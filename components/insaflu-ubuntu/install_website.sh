#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
#apt-get -y install epel-release
#apt-get -y install epel-release
apt update -y

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.bashrc

apt install -y python3-pip
#exec "$SHELL"
~/.pyenv/bin/pyenv install 3.8.3
~/.pyenv/bin/pyenv global 3.8.3

### install blast+ v2.7.1
echo "Install blast+ v2.7.1"
mkdir -p /software/blast+/2.7.1 && cd /software/blast+/2.7.1 && wget --no-check-certificate https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-x64-linux.tar.gz && tar -zxvf ncbi-blast-2.7.1+-x64-linux.tar.gz && rm ncbi-blast-2.7.1+-x64-linux.tar.gz
### add blast+ to path
echo 'export PATH="/software/blast+/2.7.1/ncbi-blast-2.7.1+/bin:${PATH}"' >> ~/.bashrc
if [ $? -ne 0 ]; then
    echo "Error installing blast+ v2.7.1"
    exit 1
fi


### web site
echo "Setup website code"
echo `which python3`
echo `python3 --version`
echo `pip3 --version`
#mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone https://github.com/INSaFLU/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir -p /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu && chown -R ${APP_USER}:${APP_USER} /var/log/insaFlu
mkdir /home/insaflu_web && cd /home/insaflu_web && pip3 install Cython && git clone --branch metagenomics-ubuntu https://github.com/SantosJGND/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && mkdir -p /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu
if [ $? -ne 0 ]; then
    echo "Error installing INSaFLU base"
    exit 1
fi


### Temp Directory /usr/lib/tmpfiles.d
mv /tmp_install/configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf

#### SGE
echo "Setup SGE job queuing"
#apt-get install csh libhwloc-dev openssl libssl-dev libpam-dev libxt-dev libmotif-dev libreadline-dev libntirpc-dev -y
#apt install git build-essential libhwloc-dev libssl-dev libtirpc-dev libmotif-dev libxext-dev libncurses-dev libdb5.3-dev libpam0g-dev pkgconf libsystemd-dev cmake -y
apt-get install build-essential cmake git libdb5.3-dev libhwloc-dev libmotif-dev libncurses-dev libpam0g-dev libssl-dev libsystemd-dev libtirpc-dev libxext-dev pkgconf -y

mkdir /insaflu_sge_source && cd /insaflu_sge_source 
git clone https://github.com/daimh/sge.git

cd /insaflu_sge_source/sge
echo "INSTALLING SGE"
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/opt/sge -DSYSTEMD=ON
cmake --build build -j
cmake --install build

#wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz; tar -zxvf sge-8.1.9.tar.gz 

#cd /insaflu_sge_source/sge-8.1.9/source
echo "INSTALLING SGE, BOOTSTRAP"
#sh scripts/bootstrap.sh -no-java -no-jni && ./aimk -no-java -no-jni
#echo Y | /insaflu_sge_source/sge/source/scripts/distinst -local -all -noexit
#if [ $? -ne 0 ]; then
#    echo "Error installing SGE"
#    exit 1
#fi

export SGE_ROOT=/opt/sge
groupadd -g 58 gridware && useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin && chmod 0755 ${SGE_ROOT}

#copy default files to the queues
mv /tmp_install/sge_default/default/ ${SGE_ROOT}/ && chown -R sgeadmin:gridware ${SGE_ROOT} && mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/ && mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/ && mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/ && mv /tmp_install/sge_default/root.cshrc /root/.cshrc && chmod a+x /etc/profile.d/sun-grid-engine.sh && rm -rf /insaflu_sge_source*
#export PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:${PATH}"
#
### END SGE


