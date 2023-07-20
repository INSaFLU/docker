#!/bin/bash

if [ "$1" = "move" ]; then
    echo "---> Create televir dbs in /televir/mngs_benchmark/ ..."
    
    if [ ! -d "/televir/mngs_benchmark" ]; then
        mkdir -p /televir/mngs_benchmark
    fi
    
    cd insaflu_web/TELEVIR
    
    /opt/venv/bin/python main.py --docker --envs --setup_conda --partial
    /opt/venv/bin/python main.py --docker --envs --partial
    
    /opt/venv/bin/python main.py --docker --seqdl --partial
    /opt/venv/bin/python main.py --docker --soft --partial
    /opt/venv/bin/python main.py --docker --deploy --partial
    
    
    cp utility.db /televir/mngs_benchmark/utility.db
    cp install_scripts/config.py /televir/mngs_benchmark/config.py

    chmod -R 0777 /televir/mngs_benchmark
    
    echo "---> Finshed creating televir dbs in /televir/mngs_benchmark/ ... done"
fi