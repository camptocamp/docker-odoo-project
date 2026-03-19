#!/bin/bash
set -eo pipefail

PSQL_VERSION=17

OS_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)
APT_REPO="apt.postgresql.org"

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/postgresql.asc] http://${APT_REPO}/pub/repos/apt/ ${OS_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /etc/apt/keyrings/postgresql.asc

apt-get update
apt-get install -y --no-install-recommends postgresql-client-${PSQL_VERSION} libpq-dev
apt-get -y install -f --no-install-recommends
