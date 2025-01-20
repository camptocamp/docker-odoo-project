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
# * DOCKERFILE (name of the file used for the Docker build)
#
if [ -z "$VERSION" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi

TMP=$(mktemp -d)
echo "Working in $TMP"

on_exit() {
    echo "Cleaning up temporary directory..."
    rm -rf $TMP
    rm -f /tmp/odoo.tar.gz
}

trap on_exit EXIT

cp -r ${VERSION}/. ${TMP}/
cp -r bin/ ${TMP}
cp -r install/ ${TMP}
cp -r start-entrypoint.d/ ${TMP}
cp -r before-migrate-entrypoint.d/ ${TMP}

docker build --progress plain --no-cache -f ${TMP}/Dockerfile -t ${BUILD_TAG} ${TMP} 
