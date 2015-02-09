require 'spec_helper'
require 'lcd_buttons'

module RaspberryPiControlPanel
  describe LcdButtons, :include_lcd_buttons_helper do
    before(:example) do
      allow(LcdStateMachine).to receive(:new).and_return(lcd_state_machine)
      allow(Logging).to receive(:logger).and_return(logger)
    end

    subject { LcdButtons.new lcd }

    let(:logger) do
      double(Logging::Logger).tap do |logger|
        allow(logger).to receive('[]').with('LcdButtons').and_return(logger)
      end
    end

    let(:lcd_state_machine) { instance_double(LcdStateMachine) }

    let!(:lcd) do
      instance_double(Adafruit::LCD::Char16x2).tap do |lcd|
        RaspberryPiControlPanel::LcdButtons::BUTTONS.each do |button|
          allow(lcd).to receive(:button_pressed).with(get_lcd_button_constant(button)).and_return(false)
        end
      end
    end

    RaspberryPiControlPanel::LcdButtonsSpecHelper::BUTTON_SYMBOLS.each do |button|
      context "#{button} button" do
        let(:method_name) { (button.to_s + '_button_pressed?').to_sym }

        let(:lcd_constant) { get_lcd_button_constant button }

        it 'returns truthy value when pressed' do
          allow(lcd).to receive(:button_pressed).with(lcd_constant).and_return(true)
          expect(subject.send(method_name)).to be_truthy
        end

        it 'returns falsy value when not pressed' do
          allow(lcd).to receive(:button_pressed).with(lcd_constant).and_return(false)
          expect(subject.send(method_name)).to be_falsy
        end
      end
    end

    it 'raises error when a method is not found' do
      expect { subject.bogus }.to raise_error
    end

    context 'button press determination' do
      RaspberryPiControlPanel::LcdButtonsSpecHelper::BUTTON_SYMBOLS.each do |button|
        it "returns :#{button} when #{button} button is pressed" do
          allow(lcd).to receive(:button_pressed).with(get_lcd_button_constant(button)).and_return(true)
          expect(subject.which_button_was_pressed?).to eq(button)
        end
      end

      it 'returns nil when no button is pressed' do
        expect(subject.which_button_was_pressed?).to be nil
      end
    end
  end
end
