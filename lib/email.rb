require 'mail'
require 'base64'

Mail.defaults do
  delivery_method :smtp, { 
    :address =>  ENV['LCD_EMAIL_ADDRESS'],
    :port =>  ENV['LCD_EMAIL_PORT'],
    :user_name => ENV['LCD_EMAIL_USER_NAME'],
    :password => Base64.decode64(ENV['LCD_EMAIL_PASSWORD']),
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
