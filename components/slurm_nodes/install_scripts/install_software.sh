#!/bin/bash
set -e

### install basic 
apt-get update
apt-get install bc samtools parallel meson ninja-build libvcflib-tools vcftools -y

### any2fasta - necessary for abricate
echo "Install any2fasta"
git clone https://github.com/tseemann/any2fasta.git
cp any2fasta/any2fasta /usr/local/bin


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

### fastq-tools
echo "Install PCRE"
apt install libpcre3 libpcre3-dev -y

### Install EMBOSS
echo "Install EMBOSS 6.6.0"
#mv /tmp_install/software/EMBOSS-6.6.0/EMBOSS-6.6.0.tar.gz /software/extra_software && cd /software/extra_software && tar -zxvf EMBOSS-6.6.0.tar.gz
#cd /software/extra_software/EMBOSS-6.6.0 && ./configure --without-x
#/sbin/ldconfig
#make
#make install
#ln -s /usr/local/bin/seqret /usr/bin/seqret && rm -rf /software/extra_software/EMBOSS-6.6.0.tar.gz
apt install emboss -y
if [ $? -ne 0 ]; then
    echo "Error installing EMBOSS"
    exit 1
fi


# make several links
echo "Create snippy links"
sh /tmp_install/software/make_links.sh
if [ $? -ne 0 ]; then
    echo "Error making snippy links"
    exit 1
fi