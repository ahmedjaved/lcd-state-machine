source 'https://rubygems.org'

gem 'state_machine', require: 'state_machine/core'
gem 'logging'
gem 'mail'
gem 'dotenv'

group :development do
  gem 'ruby-graphviz'
  gem 'rubocop', require: false
  gem 'codecov', :require => false, :group => :test
  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'libnotify'
  gem 'rb-readline'
end

group :test do
  gem 'rspec', '~>3.2.0'
  gem 'rake'
  gem 'fuubar'

  # for code coverage
  gem 'simplecov', require: false

  # for raspi-adafruit-ruby
  gem 'i2c', '0.2.22'
  gem 'wiringpi', '1.1.0'
  gem 'pi_piper'

end
