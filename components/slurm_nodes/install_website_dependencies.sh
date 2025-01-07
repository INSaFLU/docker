#!/bin/bash
set -e

# Install package dependencies

setup_website_dependencies() {
    echo "Install package dependencies"
    #apt-get -y install epel-release
    #apt-get -y install epel-release
    apt update -y
    
    apt install git curl wget libbz2-dev libffi-dev libreadline-dev libsqlite3-dev liblzma-dev libssl-dev libevent-dev libpq-dev -y
    if [ $? -ne 0 ]; then
        echo "Error installing system packages"
        exit 1
    fi
    
    pip3 install Cython  mod_wsgi-standalone pytest
}

setup_website_requirements() {
    echo "Setup website code"
    echo `which python3`
    echo `python3 --version`
    echo `pip3 --version`
    
    mkdir /insaflu_web_proxy && cd /insaflu_web_proxy
    if [ $? -ne 0 ]; then
        echo "Error creating or changing to /insaflu_web directory"
        exit 1
    fi
    
    git clone --branch ubuntu-develop https://github.com/SantosJGND/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "Error installing INSaFLU base"
        exit 1
    fi
    
    
}

setup_website_dependencies
setup_website_requirements
