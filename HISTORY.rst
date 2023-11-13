.. :changelog:

.. Template:

.. 0.0.1 (2016-05-09)
.. ++++++++++++++++++

.. **Features and Improvements**

.. **Bugfixes**

.. **Libraries**

.. **Build**

* Change PostgreSQL deb repo to 'apt-archive' for debian stretch based images

.. **Documentation**

Release History
---------------

5.1.0.0.0 (2023-11-13)
++++++++++++++++++++++

**Features and Improvements**

* 17.0 version 
* Switch to github action
* Image pushed to github repository
  

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.1.0 (2023-11-13) move to 5.1.0.0.0
++++++++++++++++++++++++++++++++++++

**Features and Improvements**

* Image pushed to github repository
  

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.8 (2023-09-12)
++++++++++++++++++

**Features and Improvements**

**Bugfixes**

* Remove pip install of src

**Libraries**

**Build**

**Documentation**

5.0.7 (2023-06-07)
++++++++++++++++++

**Features and Improvements**

**Bugfixes**

* Fix entrypoint path for odoo

**Libraries**

**Build**

**Documentation**
5.0.6 (2023-04-28)
++++++++++++++++++

**Features and Improvements**

* Switch to buster for version 11.0 

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.5 (2022-12-05)
++++++++++++++++++

**Features and Improvements**

* Fix package version for all versions 

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.4 (2022-11-23)
++++++++++++++++++

**Features and Improvements**

* Fix for V16 pypi

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.3 (2022-09-01)
++++++++++++++++++

**Features and Improvements**

* Fix coverage 

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.2 (2022-08-31)
++++++++++++++++++

**Features and Improvements**

* Fix path in instance dependencies 

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.1 (2022-08-30)
++++++++++++++++++

**Features and Improvements**

* Fix makefile tag 

**Bugfixes**

**Libraries**

**Build**

**Documentation**

5.0.0 (2022-08-30)
++++++++++++++++++

**Features and Improvements**

* Remove old version (python 2.7) 7.0/8.0/9.0/10.0
* Remove Gosu.sh
* Run container with odoo user

**Bugfixes**

**Libraries**

**Build**

**Documentation**

4.4.5 (2022-08-29)
++++++++++++++++++

**Features and Improvements**

