<p align="center"><img src="logo/logo_insaflu.png" alt="INSaFLU" width="300"></p>


[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# INSaFLU - docker installation 

INSaFLU (“INSide the FLU”) is a bioinformatics free web-based suite (https://insaflu.insa.pt/) that deals with primary data (reads) towards the automatic generation of the output data that are the core first-line “genetic requests” for effective and timely viral influenza and SARS-CoV-2 laboratory surveillance (e.g., type and sub-type, gene and whole-genome consensus sequences, variants annotation, alignments and phylogenetic trees). Data integration is continuously scalable, fitting the need for a real-time epidemiological surveillance during the flu and COVID-19 epidemics.

**Here, you can find how to easily set up your local INSaFLU instance.**

## Recommended minimal hardware requirements

* Processor: 8 cores (4 minimal if only surveillance module is required);
* RAM: 32GB of memory (16GB minimal if only surveillance module is required);
* Disk Space: 1TB (suggestion; depends on the volume of data to process);

## Installation

Docker:

* Install [docker](https://docs.docker.com/engine/install/) in your linux server;
(recent versions of docker already include docker compose)

* Install the docker extension [local-persist](https://github.com/MatchbookLab/local-persist);

	$ curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh > install.sh
	
	$ chmod a+x install.sh

	$ sudo ./install.sh

:warning: If you're uncomfortable running a script you downloaded off the internet with sudo, you can extract any of the steps out of the install.sh script and run them manually.

:warning: local-persist does not seem to be supported in windows environments eg. WSL2. In this case you may need to adjust the Dockerfile(s) to use bind volumes instead.


INSaFLU:

	$ git clone https://github.com/INSaFLU/docker.git
	$ cd docker
	
	## to define the directory where the data will be saved and the web port exposed, edit the .env file: 
	$ cp .env_temp .env
	$ vi .env
	OR
	$ nano .env
	
	## add your user account to docker group to use docker without sudo
	$ sudo usermod -aG docker $USER
	$ sudo chmod 666 /var/run/docker.sock
	
	## test if everything is OK
	$ docker ps
	$ docker run hello-world 
	
	## build INSaFLU
	$ ./build.sh
	
	## (optional) to run the new viral detection module you need to set up the software and databases
	## This step can take several hours
	$ ./up_televir.sh
	
	## Now run INSaFLU
	$ ./up.sh		
	
	## create an user, in other terminal or you can use 'screen' in previous steps
	$ docker exec -it insaflu-server create-user
	
Now, you can go to a web explorer and link to the address "127.0.0.1:<port defined in .env>". Default port is 8080

To stop:

	$ ./stop.sh

To start again:

	$ ./up.sh
	
	
## Commands available

With these commands you can interact with INSaFLU image to do several tasks.

How to run:
	
	$ docker exec -it insaflu-server <<command>>

Commands:

	* create-user			## to create an user in insaflu;
	* list-all-users		## list all users in insaflu;
	* update-password		## update password for a specific user;
	* remove-fastq-files	## remove fastq files to increase sample in hard drive. You must have a copy of these files;
	* restart-apache		## restart web server, for example, after change something in insaflu/env/insaflu.env file;
	* test-email-server		## test you smtp server, change parameters first in insaflu/env/insaflu.env file;
	* unlock-upload-files	## unlock files samples thar are zombie when upload multiple samples;
	* update-tbl2asn		## every year it is necessary update the tbl2asn ncbi software;
	* upload-reference-dbs	## place new references in db/references and you can update them;
	* update-insaflu		## update insaflu software to a new version;
	* confirm-email-account 

Examples:
```
$ docker exec -it insaflu-server create-user
$ docker exec -it insaflu-server update-tbl2asn
$ docker exec -it insaflu-server restart-apache
$ docker exec -it insaflu-server update-password <some login>
$ docker exec -it insaflu-server update-insaflu
```


## Change variables in your local environment

You can customize your environment. Some of the relevant variables include the maximum reads size for upload (e.g., MAX_FASTQ_FILE_UPLOAD = 104857600), indicate if the files should be (or not) downsized after upload (i.e., DOWN_SIZE_FASTQ_FILES = True/False), indicate the maximum files size after downsizing (e.g. MAX_FASTQ_FILE_WITH_DOWNSIZE = 429916160), maximum length of external consensus sequences for nextstrain analysis (eg. MAX_LENGTH_SEQUENCE_TOTAL_FROM_CONSENSUS_FASTA = 104857600), etc.
	
To change these variables you need to edit the config file .env, as described below:

```
### get into INSaFLU docker
$ docker exec -it insaflu-server /bin/bash
### change the values here
$ vi /insaflu_web/INSaFLU/.env
### get out INSaFLU  docker
$ Ctrl^D
### restart apache
$ docker exec -it insaflu-server restart-apache
```

If you want to perpetuate the changes in future updates of INSaFLU webserver you also need to update "insaflu/env/insaflu.env".


## Update database for rapid assignment of segments/references to contigs


Some influenza sequences of the abricate database for "contigs2sequences" assignment currently being used on INSaFLU free website (latest version can be found here: https://insaflu.readthedocs.io/en/latest/data_analysis.html#type-and-sub-type-identification) are not included as part of this repository as they are protected by the terms of GISAID sharing (we gratefully acknowledge the Authors, Originating and Submitting laboratories, as indicated in the lists provided in the Documentation). These sequences will need to be collected by the user and the database will need to be build based on abricate instructions on "making your own database" (https://github.com/tseemann/abricate). Please contact us if you need help for building the database currently being used on INSaFLU free website.

## Update **INSaFLU docker** installation -keeping your previous data-


This steps are for the users that already have previous docker installations of INSaFLU. This re-installation maintains all previous data that were generated in older installations.

```
$ cd <move to the previous instalation of insaflu docker>
$ ./stop.sh
$ git pull
$ docker image ls

REPOSITORY                              TAG                 IMAGE ID            CREATED             SIZE
<user_name>                             insaflu-server      637475d74da0        16 hours ago        8.38GB
docker_db_insaflu                       latest              30f7aa670a79        16 hours ago        331MB
prodrigestivill/postgres-backup-local   latest              5ff2ca2295f1        25 hours ago        326MB
postgres                                10                  3cfd168e7b61        2 weeks ago         200MB
centos                                  7                   7e6257c9f8d8        2 months ago        203MB
funkyfuture/deck-chores                 1                   848ca42ff6aa        3 weeks ago         321MB


$ docker image rm -f <IMAGE ID that exist in your docker for insaflu-server>

In my case:
$ docker image rm -f 637475d74da0
$ ./build.sh
$ ./up.sh

It will give an error,
Recreating insaflu-server ... error
.....
.....
Continue with the new image? [yN]y    	"Press 'y' to update the insaflu-server"
```

:warning: Please, check if you have the variable TIMEZONE defined in ".env" file. You can check and example in ".env_temp".


## Update INSaFLU to last version

You can update only **INSaFLU website** to last version (keep your previous data).

For INSaFlu versions **equal or higher 1.5.2**

```
### update INSaFLU website
$ docker exec -it insaflu-server update-insaflu
```


For INSaFLU versions **before 1.5.2**

It is necessary to install the last [INSaFLU docker](#update-insaflu-docker-installation--keeping-your-previous-data-).



**_NOTE:_** When you make the update of **INSaFLU docker** you update all software and **INSaFLU website**. When you update only **INSaFLU website** you only update **INSaFLU**.

