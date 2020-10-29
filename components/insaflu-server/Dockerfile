FROM centos:7
MAINTAINER Miguel Pinheiro, monsantopinheiro@gmail.com

# version
ADD VERSION .

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="0.0.1-beta" \
      pt.insa.insaflu.release-date="2020-04-01"

# Install package dependencies
RUN yum -y install epel-release
RUN yum -y install gdal gdal-devel dos2unix parallel postgis postgresql-devel postgresql-client httpd httpd-tools httpd-devel mod_wsgi bash file binutils bgzip2 gzip git unzip wget java perl perl-devel perl-Time-Piece perl-XML-Simple perl-Digest-MD5 perl-CPAN perl-Module-Build perl-File-Slurp perl-Test* python3 python3-pip gcc zlib-devel bzip2-devel xz-devel python3-devel cmake cmake3 gcc-c++ autoconf automake libtool which https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-1.x86_64.rpm

#### create a apache
# Create a group and user to run insaflu
ARG APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER}

### general software
#RUN mkdir /software

### install EMBOSS and bioperl
RUN mkdir -p /root/.cpan/CPAN
COPY configs/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
ARG PERL_MM_USE_DEFAULT=1
ARG PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
RUN cpan CJFIELDS/BioPerl-1.6.924.tar.gz

