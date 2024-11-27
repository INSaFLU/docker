#!/bin/bash
set -e

echo "Install Apache"
apt update -y
apt install apache2 libapache2-mod-wsgi -y

apt install software-properties-common -y
#add-apt-repository ppa:ubuntugis/ppa && apt-get update
#apt-get install  apache2 apache2-utils apache2-dev libexpat1 ssl-cert -y
#apt-get install  libapache2-mod-wsgi-py3 -y
#service apache2 restart

useradd apache

#### create a apache
# Create a group and user to run insaflu
#useradd -ms /bin/bash ${APP_USER}

### apache server
echo "Setup Apache httpd"
usermod -a -G ${APP_USER} apache && mv /tmp_install/configs/insaflu.conf /etc/apache2/sites-available/000-default.conf
echo 'ServerName localhost' >> /etc/apache2/apache2.conf
sed 's~</IfModule>~\n    AddType application/octet-stream .bam\n\n</IfModule>~' /etc/apache2/mods-available/mime.conf > /etc/apache2/mods-available/mime.conf_temp
mv /etc/apache2/mods-available/mime.conf_temp /etc/apache2/mods-available/mime.conf

a2ensite 000-default.conf
a2enmod wsgi

if [ $? -ne 0 ]; then
    echo "Error installing apache"
    exit 1
fi