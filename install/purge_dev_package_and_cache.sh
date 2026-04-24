#!/bin/bash
set -eo pipefail

apt-get remove -y $BUILD_PACKAGE libpq-dev
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $PURGE_PACKAGE
rm -rf /var/lib/apt/lists/* /root/.cache/pip/*

# Remove METADATA of vendored dependencies
# which triggered a vulnerability report, without easy way to fix it.
rm -vrf /odoo/.venv/lib/python3*/site-packages/setuptools/_vendor/*.dist-info

unset $BUILD_PACKAGE
