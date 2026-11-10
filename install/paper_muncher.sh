#!/bin/bash
set -eo pipefail

if [ "${VERSION%%.*}" -lt 20 ]; then
  echo "Paper Muncher is not needed for Odoo $VERSION, skipping"
  exit 0
fi

PAPER_MUNCHER_VERSION=0.10.0
# Checksum of the Debian trixie amd64 package (only amd64 packages are published)
PAPER_MUNCHER_SHA256=c01bc309996b0606a22fbfbfa95f32ca362b796de2221505153acc27b548aef1

DEB="paper-muncher_v${PAPER_MUNCHER_VERSION}_trixie_amd64.deb"

cd /tmp
curl -o "$DEB" -fSL "https://github.com/odoo/paper-muncher/releases/download/v${PAPER_MUNCHER_VERSION}/${DEB}"
echo "${PAPER_MUNCHER_SHA256} ${DEB}" | sha256sum -c -
apt-get install -y --no-install-recommends "./$DEB"
rm -f "$DEB"

# The package installs into /opt/paper-muncher, which is not in PATH
ln -s /opt/paper-muncher/bin/paper-muncher /usr/local/bin/paper-muncher
# verify that the binary works
paper-muncher --version
