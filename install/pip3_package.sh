#!/bin/bash
set -eo pipefail

# TODO FULL VERSION WITH IF
python3 -m pip install --force-reinstall pip setuptools && pip3 install -r base_requirements.txt  --ignore-installed
