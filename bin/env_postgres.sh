
if [ ${DB_USER-} ]; then
  export PGHOST=$DB_HOST
  export PGPORT=$DB_PORT
  export PGUSER=$DB_USER
  export PGDATABASE=$DB_NAME
  export PGAPPNAME=$HOSTNAME
  # Only set PGPASSWORD if there is no .pgpass file
  if [ ! -f ~/.pgpass ]; then
    export PGPASSWORD=$DB_PASSWORD
  fi
fi
