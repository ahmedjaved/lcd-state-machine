require 'spec_helper'
require 'lcd_buttons'

module RaspberryPiControlPanel
  describe LcdButtons, :include_lcd_buttons_helper do
    before(:example) do
      allow(LcdStateMachine).to receive(:instance).and_return(lcd_state_machine)
      allow(Logging).to receive(:logger).and_return(logger)
      allow(Lcd).to receive(:instance).and_return(lcd)
    end

    subject { LcdButtons.send :new }

    let(:logger) do
      double(Logging::Logger).tap do |logger|
        allow(logger).to receive('[]').with('LcdButtons').and_return(logger)
      end
    end

    let(:lcd_state_machine) { instance_double LcdStateMachine }

    let!(:lcd) do
      instance_double(Adafruit::LCD::Char16x2).tap do |lcd|
        RaspberryPiControlPanel::LcdButtons::BUTTONS.each do |button|
          allow(lcd).to receive(:button_pressed).with(get_lcd_button_constant button).and_return(false)
        end
      end
    end

    RaspberryPiControlPanel::LcdButtonsSpecHelper::BUTTON_SYMBOLS.each do |button|
      context "##{button}_button_pressed?" do
        let(:method_name) { (button.to_s + '_button_pressed?').to_sym }

        let(:lcd_constant) { get_lcd_button_constant button }

        it 'returns truthy value when pressed' do
          allow(lcd).to receive(:button_pressed).with(lcd_constant).and_return(true)
          expect(subject.send method_name).to be_truthy
        end

        it 'returns falsy value when not pressed' do
          allow(lcd).to receive(:button_pressed).with(lcd_constant).and_return(false)
          expect(subject.send method_name).to be_falsy
        end
      end
    end

    it 'raises error when a method is not found' do
      expect { subject.bogus }.to raise_error(NoMethodError)
    end

    context '#which_button_was_pressed?' do
      RaspberryPiControlPanel::LcdButtonsSpecHelper::BUTTON_SYMBOLS.each do |button|
        it "returns :#{button} when #{button} button is pressed" do
          allow(lcd).to receive(:button_pressed).with(get_lcd_button_constant button).and_return(true)
          expect(subject.send :which_button_was_pressed?).to eq(button)
        end
      end

      it 'returns nil when no button is pressed' do
        expect(subject.send :which_button_was_pressed?).to be nil
      end
    end

    context '#monitor_buttons' do
      it 'stops monitoring when lcd state machine reaches :terminating state' do
        allow(lcd_state_machine).to receive(:state).and_return(:terminating)
        expect(logger).to receive(:debug).once.ordered.with('Monitoring buttons')
        subject.monitor_buttons
      end

      it 'calls lcd state machine when select button is pressed' do
        expect(lcd).to receive(:button_pressed).and_return(true)

        allow(lcd_state_machine).to receive(:state).and_return(:terminate, :terminating)
        expect(lcd_state_machine).to receive(:select_button_pressed)

        expect(logger).to receive(:debug).once.ordered.with('Monitoring buttons')
        expect(logger).to receive(:debug).once.ordered.with('select button pressed')

        subject.monitor_buttons
      end
    end
  end
end
