# frozen_string_literal: true

require_relative '../raspi-adafruit-ruby/lib/lcd/char16x2'
require 'dotenv'
require_relative 'logger'
require_relative 'lcd_buttons'

# Raspberry PI Control Panel Module using Adafruit LCD to control different
module RaspberryPiControlPanel
  # Delegates functionality to other classes based on button presses
  class Lcd < SimpleDelegator
    include Singleton

    def initialize
      super Adafruit::LCD::Char16x2.new
    end

    def self.run
      Dotenv.load!
      Logger.configure_logging
      lcd_logger = Logging.logger['main']
      lcd_logger.debug '********** Starting Up **********'
      LcdButtons.instance.monitor_buttons
      lcd_logger.debug '********** Shutting Down **********'
    end
  end
  Lcd.run if $PROGRAM_NAME == __FILE__
end
