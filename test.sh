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
# * VERSION (16.0, 17.0, ...)
# * IMAGE_LATEST (tag of the 'latest' image built)
#

if [ -z "${VERSION-}" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi
if [ -z "${IMAGE_LATEST-}" ]; then
    if [ -n "${BUILD_TAG-}" ]; then
        IMAGE_LATEST="${BUILD_TAG}"
    else
        IMAGE_LATEST="odoo:${VERSION}"
    fi
fi
export IMAGE_LATEST

case $IMAGE_LATEST in
  *-5xx-*)
    TEST_SRC=./example-core
    BASE_PATH=.
    LOCAL_CODE_PATH=./odoo/addons
    ODOO_PATH=./odoo/src/odoo
    ;;
  *)
    TEST_SRC=./example
    BASE_PATH=./odoo
    LOCAL_CODE_PATH=./odoo/local-src
    ODOO_PATH=./odoo/src
    ;;
esac

# Allow version flavor like 12.0-buster
VERSION=$(echo $VERSION | cut -d '-' -f '1')

ODOO_URL="https://github.com/odoo/odoo/archive/${VERSION}.tar.gz"

TMP=$(mktemp -d)
echo "Working in $TMP"

on_exit() {
    echo "Cleaning up temporary directory..."
    cd $TMP
    docker compose -f test-compose.yml down
    rm -rf $TMP
    rm -f /tmp/odoo.tar.gz
}

trap on_exit EXIT

# run 'runtests' in the container
# extra arguments are passed to the 'run' command (example: -e FOO=bar is added to the list of args)
docoruntests() {
    docker compose -f test-compose.yml run --rm -e LOCAL_USER_ID=$(id -u) $@ odoo runtests
}
# run 'runmigration' in the container
# extra arguments are passed to the 'run' command (example: -e FOO=bar is added to the list of args)
docorunmigration() {
    docker compose -f test-compose.yml run --rm -e LOCAL_USER_ID=$(id -u) $@ odoo runmigration
}
docodown() {
    docker compose -f test-compose.yml down
}
docoruncmd() {
    docker compose -f test-compose.yml build odoo
    docker compose -f test-compose.yml run --rm -e LOCAL_USER_ID=$(id -u) $@
}

cp -ra "$TEST_SRC/." "$TMP/"

cd "$TMP"

echo '>>> Downloading Odoo src'
rm -rf "$ODOO_PATH"
wget -nv -O /tmp/odoo.tar.gz "$ODOO_URL"
tar xfz /tmp/odoo.tar.gz -C "./odoo"
mkdir -p $(dirname -- "$ODOO_PATH")
mv "./odoo/odoo-$VERSION" "$ODOO_PATH"
echo "+++++++++++++ $IMAGE_LATEST"
echo '>>> Run test for base image'
sed "s|FROM .*|FROM ${IMAGE_LATEST}|" -i "$BASE_PATH/Dockerfile"
sed "s|\(.version.: .\)[0-9.]*\(.*\)|\\1${VERSION}.0.0.0\\2|" -i "$LOCAL_CODE_PATH/dummy_test/__manifest__.py"
echo $VERSION.0.0.0 > "$BASE_PATH/VERSION"

mkdir .cachedb

echo '>>> * migration: standard'
docoruncmd -e LOAD_DB_CACHE="false" odoo odoo --stop-after-init

echo '>>> * migration: create the dump for a base version'
docorunmigration -e CREATE_DB_CACHE="true"
docoruncmd odoo dropdb odoodb

echo '>>> * migration: use the dump and migrate to new version'
docorunmigration -e LOAD_DB_CACHE="true"
docodown
cat <<EOT >>"$BASE_PATH/migration.yml"
    - version: ${VERSION}.0.1
      operations:
        post:
          - anthem songs.install.demo::create_partners
EOT
docoruncmd odoo dropdb odoodb

echo '>>> * run unit tests with runtests'
docoruntests -e LOAD_DB_CACHE="false" -e CREATE_DB_CACHE="false"

echo '>>> * run unit tests with runtests and create a dump'
docoruntests -e CREATE_DB_CACHE="true" -e SUBS_MD5=testcache

echo '>>> * run unit tests with runtests and re-use a dump'
docoruntests -e LOAD_DB_CACHE="true" -e SUBS_MD5=testcache
docodown
