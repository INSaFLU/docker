#!/usr/bin/env bash
eval "$(/software/extra_software/miniconda/bin/conda shell.bash hook)"
conda activate nextstrain
nextstrain $@
conda deactivate
