#!/bin/bash
set -eo pipefail

apt-get update -o Acquire::AllowInsecureRepositories=true
apt-get install -y --no-install-recommends \
    ghostscript \
