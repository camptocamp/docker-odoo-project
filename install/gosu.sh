#!/bin/bash
set -eo pipefail

# fix intermittent gpg server error from https://github.com/tianon/gosu/issues/35
export GNUPGHOME="$(mktemp -d)"
for server in $(shuf -e ha.pool.sks-keyservers.net \
                        hkp://p80.pool.sks-keyservers.net:80 \
                        keyserver.ubuntu.com \
                        hkp://keyserver.ubuntu.com:80 \
                        pgp.mit.edu)
do
  ks_options=""
  # $http_proxy is an environment variable which is usually lowcase, a gpg quirk
  if [ -n "$http_proxy" ]
  then
    ks_options="--keyserver-options http-proxy=$http_proxy"
  fi
  gpg --keyserver "$server" $ks_options --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && break || :
done
curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)"
curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc"
gpg --verify /usr/local/bin/gosu.asc
rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc
chmod +x /usr/local/bin/gosu
# verify that the binary works
gosu nobody true
