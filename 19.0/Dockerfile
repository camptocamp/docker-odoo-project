FROM python:3.12-slim-trixie
ARG UID=999
ARG GID=0


# create the working directory and a place to set the logs (if wanted)
RUN adduser --disabled-password --no-create-home \
            --home /odoo --gecos '' -u $UID --gid $GID odoo \
    && install -m 770 -o odoo -d /var/log/odoo \
                                 /odoo /odoo/.venv /odoo/src \
                                 /odoo/data \
                                 /odoo/data/odoo \
                                 /odoo/data/odoo/addons \
                                 /odoo/data/odoo/filestore \
                                 /odoo/data/odoo/sessions \
    && install -m 660 -o odoo /dev/null /odoo/odoo.cfg \
    && install -m 660 -o odoo /dev/null /odoo/.bashrc

COPY --chown=odoo:root --chmod=770 ./install /install
COPY --chown=odoo:root --chmod=660 ./base_requirements.txt /odoo
COPY --chown=odoo:root --chmod=660 ./extra_requirements.txt /odoo

# Moved because there was a bug while installing `odoo-autodiscover`. There is
# an accent in the contributor name
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

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
    && /install/dev_package.sh

# grab dockerize to generate template and
# wait on postgres
RUN /install/dockerize.sh

COPY --chown=odoo:root --chmod=660 ./src_requirements.txt /odoo
COPY --chown=odoo:root --chmod=770 ./bin /odoo/odoo-bin
COPY --chown=odoo:root --chmod=660 ./templates /templates
COPY --chown=odoo:root --chmod=770 ./before-migrate-entrypoint.d /odoo/before-migrate-entrypoint.d
COPY --chown=odoo:root --chmod=770 ./start-entrypoint.d /odoo/start-entrypoint.d
COPY --chown=odoo:root --chmod=660 ./MANIFEST.in /odoo


VOLUME ["/data/odoo", "/var/log/odoo"]
USER odoo
RUN umask 007 \
    && python3 -m venv /odoo/.venv --system-site-packages
ENV PATH=/odoo/.venv/bin:$PATH
ENV PYTHONPATH=/odoo/
RUN echo "export PATH=$PATH" >> ~/.bashrc

RUN umask 007 \
    && /odoo/.venv/bin/pip install -r /odoo/base_requirements.txt \
    && /odoo/.venv/bin/pip install -r /odoo/extra_requirements.txt
USER root
RUN /install/purge_dev_package_and_cache.sh

USER odoo
EXPOSE 8069 8072

ENV ODOO_VERSION=19.0 \
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
