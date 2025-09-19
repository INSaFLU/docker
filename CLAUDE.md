# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

INSaFLU ("INSide the FLU") is a bioinformatics free web-based suite for viral influenza and SARS-CoV-2 laboratory surveillance. This repository contains the Docker-based deployment setup for a local INSaFLU instance with integrated SLURM cluster management and optional TELEVIR viral detection module.

## Architecture

The system uses a multi-container Docker architecture with the following key services:

- **insaflu-ubuntu** (container: insaflu-ubuntu, IP: 10.1.0.4): Main INSaFLU web application server
- **db_insaflu** (container: postgres, IP: 10.1.0.2): PostgreSQL database with PostGIS extension
- **televir-server** (container: televir-server, IP: 10.1.0.5): Optional viral detection module
- **SLURM cluster**: Job scheduling system with:
  - **slurmctld**: Control daemon
  - **slurmdbd**: Database daemon  
  - **c1, c2** (IPs: 10.1.0.6, 10.1.0.7): Compute nodes
  - **mysql**: MariaDB for SLURM accounting

The services communicate over two networks:
- `insaflu_ubuntu_net` (10.1.0.0/24): Main application network
- `slurm-network`: Internal SLURM cluster communication

## Essential Commands

### Setup and Installation
```bash
# Initial setup - copy environment template and edit configuration
cp .env_temp .env
# Edit .env to set BASE_PATH_DATA, APP_PORT, TIMEZONE, etc.

# Build all containers
./build.sh

# Install TELEVIR module (optional, takes several hours)
./up_televir.sh

# Start INSaFLU services
./up.sh

# Create admin user (run in separate terminal)
docker exec -it insaflu-ubuntu create-user
```

### Daily Operations
```bash
# Start services
./up.sh

# Stop all services
./stop.sh

# Check container status
docker ps
```

### Administration Commands
Execute these commands with: `docker exec -it insaflu-ubuntu <command>`

- `create-user`: Create a new INSaFLU user
- `list-all-users`: List all registered users
- `update-password`: Update user password
- `restart-apache`: Restart web server
- `update-insaflu`: Update INSaFLU software to latest version
- `remove-fastq-files`: Remove FASTQ files to save disk space
- `unlock-upload-files`: Unlock zombie file uploads
- `upload-reference-dbs`: Update reference databases
- `update-nextstrain_builds`: Update Nextstrain builds
- `test-email-server`: Test SMTP configuration

### Configuration Files

#### Environment Variables (.env)
Key variables to configure:
- `BASE_PATH_DATA`: Host directory for persistent data storage
- `APP_PORT`: Web interface port (default: 8080)
- `TIMEZONE`: System timezone
- `USERNAME_IMAGE`: Docker image prefix
- `SLURM_TAG`: SLURM version tag

#### TELEVIR Configuration
Modify `components/televir/configs/config_install.py` to control which software and databases are installed:
- Viral databases: RefSeq, SwissProt, RVDB, Virosaurus
- Host genomes: Human (hg38), various animal species
- Classification tools: Centrifuge, Kraken2, Diamond, BLAST
- Assembly tools: SPAdes, Raven

After modifying, run:
```bash
./build.sh
./up_televir.sh
```

## Data Persistence

Persistent volumes are mounted to `${BASE_PATH_DATA}`:
- `/postgres/postgres_data`: Database files
- `/insaflu/data/all_data`: INSaFLU media files
- `/insaflu/data/predefined_dbs`: Reference databases
- `/insaflu/env`: Environment configuration
- `/insaflu/log/`: Application logs
- `/televir/`: TELEVIR data and databases

## Development Notes

- Web interface accessible at `http://localhost:${APP_PORT}` (default: 8080)
- Database connection: PostgreSQL on port 5432 (internal network only)
- SLURM job submission happens through the compute nodes (c1, c2)
- Logs are available in mounted volumes and via `docker logs <container-name>`
- The system uses local-persist Docker plugin for volume management (not compatible with WSL2)

## Updates

### Update INSaFLU software only:
```bash
docker exec -it insaflu-ubuntu update-insaflu
```

### Update entire Docker installation:
```bash
./stop.sh
git pull
docker image rm -f <insaflu-ubuntu-image-id>
./build.sh
./up.sh
```

### Customizing INSaFLU Configuration
Edit variables in the running container:
```bash
docker exec -it insaflu-ubuntu /bin/bash
vi /insaflu_web/INSaFLU/.env
# Exit container, then restart apache
docker exec -it insaflu-ubuntu restart-apache
```

To persist changes across updates, also edit `insaflu/env/insaflu.env` in the mounted volume.