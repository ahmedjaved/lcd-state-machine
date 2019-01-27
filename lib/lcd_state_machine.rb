# frozen_string_literal: true

require 'state_machine'
require 'forwardable'
require_relative 'state_machine_actions'

module RaspberryPiControlPanel
  # State machine based on LCD buttons
  class LcdStateMachine
    include Singleton
    extend StateMachine::MacroMethods
    extend Forwardable

    protected

    def_delegators :@state_machine_actions, :display_update_pi_question, :turn_display_off,
                   :display_update_status, :display_terminate_question, :display_terminating_and_terminate

    def initialize
      super() # NOTE: This *must* be called, otherwise states won't get initialized
      @state_machine_actions = StateMachineActions.instance
      @state_machine_actions.display_startup_message
      @logger = Logging.logger['LcdStateMachine']
    end

    def log_transition(transition)
      @logger.debug "After transition EVENT: #{transition.event} FROM: #{transition.from} TO: #{transition.to}"
    end

    def fire_download_complete_event
      fire_events(:download_complete)
    end

    # rubocop:disable Style/HashSyntax
    state_machine :state, :initial => :sleep do
      # state machine transitions

      transition :sleep => :update_pi, :on => :right_button_pressed
      transition :sleep => :terminate, :on => :down_button_pressed

      transition :download_updates => :sleep, :on => :download_complete

      transition :update_pi => :sleep, :on => :left_button_pressed
      transition :update_pi => :download_updates, :on => :select_button_pressed

      transition :terminate => :sleep, :on => :left_button_pressed
      transition :terminate => :terminating, :on => :select_button_pressed

      # transition :update_pi => :terminate, :on => :right_button_pressed

      # actions to take place after state transitions using the :do key

      after_transition :on => all, :do => :log_transition

      after_transition :sleep => :update_pi, :do => :display_update_pi_question
      after_transition :sleep => :terminate, :do => :display_terminate_question

      after_transition :download_updates => :sleep, :terminate => :sleep, :do => :turn_display_off

      after_transition :update_pi => :sleep, :do => :turn_display_off
      after_transition :update_pi => :download_updates, :do => %i[display_update_status fire_download_complete_event]

      after_transition :terminate => :terminating, :do => :display_terminating_and_terminate
      # after_transition :update_pi => :terminate, :do => :terminate
      # rubocop:enable Style/HashSyntax

      states.each do |state|
        self.state(state.name, value: state.name.to_sym)
      end
    end
  end
end
