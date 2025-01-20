#!/bin/bash
set -eo pipefail

apt-get update -o Acquire::AllowInsecureRepositories=true
apt-get install -y --no-install-recommends \
 python3-html5lib \
 python3-odf \
 python3-pyinotify \
 python3-simplejson \
 python3-flake8 \
 python3-pytest \
 python3-pluggy \
 python3-coverage \
 python3-pytest-cov \
 python3-argh \
 python3-watchdog \
 python3-atomicwrites \
 python3-attr \
 python3-bs4 \
 python3-future \
 python3-mccabe \
 python3-more-itertools \
 python3-pbr \
 python3-pexpect \
 python3-ptyprocess \
 python3-py \
 python3-pycodestyle \
 python3-pyflakes \
 python3-unicodecsv \
 python3-wrapt \
 python3-distutils \
 python3-apt
