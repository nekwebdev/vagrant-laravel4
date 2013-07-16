# Get the bashrc with our aliases for reloading puppet in vagrant.
# This is specific to our vagrant machine and can have aliases
# specific to our php project.
# It will most likely be a different file for a production server.
file { '.bashrc':
    path    => '/home/vagrant/.bashrc',
    ensure  => file,
    source  => "/vagrant/puppet/files/.bashrc",
    owner   => "vagrant",
}

# class {'locales':
#     locales => [ 'en_US.UTF-8 UTF-8' ],
# }

class { locales:
  default_value  => "en_US.UTF-8",
  available      => ["en_US.UTF-8 UTF-8"]
}

# Provision apache with no default vhost
class { 'apache':
    default_vhost => false,
    mpm_module => 'prefork',
}

# Configure the default vhost
apache::vhost { 'default':
    default_vhost => true,
    #ip => '192.168.168.160',
    port => '80',
    docroot     => '/vagrant/www/public',
    directories => [ { path => '/vagrant/www/public/', allow_override => ['All'] } ],
}

# Install apache modules
apache::mod { 'rewrite': }

# Enable php for apache
class { 'apache::mod::php': }

# Provision MySQL server and client
class { 'mysql::server':
    config_hash => { 'root_password' => 'root' }
}

# Enable mysql for php
class { 'mysql::php': }

# Create vagrant database and user
mysql::db { 'vagrant':
    user     => 'vagrant',
    password => 'vagrant',
    host     => 'localhost',
    grant    => ['all'],
}

# Curl is needed for composer
package { 'curl':
    ensure => 'installed',
}
exec { 'Install Composer for php projects':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    require => Package['curl'],
}

# Needed for Laravel 4 
package { 'php5-mcrypt':
    ensure  => 'installed',
}

# Config files for Laravel4
# Make sure this line is in your $env array:
# 'vagrant' => array('vagrant'),
# This will make Laravel 4 use the following 3 configuration files
file{'/vagrant/www/app/config/vagrant':
    ensure => directory,
}

file { '/vagrant/www/app/config/vagrant/app.php':
    ensure  => file,
    source  => "/vagrant/puppet/files/laravel4-config/app.php",
}

file { '/vagrant/www/app/config/vagrant/database.php':
    ensure  => file,
    source  => "/vagrant/puppet/files/laravel4-config/database.php",
}

file { '/vagrant/www/app/config/vagrant/mail.php':
    ensure  => file,
    source  => "/vagrant/puppet/files/laravel4-config/mail.php",
}

# Script to run composer and artisan
file { '/home/vagrant/boot-starter.sh':
    ensure  => file,
    source  => "/vagrant/puppet/files/boot-starter.sh",
    owner   => "vagrant",
    mode    => "u+x",
}