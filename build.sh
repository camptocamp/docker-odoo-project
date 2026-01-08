#!/bin/bash
set -exo pipefail
if [ -z "$VERSION" ]; then
    export VERSION=18.0
fi
if [ -z "$BUILD_TAG" ]; then
    export BUILD_TAG=odoo:${VERSION}
fi

#
# Build the image
#
# Normally run by the Makefile:
#
#   $ make VERSION=$VERSION build
#
# It expects the following variables to be set:
#
# * VERSION (16.0, 17.0, ...)
# * BUILD_TAG (tag of the 'latest' image built)
#
if [ -z "$VERSION" ]; then
    echo "VERSION environment variable is missing"
    exit 1
fi

if [ "$VERSION" = "14.0" ]; then
    PYTHON_FROM="python:3.9-slim-trixie"
else
    PYTHON_FROM="python:3.12-slim-trixie"
fi

TMP=$(mktemp -d)
echo "Working in $TMP"

on_exit() {
    echo "Cleaning up temporary directory..."
    rm -rf $TMP
    rm -f /tmp/odoo.tar.gz
}

trap on_exit EXIT

SRC=${TMP} . ./setup.sh

docker build --progress plain --no-cache \
             --build-arg VERSION=${VERSION} \
             --build-context python=docker-image://${PYTHON_FROM} \
             -f ${TMP}/Dockerfile -t ${BUILD_TAG} ${TMP}
