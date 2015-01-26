require_relative '../raspi-adafruit-ruby/lib/lcd/char16x2'
require_relative 'email'

module RaspberryPiControlPanel
  # Delegate for LCD State Machine to control the Adafruit LCD
  class LcdDisplay
    private

    def initialize(lcd)
      @lcd = lcd
      display "-----Hello!-----\n+++I'm Alive!+++"
      Kernel.sleep 5
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
      when :off
        @lcd.backlight Adafruit::LCD::Char16x2::OFF
      when :on
        @lcd.backlight Adafruit::LCD::Char16x2::ON
      end
    end

    def yield_self_optionally_and_return(&block)
      instance_eval(&block) if block_given?
      self
    end

    public

    def turn_display_off
      @lcd.clear
      change_lcd_background_color_to :off
      yield_self_optionally_and_return
    end

    def display(text)
      @lcd.clear
      @lcd.message text
      yield_self_optionally_and_return
    end

    def display_and_block_for_seven_seconds(text)
      display text
      Kernel.sleep 7
      yield_self_optionally_and_return
    end

    def with_red_background
      change_lcd_background_color_to :red
      yield_self_optionally_and_return
    end

    def with_green_background
      change_lcd_background_color_to :green
      yield_self_optionally_and_return
    end

    def with_blue_background
      change_lcd_background_color_to :blue
      yield_self_optionally_and_return
    end

    def terminate
      turn_display_off
      @lcd.stop
      yield_self_optionally_and_return
    end
  end
end
