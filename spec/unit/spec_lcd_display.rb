require 'spec_helper'

module RaspberryPiControlPanel
  describe LcdDisplay do
    describe 'using mock lcd and email client' do
      let(:lcd) do
        instance_double('Adafruit::LCD::Char16x2').tap do |lcd|
          %i(
            clear
            message
            backlight
          ).each do |method|
            allow(lcd).to receive(method) { true }
          end
        end
      end

      subject { LcdDisplay.new lcd }

      it 'initializes without exception' do
        expect { subject }.to_not raise_error
      end
    end
  end
end
