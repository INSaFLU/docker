#!/bin/bash

set -e

apt install slurm-client munge -y
apt install curl dirmngr apt-transport-https lsb-release ca-certificates -y

curl -sL https://deb.nodesource.com/setup_12.x | bash -
