require 'spec_helper'

module RaspberryPiControlPanel
  describe StateMachineActions do
    display_strings = DisplayStringsMap.read_from_yaml_file

    let(:lcd_display) do
      instance_double('LcdDisplay').tap do |lcd_display|
        %i(
          with_red_background
          with_green_background
          with_blue_background
          turn_display_off
          display
        ).each { |method| allow(lcd_display).to receive(method).and_return(lcd_display) }
      end
    end

    let(:email_client) do
      instance_double('Email')
    end

    let(:system_commands) do
      instance_double('SystemCommands')
    end

    subject { StateMachineActions.new(email_client, lcd_display, system_commands, display_strings) }

    it 'displays update pi question' do
      expect(lcd_display).to receive(:with_blue_background)
      expect(lcd_display).to receive(:display).with('update pi?')
      subject.display_update_pi_question nil
    end

    it 'displays terminate question' do
      expect(lcd_display).to receive(:with_red_background)
      expect(lcd_display).to receive(:display).with('terminate?')
      subject.display_terminate_question nil
    end

    it 'display is turned off' do
      expect(lcd_display).to receive(:turn_display_off)
      subject.turn_display_off nil
    end

    it 'displays updating pi, updates pi and displays done' do
      expect(lcd_display).to receive(:with_red_background).ordered
      expect(lcd_display).to receive(:display).with('updating!').ordered
      expect(system_commands).to receive(:update_system).ordered
      expect(email_client).to receive(:deliver).with(nil, display_strings.update_pi_email_subject, nil).ordered
      expect(lcd_display).to receive(:with_green_background).ordered
      expect(lcd_display).to receive(:display_and_block_for_seven_seconds).with('done!').ordered
      subject.display_update_status nil
    end

    it 'displays terminating message' do
      expect(lcd_display).to receive(:display_and_block_for_seven_seconds).with("-----ByeBye-----\n+++See U l8r!+++")
      expect(lcd_display).to receive(:terminate)
      subject.display_terminating_and_terminate nil
    end
  end
end
