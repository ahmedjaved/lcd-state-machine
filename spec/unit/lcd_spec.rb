# frozen_string_literal: true

require 'spec_helper'
require 'lcd'

module RaspberryPiControlPanel
  describe Lcd do
    it 'uses Adafruit::LCD::Char16x2' do
      expect(Adafruit::LCD::Char16x2).to receive(:new)
      Lcd.instance
    end

    context 'when run as main' do
      let(:logger) do
        double(Logging::Logger).tap do |logger|
          expect(logger).to receive('[]').with('main').and_return(logger)
          expect(logger).to receive(:debug).exactly(2).times
        end
      end

      it 'initializes correctly' do
        expect(Dotenv).to receive(:load!)
        expect(Logger).to receive(:configure_logging)
        expect(Logging).to receive(:logger).and_return(logger)
        expect(LcdButtons).to receive(:instance).and_return(double(LcdButtons).as_null_object)
        expect { Lcd.run }.to_not raise_error
      end
    end
  end
end
