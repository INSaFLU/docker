# components/insaflu-server/Dockerfile
# INSaFLU built from source, CentOS 7, python 3.6.8 throughout.
# Each script is copied immediately before the RUN that consumes it, together
# with the data it moves out of /tmp_install. A single COPY of the whole build
# context would make every edit invalidate every install step below it.
# Config files land last: they change most often and nothing above needs them.
# Tools that only compile and install into their own directory build in their
# own stage, in parallel: emboss (own prefix /software/emboss), bamtools,
# fastq-tools, mafft, spades, rabbitqc, sge. RabbitQC's stage carries the
# compile only: its nanostat and nanofilt pip installs stay in the main stage
# because they write to the system python. SGE's stage carries the compile
# into /opt/sge; the sgeadmin account and queue configuration land in the main
# stage via install_sge_configure.sh. Build one stage alone with --target <name>.
# fork: github.com/georgemarselis-nvi/insaflu-docker branch nvi-install

FROM centos:7 AS emboss

RUN mkdir -p /tmp_install /software/extra_software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY software/EMBOSS-6.6.0/ /tmp_install/software/EMBOSS-6.6.0/
COPY install_emboss.sh /tmp_install/
RUN sh /tmp_install/install_emboss.sh

FROM centos:7 AS bamtools

RUN mkdir -p /tmp_install /software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_bamtools.sh /tmp_install/
RUN sh /tmp_install/install_bamtools.sh

FROM centos:7 AS fastq-tools

RUN mkdir -p /tmp_install /software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_fastq-tools.sh /tmp_install/
RUN sh /tmp_install/install_fastq-tools.sh

FROM centos:7 AS mafft

RUN mkdir -p /tmp_install /software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_mafft.sh /tmp_install/
RUN sh /tmp_install/install_mafft.sh

FROM centos:7 AS spades

RUN mkdir -p /tmp_install /software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_spades.sh /tmp_install/
RUN sh /tmp_install/install_spades.sh

FROM centos:7 AS rabbitqc

RUN mkdir -p /tmp_install /software

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_rabbitqc_compile.sh /tmp_install/
RUN sh /tmp_install/install_rabbitqc_compile.sh

FROM centos:7 AS sge

RUN mkdir -p /tmp_install /opt/sge

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_sge_compile.sh /tmp_install/
RUN sh /tmp_install/install_sge_compile.sh

FROM centos:7
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"

# version
ADD VERSION .

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="1.7.0-beta" \
      pt.insa.insaflu.release-date="2023-06-13"

RUN mkdir -p /tmp_install

ENV APP_USER=flu_user

# Each script is copied immediately before the RUN that consumes it, together
# with the data it moves out of /tmp_install. A single COPY of the whole build
# context would make every edit invalidate every install step below it.

COPY install_uv.sh /tmp_install/
RUN sh /tmp_install/install_uv.sh

COPY install_packages.sh /tmp_install/
RUN sh /tmp_install/install_packages.sh

COPY install_pixi.sh /tmp_install/
RUN sh /tmp_install/install_pixi.sh

COPY install_appuser.sh /tmp_install/
RUN sh /tmp_install/install_appuser.sh

COPY insaflu-requirements.txt install_insaflu.sh /tmp_install/
RUN sh /tmp_install/install_insaflu.sh

COPY --from=sge /opt/sge/ /opt/sge/
COPY sge_default/ /tmp_install/sge_default/
COPY install_sge_configure.sh /tmp_install/
RUN sh /tmp_install/install_sge_configure.sh

COPY install_miniconda.sh /tmp_install/
RUN sh /tmp_install/install_miniconda.sh

COPY install_ivar.sh /tmp_install/
RUN sh /tmp_install/install_ivar.sh

COPY software/aln2pheno/ /tmp_install/software/aln2pheno/
COPY install_aln2pheno.sh /tmp_install/
RUN sh /tmp_install/install_aln2pheno.sh

COPY install_flumut.sh /tmp_install/
RUN sh /tmp_install/install_flumut.sh

COPY install_irma.sh /tmp_install/
RUN sh /tmp_install/install_irma.sh

COPY software/nextstrain/ /tmp_install/software/nextstrain/
COPY install_nextstrain.sh /tmp_install/
RUN sh /tmp_install/install_nextstrain.sh

COPY install_label.sh /tmp_install/
RUN sh /tmp_install/install_label.sh

COPY install_nextstrain_rsv.sh /tmp_install/
RUN sh /tmp_install/install_nextstrain_rsv.sh

COPY install_nextstrain_mpx.sh /tmp_install/
RUN sh /tmp_install/install_nextstrain_mpx.sh

