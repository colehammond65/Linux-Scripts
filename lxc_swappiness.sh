#!/bin/bash

# Define the directory containing LXC container configuration files
config_dir="/etc/pve/lxc/"

# Define the desired swappiness value
desired_swappiness="10"

# Iterate through each configuration file in the directory
for conf_file in ${config_dir}*.conf; do
    # Check if the file exists and is a regular file
    if [ -f "$conf_file" ]; then
        # Add or modify the swappiness parameter in the configuration file
        # Check if the parameter already exists
        if grep -q "^lxc.cgroup.memory.swappiness" "$conf_file"; then
            # If it exists, replace the existing value
            sed -i "s/^lxc.cgroup.memory.swappiness.*/lxc.cgroup.memory.swappiness = ${desired_swappiness}/" "$conf_file"
        else
            # If it doesn't exist, add it to the end of the file
            echo "lxc.cgroup.memory.swappiness = ${desired_swappiness}" >> "$conf_file"
        fi
        echo "Updated $conf_file with swappiness value $desired_swappiness"
    fi
done

echo "All LXC container configuration files in $config_dir have been updated."
