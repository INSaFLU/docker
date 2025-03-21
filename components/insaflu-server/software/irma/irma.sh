#!/usr/bin/bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate irma
IRMA $@
conda deactivate
