#!/bin/bash
# components/insaflu-server/install_nextstrain_rsv.sh
# Creates the nextstrain_rsv environment with pixi.

set -e

echo "Install Nextstrain RSV"
mkdir -p /software/pixi/nextstrain_rsv
cd /software/pixi/nextstrain_rsv
pixi init --channel conda-forge --channel bioconda
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add python=3.10 augur=20.0 auspice=2.42 nextalign=2.9.1 nextclade=2.9.1 snakemake git epiweeks=2.1.4
ln -s /software/pixi/nextstrain_rsv/.pixi/envs/default /software/miniconda2/envs/nextstrain_rsv