COPY install_tsv_utils.sh /tmp_install/
RUN sh /tmp_install/install_tsv_utils.sh

COPY install_nextstrain_dengue.sh /tmp_install/
RUN sh /tmp_install/install_nextstrain_dengue.sh

COPY install_nextstrain_builds.sh /tmp_install/
RUN sh /tmp_install/install_nextstrain_builds.sh

COPY software/pangolin/ /tmp_install/software/pangolin/
COPY software/update_pangolin_data.sh /tmp_install/software/
COPY install_pangolin.sh /tmp_install/
RUN sh /tmp_install/install_pangolin.sh

COPY software/raven/ /tmp_install/software/raven/
COPY install_raven.sh /tmp_install/
RUN sh /tmp_install/install_raven.sh

COPY configs/CPAN/ /tmp_install/configs/CPAN/
COPY install_bioperl.sh /tmp_install/
RUN sh /tmp_install/install_bioperl.sh

COPY --from=emboss /software/emboss/ /software/emboss/
RUN ln -s /software/emboss/bin/seqret /usr/bin/seqret

COPY software/abricate/ /tmp_install/software/abricate/
COPY install_abricate.sh /tmp_install/
RUN sh /tmp_install/install_abricate.sh

COPY --from=bamtools /software/bamtools/ /software/bamtools/

COPY install_fastqc.sh /tmp_install/
RUN sh /tmp_install/install_fastqc.sh

COPY --from=fastq-tools /software/fastq-tools/ /software/fastq-tools/

COPY install_fasttree.sh /tmp_install/
RUN sh /tmp_install/install_fasttree.sh

COPY install_freebayes.sh /tmp_install/
RUN sh /tmp_install/install_freebayes.sh

COPY install_igvtools.sh /tmp_install/
RUN sh /tmp_install/install_igvtools.sh

COPY --from=mafft /software/mafft-7.453-without-extensions/ /software/mafft-7.453-without-extensions/

COPY install_mauve.sh /tmp_install/
RUN sh /tmp_install/install_mauve.sh

COPY software/prokka/ /tmp_install/software/prokka/
COPY install_prokka.sh /tmp_install/
RUN sh /tmp_install/install_prokka.sh

COPY software/scripts/ /tmp_install/software/scripts/
COPY install_scripts.sh /tmp_install/
RUN sh /tmp_install/install_scripts.sh

COPY software/snippy/ /tmp_install/software/snippy/
COPY install_snippy.sh /tmp_install/
RUN sh /tmp_install/install_snippy.sh

COPY software/make_links_snippy.sh /tmp_install/software/
COPY install_snippy_links.sh /tmp_install/
RUN sh /tmp_install/install_snippy_links.sh

COPY software/snpEff/ /tmp_install/software/snpEff/
COPY install_snpeff.sh /tmp_install/
RUN sh /tmp_install/install_snpeff.sh

COPY --from=spades /software/SPAdes-3.11.1-Linux/ /software/SPAdes-3.11.1-Linux/

COPY software/trimmomatic/ /tmp_install/software/trimmomatic/
COPY install_trimmomatic.sh /tmp_install/
RUN sh /tmp_install/install_trimmomatic.sh

COPY --from=rabbitqc /software/RabbitQC/ /software/RabbitQC/
COPY install_rabbitqc_python.sh /tmp_install/
RUN sh /tmp_install/install_rabbitqc_python.sh

COPY software/install_soft_medaka.sh software/medaka-requirements.txt software/medaka-overrides.txt /tmp_install/software/
COPY software/medaka/ /tmp_install/software/medaka/
COPY install_medaka.sh /tmp_install/
RUN sh /tmp_install/install_medaka.sh

COPY install_kallisto.sh /tmp_install/
RUN sh /tmp_install/install_kallisto.sh

COPY commands/ /tmp_install/commands/
COPY entrypoint.sh /tmp_install/
COPY install_finish.sh /tmp_install/
RUN sh /tmp_install/install_finish.sh

# Config files land last: they change most often and nothing above needs them.
# Editing insaflu.env or insaflu.conf now rebuilds only from here.

COPY configs/insaflu.env /tmp_install/configs/
RUN mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown ${APP_USER}:${APP_USER} /insaflu_web/INSaFLU/.env

COPY configs/insaflu.conf configs/insaflu_tmp_path.conf /tmp_install/configs/
COPY install_apache.sh /tmp_install/
RUN sh /tmp_install/install_apache.sh

ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}"

ENTRYPOINT ["/entrypoint.sh"]
