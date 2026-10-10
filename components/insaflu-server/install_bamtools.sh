#!/bin/bash
# components/insaflu-server/install_bamtools.sh
# Builds bamtools v2.5.1.
# The cd is explicit: in the monolithic script this block inherited
# /software as the working directory from the abricate block above it.

set -e

echo "Install bamtools"
cd /software
git clone --branch v2.5.1 https://github.com/pezmaster31/bamtools.git
cd bamtools
mkdir build
cd build
cmake3 ..
make
