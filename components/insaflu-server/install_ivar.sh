#!/bin/bash
# components/insaflu-server/install_ivar.sh
# Creates the ivar environment with pixi and symlinks it into the conda envs
# directory, so "conda activate ivar" keeps working.

set -e

echo "Install iVar"
mkdir -p /software/pixi/ivar
cd /software/pixi/ivar
pixi init --channel conda-forge --channel bioconda
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add ivar=1.4.2 bedtools=2.31.0 bwa=0.7.17
ln -s /software/pixi/ivar/.pixi/envs/default /software/miniconda2/envs/ivar
