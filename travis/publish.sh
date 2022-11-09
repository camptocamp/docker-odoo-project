#!/bin/bash

set -e

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  if [ "$TARGET" = "GHCR" ]
  then
      echo $GHCR_TOKEN | docker login --username="$GHCR_USER" --password-stdin https://ghcr.io
  else
      echo $DOCKER_PASSWORD | docker login --username="$DOCKER_USERNAME" --password-stdin
  fi

  if [ "$TRAVIS_BRANCH" == "stable-4.x.y" ]; then
    if [ "$VERSION" == "15.0" ]; then
      make VERSION=$VERSION TAG=$TRAVIS_TAG tag_latest_main push_latest_main
    fi
    make VERSION=$VERSION TAG=latest tag push
  elif [ ! -z "$TRAVIS_TAG" ]; then
    make VERSION=$VERSION TAG=$TRAVIS_TAG tag push
  else
    echo "Not pushing any image"
  fi

fi
