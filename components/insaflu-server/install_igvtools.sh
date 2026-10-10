#!/bin/bash
# components/insaflu-server/install_igvtools.sh
# Installs igvtools 2.3.98.

set -e

echo "Install igvtools"
cd /software
wget -O igvtools_2.3.98.zip https://data.broadinstitute.org/igv/projects/downloads/2.3/igvtools_2.3.98.zip
unzip igvtools_2.3.98.zip
rm igvtools_2.3.98.zip
