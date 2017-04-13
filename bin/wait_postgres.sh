#!/bin/bash
#
# Wait until postgresql is running.
#
set -e

BASEDIR=$(dirname $0)
CONFIGDIR=$BASEDIR/../etc

dockerize -timeout 30s -wait tcp://${DB_HOST}:${DB_PORT}

# now the port is up but sometimes postgres is not totally ready yet:
# 'createdb: could not connect to database template1: FATAL:  the database system is starting up'
# we retry if we get this error

while [ "$(PGPASSWORD=$DB_PASSWORD psql -h ${DB_HOST} -U $DB_USER -c '' postgres 2>&1)" = "psql: FATAL:  the database system is starting up" ]
do
  echo "Waiting for the database system to start up"
  sleep 0.1
done
