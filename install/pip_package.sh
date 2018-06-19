#!/bin/bash
set -eo pipefail

pip install -U pip setuptools && pip install -r base_requirements.txt
if $FULL
  then pip install -r extra_requirements.txt
fi
