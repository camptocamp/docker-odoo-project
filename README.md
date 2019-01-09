[![Build Status](https://travis-ci.org/camptocamp/docker-odoo-project.svg?branch=master)](https://travis-ci.org/camptocamp/docker-odoo-project)

# docker-odoo-project

A base image for our Odoo projects.

This image alone does nothing because it doesn't contain any Odoo's code. The
code should be added in a Dockerfile inheriting from this image.

A project using this image has to respect a defined structure, look at the [example](example).

See also the [Changelog](HISTORY.rst).

## Image Flavors

There are 4 flavors of the image:

- normal: `odoo-project:${odoo_version}-${tag_version}`
- normal-onbuild: `odoo-project:${odoo_version}-${tag_version}-onbuild`
- batteries-included: `odoo-project:${odoo_version}-${tag_version}-batteries`
- batteries-included-onbuild: `odoo-project:${odoo_version}-${tag_version}-batteries-onbuild`

Note: in production, we strongly recommend to never use the "latest" tag.
Instead use a specific version in order to be able to rebuild identical images.

### Normal or Batteries-included?

The batteries-included image is exactly the same image, with a list of
additional pre-installed python packages. The packages have been chosen because
of their prevalent usage in OCA addons.

The list of package (with their version) is defined in the extra_requirements.txt file.

* [9.0/extra_requirements.txt](9.0/extra_requirements.txt)
* [10.0/extra_requirements.txt](10.0/extra_requirements.txt)
* [11.0/extra_requirements.txt](11.0/extra_requirements.txt)

you can also see the Dockerfile that generate this image here: [common/Dockerfile-batteries](common/Dockerfile-batteries)

### With or without onbuild?

The `onbuild` flavors add default *ONBUILD* instructions in the Dockerfile in
order to simplify the generation of custom image.

For more information on the *ONBUILD* command please read Docker documentation

The dockerfile for this flavor is here:  [common/Dockerfile-onbuild](common/Dockerfile-onbuild)

For comparison, two example of Dockerfile are shown in the project example here:

- without onbuild: [example/odoo/Dockerfile](example/odoo/Dockerfile)
- with onbuild: [example/odoo/Dockerfile-onbuild](example/odoo/Dockerfile-onbuild)

Note: the Dockerfile of the onbuild flavor is shorter but

- you can not create intermediary custom image based on it (as ONBUILD instruction need to be played).
- the official docker images have deprecated their `-onbuild` images: https://github.com/docker-library/official-images/issues/2076


## Build

The images should be build with `make`:

Normal flavors:

```
# generate image camptocamp/odoo-project:11.0-latest and camptocamp/odoo-project:11.0-latest-onbuild
$ make VERSION=11.0
# generate image camptocamp/odoo-project:10.0-latest and camptocamp/odoo-project:10.0-latest-onbuild
$ make VERSION=10.0
# generate image camptocamp/odoo-project:9.0-latest and camptocamp/odoo-project:9.0-latest-onbuild
$ make VERSION=9.0
```

Batteries-included flavors:
```
# generate image camptocamp/odoo-project:11.0-batteries-latest and camptocamp/odoo-project:11.0-latest-batteries-onbuild
$ make VERSION=11.0 BATTERIES=True
# generate image camptocamp/odoo-project:10.0-batteries-latest and camptocamp/odoo-project:10.0-latest-batteries-onbuild
$ make VERSION=10.0 BATTERIES=True
# generate image camptocamp/odoo-project:9.0-batteries-latest and camptocamp/odoo-project:9.0-latest-batteries-onbuild
$ make VERSION=9.0 BATTERIES=True
```


## Configuration

The host for the database is in `$DB_HOST` (`db` by default).

A volume `/data/odoo` is declared, which is expected to contain Odoo's filestore
(this path is set in `openerp.cfg`).

Ports 8069 and 8072 are exposed by default.

## Environment variables

### ODOO_BASE_URL

The `ir.config_parameter` `web.base.url` will be automatically set to this
domain when the container starts. `web.base.url.freeze` will be set to `True`.
Default url is `http://localhost:8069`. If `ODOO_BASE_URL` is set to an empty
value, the configuration parameters will be left unchanged.

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

By default, the user ID inside of the container will be 9001. There is little
concern with this ID until we setup a host volume: the same user ID will be
used to write the files on the host's filesystem. 9001 will probably be
inexistent on the host system but at least it will not collide with an actual
user.

Instead, you can set the ID of the host's system in `LOCAL_USER_ID`, which will
then be shared by the container. All the files created in host volumes will
then share the same user.

### CREATE_DB_CACHE

Used in `bin/runtests` and `bin/runmigration`.

If set to "true", will create a dump in `.cachedb` of an intermediate state of the tests or migration.
By default not set, thus unactivated.

### LOAD_DB_CACHE

Used in `bin/runtests` and `bin/runmigration`.

If set to "false", will skip trying to reload a cached dump from `.cachedb`.

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

For instance you have made a dump 10.1.0, you are now on the version
10.2.0, if you pass your current version it will search for a dump
lower than 10.2.0 and restore the 10.1.0. Then play the remaining
steps on top of it.

### Odoo Configuration Options

The main configuration options of Odoo can be configured through environment variables. The name of the environment variables are the same of the options but uppercased (eg. `workers` becomes `WORKERS`).

Look in [11.0/templates/odoo.cfg.tmpl](11.0/templates/odoo.cfg.tmpl) to see the full list.

While most of the variables can be set in the docker-compose file so we can have different values for different environments, the `ADDONS_PATH` **must** be set in the `Dockerfile` of your project with a line such as:

```
ENV ADDONS_PATH=/odoo/local-src,/odoo/external-src/server-tools,/odoo/src/addons
```

By setting this value in the `Dockerfile`, it will be integrated into the build and thus will be consistent across each environment.

By the way, you can add other `ENV` variables in your project's `Dockerfile` if you want to customize the default values of some variables for a project.


## Running tests

### runtests

Inside the container, a script `runtests` is used for running the tests on Travis.

Unless `LOAD_DB_CACHE is set to `false` it will search for a dump of dependencies and restore it.
Otherwise, will create a new database, find the `odoo/external-src` and `odoo/src` dependencies of the local addons and
if `CREATE_DB_CACHE` is activated creates a dump of that state.

Then it will install local addons, run their tests and show the code coverage.

```
docker-compose run --rm [-e CREATE_DB_CACHE=true] [-e LOAD_DB_CACHE=false] [-e SUBS_MD5=<hash>] odoo runtests
```


This is not the day-to-day tool for running the tests as a developer.

### pytests

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

### runmigration

Inside the container, a script `runmigration` is used to run the migration steps on Travis.

Then when launched, it will search for database dump of the content of `odoo/VERSION` file.
Or if you provided `MIG_LOAD_VERSION_CEIL` which will allow you to search for an other version.
If no dump is available (or `LOAD_DB_CACHE` is set to `false`), migration will start from scratch.

The migration steps are then run.

If migration succeed a dump is created if `CREATE_DB_CACHE` is set to `true`.

```
docker-compose run --rm [-e CREATE_DB_CACHE=true] [-e LOAD_DB_CACHE=false] [-e MIG_LOAD_VERSION_CEIL=x.y.z] odoo runmigration
```

This tools really speed up the process of testing migration steps as you can be executing only a single step instead of redoing all.

### cached dumps (runtests / runmigration)

To use database dumps you will need a volume on `/.cachedb` to have persistant dumps.

On travis you will also want to activate the cache, if your volume definition is `- "$HOME/.cachedb:/.cachedb"`
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
must take that in account when writing them. Usually you'll want to use such
check:

```
  if [ "$( psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" )" != '1' ]
  then
      echo "Database does not exist, ignoring script"
      exit 0
  fi
```

The scripts are run only if the command is `odoo`/`odoo.py`.
