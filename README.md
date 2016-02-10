# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Docker inheriting from this image.

The structure of a project has to respect a structure, look at the [example](example).

## Configuration

The host for the database is `db`.

You are expected to set the  following environment variables:

* `DB_USER`: user that connects on the db
* `DB_PASS`: password for this user
* `DB_NAME`: name of the database
* `SCENARIO_MAIN_TAG`: tag filtering oerpscenario's features, usually the name of the project

Note: those variables are not yet substituted in the project's `openerp.cfg`
configuration file, so for now you should set them correctly in the
configuration file.

A volume `/data/odoo` is shared, which is expected to contain Odoo's filestore
(to set in `openerp.cfg`).

Ports 8069 and 8072 are exposed by default.

## Particularities

When a container is started, if no database exists, the entrypoint will call
the setup script of `oerpscenario` with the tags `$SCENARIO_MAIN_TAG` and
`setup` followed by `demo`, creating and initializing the database.
