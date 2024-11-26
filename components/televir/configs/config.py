#!/usr/bin/python
##
# replace the variables bellow with paths in your system. Beware of permissions.

SOURCE = (
    # path to miniconda3 executable.
    "/opt/conda/etc/profile.d/conda.sh"
)
# /home/bioinf/Desktop/METAGEN/depo
# path to the directory where the databases will be stored.
HOME = "/televir/mngs_benchmark/"
# path to the directory where the environments will be stored.
ENVDIR = "/televir/mngs_benchmark/mngs_environments/"
# technology used to generate the database and deployment files. options: "illumina" or "nanopore".
TECH = "nanopore"
# path to the taxdump.tar.gz file.
TAXDUMP = "/opt/taxdump.tar.gz"
ENV = "/home/bioinf/Desktop/CODE/TELEVIR/.venv"
UPDATE = False
