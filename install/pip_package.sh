#!/bin/bash
set -eo pipefail

# TODO FULL VERSION WITH IF
pip install -U pip setuptools && pip install -r base_requirements.txt  --ignore-installed
