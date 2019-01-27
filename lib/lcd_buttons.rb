# frozen_string_literal: true

require_relative '../raspi-adafruit-ruby/lib/lcd/char16x2'
require_relative 'lcd_state_machine'
require_relative 'logger'
require_relative 'lcd'

# Raspberry PI Control Panel Module using Adafruit LCD
module RaspberryPiControlPanel
  # Delegates functionality to other classes based on button presses
  class LcdButtons
    include Singleton
    BUTTONS = %w[select down left right].freeze

    def monitor_buttons
      @logger.debug 'Monitoring buttons'
      until @lcd_state_machine.state == :terminating
        button_pressed = which_button_was_pressed?
        if button_pressed
          @logger.debug "#{button_pressed} button pressed"
          @lcd_state_machine.send("#{button_pressed}_button_pressed")
        end
        sleep 0.1
      end
    end

    protected

    def initialize
      @lcd_state_machine = LcdStateMachine.instance
      @lcd = Lcd.instance
      @logger = Logging.logger['LcdButtons']
    end

    def which_button_was_pressed?
      BUTTONS.each do |button|
        return button.to_sym if send("#{button}_button_pressed?")
      end
      nil
    end

    def method_missing(method_name, *args)
      match = method_name.to_s.match(/(#{BUTTONS.join('|')})_button_pressed\?$/)
      if match
        self.class.class_eval do
          constant_name = method_name.to_s.sub('_button_pressed?', '').upcase
          define_method(method_name) do
            @lcd.button_pressed Adafruit::LCD::Char16x2.const_get(constant_name.to_s)
          end
        end
        send(method_name)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.match(/(#{BUTTONS.join('|')})_button_pressed\?$/) || super
    end
  end
end
