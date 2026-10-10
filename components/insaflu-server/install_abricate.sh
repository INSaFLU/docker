#!/bin/bash
# components/insaflu-server/install_abricate.sh
# Clones abricate v0.8.4 and installs the nextstrain database.

set -e

echo "Install abricate"
cd /software
git clone --branch v0.8.4 https://github.com/tseemann/abricate.git
mv /tmp_install/software/abricate/nextstrain /software/abricate/db/
