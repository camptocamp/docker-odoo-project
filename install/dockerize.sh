#!/bin/bash
set -eo pipefail

curl -o dockerize-linux-amd64-v0.6.0.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-linux-amd64-v0.6.0.tar.gz -SL
echo 'a13ff2aa6937f45ccde1f29b1574744930f5c9a5 dockerize-linux-amd64-v0.6.0.tar.gz' | sha1sum -c -
tar xvfz dockerize-linux-amd64-v0.6.0.tar.gz -C /usr/local/bin && rm dockerize-linux-amd64-v0.6.0.tar.gz
