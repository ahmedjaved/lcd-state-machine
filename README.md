lcd-state-machine [![Build Status](https://travis-ci.org/ahmedjaved/lcd-state-machine.svg?branch=master)](https://travis-ci.org/ahmedjaved/lcd-state-machine) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=lcd-state-machine&metric=alert_status)](https://sonarcloud.io/dashboard?id=lcd-state-machine)
==================

## Description
A [state machine](https://github.com/pluginaweek/state_machine) backed implementation to control [Raspberry PI](http://www.raspberrypi.org/) using [Adafruit LCD](http://www.adafruit.com/product/1110).

When the buttons are pressed on the LCD events are triggered on state machine. At the moment up button is not used.

The start state is dot in the diagram below and depending on the button pressed LCD can be in one of the states in circle.

The circle with double border is the final state after which the process for the state machine exits.

![](https://raw.githubusercontent.com/ahmedjaved/lcd-state-machine/master/state_machine_diagram.png)

## Setup
* Raspberry Pi with Ruby 2.1.5 setup using [rbenv](https://github.com/sstephenson/rbenv), [rbenv-build](https://github.com/sstephenson/ruby-build) and [rbenv-sudo](https://github.com/dcarley/rbenv-sudo)
* Setup Adafruit LCD as outlined [here](https://github.com/ahmedjaved/raspi-adafruit-ruby/tree/0a55879b47972efa3d2af5d208417659a441a62d)
* ```bundle install```
* ```bundle exec rake setup_git_submodule```

## Usage

To start LCD using state machine run
```rbenv sudo ruby lib/lcd.rb```

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

## Development

### tests
The [unit](https://github.com/ahmedjaved/lcd-control-panel-statemachine/tree/master/spec/unit) and [integration](https://github.com/ahmedjaved/lcd-control-panel-statemachine/tree/master/spec/integration) tests are implemented using [rspec](http://rspec.info/)
### state machine diagram
Requires [graphviz](http://www.graphviz.org/) for creating state machine diagram.

To create the state machine diagram execute following in the root directory

```bundle exec rake draw_state_machine_diagram```

## Resources

Learning Ruby? Here are some links for some of the Ruby Standard Library
classes used in this project

[Singleton](https://dalibornasevic.com/posts/9-ruby-singleton-pattern)

[SimpleDelegator](https://hashrocket.com/blog/posts/using-simpledelegator-for-your-decorators)

[Forwardable](http://vaidehijoshi.github.io/blog/2015/03/31/delegating-all-of-the-things-with-ruby-forwardable/)
