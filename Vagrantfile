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
    apt-add-repository --yes --update ppa:ansible/ansible
    DEBIAN_FRONTEND=noninteractive apt-get -yq install ansible make
SHELL

IMAGES = {
  ubuntu: {
    virtualbox: "generic/ubuntu2004",
    libvirt:    "generic/ubuntu2004",
    docker:     "20.04"
  },
  debian: {
    virtualbox: "generic/debian10",
    libvirt:    "generic/debian10",
    docker:     "stable"
  }
}

ENV['VAGRANT_DEFAULT_PROVIDER'] = "libvirt"

Vagrant.configure("2") do |config|
  # do not create console log for vms
  config.vm.provider("virtualbox") { |v| v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ] }
  config.vm.provider("libvirt"   ) { |v| v.graphics_type = "none" }

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
      # https://dev.to/mattdark/using-docker-as-provider-for-vagrant-10me
      config.vm.provider :docker do |d|
        d.build_dir       = "docker"
        d.dockerfile      = "Dockerfile.#{os}"
        d.build_args      = ["--build-arg", "VER=#{IMAGES[os][:docker]}"]
        d.has_ssh         = true
        d.remains_running = true
      end
    end
  end
end