### EMBOSS-6.6.0
RUN mkdir -p /software/extra_software
WORKDIR /software/extra_software
COPY software/EMBOSS-6.6.0/EMBOSS-6.6.0.tar.gz /software/extra_software
RUN tar -zxvf EMBOSS-6.6.0.tar.gz
WORKDIR /software/extra_software/EMBOSS-6.6.0
RUN ./configure --without-x; make; make install;
RUN ln -s /usr/local/bin/seqret /usr/bin/seqret
WORKDIR /software/extra_software
RUN rm -rf /software/extra_software/*

### web site
RUN mkdir /insaflu_web
WORKDIR /insaflu_web
RUN pip3 install Cython
RUN git clone https://github.com/INSaFLU/INSaFLU.git
WORKDIR /insaflu_web/INSaFLU
RUN pip3 install -r requirements.txt
RUN pip3 install mod_wsgi-standalone
RUN rm /etc/httpd/modules/mod_wsgi.so
RUN ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so

RUN mkdir /insaflu_web/INSaFLU/env
## is going to be linked in "/insaflu_web/INSaFLU/env"
COPY configs/insaflu.env /insaflu_web/INSaFLU/.env
RUN chown -R ${APP_USER}:${APP_USER} *; mkdir /var/log/insaFlu

### apache server
RUN usermod -a -G ${APP_USER} apache
COPY configs/insaflu.conf /etc/httpd/conf.d
RUN rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf; echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf
RUN sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp
RUN mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf

#### SGE
ARG SGE_ROOT=/opt/sge
RUN groupadd -g 58 gridware; useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin; chmod 0755 ${SGE_ROOT}
RUN mkdir /insaflu_sge_source
WORKDIR /insaflu_sge_source
RUN wget https://arc.liv.ac.uk/downloads/SGE/releases/8.1.9/sge_8.1.9.tar.xz; tar -xJvf sge_8.1.9.tar.xz
RUN yum -y install csh hwloc-devel openssl-devel pam-devel libXt-devel motif motif-devel readline-devel
WORKDIR /insaflu_sge_source/sge-8.1.9/source
RUN scripts/bootstrap.sh -no-java -no-jni
RUN ./aimk -no-java -no-jni
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
###           All software
### abricate
WORKDIR /software
RUN git clone --branch v0.8.4 https://github.com/tseemann/abricate.git

### bamtools
RUN git clone --branch v2.5.1 https://github.com/pezmaster31/bamtools.git
WORKDIR /software/bamtools
RUN mkdir build
WORKDIR /software/bamtools/build
RUN cmake3 ..; make

### FastQC
RUN mkdir -p /software/FastQC/0.11.9
WORKDIR /software/FastQC/0.11.9
RUN wget -O fastqc_v0.11.9.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
RUN unzip fastqc_v0.11.9.zip; rm fastqc_v0.11.9.zip
RUN chmod a+x /software/FastQC/0.11.9/FastQC/fastqc

### fastq-tools
WORKDIR /software
RUN wget -O fastq-tools-0.8.tar.gz https://github.com/dcjones/fastq-tools/archive/v0.8.tar.gz
RUN tar -zxvf fastq-tools-0.8.tar.gz; rm fastq-tools-0.8.tar.gz; mv fastq-tools-0.8 fastq-tools
WORKDIR /software/fastq-tools
RUN ./autogen.sh && ./configure && make

### fasttree
WORKDIR /software
RUN mkdir fasttree
WORKDIR /software/fasttree
RUN wget -O FastTreeDbl http://microbesonline.org/fasttree/FastTreeDbl; chmod a+x /software/fasttree/FastTreeDbl

### freebayes
WORKDIR /software
RUN git clone --branch v1.2.0 --recursive https://github.com/ekg/freebayes.git
WORKDIR /software/freebayes
RUN make

### igvtools
WORKDIR /software
RUN wget -O igvtools_2.3.98.zip https://data.broadinstitute.org/igv/projects/downloads/2.3/igvtools_2.3.98.zip
RUN unzip igvtools_2.3.98.zip; rm igvtools_2.3.98.zip

### mafft
WORKDIR /software
RUN wget -O mafft-7.453-without-extensions-src.tgz https://mafft.cbrc.jp/alignment/software/mafft-7.453-without-extensions-src.tgz
RUN tar -zxvf mafft-7.453-without-extensions-src.tgz; rm mafft-7.453-without-extensions-src.tgz
WORKDIR /software/mafft-7.453-without-extensions/core
RUN make clean; make

### mauve
WORKDIR /software
RUN wget -O mauve_linux_snapshot_2015-02-13.tar.gz http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64/mauve_linux_snapshot_2015-02-13.tar.gz
RUN tar -zxvf mauve_linux_snapshot_2015-02-13.tar.gz; rm mauve_linux_snapshot_2015-02-13.tar.gz; mv mauve_snapshot_2015-02-13 mauve
RUN ln -s /software/mauve/linux-x64/progressiveMauve /software/mauve/progressiveMauve

### prokka
WORKDIR /software
RUN git clone --branch v1.12 https://github.com/tseemann/prokka.git
# install a fresh a tbl2asn
WORKDIR /software/extra_software;
RUN wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz; gunzip tbl2asn.gz; chmod +x tbl2asn; mv tbl2asn /software/prokka/binaries/linux

### final scripts
WORKDIR /software/
RUN mkdir scripts
COPY software/scripts /software/scripts

### snippy
WORKDIR /software
RUN git clone --branch v3.2 https://github.com/tseemann/snippy.git
RUN ln -s snippy/perl5 perl5
COPY software/snippy/snippy-vcf_to_tab_add_freq /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq
COPY software/snippy/snippy-vcf_to_tab_add_freq_and_evidence /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq_and_evidence
COPY software/snippy/msa_masker.py /software/snippy/bin/
RUN chmod a+x /software/snippy/bin/msa_masker.py
RUN sed 's/,     4.3, qr/,     4.1, qr/' /software/snippy/bin/snippy > /software/snippy/bin/snippy_temp
RUN mv snippy/bin/snippy_temp snippy/bin/snippy; chmod a+x /software/snippy/bin/snippy

# make several links
RUN ln -s /software/snippy/binaries/linux/bgzip /software/snippy/bin/bgzip
RUN ln -s /software/snippy/binaries/linux/bwa /software/snippy/bin/bwa
RUN ln -s /software/freebayes/bin/freebayes /software/snippy/bin/freebayes
RUN ln -s /software/snippy/binaries/linux/samtools /software/snippy/bin/samtools
RUN ln -s /software/snippy/binaries/linux/tabix /software/snippy/bin/tabix
RUN ln -s /software/snippy/binaries/linux/vcfallelicprimitives /software/snippy/bin/vcfallelicprimitives

RUN ln -s /software/snippy/binaries/noarch/fasta_generate_regions.py /software/snippy/bin/fasta_generate_regions.py
RUN ln -s /software/snippy/binaries/noarch/freebayes-parallel /software/snippy/bin/freebayes-parallel
RUN ln -s /software/snippy/binaries/noarch/vcf-consensus /software/snippy/bin/vcf-consensus
RUN ln -s /software/snippy/binaries/noarch/vcffirstheader /software/snippy/bin/vcffirstheader
RUN ln -s /software/snippy/binaries/noarch/parallel /software/snippy/bin/parallel

RUN ln -s /software/freebayes/bin/freebayes /usr/local/bin/freebayes
RUN ln -s /software/snippy/binaries/noarch/vcffirstheader /usr/local/bin/vcffirstheader
RUN ln -s /software/snippy/binaries/linux/vcfstreamsort /usr/local/bin/vcfstreamsort
RUN ln -s /software/snippy/binaries/linux/vcfuniq /usr/local/bin/vcfuniq

### snpEff; version 4.3 has some problems in annotation of INDELs
WORKDIR /software
RUN wget -O snpEff_v4_1l_core.zip https://sourceforge.net/projects/snpeff/files/snpEff_v4_1l_core.zip/download
RUN unzip snpEff_v4_1l_core.zip; rm snpEff_v4_1l_core.zip
RUN cp /software/snpEff/scripts/snpEff /software/snippy/bin/snpEff
COPY software/snpEff/snpEff /software/snippy/bin/snpEff
RUN chmod a+x /software/snippy/bin/snpEff
RUN ln -s /software/snpEff/snpEff.jar /software/snippy/bin/snpEff.jar

### spades 
WORKDIR /software
RUN wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz
RUN tar -xzf SPAdes-3.11.1-Linux.tar.gz; rm SPAdes-3.11.1-Linux.tar.gz
RUN sed s'~#!/usr/bin/env python~#!/usr/bin/env python3~' SPAdes-3.11.1-Linux/bin/spades.py > SPAdes-3.11.1-Linux/bin/spades_temp.py
RUN mv SPAdes-3.11.1-Linux/bin/spades_temp.py SPAdes-3.11.1-Linux/bin/spades.py; chmod a+x SPAdes-3.11.1-Linux/bin/spades.py

### trimmomatic
WORKDIR /software
RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip
RUN unzip Trimmomatic-0.39.zip
RUN rm Trimmomatic-0.39.zip
RUN mkdir -p trimmomatic/classes
RUN ln -s /software/Trimmomatic-0.39/trimmomatic-0.39.jar /software/trimmomatic/classes/trimmomatic.jar

COPY software /software
WORKDIR /software
RUN chown -R ${APP_USER}:${APP_USER} *
RUN rm -rf /var/lib/apt/lists/*
###           End software
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
RUN sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh; rm entrypoint_original.sh
RUN chmod a+x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


