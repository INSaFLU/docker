#!/usr/bin/env bash
eval "$(/software/miniconda2/bin/conda shell.bash hook)"
conda activate aln2pheno
export PATH=/software/aln2pheno/:$PATH
algn2pheno $@
conda deactivate
