#!/bin/bash
# components/insaflu-server/install_freebayes.sh
# Builds freebayes v1.2.0 with its submodules.

set -e

echo "Install freebayes"
cd /software
git clone --branch v1.2.0 --recursive https://github.com/ekg/freebayes.git
cd freebayes
make
