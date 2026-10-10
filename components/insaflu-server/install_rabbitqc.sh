#!/bin/bash
# components/insaflu-server/install_rabbitqc.sh
# Builds RabbitQC 0.0.1 and installs the nanopore QC tools.
# The sed drops -static from the Makefile.

set -e

echo "Install RabbitQC"
cd /software
wget https://github.com/ZekunYin/RabbitQC/archive/v0.0.1.zip
unzip v0.0.1.zip
rm -f v0.0.1.zip
mv RabbitQC-0.0.1/ RabbitQC
cd RabbitQC
sed 's/ -static//' Makefile > temp.txt
mv -f temp.txt Makefile
make
uv pip install --system nanostat==1.5.0 nanofilt==2.7.1
