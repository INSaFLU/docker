#!/bin/bash
set -e

echo "Install System Packages"
apt update -y
apt install apt-utils dialog -y
apt install make build-essential libssl-dev zlib1g-dev systemd -y

echo "SECOND"

apt install libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev -y
apt-get install gfortran libopenblas-dev liblapack-dev mysql-server -y
apt-get install dos2unix parallel postgis postgresql-contrib postgresql  bash file binutils gzip git unzip wget default-jdk default-jre perl libperl-dev libtime-piece-perl libxml-simple-perl libdigest-perl-md5-perl libmodule-build-perl libfile-slurp-unicode-perl libtest-simple-perl gcc zlib1g libbz2-dev xz-utils cmake g++ autoconf bzip2 automake libtool -y
apt install libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git apt-utils -y

if [ $? -ne 0 ]; then 
    echo "Error installing system packages"
    exit 1
fi