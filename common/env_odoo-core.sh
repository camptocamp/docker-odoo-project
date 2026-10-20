
ODOO_BASE_PATH="/odoo"
USER_ID=$EUID

[ $USER_ID -eq 0 ] && { echo "Cannot run as root"; exit 1; }

run_as_odoo () { "$@"; }
exec_as_odoo () { exec "$@"; }
