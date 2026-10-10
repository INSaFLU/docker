#!/bin/bash
# components/insaflu-server/install_pangolin.sh
# Creates the pangolin conda environment and installs the wrapper scripts.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Pangolin"
mv /tmp_install/software/update_pangolin.sh /software
chmod a+x /software/update_pangolin.sh
mv /tmp_install/software/pangolin /software/
conda create --name=pangolin -c conda-forge python=3.8 mamba --yes
conda activate pangolin
mamba install -c conda-forge -c bioconda pangolin=4.2 --yes
chmod u+x /software/pangolin/pangolin.sh
conda deactivate
