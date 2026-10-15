#!/bin/bash
# components/insaflu-server/install_sge_compile.sh
# Builds Open Grid Scheduler 8.1.9 into /opt/sge. The sgeadmin user and the
# queue configuration land in the main stage: install_sge_configure.sh.

set -e

echo "Setup SGE job queuing"
export SGE_ROOT=/opt/sge
groupadd -g 58 gridware
useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin
chmod 0755 ${SGE_ROOT}
mkdir /insaflu_sge_source
cd /insaflu_sge_source
wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz
tar -zxvf sge-8.1.9.tar.gz
yum -y install csh hwloc-devel openssl-devel pam-devel libXt-devel motif motif-devel readline-devel
cd /insaflu_sge_source/sge-8.1.9/source
sh scripts/bootstrap.sh -no-java -no-jni
./aimk -no-java -no-jni
echo Y | /insaflu_sge_source/sge-8.1.9/source/scripts/distinst -local -all -noexit

rm -rf /insaflu_sge_source*
