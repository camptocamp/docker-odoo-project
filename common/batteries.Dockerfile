# hadolint ignore=DL3006  # Use `docker build --build-context ...`
FROM odoo
LABEL maintainer="Camptocamp"

COPY ./.coveragerc /odoo/

# Install extra requirements
RUN /install/dev_package.sh \
    && pip install -r /odoo/extra_requirements.txt \
    && /install/purge_dev_package_and_cache.sh
