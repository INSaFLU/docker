#!/bin/bash
set -ex

# image name
export IMAGE=televir-server

docker compose up $IMAGE

