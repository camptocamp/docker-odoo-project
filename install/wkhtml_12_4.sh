#!/bin/bash
set -eo pipefail

curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
echo '3f923f425d345940089e44c1466f6408b9619562 wkhtmltox.tar.xz' | sha1sum -c -
tar xvf wkhtmltox.tar.xz
cp --no-dereference --preserve=link wkhtmltox/lib/* /usr/local/lib/
cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf
rm -rf wkhtmltox wkhtmltox.tar.xz
