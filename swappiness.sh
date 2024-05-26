#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Ask the user for the swappiness value
read -p "Enter the swappiness value (default is 10): " swappiness
swappiness=${swappiness:-10}  # If no value provided, default to 10

# Set swappiness to the user-provided value now
sysctl vm.swappiness=$swappiness

# Set swappiness to the user-provided value for future boots
echo "vm.swappiness = $swappiness" >> /etc/sysctl.conf

echo "Swappiness has been set to $swappiness"