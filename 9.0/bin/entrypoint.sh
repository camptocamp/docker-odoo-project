#!/bin/bash
set -e

BASEDIR=$(dirname $0)
$BASEDIR/wait_postgres.sh

if [ "$1" = "./src/odoo/odoo.py" ]; then
  chown -R odoo .
  chown -R odoo /data/odoo

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"

