
if [ -z "${PGUSER-}" ] && [ -n "${DB_USER-}" ]; then
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

wait_postgres () {
  TIMEOUT="${1:-30s}"
  # Wait until PostgreSQL is running.
  if [ -d "$DB_HOST" ]; then
      dockerize -timeout $TIMEOUT -wait "unix://${DB_HOST}/.s.PGSQL.${DB_PORT}"
  else
      dockerize -timeout $TIMEOUT -wait "tcp://${DB_HOST}:${DB_PORT}"
  fi

  # now the port is up but sometimes server is not ready yet:
  # 'createdb: could not connect to database template1: FATAL:  the database system is starting up'
  # we retry if we get this error

  while [ "$(psql -c '' postgres 2>&1)" = "psql: FATAL:  the database system is starting up" ]
  do
    echo "Waiting for the database system to start up"
    sleep 0.1
  done
}
