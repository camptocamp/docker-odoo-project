#!/bin/bash
set -eo pipefail

apt-get update
apt-get install -y --no-install-recommends $BUILD_PACKAGE
