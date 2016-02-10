# Odoo Project Example

The base images does nothing alone, it only contains the dependencies and a few
tools, but you need to create an inheriting image with the odoo and addons
code.

Follow the steps:

1. Create directories. This is mandatory, they will be copied in the image

        mkdir -p external-src local-src etc data features

2. Add a submodule for Odoo (official or OCA/OCB)

        git submodule init
        git submodule add git@github.com:odoo/odoo.git src

3. Optionally add submodules for external addons in `external-src`
 
        git submodule add git@github.com:OCA/server-tools.git external-src/server-tools

4. Optionally add custom addons in `local-src`

5. Create `openerp.cfg` in `etc`, see [the example file](etc/openerp.cfg).
   Adapt the `addons_path` and the other options if needed.

6. Create the Dockerfile, the bare minimum being (see also [the example
   file](etc/openerp.cfg) that installs additional dependencies):

        FROM camptocamp/odoo-project:9.0
        MAINTAINER <name>

7. Build your image

        docker build -t namespace/project .
