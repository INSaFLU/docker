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
if [ ! -d "${BASE_PATH_DATA}/televir" ]; then 
	mkdir -p ${BASE_PATH_DATA}/televir
fi

# image name
export IMAGE=insaflu-ubuntu

echo "Starting INSaFLU services (without compute nodes)..."
docker compose up ${IMAGE}

echo ""
echo "==================================================================="
echo "INSaFLU is now running without compute nodes."
echo "To add compute nodes dynamically, use:"
echo "  ./scale-up.sh [number_of_nodes]"
echo ""
echo "To remove compute nodes, use:"
echo "  ./scale-down.sh [number_of_nodes]"
echo ""
echo "To start with initial nodes, run:"
echo "  ./scale-up.sh 2"
echo "==================================================================="
