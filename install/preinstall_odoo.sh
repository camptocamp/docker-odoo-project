#!/bin/bash
set -eo pipefail

ODOO_URL=https://github.com/odoo/odoo/archive/$ODOO_VERSION.tar.gz

curl -o /tmp/odoo.tar.gz -SL $ODOO_URL
tar xfz /tmp/odoo.tar.gz -C /opt/odoo/
mv /opt/odoo/odoo-$ODOO_VERSION/ /opt/odoo/src
pip install -e /opt/odoo/src
rm -f /tmp/odoo.tar.gz
rm -rf /opt/odoo/src
