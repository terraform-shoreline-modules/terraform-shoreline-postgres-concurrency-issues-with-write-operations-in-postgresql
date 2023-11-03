

#!/bin/bash



# Set variables

database=${DATABASE_NAME}

table=${TABLE_NAME}



# Check for active write operations

active_writes=$(psql -d $database -c "SELECT count(*) FROM pg_stat_activity WHERE query LIKE '%INSERT INTO $table%' OR query LIKE '%UPDATE $table%' OR query LIKE '%DELETE FROM $table%'")



# Check for locks on the table

table_locks=$(psql -d $database -c "SELECT count(*) FROM pg_locks WHERE relation::regclass = '$table'::regclass")



# Check for blocked processes

blocked_processes=$(psql -d $database -c "SELECT count(*) FROM pg_stat_activity WHERE waiting='t'")



# Output results

echo "Active write operations: $active_writes"

echo "Table locks: $table_locks"

echo "Blocked processes: $blocked_processes"