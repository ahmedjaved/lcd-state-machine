# LCD Control Panel for Raspberry Pi

### Requirements
* Ruby 2.1.2
* Setup LCD based on https://github.com/ahmedjaved2011/raspi-adafruit-ruby

### How To Run

Execute 
```
rbenv sudo ruby lib/lcd.rb
```

### .env file
.env is used to specify settings for email. Following environment variables are used

```
LCD_EMAIL_ADDRESS
LCD_EMAIL_PORT
LCD_EMAIL_USER_NAME
LCD_EMAIL_PASSWORD
```
Note: the password is in base 64

### state machine diagram
Requires graphviz for creating state machine diagram.

To create the state machine diagram execute following in the root directory

```
rake -f state-diagram/Rakefile state_machine:draw FILE=./lib/lcd_control_panel.rb CLASS=LcdControlPanel TARGET=state-diagram
```

