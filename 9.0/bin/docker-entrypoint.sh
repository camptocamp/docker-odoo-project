#!/bin/bash
set -e

BASEDIR=$(dirname $0)

# Accepted values for DEMO:
# - none/false (default value): no demo data
# - odoo: create Odoo's database with Odoo's demo data (only works at the
#         creation of the database!)
# - scenario: load the demo from the scenario
# - all: lead both Odoo's demo data and the scenario demo data
# WITHOUT_DEMO:
# Odoo use a reverse boolean for the demo.
# We export WITHOUTH_DEMO so we can use it for the configuration file
# openerp.cfg.tmpl, which contains a line:
# without_demo = {{ default .Env.WITHOUT_DEMO "True" }}
case "${DEMO}" in
  "all")
    echo "Running with demo data from Odoo and Scenario"
    export WITHOUT_DEMO=False
    ;;
  "odoo")
    echo "Running with demo data from Odoo only"
    export WITHOUT_DEMO=False
    ;;
  "scenario")
    echo "Running with demo data from Scenario only"
    export WITHOUT_DEMO=True
    ;;
  "none")
    echo "Running without demo data"
    export WITHOUT_DEMO=True
    ;;
  *)
    echo "Value '${DEMO}' for DEMO is not a valid value in 'none', 'odoo', 'scenario', 'all'"
    exit 1
    ;;
esac

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

BASE_CMD=$(basename $1)
if [ "$BASE_CMD" = "odoo.py" ]; then

  chown -R odoo .
  chown -R odoo /data/odoo

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"
