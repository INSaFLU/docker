#!/bin/bash
# components/insaflu-server/install_fastq_tools.sh
# Builds fastq-tools 0.8.

set -e

# requirement for fastq-tools
yum -y install pcre-devel

echo "Install fastq-tools"
cd /software
wget -O fastq-tools-0.8.tar.gz https://github.com/dcjones/fastq-tools/archive/v0.8.tar.gz
tar -zxvf fastq-tools-0.8.tar.gz
rm fastq-tools-0.8.tar.gz
mv fastq-tools-0.8 fastq-tools
cd /software/fastq-tools
./autogen.sh
./configure
make
