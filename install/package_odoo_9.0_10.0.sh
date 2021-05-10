#!/bin/bash
set -eo pipefail

apt-get update
# authentication error for libc-ares2
apt-get install -y --force-yes --no-install-recommends libc-ares2
apt-get install -y --no-install-recommends \
    antiword \
    apt-transport-https \
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
