#!/bin/bash
set -e

. env_postgres.sh
. env_odoo.sh

echo "Starting with UID: $USER_ID"

BASE_CMD=$(basename $1)
CMD_ARRAY=($*)
ARGS=(${CMD_ARRAY[@]:1})

# Accepted values for DEMO: True / False
# Odoo <= 18 used a negated boolean without_demo, which is not handy
# Odoo >= 19 uses an intuitive with_demo option
case "$BASE_CMD" in ("runtests"|"testdb-gen"|"testdb-update")
  DEMO=true;;
esac
case "$(echo "${DEMO:-false}" | tr '[:upper:]' '[:lower:]')" in
  "false")
    echo "Running without demo data"
    export DEMO=False WITHOUT_DEMO=all
    ;;
  "true")
    echo "Running with demo data"
    export DEMO=True WITHOUT_DEMO=
    ;;
  *)
    echo "Value '${DEMO}' for DEMO is not a valid value in 'False', 'True'"
    exit 1
    ;;
esac

# Create configuration file from the template
DATA_DIR="$ODOO_BASE_PATH/data/odoo"
ODOO_RC_TMPL="/templates/odoo.cfg.tmpl"
if [ -e "$ODOO_RC_TMPL" ]; then
  DATA_DIR=$DATA_DIR dockerize -template $ODOO_RC_TMPL:${ODOO_RC-$OPENERP_SERVER}
fi
if [ ! -f "${ODOO_RC-$OPENERP_SERVER}" ]; then
  echo "Error: $ODOO_RC_TMPL is required"
  exit 1
fi

if [ -z "$(pip list --format=columns | grep "/odoo/src")" ]; then
  # The build runs 'pip install -e' on the odoo src, which creates an
  # odoo.egg-info directory *inside /odoo/src*. So when we run a container
  # with a volume shared with the host, we don't have this .egg-info (at least
  # the first time).
  # When it happens, we reinstall the odoo python package. We don't want to run
  # the install everytime because it would slow the start of the containers
  echo '/odoo/src/odoo.egg-info is missing, probably because the directory is a volume.'
  echo 'Running pip install -e /odoo/src to restore odoo.egg-info'
  pip install -e /odoo/src
  # As we write in a volume, ensure it has the same user.
  # So when the src is a host volume and we set the LOCAL_USER_ID to be the
  # host user, the files are owned by the host user
  chown -R odoo: /odoo/src/*.egg-info
fi


# Same logic but for your custom project
if [ -z "$(pip list --format=columns | grep "/odoo" | grep -v "/odoo/src")" ]; then
  echo '/src/*.egg-info is missing, probably because the directory is a volume.'
  echo 'Running pip install -e /odoo to restore *.egg-info'
  pip install -e /odoo
  chown -R odoo: /odoo/*.egg-info
fi


# Wait until postgres is up
wait_postgres.sh

if [ $EUID -eq 0 ]; then
  # Not for core image
  mkdir -p $DATA_DIR/{addons,filestore,sessions}
  if [ ! "$(stat -c '%U' $DATA_DIR)" = "odoo" ]; then
    chown -R odoo: $DATA_DIR
  fi
  if [ ! "$(stat -c '%U' /var/log/odoo)" = "odoo" ]; then
    chown -R odoo: /var/log/odoo
  fi
fi

if [ "$BASE_CMD" = "odoo" ] || [ "$BASE_CMD" = "odoo.py" ] || [ "$BASE_CMD" = "migrate" ] ||
    ([ "$BASE_CMD" = "gosu" ] && [[ "${ARGS[@]}" =~ "odoo migrate" ]] ); then
  BEFORE_MIGRATE_ENTRYPOINT_DIR=$ODOO_BASE_PATH/before-migrate-entrypoint.d
  if [ -d "$BEFORE_MIGRATE_ENTRYPOINT_DIR" ]; then
    run-parts --exit-on-error --verbose "$BEFORE_MIGRATE_ENTRYPOINT_DIR"
  fi
fi
if [ "$BASE_CMD" = "odoo" ] || [ "$BASE_CMD" = "odoo.py" ]; then

  # Bypass migrate when `odoo shell` or `odoo --help` are used
  if [[ ! " ${ARGS[@]} " =~ " --help " ]] && [[ ! " ${ARGS[@]:0:1} " =~ " shell " ]]; then

    if [ -z "$MIGRATE" -o "$MIGRATE" = True ]; then
      run_as_odoo migrate
    fi

  fi

  START_ENTRYPOINT_DIR=$ODOO_BASE_PATH/start-entrypoint.d
  if [ -d "$START_ENTRYPOINT_DIR" ]; then
    run-parts --exit-on-error --verbose "$START_ENTRYPOINT_DIR"
  fi

  exec_as_odoo "$@"
fi

exec "$@"
