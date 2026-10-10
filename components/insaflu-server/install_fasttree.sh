#!/bin/bash
# components/insaflu-server/install_fasttree.sh
# Downloads the FastTreeDbl binary.

set -e

echo "Install fasttree"
mkdir -p /software/fasttree
cd /software/fasttree
wget -O FastTreeDbl http://microbesonline.org/fasttree/FastTreeDbl
chmod a+x /software/fasttree/FastTreeDbl
