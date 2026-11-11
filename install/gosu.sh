#!/bin/bash
set -eo pipefail

GOSU_VER="1.20"
GOSU_DL_URL="https://github.com/tianon/gosu/releases/download/${GOSU_VER}/gosu-$(dpkg --print-architecture)"
KEY_SERVERS="keys.openpgp.org pgpkeys.eu"
GPG_KEY="B42F6819007F00F88E364FD4036A9C25BF357DD4"
BIN_DIR="/usr/local/bin"

export GNUPGHOME="$(mktemp -d)"
for server in $(shuf -e $KEY_SERVERS)
do
  ks_options=""
  # $http_proxy is an environment variable which is usually lowercase, a gpg quirk
  if [ -n "$http_proxy" ]
  then
    ks_options="--keyserver-options http-proxy=$http_proxy"
  fi
  echo gpg --keyserver "$server" $ks_options --batch --no-tty --recv-keys "$GPG_KEY"
  gpg --keyserver "$server" $ks_options --batch --no-tty --recv-keys "$GPG_KEY" && break || :
done
curl -o "${BIN_DIR}/gosu" -SL "${GOSU_DL_URL}"
curl -o "${BIN_DIR}/gosu.asc" -SL "${GOSU_DL_URL}.asc"
gpg --verify "${BIN_DIR}/gosu.asc"
rm -rf "$GNUPGHOME" "${BIN_DIR}/gosu.asc"
chmod +x "${BIN_DIR}/gosu"
# verify that the binary works
"${BIN_DIR}/gosu" nobody true
