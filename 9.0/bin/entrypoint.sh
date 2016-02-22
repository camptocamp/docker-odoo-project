#!/bin/bash
set -e

BASEDIR=$(dirname $0)

CONFIGDIR=$BASEDIR/..
if [ -e $CONFIGDIR/etc/openerp.cfg.tmpl ]; then
  dockerize -template $CONFIGDIR/etc/openerp.cfg.tmpl:$CONFIGDIR/etc/openerp.cfg
fi

$(dirname $0)/wait_postgres.sh

if [ "$1" = "./src/odoo.py" ] || [ "$1" = "src/odoo.py" ]; then
  chown -R odoo .
  chown -R odoo /data/odoo

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"

