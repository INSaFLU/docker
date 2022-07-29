FROM centos:7
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"

# version
ADD VERSION .

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="0.0.1-beta" \
      pt.insa.insaflu.release-date="2020-04-01"

# Install package dependencies
RUN yum -y install epel-release
RUN yum -y install gdal gdal-devel dos2unix parallel postgis postgresql-devel postgresql-client httpd httpd-tools httpd-devel mod_wsgi bash file binutils gzip git unzip wget java perl perl-devel perl-Time-Piece perl-XML-Simple perl-Digest-MD5 perl-CPAN perl-Module-Build perl-File-Slurp perl-Test* python3 python3-pip gcc zlib-devel bzip2-devel xz-devel python3-devel cmake cmake3 gcc-c++ autoconf bgzip2 bzip2 automake libtool which https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-1.x86_64.rpm

#### create a apache
# Create a group and user to run insaflu
ARG APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER}

### general software on /software

# Miniconda2: will be useful to install several softwares
RUN mkdir -p /software/extra_software && cd /software/extra_software && wget https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh && sh Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /software/miniconda2/ && rm Miniconda2-4.7.12.1-Linux-x86_64.sh

# Aln2pheno
RUN eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=aln2pheno python=3 && conda activate aln2pheno && pip install algn2pheno==1.1.4 --quiet && conda deactivate
COPY software/aln2pheno /software/

# Nextstrain
RUN eval "$(/software/miniconda2/bin/conda shell.bash hook)" && conda create --name=nextstrain && conda activate nextstrain && conda install -c conda-forge mamba --yes && conda config --env --add channels defaults && conda config --env --add channels bioconda && conda config --env --add channels conda-forge && conda config --env --set channel_priority strict && mamba install --yes nextstrain-cli augur auspice nextalign nextclade snakemake git epiweeks pangolin pangolearn && conda deactivate
COPY software/nextstrain /software/
RUN mkdir -p /software/nextstrain/binaries_2.0 && cd /software/nextstrain/binaries_2.0 && wget https://github.com/nextstrain/nextclade/releases/download/2.0.0/nextalign-x86_64-unknown-linux-musl && ln -s nextalign-x86_64-unknown-linux-musl nextalign && wget https://github.com/nextstrain/nextclade/releases/download/2.0.0/nextclade-x86_64-unknown-linux-musl && ln -s nextclade-x86_64-unknown-linux-musl nextclade

### install EMBOSS and bioperl
RUN mkdir -p /root/.cpan/CPAN
COPY configs/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
ARG PERL_MM_USE_DEFAULT=1
ARG PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
RUN cpan CJFIELDS/BioPerl-1.6.924.tar.gz

