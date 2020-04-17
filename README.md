<p align="center"><img src="logo/logo_insaflu.png" alt="INSaFLU" width="300"></p>


[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# INSaFLU - docker installation

INSaFLU (“INSide the FLU”) is an influenza-oriented bioinformatics free web-based platform for an effective and timely whole-genome-sequencing-based influenza laboratory surveillance.

## Hardware Requirements

* Processor: 8 cores (4 minimal);
* RAM: 32GB of memory (16GB minimal);
* Disk Space: 512GB;


## Installation

Docker:

* Install [docker](https://docs.docker.com/engine/install/) in your linux server;
* Install [docker-compose](https://docs.docker.com/compose/install/) in your linux server;

	$ sudo curl –L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	
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
	$ vi .env
	
	$ sudo ./build
	$ sudo ./up
	
	## create an user, in other terminal or you can use 'screen' in previous steps
	$ docker exec -it insaflu-server create-user
	
Now, you can go to a web explorer and link to the address "127.0.0.1:<port defined in .env>"

To stop:

	$ sudo ./stop

To start again:

	$ sudo ./up
	
	
## Commands available

With these commands you can interact with INSaFLU image to do several tasks.

How to run:
	
	$ docker exec -it insaflu-server <<command>>

Commands:

	* confirm-email-account
	* create-user			## to create an user in insaflu
	* list-all-users		## list all users in insaflu
	* remove-fastq-files		
	* restart-apache		## restart web server, for example, after change something in insaflu/env/insaflu.env file
	* test-email-server		## test you smtp server, change parameters first in insaflu/env/insaflu.env file
	* unlock-upload-files		
	* update-tbl2asn		## every year is necessary update the tbl2asn ncbi software
	* upload-reference-dbs		## place new references in db/references and you can update them
 

Examples:
```
$ docker exec -it insaflu-server create-user
$ docker exec -it insaflu-server update-tbl2asn
$ docker exec -it insaflu-server restart-apache
```


## Change variables in your local environment

You can customize your environment by changing the "insaflu/env/insaflu.env" located in the directory where your data is being saved.

For instance, users can change the maximum reads size for upload (e.g., MAX_FASTQ_FILE_UPLOAD = 104857600), indicate if the files should be (or not) downsized after upload (i.e., DOWN_SIZE_FASTQ_FILES = True/False), indicate the maximum files size after downsizing (e.g. MAX_FASTQ_FILE_WITH_DOWNSIZE = 429916160), etc.

After editing the "insaflu.env" file, restart the web server:
```
$ docker exec -it insaflu-server restart-apache
```

## Update database for rapid assignment of segments/references to contigs


Some influenza sequences of the abricate database for "contigs2sequences" assignment currently being used on INSaFLU free website (latest version can be found here: https://insaflu.readthedocs.io/en/latest/data_analysis.html#type-and-sub-type-identification) are not included as part of this repository as they are protected by the terms of GISAID sharing (we gratefully acknowledge the Authors, Originating and Submitting laboratories, as indicated in the lists provided in the Documentation). These sequences will need to be collected by the user and the database will need to be build based on abricate instructions on "making your own database" (https://github.com/tseemann/abricate). Please contact us if you need help for building the database currently being used on INSaFLU free website.


