#!/bin/bash
# components/insaflu-server/install_rabbitqc_compile.sh
# Compiles RabbitQC 0.0.1 into /software/RabbitQC. The -static flag is
# stripped from the Makefile because centos:7 has no static libstdc++.

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
