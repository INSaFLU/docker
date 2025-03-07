#!/usr/bin/bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate irma
export PATH=/software/irma:$PATH
IRMA $@
conda deactivate