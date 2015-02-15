require 'lcd'

module RaspberryPiControlPanel
  describe Lcd do
    before(:example) { allow(Adafruit::LCD::Char16x2).to receive(:new).and_return(instance_double(Adafruit::LCD::Char16x2)) }

    subject { Lcd.instance }

    it 'uses Adafruit::LCD::Char16x2' do
      expect(Adafruit::LCD::Char16x2).to receive(:new)
      subject
    end

    context 'when run as main' do
      it 'initializes correctly' do
        `ruby lib/lcd.rb`
      end
    end
  end
end
