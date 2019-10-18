#!/bin/bash
set -eo pipefail

apt-get update
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
    postgresql-11 \
    poppler-utils \
    python3 \
    python-libxslt1 \
    python3-pip \
    python3-setuptools \
    python3-renderpm \
    libxslt1.1 \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
    tcl expect
