require 'spec_helper'
require 'email'
require 'dotenv'

module RaspberryPiControlPanel
  env_file = '.env'
  describe Email do
    context "#{env_file} file is present" do
      before(:all) do
        Dotenv.load! env_file
        fail "#{env_file} is needed to test this spec" unless File.exist?(env_file)
      end

      it 'initializes' do
        expect { subject }.to_not raise_error
      end

      it 'delivers email' do
        text = 'rspec test email'
        expect { subject.deliver(ENV['SMTP_USER_NAME'], "#{text} subject", "#{text} body") }.to_not raise_error
      end
    end
  end
end
