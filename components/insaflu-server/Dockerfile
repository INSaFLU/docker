FROM centos:7
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"

# version
ADD VERSION .

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="0.0.1-beta" \
      pt.insa.insaflu.release-date="2022-10-05"

RUN mkdir -p /tmp_install

COPY . /tmp_install/

# To reduce the number of layers
RUN sh /tmp_install/install_website.sh

RUN sh /tmp_install/install_miniconda.sh

RUN sh /tmp_install/install_software.sh

RUN sh /tmp_install/software/install_pangolin.sh && mv /tmp_install/software/update_pangolin.sh /software && chmod a+x /software/update_pangolin.sh

RUN sh /tmp_install/install_finish.sh


ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:${PATH}" 

ENTRYPOINT ["/entrypoint.sh"]

