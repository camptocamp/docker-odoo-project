FROM debian:jessie
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /opt/odoo /var/log/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./
COPY ./install /install

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            antiword \
            ca-certificates \
            curl \
            ghostscript \
            graphviz \
            less \
            nano \
            node-clean-css \
            node-less \
            poppler-utils \
            python \
            python-libxslt1 \
            python-pip \
            xfonts-75dpi \
            xfonts-base \
            # build packages to clean after the pip install
            build-essential \
            python-dev \
            libfreetype6-dev \
            libxml2-dev \
            libxslt1-dev \
            libsasl2-dev \
            libldap2-dev \
            libssl-dev \
            libjpeg-dev \
            zlib1g-dev \
            libfreetype6-dev \
            tcl expect \
            git \
        && /install/setup-pip.sh \
        && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            postgresql-client \
            libpq-dev \
        && curl -o wkhtmltox.deb -SL https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.jessie_amd64.deb \
        && echo '4d104ff338dc2d2083457b3b1e9baab8ddf14202 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && pip install -U pip setuptools && pip install -r base_requirements.txt \
        && apt-get remove -y build-essential python-dev libfreetype6-dev libpq-dev libxml2-dev libxslt1-dev \
                             libsasl2-dev libldap2-dev libssl-dev libjpeg-dev zlib1g-dev libfreetype6-dev git \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

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

ENV ODOO_VERSION=10.0 \
    PATH=/opt/odoo/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_NAME=odoodb \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    ODOO_BASE_URL=http://localhost:8069 \
    DEMO=False \
    ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/src/addons \
    OPENERP_SERVER=/opt/odoo/etc/odoo.cfg

# set to /opt so we can have the same path outside and inside of the container:
# docker run --rm odoo pytest odoo/external-src/abc/xyz/tests/test.py
WORKDIR "/opt"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]

# intermediate images should help speed up builds when only local-src, or only
# external-src changes
ONBUILD COPY ./src /opt/odoo/src
ONBUILD COPY ./external-src /opt/odoo/external-src
ONBUILD COPY ./local-src /opt/odoo/local-src
ONBUILD COPY ./data /opt/odoo/data
ONBUILD COPY ./songs /opt/odoo/songs
ONBUILD COPY ./setup.py /opt/odoo/
ONBUILD COPY ./VERSION /opt/odoo/
ONBUILD COPY ./migration.yml /opt/odoo/
# need to be called at the end, because it installs . and src
ONBUILD RUN cd /opt/odoo && pip install -r src_requirements.txt
