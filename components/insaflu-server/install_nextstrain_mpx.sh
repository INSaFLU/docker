#!/bin/bash
# components/insaflu-server/install_nextstrain_mpx.sh
# Creates the nextstrain_mpx conda environment.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Nextstrain MPX"
conda create --name=nextstrain_mpx -c conda-forge mamba python=3.8 --yes
conda activate nextstrain_mpx
mamba install -c bioconda -c conda-forge --yes biopython=1.74 nextstrain-cli=4.2.0 augur=17.1.0 auspice=2.38.0 nextalign=2.5.0 nextclade=2.5.0 snakemake git epiweeks=2.1.4 pangolin=2.4.2 pangolearn=2021.05.27 seqkit=2.3.0
conda deactivate
