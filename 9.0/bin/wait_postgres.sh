#!/bin/bash
#
# Wait until postgresql is running.
#
set -e

BASEDIR=$(dirname $0)
CONFIGDIR=$BASEDIR/../etc

DB_PORT=$(grep db_port $CONFIGDIR/openerp.cfg | cut -d ' ' -f 3)
if [ -z $DB_PORT ]; then
  DB_PORT=5432
fi
dockerize -wait tcp://db:${DB_PORT}
# port is up before postgres is totally ready:
# 'createdb: could not connect to database template1: FATAL:  the database system is starting up'
# wait a little bit more
sleep 1
