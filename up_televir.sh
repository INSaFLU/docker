#!/bin/bash
set -ex

source .env

if [ ! -d "${BASE_PATH_DATA}/postgres/postgres_data" ]; then 
	mkdir -p ${BASE_PATH_DATA}/postgres/postgres_data
fi
if [ ! -d "${BASE_PATH_DATA}/postgres/backups" ]; then 
	mkdir -p ${BASE_PATH_DATA}/postgres/backups
fi
if [ ! -d "${BASE_PATH_DATA}/insaflu/data/all_data" ]; then 
	mkdir -p ${BASE_PATH_DATA}/insaflu/data/all_data
fi
if [ ! -d "${BASE_PATH_DATA}/insaflu/data/predefined_dbs" ]; then 
	mkdir -p ${BASE_PATH_DATA}/insaflu/data/predefined_dbs
fi
if [ ! -d "${BASE_PATH_DATA}/insaflu/env" ]; then 
	mkdir -p ${BASE_PATH_DATA}/insaflu/env
fi
if [ ! -d "${BASE_PATH_DATA}/insaflu/log/insaFlu" ]; then 
	mkdir -p ${BASE_PATH_DATA}/insaflu/log/insaFlu
	chmod 777 ${BASE_PATH_DATA}/insaflu/log/insaFlu
fi
if [ ! -d "${BASE_PATH_DATA}/insaflu/log/httpd" ]; then 
	mkdir -p ${BASE_PATH_DATA}/insaflu/log/httpd
	chmod 777 ${BASE_PATH_DATA}/insaflu/log/httpd
fi
if [ ! -d "${BASE_PATH_DATA}/televir" ]; then 
	mkdir -p ${BASE_PATH_DATA}/televir
fi

# image name
export IMAGE=televir-server

docker compose up $IMAGE

