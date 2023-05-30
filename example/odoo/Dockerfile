FROM camptocamp/odoo-project:11.0-latest
MAINTAINER Camptocamp

# For installing odoo you have two possibility
# 1. either adding the whole root directory
#COPY . /odoo

# 2. or adding each directory, this solution will reduce the build and download
# time of the image on the server (layers are reused)
RUN mkdir -p /odoo/src/odoo
COPY ./src /odoo/src/odoo
COPY ./external-src /odoo/external-src
COPY ./local-src /odoo/local-src
COPY ./data /odoo/data
COPY ./songs /odoo/songs
COPY ./setup.py /odoo/
COPY ./VERSION /odoo/
COPY ./migration.yml /odoo/
USER root
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        python3-shapely \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /odoo/
RUN chown -R odoo:odoo /odoo
USER odoo
RUN pip install -e /odoo
RUN pip install -e /odoo/src/odoo

# Project's specifics packages
RUN cd /odoo && pip install -r requirements.txt

ENV ADDONS_PATH=/odoo/local-src,/odoo/src/odoo/addons

