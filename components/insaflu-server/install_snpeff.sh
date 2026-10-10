#!/bin/bash
# components/insaflu-server/install_snpeff.sh
# Installs snpEff 4.1l. Version 4.3 has problems annotating INDELs.
# Writes into /software/snippy/bin, so snippy must be installed first.

set -e

echo "Install snpeff"
cd /software
wget --no-check-certificate -O snpEff_v4_1l_core.zip https://sourceforge.net/projects/snpeff/files/snpEff_v4_1l_core.zip/download
unzip snpEff_v4_1l_core.zip
rm snpEff_v4_1l_core.zip
cp /software/snpEff/scripts/snpEff /software/snippy/bin/snpEff
mv /tmp_install/software/snpEff/snpEff /software/snippy/bin/
chmod a+x /software/snippy/bin/snpEff
ln -s /software/snpEff/snpEff.jar /software/snippy/bin/snpEff.jar
