from setuptools import find_packages, setup

with open('VERSION') as fd:
    version = fd.read().strip()

setup(
    name="odoo-project",
    version=version,
    description="Odoo Project",
    license='GNU Affero General Public License v3 or later (AGPLv3+)',
    author="Camptocamp",
    author_email="info@camptocamp.com",
    url="www.camptocamp.com",
    packages=['songs'] + ['songs.%s' % p for p in find_packages('./songs')],
    include_package_data=True,
    odoo_addons=True,
)
