require_relative '../raspi-adafruit-ruby/lib/lcd/char16x2'
require_relative 'lcd_display'
require_relative 'lcd_state_machine'
require_relative 'email'
require_relative 'dotenv_loader'
require_relative 'logger'
require_relative 'state_machine_actions'
require_relative 'display_strings'
require_relative 'system_commands'

# Raspberry PI Control Panel Module using Adafruit LCD to control different
module RaspberryPiControlPanel
  # Delegates functionality to other classes based on button presses
  class LcdButtons
    def initialize(lcd, logger)
      @lcd = lcd
      @logger = logger
    end
    # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
    def monitor_buttons(lcd_state_machine)
      @logger.debug 'Monitoring button presses'
      until (lcd_state_machine.state == 'terminating')
        case
        when (@lcd.button_pressed Adafruit::LCD::Char16x2::SELECT)
          @logger.debug 'SELECT pressed'
          lcd_state_machine.select_button_pressed
        when (@lcd.button_pressed Adafruit::LCD::Char16x2::LEFT)
          @logger.debug 'LEFT pressed'
          lcd_state_machine.left_button_pressed
        when (@lcd.button_pressed Adafruit::LCD::Char16x2::RIGHT)
          @logger.debug 'RIGHT pressed'
          lcd_state_machine.right_button_pressed
        when (@lcd.button_pressed Adafruit::LCD::Char16x2::UP)
          @logger.debug 'UP pressed'
        when (@lcd.button_pressed Adafruit::LCD::Char16x2::DOWN)
          @logger.debug 'DOWN pressed'
          lcd_state_machine.down_button_pressed
        end
        sleep 0.1
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
  end

  if __FILE__ == $PROGRAM_NAME
    Logger.configure_logging
    lcd_logger = Logging.logger['Adafruit::LCD::Char16x2']

    lcd_logger.debug '********** Starting Up **********'
    DotenvLoader.new('.env')
    lcd = Adafruit::LCD::Char16x2.new
    lcd_display = LcdDisplay.new(lcd)
    system_commands = SystemCommands.new
    display_strings = DisplayStringsMap.read_from_yaml_file
    state_machine_actions = StateMachineActions.new(Email.new, lcd_display, system_commands, display_strings)
    lcd_state_machine = LcdStateMachine.new(state_machine_actions, Logging.logger['LcdStateMachine'])
    lcd_buttons = LcdButtons.new(lcd, Logging.logger['LcdButtons'])
    lcd_buttons.monitor_buttons(lcd_state_machine)
  end
end
