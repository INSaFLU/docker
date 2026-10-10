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

COPY configs/insaflu.conf configs/insaflu.env configs/insaflu_tmp_path.conf /tmp_install/configs/
COPY sge_default/ /tmp_install/sge_default/
COPY install_website.sh /tmp_install/
RUN sh /tmp_install/install_website.sh

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
COPY software/update_pangolin.sh /tmp_install/software/
COPY install_pangolin.sh /tmp_install/
RUN sh /tmp_install/install_pangolin.sh

COPY software/raven/ /tmp_install/software/raven/
COPY install_raven.sh /tmp_install/
RUN sh /tmp_install/install_raven.sh

COPY configs/CPAN/ /tmp_install/configs/CPAN/
COPY software/ /tmp_install/software/
COPY install_software.sh /tmp_install/
RUN sh /tmp_install/install_software.sh

COPY commands/ /tmp_install/commands/
COPY entrypoint.sh /tmp_install/
COPY install_finish.sh /tmp_install/
RUN sh /tmp_install/install_finish.sh

ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}"

ENTRYPOINT ["/entrypoint.sh"]
