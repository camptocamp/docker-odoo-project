FROM camptocamp/odoo-project:11.0-latest
MAINTAINER Camptocamp

# For installing odoo you have two possibility
# 1. either adding the whole root directory
#COPY . /opt/odoo

# 2. or adding each directory, this solution will reduce the build and download
# time of the image on the server (layers are reused)
COPY ./src /opt/odoo/src
COPY ./external-src /opt/odoo/external-src
COPY ./local-src /opt/odoo/local-src
COPY ./data /opt/odoo/data
COPY ./songs /opt/odoo/songs
COPY ./setup.py /opt/odoo/
COPY ./VERSION /opt/odoo/
COPY ./migration.yml /opt/odoo/

RUN pip install -e /opt/odoo
RUN pip install -e /opt/odoo/src

# Project's specifics packages
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        python-shapely \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /opt/odoo/
RUN cd /opt/odoo && pip3 install -r requirements.txt

ENV ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/src/addons
