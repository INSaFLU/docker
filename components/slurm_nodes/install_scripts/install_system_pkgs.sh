#!/bin/bash
set -e

echo "Install System Packages"

install_pyenv() {
    apt install -y python3-pip
    #exec "$SHELL"
    
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    if [ $? -ne 0 ]; then
        echo "Error cloning pyenv repository"
        exit 1
    fi
    
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc
    
    ~/.pyenv/bin/pyenv install 3.8.3
    ~/.pyenv/bin/pyenv global 3.8.3
    
    pip3  install --upgrade pip
}


install_python2() {
    apt install -y python2
    if [ $? -ne 0 ]; then
        echo "Error installing python2"
        exit 1
    fi
    
}

install_python310() {
    apt install python3-pip -y
    if [ $? -ne 0 ]; then
        echo "Error installing python3-pip"
        exit 1
    fi
    
    apt install python3.10 -y
    if [ $? -ne 0 ]; then
        echo "Error installing python3.10"
        exit 1
    fi
}

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
    
    apt-get install dos2unix parallel postgis postgresql-contrib postgresql bash file binutils gzip git unzip wget default-jdk default-jre perl libconfig-yaml-perl libperl-dev libtime-piece-perl libxml-simple-perl libdigest-perl-md5-perl libmodule-build-perl libfile-slurp-unicode-perl libtest-simple-perl gcc zlib1g libbz2-dev xz-utils cmake g++ autoconf bzip2 lib32stdc++6 automake libtool -y
    if [ $? -ne 0 ]; then
        echo "Error installing various utilities and libraries"
        exit 1
    fi
    
    apt install libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git apt-utils nano -y
    if [ $? -ne 0 ]; then
        echo "Error installing additional development libraries"
        exit 1
    fi
    
    #install_pyenv
    install_python310
    install_python2
    
}

install_system_packages