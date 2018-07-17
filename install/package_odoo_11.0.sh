#!/bin/bash
set -eo pipefail

apt-get update
apt-get purge python2.7 python2.7-minimal
apt-get install -y --no-install-recommends \
    antiword \
    ca-certificates \
    curl \
    dirmngr \
    ghostscript \
    graphviz \
    gnupg2 \
    less \
    nano \
    node-clean-css \
    node-less \
    poppler-utils \
    python \
    python-libxslt1 \
    python-pip \
    python3-pip \
    python3-setuptools \
    python3-renderpm \
    libxslt1.1 \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
    tcl expect
