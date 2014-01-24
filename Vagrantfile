# -*- mode: ruby -*-
# vi: set ft=ruby :


# Configurable variables for your vagrant machine.
# See /shell/bootstrap.sh and /puppet/manifests/site.pp for more configurations.
$hostname  = "vagrant.phpdev.local"
$localip = "192.168.168.160"


Vagrant.configure("2") do |config|
    # Basics.
    config.vm.box     = "debian70-rc1-puppetlabs"
    config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-70rc1-x64-vbox4210.box"

    # Networking.
    config.vm.hostname = $hostname
    config.vm.network :private_network, ip: $localip

    # Provisioning.
    config.vm.provision :shell, :path => "shell/bootstrap.sh"

    # Note we are not using Vagrant to start puppet.
    # I am trying to make the use of puppet separate so it can be reproduced on a live server.

    # Set the permissions and ownership of your php project. This is for laravel 4 using basset as an example
    config.vm.synced_folder "www/app/storage", "/vagrant/www/app/storage",
        :owner => 'vagrant',
        :group => 'www-data',
        :mount_options => ['dmode=775,fmode=664']

    config.vm.synced_folder "www/public/assets/compiled", "/vagrant/www/public/assets/compiled",
        :owner => 'vagrant',
        :group => 'www-data',
        :mount_options => ['dmode=775,fmode=664']
end
