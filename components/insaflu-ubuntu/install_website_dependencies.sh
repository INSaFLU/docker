#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
#apt-get -y install epel-release
#apt-get -y install epel-release
apt update -y

apt install git curl wget libbz2-dev libffi-dev libreadline-dev libssl-dev -y
if [ $? -ne 0 ]; then
    echo "Error installing system packages"
    exit 1
fi
apt install -y python3-pip
#exec "$SHELL"

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc


~/.pyenv/bin/pyenv install 3.8.3
~/.pyenv/bin/pyenv global 3.8.3

### install blast+ v2.7.1
echo "Install blast+ v2.7.1"
mkdir -p /software/blast+/2.7.1 && cd /software/blast+/2.7.1 && wget --no-check-certificate https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-x64-linux.tar.gz && tar -zxvf ncbi-blast-2.7.1+-x64-linux.tar.gz && rm ncbi-blast-2.7.1+-x64-linux.tar.gz
### add blast+ to path
echo 'export PATH="/software/blast+/2.7.1/ncbi-blast-2.7.1+/bin:${PATH}"' >> ~/.bashrc
if [ $? -ne 0 ]; then
    echo "Error installing blast+ v2.7.1"
    exit 1
fi

