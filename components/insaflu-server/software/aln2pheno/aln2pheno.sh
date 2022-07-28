#!/usr/bin/env bash
eval "$(/software/extra_software/miniconda/bin/conda shell.bash hook)"
conda activate aln2pheno
export PATH=/software/aln2pheno/:$PATH
algn2pheno $@
conda deactivate
