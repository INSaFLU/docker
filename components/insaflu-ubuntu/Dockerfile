FROM ubuntu:22.04
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
RUN mkdir -p /software



ENV APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER}

ADD configs/ /tmp_install/configs/
ADD commands/ /tmp_install/commands/
ADD software/ /tmp_install/software/
ADD *.sh /tmp_install/
COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/

# To reduce the number of layers
RUN sh /tmp_install/install_system_pkgs.sh
RUN sh /tmp_install/install_apache.sh
RUN sh /tmp_install/install_slurm.sh
USER root

#RUN sh /tmp_install/install_website_dependencies.sh
#RUN sh /tmp_install/install_website.sh

#RUN sh /tmp_install/install_miniconda.sh
#RUN sh /tmp_install/install_software.sh
RUN sh /tmp_install/install_finish.sh

ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}" 

ENTRYPOINT ["/entrypoint.sh"]
