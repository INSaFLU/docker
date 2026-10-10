#!/bin/bash
# components/insaflu-server/install_nextstrain_dengue.sh
# Creates the nextstrain_dengue conda environment and installs nextclade 3.
# Pins: CentOS 7 has glibc 2.17. augur 23.1.1 constrains pandas/numpy/scipy to
# 1.*, which still publish manylinux_2_17 wheels, so nothing is built from
# source. cvxopt has no wheel at all and links against LAPACK and BLAS.
# See:      https://github.com/INSaFLU/docker/issues/48
# See also: https://github.com/INSaFLU/docker/issues/50
# See also: https://github.com/INSaFLU/docker/issues/52
# See also: https://github.com/INSaFLU/docker/issues/55
# See also: https://github.com/INSaFLU/docker/issues/58
# See also: https://github.com/INSaFLU/docker/issues/60

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Nextstrain Dengue"
conda create --name=nextstrain_dengue -c conda-forge mamba python=3.10 --yes
conda activate nextstrain_dengue
mamba install -c conda-forge -c bioconda mafft iqtree seqkit --yes
export CVXOPT_LAPACK_LIB_DIR=/usr/lib64
export CVXOPT_BLAS_LIB_DIR=/usr/lib64
export CFLAGS="-std=gnu99"
pip install nextstrain-cli==8.5.4
pip install numpy==1.26.4
pip install pandas==1.5.3
pip install pillow==12.2.0
pip install matplotlib==3.9.4
pip install phylo-treetime==0.11.5
pip install nextstrain-augur==23.1.1
pip install snakemake==7.32.2
pip install cvxopt==1.3.2
pip install pulp==2.7
pip install epiweeks==2.4.0
curl -fsSL "https://github.com/nextstrain/nextclade/releases/download/3.10.2/nextclade-x86_64-unknown-linux-gnu" -o "/software/nextclade"
chmod +x /software/nextclade
mv /software/nextclade /software/miniconda2/envs/nextstrain_dengue/bin/
ln -s /software/miniconda2/envs/nextstrain_dengue/bin/nextclade /software/miniconda2/envs/nextstrain_dengue/bin/nextclade3
conda deactivate