### EMBOSS-6.6.0
WORKDIR /software/extra_software
COPY software/EMBOSS-6.6.0/EMBOSS-6.6.0.tar.gz /software/extra_software
RUN tar -zxvf EMBOSS-6.6.0.tar.gz
WORKDIR /software/extra_software/EMBOSS-6.6.0
RUN ./configure --without-x && make && make install && ln -s /usr/local/bin/seqret /usr/bin/seqret
WORKDIR /software/extra_software
RUN rm -rf /software/extra_software/*

### web site
RUN mkdir /insaflu_web
WORKDIR /insaflu_web
RUN pip3 install Cython && git clone https://github.com/INSaFLU/INSaFLU.git
#RUN pip3 install Cython; git clone --branch develop https://github.com/INSaFLU/INSaFLU.git
WORKDIR /insaflu_web/INSaFLU
RUN pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir /insaflu_web/INSaFLU/env
## is going to be linked in "/insaflu_web/INSaFLU/env"
COPY configs/insaflu.env /insaflu_web/INSaFLU/.env
RUN chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu

### apache server
RUN usermod -a -G ${APP_USER} apache
COPY configs/insaflu.conf /etc/httpd/conf.d
RUN rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf && echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf && sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp && mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf

### Temp Directory /usr/lib/tmpfiles.d
COPY configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf

#### SGE
ARG SGE_ROOT=/opt/sge
RUN groupadd -g 58 gridware; useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin; chmod 0755 ${SGE_ROOT} && mkdir /insaflu_sge_source
WORKDIR /insaflu_sge_source
#RUN wget https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/sge_8.1.9.tar.xz; tar -xJvf sge_8.1.9.tar.xz
RUN wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz; tar -zxvf sge-8.1.9.tar.gz && yum -y install csh hwloc-devel openssl-devel pam-devel libXt-devel motif motif-devel readline-devel
WORKDIR /insaflu_sge_source/sge-8.1.9/source
RUN scripts/bootstrap.sh -no-java -no-jni && ./aimk -no-java -no-jni
#WORKDIR /insaflu_sge_source/sge-8.1.9/source/3rdparty/qtcsh/LINUXAMD64
#RUN cc -o tcsh  -O2 -Wstrict-prototypes -DLINUX -DLINUXAMD64 -DLINUXAMD64 -D_GNU_SOURCE -DGETHOSTBYNAME_R6 -DGETHOSTBYADDR_R8 -DTARGET_64BIT -DSGE_PQS_API -DSPOOLING_dynamic -DSECURE -DHAVE_HWLOC=1 -DNO_JNI -DCOMPILE_DC -D__SGE_COMPILE_WITH_GETTEXT__ -D__SGE_NO_USERMAPPING__ -U_GNU_SOURCE -Wno-error -DPROG_NAME='"qtcsh"' -DLINUXAMD64 -I. -I.. sh.o sh.dir.o sh.dol.o sh.err.o sh.exec.o sh.char.o sh.exp.o sh.file.o sh.func.o sh.glob.o sh.hist.o sh.init.o sh.lex.o sh.misc.o sh.parse.o sh.print.o sh.proc.o sh.sem.o sh.set.o sh.time.o glob.o mi.termios.o ma.setp.o vms.termcap.o tw.help.o tw.init.o tw.parse.o tw.spell.o tw.comp.o tw.color.o ed.chared.o ed.refresh.o ed.screen.o ed.init.o ed.inputl.o ed.defns.o ed.xmap.o ed.term.o tc.alloc.o tc.bind.o tc.const.o tc.defs.o tc.disc.o tc.func.o tc.nls.o tc.os.o tc.printf.o tc.prompt.o tc.sched.o tc.sig.o tc.str.o tc.vers.o tc.who.o  -lcrypt      -L../../../LINUXAMD64 -L.  -rdynamic -Wl,-rpath,\$ORIGIN/../../lib/lx-amd64  -lsge -lpthread -lssl -lcrypto   -luti -ldl -lm -lreadline -lncurses
#WORKDIR /insaflu_sge_source/sge-8.1.9/source
#RUN ./aimk -no-java -no-jni

# install SGE
RUN echo Y | /insaflu_sge_source/sge-8.1.9/source/scripts/distinst -local -all -noexit

#copy default files to the queues
RUN mkdir ${SGE_ROOT}/default
COPY sge_default/default ${SGE_ROOT}/default
RUN chown -R sgeadmin:gridware ${SGE_ROOT}
COPY sge_default/sun-grid-engine.sh /etc/profile.d/
COPY sge_default/sgeexecd.p6444 /etc/init.d/
COPY sge_default/sgemaster.p6444 /etc/init.d/
COPY sge_default/root.cshrc /root/.cshrc
RUN chmod a+x /etc/profile.d/sun-grid-engine.sh; rm -rf /insaflu_sge_source*
ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:${PATH}"
### END SGE

##########################
###          Update pangolin
COPY software/update_pangolin.sh /software
RUN chmod a+x /software/update_pangolin.sh

##########################
###           All software
### abricate
RUN cd /software && git clone --branch v0.8.4 https://github.com/tseemann/abricate.git

### bamtools && FastQC
RUN git clone --branch v2.5.1 https://github.com/pezmaster31/bamtools.git && cd bamtools && mkdir build && cd build && cmake3 .. && make

### FastQC
RUN mkdir -p /software/FastQC/0.11.9 && cd /software/FastQC/0.11.9 && wget --no-check-certificate -O fastqc_v0.11.9.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && unzip fastqc_v0.11.9.zip; rm fastqc_v0.11.9.zip && chmod a+x /software/FastQC/0.11.9/FastQC/fastqc

### fastq-tools
RUN cd /software && wget -O fastq-tools-0.8.tar.gz https://github.com/dcjones/fastq-tools/archive/v0.8.tar.gz && tar -zxvf fastq-tools-0.8.tar.gz; rm fastq-tools-0.8.tar.gz; mv fastq-tools-0.8 fastq-tools && cd /software/fastq-tools && ./autogen.sh && ./configure && make

### fasttree
RUN mkdir -p /software/fasttree && cd /software/fasttree && wget -O FastTreeDbl http://microbesonline.org/fasttree/FastTreeDbl && chmod a+x /software/fasttree/FastTreeDbl

### freebayes
RUN cd /software && git clone --branch v1.2.0 --recursive https://github.com/ekg/freebayes.git && cd freebayes && make

### igvtools
RUN cd /software && wget -O igvtools_2.3.98.zip https://data.broadinstitute.org/igv/projects/downloads/2.3/igvtools_2.3.98.zip && unzip igvtools_2.3.98.zip; rm igvtools_2.3.98.zip

### mafft
RUN cd /software && wget --no-check-certificate -O mafft-7.453-without-extensions-src.tgz https://mafft.cbrc.jp/alignment/software/mafft-7.453-without-extensions-src.tgz && tar -zxvf mafft-7.453-without-extensions-src.tgz; rm mafft-7.453-without-extensions-src.tgz && cd /software/mafft-7.453-without-extensions/core && make clean && make

### mauve
RUN cd /software && wget --no-check-certificate -O mauve_linux_snapshot_2015-02-13.tar.gz http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64/mauve_linux_snapshot_2015-02-13.tar.gz && tar -zxvf mauve_linux_snapshot_2015-02-13.tar.gz && rm mauve_linux_snapshot_2015-02-13.tar.gz && mv mauve_snapshot_2015-02-13 mauve && ln -s /software/mauve/linux-x64/progressiveMauve /software/mauve/progressiveMauve

### prokka
RUN cd /software && git clone --branch v1.12 https://github.com/tseemann/prokka.git && cd extra_software && wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz && gunzip tbl2asn.gz && chmod +x tbl2asn && mv tbl2asn /software/prokka/binaries/linux

### dehumanizer
# WORKDIR /software
# RUN mkdir dehumanizer
# WORKDIR /software/dehumanizer
# RUN wget https://sam.s3.climb.ac.uk/dehumanizer/20200421/GCA_000786075.2_hs38d1_genomic.mmi
# RUN wget https://sam.s3.climb.ac.uk/dehumanizer/20200421/GCF_000001405.39_GRCh38.p13_genomic.mmi
# RUN wget https://sam.s3.climb.ac.uk/dehumanizer/20200421/ipd-imgt-3_39_0.hla_gen.mmi

### final scripts
RUN mkdir -p /software/scripts
COPY software/scripts /software/scripts

### snippy
WORKDIR /software
RUN git clone --branch v3.2 https://github.com/tseemann/snippy.git; ln -s snippy/perl5 perl5
COPY software/snippy/snippy-vcf_to_tab_add_freq /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq
COPY software/snippy/snippy-vcf_to_tab_add_freq_and_evidence /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq_and_evidence
COPY software/snippy/msa_masker.py /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/msa_masker.py; sed 's/,     4.3, qr/,     4.1, qr/' /software/snippy/bin/snippy > /software/snippy/bin/snippy_temp && mv snippy/bin/snippy_temp snippy/bin/snippy && chmod a+x /software/snippy/bin/snippy

# make several links
COPY software/make_links_snippy.sh /software
RUN /software/make_links_snippy.sh
# RUN ln -s /software/snippy/binaries/linux/bgzip /software/snippy/bin/bgzip
# RUN ln -s /software/snippy/binaries/linux/bwa /software/snippy/bin/bwa
# RUN ln -s /software/freebayes/bin/freebayes /software/snippy/bin/freebayes
# RUN ln -s /software/snippy/binaries/linux/samtools /software/snippy/bin/samtools
# RUN ln -s /software/snippy/binaries/linux/tabix /software/snippy/bin/tabix
# RUN ln -s /software/snippy/binaries/linux/vcfallelicprimitives /software/snippy/bin/vcfallelicprimitives

# RUN ln -s /software/snippy/binaries/noarch/fasta_generate_regions.py /software/snippy/bin/fasta_generate_regions.py
# RUN ln -s /software/snippy/binaries/noarch/freebayes-parallel /software/snippy/bin/freebayes-parallel
# RUN ln -s /software/snippy/binaries/noarch/vcf-consensus /software/snippy/bin/vcf-consensus
# RUN ln -s /software/snippy/binaries/noarch/vcffirstheader /software/snippy/bin/vcffirstheader
# RUN ln -s /software/snippy/binaries/noarch/parallel /software/snippy/bin/parallel

# RUN ln -s /software/freebayes/bin/freebayes /usr/local/bin/freebayes
# RUN ln -s /software/snippy/binaries/noarch/vcffirstheader /usr/local/bin/vcffirstheader
# RUN ln -s /software/snippy/binaries/linux/vcfstreamsort /usr/local/bin/vcfstreamsort
# RUN ln -s /software/snippy/binaries/linux/vcfuniq /usr/local/bin/vcfuniq

### snpEff; version 4.3 has some problems in annotation of INDELs
WORKDIR /software
RUN wget --no-check-certificate -O snpEff_v4_1l_core.zip https://sourceforge.net/projects/snpeff/files/snpEff_v4_1l_core.zip/download && unzip snpEff_v4_1l_core.zip; rm snpEff_v4_1l_core.zip && cp /software/snpEff/scripts/snpEff /software/snippy/bin/snpEff
COPY software/snpEff/snpEff /software/snippy/bin/snpEff
RUN chmod a+x /software/snippy/bin/snpEff && ln -s /software/snpEff/snpEff.jar /software/snippy/bin/snpEff.jar

### spades 
WORKDIR /software
RUN cd /software && wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz && tar -xzf SPAdes-3.11.1-Linux.tar.gz && rm SPAdes-3.11.1-Linux.tar.gz && sed s'~#!/usr/bin/env python~#!/usr/bin/env python3~' SPAdes-3.11.1-Linux/bin/spades.py > SPAdes-3.11.1-Linux/bin/spades_temp.py && mv SPAdes-3.11.1-Linux/bin/spades_temp.py SPAdes-3.11.1-Linux/bin/spades.py &&  chmod a+x SPAdes-3.11.1-Linux/bin/spades.py

### trimmomatic
WORKDIR /software
### version from GIT is 0.33
# RUN yum -y install java-devel
# RUN git clone https://github.com/timflutre/trimmomatic.git
# WORKDIR /software/trimmomatic
# RUN make
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip && unzip Trimmomatic-0.39.zip && rm Trimmomatic-0.39.zip && mkdir -p trimmomatic/classes && mkdir -p trimmomatic/adapters
COPY software/trimmomatic/adapters/* /software/Trimmomatic-0.39/adapters/
RUN ln -s /software/Trimmomatic-0.39/trimmomatic-0.39.jar /software/trimmomatic/classes/trimmomatic.jar && ln -s /software/Trimmomatic-0.39/adapters/* /software/trimmomatic/adapters

COPY software /software
WORKDIR /software
RUN chown -R ${APP_USER}:${APP_USER} * && rm -rf /var/lib/apt/lists/*
###           End software
##########################

##########################
###   ONT software

### 
WORKDIR /software
RUN wget https://github.com/ZekunYin/RabbitQC/archive/v0.0.1.zip && unzip v0.0.1.zip && rm -f v0.0.1.zip && mv RabbitQC-0.0.1/ RabbitQC && cd RabbitQC && sed 's/ -static//' Makefile > temp.txt && mv -f temp.txt Makefile && make && pip3 install nanostat==1.5.0 && pip3 install nanofilt==2.7.1

## medaka
COPY software/install_soft_medaka.sh /software
RUN /software/install_soft_medaka.sh

## pangolin
COPY software/install_pangolin.sh /software
RUN /software/install_pangolin.sh

## Canu
RUN mkdir -p /software/canu && cd /software/canu && wget https://github.com/marbl/canu/releases/download/v2.1.1/canu-2.1.1.Linux-amd64.tar.xz && tar -xJvf canu-2.1.1.Linux-amd64.tar.xz && rm -f canu-2.1.1.Linux-amd64.tar.xz

###  END ONT software
##########################

### several commands
ARG COMMANDS_ROOT=/insaflu_web/commands
ENV PATH="${COMMANDS_ROOT}:${PATH}"
RUN mkdir ${COMMANDS_ROOT}
COPY commands /insaflu_web/commands
RUN chmod a+x /insaflu_web/commands/*

## entry point
WORKDIR /
COPY entrypoint.sh entrypoint_original.sh
RUN sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh && rm entrypoint_original.sh && chmod a+x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


