#!/bin/bash
# components/insaflu-server/install_raven.sh
# Creates the raven conda environment and installs the wrapper script.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install raven"
conda create --name=raven -c conda-forge -c bioconda raven-assembler=1.8.1 --yes
mv /tmp_install/software/raven/ /software/
chmod a+x /software/raven/raven.sh
