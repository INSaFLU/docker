#!/bin/bash
# Scale down SLURM compute nodes
# Usage: ./scale-down.sh [number_of_nodes]

set -e

# Number of nodes to remove (default: 1)
NUM_NODES=${1:-1}

echo "Scaling down SLURM cluster by $NUM_NODES compute nodes..."

# Get list of current node containers
CURRENT_NODES=($(docker ps --filter "name=slurm-node" --format "{{.Names}}" | sort))
TOTAL_NODES=${#CURRENT_NODES[@]}

if [ $TOTAL_NODES -eq 0 ]; then
    echo "No SLURM nodes currently running"
    exit 0
fi

if [ $NUM_NODES -ge $TOTAL_NODES ]; then
    echo "Warning: Attempting to remove $NUM_NODES nodes, but only $TOTAL_NODES exist"
    echo "Will remove all existing nodes"
    NUM_NODES=$TOTAL_NODES
fi

# Remove nodes from the end of the list
for ((i=TOTAL_NODES-1; i>=TOTAL_NODES-NUM_NODES; i--)); do
    NODE_NAME=${CURRENT_NODES[$i]}
    echo "Removing node: $NODE_NAME"
    
    # Gracefully drain and remove the node
    docker exec -it "$NODE_NAME" /scripts/node-deregister.sh || echo "Warning: Could not deregister node"
    
    # Stop and remove the container
    docker stop "$NODE_NAME" || echo "Warning: Could not stop container"
    docker rm "$NODE_NAME" || echo "Warning: Could not remove container"
    
    echo "Removed node: $NODE_NAME"
done

REMAINING_NODES=$((TOTAL_NODES - NUM_NODES))
echo "Successfully scaled down cluster by $NUM_NODES nodes"
echo "Remaining nodes: $REMAINING_NODES"

# Show current SLURM node status
if [ $REMAINING_NODES -gt 0 ]; then
    echo "Current SLURM nodes:"
    docker exec -it insaflu-ubuntu sinfo -N || echo "Could not retrieve node status"
else
    echo "No compute nodes remaining in cluster"
fi