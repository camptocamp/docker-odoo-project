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

**Warning**

Compatibility break:
the Workdir of the container will be ``/opt`` instead of ``/opt/odoo``.
The reason is that it allows a more natural transition between the project from
the outside of the container and from the inside. Meaning, if we run the following command:

::

  docker-compose run --rm -e DB_NAME=dbtest odoo pytest -s odoo/local-src/my_addon/tests/test_feature.py::TestFeature::test_it_passes

The path ``odoo/local-src...`` is the path you see in your project (with auto-completion),
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

**Bugfixes**

**Libraries**

**Build**

**Documentation**


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
