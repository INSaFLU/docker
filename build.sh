#!/bin/bash

source .env

mkdir -p ${BASE_PATH_DATA}/postgres/postgres_data
mkdir -p ${BASE_PATH_DATA}/postgres/backups
mkdir -p ${BASE_PATH_DATA}/insaflu/data/all_data
mkdir -p ${BASE_PATH_DATA}/insaflu/data/predefined_dbs
mkdir -p ${BASE_PATH_DATA}/insaflu/env

if [ -z "$1" ] 
then  
	docker-compose build 
else  
	docker-compose -f docker-compose_bind.yml build 
fi
