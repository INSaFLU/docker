#!/bin/bash
set -e

echo "Install Apache"
apt update -y

add-apt-repository ppa:ubuntugis/ppa && sudo apt-get update
apt-get install  apache2 apache2-utils apache2-dev libexpat1 ssl-cert python3 python3-pip -y
apt-get install  libapache2-mod-wsgi-py3 -y

a2enmod wsgi
systemctl restart apache2

useradd apache
echo `systemctl status apache2`

#### create a apache
# Create a group and user to run insaflu
useradd -ms /bin/bash ${APP_USER}

echo `ls /usr/local/etc/httpd` 
echo "FIRST"

### apache server
echo "Setup Apache httpd"
usermod -a -G ${APP_USER} apache && mv /tmp_install/configs/insaflu.conf /etc/httpd/conf.d && rm /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/welcome.conf && echo 'ServerName localhost' >> /etc/httpd/conf/httpd.conf && sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf_temp && mv /etc/httpd/conf/httpd.conf_temp /etc/httpd/conf/httpd.conf
if [ $? -ne 0 ]; then
    echo "Error installing apache"
    exit 1
fi