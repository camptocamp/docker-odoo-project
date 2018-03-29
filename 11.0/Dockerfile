FROM debian:stretch
MAINTAINER Camptocamp

# create the working directory and a place to set the logs (if wanted)
RUN mkdir -p /opt/odoo /var/log/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./
COPY ./install /install

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
        && apt-get update \
        && apt-get purge python2.7 python2.7-minimal \
        && apt-get install -y --no-install-recommends \
            antiword \
            ca-certificates \
            curl \
            dirmngr \
            ghostscript \
            graphviz \
            gnupg2 \
            less \
            nano \
            node-clean-css \
            node-less \
            poppler-utils \
            python3-pip \
            python3-setuptools \
            python3-renderpm \
            libxslt1.1 \
            xfonts-75dpi \
            xfonts-base \
            tcl expect \
            # build packages to clean after the pip install
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
            git \
        && /install/setup-pip.sh \
        && curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            postgresql-client \
            libpq-dev \
        && curl -o wkhtmltox.tar.xz -SL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
        && echo '3f923f425d345940089e44c1466f6408b9619562 wkhtmltox.tar.xz' | sha1sum -c - \
        && tar xvf wkhtmltox.tar.xz \
        && cp --no-dereference --preserve=link wkhtmltox/lib/* /usr/local/lib/ \
        && cp wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
        && rm -rf wkhtmltox wkhtmltox.tar.xz \
        && apt-get -y install -f --no-install-recommends \
        && pip3 install -U pip setuptools && pip3 install wheel && pip3 install -r base_requirements.txt --ignore-installed \
        && apt-get remove -y build-essential gcc python3.5-dev libevent-dev libfreetype6-dev libpq-dev libxml2-dev libxslt1-dev git \
                             libsasl2-dev libldap2-dev libssl-dev libjpeg-dev libpng-dev zlib1g-dev \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
        && ln -s $(which pip3) /usr/bin/pip \
        && rm -rf /var/lib/apt/lists/* /root/.cache/pip/*

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
ONBUILD RUN cd /opt/odoo && pip3 install -r src_requirements.txt
