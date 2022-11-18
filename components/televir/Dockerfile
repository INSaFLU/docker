FROM ubuntu:latest AS builder

# Create a group and user to run insaflu
ARG APP_USER=flu_user
RUN useradd -ms /bin/bash ${APP_USER}

ENV TERM xterm

RUN set -xe && apt-get update && apt-get install -y python3 python3-pip 
RUN pip install --upgrade pip

RUN apt-get update
RUN apt-get install -y build-essential wget curl rsync apt-utils python3-setuptools

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip

RUN apt-get update \
    && apt-get install -y gcc python3-dev musl-dev 
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y git ncbi-entrez-direct tabix samtools bioperl 

RUN apt-get -y install default-jre python3-pip
# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR && \
    rm ~/miniconda.sh

ENV PATH $CONDA_DIR/bin:$PATH

## install kallisto version
RUN wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz
RUN tar -xzf kallisto_linux-v0.43.1.tar.gz
ENV PATH $PATH:kallisto_linux-v0.43.1


##
RUN apt-get install zlib1g-dev make g++

##
RUN python -m venv /opt/venv

RUN /opt/venv/bin/pip install numpy==1.23.0 psycopg2-binary pandas==1.4.3 sqlalchemy==1.4.41 python-decouple
RUN /opt/venv/bin/pip install --default-timeout=100 future
## install televir dbs

COPY taxdump.tar.gz /opt/

WORKDIR /insaflu_web
ADD https://api.github.com/repos/SantosJGND/TELEVIR/git/refs/heads/main version.json
RUN wget --quiet https://github.com/SantosJGND/TELEVIR/archive/main.zip -O televir.zip && \
    unzip -q televir.zip && \
    rm televir.zip && \
    mv TELEVIR-main TELEVIR && \
    chown -R ${APP_USER}:${APP_USER} TELEVIR


COPY configs/televir.env /insaflu_web/TELEVIR/.env

WORKDIR /
COPY entrypoint.sh entrypoint_original.sh
RUN sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh; rm entrypoint_original.sh
RUN chmod a+x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
