#!/usr/bin/env bash
eval "$(/software/extra_software/miniconda/bin/conda shell.bash hook)"
conda activate nextstrain
export PATH=/software/nextstrain/binaries_2.0/:$PATH
nextstrain $@
conda deactivate
