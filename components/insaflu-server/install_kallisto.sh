#!/bin/bash
# components/insaflu-server/install_kallisto.sh
# Installs kallisto 0.43.1, used by TELEVIR.

set -e

echo "Install kallisto"
cd /software
wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz
tar -xvf kallisto_linux-v0.43.1.tar.gz
rm kallisto_linux-v0.43.1.tar.gz
