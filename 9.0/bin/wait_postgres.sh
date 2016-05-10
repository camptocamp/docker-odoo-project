#!/bin/bash
#
# Wait until postgresql is running.
#
set -e

BASEDIR=$(dirname $0)
CONFIGDIR=$BASEDIR/../etc

dockerize -wait tcp://db:${DB_PORT}
# port is up before postgres is totally ready:
# 'createdb: could not connect to database template1: FATAL:  the database system is starting up'
# wait a little bit more
sleep 1
