#!/bin/bash
set -e

BASEDIR=$(dirname $0)
$BASEDIR/wait_postgres.sh

if [ "$1" = "./src/odoo.py" ]; then
  chown -R odoo .
  chown -R odoo /data/odoo

  if [ -e etc/openerp.cfg.tmpl ]; then
    dockerize -template etc/openerp.cfg.tmpl:etc/openerp.cfg
  fi

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"

