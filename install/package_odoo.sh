#!/bin/bash
set -eo pipefail

ODOO_PACKAGE=" \
    antiword \
    ca-certificates \
    curl \
    dirmngr \
    expect \
    ghostscript \
    gnupg2 \
    graphviz \
    less \
    libxslt1.1 \
    nano \
    node-clean-css \
    node-less \
    poppler-utils \
    tcl \
    xfonts-75dpi \
    xfonts-base \
    xz-utils \
"

if [ "${1-}" = "core" ]; then
  ODOO_PACKAGE="$ODOO_PACKAGE \
    adduser \
    fonts-dejavu-core \
    fonts-font-awesome \
    fonts-freefont-otf \
    fonts-freefont-ttf \
    fonts-inconsolata \
    fonts-noto-core \
    fonts-roboto-unhinted \
    git \
    gnupg2 \
    gsfonts \
    libjs-underscore \
    lsb-base \
    patch \
    procps \
    vim-tiny \
"
fi

apt-get update -o Acquire::AllowInsecureRepositories=true
apt-get install -y --no-install-recommends $ODOO_PACKAGE
