#!/bin/bash
set -eo pipefail

arch=`uname -m`
if [[ arch -eq 'aarch64' ]]; then
  arch="arm64"
  hash="541ee4713933e087d766e2954b37cc652dff73b569d26b0c589277dcf8b16a9a"
else
  # assume x86_64
  hash="6981643dfb8e0b731f4b48b35d1fdd742b374ec66d1471a9ed7ed91781f2aca7"
fi
curl -o dockerize-linux-${arch} https://github.com/powerman/dockerize/releases/download/v0.16.0/dockerize-linux-${arch} -SL
echo "${hash}  dockerize-linux-${arch}" | sha256sum -c -
install dockerize-linux-${arch} /usr/local/bin/dockerize && rm dockerize-linux-${arch}
