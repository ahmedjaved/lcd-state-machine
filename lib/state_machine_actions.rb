require_relative 'email'
require_relative 'lcd_display'
require_relative 'system_commands'
require_relative 'display_strings'

module RaspberryPiControlPanel
  # stores all of the actions performed due to an option selected on the lcd display
  class StateMachineActions
    include Singleton

    private

    def initialize
      @email_client = Email.new
      @lcd_display = LcdDisplay.new Lcd.instance
      @system_commands = SystemCommands.new
      @display_strings =  DisplayStringsMap.instance
    end

    public

    def display_startup_message
      @lcd_display.with_green_background
        .display_and_block_for_seven_seconds(@display_strings.startup)
        .turn_display_off
    end

    def display_update_pi_question(_)
      @lcd_display.with_blue_background.display @display_strings.update_pi_question
    end

    def turn_display_off(_)
      @lcd_display.turn_display_off
    end

    def display_update_status(_)
      @lcd_display.with_red_background.display @display_strings.update_pi_progress
      email_body = @system_commands.update_system
      @email_client.deliver ENV['FROM_EMAIL_ADDRESS'], @display_strings.update_pi_email_subject, email_body
      @lcd_display.with_green_background.display_and_block_for_seven_seconds @display_strings.update_pi_complete
    end

    def display_terminate_question(_)
      @lcd_display.with_red_background.display @display_strings.terminate_question
    end

    def display_terminating_and_terminate(_)
      @lcd_display.display_and_block_for_seven_seconds @display_strings.terminate
      @lcd_display.terminate
    end
  end
end
