# frozen_string_literal: true

require 'spec_helper'
require 'state_machine_actions'

module RaspberryPiControlPanel
  # rubocop:disable Metrics/BlockLength
  describe StateMachineActions do
    # rubocop:enable Metrics/BlockLength
    before(:example) do
      allow(Lcd).to receive(:instance).and_return(nil)
      allow(LcdDisplay).to receive(:new).and_return(lcd_display)
      allow(Email).to receive(:new).and_return(email_client)
      allow(SystemCommands).to receive(:new).and_return(system_commands)
    end

    let(:display_strings) { DisplayStringsMap.instance }

    let(:lcd_display) do
      instance_double(LcdDisplay).tap do |lcd_display|
        %i[
          with_red_background
          with_green_background
          with_blue_background
          turn_display_off
          display
          display_and_block_for_seven_seconds
        ].each { |method| allow(lcd_display).to receive(method).and_return(lcd_display) }
      end
    end

    let(:email_client) { instance_double Email }

    let(:system_commands) { instance_double SystemCommands }

    subject { StateMachineActions.send :new }

    it 'displays update pi question' do
      expect(lcd_display).to receive(:with_blue_background)
      expect(lcd_display).to receive(:display).with(display_strings.update_pi_question)
      subject.display_update_pi_question nil
    end

    it 'displays terminate question' do
      expect(lcd_display).to receive(:with_red_background)
      expect(lcd_display).to receive(:display).with(display_strings.terminate_question)
      subject.display_terminate_question nil
    end

    it 'display is turned off' do
      expect(lcd_display).to receive(:turn_display_off)
      subject.turn_display_off nil
    end

    it 'displays updating pi, updates pi and displays done' do
      expect(lcd_display).to receive(:with_red_background).ordered
      expect(lcd_display).to receive(:display).with(display_strings.update_pi_progress).ordered
      expect(system_commands).to receive(:install_software_updates).ordered
      expect(system_commands).to receive(:install_kernel_updates).ordered
      allow(subject).to receive(:system).and_return(true, true)
      email_body = display_strings.software_updates_installation_successful + \
                   display_strings.kernel_updates_installation_successful
      expect(email_client).to receive(:deliver).with(anything, display_strings.update_pi_email_subject, email_body).ordered
      expect(lcd_display).to receive(:with_green_background).ordered
      expect(lcd_display).to receive(:display_and_block_for_seven_seconds).with(display_strings.update_pi_complete).ordered
      subject.display_update_status nil
    end

    it 'displays terminating message' do
      expect(lcd_display).to receive(:display_and_block_for_seven_seconds).with(display_strings.terminate)
      expect(lcd_display).to receive(:terminate)
      subject.display_terminating_and_terminate nil
    end

    it 'displays startup message' do
      expect(lcd_display).to receive(:with_green_background)
      expect(lcd_display).to receive(:display_and_block_for_seven_seconds).with(display_strings.startup)
      expect(lcd_display).to receive(:turn_display_off)
      subject.display_startup_message
    end
  end
end
