
#### Analysis
Our bioinformatic processing workflow can be found at [github.com/nextstrain/monkeypox](https://github.com/nextstrain/monkeypox) and includes:
- sequence alignment by [nextalign](https://docs.nextstrain.org/projects/nextclade/en/stable/user/nextalign-cli.html)
- masking several regions of the genome, including the first 1500 and last 7000 base pairs and a repetitive region of variable length
- phylogenetic reconstruction using [IQTREE](http://www.iqtree.org/)
- ancestral state reconstruction and temporal inference using [TreeTime](https://github.com/neherlab/treetime)
- clade assignment via [clade definitions defined here](https://github.com/nextstrain/monkeypox/blob/master/config/clades.tsv), to label broader MPXV clades 1, 2 and 3 and to label hMPXV1 lineages A, A.1, A.1.1, etc... (last update 20/10/2022)

