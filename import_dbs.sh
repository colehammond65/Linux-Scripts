#!/bin/bash

# Define the MySQL/MariaDB credentials
USER="your_username"
PASSWORD="your_password"
HOST="localhost"

# Loop through each .sql file in the current directory and import it
for FILE in *.sql; do
    # Extract the database name from the filename
    DB=$(basename "$FILE" .sql)
    
    # Create the database if it doesn't exist
    echo "Creating database: $DB if it doesn't exist"
    mysql -u $USER -p$PASSWORD -h $HOST -e "CREATE DATABASE IF NOT EXISTS $DB"
    
    # Import the SQL file into the database
    echo "Importing $FILE into database: $DB"
    mysql -u $USER -p$PASSWORD -h $HOST $DB < "$FILE"
done

echo "All databases have been imported."
