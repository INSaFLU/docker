#!/bin/bash
# components/insaflu-server/install_uv.sh
# Installs the uv resolver under /usr/local/bin.
# The gnu build needs at most GLIBC_2.17, which is what CentOS 7 has.

set -e

mkdir -p /software/extra_software
cd /software/extra_software
curl -fsSL -O https://github.com/astral-sh/uv/releases/download/0.12.7/uv-x86_64-unknown-linux-gnu.tar.gz
tar -xzf uv-x86_64-unknown-linux-gnu.tar.gz
mv uv-x86_64-unknown-linux-gnu/uv /usr/local/bin/uv
chmod +x /usr/local/bin/uv
rm -rf uv-x86_64-unknown-linux-gnu uv-x86_64-unknown-linux-gnu.tar.gz
