#!/usr/bin/bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate irmaenv
export PATH=/software/flumut/:$PATH
flutmut $@
conda deactivate