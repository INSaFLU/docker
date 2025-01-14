#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
#apt-get -y install epel-release
#apt-get -y install epel-release
apt update -y

apt install git curl wget libbz2-dev libffi-dev libreadline-dev libsqlite3-dev liblzma-dev libssl-dev libevent-dev libpq-dev -y
if [ $? -ne 0 ]; then
    echo "Error installing system packages"
    exit 1
fi

pip3 install Cython  mod_wsgi-standalone
