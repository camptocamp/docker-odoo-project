#!/bin/bash
#
# Keep for backward compatibility.  For example `odoo-upgrade-tool` depends on it.
#

set -e

. env_postgres.sh

wait_postgres ${1-}
