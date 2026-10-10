#!/bin/bash
# components/insaflu-server/install_trimmomatic.sh
# Installs Trimmomatic 0.39 and the adapters shipped in the build context.

set -e

echo "Install trimmomatic"
cd /software
wget https://github.com/usadellab/Trimmomatic/files/5854859/Trimmomatic-0.39.zip
unzip Trimmomatic-0.39.zip
rm Trimmomatic-0.39.zip
mkdir -p trimmomatic/classes
mkdir -p trimmomatic/adapters
mv /tmp_install/software/trimmomatic/adapters/* /software/Trimmomatic-0.39/adapters/
ln -s /software/Trimmomatic-0.39/trimmomatic-0.39.jar /software/trimmomatic/classes/trimmomatic.jar
ln -s /software/Trimmomatic-0.39/adapters/* /software/trimmomatic/adapters
