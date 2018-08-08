#!/bin/bash
set -eo pipefail

apt-get update
apt-get install -y --no-install-recommends \
    antiword \
    ca-certificates \
    curl \
    ghostscript \
    graphviz \
    nano \
    poppler-utils \
    python \
    python-libxslt1 \
    python-pip \
    python-vobject \
    python-zsi \
    xfonts-75dpi \
    xfonts-base \
    tcl expect
