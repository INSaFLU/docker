#!/bin/bash
set -e

if [ "$1" = "slurmdbd" ]
then
    echo "---> Starting the MUNGE Authentication service (munged) ..."
    #service munge start
    gosu munge munged --pid-file=/var/run/munge/munged.pid
    
    echo "---> Starting the Slurm Database Daemon (slurmdbd) ..."
    
    {
        . /etc/slurm/slurmdbd.conf
        until echo "SELECT 1" | mysql -h $StorageHost -u$StorageUser -p$StoragePass 2>&1 > /dev/null
        do
            echo "-- Waiting for database to become active ..."
            sleep 2
        done
    }
    echo "-- Database is now active ..."
    
    exec gosu slurm /usr/sbin/slurmdbd -Dvvv
fi

if [ "$1" = "slurmctld" ]
then
    echo "---> Starting the MUNGE Authentication service (munged) ..."
    #service munge start
    gosu munge munged --pid-file=/var/run/munge/munged.pid
    echo "---> Waiting for slurmdbd to become active before starting slurmctld ..."
    
    until 2>/dev/null >/dev/tcp/slurmdbd/6819
    do
        echo "-- slurmdbd is not available.  Sleeping ..."
        sleep 2
    done
    echo "-- slurmdbd is now active ..."

    echo "---> create user and group for slurmctld ..."
    
    echo "---> Starting the Slurm Controller Daemon (slurmctld) ..."
    if /usr/sbin/slurmctld -V | grep -q '21.08.8-2' ; then
        exec gosu slurm /usr/sbin/slurmctld -Dvvv
    else
        exec gosu slurm /usr/sbin/slurmctld -i -Dvvv
    fi
fi

if [ "$1" = "slurmd" ]
then
    chown -R flu_user:slurm /software
    echo "---> Starting the MUNGE Authentication service (munged) ..."
    #service munge start
    gosu munge munged --pid-file=/var/run/munge/munged.pid
    echo "---> Waiting for slurmctld to become active before starting slurmd..."
    
    until 2>/dev/null >/dev/tcp/slurmctld/6817
    do
        echo "-- slurmctld is not available.  Sleeping ..."
        sleep 2
    done
    echo "-- slurmctld is now active ..."
    echo "---> create user and group for slurmd ..."
    APP_USER=flu_user
    APP_GROUP=flu_user
    APP_HOME=/home/$APP_USER
    sacctmgr create account -i $APP_USER
    sacctmgr create user -i $APP_USER
    sacctmgr modify user $APP_USER set adminlevel=ALL
    sacctmgr modify user $APP_USER set defaultaccount=$APP_USER

    echo "---> Starting the Slurm Node Daemon (slurmd) ..."
    exec /usr/sbin/slurmd -Dvvv

fi

exec "$@"
