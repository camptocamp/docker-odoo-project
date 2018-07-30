#!/bin/bash
set -eo pipefail

apt-get remove -y $BUILD_PACKAGE libpq-dev
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PURGE_PACKAGE
rm -rf /var/lib/apt/lists/* /root/.cache/pip/*
