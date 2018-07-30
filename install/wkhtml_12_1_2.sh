#!/bin/bash
set -eo pipefail

curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c -
dpkg --force-depends -i wkhtmltox.deb
rm wkhtmltox.deb
