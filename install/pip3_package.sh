#!/bin/bash
set -eo pipefail

python3 -m pip install --force-reinstall pip setuptools && pip3 install -r base_requirements.txt --ignore-installed
if $FULL
  then python3 -m pip install -r extra_requirements.txt
fi
