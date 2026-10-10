#!/bin/bash
# components/insaflu-server/install_flumut.sh
# Creates the flumut conda environment.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install FluMut"
conda create --name=flumut -c conda-forge -c bioconda flumut=0.6.3 --yes
