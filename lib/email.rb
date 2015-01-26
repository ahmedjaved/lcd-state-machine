require 'mail'
require 'base64'

module RaspberryPiControlPanel
  # An email client
  class Email
    private

    def initialize
      Mail.defaults do
        delivery_method :smtp,
                        address: ENV['SMTP_ADDRESS'],
                        port: ENV['SMTP_PORT'],
                        user_name: ENV['SMTP_USER_NAME'],
                        password: Base64.decode64(ENV['SMTP_PASSWORD']),
                        authentication: :plain,
                        enable_starttls_auto: true
      end
    end

    public

    def deliver(to_email, email_subject, email_body)
      Mail.new do
        from ENV['FROM_EMAIL_ADDRESS']
        to to_email
        body email_body
        subject email_subject
      end.deliver!
    end
  end
end
