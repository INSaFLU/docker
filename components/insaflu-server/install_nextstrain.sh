#!/bin/bash
# components/insaflu-server/install_nextstrain.sh
# Creates the nextstrain conda environment and installs the wrapper scripts.

set -e

eval "$(/software/miniconda2/bin/conda shell.bash hook)"

echo "Install Nextstrain"
conda create --name=nextstrain -c conda-forge mamba python=3.9 --yes
conda activate nextstrain
mamba install -c bioconda -c conda-forge --yes nextstrain-cli=3.2.4 augur=15.0.2 auspice nextalign=1.11.0 nextclade=1.11.0 snakemake git epiweeks pangolin pangolearn
conda deactivate
mv /tmp_install/software/nextstrain/ /software/
chmod u+x /software/nextstrain/nextstrain.sh
chmod u+x /software/nextstrain/nextstrain_mpx.sh
chmod u+x /software/nextstrain/auspice_tree_to_table.sh
chmod u+x /software/nextstrain/nextstrain_snake.sh
chmod u+x /software/nextstrain/nextstrain_rsv.sh
chmod u+x /software/nextstrain/scripts/auspice_tree_to_table.py