* Add +x on start-entrypoint.d/001_set_report_url (#192)

**Bugfixes**

* Pin certifi library for Odoo<=10.0 to avoid python compatibility issue

**Libraries**

**Build**

**Documentation**


4.4.4 (2022-05-23)
++++++++++++++++++

**Features and Improvements**

* Set PostgreSQL application name using hostname

**Bugfixes**

* Fix args unpacking in docker-entrypoint.sh
* Replace deprecated URL in requirements.txt for V15
* Pin contextlib2 requirement for Odoo <= V10
* Add kwkhtmltopdf in test composition to avoid issues when testing reports

**Libraries**

**Build**

**Documentation**

4.4.3 (2022-03-04)
++++++++++++++++++

**Features and Improvements**

**Bugfixes**

* Fix reportlab version for label 

**Libraries**

**Build**

**Documentation**

4.4.2 (2022-03-01)
++++++++++++++++++

**Features and Improvements**

**Bugfixes**

* Fix python3 for version 15 

**Libraries**

**Build**

**Documentation**

4.4.1 (2022-02-16)
++++++++++++++++++

**Features and Improvements**

**Bugfixes**

* Fix execute flag wkhtmltopdf 

**Libraries**

**Build**

**Documentation**

4.4.0 (2022-02-05)
++++++++++++++++++

**Features and Improvements**

* Use kwkhtmltopdf server instead of wkhtmltopdf binary for reporting

**Bugfixes**

* Fix lab entry point

**Libraries**

**Build**

**Documentation**


4.3.0 (2021-12-02)
++++++++++++++++++

**Features and Improvements**

* Update marabunta to 0.10.6

**Bugfixes**

* [15.0] Fix bullseye src repo for postgresql
* [*] Fix error NO_PUBKEY for postgres packages
* [15.0] Fix python-dev version to use 3.9 as it is the default python version on bullseye
* [15.0] Change bin/list_dependencies.py script to use `python3` instead of `python` as the latest does not exist on bullseye

**Libraries**

* [13.0-15.0] Remove python2 package python-libxslt1
* [11.0-14.0] Remove obsolete feedparser package
* [11.0-15.0] Fix setuptools for compat with 2to3 still in used in pinned dependencies
* [12.0-15.0] Get proper wkhtml version for >= buster releases (includes bullseye)
* [15.0] zeep replaces suds-jurko
* [9.0,10.0] pin libraries that dropped python2.7 support (pytest-cov, watchdog and ruamel.yaml.clib)
* [15.0] upgrade extra dep cffi to 1.15.0
* [13.0-15.0] Bump Pillow, urllib3 and requests to fix potential security issues
* [14.0,15.0] Upgrade to same Psycopg2 and Jinja2 versions
* [15.0] Bump lxml to version 4.6.3
* [14.0] Bump reportlab version to fix printing qr code

**Build**

* Add new version for Odoo 15.0
* [15.0] Need docker-ce 20 instead of docker-ce 18 for building Odoo 15 on debian:bullseye
* Publish images on ghcr.io

**Documentation**

* Document change to ghcr.io


4.2.1 (2021-05-10)
++++++++++++++++++

**Bugfixes**

* switch apt url for PostgreSQL to apt-archive for jessie-based images
    see https://www.postgresql.org/message-id/YBMtd6nRuXyU2zS4%40msg.df7cb.de


4.2.0 (2021-04-08)
++++++++++++++++++

**Features and Improvements**

* disable pip version checks (required network access, can timeout)
* Bypass migration when using:

    docker-compose run --rm odoo odoo shell [...]
    docker-compose run --rm odoo odoo [...] --help [...]

**Bugfixes**

* [<= 10.0] Fix pytest version to 4.6, last supported version in Python 2.7
* Fix dbfilter in test environment

**Libraries**

* Update Marabunta to 0.10.5
* [14.0] Downgrade `urllib3` to a compatible version with Odoo supported `requests` version.
* [>= 12.0] Remove `odoo-autodiscover` as it's not necessary since Odoo 12.0.
* [11.0,12.0] Pin `watchdog` to Py3.5 compatible versions
* [>= 10.0] Bump odoo requirements
  * Bump jinja2 to fix security issue
  * Bump lxml to fix security issue
  * Bump Pillow to fix security issue
  * Bump PyYAML to fix security issue
* [<= 10.0] Pin `pip` to last Py2 compatible version
* [<= 10.0] Pin `watchdog` to last Py2 compatible version
* [<= 10.0] Pin `ruamel.yaml` to last Py2 compatible version
* [<= 10.0] Pin `importlib-metadata` to last Py2 compatible version
* [<= 10.0] Pin `zipp` to last Py2 compatible version

**Build**

* Add new version for Odoo 14.0
* Add new 12.0 flavor based on debian:buster

**Documentation**

* pytest-cov documentation


4.1.0 (2020-05-05)
++++++++++++++++++

**Features and Improvements**

* Add support for socket connection to PostgreSQL

**Bugfixes**

* Pin `setuptools<45` and other dependencies to ensure Python 2 support in Odoo<=10
* Fix deprecated download links for wkhtmltopdf
* Include `.coveragerc` for all versions
* Fix PostgreSQL package installation in v13

**Libraries**

* Bump `psutil` version to 5.7.0
* Bump `Pillow` version to 6.2.2 (v9-13)
* Bump various libraries in v13 to match Odoo's requirements


4.0.0 (2019-12-23)
++++++++++++++++++

**Features and Improvements**

* Add support for additional Odoo configuration parameters with environment variable `ADDITIONAL_ODOO_RC`

**Bugfixes**

* Use user `odoo` instead of `root` when running tests and coverage
  **! Warning !** Because of this change, the file previously `/.coverage` is now in `/home/odoo/.coverage`

**Libraries**

* Bump `Jinja2` version to 2.10.1
* Bump `urllib3` version to 1.24.2
* Bump `wkhtmltopdf` version to 0.12.5.1 (for odoo 12 only)
* Bump `werkzeug` version to 0.16.0 (v9-13)
* Bump `werkzeug` version to 0.9.6 (v7-8)
* Bump various libraries to get rid of security alerts (v7+8 only)
* Bump `Pillow` version to 6.2.0 (v9-13)
* Bump `Pillow` version to 3.4.2 (v7-8)
* Bump `anthem` version to 0.13.0

**Build**

* Add images for versions 7 & 8 (check Legacy Images section in documentation)


3.1.2 (2019-03-27)
++++++++++++++++++

.. DANGER:: Breaking changes

      Marabunta:
      * `install_command` and `install_args` options are now all merged into `install_command`
      Please update your migration.yml and docker-compose files accordingly.
      See https://github.com/camptocamp/marabunta/blob/master/HISTORY.rst#0100-2018-11-06
      for more information

**Libraries**

* Update marabunta to have fixed marabunta_serie

**Build**

* Pin PyYAML to 4.2b4
* Unpin pip on all images


3.1.1 (2019-01-09)
++++++++++++++++++

**Bugfixes**

* Remove the NO_DATABASE_LIST option, does not exist, the sole option is DB_LIST

**Libraries**

* Bump `requests` version
* Remove duplicated `magento` dependency
* Bump `PyYAML` version for CVE-2017-18342
* Remove bad copy of extra_requirements in Dockerfile

  * Must be done only in batteries flavor (see Dockerfile-batteries)


3.1.0 (2018-10-19)
++++++++++++++++++

**Features and Improvements**

* Launch tests only once

**Bugfixes**

* Fix Travis build, batteries overriding normal build
* Fix broken build chain
* Fix BEFORE_MIGRATE_ENTRYPOINT_DIR & START_ENTRYPOINT_DIR to remove /odoo

**Libraries**

* Adapt requirements for system and python 3.5
* Bump paramiko version
* Unfreeze pluggy version

**Build**

* Change latest docker tag to 11.0
* Use setup version for marabunta in example
* Add coveragerc in working directory

**Support of 12.0**

* Copy settings from 11.0 to 12.0
* Rename package odoo file for odoo v12
* Copy v12 requirements from odoo requirements
* Add version 12.0 in travis.yml
* Temporary fix test waiting Odoo release 12.0
* Remove useless install of pip from github in version 12.0


3.0.0 (2018-09-07)
++++++++++++++++++

.. DANGER:: Breaking changes

      Flavors: you have either to use the ``onbuild`` flavor, either to add the
      ``COPY`` instructions in your projects Dockerfiles.

      Directories have been re-arranged, you must adapt addons-path, volumes or COPY instructions:

      * /opt/odoo/etc/odoo.cfg.tmpl → /templates/odoo.cfg.tmpl
      * /opt/odoo/etc/odoo.cfg → /etc/odoo.cfg
      * /opt/odoo → /odoo
      * /opt/odoo/bin → /odoo-bin
      * /opt/odoo/bin_compat → /odoo-bin-compat (for 9.0)
      * /opt/odoo/before-migrate-entrypoint.d → /before-migrate-entrypoint.d
      * /opt/odoo/start-entrypoint.d → /start-entrypoint.d

      Marabunta:

      * 1st version is now "setup"
      * Support of 5 digits versions (11.0.1.2.3), consistent with Odoo addons
      See
      https://github.com/camptocamp/marabunta/blob/master/HISTORY.rst#090-2018-09-04
      for more information


**Features and Improvements**

* Refactor code to be able to share code between versions (see common and bin directories)
* Introduce Flavors of the image:

  * normal image without "onbuild"
  * normal image with "onbuild" instructions
  * batteries-included image without "onbuild"
  * batteries-included with "onbuild" instructions

* Batteries-included flavor includes a selected list of python packages commonly used in OCA addons (see extra_requirements.txt)
* Do not use the "latest" image, pick your flavor after you read the readme
* Python build package are now available in the variable $BUILD_PACKAGE
* New script to install and remove all build package (see install/dev_package.sh and install/purge_dev_package_and_cache.sh) from $BUILD_PACKAGE
* Change directory organisation. Move /opt/odoo/etc => /opt/etc, /opt/odoo/bin => /opt/bin. So now you can mount the whole odoo directory from your dev environment (instead of directory by directory)
* Adapt example with the previous change
* Helpers for running tests on cached databases / preinstalled addons

**Libraries**

* Update marabunta to 0.9.0 (https://github.com/camptocamp/marabunta/blob/master/HISTORY.rst#090-2018-09-04)
* Update `cryptography` dependency to a newer version as security vulnerability was found in the one we used


2.7.0 (2018-07-27)
++++++++++++++++++

This is the last release before 3.0.0, which will provide different flavors
if the image, without onbuild instructions, with onbuild and full.

**Features and Improvements**

* Allow to set the odoo's unaccent option with the environment variable UNACCENT
  in order to use the PostgreSQL extension 'unaccent'
* ``ODOO_REPORT_URL`` is now ``http://localhost:8069`` by default

**Bugfixes**

* Fix error with python3/pip (ImportError: cannot import name 'main')

**Libraries**

* Upgrade python libs; either to the version in odoo's requirements.txt, either
  to a more recent version if there is no breaking change. It should fix a few
  potential security issues.


2.6.1 (2018-03-29)
++++++++++++++++++

**Bugfixes**

* Fix permission issue when running 'runtests' if odoo-bin has no executable flag


2.6.0 (2018-03-29)
++++++++++++++++++

**Features and Improvements**

* Add Script to set report.url if provided.
* The http_proxy environment variable will be honored by 'gpg' when reaching the
  key for the gosu key.
* With the new version of anthem, CSV files can be loaded from a relative path
  (starting from /opt/odoo/data): https://github.com/camptocamp/anthem/pull/36
* The runtests script shows the coverage at the end

**Build**

* Upgrade setuptools, otherwise the pip installs fail with
  NameError: name 'platform_system' is not defined
* Disable pip cache directory to reduce image size

**Libraries**

* Upgrade six to 1.10.0
* Upgrade ``anthem`` to 0.11.0 in every odoo version
* Upgrade ``marabunta`` to 0.8.0 in every odoo version
* Install the ``phonenumbers`` library for odoo 11.0


2.5.1 (2018-01-11)
++++++++++++++++++

**Build**

* Reduce size of the 11.0 image by cleaning and optimizing layers

2.5.0 (2018-01-11)
++++++++++++++++++

**Features and Improvements**

* Add an Odoo 11.0 image version. Which required upgrading dependencies to
  Python 3 for this image.

**Libraries**

* Upgrade pip to the development version, to prevent unnecessary upgrades of libs
* Upgrade ``anthem`` to 0.11.0
* Upgrade ``marabunta`` to 0.8.0

**Build**

* Upgrade gosu to 1.10
* Upgrade dockerize to 0.6.0 and run a checksum


2.4.1 (2017-11-01)
++++++++++++++++++

**Libraries**

* Upgrade ``marabunta`` to 0.7.3, includes a bugfix for postgresql passwords
  with special chars


2.4.0 (2017-09-20)
++++++++++++++++++

**Features and Improvements**

* A maintenance page is published on the same port than Odoo (8069) during the
  marabunta migration (need anthem >= 0.10.0 and marabunta >= 0.7.2)
* Support installation of Odoo addons packaged as Python wheels

**Bugfixes**

* The ``start-entrypoint./000_base_url`` script might fail when we don't run
  marabunta migration and the database does not exist, the script is now
  ignored in such case.

**Libraries**

* Upgrade ``anthem`` to 0.10.0
* Upgrade ``marabunta`` to 0.7.2, includes a maintenance page during the upgrade!
* Add ``odoo-autodiscover>=2.0.0b1`` to support Odoo addons packaged as wheels
* Upgrade ``psycopg2`` to 2.7.3.1 with several bugfixes notably "Fixed
  inconsistent state in externally closed connections" in
  http://initd.org/psycopg/articles/2017/07/22/psycopg-272-released/


2.3.0 (2017-07-05)
++++++++++++++++++

**Features and Improvements**

* Remove ``DOMAIN_NAME`` environment variable. Only ``ODOO_BASE_URL`` is now used.
* Set a default value for ``ODOO_BASE_URL`` to ``http://localhost:8069``.

**Libraries**

* Add ``ofxparse`` as found in odoo's requirements
* Upgrade ``psycopg2`` to 2.7.1
* Add ``pytest-cov`` for tests
* PyChart is no longer installed from gna.org (down) but from pypi


2.2.0 (2017-05-18)
++++++++++++++++++

**Features and Improvements**

* Upgrade postgres-client to 9.6
* Add before-migrate-entrypoint.d, same principle than the start-entrypoint.d
  but run before the migration


2.1.1 (2017-05-04)
++++++++++++++++++

**Bugfixes**

* Remove a remaining occurence of hardcoded 'db' host in the start-entrypoint
  that set the base URL.


2.1.0 (2017-04-28)
++++++++++++++++++

**Features and Improvements**

* Possibility to change the hostname for database with ``$DB_HOST`` (default is ``db``)
* Set the ``list_db`` option to ``False`` by default.  This option can be
  unsafe and there is no reason to activate it as the image is designed to run
  on one database by default.
* New option in configuration file replacing ``--load``: ``server_wide_modules`` can
  be configured with the environment variable ``SERVER_WIDE_MODULES``

**Libraries**

* Upgrade ``anthem`` to 0.7.0
* Upgrade ``dockerize`` to 0.4.0
* Add ``html2text`` (used in ``mail`` module)
* Add ``odfpy`` and ``xlrd`` for xls/xlsx/ods imports


2.0.0 (2016-12-22)
++++++++++++++++++

**Warning**

This release might break compatibility with the images using it, it needs some
little modifications in their ``Dockerfile``.
The Workdir of the container will be ``/opt`` instead of ``/opt/odoo``.
The reason is that it allows a more natural transition between the project from
the outside of the container and from the inside. Meaning, if we run the following command:

::

  docker-compose run --rm -e DB_NAME=dbtest odoo pytest -s odoo/local-src/my_addon/tests/test_feature.py::TestFeature::test_it_passes

The path ``odoo/local-src...`` is the path you see in your local project (with auto-completion),
but it is valid from inside the container too.

The implication is that the projects' Dockerfile need to be adapted, for instance:

::

  COPY ./requirements.txt ./
  RUN pip install -r requirements.txt
  COPY ./importer.sh bin/

becomes:

::

  COPY ./requirements.txt /opt/odoo/
  RUN cd /opt/odoo && pip install -r requirements.txt

  COPY ./importer.sh /opt/odoo/bin/


**Features and Improvements**

* Include pytest
* Add testdb-gen, command that generates a test database to be used with pytest
* Add testdb-update, command to update the addons of a database created with testdb-gen
* 'chown' is executed on the volumes only if the user is different, should make the boot faster
* 'chown' is executed for any command, not only when starting odoo, needed to run testdb-gen
* Customizable ``web.base.url`` with environment variables ``ODOO_BASE_URL`` or
  ``DOMAIN_NAME``
* Allow to run custom scripts between ``migrate`` and the execution of
  ``odoo``, by placing them in ``/opt/odoo/start-entrypoint.d`` (respecting
  ``run-parts`` naming rules)

**Libraries**

* Upgrade marabunta to 0.6.3 (https://github.com/camptocamp/marabunta/releases/tag/0.6.3)


1.7.1 (2016-11-25)
++++++++++++++++++

Important bugfix in marabunta! The changes in the ``marabunta_version`` were
never committed, so migration would run again.

**Libraries**

* Upgrade Marabunta to 0.6.1


1.7.0 (2016-11-21)
++++++++++++++++++

**Features and Improvements**

* Export PG* environment variables for convenience, so in a shell we can connect
  on the current database with:

  ``docker-compose run --rm odoo psql -l``

  And in Marabunta steps we can execute SQL files with:

  ``psql -f path/to/file.sql``

  Instead of:

  ``sh -c 'PGPASSWORD=$DB_PASSWORD psql -h db -U $DB_USER -f path/to/file.sql $DB_NAME'``

* Use unbuffer when calling marabunta, to have the output line by line

**Bugfixes**

* Change 'pip list' invocation to remove a deprecation warning

**Libraries**

* Upgrade marabunta to 0.6.0 (https://github.com/camptocamp/marabunta/releases/tag/0.6.0)


1.6.2 (2016-10-26)
++++++++++++++++++

**Bugfixes**

* Set default command to 'odoo' for 9.0 as well
* Run migration if the command is odoo.py too

**Libraries**

* Upgrade marabunta to 0.5.1

1.6.1 (2016-10-24)
++++++++++++++++++

**Bugfixes**

* ``runtests`` was calling the wrong path for ``odoo`` in 9.0 version

**Build**

* Tests on Travis call ``runtests`` during the build to ensure the script works
  as expected


1.6.0 (2016-10-12)
++++++++++++++++++

**New Odoo 10.0 image**

Now, images for Odoo 10.0 and 9.0 are generated.
The versioning is still the same, note that 9.0 and 10.0 share the final
part of their version:

- ``camptocamp/odoo-project:9.0-latest``
- ``camptocamp/odoo-project:9.0-1.6.0``
- ``camptocamp/odoo-project:10.0-latest``
- ``camptocamp/odoo-project:10.0-1.6.0``

Images are no longer built on hub.docker.com but tested on Travis and pushed
when the test is green.
The test consists of the example project being built and Odoo started.

Images should be built using ``make`` now. The ``bin`` folder at the root of the
repository is copied into the folders before the builds, so it is common to
both versions.

**Changes in the Odoo 9.0 image**

A new command ``odoo`` has been added in the path and ``exec``-utes ``odoo.py``.
This is to ensure the compatibility of the various scripts as ``odoo.py`` has
been renamed to ``odoo`` in Odoo 10.0.

**Libraries**

* Anthem upgraded to 0.5.0 (Odoo 10.0 support)
* Marabunta upgraded to 0.5.0 (Odoo 10.0 support)
* XlsxWriter added in 9.0 as it becomes required in Odoo 10.0 and required for
  the OCA QWeb accounting reports


1.5.0 (2016-09-28)
++++++++++++++++++

**Possibly breaking change**

* Now the default user id for the filestore will be 999 instead of 9001.  It
  should not be problematic in most cases because the volumes are `chown`-ed in
  the entrypoint. But you have to be cautious if you have interactions with
  host volumes or other containers.


1.4.0 (2016-09-23)
++++++++++++++++++

**Features and Improvements**

* Add a 'lint' command that calls flake8 on the local sources

**Bugfixes**

* Make the database user own the created database

**Libraries**

* Upgrade requests to 2.6.0 (same version defined in odoo's requirements.txt)

1.3.0 (2016-08-19)
++++++++++++++++++

**Bugfixes**

* Create /data/odoo{addons,filestore,sessions} folders at container's start,
  which sometimes prevent Odoo to start at the first boot

**Libraries**

* Upgrade to Marabunta 0.4.2 (https://github.com/camptocamp/marabunta/releases/tag/0.4.2)
* Upgrade to Anthem 0.4.0 (https://github.com/camptocamp/anthem/releases/tag/0.4.0)

1.2.1 (2016-07-27)
++++++++++++++++++

**Libraries**

* Upgrade to Marabunta 0.4.1 (https://github.com/camptocamp/marabunta/releases/tag/0.4.1)

1.2.0 (2016-07-26)
++++++++++++++++++

**Libraries**

* Upgrade to Marabunta 0.4.0 (https://github.com/camptocamp/marabunta/releases/tag/0.4.0)
* Upgrade to Anthem 0.3.0 (https://github.com/camptocamp/anthem/releases/tag/0.3.0)

1.1.0 (2016-07-22)
++++++++++++++++++

**Features and Improvements**

* Add environment variable `MIGRATE` which allow to disable migration when
  launching the container.

**Libraries**

* Upgrade to Anthem 0.2.0

1.0.3 (2016-07-13)
++++++++++++++++++

**Fixes**

* Fix error ``pkg_resources.DistributionNotFound: odoo==9.0c`` happening at the
  start of the container when we use a host volume for the odoo's src.

1.0.2 (2016-07-12)
++++++++++++++++++

**Fixes**

* Fix ``DEMO=True`` wrongly displaying "Running without demo data" instead of
  "with" (but the demo data was loaded)
* Upgrade to Marabunta 0.3.3 which resolves an unicode encode error on output

1.0.1 (2016-07-08)
++++++++++++++++++

* Upgrade to Marabunta 0.3.2

1.0.0 (2016-07-08)
++++++++++++++++++

The docker image for Odoo 9.0 is `camptocamp/odoo-project:9.0-1.0.0`

This release is not backward compatible, it drops ``oerpscenario``.

**Changes**

* Drop ``oerpscenario`` which will no longer maintained.
* ``marabunta`` (https://github.com/camptocamp/marabunta) is now called on
  startup to automatically apply the migrations scripts for new versions.
* ``anthem`` (https://github.com/camptocamp/anthem) is added to write the
  migration scripts.
* The ``odoo`` directory is now a (local) Python package, so we can use
  ``pkg_resources`` to find files.
* Python packages are now installed from ``pip`` instead of Debian packages
* ``pip install -e src`` is called to install Odoo, so ``odoo.py`` and ``import
  openerp`` are widely available without having to resort on ``PATH``
  modifications.
* The ``DEMO`` environment variable now only accepts ``True`` or ``False``,
  loading demo data from scenario (anthem songs) should be done using
  ``MARABUNTA_MODE=<mode>``.  It allows to have an unlimited number of
  different scenario (demo, light, full, or whatever)
* ``SCENARIO_MAIN_TAG`` has no effect

**Instructions for migration of your project**

New files / directory to add in the ``odoo`` directory:

* Directory ``songs/``, which is used to store the ``anthem`` songs (upgrade scripts)
* File ``setup.py``, used to make a Python package from the project's
  directory, allowing to find data and songs for the migrations

  ::

    # -*- coding: utf-8 -*-

    from setuptools import setup, find_packages

    with open('VERSION') as fd:
        version = fd.read().strip()

    setup(
        name="project-name",
        version=version,
        description="project description",
        license='GNU Affero General Public License v3 or later (AGPLv3+)',
        author="Author...",
        author_email="email...",
        url="url...",
        packages=['songs'] + ['songs.%s' % p for p in find_packages('./songs')],
        include_package_data=True,
        classifiers=[
            'Development Status :: 4 - Beta',
            'License :: OSI Approved',
            'License :: OSI Approved :: '
            'GNU Affero General Public License v3 or later (AGPLv3+)',
            'Programming Language :: Python',
            'Programming Language :: Python :: 2',
            'Programming Language :: Python :: 2.7',
            'Programming Language :: Python :: Implementation :: CPython',
        ],
    )

* ``VERSION`` contains the current version number, such as ``9.1.0``.

* ``migration.yml`` is the ``marabunta``'s manifest file, example:

  ::

    migration:
      options:
        install_command: odoo.py
      versions:
        - version: 9.0.0
          operations:
            pre:
              - "sh -c 'PGPASSWORD=$DB_PASSWORD psql -h db -U $DB_USER -c \"CREATE EXTENSION pg_trgm;" $DB_NAME'"
            post:
              - anthem songs.install.base::main
          addons:
            upgrade:
              - sale
              - document
        - version: 9.1.0
          addons:
            upgrade:
             - stock


* If you use ``DEMO=odoo``, you should replace it with ``DEMO=True``
* If you use ``DEMO=scenario``, you should remove the variable and use
  ``MARABUNTA_MODE=demo``
* If you use ``DEMO=all``, you should replace it with ``DEMO=True`` and add
  ``MARABUNTA_MODE=demo``

* If you use ``oerpscenario`` in your project, you should plan to replace it by
  ``anthem``. In the meantime, you need to add it in your project:

  ::

    $ git submodule add https://github.com/camptocamp/oerpscenario.git odoo/oerpscenario
    $ mkdir -p odoo/bin
    $ wget https://raw.githubusercontent.com/camptocamp/docker-odoo-project/c9a2afcf8152e5323cc49c919443602c54c839fd/9.0/bin/oerpscenario -O odoo/bin/oerpscenario
    $ chmod +x odoo/bin/oerpscenario


  And in your local Dockerfile, add the following lines:

  ::

    COPY oerpscenario /opt/odoo/oerpscenario
    COPY bin/oerpscenario /opt/odoo/bin/oerpscenario


  Then, add call to ``oerpscenario`` in the ``marabunta``'s ``migration.yml`` operations.

  ::

    migration:
      versions:
        - version: 9.0.0
          operations:
            post:
              - oerpscenario -t my-project-tag

9.0
+++

Initial release of the Docker Odoo Project image.
