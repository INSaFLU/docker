# nextstrain.org/flu

This is a customized [Nextstrain](https://nextstrain.org) build for seasonal influenza viruses.
The original build is available online at [nextstrain.org/flu](https://nextstrain.org/flu).

At the moment, it limits the analysis to the HA segment, and does not perform fitness analysis.

The influenza virus output files have the wildcard set

`{lineage}_{segment}_{resolution}`

that currently use the following values:

* lineage: [`h3n2`, `h1n1pdm`, `vic`, `yam`]
* segment: [`ha`]
* resolution: [`6m`, `2y`, `3y`, `6y`, `12y`]

To run this customized build, copy sequences_{lineage}_ha.fasta and metadata_{lineage}_ha.tsv into the data folder and run:

```
nextstrain build targets/flu_{lineage}_ha_{resolution} --cores [nbr of threads]
```

[Nextstrain]: https://nextstrain.org
[augur]: https://github.com/nextstrain/augur
[auspice]: https://github.com/nextstrain/auspice
[snakemake cli]: https://snakemake.readthedocs.io/en/stable/executable.html#all-options
[nextstrain-cli]: https://github.com/nextstrain/cli
[nextstrain-cli README]: https://github.com/nextstrain/cli/blob/master/README.md
