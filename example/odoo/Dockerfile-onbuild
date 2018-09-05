FROM camptocamp/odoo-project:11.0-latest-onbuild
MAINTAINER Camptocamp

# Project's specifics packages
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        python-shapely \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt /odoo/
RUN cd /odoo && pip install -r requirements.txt

ENV ADDONS_PATH=/odoo/local-src,/odoo/src/addons
