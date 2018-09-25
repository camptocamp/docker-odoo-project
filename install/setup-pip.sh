#!/bin/bash
set -eo pipefail

cat << EOF > /etc/pip.conf
[global]
# counter-intuitively, false means that we enable 'no-cache-dir'
# "To enable the boolean options --no-compile and --no-cache-dir, falsy values have to be used"
# https://pip.pypa.io/en/stable/user_guide/#configuration
no-cache-dir = false
EOF
