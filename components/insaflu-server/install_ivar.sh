#!/bin/bash
# components/insaflu-server/install_ivar.sh
# Creates the ivar conda environment.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install iVar"
conda create --name=ivar -c conda-forge -c bioconda ivar=1.4.2 bedtools=2.31.0 bwa=0.7.17 --yes
