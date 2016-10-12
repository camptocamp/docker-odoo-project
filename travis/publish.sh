#!/bin/bash

set -e

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  docker login --username="$DOCKER_USERNAME" --password="$DOCKER_PASSWORD"

  if [ "$TRAVIS_BRANCH" == "master" ]; then
    if [ "$VERSION" == "10.0" ]; then
      make VERSION=$VERSION TAG=$TRAVIS_TAG tag_latest_main push_latest_main
    fi
    make VERSION=$VERSION TAG=latest tag push
  elif [ ! -z "$TRAVIS_TAG" ]; then
    make VERSION=$VERSION TAG=$TRAVIS_TAG tag push
  else
    echo "Not pushing any image"
  fi

fi
