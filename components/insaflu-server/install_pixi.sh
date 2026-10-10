#!/bin/bash
# components/insaflu-server/install_pixi.sh
# Installs the pixi resolver under /usr/local/bin.
# The musl build is static, so it does not care what glibc CentOS 7 has.

set -e

mkdir -p /software/extra_software
cd /software/extra_software
curl -fsSL -O https://github.com/prefix-dev/pixi/releases/download/v0.78.0/pixi-x86_64-unknown-linux-musl.tar.gz
tar -xzf pixi-x86_64-unknown-linux-musl.tar.gz
mv pixi /usr/local/bin/pixi
chmod +x /usr/local/bin/pixi
rm -f pixi-x86_64-unknown-linux-musl.tar.gz
