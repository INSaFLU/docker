#!/bin/bash
# components/insaflu-server/install_label.sh
# Downloads LABEL for Nextstrain (avian flu) into /software/nextstrain.
# CDC retired the wonder.cdc.gov download; the identical file is the v0.6.4
# release asset on GitHub.
# See: https://github.com/INSaFLU/docker/issues/46

set -e

echo "Install LABEL for Nextstrain"
cd /software/nextstrain
wget https://github.com/CDCgov/label/releases/download/v0.6.4/flu-amd-LABEL-202209.zip
unzip flu-amd-LABEL-202209.zip
rm -f flu-amd-LABEL-202209.zip
