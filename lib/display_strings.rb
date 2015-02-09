require 'yaml'
require 'ostruct'
require 'delegate'

module RaspberryPiControlPanel
  # stores all of the actions performed due to an option selected on the lcd display
  class DisplayStringsMap < SimpleDelegator
    include Singleton

    private

    def initialize
      super self.class.read_from_yaml_file
    end

    def self.read_from_yaml_file
      @display_strings_hash ||= YAML.load_file File.join(__dir__, 'display_strings.yml')
      @os ||= OpenStruct.new(@display_strings_hash)
    end
  end
end
