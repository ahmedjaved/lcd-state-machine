source 'https://rubygems.org'

gem 'state_machine', require: 'state_machine/core'
gem 'logging'
gem 'mail'
gem 'dotenv'

group :development do
  gem 'ruby-graphviz'
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec', '>=3.0'
  gem 'rake'
  gem 'fuubar'
  # for code coverage
  gem 'simplecov', require: false
  # for automatic execution of tests upon changing rspec files
  # https://github.com/guard/guard-rspec
  gem 'guard-rspec', require: false
  gem 'rb-readline'
  # for raspi-adafruit-ruby
  gem 'i2c', '0.2.22'
  gem 'wiringpi', '1.1.0'
  gem 'pi_piper'
end
