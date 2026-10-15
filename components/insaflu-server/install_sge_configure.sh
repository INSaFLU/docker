#!/bin/bash
# components/insaflu-server/install_sge_configure.sh
# Runtime side of SGE: the sgeadmin account, the queue configuration shipped
# in the build context, the profile.d environment and the init scripts.
# The compiled tree arrives from the sge build stage: install_sge_compile.sh.

set -e

# required dependency
yum -y install hwloc-libs motif

export SGE_ROOT=/opt/sge
groupadd -g 58 gridware
useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin

mv /tmp_install/sge_default/default/ ${SGE_ROOT}/
chown -R sgeadmin:gridware ${SGE_ROOT}
mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/
mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/
mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/
mv /tmp_install/sge_default/root.cshrc /root/.cshrc
chmod a+x /etc/profile.d/sun-grid-engine.sh
