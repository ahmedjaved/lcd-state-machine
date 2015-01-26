# LCD Control Panel for Raspberry Pi

[![Build Status](https://travis-ci.org/ahmedjaved/lcd-control-panel-statemachine.svg?branch=master)](https://travis-ci.org/ahmedjaved/lcd-control-panel-statemachine)
[![Coverage Status](https://coveralls.io/repos/ahmedjaved/lcd-control-panel-statemachine/badge.svg)](https://coveralls.io/r/ahmedjaved/lcd-control-panel-statemachine)


### Requirements
* Ruby 2.1.2
* Setup LCD based on https://github.com/ahmedjaved2011/raspi-adafruit-ruby

### How To Run

Execute
```
rbenv sudo ruby lib/lcd_buttons.rb
```

### .env file
.env is used to specify settings for email. Following environment variables are used

```
SMTP_ADDRESS
SMTP_PORT
SMTP_USER_NAME
SMTP_PASSWORD
FROM_EMAIL_ADDRESS

```
Note: the password is in base 64

### state machine diagram
Requires graphviz for creating state machine diagram.

To create the state machine diagram execute following in the root directory

```
bundle exec rake -f state-diagram/Rakefile state_machine:draw FILE=./lib/lcd_state_machine.rb CLASS=RaspberryPiControlPanel::LcdStateMachine TARGET=state-diagram
```

