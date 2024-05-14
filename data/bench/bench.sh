#!/bin/bash

DB_NAME="mydatabase"  # Set the database name
DB_USER="postgres"      # Set the database user
cd /tmp
while true; do
    # Add 100 rows with 'data' as 'x' and 'num' as a random number

    # Insert 100 rows with 'data' as 'x' and 'num' as a random number, all at once
    insert_query="INSERT INTO test (num, data) VALUES "
    values=()
    for i in {1..100}; do
        random_num=$((RANDOM % 1000))  # Generate a random number between 0 and 999
        values+=("($random_num, 'x')")
    done
    # Join all values into a single string separated by commas and execute the insert
    insert_query+=$(IFS=,; echo "${values[*]}")
    echo "$insert_query;" | sudo -u $DB_USER psql $DB_NAME >/dev/null 2>&1

    # Calculate the sum of all 'num' values where 'data' is 'x', then insert a new row with this sum and 'data' as 'run'
    echo "INSERT INTO test (num, data) SELECT SUM(num), 'run' FROM test WHERE data = 'x';" | sudo -u $DB_USER psql $DB_NAME >/dev/null 2>&1

    # Delete all rows where 'data' is 'x'
    echo "DELETE FROM test WHERE data = 'x';" | sudo -u $DB_USER psql $DB_NAME

    # Optional: sleep for a period to slow down the loop or handle the next iteration
    #sleep 1  # Adjust sleep time as needed for your use case
done
