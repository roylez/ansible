#!/usr/bin/env ruby
# encoding: utf-8
#

Vagrant.configure("2") do |config|
  # do not create console log for vms
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.box_check_update = false

  config.vm.synced_folder ".", "/root/ansible", type: "rsync", rsync__exclude: ".git/"
  config.vm.provision "shell", inline: "apt-get -qq update; DEBIAN_FRONTEND=noninteractive apt-get -yq install ansible"

  config.vm.define(:ubuntu, primary: true) do |config|
    config.vm.box = "ubuntu/bionic64"
  end

  config.vm.define(:debian) do |config|
    config.vm.box = "generic/debian9"
  end

end
