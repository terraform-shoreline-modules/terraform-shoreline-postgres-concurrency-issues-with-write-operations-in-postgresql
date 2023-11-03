bash

#!/bin/bash



# Define variables

database=${DATABASE_NAME}

table=${TABLE_NAME}

id=${ID_VALUE}



# Connect to PostgreSQL

psql -d $database -c "BEGIN; LOCK TABLE $table IN ROW EXCLUSIVE MODE; UPDATE $table SET column = value WHERE id = $id; COMMIT;"