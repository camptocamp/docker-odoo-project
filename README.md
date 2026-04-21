[![Build Status](https://app.travis-ci.com/camptocamp/docker-odoo-project.svg?branch=master)](https://app.travis-ci.com/camptocamp/docker-odoo-project)

# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Dockerfile inheriting from this image.

A project using this image has to respect a defined structure, look at the [example](example).

See also the [Changelog](HISTORY.rst).

## ⚠️ Reporting now uses kwkhtmltopdf instead of wkhtmltopdf

To limit the amount of memory required on each container to print a report

We have switched to the kwkhtmltopdf project: https://github.com/acsone/kwkhtmltopdf

the kwkhtmltopdf client is included in the base image, you must set the
env variable :

KWKHTMLTOPDF_SERVER_URL=<url of your KWKHTMLTOPDF server>:<port>

and you also need to specify the report URL to let the kwkhtmltopdf server to retrieve images/headers, etc. from Odoo:

ODOO_REPORT_URL=<url of your odoo:8069>

## ⚠️ Images moved to ghcr.io

Due to the pull limitation on docker.io the images are now pushed exclusively on ghcr.io.

Images can be found under the Github link "Packages".
https://github.com/camptocamp/docker-odoo-project/pkgs/container/odoo-project

## Image Flavors

There are 2 flavors of the image:

- normal: `odoo-project:${odoo_version}-${tag_version}`
- batteries-included: `odoo-project:${odoo_version}-${tag_version}-batteries`

Note: in production, we strongly recommend against using the "latest" tag.
Instead, use a specific version in order to be able to rebuild identical images.

### Normal or Batteries-included?

The batteries-included image is exactly the same image, with a list of
additional pre-installed python packages. The packages have been chosen because
of their prevalent usage in OCA addons.

The list of packages (with their version) is defined in the extra_requirements.txt file.

* [19.0/extra_requirements.txt](19.0/extra_requirements.txt)

You can also see the Dockerfile that generated this image here: [common/Dockerfile-batteries](common/Dockerfile-batteries)

## Build

The images should be built with `make`:

Normal flavors:

```
$ make VERSION=19.0
```

Batteries-included flavors:
```
$ make VERSION=19.0 BATTERIES=True
```


## Configuration

The host for the database is in `$DB_HOST` (`db` by default).

A volume `/data/odoo` is declared, which is expected to contain Odoo's filestore
(this path is set in `odoo.cfg`).

Ports 8069 and 8072 are exposed by default.

## Environment variables

### ODOO_BASE_URL

The `ir.config_parameter` `web.base.url` will be automatically set to this
domain when the container starts. `web.base.url.freeze` will be set to `True`.
Default url is `http://localhost:8069`. If `ODOO_BASE_URL` is set to an empty
value, the configuration parameters will be left unchanged.

### ODOO_REPORT_URL

The `ir.config_parameter` `report.url` will be automatically set to this
domain when the container starts.
Default url is `http://localhost:8069`. As soon as we use kwkhtmltopdf
we must set this URL to be accessible by your kwkhtmltopdf server.

### KWKHTMLTOPDF_SERVER_URL

It points to the server that hosts the kwktmltopdf server to serve files


### MIGRATE

`MIGRATE` can be `True` or `False` and determines whether migration tool
marabunta will be launched. By default, migration will be launched.

Migration is *not* launched when using:

```
    docker compose run --rm odoo odoo shell [...]
    docker compose run --rm odoo odoo [...] --help [...]
```

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
dangerous to execute a migration script (say 19.1.0) if the version of the code
is not the same (say 19.2.0).

For a production server, it works, because usually you only want to upgrade to
the last version N from N-1. But for development or a test server, you might
want to take the risk of running all the migration scripts consecutively, this
is what `MARABUNTA_ALLOW_SERIE=True` is for.

### MARABUNTA_FORCE_VERSION

When you are developing / testing migrations with
[Marabunta](https://github.com/camptocamp/marabunta), you can force the upgrade
of a specific version with `MARABUNTA_FORCE_VERSION=<version>`.

### ODOO_DATA_PATH

Specifies path of data folder where to put base setup data for your project.
In `anthem` songs this allows you to pass relative paths
instead of recovering the full path via module resource paths.
More precisely, if you set this var you can skip this in your songs:

```
  from pkg_resources import Requirement, resource_stream

  req = Requirement.parse('my-odoo')


  def load_csv(ctx, path, model, delimiter=',',
               header=None, header_exclude=None):
      content = resource_stream(req, path)
      load_csv(ctx, content, ...)
```

and use `anthem` loader straight::

```
  from anthem.lyrics.loaders import load_csv

  load_csv('relative/path/to/file', ...)
```

NOTE: `anthem > 0.11.0` is required.

### DEMO

`DEMO` can be `True` or `False` and determines whether Odoo will load its Demo
data. It has effect only at the creation of the database.

### LOCAL_USER_ID

By default, the user ID inside the container is 9001. There is little
concern with this ID until we setup a host volume: the same user ID will be
used to write the files on the host's filesystem. 9001 will probably be
inexistent on the host system, but at least it will not collide with an actual
user.

Instead, you can set the ID of the host's system in `LOCAL_USER_ID`, which will
then be shared by the container. All the files created in host volumes will
then share the same user.

### CREATE_DB_CACHE

Used in `bin/runtests` and `bin/runmigration`.

If set to "true", it creates a dump in `.cachedb` of an intermediate state of the tests or migration.
By default not set, thus unactivated.

### LOAD_DB_CACHE

Used in `bin/runtests` and `bin/runmigration`.

If set to "false", it skips trying to reload a cached dump from `.cachedb`.

### SUBS_MD5

This value is used in `bin/runtests` to determine the name of the intermediate state to
load or create.

Value to tag a database dump of `bin/runtests`, for instance it can be based on
submodules in .travis.yml of your git repositories in odoo/src and in odoo/external-src:

```
export SUBS_MD5=$(git submodule status | md5sum | cut -d ' ' -f1)
```

You want this value to be unique and identify your dependencies, thus if a
dependency change you need to generate a new one.

### MIG_LOAD_VERSION_CEIL

Used in `bin/runmigration` to specify from which dump we want to play the migration.
In case you have a dump per version, you can play the migration against the version of your choice.
If the version specified does not exists, it will search for a lower occurence.

It will load a dump lower than "odoo_sample_$MIG_LOAD_VERSION_CEIL.dmp"
This is useful if you bumped odoo/VERSION as it won't match existing
dumps.

For instance you have made a dump 19.1.0, you are now on the version
19.2.0, if you pass your current version it will search for a dump
lower than 19.2.0 and restore the 19.1.0. Then play the remaining
steps on top of it.

### ODOO_NEUTRALIZE

`ODOO_NEUTRALIZE` can be `True` or `False`. When set to `True` (default), the image will execute the official Odoo neutralization script if `RUNNING_ENV` is not set to `prod`. This deactivates outgoing emails, scheduled actions, and external payments to prevent accidental data leaks from production dumps.

    Note: This requires Odoo 16.0 or higher.

### CONFIDOO_APPLY

`CONFIDOO_APPLY` can be `True` or `False`. When set to `True` (default), the image will use the [confidoo tool](https://github.com/camptocamp/confidoo) to apply settings defined in environment variables. This runs after neutralization and migrations but before the Odoo server starts.

### ODOO_ENVIRONMENT_CONFIG

An INI-formatted string containing system parameters or Odoo configurations to be applied by Confidoo.
Example from [the tool documentation](https://github.com/camptocamp/confidoo):
  ```
  ODOO_ENVIRONMENT_CONFIG: |
    # Disable all scheduled actions
    [model:ir.cron]
    active = False

    # Update specific partner
    [record:base.partner_admin]
    name = Confidoo Admin
    email = admin@confidoo.com

    # Set system parameters
    [config:set_param]
    ribbon.name = Test Environment
    database.uuid = 0000-0000-0000-0000

    # Remove expiration settings
    database.expiration_reason =
    database.expiration_date =
  ```

### ODOO_ENVIRONMENT_SECRET_CONFIG

Similar to `ODOO_ENVIRONMENT_CONFIG`, but intended for sensitive data (API keys, passwords).


## Odoo Configuration Options

There are three ways to configure Odoo in this image, depending on the scope and persistence required:


1. The main configuration options of Odoo can be configured through environment variables. The name of the environment variables are the same of the options but uppercased (eg. `workers` becomes `WORKERS`).

Look in [19.0/templates/odoo.cfg.tmpl](19.0/templates/odoo.cfg.tmpl) to see the full list.

While most of the variables can be set in the docker compose file so we can have different values for different environments, the `ADDONS_PATH` **must** be set in the `Dockerfile` of your project with a line such as:

```
ENV ADDONS_PATH=/odoo/local-src,/odoo/external-src/server-tools,/odoo/src/addons
```

By setting this value in the `Dockerfile`, it will be integrated into the build and thus will be consistent across each environment.

By the way, you can add other `ENV` variables in your project's `Dockerfile` if you want to customize the default values of some variables for a project.

2. Declarative Configuration via Confidoo (non-production environment)

For Odoo 16.0+, it is recommended to use Confidoo for managing system parameters and complex configurations. This is handled via the ODOO_ENVIRONMENT_CONFIG and ODOO_ENVIRONMENT_SECRET_CONFIG variables.

Unlike standard environment variables, Confidoo:

    Can set `ir.config_parameter` values directly in the database.

    Supports INI-style sections.

    Is applied automatically during the entrypoint sequence in non-production environments.

3. Raw Configuration Injection (`ADDITIONAL_ODOO_RC`)

You can also use environment variable `ADDITIONAL_ODOO_RC` for any additional parameters that must go in the `odoo.cfg` file.
e.g.:
```
ADDITIONAL_ODOO_RC="
custom_param=42
other_param='some value'
"
```


## Running tests

### runtests

Inside the container, a script `runtests` is used for running the tests on Travis.

Unless `LOAD_DB_CACHE is set to `false` it will search for a dump of dependencies and restore it.
Otherwise, will create a new database, find the `odoo/external-src` and `odoo/src` dependencies of the local addons,
and if `CREATE_DB_CACHE` is activated, it creates a dump of that state.

Then it will install local addons, run their tests, and show the code coverage.

```
docker compose run --rm [-e CREATE_DB_CACHE=true] [-e LOAD_DB_CACHE=false] [-e SUBS_MD5=<hash>] odoo runtests
```


This is not the day-to-day tool for running the tests as a developer.

### pytests

pytest is included and can be invoked when starting a container. It needs an existing database to run the tests:

```
docker compose run --rm -e DB_NAME=testdb odoo testdb-gen -i my_addon
docker compose run --rm -e DB_NAME=testdb odoo pytest -s odoo/local-src/my_addon/tests/test_feature.py::TestFeature::test_it_passes
```

When you make changes in the addon, you need to update it in Odoo before running the tests again. You can use:

```
docker compose run --rm -e DB_NAME=testdb odoo testdb-update -u my_addon
```

When you are done, you can drop the database with:

```
docker compose run --rm odoo dropdb testdb
```


Pytest uses a plugin (https://github.com/camptocamp/pytest-odoo) that corrects the
Odoo namespaces (`openerp.addons`/`odoo.addons`) when running the tests.

### pytest-cov

pytest-cov is also included and can be used to generate a coverage report.
You can add --cov=MODULE_PATH to your pytest to get a text version in the shell, or export it as HTML so you can browse the results.
To export it to HTML, add --cov-report=HTML:EXPORT_PATH

### runmigration

Inside the container, a script `runmigration` is used to run the migration steps on Travis.

Then, when launched, it will search for a database dump of the content of `odoo/VERSION` file.
Or if you provided `MIG_LOAD_VERSION_CEIL` which will allow you to search for an other version.
If no dump is available (or `LOAD_DB_CACHE` is set to `false`), migration will start from scratch.

The migration steps are then run.

If migration succeeds, a dump is created if `CREATE_DB_CACHE` is set to `true`.

```
docker compose run --rm [-e CREATE_DB_CACHE=true] [-e LOAD_DB_CACHE=false] [-e MIG_LOAD_VERSION_CEIL=x.y.z] odoo runmigration
```

This tool really speeds up the process of testing migration steps, as you can be executing only a single step instead of redoing all.

### cached dumps (runtests / runmigration)

To use database dumps, you will need a volume on `/.cachedb` to have persistant dumps.

On travis, you will also want to activate the cache, if your volume definition is `- "$HOME/.cachedb:/.cachedb"`
add this in `.travis.yml`:

```
cache:
  directories:
    - $HOME/.cachedb
```

## Start entrypoint

Any script in any language placed in `/start-entrypoint.d` will be
executed just between the migration and the start of Odoo.
Similarly, scripts placed in `/before-migrate-entrypoint.d` will be
executed just before the migration.

The order of execution of the files is determined by the `run-parts` 's rules.
You can add your own scripts in those directories. They must be named
something like `010_abc` (`^[a-zA-Z0-9_-]+$`) and must have no extension (or
it would not be picked up by `run-parts`).

Important: The database is guaranteed to exist when the scripts are run, so you
must take that into account when writing them. Usually you'll want to use such
check:

```
  if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" )" != '1' ]
  then
      echo "Database does not exist, ignoring script"
      exit 0
  fi
```

The scripts are run only if the command is `odoo`/`odoo.py`.

## Legacy images

Legacy images are used for projects using deprecated Odoo versions (7 & 8).
They work the same as the newer ones, with a few differences.

### Anthem

`anthem` is not available in these images as the Odoo API is too old to use it.
If you want to script migration parts, you can write a script using `erppeek`.

Sidenote: You can still use SQL scripts the same as before

### Demo Data

In Odoo 8, the configuration parameter `without_demo` can be sometimes buggy (Odoo will still install demo data even if it is told not to do so).

To circumvent this behavior, you can force this parameter in the command line used to start Odoo (check [migration.yml](example/odoo/migration.yml) as an example).
