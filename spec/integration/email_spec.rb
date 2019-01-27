# frozen_string_literal: true

require 'spec_helper'
require 'email'
require 'dotenv'

module RaspberryPiControlPanel
  env_file = '.env'
  describe Email do
    context "given #{env_file} file is present" do
      before(:all) do
        Dotenv.load! env_file
        raise "#{env_file} is needed to test this spec" unless File.exist?(env_file)
      end

      it 'when Email is initilaized then no exception is raised' do
        expect { subject }.to_not raise_error
      end

      it 'when deliever is used to send email then no execption is raised' do
        text = 'rspec test email'
        expect { subject.deliver(ENV['SMTP_USER_NAME'], "#{text} subject", "#{text} body") }.to_not raise_error
      end
    end
  end
end
