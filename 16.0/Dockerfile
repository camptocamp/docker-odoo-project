FROM python:3.12-slim-bookworm 
ARG UID=999
ARG GID=999
# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /odoo /var/log/odoo

COPY ./install /install
COPY ./base_requirements.txt /odoo
COPY ./extra_requirements.txt /odoo

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# build and dev packages
ENV BUILD_PACKAGE \
    build-essential \
    gcc \
    libevent-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libpng-dev \
    zlib1g-dev \
    libcairo2-dev 

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
# wkhtml-buster is kept as in official image, no deb available for bullseye
RUN set -x; \
        sh -c /install/package_odoo.sh \
        && /install/setup-pip.sh \
        && /install/postgres.sh \
        && /install/kwkhtml_client.sh \
        && /install/kwkhtml_client_force_python3.sh \
        && /install/dev_package.sh 

# grab dockerize to generate template and
# wait on postgres
RUN /install/dockerize.sh

COPY ./src_requirements.txt /odoo
COPY ./bin /odoo/odoo-bin
COPY ./templates /templates
COPY ./before-migrate-entrypoint.d /odoo/before-migrate-entrypoint.d
COPY ./start-entrypoint.d /odoo/start-entrypoint.d
COPY ./MANIFEST.in /odoo

RUN groupadd -g $GID odoo \
  && adduser --disabled-password -u $UID --gid $GID --gecos '' odoo \
  && touch /odoo/odoo.cfg \
  && touch /odoo/.bashrc \
  && mkdir -p /odoo/data/odoo/{addons,filestore,sessions} \
  && chown -R odoo:root /odoo && usermod odoo --home /odoo \
  && chown -R odoo:root /var/log/odoo

VOLUME ["/data/odoo", "/var/log/odoo"]
USER odoo
RUN python3 -m venv /odoo/.venv  --system-site-packages
ENV PATH=/odoo/.venv/bin:$PATH
ENV PYTHONPATH=$PYTHONPATH:/odoo/
RUN echo "export PATH=$PATH" >> ~/.bashrc

RUN /odoo/.venv/bin/pip install -r /odoo/base_requirements.txt  
RUN /odoo/.venv/bin/pip install -r /odoo/extra_requirements.txt
USER root
RUN set -x; \
        sh -c /install/purge_dev_package_and_cache.sh
USER odoo
EXPOSE 8069 8072

ENV ODOO_VERSION=16.0 \
    PATH=/odoo/odoo-bin:/odoo/.local/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_NAME=odoodb \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    ODOO_BASE_URL=http://localhost:8069 \
    ODOO_REPORT_URL=http://localhost:8069 \
    # the place where you put the data of your project (csv, ...)
    ODOO_DATA_PATH=/odoo/data \
    DEMO=False \
    ADDONS_PATH=/odoo/odoo/addons,/odoo/odoo/src/odoo/addons \
    ODOO_RC=/odoo/odoo.cfg

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]
