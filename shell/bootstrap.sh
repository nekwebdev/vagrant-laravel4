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
    echo 'Updating apt package manager.'
    apt-get -q -y update
    if [ "$FOUND_GIT" -ne '0' ]; then
        echo 'Attempting to install Git.'
        apt-get -q -y install git
        echo 'Git installed.'
    else
        echo 'Git found.'
    fi
else
  echo 'No package manager available.'
fi

# Install Librarian Puppet fork from maestrodev.
if [ "$(gem search -i librarian-puppet-maestrodev)" = "false" ]; then
  gem install librarian-puppet --verbose
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi

# Run Puppet
puppet apply --verbose --hiera_config $PUPPET_DIR/manifests/hiera.yaml --modulepath=$PUPPET_DIR/modules/ $PUPPET_DIR/manifests/site.pp