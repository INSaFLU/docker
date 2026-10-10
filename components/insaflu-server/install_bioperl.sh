#!/bin/bash
# components/insaflu-server/install_bioperl.sh
# Installs BioPerl 1.6.924 from CPAN.

set -e

echo "Install bioperl"
mkdir -p /root/.cpan/CPAN
mv /tmp_install/configs/CPAN/MyConfig.pm /root/.cpan/CPAN/MyConfig.pm
export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"
cpan -f -i CJFIELDS/BioPerl-1.6.924.tar.gz
