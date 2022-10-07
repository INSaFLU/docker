#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate nextstrain
export PATH=/software/nextstrain/scripts/:$PATH
auspice_tree_to_table.py $@
conda deactivate
