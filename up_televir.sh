#!/bin/bash
set -ex

# image name
export IMAGE=televir-image

docker-compose up ${IMAGE}

