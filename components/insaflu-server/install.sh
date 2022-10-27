#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
yum -y install epel-release
yum -y install gdal gdal-devel dos2unix parallel postgis postgresql-devel postgresql-client httpd httpd-tools httpd-devel mod_wsgi bash file binutils gzip git unzip wget java perl perl-devel perl-Time-Piece perl-XML-Simple perl-Digest-MD5 perl-CPAN perl-Module-Build perl-File-Slurp perl-Test* python3 python3-pip gcc zlib-devel bzip2-devel xz-devel python3-devel cmake cmake3 gcc-c++ autoconf bgzip2 bzip2 automake libtool which https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-1.x86_64.rpm
if [ $? -ne 0 ]; then
    echo "Error installing system packages"
    exit 1
fi

#### create a apache
# Create a group and user to run insaflu
export APP_USER=flu_user
useradd -ms /bin/bash ${APP_USER}

### general software on /software

# Miniconda2: will be useful to install several softwares
mkdir -p /software/extra_software && cd /software/extra_software && wget https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh && sh Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /software/miniconda2/ && rm Miniconda2-4.7.12.1-Linux-x86_64.sh

# Aln2pheno
echo "Install Aln2Pheno"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=aln2pheno python=3 && conda activate aln2pheno && pip install algn2pheno==1.1.4 --quiet && conda deactivate && mv /tmp_install/software/aln2pheno /software/ && chmod u+x /software/aln2pheno/aln2pheno.sh
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


### install bioperl
echo "Install bioperl"
mkdir -p /root/.cpan/CPAN && mv /tmp_install/configs/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
cpan CJFIELDS/BioPerl-1.6.924.tar.gz
if [ $? -ne 0 ]; then
    echo "Error installing Bioperl"
    exit 1
fi

### Install EMBOSS
echo "Install EMBOSS 6.6.0"
mv /tmp_install/software/EMBOSS-6.6.0/EMBOSS-6.6.0.tar.gz /software/extra_software && cd /software/extra_software && tar -zxvf EMBOSS-6.6.0.tar.gz && cd /software/extra_software/EMBOSS-6.6.0 && ./configure --without-x && make && make install && ln -s /usr/local/bin/seqret /usr/bin/seqret && rm -rf /software/extra_software/EMBOSS-6.6.0.tar.gz
if [ $? -ne 0 ]; then
    echo "Error installing EMBOSS"
    exit 1
fi

### web site
echo "Setup website code"
mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone https://github.com/INSaFLU/INSaFLU.git && cd INSaFLU && git checkout tags/v1.6.0 && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu
#mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone --branch develop https://github.com/INSaFLU/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu
if [ $? -ne 0 ]; then
    echo "Error installing INSaFLU base"
    exit 1
fi

### apache server
echo "Setup Apache httpd"
usermod -a -G ${APP_USER} apache && mv /tmp_install/configs/insaflu.conf /etc/httpd/conf.d && rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf && echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf && sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp && mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf
if [ $? -ne 0 ]; then
    echo "Error installing apache"
    exit 1
fi

### Temp Directory /usr/lib/tmpfiles.d
mv /tmp_install/configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf

#### SGE
echo "Setup SGE job queuing"
export SGE_ROOT=/opt/sge
groupadd -g 58 gridware && useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin && chmod 0755 ${SGE_ROOT} && mkdir /insaflu_sge_source && cd /insaflu_sge_source 
wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz; tar -zxvf sge-8.1.9.tar.gz 
yum -y install csh hwloc-devel openssl-devel pam-devel libXt-devel motif motif-devel readline-devel
cd /insaflu_sge_source/sge-8.1.9/source && sh scripts/bootstrap.sh -no-java -no-jni && ./aimk -no-java -no-jni
echo Y | /insaflu_sge_source/sge-8.1.9/source/scripts/distinst -local -all -noexit
if [ $? -ne 0 ]; then
    echo "Error installing SGE"
    exit 1
fi
#copy default files to the queues
mv /tmp_install/sge_default/default/ ${SGE_ROOT}/ && chown -R sgeadmin:gridware ${SGE_ROOT} && mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/ && mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/ && mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/ && mv /tmp_install/sge_default/root.cshrc /root/.cshrc && chmod a+x /etc/profile.d/sun-grid-engine.sh && rm -rf /insaflu_sge_source*
export PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:${PATH}"

### END SGE

##########################
###           All software
### abricate
echo "Install abricate"
cd /software && git clone --branch v0.8.4 https://github.com/tseemann/abricate.git
if [ $? -ne 0 ]; then
    echo "Error installing abricate"
    exit 1
fi

