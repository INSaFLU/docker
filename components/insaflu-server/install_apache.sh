#!/bin/bash
# components/insaflu-server/install_apache.sh
# Configures httpd and the tmpfiles.d entry.

set -e

echo "Setup Apache httpd"
usermod -a -G ${APP_USER} apache
mv /tmp_install/configs/insaflu.conf /etc/httpd/conf.d
rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf
echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf
sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp
mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf

mv /tmp_install/configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf
