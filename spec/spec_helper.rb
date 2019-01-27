# frozen_string_literal: true

require 'rspec/core'
# require 'simplecov'

# SimpleCov.start do
#   add_filter '/spec/'
#   add_filter '/raspi-adafruit-ruby/'
#   add_filter '/vendor/'
# end

if ENV['CI'] == 'true'
  # require 'codecov'
  # SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'lcd_buttons'
module RaspberryPiControlPanel
  module LcdButtonsSpecHelper
    BUTTON_SYMBOLS = RaspberryPiControlPanel::LcdButtons::BUTTONS.map(&:to_sym)

    def get_lcd_button_constant(button)
      Adafruit::LCD::Char16x2.const_get(button.to_s.upcase)
    end
  end
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  # require 'fuubar'
  # config.formatter = 'Fuubar'
  # config.formatter = :documentation
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    # This option should be set when all dependencies are being loaded
    # before a spec run, as is the case in a typical spec helper. It will
    # cause any verifying double instantiation for a class that does not
    # exist to raise, protecting against incorrectly spelt names.
    mocks.verify_doubled_constant_names = true
  end
  config.include RaspberryPiControlPanel::LcdButtonsSpecHelper, :include_lcd_buttons_helper
end
