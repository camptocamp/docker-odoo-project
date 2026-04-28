#!/bin/bash
set -eo pipefail

if [ -n "${_PACKAGES_TO_REMOVE=$@}" ]; then
  apt-get remove -y "$_PACKAGES_TO_REMOVE"
fi

apt-get purge -y --auto-remove \
  -o APT::AutoRemove::RecommendsImportant=false \
  -o APT::AutoRemove::SuggestsImportant=false

# Note: `apt-get clean` is done already:
# - /etc/apt/apt.conf.d/docker-clean

rm -rf /var/lib/apt/lists/*
