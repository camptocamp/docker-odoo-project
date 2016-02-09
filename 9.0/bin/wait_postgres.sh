#!/bin/bash
set -e

while ! PGPASSWORD=$DB_PASS psql -h db -U $DB_USER </dev/null >/dev/null 2>&1
do
  echo "Waiting for db to come up..."
  sleep 1
done
