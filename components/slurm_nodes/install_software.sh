#!/bin/bash
set -e


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

# make several links
echo "Create snippy links"
sh /tmp_install/software/make_links.sh
if [ $? -ne 0 ]; then
    echo "Error making snippy links"
    exit 1
fi