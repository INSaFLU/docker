
# About

This is a generic [Nextstrain](https://nextstrain.org) build.

Visit [the workflow documentation](https://docs.nextstrain.org) for tutorials and reference material.

## Bioinformatics notes

This build requires a user-provided reference. To run the build we need to add in the data folder:
data/reference.fasta 
data/reference.gb
data/sequences.fasta
data/metadata.tsv

Then you need to copy Snakefile_base to Snakefile and change the "REFID" in the first line by the id of the reference (e.g SARS-CoV-2).

NOTE: This build currently does not work with multisegmented references. It also does not estimate a time tree.
