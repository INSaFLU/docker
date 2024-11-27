

### web site
echo "Setup website code"
echo `which python3`
echo `python3 --version`
echo `pip3 --version`


#mkdir /insaflu_web && cd /insaflu_web && pip3 install Cython && git clone https://github.com/INSaFLU/INSaFLU.git && cd INSaFLU && pip3 install -r requirements.txt && pip3 install mod_wsgi-standalone && rm /etc/httpd/modules/mod_wsgi.so &&  ln -s /usr/local/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so /etc/httpd/modules/mod_wsgi.so && mkdir -p /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu && chown -R ${APP_USER}:${APP_USER} /var/log/insaFlu
mkdir /insaflu_web && cd /insaflu_web
git clone https://github.com/SantosJGND/INSaFLU.git #&& cd INSaFLU && pip3 install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "Error installing INSaFLU base"
    exit 1
fi



mkdir -p /insaflu_web/INSaFLU/env && mv /tmp_install/configs/insaflu.env /insaflu_web/INSaFLU/.env && chown -R ${APP_USER}:${APP_USER} * && mkdir /var/log/insaFlu


### Temp Directory /usr/lib/tmpfiles.d
#mv /tmp_install/configs/insaflu_tmp_path.conf /usr/lib/tmpfiles.d/insaflu_tmp_path.conf


#wget --no-check-certificate https://sourceforge.net/projects/gridengine/files/SGE/releases/8.1.9/sge-8.1.9.tar.gz/download -O sge-8.1.9.tar.gz; tar -zxvf sge-8.1.9.tar.gz

#cd /insaflu_sge_source/sge-8.1.9/source
#echo "INSTALLING SGE, BOOTSTRAP"
#sh scripts/bootstrap.sh -no-java -no-jni && ./aimk -no-java -no-jni
#echo Y | /insaflu_sge_source/sge/source/scripts/distinst -local -all -noexit
#if [ $? -ne 0 ]; then
#    echo "Error installing SGE"
#    exit 1
#fi

#export SGE_ROOT=/opt/sge
#groupadd -g 58 gridware && useradd -u 63 -g 58 -d ${SGE_ROOT} sgeadmin && chmod 0755 ${SGE_ROOT}

#copy default files to the queues
#mv /tmp_install/sge_default/default/ ${SGE_ROOT}/ && chown -R sgeadmin:gridware ${SGE_ROOT} && mv /tmp_install/sge_default/sun-grid-engine.sh /etc/profile.d/ && mv /tmp_install/sge_default/sgeexecd.p6444 /etc/init.d/ && mv /tmp_install/sge_default/sgemaster.p6444 /etc/init.d/ && mv /tmp_install/sge_default/root.cshrc /root/.cshrc && chmod a+x /etc/profile.d/sun-grid-engine.sh && rm -rf /insaflu_sge_source*
#export PATH="/opt/sge/bin:/opt/sge/bin/lx-amd64:${PATH}"
#
### END SGE


