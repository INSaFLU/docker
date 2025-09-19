#!/bin/bash
# Scale up SLURM compute nodes
# Usage: ./scale-up.sh [number_of_nodes]

set -e

source .env

# Number of nodes to add (default: 1)
NUM_NODES=${1:-1}

echo "Scaling up SLURM cluster by $NUM_NODES compute nodes..."

# Get current highest node number
CURRENT_NODES=$(docker ps --filter "name=slurm-node" --format "table {{.Names}}" | grep -c "slurm-node" || echo 0)
NEXT_NODE_ID=$((CURRENT_NODES + 1))

# Start new nodes
for i in $(seq 1 $NUM_NODES); do
    NODE_ID=$((NEXT_NODE_ID + i - 1))
    NODE_NAME="slurm-node-$NODE_ID"
    
    echo "Starting node: $NODE_NAME"
    
    # Export environment variables for this node
    export NODE_ID=$NODE_ID
    export HOSTNAME=$NODE_NAME
    
    # Start the node container
    docker-compose -f docker-compose-node-template.yml \
        -p "${COMPOSE_PROJECT_NAME:-docker}_node_$NODE_ID" \
        up -d
    
    # Rename the container to have a meaningful name
    docker rename "${COMPOSE_PROJECT_NAME:-docker}_node_${NODE_ID}_slurm-node_1" "$NODE_NAME" || true
    
    echo "Started node: $NODE_NAME"
done

echo "Successfully scaled up cluster by $NUM_NODES nodes"
echo "Total nodes now: $((CURRENT_NODES + NUM_NODES))"

# Show current SLURM node status
echo "Current SLURM nodes:"
docker exec -it insaflu-ubuntu sinfo -N || echo "Could not retrieve node status"