### bamtools
echo "Install bamtools"
git clone --branch v2.5.1 https://github.com/pezmaster31/bamtools.git && cd bamtools && mkdir build && cd build && cmake3 .. && make
if [ $? -ne 0 ]; then
    echo "Error installing bamtools"
    exit 1
fi

### FastQC
echo "Install FastQC"
mkdir -p /software/FastQC/0.11.9 && cd /software/FastQC/0.11.9 && wget --no-check-certificate -O fastqc_v0.11.9.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && unzip fastqc_v0.11.9.zip; rm fastqc_v0.11.9.zip && chmod a+x /software/FastQC/0.11.9/FastQC/fastqc
if [ $? -ne 0 ]; then
    echo "Error installing FastQC"
    exit 1
fi

### fastq-tools
echo "Install fastq-tools"
cd /software && wget -O fastq-tools-0.8.tar.gz https://github.com/dcjones/fastq-tools/archive/v0.8.tar.gz && tar -zxvf fastq-tools-0.8.tar.gz; rm fastq-tools-0.8.tar.gz; mv fastq-tools-0.8 fastq-tools && cd /software/fastq-tools && ./autogen.sh && ./configure && make
if [ $? -ne 0 ]; then
    echo "Error installing fastq-tools"
    exit 1
fi

### fasttree
echo "Install fasttree"
mkdir -p /software/fasttree && cd /software/fasttree && wget -O FastTreeDbl http://microbesonline.org/fasttree/FastTreeDbl && chmod a+x /software/fasttree/FastTreeDbl
if [ $? -ne 0 ]; then
    echo "Error installing fasttree"
    exit 1
fi

### freebayes
echo "Install freebayes"
cd /software && git clone --branch v1.2.0 --recursive https://github.com/ekg/freebayes.git && cd freebayes && make
if [ $? -ne 0 ]; then
    echo "Error installing freebayes"
    exit 1
fi

### igvtools
echo "Install igvtools"
cd /software && wget -O igvtools_2.3.98.zip https://data.broadinstitute.org/igv/projects/downloads/2.3/igvtools_2.3.98.zip && unzip igvtools_2.3.98.zip && rm igvtools_2.3.98.zip
if [ $? -ne 0 ]; then
    echo "Error installing igvtools"
    exit 1
fi

### mafft
echo "Install mafft"
cd /software && wget --no-check-certificate -O mafft-7.453-without-extensions-src.tgz https://mafft.cbrc.jp/alignment/software/mafft-7.453-without-extensions-src.tgz && tar -zxvf mafft-7.453-without-extensions-src.tgz && rm mafft-7.453-without-extensions-src.tgz && cd /software/mafft-7.453-without-extensions/core && make clean && make
if [ $? -ne 0 ]; then
    echo "Error installing mafft"
    exit 1
fi

### mauve
echo "Install mauve"
cd /software && wget --no-check-certificate -O mauve_linux_snapshot_2015-02-13.tar.gz http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64/mauve_linux_snapshot_2015-02-13.tar.gz && tar -zxvf mauve_linux_snapshot_2015-02-13.tar.gz && rm mauve_linux_snapshot_2015-02-13.tar.gz && mv mauve_snapshot_2015-02-13 mauve && ln -s /software/mauve/linux-x64/progressiveMauve /software/mauve/progressiveMauve
if [ $? -ne 0 ]; then
    echo "Error installing mauve"
    exit 1
fi

### prokka
echo "Install prokka"
cd /software && git clone --branch v1.12 https://github.com/tseemann/prokka.git && cd extra_software && wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz && gunzip tbl2asn.gz && chmod +x tbl2asn && mv tbl2asn /software/prokka/binaries/linux
if [ $? -ne 0 ]; then
    echo "Error installing prokka"
    exit 1
fi

### final scripts
mv /tmp_install/software/scripts /software/

### snippy
echo "Install snippy"
cd /software && git clone --branch v3.2 https://github.com/tseemann/snippy.git && ln -s snippy/perl5 perl5 && mv /tmp_install/software/snippy/snippy-vcf_to_tab_add_freq /software/snippy/bin/ && chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq
mv /tmp_install/software/snippy/snippy-vcf_to_tab_add_freq_and_evidence /software/snippy/bin/ && chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq_and_evidence
mv /tmp_install/software/snippy/msa_masker.py /software/snippy/bin/ && chmod a+x /software/snippy/bin/msa_masker.py
sed 's/,     4.3, qr/,     4.1, qr/' /software/snippy/bin/snippy > /software/snippy/bin/snippy_temp && mv snippy/bin/snippy_temp snippy/bin/snippy && chmod a+x /software/snippy/bin/snippy
if [ $? -ne 0 ]; then
    echo "Error installing snippy"
    exit 1
fi

