#!/bin/bash
# components/insaflu-server/install_insaflu.sh
# Clones the INSaFLU application and installs its Python dependencies.
# Cython<3.0, pyyaml and pysam are installed before requirements.txt because
# packages in that file build against them.

set -e

echo "Setup website code"
pip3 install wheel
pip3 install --upgrade setuptools

mkdir /insaflu_web
cd /insaflu_web
uv pip install --system "Cython<3.0" pyyaml==6.0.1 pysam==0.19.1
git clone --branch develop https://github.com/INSaFLU/INSaFLU.git
cd INSaFLU
# INSaFLU/INSaFLU#213: pathogen_identification has two migrations numbered
# 0054, both depending on 0053, and 0055 depends on only one of them. Django
# refuses to run with two leaf nodes. Nothing depends on this one and 0055
# sets the same field afterwards, anyway.
rm -f pathogen_identification/migrations/0054_auto_20250327_1705.py

# django-tables2 1.16.0 ships sdist only, and its tarball contains
# docs/pages/CHANGELOG.md as a symlink to an absolute path in the
# packager's home directory. uv refuses to unpack archives with external
# symlinks. Unpack it here, drop the symlink, install from the directory.
curl -fsSL -O https://files.pythonhosted.org/packages/source/d/django-tables2/django-tables2-1.16.0.tar.gz
tar -xzf django-tables2-1.16.0.tar.gz
rm -f django-tables2-1.16.0/docs/pages/CHANGELOG.md
uv pip install --system ./django-tables2-1.16.0
rm -rf django-tables2-1.16.0 django-tables2-1.16.0.tar.gz

uv pip install --system -r /tmp_install/insaflu-requirements.txt
rm /etc/httpd/modules/mod_wsgi.so
ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so
mkdir /insaflu_web/INSaFLU/env
chown -R ${APP_USER}:${APP_USER} /insaflu_web/INSaFLU
mkdir /var/log/insaFlu
chown -R ${APP_USER}:${APP_USER} /var/log/insaFlu
