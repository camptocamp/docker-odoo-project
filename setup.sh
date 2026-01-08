#!/bin/bash
set -euxo pipefail

#
# Prepare to build the image
#
# Normally run by the Makefile:
#
#   $ make VERSION=$VERSION setup
#
# It expects the following variable to be set:
#
# * VERSION (16.0, 17.0, ...)
#
if [ -z "$VERSION" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi

SRC=${SRC:=(mktemp -d)}
echo "Creating $SRC"

mkdir -p ${SRC}
cp Dockerfile MANIFEST.in ${SRC}/
cp -r ${VERSION}/. $SRC/
cp -r bin/ $SRC
cp -r install/ $SRC
cp -r start-entrypoint.d/ $SRC
cp -r before-migrate-entrypoint.d/ $SRC
