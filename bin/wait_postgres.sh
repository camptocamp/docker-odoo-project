#!/bin/bash
#
# Wait until postgresql is running.
#
set -e

if [[ -d $DB_HOST ]]; then
    dockerize -timeout 30s -wait unix://${DB_HOST}/.s.PGSQL.${DB_PORT}
else
    dockerize -timeout 30s -wait tcp://${DB_HOST}:${DB_PORT}
fi

# now the port is up but sometimes postgres is not totally ready yet:
# 'createdb: could not connect to database template1: FATAL:  the database system is starting up'
# we retry if we get this error

while [ "$(PGPASSWORD=$DB_PASSWORD psql -h ${DB_HOST} -U $DB_USER -c '' postgres 2>&1)" = "psql: FATAL:  the database system is starting up" ]
do
  echo "Waiting for the database system to start up"
  sleep 0.1
done
