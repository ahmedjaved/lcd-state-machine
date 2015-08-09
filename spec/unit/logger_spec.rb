require 'spec_helper'
require 'logger'

module RaspberryPiControlPanel
  describe Logger do
    Logger.configure_logging

    let :appender_names do
      Logging.logger.root.appenders.map(&:name)
    end

    it 'should use debug level' do
      expect(Logging.logger.root.debug?).to eq true
    end

    it 'should log to standard output' do
      expect(appender_names).to include 'stdout'
    end

    it 'should log to standard output' do
      expect(appender_names).to include "log-#{Time.now.strftime '%Y%m%d'}.log"
    end

    log_file_name = "log-#{Time.now.strftime '%Y%m%d'}.log"
    it "should log to a file named #{log_file_name}" do
      expect(appender_names).to include log_file_name
    end

    Logging.logger.root.appenders.each do |appender|
      context "logging pattern for #{appender.name}" do
        it 'should start with date' do
          expect(appender.layout.pattern).to start_with '[%d]'
        end

        it 'should display name of the class using right justified with spaces padded to the left after date' do
          expect(appender.layout.pattern.split[1]).to start_with '%23.23c'
        end

        it 'should display debug level up to 5 characters after class name' do
          expect(appender.layout.pattern.split[2]).to start_with '%-5l:'
        end

        it 'should end with log from the application and a newline' do
          expect(appender.layout.pattern).to end_with '%m\n'
        end
      end
    end
  end
end
