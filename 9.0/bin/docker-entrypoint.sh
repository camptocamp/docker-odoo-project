#!/bin/bash
set -e

# allow to customize the UID of the odoo user,
# so we can share the same than the host's.
# If no user id is set, we use 9001
# so we have hardly any chance to collide
# with an existing UID on the host
# See https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
id -u odoo &> /dev/null || useradd --shell /bin/bash -u $USER_ID -o -c "" -m odoo

BASEDIR=$(dirname $0)

# Accepted values for DEMO: True / False
# Odoo use a reverse boolean for the demo, which is not handy,
# that's why we propose DEMO which exports WITHOUT_DEMO used in
# openerp.cfg.tmpl
if [ -z "$DEMO" ]; then
  $DEMO=False
fi
case "$(echo "${DEMO}" | tr '[:upper:]' '[:lower:]' )" in
  "false")
    echo "Running without demo data"
    export WITHOUT_DEMO=all
    ;;
  "true")
    echo "Running with demo data"
    export WITHOUT_DEMO=
    ;;
  # deprecated options:
  "odoo")
    echo "Running with demo data"
    echo "DEMO=odoo is deprecated, use DEMO=True"
    export WITHOUT_DEMO=
    ;;
  "none")
    echo "Running without demo data"
    echo "DEMO=none is deprecated, use DEMO=False"
    export WITHOUT_DEMO=all
    ;;
  "scenario")
    echo "DEMO=scenario is deprecated, use DEMO=False and MARABUNTA_MODE=demo with a demo mode in migration.yml"
    exit 1
    ;;
  "all")
    echo "DEMO=all is deprecated, use DEMO=True and MARABUNTA_MODE=demo with a demo mode in migration.yml"
    exit 1
    ;;
  *)
    echo "Value '${DEMO}' for DEMO is not a valid value in 'False', 'True'"
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

  chown -R odoo: /data/odoo
  chown -R odoo: /var/log/odoo

  gosu odoo bin/migrate
  exec gosu odoo "$@"
fi

exec "$@"
