#!/bin/bash
# components/insaflu-server/install_medaka.sh
# Runs the medaka venv build and installs the binaries shipped in the build
# context.

set -e

# prerequsite for compiling medaka
yum -y install ncurses-devel

echo "Install medaka"
sh /tmp_install/software/install_soft_medaka.sh
mv /tmp_install/software/medaka/bwa /software/medaka/bin/
chmod a+x /software/medaka/bin/bwa
mv /tmp_install/software/medaka/ivar /software/medaka/bin/
chmod a+x /software/medaka/bin/ivar
mv /tmp_install/software/medaka/bedtools /software/medaka/bin/
chmod a+x /software/medaka/bin/bedtools
mv /tmp_install/software/medaka/run_check_consensus /software/medaka/bin/
chmod a+x /software/medaka/bin/run_check_consensus
mv /tmp_install/software/medaka/medaka_consensus /software/medaka/bin/
chmod a+x /software/medaka/bin/medaka_consensus
