#!/bin/bash
set -eo pipefail

OS_CODENAME=$(awk -F= '$1=="VERSION_CODENAME" { print $2 ;}' /etc/os-release)

if [ -z "$OS_CODENAME" ]
then
    # VERSION_CODENAME doesn't exist in jessie
    # To remove on drop of support of jessie
    OS_CODENAME="jessie"
fi


APT_REPO="apt.postgresql.org"
if [ $OS_CODENAME = "jessie" ]
then
    APT_REPO="apt-archive.postgresql.org"
fi

echo "deb http://${APT_REPO}/pub/repos/apt/ ${OS_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get update
apt-get install -y --no-install-recommends postgresql-client libpq-dev
apt-get -y install -f --no-install-recommends
