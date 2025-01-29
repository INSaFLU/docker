#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate flumut
export PATH=/software/flumut/:$PATH
flutmut $@
conda deactivate