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

latest (unreleased)
+++++++++++++++++++

**Features and Improvements**

* Replace environment variable OPENERP_SERVER with ODOO_RC
* Entrypoint: exit on error when executing run-parts
* Pillow: bump to 12.1.1 (to fix security issues)

**Bugfixes**

**Build**

* Change PostgreSQL deb repo to 'apt-archive' for debian stretch based images

**Documentation**

* Switch project example to Python 3


5.3.0.0.0 (2024-08-26)
++++++++++++++++++++++

**Features and Improvements**

* remove pathtools library, use pathlib instead
* remove 14 buster, use bookworm instead
* use bookwork for all supported versions, specific debian version applied
* bump all packages for 15.0/16.0/17.0
* switch 15.0/16.0/17.0 to python 3.12 on bookworm


5.2.1.0.0 (2024-01-19)
++++++++++++++++++++++

**Features and Improvements**

* add openxlrd library
* remove 11.0 version


5.2.0.0.0 (2024-01-19)
++++++++++++++++++++++

**Features and Improvements**

* add env variable for LOCAL_CODE_PATH and MIGRATION_CONFIG_FILE
* /bin script to remove gosu dependencies
* clean local-src reference
* print DEPS_ADDONS for debugging


5.1.0.0.1 (2023-12-11)
++++++++++++++++++++++

**Bugfixes**

* fix the entrypoint path in the entrypoint script


5.1.0.0.0 (2023-11-13)
++++++++++++++++++++++

**Features and Improvements**

* 17.0 version
* Switch to github action
* Image pushed to github repository


5.1.0 (2023-11-13) move to 5.1.0.0.0
++++++++++++++++++++++++++++++++++++

**Features and Improvements**

* Image pushed to github repository


5.0.8 (2023-09-12)
++++++++++++++++++

**Bugfixes**

* Remove pip install of src


5.0.7 (2023-06-07)
++++++++++++++++++

**Bugfixes**

* Fix entrypoint path for odoo


5.0.6 (2023-04-28)
++++++++++++++++++

**Features and Improvements**

* Switch to buster for version 11.0


5.0.5 (2022-12-05)
++++++++++++++++++

**Features and Improvements**

* Fix package version for all versions


5.0.4 (2022-11-23)
++++++++++++++++++

**Features and Improvements**

* Fix for V16 pypi


5.0.3 (2022-09-01)
++++++++++++++++++

**Features and Improvements**

* Fix coverage


5.0.2 (2022-08-31)
++++++++++++++++++

**Features and Improvements**

* Fix path in instance dependencies


5.0.1 (2022-08-30)
++++++++++++++++++

**Features and Improvements**

* Fix makefile tag


5.0.0 (2022-08-30)
++++++++++++++++++

**Features and Improvements**

* Remove old version (python 2.7) 7.0/8.0/9.0/10.0
* Remove Gosu.sh
* Run container with odoo user


4.x
+++

* Flavor 'core' is a fork of traditional image '4.4.5'.
  See HISTORY.rst in same folder
