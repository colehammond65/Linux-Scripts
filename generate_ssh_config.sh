#!/bin/bash

# Output ssh_config file
OUTPUT_FILE="ssh_config"

# Clear the output file
> "$OUTPUT_FILE"

# Get a list of all LXC containers
for CTID in $(pct list | awk 'NR>1 {print $1}'); do
    # Retrieve the container hostname
    HOSTNAME=$(pct exec "$CTID" hostname 2>/dev/null)
    
    # Retrieve the container's network configuration
    NET_CONFIG=$(pct config "$CTID" | grep net0)
    
    # Extract the IP address from the network configuration
    IP_ADDRESS=$(echo "$NET_CONFIG" | grep -oP 'ip=\K[\d\.]+')
    
    # Skip if no IP address is found
    if [[ -z "$IP_ADDRESS" ]]; then
        echo "Skipping container $CTID (no IP address found)"
        continue
    fi
    
    # Append the ssh_config entry
    echo "Host $HOSTNAME" >> "$OUTPUT_FILE"
    echo "  HostName $IP_ADDRESS" >> "$OUTPUT_FILE"
    echo "  User root" >> "$OUTPUT_FILE"  # Adjust if needed
    echo "  Port 22" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    
    echo "Added container $CTID ($HOSTNAME) to ssh_config"
done

echo "SSH config written to $OUTPUT_FILE"
