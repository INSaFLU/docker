#!/bin/bash
set -ex

# image name
export IMAGE=televir-image

docker-compose build
docker-compose up televir-server
docker-compose up $IMAGE


