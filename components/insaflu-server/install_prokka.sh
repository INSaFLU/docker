#!/bin/bash
# components/insaflu-server/install_prokka.sh
# Clones prokka v1.12 and installs the tbl2asn binary shipped in the build
# context.
#
# Upstream originally fetched tbl2asn from the NCBI anonymous ftp endpoint:
#   wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz
# That line is commented out here, but the same URL is still live in
# commands/update-tbl2asn, which is on the PATH and runs at runtime, not at
# build time. The endpoint now returns 550 file does not exist, so that
# command is broken.

set -e

echo "Install prokka"
cd /software
git -c advice.detachedHead=false clone --depth 1 --branch v1.12 https://github.com/tseemann/prokka.git
mv /tmp_install/software/prokka/tbl2asn /software/prokka/binaries/linux
chmod +x /software/prokka/binaries/linux/tbl2asn
