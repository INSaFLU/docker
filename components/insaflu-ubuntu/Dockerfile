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



RUN sh /tmp_install/install_system_pkgs.sh
RUN sh /tmp_install/install_apache.sh
RUN sh /tmp_install/install_slurm.sh
USER root

RUN sh /tmp_install/install_website_dependencies.sh
RUN sh /tmp_install/install_website.sh

#RUN sh /tmp_install/install_miniconda.sh
#RUN sh /tmp_install/install_software.sh
RUN sh /tmp_install/install_finish.sh

ENV PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:${PATH}" 

## slurm configuration

RUN set -ex \
      && apt-get update \
      && apt-get -y upgrade \
      && apt-get -y install \
      slurm-client munge \
      libmunge-dev \
      curl dirmngr apt-transport-https lsb-release ca-certificates \
      gnupg \
      munge \
      libmunge-dev \
      libhttp-parser-dev \
      libjson-c-dev


ARG SLURM_TAG

RUN set -x \
      && git clone -b ${SLURM_TAG} --single-branch --depth=1 https://github.com/SchedMD/slurm.git \
      && cd slurm \
      && ./configure --enable-debug --prefix=/usr --sysconfdir=/etc/slurm \
      --with-mysql_config=/usr/bin  --libdir=/usr/lib/x86_64-linux-gnu \
      && make install \
      && install -D -m644 etc/cgroup.conf.example /etc/slurm/cgroup.conf.example \
      && install -D -m644 etc/slurm.conf.example /etc/slurm/slurm.conf.example \
      && install -D -m644 etc/slurmdbd.conf.example /etc/slurm/slurmdbd.conf.example \
      && install -D -m644 contribs/slurm_completion_help/slurm_completion.sh /etc/profile.d/slurm_completion.sh \
      && cd .. \
      && rm -rf slurm \
      && mkdir -p /etc/sysconfig/slurm \
      /var/spool/slurmd \
      /var/run/slurmd \
      /var/run/slurmdbd \
      /var/lib/slurmd \
      /var/log/slurm \
      /data 

RUN touch /var/lib/slurmd/node_state \
      /var/lib/slurmd/front_end_state \
      /var/lib/slurmd/job_state \
      /var/lib/slurmd/resv_state \
      /var/lib/slurmd/trigger_state \
      /var/lib/slurmd/assoc_mgr_state \
      /var/lib/slurmd/assoc_usage \
      /var/lib/slurmd/qos_usage \
      /var/lib/slurmd/fed_mgr_state \
      && chown -R slurm:slurm /var/*/slurm* 

RUN test -f /etc/munge/munge.key || /usr/sbin/mungekey --create


COPY slurm.conf /etc/slurm/slurm.conf
COPY cgroup.conf /etc/slurm/cgroup.conf 
COPY slurmdbd.conf /etc/slurm/slurmdbd.conf
RUN set -x \
      && chown slurm:slurm /etc/slurm/slurmdbd.conf \
      && chmod 600 /etc/slurm/slurmdbd.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chown slurm:slurm /usr/local/bin/entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
