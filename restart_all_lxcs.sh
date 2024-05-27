#!/bin/bash

# Get a list of all LXC container IDs
containers=$(pct list | awk 'NR>1 {print $1}')

# Restart each container
for container in $containers; do
    echo "Restarting container $container..."
    pct restart $container
done

echo "All LXC containers have been restarted."
