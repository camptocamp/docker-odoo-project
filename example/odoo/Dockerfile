FROM ci-latest:0.1
LABEL maintainer="Camptocamp"

# For installing odoo you have two possibility
# 1. either adding the whole root directory
#COPY . /odoo

# 2. or adding each directory, this solution will reduce the build and download
# time of the image on the server (layers are reused)
COPY ./src /odoo/src
COPY ./external-src /odoo/external-src
COPY ./local-src /odoo/local-src
COPY ./data /odoo/data
COPY ./songs /odoo/songs
COPY ./setup.py /odoo/
COPY ./VERSION /odoo/
COPY ./migration.yml /odoo/

COPY ./requirements.txt /odoo/

USER root
RUN \
  # Project's specific packages
  apt-get update \
  && apt-get install -y --no-install-recommends python3-shapely \
  && pip install -r /odoo/requirements.txt -e /odoo -e /odoo/src \
  # cleaning of dev packages
  && /install/apt_purge.sh

ENV ADDONS_PATH=/odoo/local-src,/odoo/src/addons
