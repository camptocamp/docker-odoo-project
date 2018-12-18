#!/bin/bash
set -xe
python3 -c "import urllib.request
url = 'http://www.reportlab.com/ftp/pfbfer.zip'
urllib.request.urlretrieve(url, '/tmp/pfbfer.zip')"
apt update
apt install unzip -y
mkdir /usr/lib/python3/dist-packages/reportlab/fonts
cd /usr/lib/python3/dist-packages/reportlab/fonts
unzip /tmp/pfbfer.zip
rm -rf /tmp/pfbfer.zip


