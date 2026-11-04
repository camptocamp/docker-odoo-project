from setuptools import find_packages, setup

with open('VERSION') as fd:
    version = fd.read().strip()

setup(
    name="odoo-project",
    version=version,
    description="Odoo Project",
    license="AGPL-3.0-or-later",
    author="Camptocamp",
    author_email="info@camptocamp.com",
    url="www.camptocamp.com",
    packages=['songs'] + ['songs.%s' % p for p in find_packages('./songs')],
    include_package_data=True,
)
