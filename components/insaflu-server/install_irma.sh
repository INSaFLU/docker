#!/bin/bash
# components/insaflu-server/install_irma.sh
# Creates the irma conda environment.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install IRMA"
conda create --name=irma -c conda-forge -c bioconda irma=1.2.0 --yes
