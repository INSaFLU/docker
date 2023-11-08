#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate nextstrain_mpx
export PATH=/software/nextstrain/tsv-utils/:$PATH
nextstrain $@
conda deactivate
