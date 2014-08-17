require 'dotenv'
Dotenv.load

require_relative "../raspi-adafruit-ruby/lib/lcd/char16x2"
require_relative "lcd_control_panel"
require_relative 'email'

module Adafruit
  module LCD
    class Char16x2

      def display_press_right_button_message
        clear_display
        change_lcd_background_color_to :blue
        display "press right butt\non"
      end

      def turn_display_off
        clear_display
        change_lcd_background_color_to :off
      end

      def terminate
        clear_display
        display "-----ByeBye-----\n+++See U l8r!+++"
        sleepFiveSeconds
        clear_display
        change_lcd_background_color_to :off
        abort
      end

      def display_update_pi_question
        clear_display
        display 'update pi?'
      end

      def update_operating_system_software_on_pi
        clear_display

        change_lcd_background_color_to :red

        display "updating!"
        `sudo apt-get update 2>&1 |tee apt-get_update_output.log`
        email_body =  "**** apt-get update START****\n"
        email_body << `cat apt-get_update_output.log` +"\n"
        email_body <<  "**** apt-get update END****\n"
        email_body <<  "\n"
        email_body <<  "**** apt-get upgrade START****\n"
        `sudo apt-get upgrade -y 2>&1 |tee apt-get_upgrade_output.log`
        email_body << `cat apt-get_upgrade_output.log` + "\n"
        email_body <<  "**** apt-get upgrade END****\n"

        mail = Mail.new do
          from 'ahmed.javed@gmail.com'
          to 'ahmed.javed@gmail.com'
          subject 'Raspi Update Run'
          body email_body 
        end
        mail.deliver!    
        change_lcd_background_color_to :green
        clear_display
        display "done!"
        Kernel::sleep(3)
      end

      def change_lcd_background_color_to color
        case color
          when :red
            backlight Adafruit::LCD::Char16x2::RED
          when :green
            backlight Adafruit::LCD::Char16x2::GREEN
          when :blue
            backlight Adafruit::LCD::Char16x2::BLUE  
          when :off
            backlight Adafruit::LCD::Char16x2::OFF
          when :on
            backlight Adafruit::LCD::Char16x2::ON
        end    
      end

      def clear_display
          clear
      end

      def display text
        message text
      end

      def sleepFiveSeconds
        Kernel::sleep 5
      end

      def displayStartupText
        clear_display
        display "-----Hello!-----\n+++I'm Alive!+++"
        sleepFiveSeconds
      end      
    end
  end
end


Adafruit::LCD::Char16x2.new do |lcd|
    lcd_control_panel = LcdControlPanel.new(lcd)
    while true
      buttons = lcd.buttons
      case
      when (buttons >> Adafruit::LCD::Char16x2::SELECT) & 1 > 0
        puts "SELECT pressed"
        lcd_control_panel.select_button_pressed
      when (buttons >> Adafruit::LCD::Char16x2::LEFT) & 1 > 0
        puts "LEFT pressed"
        lcd_control_panel.left_button_pressed
      when (buttons >> Adafruit::LCD::Char16x2::RIGHT) & 1 > 0
        puts "RIGHT pressed"
        lcd_control_panel.right_button_pressed
      when (buttons >> Adafruit::LCD::Char16x2::UP) & 1 > 0
        puts "UP pressed"
        lcd_control_panel.up_button_pressed
      when (buttons >> Adafruit::LCD::Char16x2::DOWN) & 1 > 0
        puts "DOWN pressed"
        lcd_control_panel.down_button_pressed
      end
      sleep 0.1
    end
    lcd.clear
    lcd.stop
end