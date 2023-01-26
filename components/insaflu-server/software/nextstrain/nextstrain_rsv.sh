#!/usr/bin/env bash
eval "$(/usr/local/software/insaflu/miniconda/bin/conda shell.bash hook)"
conda activate nextstrain_rsv
snakemake $@
conda deactivate
