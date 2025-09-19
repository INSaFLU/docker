#!/bin/bash
# Node deregistration script for dynamic SLURM nodes
# This script removes a node from the SLURM cluster

set -e

NODE_NAME=${HOSTNAME:-$(hostname)}
CONTROLLER_HOST=${SLURM_CONTROLLER:-slurmctld}

echo "Deregistering SLURM node: $NODE_NAME"

# Set node to DRAIN state first
echo "Draining node $NODE_NAME..."
scontrol update NodeName=$NODE_NAME State=DRAIN Reason="Node being removed" || echo "Warning: Could not drain node"

# Wait for jobs to complete (with timeout)
TIMEOUT=300  # 5 minutes
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    if squeue -h -w $NODE_NAME | grep -q .; then
        echo "Waiting for jobs to complete on $NODE_NAME..."
        sleep 10
        ELAPSED=$((ELAPSED + 10))
    else
        break
    fi
done

# Force DOWN state
echo "Setting node $NODE_NAME to DOWN state..."
scontrol update NodeName=$NODE_NAME State=DOWN || echo "Warning: Could not set node to DOWN"

echo "Node $NODE_NAME deregistered successfully"