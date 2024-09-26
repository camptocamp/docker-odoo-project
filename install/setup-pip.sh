#!/bin/bash
set -eo pipefail
# Install pip with ensuire pip
python -m ensurepip
cat << EOF > /etc/pip.conf
[global]
# counter-intuitively, false means that we enable 'no-cache-dir'
# "To enable the boolean options --no-compile and --no-cache-dir, falsy values have to be used"
# https://pip.pypa.io/en/stable/user_guide/#configuration
no-cache-dir = false
disable-pip-version-check = True
EOF