# make several links
echo "Create snippy links"
sh /tmp_install/software/make_links_snippy.sh
if [ $? -ne 0 ]; then
    echo "Error making snippy links"
    exit 1
fi

### snpEff; version 4.3 has some problems in annotation of INDELs
echo "Install snpeff"
cd /software && wget --no-check-certificate -O snpEff_v4_1l_core.zip https://sourceforge.net/projects/snpeff/files/snpEff_v4_1l_core.zip/download && unzip snpEff_v4_1l_core.zip; rm snpEff_v4_1l_core.zip && cp /software/snpEff/scripts/snpEff /software/snippy/bin/snpEff
mv /tmp_install/software/snpEff/snpEff /software/snippy/bin/ && chmod a+x /software/snippy/bin/snpEff && ln -s /software/snpEff/snpEff.jar /software/snippy/bin/snpEff.jar
if [ $? -ne 0 ]; then
    echo "Error installing snpEff"
    exit 1
fi

### spades : it is better to recompile as in some instances (eg. windows WSL2) the precompiled does not work
echo "Install spades"
cd /software && wget https://github.com/ablab/spades/releases/download/v3.11.1/SPAdes-3.11.1.tar.gz && tar -xzf SPAdes-3.11.1.tar.gz && rm SPAdes-3.11.1.tar.gz && mv SPAdes-3.11.1 SPAdes-3.11.1-Linux && cd SPAdes-3.11.1-Linux && sh spades_compile.sh && sed s'~#!/usr/bin/env python~#!/usr/bin/env python3~' bin/spades.py > bin/spades_temp.py && mv bin/spades_temp.py bin/spades.py &&  chmod a+x bin/spades.py
if [ $? -ne 0 ]; then
    echo "Error installing SPAdes"
    exit 1
fi

### trimmomatic
echo "Install trimmomatic"
cd /software && wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip && unzip Trimmomatic-0.39.zip && rm Trimmomatic-0.39.zip && mkdir -p trimmomatic/classes && mkdir -p trimmomatic/adapters
mv /tmp_install/software/trimmomatic/adapters/* /software/Trimmomatic-0.39/adapters/ && ln -s /software/Trimmomatic-0.39/trimmomatic-0.39.jar /software/trimmomatic/classes/trimmomatic.jar && ln -s /software/Trimmomatic-0.39/adapters/* /software/trimmomatic/adapters
if [ $? -ne 0 ]; then
    echo "Error installing Trimmomatic"
    exit 1
fi

### 
cd /software && wget https://github.com/ZekunYin/RabbitQC/archive/v0.0.1.zip && unzip v0.0.1.zip && rm -f v0.0.1.zip && mv RabbitQC-0.0.1/ RabbitQC && cd RabbitQC && sed 's/ -static//' Makefile > temp.txt && mv -f temp.txt Makefile && make && pip3 install nanostat==1.5.0 && pip3 install nanofilt==2.7.1

## medaka
echo "Install medaka"
sh /tmp_install/software/install_soft_medaka.sh
if [ $? -ne 0 ]; then
    echo "Error installing Medaka"
    exit 1
fi

## pangolin
echo "Install pangolin"
sh /tmp_install/software/install_pangolin.sh
if [ $? -ne 0 ]; then
    echo "Error installing pangolin"
    exit 1
fi

###          Update pangolin
mv /tmp_install/software/update_pangolin.sh /software && chmod a+x /software/update_pangolin.sh

## Canu
echo "Install canu"
mkdir -p /software/canu && cd /software/canu && wget https://github.com/marbl/canu/releases/download/v2.1.1/canu-2.1.1.Linux-amd64.tar.xz && tar -xJvf canu-2.1.1.Linux-amd64.tar.xz && rm -f canu-2.1.1.Linux-amd64.tar.xz
if [ $? -ne 0 ]; then
    echo "Error installing canu"
    exit 1
fi

# flye
echo "Install flye"
eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=flye -c conda-forge -c anaconda -c bioconda flye=2.9.1 && mv /tmp_install/software/flye/ /software/ && chmod u+x /software/flye/flye.sh 
if [ $? -ne 0 ]; then
    echo "Error installing flye"
    exit 1
fi

###  END software
##########################

### several commands
export PATH="/insaflu_web/commands/:${PATH}" && mv /tmp_install/commands /insaflu_web/ && chmod a+x /insaflu_web/commands/*

cd /software && chown -R ${APP_USER}:${APP_USER} * && rm -rf /var/lib/apt/lists/*

## entry point
cd / && mv /tmp_install/entrypoint.sh entrypoint_original.sh && sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh && rm entrypoint_original.sh && chmod a+x entrypoint.sh

## delete the temporary folder
rm -R -f /tmp_install/

