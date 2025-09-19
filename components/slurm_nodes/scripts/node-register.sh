#!/bin/bash
# Node registration script for dynamic SLURM nodes
# This script registers a node with the SLURM controller and updates the configuration

set -e

NODE_NAME=${HOSTNAME:-$(hostname)}
CONTROLLER_HOST=${SLURM_CONTROLLER:-slurmctld}
NODE_ID=${NODE_ID:-1}
MEMORY=${NODE_MEMORY:-1000}
CPUS=${NODE_CPUS:-1}

echo "Registering SLURM node: $NODE_NAME"

# Wait for SLURM controller to be available
echo "Waiting for SLURM controller at $CONTROLLER_HOST..."
while ! nc -z $CONTROLLER_HOST 6817; do
    sleep 2
done
echo "SLURM controller is available"

# Create dynamic node configuration
NODE_CONFIG="NodeName=${NODE_NAME} RealMemory=${MEMORY} CPUs=${CPUS} State=UNKNOWN"

# Add node to SLURM configuration if not already present
if ! grep -q "NodeName=${NODE_NAME}" /etc/slurm/slurm.conf; then
    echo "Adding node configuration: $NODE_CONFIG"
    # Add before the PARTITIONS section
    sed -i "/^# PARTITIONS/i $NODE_CONFIG" /etc/slurm/slurm.conf
    
    # Signal SLURM controller to reconfigure
    echo "Notifying SLURM controller to reconfigure..."
    scontrol reconfigure || echo "Warning: Could not reconfigure SLURM controller"
fi

# Update node state to IDLE
echo "Setting node state to IDLE..."
scontrol update NodeName=$NODE_NAME State=IDLE || echo "Warning: Could not update node state"

echo "Node $NODE_NAME registered successfully"