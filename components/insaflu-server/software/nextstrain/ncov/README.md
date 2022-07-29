
# nextstrain/ncov

This is a modified version of the [Nextstrain](https://nextstrain.org) SARS-CoV-2 build. 

## Usage

Add data/references_sequences.fasta to the end of sequences.fasta in the data folder

Add data/references_metadata.tsv to the end of metadata.tsv in the data folder

Add include.txt with all identifiers in the data folder

Run pipeline with:
```
nextstrain.sh build --native . --cores {cores} --configfile ./config/config.yaml
```

