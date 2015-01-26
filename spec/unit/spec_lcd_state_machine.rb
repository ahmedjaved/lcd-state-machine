require 'spec_helper'

module RaspberryPiControlPanel
  describe LcdStateMachine do
    all_buttons = %w(right left select down).map! { |element| "#{element}_button_pressed".to_sym }
    all_buttons_except_right_and_down = all_buttons - %i(right_button_pressed down_button_pressed)

    let(:logger) do
      instance_double('Logger').as_null_object
    end

    let(:state_machine_actions) do
      # allow(state_machine_actions).to receive(:update_pi)
      instance_double('StateMachineActions').tap do |state_machine_actions|
        %i(
          display_update_pi_question
          turn_display_off
          display_update_status
          display_terminate_question
          display_terminating_and_terminate
        ).each { |method| allow(state_machine_actions).to receive(method) }
      end
    end

    let(:available_events) { subject.state_transitions.map(&:event) }

    let(:to_states) { subject.state_transitions.map(&:to_name).uniq }

    let(:subject_in_sleep_state) { LcdStateMachine.new state_machine_actions, logger }

    let(:subject_in_update_pi_state) do
      subject_in_sleep_state.clone.tap(&:right_button_pressed)
    end

    let(:subject_in_terminate_state) do
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
          expect(subject.state).to eq('sleep')
        end
      end

      it 'displays update pi question after transitioning to update pi state due to right button press' do
        expect(state_machine_actions).to receive(:display_update_pi_question)
        subject.right_button_pressed
        expect(subject.state).to eq('update_pi')
      end

      it 'displays terminate question after transitioning to terminate state due to down button press' do
        expect(state_machine_actions).to receive(:display_terminate_question)
        subject.down_button_pressed
        expect(subject.state).to eq('terminate')
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
        expect(subject.state).to eq('sleep')
      end

      it 'displays updating pi and after updating pi transitions to sleep state' do
        expect(state_machine_actions).to receive(:display_update_status)
        subject.select_button_pressed
        expect(subject.state).to eq('sleep')
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
        expect(subject.state).to eq('sleep')
      end

      it 'displays terminating message on select button press' do
        expect(state_machine_actions).to receive(:display_terminating_and_terminate)
        subject.select_button_pressed
        expect(subject.state).to eq('terminating')
      end
    end
  end
end
