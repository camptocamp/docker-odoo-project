#!/bin/bash

db_restore() {
    DUMP=$1
    DB_NAME=$2
    if [ -f "$DUMP" ]; then
        echo "🐘 🐘 Database dump $DUMP found 🐘 🐘"
        echo "Restore Database dump from $DUMP 📦⮕ 🐘"
        psql -q -o /dev/null -d $DB_NAME -f "$DUMP"
        psql -d $DB_NAME -P pager=off -c "SELECT name as installed_module FROM ir_module_module WHERE state = 'installed' ORDER BY name"
        return 1
    else
        echo "No dump found matching"
        return 0
    fi
}

db_save() {
    DB_NAME=$1
    DUMP=$2
    if [ ! -z "$DUMP" ]; then
        echo "Dumping $DB_NAME into $DUMP 🐘⮕ 📦"
        mkdir -p $(dirname $DUMP)
        pg_dump -Fp -d $DB_NAME -O -f "$DUMP"
        ls $DUMP
    fi
}
