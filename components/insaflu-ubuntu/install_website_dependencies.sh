#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
#apt-get -y install epel-release
#apt-get -y install epel-release
apt update -y

apt install git curl wget libbz2-dev libffi-dev libreadline-dev libsqlite3-dev liblzma-dev libssl-dev -y
if [ $? -ne 0 ]; then
    echo "Error installing system packages"
    exit 1
fi
apt install -y python3-pip
#exec "$SHELL"

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc

echo 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc


~/.pyenv/bin/pyenv install 3.8.3
~/.pyenv/bin/pyenv global 3.8.3

pip3 install Cython  mod_wsgi-standalone
