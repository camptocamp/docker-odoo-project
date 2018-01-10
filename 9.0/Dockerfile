FROM debian:jessie
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /opt/odoo /var/log/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./

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
        && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            postgresql-client \
            libpq-dev \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && pip install -U pip && pip install -r base_requirements.txt \
        && apt-get remove -y build-essential python-dev libfreetype6-dev libpq-dev libxml2-dev libxslt1-dev \
                             libsasl2-dev libldap2-dev libssl-dev libjpeg-dev zlib1g-dev libfreetype6-dev git \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
        && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

# grab dockerize for generation of the configuration file and wait on postgres
RUN curl -o dockerize-linux-amd64-v0.6.0.tar.gz https://github.com/jwilder/dockerize/releases/download/v0.6.0/dockerize-linux-amd64-v0.6.0.tar.gz -SL \
    && echo 'a13ff2aa6937f45ccde1f29b1574744930f5c9a5 dockerize-linux-amd64-v0.6.0.tar.gz' | sha1sum -c - \
    && tar xvfz dockerize-linux-amd64-v0.6.0.tar.gz -C /usr/local/bin && rm dockerize-linux-amd64-v0.6.0.tar.gz

COPY ./src_requirements.txt ./
COPY ./bin bin
COPY ./bin_compat bin_compat
COPY ./etc etc
COPY ./before-migrate-entrypoint.d before-migrate-entrypoint.d
COPY ./start-entrypoint.d start-entrypoint.d
COPY ./MANIFEST.in ./

VOLUME ["/data/odoo", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENV ODOO_VERSION=9.0 \
    PATH=/opt/odoo/bin:/opt/odoo/bin_compat:$PATH \
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
