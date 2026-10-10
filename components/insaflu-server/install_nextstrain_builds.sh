#!/bin/bash
# components/insaflu-server/install_nextstrain_builds.sh
# Clones the INSaFLU Nextstrain build repositories into /software/nextstrain.

set -e

echo "Install Nextstrain builds"
cd /software/nextstrain/
git clone https://github.com/INSaFLU/nextstrain_builds.git
cd nextstrain_builds
rm -R -f ncov
git clone https://github.com/INSaFLU/dengue.git
git clone https://github.com/INSaFLU/mpox.git
git clone https://github.com/INSaFLU/ncov.git
