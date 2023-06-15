-------INSaFLU Align2pheno Module-------

Align2pheno v1.1.5
The align2pheno module in INSaFLU performs the screening of genetic features potentially linked to specific phenotypes. Aln2pheno currently screens SARS-CoV-2 Spike amino acid alignments in each SARS-CoV-2 project against two default "genotype-phenotype" databases: the COG-UK Antigenic mutations and the Pokay Database (detailed below). Align2pheno reports the repertoire of mutations of interest per sequence and their potential impact on phenotype.

Caution: INSaFLU only runs the align2pheno module over Spike amino acid sequences with less than 10% of undefined amino acids (i.e., positions below the coverage cut-off; labelled as “X” in the protein alignments/sequences).

DATABASES

Spike_EpitopeResidues_Carabelli_2023 database

Description: Database of Spike amino acid mutations in epitope residues listed in Carabelli et al, 2023, 21(3), 162–177, Nat Rev Microbiol (https://doi.org/10.1038/s41579-022-00841-7), Figure 1.

Source:

https://github.com/insapathogenomics/algn2pheno/blob/main/tests/DB_SARS_CoV_2_Spike_EpitopeResidues_Carabelli_2023_NatRevMic_Fig1.tsv 

Prepated and adapted for align2pheno based on https://doi.org/10.1038/s41579-022-00841-7


Pokay Database

Description: Database of Spike amino acid mutations adapted from the curated database available through the tool Pokay, which includes a comprehensive list of SARS-CoV-2 mutations, and their associated functional impact (e.g., vaccine efficacy, pharmaceutical effectiveness, etc.) collected from literature. Made available by the CSM Center for Health Genomics and Informatics, University of Calgary.

Source: https://github.com/nodrogluap/pokay
Downloaded and adapted for align2pheno on 2022-07-28

COG-UK Antigenic Mutations Database

Description: Database of Spike amino acid mutations adapted from the COG-UK Antigenic Mutations Database that includes “Spike amino acid replacements reported to confer antigenic change relevant to antibodies, detected in the UK data. The table lists those mutations in the spike gene identified in the UK dataset that have been associated with weaker neutralisation of the virus by convalescent plasma from people who have been infected with SARS-CoV-2, and/or monoclonal antibodies (mAbs) that recognise the SARS-CoV-2 spike protein.” Made available by the COVID-19 Genomics UK (COG-UK) Consortium through the COG-UK/Mutation Explorer.

Source: https://sars2.cvr.gla.ac.uk/cog-uk/
Downloaded and adapted for align2pheno on 2022-10-20

TOOL

Align2pheno code: https://github.com/insapathogenomics/algn2pheno
Align2pheno adapted databases available at: https://github.com/INSaFLU/INSaFLU/tree/master/static/db/Alignment2phenotype

DESCRIPTION OF OUTPUTS

_final_report.tsv: provides the list of samples analysed, their repertoire of "Flagged mutations" (i.e., database mutations that were detected in the alignment), the "phenotypes" that are supported by those mutations of interest and the list of "All mutations" detected for each sequence.

_flagged_mutation_report.tsv: "Flagged mutation" binary matrix for all sequences and the "associated" phenotypes.


