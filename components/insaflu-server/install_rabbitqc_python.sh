#!/bin/bash
# components/insaflu-server/install_rabbitqc_python.sh
# The python tools RabbitQC's nanopore path needs. Separate from the compile
# because these write to the system python, not /software/RabbitQC, so they
# cannot live in the rabbitqc build stage.

set -e

echo "Install NanoStat and NanoFilt"
uv pip install --system nanostat==1.5.0 nanofilt==2.7.1
