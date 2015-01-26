require 'dotenv'

module RaspberryPiControlPanel
  # Loads dot env files
  class DotenvLoader
    def initialize(env_file_name)
      fail DotenvLoader.dot_env_file_not_found_message(env_file_name) unless File.file?(env_file_name)
      Dotenv.load
    end

    def self.dot_env_file_not_found_message(env_file_name)
      "#{env_file_name} file not found to read configuration data"
    end
  end
end
