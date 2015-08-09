require 'spec_helper'
require 'lcd_display'

module RaspberryPiControlPanel
  describe LcdDisplay do
    describe 'using mock lcd and email client' do
      let(:lcd) { instance_double(Adafruit::LCD::Char16x2) }

      subject { LcdDisplay.new lcd }

      let(:subject_has_initialized) do
        %i(clear backlight).each do |method|
          allow(lcd).to receive(method)
        end
        subject
      end

      it 'upon intializing turns the lcd display off' do
        expect(lcd).to receive(:clear)
        expect(lcd).to receive(:backlight).with(Adafruit::LCD::Char16x2::OFF)
        subject
      end

      it 'changes lcd background color to red' do
        expect(lcd).to receive(:backlight).with(Adafruit::LCD::Char16x2::RED)
        subject_has_initialized.with_red_background
      end

      it 'changes lcd background color to green' do
        expect(lcd).to receive(:backlight).with(Adafruit::LCD::Char16x2::GREEN)
        subject_has_initialized.with_green_background
      end

      it 'changes lcd background color to blue' do
        expect(lcd).to receive(:backlight).with(Adafruit::LCD::Char16x2::BLUE)
        subject_has_initialized.with_blue_background
      end

      it 'displays text on the lcd' do
        text = 'text'
        expect(lcd).to receive(:clear)
        expect(lcd).to receive(:message).with(text)
        subject_has_initialized.display text
      end

      it 'displays text and blocks for seven seconds' do
        allow(Kernel).to receive(:sleep)
        text = 'text'
        expect(lcd).to receive(:clear)
        expect(lcd).to receive(:message).with(text)
        expect(Kernel).to receive(:sleep).with(7)
        subject_has_initialized.display_and_block_for_seven_seconds text
      end

      it 'terminates the lcd after turning it off' do
        expect(lcd).to receive(:clear)
        expect(lcd).to receive(:backlight).with(Adafruit::LCD::Char16x2::OFF)
        expect(lcd).to receive(:stop)
        subject_has_initialized.terminate
      end
    end
  end
end
