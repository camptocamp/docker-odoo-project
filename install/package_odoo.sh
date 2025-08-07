#!/bin/bash
set -eo pipefail

apt-get update -o Acquire::AllowInsecureRepositories=true
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
    libxslt1.1 \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
    tcl expect
