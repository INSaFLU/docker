<p align="center"><img src="logo/logo_insaflu.png" alt="INSaFLU" width="300"></p>


[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# INSaFLU - docker installation

INSaFLU (“INSide the FLU”) is a bioinformatics free web-based suite (https://insaflu.insa.pt/) that deals with primary data (reads) towards the automatic generation of the output data that are the core first-line “genetic requests” for effective and timely viral influenza and SARS-CoV-2 laboratory surveillance (e.g., type and sub-type, gene and whole-genome consensus sequences, variants annotation, alignments and phylogenetic trees). Data integration is continuously scalable, fitting the need for a real-time epidemiological surveillance during the flu and COVID-19 epidemics.

**Here, you can find how to easily set up your local INSaFLU instance.**

## Hardware Requirements

* Processor: 8 cores (4 minimal);
* RAM: 32GB of memory (16GB minimal);
* Disk Space: 512GB;


## Installation

Docker:

* Install [docker](https://docs.docker.com/engine/install/) in your linux server;
* Install [docker-compose](https://docs.docker.com/compose/install/) in your linux server;

	$ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	
	$ sudo chmod +x /usr/local/bin/docker-compose

* Install docker extensions [local-persist](https://github.com/MatchbookLab/local-persist);

	$ curl -fsSL https://raw.githubusercontent.com/MatchbookLab/local-persist/master/scripts/install.sh > install.sh
	
	$ chmod a+x install.sh

	$ sudo ./install.sh

:warning: If you're uncomfortable running a script you downloaded off the internet with sudo, you can extract any of the steps out of the install.sh script and run them manually.

INSaFLU:

	$ git clone https://github.com/INSaFLU/docker.git
	$ cd docker
	
	## to define the directory where the data will be saved and the web port exposed, edit the .env file: 
	$ cp .env_temp .env
	$ vi .env
	OR
	$ nano .env
	
	$ sudo ./build.sh
	$ sudo ./up.sh
	
	## create an user, in other terminal or you can use 'screen' in previous steps
	$ docker exec -it insaflu-server create-user
	
Now, you can go to a web explorer and link to the address "127.0.0.1:<port defined in .env>". Default port is 8080

To stop:

	$ sudo ./stop.sh

To start again:

	$ sudo ./up.sh
	
	
## Commands available

With these commands you can interact with INSaFLU image to do several tasks.

How to run:
	
	$ docker exec -it insaflu-server <<command>>

Commands:

	* confirm-email-account
	* create-user			## to create an user in insaflu
	* list-all-users		## list all users in insaflu
	* update-password		## update password for a specific user
	* remove-fastq-files
	* restart-apache		## restart web server, for example, after change something in insaflu/env/insaflu.env file
	* test-email-server		## test you smtp server, change parameters first in insaflu/env/insaflu.env file
	* unlock-upload-files
	* update-tbl2asn		## every year it is necessary update the tbl2asn ncbi software
	* upload-reference-dbs		## place new references in db/references and you can update them
 

Examples:
```
$ docker exec -it insaflu-server create-user
$ docker exec -it insaflu-server update-tbl2asn
$ docker exec -it insaflu-server restart-apache
$ docker exec -it insaflu-server update-password <some login>
```


## Change variables in your local environment

You can customize your environment.

For instance, users can change the maximum reads size for upload (e.g., MAX_FASTQ_FILE_UPLOAD = 104857600), indicate if the files should be (or not) downsized after upload (i.e., DOWN_SIZE_FASTQ_FILES = True/False), indicate the maximum files size after downsizing (e.g. MAX_FASTQ_FILE_WITH_DOWNSIZE = 429916160), etc.

```
#### get into INSaFLU docker
$ docker exec -it insaflu-server /bin/bash
#### change the values here
$ vi /insaflu_web/INSaFLU/.env
### get out INSaFLU  docker
$ Ctrl^D
### restart apache
$ docker exec -it insaflu-server restart-apache
```

If you want to perpetuate the changes in future updates of INSaFLU webserver you also need to update "insaflu/env/insaflu.env".


## Update database for rapid assignment of segments/references to contigs


Some influenza sequences of the abricate database for "contigs2sequences" assignment currently being used on INSaFLU free website (latest version can be found here: https://insaflu.readthedocs.io/en/latest/data_analysis.html#type-and-sub-type-identification) are not included as part of this repository as they are protected by the terms of GISAID sharing (we gratefully acknowledge the Authors, Originating and Submitting laboratories, as indicated in the lists provided in the Documentation). These sequences will need to be collected by the user and the database will need to be build based on abricate instructions on "making your own database" (https://github.com/tseemann/abricate). Please contact us if you need help for building the database currently being used on INSaFLU free website.

## Update INSaFLU docker installation (keeping your previous data)

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


