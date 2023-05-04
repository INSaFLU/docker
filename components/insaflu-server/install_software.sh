#!/bin/bash
set -e

### install bioperl
echo "Install bioperl"
mkdir -p /root/.cpan/CPAN && mv /tmp_install/configs/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
cpan -f -i CJFIELDS/BioPerl-1.6.924.tar.gz
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
cd /software && wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-0.39.zip && unzip Trimmomatic-0.39.zip && rm Trimmomatic-0.39.zip && mkdir -p trimmomatic/classes && mkdir -p trimmomatic/adapters
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
#echo "Install pangolin"
#sh /tmp_install/software/install_pangolin.sh
#if [ $? -ne 0 ]; then
#    echo "Error installing pangolin"
#    exit 1
#fi

###          Update pangolin
#mv /tmp_install/software/update_pangolin.sh /software && chmod a+x /software/update_pangolin.sh

# flye
#echo "Install flye"
#eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=flye -c conda-forge -c anaconda -c bioconda flye=2.9.1 && mv /tmp_install/software/flye/ /software/ && chmod u+x /software/flye/flye.sh 
#if [ $? -ne 0 ]; then
#    echo "Error installing flye"
#    exit 1
#fi


## kallisto (for televir)
echo "Install kallisto"
cd /software && wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz && tar -xvf kallisto_linux-v0.43.1.tar.gz && rm kallisto_linux-v0.43.1.tar.gz
if [ $? -ne 0 ]; then
    echo "Error installing kallisto"
    exit 1
fi


