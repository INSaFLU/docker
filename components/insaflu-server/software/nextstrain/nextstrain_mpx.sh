#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate nextstrain
export PATH=/software/nextstrain/binaries_2.0/:$PATH
nextstrain $@
conda deactivate
