#!/bin/bash
set -eo pipefail

curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get install -y --no-install-recommends postgresql-client libpq-dev
apt-get -y install -f --no-install-recommends
