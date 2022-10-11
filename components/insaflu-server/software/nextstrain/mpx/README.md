# nextstrain.org/monkeypox

This is a customized [Nextstrain](https://nextstrain.org) build for monkeypox virus. 
This is based on the public build, visible at [nextstrain.org/monkeypox](https://nextstrain.org/monkeypox).

The lineages within the recent monkeypox outbreaks in humans are defined in a separate [lineage-designation repository](https://github.com/mpxv-lineages/lineage-designation).

## Usage

### Input data

Input sequences (sequences.fasta) and metadata (metadata.tsv) need to be added to the data folder.

### Run analysis pipeline

Run pipeline to produce "outbreak" tree for `/monkeypox/hmpxv1` with:

```bash
nextstrain build --cpus 1 . --configfile config/config_hmpxv1_big.yaml
```

Adjust the number of CPUs to what your machine has available if you want to perform alignment and tree building a bit faster.


