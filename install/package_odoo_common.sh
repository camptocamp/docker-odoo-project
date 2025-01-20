#!/bin/bash
set -eo pipefail

apt-get update -o Acquire::AllowInsecureRepositories=true
apt-get install -y --no-install-recommends \
 adduser \
 fonts-dejavu-core \
 fonts-freefont-ttf \
 fonts-freefont-otf \
 fonts-noto-core \
 fonts-inconsolata \
 fonts-font-awesome \
 fonts-roboto-unhinted \
 gsfonts \
 libjs-underscore \
 lsb-base \
 postgresql-client \
 python3-babel \
 python3-chardet \
 python3-dateutil \
 python3-decorator \
 python3-docutils \
 python3-freezegun \
 python3-pil \
 python3-jinja2 \
 python3-libsass \
 python3-lxml \
 python3-num2words \
 python3-ofxparse \
 python3-passlib \
 python3-polib \
 python3-psutil \
 python3-psycopg2 \
 python3-pydot \
 python3-openssl \
 python3-pypdf2 \
 python3-qrcode \
 python3-renderpm \
 python3-reportlab \
 python3-requests \
 python3-stdnum \
 python3-tz \
 python3-vobject \
 python3-werkzeug \
 python3-xlsxwriter \
 python3-xlrd \
 python3-zeep \
 gnupg2 \
 git \
 curl \
 expect
