#!/bin/bash
set -eo pipefail

curl -o kwkhtmltopdf_client -SL https://raw.githubusercontent.com/camptocamp/kwkhtmltopdf/master/client/python/kwkhtmltopdf_client.py
echo '8676b798f57c67e3a801caad4c91368929c427ce kwkhtmltopdf_client' | sha1sum -c -
mv kwkhtmltopdf_client /usr/local/bin/wkhtmltopdf
chmod a+x /usr/local/bin/wkhtmltopdf