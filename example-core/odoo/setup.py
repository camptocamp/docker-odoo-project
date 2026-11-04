from setuptools import setup, find_packages

with open('VERSION') as fd:
    version = fd.read().strip()

setup(
    name="my-project-name",
    version=version,
    description="project description",
    license='AGPL-3.0-or-later',
    author="Author...",
    author_email="email...",
    url="url...",
    packages=['songs'] + ['songs.%s' % p for p in find_packages('./songs')],
    include_package_data=True,
    classifiers=[
        'Development Status :: 4 - Beta',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.12',
        'Programming Language :: Python :: Implementation :: CPython',
    ],
)
