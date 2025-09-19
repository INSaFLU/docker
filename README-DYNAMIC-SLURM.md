# Dynamic SLURM Node Scaling

This branch implements dynamic scaling capabilities for the SLURM cluster in the INSaFLU Docker environment.

## Overview

The original setup had two hardcoded compute nodes (`c1` and `c2`). This implementation allows you to:

- Start INSaFLU without any compute nodes
- Dynamically add compute nodes as needed
- Remove compute nodes when not required
- Monitor cluster status and node health

## Key Changes

### Architecture Changes
1. **Removed static node definitions** from `docker-compose.yml`
2. **Created parameterized node template** (`docker-compose-node-template.yml`)
3. **Modified SLURM configuration** to support dynamic node discovery
4. **Added node management scripts** for registration/deregistration

### New Files
- `docker-compose-node-template.yml` - Template for creating compute nodes
- `scale-up.sh` - Add compute nodes to the cluster
- `scale-down.sh` - Remove compute nodes from the cluster
- `cluster-status.sh` - Show cluster and node status
- `components/slurm_nodes/scripts/node-register.sh` - Node registration logic
- `components/slurm_nodes/scripts/node-deregister.sh` - Node cleanup logic

## Usage

### Starting the Base System
```bash
# Start INSaFLU without compute nodes
./up.sh
```

### Adding Compute Nodes
```bash
# Add 2 compute nodes
./scale-up.sh 2

# Add 1 compute node (default)
./scale-up.sh
```

### Removing Compute Nodes
```bash
# Remove 1 compute node (default)
./scale-down.sh

# Remove 3 compute nodes
./scale-down.sh 3
```

### Monitoring the Cluster
```bash
# Show cluster status, running containers, and SLURM node information
./cluster-status.sh
```

## Node Lifecycle

### Node Startup
1. Container starts with unique hostname (`slurm-node-N`)
2. Node registration script (`node-register.sh`) runs
3. Node configuration is added to SLURM
4. SLURM controller is notified to reconfigure
5. Node state is set to IDLE and ready for jobs

### Node Shutdown
1. Graceful drain initiated via `node-deregister.sh`
2. Existing jobs are allowed to complete (5-minute timeout)
3. Node state set to DOWN
4. Container is stopped and removed

## Technical Details

### SLURM Configuration
- Uses `NodeName=DEFAULT` for dynamic node definitions
- Partitions configured with `Nodes=ALL` to accept any registered nodes
- Node registration handled through `scontrol` commands

### Container Networking
- Nodes join both `slurm-network` and `insaflu_ubuntu_net`
- Dynamic IP allocation (no static IPs)
- Service discovery through Docker DNS

### Volume Sharing
- All necessary volumes are shared with compute nodes
- External volume references ensure proper mounting
- Shared storage for SLURM job data and software

## Limitations and Considerations

1. **Node Recovery**: If a node container crashes, it must be manually restarted
2. **Job Migration**: Jobs don't automatically migrate when nodes are removed
3. **Network Partition**: Nodes removed too quickly may leave orphaned SLURM entries
4. **Resource Constraints**: No automatic resource-based scaling

## Migration from Static Setup

To migrate from the original static setup:

1. Stop all containers: `./stop.sh`
2. Switch to this branch: `git checkout dynamic-slurm`
3. Rebuild containers: `./build.sh`
4. Start base system: `./up.sh`
5. Add desired compute nodes: `./scale-up.sh 2`

## Future Enhancements

- Auto-scaling based on job queue length
- Health checks and automatic node recovery
- Integration with container orchestration platforms
- Resource-aware node allocation
- Persistent node state management