#!/bin/bash
set -euo pipefail

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
# * IMAGE_LATEST (tag of the 'latest' image built)
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
# as executable bit will be inherited to the docker image we explicitly set executable bit on scripts
chmod +x start-entrypoint.d/* before-migrate-entrypoint.d/*
cp -r ${VERSION}/. ${TMP}/
cp -r bin/ ${TMP}
cp -rT common/ ${TMP}
cp ${TMP}/Dockerfile-onbuild ${TMP}/Dockerfile-batteries-onbuild
sed -i "1i FROM ${IMAGE_LATEST}" ${TMP}/Dockerfile-onbuild
sed -i "1i FROM ${IMAGE_LATEST}" ${TMP}/Dockerfile-batteries
sed -i "1i FROM ${IMAGE_LATEST}-batteries" ${TMP}/Dockerfile-batteries-onbuild
cp -r install/ ${TMP}
cp -r start-entrypoint.d/ ${TMP}
cp -r before-migrate-entrypoint.d/ ${TMP}

docker build --no-cache -f ${TMP}/Dockerfile -t ${IMAGE_LATEST} ${TMP}
docker build --no-cache -f ${TMP}/Dockerfile-onbuild -t ${IMAGE_LATEST}-onbuild ${TMP}
docker build --no-cache -f ${TMP}/Dockerfile-batteries -t ${IMAGE_LATEST}-batteries ${TMP}
docker build --no-cache -f ${TMP}/Dockerfile-batteries-onbuild -t ${IMAGE_LATEST}-batteries-onbuild ${TMP}
