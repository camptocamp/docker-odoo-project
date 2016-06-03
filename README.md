# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Docker inheriting from this image.

A project has to respect a structure, look at the [example](example).

## Configuration

The host for the database is `db`.

A volume `/data/odoo` is shared, which is expected to contain Odoo's filestore
(this path is set in `openerp.cfg`).

Ports 8069 and 8072 are exposed by default.

## Environment variables

### SCENARIO_MAIN_TAG

Will be deprecated once the new scenario system is there.
When a container is started, if no database exists, the entrypoint will call
the setup script of `oerpscenario` with the tags `$SCENARIO_MAIN_TAG` plus
`setup` followed by `demo`, creating and initializing the database.
So usually, this variable is set to the name of the project.

### DEMO

Accepted values for DEMO:
* none (default value): no demo data
* odoo: create Odoo's database with Odoo's demo data only (only works at the creation
  of the database!)
* scenario: load the demo from the scenario only
* all: lead both Odoo's demo data and the scenario demo data

### LOCAL_USER_ID

By default, the user ID inside of the container will be 9001. There is little
concern with this ID until we setup a host volume: the same user ID will be
used to write the files on the host's filesystem. 9001 will probably be
inexistent on the host system but at least it will not collide with an actual
user.

Instead, you can set the ID of the host's system in `LOCAL_USER_ID`, which will
then be shared by the container. All the files created in host volumes will
then share the same user.

### Odoo Configuration Options

The main configuration options of Odoo can be configured through environment variables. The name of the environment variables are the same of the options but uppercased (eg. `workers` becomes `WORKERS`).

Look in [9.0/etc/openerp.cfg.tmpl](9.0/etc/openerp.cfg.tmpl) to see the full list.

While most of the variables can be set in the docker-compose file so we can have different values for different environments, the `ADDONS_PATH` **must** be set in the `Dockerfile` of your project with a line such as:

```
ENV ADDONS_PATH=/opt/odoo/local-src,/opt/odoo/external-src/server-tools,/opt/odoo/src/addons
```

By setting this value in the `Dockerfile`, it will be integrated into the build and thus will be consistent across each environment.

By the way, you can add other `ENV` variables in your project's `Dockerfile` if you want to customize the default values of some variables for a project.
