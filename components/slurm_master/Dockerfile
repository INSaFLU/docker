FROM ubuntu:22.04


LABEL org.opencontainers.image.source="https://github.com/giovtorres/slurm-docker-cluster" \
    org.opencontainers.image.title="slurm-docker-cluster" \
    org.opencontainers.image.description="Slurm Docker cluster on Ubuntu 20.04" \
    org.label-schema.docker.cmd="docker-compose up -d" \
    maintainer="Giovanni Torres"

ARG GOSU_VERSION=1.17
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
    && groupadd -r --gid=999 mysql \
    && useradd -r -g mysql --uid=999 mysql 

RUN set -x \
    && groupadd -r --gid=102 munge \
    && useradd -r -g munge --uid=102 munge 


####

RUN set -ex \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
    wget \
    bzip2 \
    perl \
    gcc \
    g++ \
    git \
    gnupg \
    make \
    munge \
    libmunge-dev \
    python3-dev \
    python3-pip \
    python3 \
    mariadb-server \
    libmariadb-dev \
    psmisc \
    bash-completion \
    vim \
    libhttp-parser-dev \
    libjson-c-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN pip3 install Cython pytest

RUN set -ex \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -rf "${GNUPGHOME}" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true


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
    /var/lib/slurmd/assoc_usage \
    /var/lib/slurmd/qos_usage \
    /var/lib/slurmd/fed_mgr_state \
    && chown -R slurm:slurm /var/*/slurm* \
    && /sbin/mungekey -cf \
    && chown -R munge:munge /etc/munge \
    && chmod 600 /etc/munge/munge.key \
    && chmod 755 /etc/munge \
    && mkdir -p /run/munge \
    && chown -R munge:munge /run/munge \
    && chmod 755 /run/munge

COPY configs/munge/munged.pid /var/run/munge/munged.pid
RUN chown munge:munge /var/run/munge/munged.pid

COPY configs/slurm/slurm.conf /etc/slurm/slurm.conf
COPY configs/slurm/cgroup.conf /etc/slurm/cgroup.conf 
COPY configs/slurm/slurmdbd.conf /etc/slurm/slurmdbd.conf
RUN set -x \
    && chown slurm:slurm /etc/slurm/slurmdbd.conf \
    && chmod 600 /etc/slurm/slurmdbd.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chown slurm:slurm /usr/local/bin/entrypoint.sh

COPY configs/munge/munge.key /etc/munge/
RUN chmod 400 /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key

RUN apt-get update \
    && apt-get install -y sudo
RUN echo "admin:admin" | chpasswd && id -u admin || sudo adduser admin && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER admin
ENV USER=admin

#RUN set -x \
#    && groupadd --gid=${SHARED_GROUP_GID} ${SHARED_GROUP_NAME} \
#    && useradd -g ${SHARED_GROUP_NAME} --uid=${SHARED_USER_UID} ${SHARED_USER_NAME}


ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["slurmdbd"]