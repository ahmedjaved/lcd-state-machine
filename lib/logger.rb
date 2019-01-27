# frozen_string_literal: true

require 'logging'

module RaspberryPiControlPanel
  # Logfile configuration class
  class Logger
    def self.configure_logging
      Logging.logger.root.level = :debug

      logger_args = { layout: Logging.layouts.pattern(pattern: '[%d] %23.23c %-5l: %m\n') }

      standard_out_appender = Logging.appenders.stdout logger_args

      file_appender = Logging.appenders.file "log-#{Time.now.strftime '%Y%m%d'}.log", logger_args

      Logging.logger.root.add_appenders standard_out_appender, file_appender
    end
  end
end
