#!/bin/bash
# components/insaflu-server/install_raven.sh
# Creates the raven environment with pixi and installs the wrapper script.

set -e

echo "Install raven"
mkdir -p /software/pixi/raven
cd /software/pixi/raven
pixi init --channel conda-forge --channel bioconda
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add raven-assembler=1.8.1
ln -s /software/pixi/raven/.pixi/envs/default /software/miniconda2/envs/raven
mv /tmp_install/software/raven/ /software/
chmod a+x /software/raven/raven.sh
