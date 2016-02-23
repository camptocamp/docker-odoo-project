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
