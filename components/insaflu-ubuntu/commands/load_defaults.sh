#!/bin/bash
#SBATCH --export=ALL
#$ --job-name=update_files
#$ --partition=all.q
#$ --ntasks=1
#$ --output=/data/tmp/%x_%j.out
#$ --error=/data/tmp/error_files.out

set -e

echo "---> Load default files  ..."
if [ ! -e "/software/prokka/db/hmm/HAMAP.hmm.h3f" ]; then
    echo "---> Set prokka default databases  ..."
    ## for fresh prokka instalations
    /software/prokka/bin/prokka --setupdb
fi
cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py load_default_files;
cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py load_default_settings;

## update pangolin if necessary
cd /insaflu_web/INSaFLU; /usr/bin/python3 manage.py update_pangolin;

