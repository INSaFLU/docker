FROM ubuntu:20.04 as builder
USER root
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"

# version
ADD VERSION .
ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="1.7.0-beta" \
      pt.insa.insaflu.release-date="2023-06-13"

RUN mkdir -p /tmp_install



ENV APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER}

COPY */ /tmp_install/
COPY entrypoint.sh /entrypoint.sh

# To reduce the number of layers
COPY install_system_pkgs.sh /tmp_install/
RUN sh /tmp_install/install_system_pkgs.sh

COPY install_apache.sh /tmp_install/
COPY configs/insaflu.conf /tmp_install/configs/insaflu.conf
RUN sh /tmp_install/install_apache.sh

USER root
COPY install_website.sh /tmp_install/
COPY configs/insaflu.env /tmp_install/configs/insaflu.env
COPY configs/insaflu_tmp_path.conf /tmp_install/configs/insaflu_tmp_path.conf
RUN sh /tmp_install/install_website_dependencies.sh
RUN sh /tmp_install/install_website.sh

COPY install_miniconda.sh /tmp_install/
RUN sh /tmp_install/install_miniconda.sh

COPY install_software.sh /tmp_install/
RUN sh /tmp_install/install_software.sh

COPY install_finish.sh /tmp_install/
RUN sh /tmp_install/install_finish.sh


ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}" 

ENTRYPOINT ["/entrypoint.sh"]

