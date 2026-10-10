#!/bin/bash
# components/insaflu-server/install_mafft.sh
# Builds mafft 7.453 without extensions.

set -e

echo "Install mafft"
cd /software
wget --no-check-certificate -O mafft-7.453-without-extensions-src.tgz https://mafft.cbrc.jp/alignment/software/mafft-7.453-without-extensions-src.tgz
tar -zxvf mafft-7.453-without-extensions-src.tgz
rm mafft-7.453-without-extensions-src.tgz
cd /software/mafft-7.453-without-extensions/core
make clean
make
