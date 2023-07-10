

FROM centos:7
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"

# version
ADD VERSION .

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="1.7.0-beta" \
      pt.insa.insaflu.release-date="2023-06-13"

RUN mkdir -p /tmp_install

COPY . /tmp_install/

ENV APP_USER=flu_user

# To reduce the number of layers
RUN sh /tmp_install/install_website.sh

RUN sh /tmp_install/install_miniconda.sh

RUN sh /tmp_install/install_software.sh

RUN sh /tmp_install/install_finish.sh


ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}" 

ENTRYPOINT ["/entrypoint.sh"]

