# frozen_string_literal: true

require 'spec_helper'
require 'email'

module RaspberryPiControlPanel
  # rubocop:disable Metrics/BlockLength
  describe Email do
    # rubocop:enable Metrics/BlockLength
    let(:mail_double) { double }
    # rubocop:disable Metrics/BlockLength
    describe 'initialize' do
      # rubocop:enable Metrics/BlockLength
      before do
        allow(Base64).to receive(:decode64)
        allow(Mail).to receive(:defaults) do |&block|
          mail_double.instance_eval(&block)
        end
        ENV.clear
      end

      after { subject }

      it 'uses smtp delivery method' do
        expect(mail_double).to receive(:delivery_method).with(:smtp, any_args)
      end

      it 'uses smtp address from environment variable SMTP_ADDRESS' do
        ENV['SMTP_ADDRESS'] = 'smtp.address'
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(address: ENV['SMTP_ADDRESS']))
      end

      it 'uses smtp port from environment variable SMTP_PORT' do
        ENV['SMTP_PORT'] = '1234'
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(port: ENV['SMTP_PORT']))
      end

      it 'uses smtp user name from environment variable SMTP_USER_NAME' do
        ENV['SMTP_USER_NAME'] = 'username'
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(user_name: ENV['SMTP_USER_NAME']))
      end

      it 'uses smtp password from environment variable SMTP_PASSWORD' do
        ENV['SMTP_PASSWORD'] = Base64.encode64('password')
        expect(Base64).to receive(:decode64).with(ENV['SMTP_PASSWORD'])
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(password: Base64.decode64(ENV['SMTP_PASSWORD'])))
      end

      it 'uses plain authentication' do
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(authentication: :plain))
      end

      it 'uses tls for authentication' do
        expect(mail_double).to receive(:delivery_method).with(:smtp, hash_including(enable_starttls_auto: true))
      end
    end

    # rubocop:disable Metrics/BlockLength
    describe 'deliver' do
      # rubocop:enable Metrics/BlockLength
      before do
        allow(Mail).to receive(:defaults)
        allow(Mail).to receive(:new) do |&block|
          mail_double.instance_eval(&block)
        end.and_return(mail_double)
        %i[from to body subject].each { |method_name| allow(mail_double).to receive(method_name) }
        allow(mail_double).to receive(:deliver!)
        ENV.clear
      end

      it 'uses from email address to send the email address from' do
        ENV['FROM_EMAIL_ADDRESS'] = 'from@email.com'
        expect(mail_double).to receive(:from).with(ENV['FROM_EMAIL_ADDRESS'])
        subject.deliver('', '', '')
      end

      it 'uses to email address to send the email to' do
        to_email = 'hello@world.com'
        expect(mail_double).to receive(:to).with(to_email)
        subject.deliver(to_email, '', '')
      end

      it 'uses email subject for the email' do
        email_subject = 'Subject'
        expect(mail_double).to receive(:subject).with(email_subject)
        subject.deliver('', email_subject, '')
      end

      it 'uses email body for the body fo the email' do
        email_body = 'Body'
        expect(mail_double).to receive(:body).with(email_body)
        subject.deliver('', '', email_body)
      end
    end
  end
end
