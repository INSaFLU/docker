#!/bin/bash
# components/insaflu-server/install_aln2pheno.sh
# Creates the aln2pheno environment with pixi and installs the wrapper script.
# python=3.9 is pinned: python=3 now resolves to 3.10, for which greenlet has
# no wheel here, and greenlet 3.x is C++11 which gcc 4.8.5 cannot compile.
# See: https://github.com/INSaFLU/docker/issues/44

set -e

echo "Install Aln2Pheno"
mkdir -p /software/pixi/aln2pheno
cd /software/pixi/aln2pheno
pixi init --channel conda-forge
pixi workspace platform add el7=linux-64 --glibc 2.17
pixi workspace platform remove linux-64
pixi add python=3.9
ln -s /software/pixi/aln2pheno/.pixi/envs/default /software/miniconda2/envs/aln2pheno
uv pip install --python /software/pixi/aln2pheno/.pixi/envs/default/bin/python algn2pheno==1.1.5
mv /tmp_install/software/aln2pheno /software/
chmod u+x /software/aln2pheno/aln2pheno.sh
