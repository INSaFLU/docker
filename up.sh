#!/bin/bash
set -ex

# image name
export IMAGE=insaflu-server

docker-compose up ${IMAGE}

