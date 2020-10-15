#!/bin/bash
set -eo pipefail

# curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
echo 'bd86f4cc9bf7a515ba038ddb8b60eaffc1c4e2b9 /install/wkhtmltox.deb' | sha1sum -c -
dpkg --force-depends -i /install/wkhtmltox.deb
rm /install/wkhtmltox.deb
