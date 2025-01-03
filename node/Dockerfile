FROM ubuntu:20.04

RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client -y


RUN apt install sudo -y && apt install python3.9 python3-pip -y 
RUN apt update -y && apt install libopenmpi-dev -y && pip3 install mpi4py

ENV APP_USER=admin
RUN useradd -ms /bin/bash ${APP_USER}
RUN echo "admin:admin" | chpasswd && id -u admin || sudo adduser admin && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER admin
ENV USER=admin


COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY docker-entrypoint.sh /etc/slurm-llnl/

EXPOSE 6817 6818 6819  

ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
