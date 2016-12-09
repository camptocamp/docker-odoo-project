[![Build Status](https://travis-ci.org/camptocamp/docker-odoo-project.svg?branch=master)](https://travis-ci.org/camptocamp/docker-odoo-project)

# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Docker inheriting from this image.

A project has to respect a structure, look at the [example](example).

See also the [Changelog](HISTORY.rst).

## Build

The images should be build with `make`:

```
$ make VERSION=10.0  # generate image camptocamp/odoo-project:10.0-latest
$ make VERSION=9.0  # generate image camptocamp/odoo-project:9.0-latest
```

## Configuration

The host for the database is `db`.

A volume `/data/odoo` is declared, which is expected to contain Odoo's filestore
(this path is set in `openerp.cfg`).

Ports 8069 and 8072 are exposed by default.

## Environment variables

### MIGRATE

`MIGRATE` can be `True` or `False` and determines whether migration tool
marabunta will be launched. By default migration will be launched.

### MARABUNTA_MODE

In [Marabunta](https://github.com/camptocamp/marabunta) versions, you can
declare additional execution modes, such as `demo` or `full` in order to choose
which operations and addons are executed for a migration.

A typical use case would be:

* Install the set of addons in the base mode (the base mode is always executed)
* Load an excerpt of the data in the `demo` mode, used for test instances
* Load the complete dataset in the `full` mode, used for the integration and
  production servers

On the test server, you would set `MARABUNTA_MODE=demo` and on the production
one `MARABUNTA_MODE=full`.

### MARABUNTA_ALLOW_SERIE

By default, [Marabunta](https://github.com/camptocamp/marabunta) does not allow
to execute more than one version upgrade at a time. This is because it is
dangerous to execute a migration script (say 9.1.0) if the version of the code
is not the same (say 9.2.0).

For a production server, it works, because usually you only want to upgrade to
the last version N from N-1.  But for development or a test server, you might
want to take the risk of running all the migration scripts consecutively, this
is what `MARABUNTA_ALLOW_SERIE=True` is for. 

### MARABUNTA_FORCE_VERSION

When you are developing / testing migrations with
[Marabunta](https://github.com/camptocamp/marabunta), you can force the upgrade
of a specific version with `MARABUNTA_FORCE_VERSION=<version>`.

### DEMO

`DEMO` can be `True` or `False` and determines whether Odoo will load its Demo
data. It has effect only at the creation of the database.

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

## Running tests

Inside the container, a script `runtests` is used for running the tests on Travis.
It will create a new database, find the local addons, install them and run their tests.

```
docker-compose run --rm odoo runtests
```


This is not the day-to-day tool for running the tests as a developer.

pytest is included and can be invoked when starting a container. It needs an existing database to run the tests:

```
docker-compose run --rm -e DB_NAME=testdb odoo testdb-gen -i my_addon
docker-compose run --rm -e DB_NAME=testdb odoo pytest -s odoo/local-src/my_addon/tests/test_feature.py::TestFeature::test_it_passes
```

When you make changes in the addon, you need to update it in Odoo before running the tests again. You can use:

```
docker-compose run --rm -e DB_NAME=testdb odoo testdb-update -u my_addon
```

When you are done, you can drop the database with:

```
docker-compose run --rm odoo dropdb testdb
```


Pytest uses a plugin (https://github.com/camptocamp/pytest-odoo) that corrects the
Odoo namespaces (`openerp.addons`/`odoo.addons`) when running the tests.
