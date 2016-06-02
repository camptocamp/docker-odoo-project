# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Docker inheriting from this image.

A project has to respect a structure, look at the [example](example).

## Configuration

The host for the database is `db`.

You are expected to set the  following environment variables:

* `DB_USER`: user that connects on the db
* `DB_PASSWORD`: password for this user
* `DB_NAME`: name of the database
* `SCENARIO_MAIN_TAG`: tag filtering oerpscenario's features, usually the name of the project
* Optionally every variable used in `etc/openerp.cfg.tmpl`, the syntax is:
  https://github.com/jwilder/dockerize#using-templates

A volume `/data/odoo` is shared, which is expected to contain Odoo's filestore
(this path is set in `openerp.cfg`).

Ports 8069 and 8072 are exposed by default.

## Environment variables

**`SCENARIO_MAIN_TAG`**

Will be deprecated once the new scenario system is there.
When a container is started, if no database exists, the entrypoint will call
the setup script of `oerpscenario` with the tags `$SCENARIO_MAIN_TAG` plus
`setup` followed by `demo`, creating and initializing the database.
So usually, this variable is set to the name of the project.

**DEMO**:

Accepted values for DEMO:
* none (default value): no demo data
* odoo: create Odoo's database with Odoo's demo data only (only works at the creation
  of the database!)
* scenario: load the demo from the scenario only
* all: lead both Odoo's demo data and the scenario demo data
