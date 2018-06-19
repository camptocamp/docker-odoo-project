#!/bin/bash
set -eo pipefail

apt-get update
apt-get install -y --no-install-recommends \
    antiword \
    ca-certificates \
    curl \
    ghostscript \
    graphviz \
    less \
    nano \
    node-clean-css \
    node-less \
    poppler-utils \
    python \
    python-libxslt1 \
    python-pip \
    xfonts-75dpi \
    xfonts-base \
    tcl expect
