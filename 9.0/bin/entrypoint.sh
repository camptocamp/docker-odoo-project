#!/bin/bash
set -e

BASEDIR=$(dirname $0)

# Create configuration file from the template
CONFIGDIR=$BASEDIR/../etc
if [ -e $CONFIGDIR/openerp.cfg.tmpl ]; then
  dockerize -template $CONFIGDIR/openerp.cfg.tmpl:$CONFIGDIR/openerp.cfg
fi

if [ ! -f "$CONFIGDIR/openerp.cfg" ]; then
  echo "Error: either etc/openerp.cfg.tmpl, either etc/openerp.cfg is required"
  exit 1
fi

# Wait until postgres is up
$BASEDIR/wait_postgres.sh

if [ "$1" = "./src/odoo.py" ] || [ "$1" = "src/odoo.py" ]; then
  chown -R odoo .
  chown -R odoo /data/odoo

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"

