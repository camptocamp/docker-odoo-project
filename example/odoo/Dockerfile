FROM camptocamp/odoo-project:10.0-latest
MAINTAINER Camptocamp

# Project's specifics packages
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        python-shapely \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY ./requirements.txt .
RUN pip install -r requirements.txt

ENV ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/src/addons
