#!/bin/bash
# components/insaflu-server/install_nextstrain_rsv.sh
# Creates the nextstrain_rsv conda environment.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Nextstrain RSV"
conda create --name=nextstrain_rsv -c conda-forge mamba python=3.10 --yes
conda activate nextstrain_rsv
mamba install -c bioconda -c conda-forge --yes augur=20.0 auspice=2.42 nextalign=2.9.1 nextclade=2.9.1 snakemake git epiweeks=2.1.4
conda deactivate
