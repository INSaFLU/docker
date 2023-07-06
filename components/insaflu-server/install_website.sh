#!/bin/bash
set -e

# Install package dependencies
echo "Install package dependencies"
yum -y install epel-release
yum -y install gdal gdal-devel dos2unix parallel postgis postgresql-devel postgresql httpd httpd-tools httpd-devel mod_wsgi bash file binutils gzip git unzip wget java perl perl-devel perl-Time-Piece perl-XML-Simple perl-Digest-MD5 perl-CPAN perl-Module-Build perl-File-Slurp perl-Test* python36 python36-pip gcc zlib-devel bzip2-devel xz-devel python36-devel cmake cmake3 gcc-c++ autoconf bzip2 automake libtool which https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-1.x86_64.rpm
if [ $? -ne 0 ]; then
    echo "Error installing system packages"
    exit 1
fi

#### create a apache
# Create a group and user to run insaflu
useradd -ms /bin/bash ${APP_USER}


### web site
echo "Setup website code"
mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone https://github.com/INSaFLU/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu && chown -R ${APP_USER}:${APP_USER} /var/log/insaFlu
#mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone --branch expand_organisms https://github.com/SantosJGND/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu
if [ $? -ne 0 ]; then
    echo "Error installing INSaFLU base"
    exit 1
fi

### apache server
echo "Setup Apache httpd"
usermod -a -G ${APP_USER} apache && mv /tmp_install/configs/insaflu.conf /etc/httpd/conf.d && rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf && echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf && sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp && mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf
if [ $? -ne 0 ]; then
    echo "Error installing apache"
    exit 1
fi

### Temp Directory /usr/lib/tmpfiles.d
mv /tmp_install/configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf

#### SGE
echo "Setup SGE job queuing"
export SGE_ROOT=/opt/sge
groupadd -g 58 gridware && useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin && chmod 0755 ${SGE_ROOT} && mkdir /insaflu_sge_source && cd /insaflu_sge_source 
wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz; tar -zxvf sge-8.1.9.tar.gz 
yum -y install csh hwloc-devel openssl-devel pam-devel libXt-devel motif motif-devel readline-devel
cd /insaflu_sge_source/sge-8.1.9/source && sh scripts/bootstrap.sh -no-java -no-jni && ./aimk -no-java -no-jni
echo Y | /insaflu_sge_source/sge-8.1.9/source/scripts/distinst -local -all -noexit
if [ $? -ne 0 ]; then
    echo "Error installing SGE"
    exit 1
fi
#copy default files to the queues
mv /tmp_install/sge_default/default/ ${SGE_ROOT}/ && chown -R sgeadmin:gridware ${SGE_ROOT} && mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/ && mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/ && mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/ && mv /tmp_install/sge_default/root.cshrc /root/.cshrc && chmod a+x /etc/profile.d/sun-grid-engine.sh && rm -rf /insaflu_sge_source*
#export PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:${PATH}"
#
### END SGE


