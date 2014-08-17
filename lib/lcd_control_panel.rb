require 'state_machine'
require_relative 'lcd_control_panel_observer'

class LcdControlPanel
  attr_reader :lcd

  state_machine :state, :initial => :sleep do

    after_transition LcdControlPanelObserver.method(:after_transition)

    event :right_button_pressed do
      transition :home => :update_pi?
      transition :updating_pi => same
    end

    event :select_button_pressed do
      transition :update_pi? => :updating_pi
      transition :updating_pi => same
      transition :home => :sleep
      transition :sleep => :home
    end

    event :left_button_pressed do
      transition [:update_pi?, :updating_pi] => same
      transition :home => :exit
    end

    event :down_button_pressed do
      transition [:home, :update_pi?, :updating_pi] => same
    end

    event :up_button_pressed do
      transition [:home, :update_pi?, :updating_pi] => same
    end

    event :after_finishing_update do
      transition :updating_pi => :sleep
    end

    after_transition all  => :home do |lcd_control_panel|
      lcd_control_panel.lcd.display_press_right_button_message
    end

    after_transition :home => :update_pi? do |lcd_control_panel|
      lcd_control_panel.lcd.display_update_pi_question
    end

    after_transition :update_pi? => :updating_pi do |lcd_control_panel|
      lcd_control_panel.lcd.update_operating_system_software_on_pi
      lcd_control_panel.fire_events(:after_finishing_update)
    end

    after_transition :home => :sleep do |lcd_control_panel|
      lcd_control_panel.lcd.turn_display_off
    end

    after_transition :sleep => :home do |lcd_control_panel|
      lcd_control_panel.lcd.display_press_right_button_message
    end    

    after_transition :home => :exit do |lcd_control_panel|
      lcd_control_panel.lcd.terminate
    end

    after_transition :updating_pi => :sleep do |lcd_control_panel|
      lcd_control_panel.lcd.turn_display_off
    end

          
  end

  def initialize lcd
    super() # NOTE: This *must* be called, otherwise states won't get initialized
    @lcd = lcd
    lcd.displayStartupText
    lcd.turn_display_off
  end
end

