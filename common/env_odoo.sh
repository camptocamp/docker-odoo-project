
ODOO_BASE_PATH=""

# allow to customize the UID of the odoo user,
# so we can share the same than the host's.
# If no user id is set, we use 999
USER_ID=${LOCAL_USER_ID:-999}
id -u odoo &> /dev/null || useradd --shell /bin/bash -u $USER_ID -o -c "" -m odoo

run_as_odoo () { gosu odoo "$@"; }
exec_as_odoo () { exec gosu odoo "$@"; }
