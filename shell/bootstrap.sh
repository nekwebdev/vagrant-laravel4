#!/bin/sh

# This script could also be used on a live Debian server.

# Directory in which librarian-puppet should manage its modules directory

PUPPET_DIR='/vagrant/puppet'

# Make sure our package manager is updated and check that Git is installed.
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?

if [ "${FOUND_APT}" -eq '0' ]; then
    echo '[Shell]: Updating apt package manager...'
    apt-get -q -y update
    if [ "$FOUND_GIT" -ne '0' ]; then
        echo '[Shell]: Attempting to install Git.'
        apt-get -q -y install git
        echo '[Shell]: Git installed.'
    else
        echo '[Shell]: Git found.'
    fi
else
  echo '[Shell]: No package manager available.'
fi

# Install Librarian Puppet fork from maestrodev.
if [ "$(gem search -i librarian-puppet-maestrodev)" = "false" ]; then
    echo '[Shell]: Attempting to install librarian-puppet...'
    gem install librarian-puppet-maestrodev --verbose
    echo '[Shell]: Librarian-puppet installed, getting Puppet modules...'
    cd $PUPPET_DIR && librarian-puppet install --clean
else
    '[Shell]: Librarian-puppet found, updating Puppet modules...'
    cd $PUPPET_DIR && librarian-puppet update
fi

# Run Puppet
puppet apply --verbose --hiera_config $PUPPET_DIR/manifests/hiera.yaml --modulepath=$PUPPET_DIR/modules/ $PUPPET_DIR/manifests/site.pp