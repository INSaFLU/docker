#!/bin/bash
# components/insaflu-server/install_aln2pheno.sh
# Creates the aln2pheno conda environment and installs the wrapper script.
# python=3.9 is pinned: python=3 now resolves to 3.10, for which greenlet has
# no wheel here, and greenlet 3.x is C++11 which gcc 4.8.5 cannot compile.
# See: https://github.com/INSaFLU/docker/issues/44

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Aln2Pheno"
conda create --name=aln2pheno python=3.9 --yes
conda activate aln2pheno
pip install algn2pheno==1.1.5 --quiet
conda deactivate
mv /tmp_install/software/aln2pheno /software/
chmod u+x /software/aln2pheno/aln2pheno.sh
