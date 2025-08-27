#!/bin/bash
set -eo pipefail

OS_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)


APT_REPO="apt.postgresql.org"

echo "deb http://${APT_REPO}/pub/repos/apt/ ${OS_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get update
apt-get install -y --no-install-recommends postgresql-client-14 libpq-dev
apt-get -y install -f --no-install-recommends
