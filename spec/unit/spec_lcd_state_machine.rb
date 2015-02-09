require 'spec_helper'
require 'lcd_state_machine'

module RaspberryPiControlPanel
  describe LcdStateMachine do
    all_buttons = %w(right left select down).map! { |element| "#{element}_button_pressed".to_sym }
    all_buttons_except_right_and_down = all_buttons - %i(right_button_pressed down_button_pressed)

    before(:example) do
      allow(Logging).to receive(:logger).and_return(logger)
      state_machine_actions
    end

    let(:logger) do
      double(Logging::Logger).tap do |logger|
        allow(logger).to receive('[]').with('LcdStateMachine').and_return(logger)
      end
    end

    let(:state_machine_actions) do
      instance_double(StateMachineActions).tap do |state_machine_actions|
        %i(
          display_update_pi_question
          turn_display_off
          display_update_status
          display_terminate_question
          display_terminating_and_terminate
        ).each { |method| allow(state_machine_actions).to receive(method) }
        allow(StateMachineActions).to receive(:new).and_return(state_machine_actions)
      end
    end

    let(:available_events) { subject.state_transitions.map(&:event) }

    let(:to_states) { subject.state_transitions.map(&:to_name).uniq }

    let(:subject_in_sleep_state) do
      # state_machine_actions
      LcdStateMachine.new double('lcd')
    end

    let(:subject_in_update_pi_state) do
      allow(logger).to receive(:debug)
      subject_in_sleep_state.clone.tap(&:right_button_pressed)
    end

    let(:subject_in_terminate_state) do
      allow(logger).to receive(:debug)
      subject_in_sleep_state.clone.tap(&:down_button_pressed)
    end

    context 'when in sleep state' do
      subject { subject_in_sleep_state }

      it 'can transition to update pi or terminate state' do
        expect(to_states).to match_array %i(update_pi terminate)
      end

      all_buttons_except_right_and_down.each do |button|
        button_text = button.to_s.split('_').first

        it "remains in sleep state due to #{button_text} button press" do
          subject.send button
          expect(subject.state).to eq(:sleep)
        end
      end

      it 'displays update pi question after transitioning to update pi state due to right button press' do
        expect(state_machine_actions).to receive(:display_update_pi_question)
        expect(logger).to receive(:debug).with('After transition EVENT: right_button_pressed FROM: sleep TO: update_pi')
        subject.right_button_pressed
        expect(subject.state).to eq(:update_pi)
      end

      it 'displays terminate question after transitioning to terminate state due to down button press' do
        expect(state_machine_actions).to receive(:display_terminate_question)
        expect(logger).to receive(:debug).with('After transition EVENT: down_button_pressed FROM: sleep TO: terminate')
        subject.down_button_pressed
        expect(subject.state).to eq(:terminate)
      end
    end

    context 'when in update pi state' do
      subject { subject_in_update_pi_state }

      it 'can transition to sleep or download updates states' do
        expect(to_states).to match_array %i(sleep download_updates)
      end

      it 'can transition using left or select buttons only' do
        expect(available_events).to match_array [:select_button_pressed, :left_button_pressed]
      end

      it 'display is turned off after transitioning to sleep state due to left button press' do
        expect(state_machine_actions).to receive(:turn_display_off)
        subject.left_button_pressed
        expect(subject.state).to eq(:sleep)
      end

      it 'displays updating pi and after updating pi transitions to sleep state' do
        expect(state_machine_actions).to receive(:display_update_status)
        subject.select_button_pressed
        expect(subject.state).to eq(:sleep)
      end
    end

    context 'when in terminate state' do
      subject { subject_in_terminate_state }

      it 'can transition to sleep state' do
        expect(to_states).to match_array %i(sleep terminating)
      end

      it 'display is turned off after transitioning to sleep state due to left button press' do
        expect(state_machine_actions).to receive(:turn_display_off)
        subject.left_button_pressed
        expect(subject.state).to eq(:sleep)
      end

      it 'displays terminating message on select button press' do
        expect(state_machine_actions).to receive(:display_terminating_and_terminate)
        subject.select_button_pressed
        expect(subject.state).to eq(:terminating)
      end
    end
  end
end
