# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "oraclelinux-6-x86_64"
  config.vm.box_url = "http://cloud.terry.im/vagrant/oraclelinux-6-x86_64.box"
  config.vm.hostname = "oracle"

  config.ssh.forward_x11=true

  # Forward Oracle ports
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  config.vm.network :forwarded_port, guest: 1158, host: 1158

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id,
                  "--name", "oradb",
                  "--memory", "2048",
                  "--natdnshostresolver1", "on"]
  end

  # CREATE SECONDARY DRIVE
  config.vm.provider :virtualbox do |virtualbox|
    file_to_disk = File.realpath( "." ).to_s + "/#{config.vm.hostname}_disk2.vdi"
    if ARGV[0] == "up" && ! File.exist?(file_to_disk) 

      disk_size = 30 # Amount of space (GB) to extend the VM with
      puts "Creating #{disk_size}GB disk #{file_to_disk}."
      virtualbox.customize [
          'createhd', 
          '--filename', file_to_disk, 
          '--format', 'VDI', 
          '--size', (disk_size * 1024)
          ] 
      virtualbox.customize [
          'storageattach', :id, 
          '--storagectl', 'SATA', 
          '--port', 1, '--device', 0, 
          '--type', 'hdd', '--medium', 
          file_to_disk
          ]

      config.ssh.pty = true # Ensure that we can execute the script
    end
  end

  config.vm.provision "shell", path: "add_second_disk.sh"

  # set timezone
  config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/GB /etc/localtime"

  config.vm.provision :shell, :inline => "sudo yum install puppet -y"

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end
end
