FROM debian:jessie
MAINTAINER Camptocamp

ENV DB_PORT 5432

# see http://stackoverflow.com/a/29799703
RUN groupadd -r odoo && useradd -r -g odoo odoo

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            antiword \
            ca-certificates \
            curl \
            ghostscript \
            graphviz \
            node-clean-css \
            node-less \
            poppler-utils \
            postgresql-client \
            python \
            python-dateutil \
            python-decorator \
            python-docutils \
            python-feedparser \
            python-gevent \
            python-imaging \
            python-jinja2 \
            python-ldap \
            python-libxslt1 \
            python-lxml \
            python-mako \
            python-mock \
            python-openid \
            python-passlib \
            python-pip \
            python-psutil \
            python-psycopg2 \
            python-pybabel \
            python-pychart \
            python-pyinotify \
            python-pyparsing \
            python-pypdf \
            python-renderpm \
            python-reportlab \
            python-simplejson \
            python-support \
            python-tz \
            python-unittest2 \
            python-vatnumber \
            python-vobject \
            python-werkzeug \
            python-xlwt \
            python-yaml \
            xfonts-75dpi \
            xfonts-base \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

# grab dockerize for generation of the configuration file and wait on postgres
RUN curl https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -L | tar xz -C /usr/local/bin

ENV ODOO_VERSION 9.0

RUN mkdir -p /opt/odoo

WORKDIR "/opt/odoo"

COPY ./base_requirements.txt ./
RUN pip install -U pip && pip install -r base_requirements.txt

COPY ./bin bin

COPY oerpscenario /opt/odoo/oerpscenario

VOLUME ["/data/odoo"]

# Expose Odoo services
EXPOSE 8069 8072

# Set the default config file
ENV OPENERP_SERVER /opt/odoo/etc/openerp.cfg

ENV PYTHONPATH /opt/odoo/src

# so we can run odoo.py, oerpscenario, ... without the full path
RUN ln -s /opt/odoo/src/odoo.py /opt/odoo/bin/odoo.py \
    && ln -s /opt/odoo/src/openerp-gevent /opt/odoo/bin/openerp-gevent
ENV PATH /opt/odoo/bin:$PATH

ENTRYPOINT ["./bin/docker-entrypoint.sh"]
CMD ["./src/odoo.py"]

# intermediate images should help speed up builds when only local-src, or only
# external-src changes
ONBUILD COPY ./src src
ONBUILD COPY ./external-src external-src
ONBUILD COPY ./local-src local-src
ONBUILD COPY ./data data
ONBUILD COPY ./features features

# Copy entrypoint script and Odoo configuration file
ONBUILD COPY ./etc etc
ONBUILD RUN chown odoo /opt/odoo/etc/* \
      && chown odoo /opt/odoo/bin/docker-entrypoint.sh
