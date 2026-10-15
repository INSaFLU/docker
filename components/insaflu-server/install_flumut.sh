#!/bin/bash
# components/insaflu-server/install_flumut.sh
# Creates the flumut environment with pixi.

set -e

echo "Install FluMut"
mkdir -p /software/pixi/flumut
cd /software/pixi/flumut
pixi init --channel conda-forge --channel bioconda
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add flumut=0.6.3
ln -s /software/pixi/flumut/.pixi/envs/default /software/miniconda2/envs/flumut
