#!/bin/bash
set -ex

# image name
export IMAGE=insaflu-server

if [ -z "$1" ]
then
	docker compose up ${IMAGE}
else
	docker compose -f docker-compose_bind.yml up ${IMAGE}
fi
