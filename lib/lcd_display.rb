require_relative '../raspi-adafruit-ruby/lib/lcd/char16x2'
require_relative 'email'

module RaspberryPiControlPanel
  # Delegate for LCD State Machine to control the Adafruit LCD
  class LcdDisplay
    private

    def initialize(lcd)
      @lcd = lcd
      turn_display_off
    end

    def change_lcd_background_color_to(color)
      case color
      when :red
        @lcd.backlight Adafruit::LCD::Char16x2::RED
      when :green
        @lcd.backlight Adafruit::LCD::Char16x2::GREEN
      when :blue
        @lcd.backlight Adafruit::LCD::Char16x2::BLUE
      end
    end

    public

    def turn_display_off
      @lcd.clear
      @lcd.backlight Adafruit::LCD::Char16x2::OFF
      self
    end

    def display(text)
      @lcd.clear
      @lcd.message text
      self
    end

    def display_and_block_for_seven_seconds(text)
      display text
      Kernel.sleep 7
      self
    end

    def with_red_background
      change_lcd_background_color_to :red
      self
    end

    def with_green_background
      change_lcd_background_color_to :green
      self
    end

    def with_blue_background
      change_lcd_background_color_to :blue
      self
    end

    def terminate
      turn_display_off
      @lcd.stop
      self
    end
  end
end
