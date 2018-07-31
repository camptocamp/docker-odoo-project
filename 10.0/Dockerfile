FROM debian:jessie
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /odoo /var/log/odoo

COPY ./base_requirements.txt /odoo
COPY ./install /install

# build and dev packages
ENV BUILD_PACKAGE \
    build-essential \
    python-dev \
    libffi-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    git

ENV PURGE_PACKAGE npm

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
        && /install/package_odoo_9.0_10.0.sh \
        && /install/setup-pip.sh \
        && /install/postgres.sh \
        && /install/wkhtml_12_1_2.sh \
        && /install/dev_package.sh \
        && pip install -U pip setuptools \
        && pip install -r /odoo/base_requirements.txt \
        && /install/purge_dev_package_and_cache.sh

# grab gosu for easy step-down from root and dockerize to generate template and
# wait on postgres
RUN /install/gosu.sh && /install/dockerize.sh

COPY ./src_requirements.txt /odoo
COPY ./bin /odoo-bin
COPY ./templates /templates
COPY ./before-migrate-entrypoint.d /before-migrate-entrypoint.d
COPY ./start-entrypoint.d /start-entrypoint.d
COPY ./MANIFEST.in /odoo

VOLUME ["/data/odoo", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENV ODOO_VERSION=10.0 \
    PATH=/odoo-bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_NAME=odoodb \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    ODOO_BASE_URL=http://localhost:8069 \
    ODOO_REPORT_URL=http://localhost:8069 \
    DEMO=False \
    ADDONS_PATH=/odoo/local-src,/odoo/src/addons \
    OPENERP_SERVER=/etc/odoo.cfg

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]
