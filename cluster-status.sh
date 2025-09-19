#!/bin/bash
# Show SLURM cluster status and running compute nodes
# Usage: ./cluster-status.sh

set -e

echo "=== SLURM Cluster Status ==="

# Show Docker containers
echo ""
echo "Running containers:"
docker ps --filter "name=slurm" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Show SLURM node information
echo ""
echo "SLURM nodes:"
if docker exec -it insaflu-ubuntu sinfo -N 2>/dev/null; then
    echo ""
    echo "SLURM node details:"
    docker exec -it insaflu-ubuntu scontrol show nodes 2>/dev/null | grep -E "(NodeName|State|CPUTot|RealMemory)" || true
else
    echo "Could not retrieve SLURM node information (cluster may not be ready)"
fi

# Show running jobs
echo ""
echo "Running jobs:"
docker exec -it insaflu-ubuntu squeue 2>/dev/null || echo "No jobs currently running"

# Show cluster statistics
echo ""
echo "=== Cluster Statistics ==="
TOTAL_CONTAINERS=$(docker ps --filter "name=slurm-node" --format "{{.Names}}" | wc -l)
echo "Total compute node containers: $TOTAL_CONTAINERS"

if [ $TOTAL_CONTAINERS -gt 0 ]; then
    echo "Compute node names:"
    docker ps --filter "name=slurm-node" --format "  - {{.Names}}"
fi