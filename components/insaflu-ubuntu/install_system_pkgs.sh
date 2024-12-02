#!/bin/bash
set -e

echo "Install System Packages"

install_system_packages() {
    apt update -y
    if [ $? -ne 0 ]; then
        echo "Error updating package list"
        exit 1
    fi
    
    apt install apt-utils dialog -y
    if [ $? -ne 0 ]; then
        echo "Error installing apt-utils and dialog"
        exit 1
    fi
    
    apt install make build-essential libssl-dev zlib1g-dev systemd -y
    if [ $? -ne 0 ]; then
        echo "Error installing build-essential packages"
        exit 1
    fi
    
    apt install libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev -y
    if [ $? -ne 0 ]; then
        echo "Error installing development libraries"
        exit 1
    fi
    
    apt-get install gfortran libopenblas-dev liblapack-dev -y
    if [ $? -ne 0 ]; then
        echo "Error installing Fortran and BLAS/LAPACK libraries"
        exit 1
    fi
    
    apt-get install dos2unix parallel postgis postgresql-contrib postgresql bash file binutils gzip git unzip wget default-jdk default-jre perl libperl-dev libtime-piece-perl libxml-simple-perl libdigest-perl-md5-perl libmodule-build-perl libfile-slurp-unicode-perl libtest-simple-perl gcc zlib1g libbz2-dev xz-utils cmake g++ autoconf bzip2 automake libtool -y
    if [ $? -ne 0 ]; then
        echo "Error installing various utilities and libraries"
        exit 1
    fi
    
    apt install libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git apt-utils nano -y
    if [ $? -ne 0 ]; then
        echo "Error installing additional development libraries"
        exit 1
    fi
}

install_system_packages