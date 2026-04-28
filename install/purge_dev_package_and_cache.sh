#!/bin/bash
set -eo pipefail
# Note: Python pip cache is disabled by install/setup-pip.sh

/install/apt_purge.sh $BUILD_PACKAGE libpq-dev

if [ ! -d "${LIB_PATH:=/odoo/.venv/lib}" ]; then
  LIB_PATH=/usr/local/lib
fi

# Remove METADATA of vendored dependencies
# which triggered a vulnerability report, without easy way to fix it.
rm -vrf $LIB_PATH/python3*/site-packages/setuptools/_vendor/*.dist-info

unset $BUILD_PACKAGE
