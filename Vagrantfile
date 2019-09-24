#!/usr/bin/env ruby
# encoding: utf-8
#

TAME_SCRIPT = <<-SHELL
    echo "Fixing hard coded DNS"
    sed -i -e "s/^#\\?DNS=.*$/DNS=/g;s/^#\\?DNSSEC=.*$/DNSSEC=no/g" /etc/systemd/resolved.conf
    systemctl restart systemd-resolved

    echo "Use local mirror for APT"
    sed -i 's/us.archive/au.archive/g' /etc/apt/sources.list

    echo "Install ansible"
    apt-get -qq update; DEBIAN_FRONTEND=noninteractive apt-get -yq install ansible
SHELL

Vagrant.configure("2") do |config|
  # do not create console log for vms
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
  config.vm.provider "libvirt" do |v|
    v.graphics_type = "none"
  end

  config.nfs.functional       = false
  config.nfs.verify_installed = false
  config.vm.box_check_update  = false

  config.vm.synced_folder ".", "/root/ansible", type: "rsync", rsync__exclude: ".git/"
  config.vm.provision "shell", inline: TAME_SCRIPT

  config.vm.define(:ubuntu, primary: true) do |config|
    config.vm.provider "virtualbox" do |_, override|
      override.vm.box = "ubuntu/bionic64"
    end
    config.vm.provider "libvirt" do |_, override|
      override.vm.box = "generic/ubuntu1804"
    end
  end

  config.vm.define(:debian) do |config|
    config.vm.provider "virtualbox" do |_, override|
      override.vm.box = "generic/debian9"
    end
    config.vm.provider "libvirt" do |_, override|
      override.vm.box = "debian/stretch64"
    end
  end

end
