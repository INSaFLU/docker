#!/bin/bash
# components/insaflu-server/install_emboss.sh
# Builds EMBOSS 6.6.0 from the tarball shipped in the build context.

set -e

echo "Install EMBOSS 6.6.0"
mv /tmp_install/software/EMBOSS-6.6.0/EMBOSS-6.6.0.tar.gz /software/extra_software
cd /software/extra_software
tar -zxvf EMBOSS-6.6.0.tar.gz
cd /software/extra_software/EMBOSS-6.6.0
./configure --without-x --prefix=/software/emboss
make
make install
ln -s /software/emboss/bin/seqret /usr/bin/seqret
rm -rf /software/extra_software/EMBOSS-6.6.0.tar.gz
