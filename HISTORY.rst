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

**Features and Improvements**

**Bugfixes**

**Libraries**

**Build**

**Documentation**

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
