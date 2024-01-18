#!/bin/bash
set -Exeuo pipefail

#
# Run tests on the image
#
# It assumes the image already exists.
# Normally run by the Makefile:
#
#   $ make VERSION=$VERSION build
#   $ make VERSION=$VERSION test
#
# It expects the following variables to be set:
#
# * VERSION (9.0, 10.0, 11.0, ...)
# * IMAGE_LATEST (tag of the 'latest' image built)
#

if [ -z "$VERSION" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi

# Allow version flavor like 12.0-buster
VERSION=$(echo $VERSION | cut -d '-' -f '1')

ODOO_URL="https://github.com/odoo/odoo/archive/${VERSION}.tar.gz"

TMP=$(mktemp -d)
echo "Working in $TMP"

on_exit() {
    echo "Cleaning up temporary directory..."
    cd $TMP
    docker-compose -f test-compose.yml down
    rm -rf $TMP
    rm -f /tmp/odoo.tar.gz
}

trap on_exit EXIT

# run 'runtests' in the container
# extra arguments are passed to the 'run' command (example: -e FOO=bar is added to the list of args)
docoruntests() {
    docker-compose -f test-compose.yml run --rm -e LOCAL_USER_ID=999 $@ odoo runtests
}
# run 'runmigration' in the container
# extra arguments are passed to the 'run' command (example: -e FOO=bar is added to the list of args)
docorunmigration() {
    docker-compose -f test-compose.yml run --rm -e LOCAL_USER_ID=999 $@ odoo runmigration
}
docodown() {
    docker-compose -f test-compose.yml down
}
docoruncmd() {
    docker-compose -f test-compose.yml run --rm -e LOCAL_USER_ID=999 $@
}

cp -ra ./example/. "$TMP/"
cd "$TMP"

echo '>>> Downloading Odoo src'
rm -rf "$TMP/odoo/src"
wget -nv -O /tmp/odoo.tar.gz "$ODOO_URL"
mkdir -p odoo/src
tar xfz /tmp/odoo.tar.gz -C odoo/src
mv "odoo/src/odoo-$VERSION" odoo/src/odoo
ls odoo/src/odoo
echo '>>> Run test for base image'
sed "s|FROM .*|FROM ${IMAGE_LATEST}|" -i Dockerfile
sed "s|version=.*|version=""'""${VERSION}"".1.0.0""'"",|" -i setup.py
sed "s|\(.version.: .\)[0-9.]*\(.*\)|\\1$VERSION.0.0.0\\2|" -i odoo/addons/dummy_test/__manifest__.py
echo $VERSION.0.0.0 > VERSION

cat setup.py
cat odoo/addons/dummy_test/__manifest__.py
mkdir .cachedb

echo '>>> * migration: standard'
docoruncmd -e LOAD_DB_CACHE="false" odoo odoo --stop-after-init

echo '>>> * migration: create the dump for a base version'
docorunmigration -e CREATE_DB_CACHE="true"
docoruncmd odoo dropdb odoodb

echo '>>> * migration: use the dump and migrate to new version'
docorunmigration -e LOAD_DB_CACHE="true"
docodown
echo "    - version: 15.0.1" >>migration.yml
echo "      operations:" >>migration.yml
echo "        post:" >>migration.yml
echo "          - anthem songs.install.demo::create_partners" >>migration.yml
docoruncmd odoo dropdb odoodb

echo '>>> * migration: use a ceil version'
docoruntests -e LOAD_DB_CACHE="true" -e MIG_LOAD_VERSION_CEIL="15.0.1"

echo '>>> * run unit tests with runtests'
docoruntests -e LOAD_DB_CACHE="false" -e CREATE_DB_CACHE="false"

echo '>>> * run unit tests with runtests and create a dump'
docoruntests -e CREATE_DB_CACHE="true" -e SUBS_MD5=testcache

echo '>>> * run unit tests with runtests and re-use a dump'
docoruntests -e LOAD_DB_CACHE="true" -e SUBS_MD5=testcache
docodown

docoruncmd odoo odoo --stop-after-init
docoruntests

docodown
