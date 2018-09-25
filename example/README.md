# Odoo Project Example

The base images does nothing alone, it only contains the dependencies and a few
tools, but you need to create an inheriting image with the odoo and addons
code.

Follow the steps:

1. Create directories. This is mandatory, they will be copied in the image

        mkdir -p odoo/external-src odoo/local-src odoo/data odoo/songs

2. Add a submodule for Odoo (official or OCA/OCB)

        git submodule init
        git submodule add git@github.com:odoo/odoo.git odoo/src

3. Optionally add submodules for external addons in `odoo/external-src`
 
        git submodule add git@github.com:OCA/server-tools.git odoo/external-src/server-tools

4. Optionally add custom addons in `odoo/local-src`

6. Create the Dockerfile, the bare minimum being (see also [the example
   file](odoo/Dockerfile) that installs additional dependencies):

        FROM camptocamp/odoo-project:11.0
        MAINTAINER <name>

        ENV ADDONS_PATH=/odoo/local-src,/odoo/external-src/server-tools,/odoo/src/addons

7. Build your image

        docker build -t youruser/odoo-project-example .

8. Optionally create a [docker-compose.yml](docker-compose.yml) file. This
   example is a development composition.
