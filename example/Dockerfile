FROM camptocamp/odoo-project:11.0-latest
MAINTAINER Camptocamp

# For installing odoo you have two possibility
# 1. either adding the whole root directory
#COPY . /odoo

# 2. or adding each directory, this solution will reduce the build and download
# time of the image on the server (layers are reused)
RUN mkdir -p /odoo/src/odoo
COPY ./odoo/src/odoo /odoo/src/odoo
COPY ./odoo/addons /odoo/odoo/addons
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
USER odoo
WORKDIR /odoo
RUN pip install --user -e .
RUN pip install --user -r requirements.txt 

# Project's specifics packages

ENV ADDONS_PATH=/odoo/odoo/addons,/odoo/src/odoo/addons

