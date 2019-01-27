# frozen_string_literal: true

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
      @display_strings = DisplayStringsMap.instance
    end

    def install_updates
      if system @system_commands.install_software_updates.to_s
        email_body = @display_strings.software_updates_installation_successful
        email_body << if system @system_commands.install_kernel_updates.to_s
                        @display_strings.kernel_updates_installation_successful
                      else
                        @display_strings.kernel_updates_installation_failed
                      end
      else
        email_body = @display_strings.software_updates_installation_failed
      end
      email_body
    end

    public

    def display_startup_message
      @lcd_display.with_green_background
                  .display_and_block_for_seven_seconds(@display_strings.startup)
                  .turn_display_off
    end

    def display_update_pi_question(_transition)
      @lcd_display.with_blue_background.display @display_strings.update_pi_question
    end

    def turn_display_off(_transition)
      @lcd_display.turn_display_off
    end

    def display_update_status(_transition)
      @lcd_display.with_red_background.display @display_strings.update_pi_progress
      @email_client.deliver ENV['FROM_EMAIL_ADDRESS'], @display_strings.update_pi_email_subject, install_updates
      @lcd_display.with_green_background.display_and_block_for_seven_seconds @display_strings.update_pi_complete
    end

    def display_terminate_question(_transition)
      @lcd_display.with_red_background.display @display_strings.terminate_question
    end

    def display_terminating_and_terminate(_transition)
      @lcd_display.display_and_block_for_seven_seconds @display_strings.terminate
      @lcd_display.terminate
    end
  end
end
