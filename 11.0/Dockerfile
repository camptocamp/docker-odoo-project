FROM debian:stretch
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /opt/odoo /var/log/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./
COPY ./extra_requirements.txt ./
COPY ./install /install

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# build and dev packages
ENV BUILD_PACKAGE \
    build-essential \
    gcc \
    python3.5-dev \
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
    git

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
        && /install/package_odoo_11.0.sh \
        && /install/setup-pip.sh \
        && /install/postgres.sh \
        && /install/wkhtml_12_4.sh \
        && /install/dev_package.sh \
        && /install/pip3_package.sh \
        && /install/purge_dev_package_and_cache.sh

# grab gosu for easy step-down from root and dockerize to generate template and
# wait on postgres
RUN /install/gosu.sh && /install/dockerize.sh && rm -rf /install

COPY ./src_requirements.txt ./
COPY ./bin bin
COPY ./etc etc
COPY ./before-migrate-entrypoint.d before-migrate-entrypoint.d
COPY ./start-entrypoint.d start-entrypoint.d
COPY ./MANIFEST.in ./

VOLUME ["/data/odoo", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENV ODOO_VERSION=11.0 \
    PATH=/opt/odoo/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_NAME=odoodb \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    ODOO_BASE_URL=http://localhost:8069 \
    ODOO_DATA_PATH=/opt/odoo/data \
    DEMO=False \
    ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/src/addons \
    OPENERP_SERVER=/opt/odoo/etc/odoo.cfg

# set to /opt so we can have the same path outside and inside of the container:
# docker run --rm odoo pytest odoo/external-src/abc/xyz/tests/test.py
WORKDIR "/opt"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]
