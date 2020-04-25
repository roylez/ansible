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

IMAGES = {
  ubuntu: {
    virtualbox: "ubuntu/bionic64",
    libvirt:    "generic/ubuntu1804",
  },
  debian: {
    virtualbox: "generic/debian9",
    libvirt:    "debian/stretch64",
  }
}

Vagrant.configure("2") do |config|
  # do not create console log for vms
  config.vm.provider "virtualbox" { |v| v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ] }
  config.vm.provider "libvirt"    { |v| v.graphics_type = "none" }

  config.nfs.functional       = false
  config.nfs.verify_installed = false
  config.vm.box_check_update  = false

  config.vm.synced_folder ".", "/root/ansible", type: "rsync", rsync__exclude: ".git/"
  config.vm.provision "shell", inline: TAME_SCRIPT

  %i(ubuntu debian).each.with_index do |os, idx|
    config.vm.define os do |config|
      %i(virtualbox libvirt).each do |virt|
        config.vm.provider virt do |_, override|
          override.vm.box = IMAGES[os][virt]
        end
      end
    end
  end
end
