#!/bin/bash
# components/insaflu-server/install_spades.sh
# Builds SPAdes 3.11.1 from source: on some hosts, Windows WSL2 among them,
# the precompiled binary does not work.

set -e

echo "Install spades"
cd /software
wget https://github.com/ablab/spades/releases/download/v3.11.1/SPAdes-3.11.1.tar.gz
tar -xzf SPAdes-3.11.1.tar.gz
rm SPAdes-3.11.1.tar.gz
mv SPAdes-3.11.1 SPAdes-3.11.1-Linux
cd SPAdes-3.11.1-Linux
sh spades_compile.sh
sed s'~#!/usr/bin/env python~#!/usr/bin/env python3~' bin/spades.py > bin/spades_temp.py
mv bin/spades_temp.py bin/spades.py
chmod a+x bin/spades.py
