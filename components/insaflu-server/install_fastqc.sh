#!/bin/bash
# components/insaflu-server/install_fastqc.sh
# Installs FastQC 0.11.9.

set -e

echo "Install FastQC"
mkdir -p /software/FastQC/0.11.9
cd /software/FastQC/0.11.9
wget --no-check-certificate -O fastqc_v0.11.9.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
rm fastqc_v0.11.9.zip
chmod a+x /software/FastQC/0.11.9/FastQC/fastqc
