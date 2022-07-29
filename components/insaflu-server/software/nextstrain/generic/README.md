
# github.com/nextstrain/zika-tutorial

This is a modified version of the [Nextstrain](https://nextstrain.org) Zika tutorial. 

## Usage

Add reference.gb and reference.fasta in data folder

Add 'root = "reference_id"' at the top of Snakefile_base, creating the final Snakefile

Copy metadata.tsv and sequences.fasta to data folder

Run pipeline with:
```
nextstrain.sh build --native . --cores {cores}
```

