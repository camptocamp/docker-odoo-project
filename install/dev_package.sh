#!/bin/bash
set -eo pipefail

# These packages are installed in order to build dependencies.
# They are uninstalled right after with 'purge_dev_package_and_cache.sh'

export BUILD_PACKAGE="\
    build-essential \
    gcc \
    libcairo2-dev \
    libevent-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libldap2-dev \
    libpng-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
"

if [ "${1-}" != "core" ]; then
  BUILD_PACKAGE="$BUILD_PACKAGE git"
fi

apt-get update
apt-get install -y --no-install-recommends $BUILD_PACKAGE
