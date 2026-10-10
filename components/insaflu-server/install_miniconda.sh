#!/bin/bash
# components/insaflu-server/install_miniconda.sh
# Installs the Miniconda2 bootstrap under /software/miniconda2.
# All conda environments are installed by separate scripts.

set -e

### general software on /software

# Miniconda2: will be useful to install several softwares
mkdir -p /software/extra_software
cd /software/extra_software
wget https://repo.anaconda.com/miniconda/Miniconda2-4.7.12.1-Linux-x86_64.sh
sh Miniconda2-4.7.12.1-Linux-x86_64.sh -b -p /software/miniconda2/
rm Miniconda2-4.7.12.1-Linux-x86_64.sh
