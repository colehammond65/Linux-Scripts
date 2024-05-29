#!/bin/bash

# Define the MySQL/MariaDB credentials
USER="your_username"
PASSWORD="your_password"
HOST="localhost"

# Get a list of all databases
DATABASES=$(mysql -u $USER -p$PASSWORD -h $HOST -e 'SHOW DATABASES;' | grep -Ev "(Database|information_schema|performance_schema)")

# Loop through each database and export it to a file
for DB in $DATABASES; do
    echo "Exporting database: $DB"
    mysqldump -u $USER -p$PASSWORD -h $HOST $DB > "${DB}.sql"
done

echo "All databases have been exported."
