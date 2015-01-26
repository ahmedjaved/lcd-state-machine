module RaspberryPiControlPanel
  # stores all of the actions performed due to an option selected on the lcd display
  class StateMachineActions
    def initialize(email_client, lcd_display, system_commands, display_strings)
      @email_client = email_client
      @lcd_display = lcd_display
      @system_commands = system_commands
      @display_strings = display_strings
    end

    def display_update_pi_question(_)
      @lcd_display.with_blue_background.display 'update pi?'
    end

    def turn_display_off(_)
      @lcd_display.turn_display_off
    end

    def display_update_status(_)
      @lcd_display.with_red_background.display 'updating!'
      email_body = @system_commands.update_system
      @email_client.deliver ENV['FROM_EMAIL_ADDRESS'], @display_strings.update_pi_email_subject, email_body
      @lcd_display.with_green_background.display_and_block_for_seven_seconds 'done!'
    end

    def display_terminate_question(_)
      @lcd_display.with_red_background.display 'terminate?'
    end

    def display_terminating_and_terminate(_)
      @lcd_display.display_and_block_for_seven_seconds "-----ByeBye-----\n+++See U l8r!+++"
      @lcd_display.terminate
    end
  end
end
