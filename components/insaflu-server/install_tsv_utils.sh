#!/bin/bash
# components/insaflu-server/install_tsv_utils.sh
# Installs TSV-Utils into /software/nextstrain/tsv-utils, used by Nextstrain MPXV.

set -e

echo "Install TSV-Utils for Nextstrain"
cd /software/nextstrain/
wget https://github.com/eBay/tsv-utils/releases/download/v2.2.0/tsv-utils-v2.2.0_linux-x86_64_ldc2.tar.gz
tar -xvf tsv-utils-v2.2.0_linux-x86_64_ldc2.tar.gz
mkdir tsv-utils
mv tsv-utils-v2.2.0_linux-x86_64_ldc2/bin/* tsv-utils
rm -R -f tsv-utils-v2.2.0_linux-x86_64_ldc2*
