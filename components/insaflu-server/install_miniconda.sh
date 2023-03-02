#!/bin/bash
set -e

### general software on /software

# Miniconda2: will be useful to install several softwares
mkdir -p /software/extra_software && cd /software/extra_software && wget https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh && sh Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /software/miniconda2/ && rm Miniconda2-4.7.12.1-Linux-x86_64.sh

# Aln2pheno
echo "Install Aln2Pheno"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=aln2pheno python=3 && conda activate aln2pheno && pip install algn2pheno==1.1.5 --quiet && conda deactivate && mv /tmp_install/software/aln2pheno /software/ && chmod u+x /software/aln2pheno/aln2pheno.sh
if [ $? -ne 0 ]; then
    echo "Error installing Aln2pheno"
    exit 1
fi

# Nextstrain
echo "Install Nextstrain"
conda create --name=nextstrain -c conda-forge mamba python=3.9 --yes && conda activate nextstrain && mamba install -c bioconda -c conda-forge --yes nextstrain-cli=3.2.4 augur=15.0.2 auspice nextalign=1.11.0 nextclade=1.11.0 snakemake git epiweeks pangolin pangolearn && conda deactivate && mv /tmp_install/software/nextstrain/ /software/ && chmod u+x /software/nextstrain/nextstrain.sh && chmod u+x /software/nextstrain/nextstrain_mpx.sh && chmod u+x /software/nextstrain/auspice_tree_to_table.sh
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain"
    exit 1
fi

# Nextstrain_rsv
echo "Install Nextstrain RSV"
conda create --name=nextstrain_rsv -c conda-forge mamba python=3.10 --yes && conda activate nextstrain_rsv && mamba install -c bioconda -c conda-forge --yes augur=20.0 auspice=2.42 nextalign=2.9.1 nextclade=2.9.1  snakemake git epiweeks=2.1.4
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain RSV"
    exit 1
fi

# Nextstrain_mpx
echo "Install Nextstrain MPX"
conda create --name=nextstrain_mpx -c conda-forge mamba python=3.8 --yes && conda activate nextstrain_mpx && mamba install -c bioconda -c conda-forge --yes biopython=1.74 nextstrain-cli=4.2.0 augur=17.1.0 auspice=2.38.0 nextalign=2.5.0 nextclade=2.5.0 snakemake git epiweeks=2.1.4 pangolin=2.4.2 pangolearn=2021.05.27 seqkit=2.3.0 && conda deactivate
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain MPX"
    exit 1
fi

# TSV-Utils for Nextstrain
echo "Install TSV-Utils for Nextstrain"
cd /software/nextstrain/ && wget https://github.com/eBay/tsv-utils/releases/download/v2.2.0/tsv-utils-v2.2.0_linux-x86_64_ldc2.tar.gz && tar -xvf tsv-utils-v2.2.0_linux-x86_64_ldc2.tar.gz && mkdir tsv-utils && mv tsv-utils-v2.2.0_linux-x86_64_ldc2/bin/* tsv-utils && rm -R -f tsv-utils-v2.2.0_linux-x86_64_ldc2* 
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain MPX"
    exit 1
fi

# Nextstrain builds
cd /software/nextstrain/ && git clone https://github.com/INSaFLU/nextstrain_builds.git
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain builds"
    exit 1
fi

# Pangolin (TODO to replace previous installation)
#cd /softwar && mkdir pangolin
#conda create -n pangolin -c conda-forge python=3.8 mamba
#conda activate pangolin
#mamba install -c conda-forge -c bioconda pangolin=4.2


