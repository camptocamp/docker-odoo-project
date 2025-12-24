#!/bin/bash
set -eo pipefail

sed -i "1 s/python/python3/g" /usr/local/bin/wkhtmltopdf
