.. :changelog:

.. Template:

.. 0.0.1 (2016-05-09)
.. ++++++++++++++++++

.. **Features and Improvements**

.. **Bugfixes**

.. **Libraries**

.. **Build**

.. **Documentation**

Release History
---------------


Unreleased
++++++++++

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

**Bugfixes**

**Libraries**

**Build**

**Documentation**


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
