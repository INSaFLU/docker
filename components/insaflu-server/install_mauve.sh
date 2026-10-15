#!/bin/bash
# components/insaflu-server/install_mauve.sh
# Installs the 2015-02-13 mauve snapshot.

set -e

echo "Install mauve"
cd /software
wget --no-check-certificate -O mauve_linux_snapshot_2015-02-13.tar.gz http://darlinglab.org/mauve/snapshots/2015/2015-02-13/linux-x64/mauve_linux_snapshot_2015-02-13.tar.gz
tar -zxvf mauve_linux_snapshot_2015-02-13.tar.gz
rm mauve_linux_snapshot_2015-02-13.tar.gz
mv mauve_snapshot_2015-02-13 mauve
ln -s /software/mauve/linux-x64/progressiveMauve /software/mauve/progressiveMauve
