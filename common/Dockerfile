FROM python
ARG VERSION=19.0
ARG UID=999
ARG GID=999


# create the working directory and a place to set the logs (if wanted)
RUN groupadd -g $GID odoo \
    && adduser --disabled-password --no-create-home --gecos '' \
               --home /odoo --uid $UID --gid $GID odoo \
    && install -m 770 -o odoo -d /templates /var/log/odoo \
                                 /odoo /odoo/.venv /odoo/src \
                                 /odoo/data \
                                 /odoo/data/odoo \
                                 /odoo/data/odoo/addons \
                                 /odoo/data/odoo/filestore \
                                 /odoo/data/odoo/sessions \
                                 /odoo/odoo-bin \
                                 /odoo/before-migrate-entrypoint.d \
                                 /odoo/start-entrypoint.d \
    && install -m 660 -o odoo /dev/null /odoo/odoo.cfg \
    && install -m 660 -o odoo /dev/null /odoo/.bashrc

COPY --chown=odoo:root --chmod=770 ./install /install
COPY --chown=odoo:root --chmod=660 ./base_requirements.txt /odoo
COPY --chown=odoo:root --chmod=660 ./extra_requirements.txt /odoo

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/odoo/.venv/bin:$PATH \
    PYTHONPATH=/odoo/

# build and dev packages
ENV BUILD_PACKAGE="\
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
    libcairo2-dev"


# Default SHELL is ["/bin/sh", "-c"]
SHELL ["/bin/sh", "-e", "-x", "-c"]


# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN /install/package_odoo.sh \
    && /install/setup-pip.sh \
    && /install/postgres.sh \
    && /install/kwkhtml_client.sh \
    && /install/kwkhtml_client_force_python3.sh \
    && /install/dev_package.sh \
    && su odoo -c "umask 007 \
    && python3 -m venv /odoo/.venv --system-site-packages \
    && /odoo/.venv/bin/pip install -r /odoo/base_requirements.txt \
    && /odoo/.venv/bin/pip install -r /odoo/extra_requirements.txt" \
    && chgrp -R root /odoo/.venv \
    # Grab dockerize to generate template and wait on postgres
    && /install/dockerize.sh \
    # Purge build packages, to reduce layer size
    && /install/purge_dev_package_and_cache.sh

COPY --chown=odoo:root --chmod=660 ./src_requirements.txt /odoo
COPY --chown=odoo:root --chmod=770 ./bin /odoo/odoo-bin
COPY --chown=odoo:root --chmod=660 ./templates /templates
COPY --chown=odoo:root --chmod=770 ./before-migrate-entrypoint.d /odoo/before-migrate-entrypoint.d
COPY --chown=odoo:root --chmod=770 ./start-entrypoint.d /odoo/start-entrypoint.d
COPY --chown=odoo:root --chmod=660 ./MANIFEST.in /odoo


USER odoo
RUN echo "export PATH=$PATH" >> ~/.bashrc

ENV ODOO_VERSION=$VERSION \
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

VOLUME ["/data/odoo", "/var/log/odoo"]
EXPOSE 8069 8072

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["odoo"]
