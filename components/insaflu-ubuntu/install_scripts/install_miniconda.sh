#!/bin/bash
set -e

### general software on /software

# Miniconda2: will be useful to install several softwares
mkdir -p /software/extra_software && cd /software/extra_software && wget https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh && sh Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /software/miniconda2/ && rm Miniconda2-4.7.12.1-Linux-x86_64.sh

# iVar environment
echo "Install iVar"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=ivar -c conda-forge -c bioconda ivar=1.4.2 bedtools=2.31.0 bwa=0.7.17
if [ $? -ne 0 ]; then
    echo "Error installing iVar"
    exit 1
fi

# Aln2pheno
echo "Install Aln2Pheno"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=aln2pheno python=3 && conda activate aln2pheno && pip install algn2pheno==1.1.5 --quiet && conda deactivate && mv /tmp_install/software/aln2pheno /software/ && chmod u+x /software/aln2pheno/aln2pheno.sh
if [ $? -ne 0 ]; then
    echo "Error installing Aln2pheno"
    exit 1
fi

# FluMut
echo "Install FluMut"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=flumut -c conda-forge -c bioconda flumut=0.6.3
if [ $? -ne 0 ]; then
    echo "Error installing FluMut"
    exit 1
fi

# IRMA
echo "Install IRMA"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=irma -c conda-forge -c bioconda irma=1.2.0
if [ $? -ne 0 ]; then
    echo "Error installing IRMA"
    exit 1
fi

# Nextstrain
echo "Install Nextstrain"
conda create --name=nextstrain -c conda-forge mamba python=3.9 --yes && conda activate nextstrain && mamba install -c bioconda -c conda-forge --yes nextstrain-cli=3.2.4 augur=15.0.2 auspice nextalign=1.11.0 nextclade=1.11.0 snakemake git epiweeks pangolin pangolearn && conda deactivate && mv /tmp_install/software/nextstrain/ /software/ && chmod u+x /software/nextstrain/nextstrain.sh && chmod u+x /software/nextstrain/nextstrain_mpx.sh && chmod u+x /software/nextstrain/auspice_tree_to_table.sh && chmod u+x /software/nextstrain/nextstrain_snake.sh && chmod u+x /software/nextstrain/nextstrain_rsv.sh && chmod u+x /software/nextstrain/scripts/auspice_tree_to_table.py && conda deactivate
if [ $? -ne 0 ]; then
    echo "Error installing Nextstrain"
    exit 1
fi

# LABEL for Nextstrain (avian flu)
#cd /software/nextstrain && wget https://wonder.cdc.gov/amd/flu/label/flu-amd-LABEL-202209.zip && unzip flu-amd-LABEL-202209.zip && rm -f flu-amd-LABEL-202209.zip
#if [ $? -ne 0 ]; then
#    echo "Error installing LABEL for Nextstrain"
#    exit 1
#fi

# Nextstrain_rsv
echo "Install Nextstrain RSV"
conda create --name=nextstrain_rsv -c conda-forge mamba python=3.10 --yes && conda activate nextstrain_rsv && mamba install -c bioconda -c conda-forge --yes augur=20.0 auspice=2.42 nextalign=2.9.1 nextclade=2.9.1  snakemake git epiweeks=2.1.4 && conda deactivate
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

# TSV-Utils for Nextstrain_MPXV
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

# Pangolin
mv /tmp_install/software/update_pangolin.sh /software && chmod a+x /software/update_pangolin.sh && mv /tmp_install/software/pangolin /software/ && conda create --name=pangolin -c conda-forge python=3.8 mamba --yes && conda activate pangolin && mamba install -c conda-forge -c bioconda pangolin=4.2 --yes && chmod u+x /software/pangolin/pangolin.sh  && conda deactivate
if [ $? -ne 0 ]; then
    echo "Error installing Pangolin"
    exit 1
fi

# raven
echo "Install raven"
conda create --name=raven -c conda-forge  -c bioconda raven-assembler=1.8.1 && mv /tmp_install/software/raven/ /software/ && chmod a+x /software/raven/raven.sh 
if [ $? -ne 0 ]; then
    echo "Error installing raven"
    exit 1
fi
