#!/bin/bash
set -e

# Display the user_id used by odoo
echo "Starting with UID : $(id -u)"

export PGHOST=${DB_HOST}
export PGPORT=${DB_PORT}
export PGUSER=${DB_USER}
export PGDATABASE=${DB_NAME}
export PGAPPNAME=${HOSTNAME}

# As docker-compose exec do not launch the entrypoint
# init PG variable into .bashrc so it will be initialized
# when doing docker-compose exec odoo gosu odoo bash
echo "
export PGHOST=${DB_HOST}
export PGPORT=${DB_PORT}
export PGUSER=${DB_USER}
export PGDATABASE=${DB_NAME}
export PGAPPNAME=${HOSTNAME}
" >>/odoo/.bashrc

# Only set PGPASSWORD if there is no .pgpass file
if [ ! -f /odoo/.pgpass ]; then
  export PGPASSWORD=${DB_PASSWORD}
  echo "
    export PGPASSWORD=${DB_PASSWORD}
    " >>/odoo/.bashrc
fi

# Accepted values for DEMO: True / False
# Odoo use a reverse boolean for the demo, which is not handy,
# that's why we propose DEMO which exports WITHOUT_DEMO used in
# openerp.cfg.tmpl
if [ -z "$DEMO" ]; then
  DEMO=False
fi
case "$(echo "${DEMO}" | tr '[:upper:]' '[:lower:]')" in
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
TEMPLATES_DIR=/templates
CONFIG_TARGET=/odoo/odoo.cfg
if [ -e $TEMPLATES_DIR/openerp.cfg.tmpl ]; then
  dockerize -template $TEMPLATES_DIR/openerp.cfg.tmpl:$CONFIG_TARGET
fi
if [ -e $TEMPLATES_DIR/odoo.cfg.tmpl ]; then
  dockerize -template $TEMPLATES_DIR/odoo.cfg.tmpl:$CONFIG_TARGET
fi

if [ ! -f "${CONFIG_TARGET}" ]; then
  echo "Error: one of /templates/openerp.cfg.tmpl, /templates/odoo.cfg.tmpl, /etc/odoo.cfg is required"
  exit 1
fi

# Wait until postgres is up
wait_postgres.sh

BASE_CMD=$(basename $1)
CMD_ARRAY=($*)
ARGS=(${CMD_ARRAY[@]:1})

if [ "$BASE_CMD" = "odoo" ] || [ "$BASE_CMD" = "odoo.py" ] || [ "$BASE_CMD" = "migrate" ]; then
  BEFORE_MIGRATE_ENTRYPOINT_DIR=/odoo/before-migrate-entrypoint.d
  if [ -d "$BEFORE_MIGRATE_ENTRYPOINT_DIR" ]; then
    run-parts --verbose "$BEFORE_MIGRATE_ENTRYPOINT_DIR"
  fi
fi
if [ "$BASE_CMD" = "odoo" ] || [ "$BASE_CMD" = "odoo.py" ]; then

  # Bypass migrate when `odoo shell` or `odoo --help` are used
  if [[ ! " ${ARGS[@]} " =~ " --help " ]] && [[ ! " ${ARGS[@]:0:1} " =~ " shell " ]]; then

    if [ -z "$MIGRATE" -o "$MIGRATE" = True ]; then
      migrate
    fi

  fi

  START_ENTRYPOINT_DIR=/odoo/start-entrypoint.d
  if [ -d "$START_ENTRYPOINT_DIR" ]; then
    run-parts --verbose "$START_ENTRYPOINT_DIR"
  fi

  exec "$@"
fi

exec "$@"
