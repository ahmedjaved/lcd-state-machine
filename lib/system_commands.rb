module RaspberryPiControlPanel
  # stores all of the actions performed using external programs
  class SystemCommands
    def update_system
      `sudo apt-get update 2>&1 |tee apt-get_update_output.log`
      log = "**** apt-get update START****\n#{`cat apt-get_update_output.log`}\n"
      log << "**** apt-get update END****\n\n**** apt-get upgrade START****\n"
      `sudo apt-get upgrade -y 2>&1 |tee apt-get_upgrade_output.log`
      log << "#{`cat apt-get_upgrade_output.log`}\n**** apt-get upgrade END****\n"
    end
  end
end
