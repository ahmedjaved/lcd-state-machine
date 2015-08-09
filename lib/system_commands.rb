module RaspberryPiControlPanel
  # stores all of the actions performed using external programs
  class SystemCommands
    def install_software_updates
      'apt-get update 2>&1 | tee apt-get-update-output.log'
    end

    def install_kernel_updates
      'apt-get upgrade -y 2>&1 | tee apt-get-upgrade-output.log'
    end
  end
end
