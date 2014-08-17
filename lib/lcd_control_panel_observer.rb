require 'logging'

class LcdControlPanelObserver
  @log = Logging.logger['log']
  @log_suffix = Time.now.strftime("%Y%m%d-%H:%M:%S")

  @log.add_appenders(
    Logging.appenders.stdout(:layout => Logging.layouts.pattern(:pattern => '[%d] %-5l: %m\n')
                            ),
    Logging.appenders.file("log-#{@log_suffix}.log",
                           :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l: %m\n')
                           )
  )

  @log.level = :debug

  def self.after_transition(lcdControlPanel, transition)    
    @log.debug "#{lcdControlPanel} instructed to #{transition.event}... #{transition.attribute} was: #{transition.from}, #{transition.attribute} is: #{transition.to}"
  end
end