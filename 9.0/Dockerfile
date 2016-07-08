FROM debian:jessie
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /opt/odoo /var/log/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
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
            postgresql-client \
            python \
            python-libxslt1 \
            python-pip \
            xfonts-75dpi \
            xfonts-base \
            # build packages to clean after the pip install
            build-essential \
            python-dev \
            libfreetype6-dev \
            libpq-dev \
            libxml2-dev \
            libxslt1-dev \
            libsasl2-dev \
            libldap2-dev \
            libssl-dev \
            libjpeg-dev \
            zlib1g-dev \
            libfreetype6-dev \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && pip install -U pip && pip install -r base_requirements.txt \
        && apt-get remove -y build-essential python-dev libfreetype6-dev libpq-dev libxml2-dev libxslt1-dev \
                             libsasl2-dev libldap2-dev libssl-dev libjpeg-dev zlib1g-dev libfreetype6-dev \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
        && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

# grab dockerize for generation of the configuration file and wait on postgres
RUN curl https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -L | tar xz -C /usr/local/bin

COPY ./src_requirements.txt ./
COPY ./bin bin
COPY ./etc etc
COPY ./MANIFEST.in ./

VOLUME ["/data/odoo", "/var/log/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

ENV ODOO_VERSION=9.0 \
    PATH=/opt/odoo/bin:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DB_PORT=5432 \
    DB_NAME=odoodb \
    DB_USER=odoo \
    DB_PASSWORD=odoo \
    DEMO=False \
    ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/src/addons \
    OPENERP_SERVER=/opt/odoo/etc/openerp.cfg

ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["./src/odoo.py"]

# intermediate images should help speed up builds when only local-src, or only
# external-src changes
ONBUILD COPY ./src src
ONBUILD COPY ./external-src external-src
ONBUILD COPY ./local-src local-src
ONBUILD COPY ./data data
ONBUILD COPY ./songs songs
ONBUILD COPY ./setup.py ./
ONBUILD COPY ./VERSION ./
ONBUILD COPY ./migration.yml ./
# need to be called at the end, because it installs . and src
ONBUILD RUN pip install -r src_requirements.txt
