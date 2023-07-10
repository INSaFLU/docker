#!/bin/bash
set -e

# build DBs and launch frontend
if [ "$1" = "init_all" ]; then
    
    echo "---> Wait 45 seconds for all pgsql services  ..."
    sleep 45	## wait for postgis extension

	### set all default insaflu data
	echo "---> Collect static data  ..."
	cd /insaflu_web/INSaFLU; python3 manage.py collectstatic --noinput;

	echo "---> Create/Update database if necessary  ..."
	cd /insaflu_web/INSaFLU; python3 manage.py migrate;

	echo "---> Load default files  ..."
	if [ ! -e "/software/prokka/db/hmm/HAMAP.hmm.h3f" ]; then
		echo "---> Set prokka default databases  ..."
		## for fresh prokka instalations
		/software/prokka/bin/prokka --setupdb
	fi
	cd /insaflu_web/INSaFLU; python3 manage.py load_default_files;
	cd /insaflu_web/INSaFLU; python3 manage.py load_default_settings;

	## update pangolin if necessary
	cd /insaflu_web/INSaFLU; python3 manage.py update_pangolin;

	### set owners
	echo "---> Set owners APP_USER ..."
	chown -R APP_USER:APP_USER /insaflu_web/INSaFLU/media
	chown -R APP_USER:APP_USER /var/log/insaFlu
	# This is for televir
	chown -R APP_USER:APP_USER /insaflu_web/INSaFLU/static_all

	### need to link after the mount, otherwise all the data in "/insaflu_web/INSaFLU/env" is going to be masked (hided)
	if [ ! -e "/insaflu_web/INSaFLU/env/insaflu.env" ]; then
		mv /insaflu_web/INSaFLU/.env /insaflu_web/INSaFLU/env/insaflu.env 
		ln -s /insaflu_web/INSaFLU/env/insaflu.env /insaflu_web/INSaFLU/.env
	fi

	### start sge
	echo "---> Start sge ..."
	/etc/init.d/sgemaster.p6444
	/etc/init.d/sgeexecd.p6444

	### some files/paths are made by "root" account and need to be accessed by "flu_user"
	### It's done by tmpfiles.d
	rm -rf /tmp/insaFlu/*
	if [ -d "/tmp/insaFlu" ]; then
		chmod -R 0777 /tmp/insaFlu
	fi
	
	# for televir
	if [ -e /televir/mngs_benchmark/utility_docker.db ]; then
		cd /insaflu_web/INSaFLU; python3 manage.py generate_default_trees
	fi

	echo "---> Start apache server  ..."
	/usr/sbin/httpd -k restart
	echo "---> apache running  ..."

	tail -f /dev/null
fi


