# What you get

Apache 2 running on port 80 of 192.168.168.160, you can change the ip in the `Vagrantfile`

PHP5.4 with MCrypt

MySQL running on port 3306 of 192.168.168.160

MySQL `root` user with a password of `root`

MySQL `vagrant` user with a password of `vagrant` that has all privileges on a database named `vagrant`

SMTP service with python that will act as a catch all for transactional email testing

# Configuration

## Usage for [Laravel 4 Starter Site](https://github.com/andrew13/Laravel-4-Bootstrap-Starter-Site)

Navigate in your terminal to the folder where you would like your project to reside and run:

    git clone https://github.com/nekwebdev/vagrant-laravel4.git project-name

This will create a folder with the needed files for the Vagrant VM.

Now let's fetch our php project from github as well.

    cd project-name
    git clone https://github.com/andrew13/Laravel-4-Bootstrap-Starter-Site.git www

We have now cloned our starter Laravel 4 site in the www folder of our project folder. Let's start our development virtual machine:

    vagrant up

This will take some time. It will first download a base virtual box of Debian 7.0 RC1 made by the folks at PuppetLabs, so nothing shady there.

Then the script `/shell/bootstrap.sh` will run. It will make sure the package manager is updated and that git is installed. It will install [librarian-puppet-maestrodev](https://github.com/maestrodev/librarian-puppet) which will act just like composer for your puppet modules. Really nice. It will then load the modules and apply puppet.

Now is time to ssh into our virtual machine and run the Starter site install script. It will basically run the composer and artisan commands for you.

    vagrant ssh
    ./boot-starter.sh

To start the smtp python server listening on port 2525 run the command `pysmtpd`.

## Other PHP projects

You can easily configure `/puppet/manifests/site.pp` and `shell/bootstrap.sh` to your own php projects. Don't forget to check the `/puppet/files/.bashrc` to customize aliases.

Use the example of the `/puppet/files/laravel4-config` files to see how puppet can initialize a project with specific files.

Look at the docs of the puppet modules enabled by `/puppet/manifests/Puppetfile` if you need more php or apache modules enabled.
