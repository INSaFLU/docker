FROM ubuntu:22.04
USER root
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"
LABEL authors="monsantopinheiro@gmail.com,daniel.sobral@insa.min-saude.pt"


RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

LABEL vendor=INSA\
      pt.insa.insaflu.is-production="" \
      pt.insa.insaflu.version="1.7.0-beta" \
      pt.insa.insaflu.release-date="2023-06-13"


RUN mkdir -p /tmp_install
RUN mkdir -p /software
RUN mkdir -p /tmp/insaFlu

ADD configs/ /tmp_install/configs/
ADD commands/ /tmp_install/commands/
ADD software/ /tmp_install/software/
ADD install_scripts/*.sh /tmp_install/

# version
ADD VERSION .
ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1
ARG SLURM_TAG
ARG SHARED_USER_NAME=user
ARG SHARED_USER_UID=1000
ARG SHARED_GROUP_NAME=user
ARG SHARED_GROUP_GID=1000


#### standardize munge and slurm users and groups across machines.
RUN set -x \
      && groupadd -r --gid=990 slurm \
      && useradd -r -g slurm --uid=990 slurm

RUN set -x \
      && groupadd -r --gid=102 munge \
      && useradd -r -g munge --uid=102 munge 

ENV APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER} -r -g slurm --uid=${SHARED_USER_UID} 


# 
RUN sh /tmp_install/install_system_pkgs.sh

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

COPY configs/munge/munged.pid /var/run/munge/munged.pid
RUN chown munge:munge /var/run/munge/munged.pid

COPY configs/slurm/slurm.conf /etc/slurm/slurm.conf
RUN chown slurm:slurm /etc/slurm/slurm.conf \
      && chmod 644 /etc/slurm/slurm.conf

COPY configs/slurm/cgroup.conf /etc/slurm/cgroup.conf
COPY configs/slurm/slurmdbd.conf /etc/slurm/slurmdbd.conf
RUN set -x \
      && chown slurm:slurm /etc/slurm/slurmdbd.conf \
      && chmod 600 /etc/slurm/slurmdbd.conf


####
RUN sh /tmp_install/install_apache.sh
RUN sh /tmp_install/install_slurm.sh

USER root

RUN sh /tmp_install/install_miniconda.sh
RUN sh /tmp_install/install_software.sh

RUN sh /tmp_install/install_website_dependencies.sh
RUN sh /tmp_install/install_website.sh

#### gosu - for running munge daemon
ARG GOSU_VERSION=1.17

RUN set -ex \
      && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
      && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
      && export GNUPGHOME="$(mktemp -d)" \
      && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
      && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
      && rm -rf "${GNUPGHOME}" /usr/local/bin/gosu.asc \
      && chmod +x /usr/local/bin/gosu \
      && gosu nobody true

COPY configs/munge/munge.key /etc/munge/
RUN chmod 400 /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key

RUN apt-get update \
      && apt-get install -y sudo

#RUN echo "admin:admin" | chpasswd && id -u admin || sudo adduser admin && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#USER admin
#ENV USER=admin

ADD entrypoint.sh /tmp_install/
RUN sh /tmp_install/install_finish.sh
RUN mkdir -p /tmp/insaFlu && chown ${APP_USER}:slurm /tmp/insaFlu

RUN echo 'PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:/insaflu_web/commands/:/software/kallisto_linux-v0.43.1/:/software/blast+/2.16.0/ncbi-blast-2.16.0+-src/c++/ReleaseMT/bin:${PATH}"' >> /home/${APP_USER}/.bashrc

ENTRYPOINT ["/entrypoint.sh"]
