#!/bin/bash
# components/insaflu-server/install_pangolin.sh
# Creates the pangolin environment with pixi and installs the wrapper scripts.

set -e

echo "Install Pangolin"
mv /tmp_install/software/update_pangolin.sh /software
chmod a+x /software/update_pangolin.sh
mv /tmp_install/software/pangolin /software/
mkdir -p /software/pixi/pangolin
cd /software/pixi/pangolin
pixi init --channel conda-forge --channel bioconda
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add python=3.8 pangolin=4.2
ln -s /software/pixi/pangolin/.pixi/envs/default /software/miniconda2/envs/pangolin
chmod u+x /software/pangolin/pangolin.sh
