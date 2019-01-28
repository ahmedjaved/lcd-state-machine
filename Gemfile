# frozen_string_literal: true

source 'https://rubygems.org'

gem 'dotenv', '2.0.1'
gem 'logging', '2.0.0'
gem 'mail', '2.7.1'
gem 'state_machine', '1.2.0', require: 'state_machine/core'

group :development do
  gem 'rubocop', '0.63.1', require: false
  gem 'ruby-graphviz', '1.2.1'
  gem 'coveralls', require: false

  # gem 'guard-rspec', '4.5.0', require: false
  # gem 'guard-rubocop', '1.2.0'
  gem 'libnotify', '0.9.1'
  gem 'rb-readline', '0.5.2'
end

group :test do
  gem 'fuubar', '2.0.0'
  gem 'rake', '10.4.2'
  gem 'rspec', '3.6.0'

  # for code coverage
  gem 'simplecov', '0.16.1', require: false

  # for raspi-adafruit-ruby
  gem 'i2c', '0.2.22'
  gem 'pi_piper', '1.3.2'
  gem 'wiringpi', '1.1.0'
end
