require 'yaml'
require 'ostruct'

module RaspberryPiControlPanel
  # stores all of the actions performed due to an option selected on the lcd display
  class DisplayStringsMap
    # TODO: check and see if open struct has been created already
    def self.read_from_yaml_file(filename = 'display_strings.yml')
      display_strings_hash = YAML.load_file File.join(__dir__, filename)
      OpenStruct.new(display_strings_hash)
    end
  end
end
