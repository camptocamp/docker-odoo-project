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
RUN apt-get update \
    && apt-get install -y --no-install-recommends parallel  libsasl2-dev libldap2-dev libssl-dev libmagic1 libpq-dev build-essential python3-dev libffi-dev pkg-config libcairo2-dev libgirepository1.0-dev\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        python3-shapely \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /odoo/
USER odoo
WORKDIR /odoo
# run in a virtualenv
RUN /odoo/.venv/bin/pip install --user -r requirements.txt 
RUN /odoo/.venv/bin/pip install -r /odoo/src/odoo/requirements.txt
RUN /odoo/.venv/bin/pip install -e /odoo/src/odoo

# Project's specifics packages

ENV ADDONS_PATH=/odoo/odoo/addons,/odoo/src/odoo/addons

