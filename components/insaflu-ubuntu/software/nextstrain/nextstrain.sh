#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate nextstrain
nextstrain $@
conda deactivate
