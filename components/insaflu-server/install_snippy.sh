#!/bin/bash
# components/insaflu-server/install_snippy.sh
# Clones snippy v3.2 and installs the patched helpers shipped in the build
# context.

set -e

echo "Install snippy"
cd /software
git -c advice.detachedHead=false clone --depth 1 --branch v3.2 https://github.com/tseemann/snippy.git
ln -s snippy/perl5 perl5
mv /tmp_install/software/snippy/ivar_variants_to_vcf.pl /software/snippy/bin/
chmod a+x /software/snippy/bin/ivar_variants_to_vcf.pl
mv /tmp_install/software/snippy/snippy-vcf_to_tab_add_freq /software/snippy/bin/
chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq
mv /tmp_install/software/snippy/snippy-vcf_to_tab_add_freq_and_evidence /software/snippy/bin/
chmod a+x /software/snippy/bin/snippy-vcf_to_tab_add_freq_and_evidence
mv /tmp_install/software/snippy/msa_masker.py /software/snippy/bin/
chmod a+x /software/snippy/bin/msa_masker.py
mv /tmp_install/software/snippy/ivar /software/snippy/binaries/linux/
chmod a+x /software/snippy/binaries/linux/ivar
mv /tmp_install/software/snippy/bedtools /software/snippy/binaries/linux/
chmod a+x /software/snippy/binaries/linux/bedtools
mv /tmp_install/software/snippy/run_check_consensus /software/snippy/binaries/linux/
chmod a+x /software/snippy/binaries/linux/run_check_consensus
mv /tmp_install/software/snippy/snippy /software/snippy/bin/
chmod a+x /software/snippy/bin/snippy
