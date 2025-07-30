#!/bin/bash
set -e

# build DBs and launch frontend
if [ "$1" = "init_all" ]; then
    echo "---> Starting the MUNGE Authentication service (munged) ..."
    #service munge start
    
    gosu munge munged --pid-file=/var/run/munge/munged.pid
    
    echo "---> Wait 45 seconds for all pgsql services  ..."
    sleep 45	## wait for postgis extension
    
    ### set all default insaflu data
    echo "---> Collect static data  ..."
    cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py collectstatic --noinput;
    
    echo "---> Create/Update database if necessary  ..."
    cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py migrate;

    ### set owners
    echo "---> Set owners APP_USER ..."
    chown -R APP_USER:slurm /insaflu_web/INSaFLU/media
    chown -R APP_USER:slurm /var/log/insaFlu
    ### This is for televir
    chown -R APP_USER:slurm /insaflu_web/INSaFLU/static_all
    
    ### need to link after the mount, otherwise all the data in "/insaflu_web/INSaFLU/env" is going to be masked (hided)
    if [ -f "/insaflu_web/INSaFLU/env/insaflu.env" ]; then
        echo "---> Linking insaflu.env to .env ..."
        if [ -e "/insaflu_web/INSaFLU/.env" ]; then
            echo "---> Removing existing .env file ..."
            rm -f /insaflu_web/INSaFLU/.env
        fi
        cp /insaflu_web/INSaFLU/env/insaflu.env /insaflu_web/INSaFLU/.env
    fi
        
    ### set default files and settings, deploy using slurm
    echo "---> Set default files and settings  ..."
    cd /data/tmp/; 
    cp /insaflu_web/commands/load_defaults.sh .
    sudo -u flu_user sbatch load_defaults.sh
    cd /insaflu_web/INSaFLU; 

    ### some files/paths are made by "root" account and need to be accessed by "flu_user"
    ### It's done by tmpfiles.d
    rm -rf /tmp/insaFlu/*
    if [ -d "/tmp/insaFlu" ]; then
        chmod -R 0777 /tmp/insaFlu
    fi

    chmod -R 0777 /insaflu_web/INSaFLU/media
    chmod -R 0777 /insaflu_web/INSaFLU/static_all
    chmod -R 0777 /var/log/insaFlu

    ## for televir
    echo "--->  Set up TELEVIR software  ..."
    if [ -e /televir/mngs_benchmark/utility_docker.db ]; then
        cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py generate_default_trees; #/usr/bin/python3 manage.py register_references_on_file -o /tmp/insaFlu/register
        
    fi
    
    echo "---> Start apache server  ..."
    service apache2 start
    echo "---> apache running  ..."
    
    tail -f /dev/null
fi


