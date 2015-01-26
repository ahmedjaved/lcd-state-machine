require 'simplecov'
require 'rspec/core'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/raspi-adafruit-ruby/'
end

require 'dotenv_loader'
require 'lcd_display'
require 'lcd_state_machine'
require 'email'
require 'lcd_buttons'
require 'display_strings'
require 'system_commands'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  # require "fuubar"
  # config.formatter = ["Fuubar", :documentation]
  config.formatter = :documentation
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
