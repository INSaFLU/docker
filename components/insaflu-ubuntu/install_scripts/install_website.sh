#!/bin/bash
set -e

setup_website() {
    echo "Setup website code"
    echo `which python3`
    echo `python3 --version`
    echo `pip3 --version`
    
    mkdir /insaflu_web && cd /insaflu_web
    if [ $? -ne 0 ]; then
        echo "Error creating or changing to /insaflu_web directory"
        exit 1
    fi
    
    git clone --branch ubuntu-develop https://github.com/SantosJGND/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "Error installing INSaFLU base"
        exit 1
    fi
    
    mkdir -p /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu && chown -R ${APP_USER}:${APP_USER} /var/log/insaFlu
    if [ $? -ne 0 ]; then
        echo "Error setting up environment and changing ownership"
        exit 1
    fi
}

setup_website