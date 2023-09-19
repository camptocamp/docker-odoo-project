#!/bin/bash
set -euxo pipefail

#
# Build the image
#
# Normally run by the Makefile:
#
#   $ make VERSION=$VERSION build
#
# It expects the following variables to be set:
#
# * VERSION (9.0, 10.0, 11.0, ...)
# * BUILD_TAG (tag of the 'latest' image built)
#
if [ -z "$VERSION" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi

SRC=${SRC:=(mktemp -d)}
echo "Creating $SRC"

cp -r ${VERSION}/. $SRC/
cp -r bin/ $SRC
cp -rT common/ $SRC
cp common/Dockerfile-onbuild $SRC/Dockerfile-batteries-onbuild
sed -i "1i FROM ${BUILD_TAG}" $SRC/Dockerfile-onbuild
sed -i "1i FROM ${BUILD_TAG}" $SRC/Dockerfile-batteries
sed -i "1i FROM ${BUILD_TAG}-batteries" $SRC/Dockerfile-batteries-onbuild
cp -r install/ $SRC
cp -r start-entrypoint.d/ $SRC
cp -r before-migrate-entrypoint.d/ $SRC
