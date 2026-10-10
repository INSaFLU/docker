#!/bin/bash
# components/insaflu-server/install_sge.sh
# Builds and installs Open Grid Scheduler 8.1.9 and drops in the queue
# configuration shipped in the build context.

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

mv /tmp_install/sge_default/default/ ${SGE_ROOT}/
chown -R sgeadmin:gridware ${SGE_ROOT}
mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/
mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/
mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/
mv /tmp_install/sge_default/root.cshrc /root/.cshrc
chmod a+x /etc/profile.d/sun-grid-engine.sh
rm -rf /insaflu_sge_source*
