#!/bin/bash

# Define the directory containing LXC container configuration files
config_dir="/etc/pve/lxc/"

# Ask the user for the desired swappiness value
read -p "Enter the desired swappiness value: " desired_swappiness

# Validate the user input to ensure it's a number between 0 and 100
if ! [[ "$desired_swappiness" =~ ^[0-9]+$ ]] || [ "$desired_swappiness" -lt 0 ] || [ "$desired_swappiness" -gt 100 ]; then
    echo "Invalid swappiness value. Please enter a number between 0 and 100."
    exit 1
fi

# Iterate through each configuration file in the directory
for conf_file in ${config_dir}*.conf; do
    echo "Processing file: $conf_file"
    # Check if the file exists and is a regular file
    if [ -f "$conf_file" ]; then
        echo "File exists: $conf_file"
        # Add or modify the swappiness parameter in the configuration file
        # Check if the parameter already exists
        if grep -q "^lxc.cgroup.memory.swappiness" "$conf_file"; then
            echo "Swappiness parameter found in $conf_file, updating value..."
            # If it exists, replace the existing value
            sed -i "s/^lxc.cgroup.memory.swappiness.*/lxc.cgroup.memory.swappiness = ${desired_swappiness}/" "$conf_file"
        else
            echo "Swappiness parameter not found in $conf_file, adding it..."
            # If it doesn't exist, add it to the end of the file
            echo "lxc.cgroup.memory.swappiness = ${desired_swappiness}" >> "$conf_file"
        fi
        echo "Updated $conf_file with swappiness value $desired_swappiness"
    else
        echo "File does not exist or is not a regular file: $conf_file"
    fi
done

echo "All LXC container configuration files in $config_dir have been updated."
