# frozen_string_literal: true

require 'yaml'
require 'ostruct'
require 'delegate'

module RaspberryPiControlPanel
  # Strings that are displayed on the lcd panel
  class DisplayStringsMap < SimpleDelegator
    include Singleton

    def initialize
      super self.class.read_from_yaml_file
    end

    def self.read_from_yaml_file
      @display_strings_hash ||= YAML.load_file File.join(__dir__, 'display_strings.yml')
      @read_from_yaml_file ||= OpenStruct.new(@display_strings_hash)
    end
  end
end
