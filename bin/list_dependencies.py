#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Provide a list of module which are dependencies
# of local-src modules excluding local-src modules
#
# Arguments:
#  list of module (coma separated), restrict list of
#  dependencies to the dependencies of this list.
#
# Usage:
#   ./odoo/bin/list_dependencies.py local_module1,local_module2
import sys
import os
import ast

BASE_DIR = os.getcwd()
LOCAL_SRC_DIR = os.path.join(BASE_DIR, 'odoo', 'local-src')

dependencies = set()
local_modules = os.listdir(LOCAL_SRC_DIR)
if len(sys.argv) > 1:
    modules = sys.argv[1].split(',')
else:
    modules = local_modules
for mod in modules:
    # read __manifest__
    manifest_path = os.path.join(LOCAL_SRC_DIR, mod, '__manifest__.py')
    if not os.path.isfile(manifest_path):
        continue
    with open(manifest_path) as manifest:
        data = ast.literal_eval(manifest.read())
    dependencies.update(data['depends'])

# remove local-src from list of dependencies
dependencies = dependencies.difference(local_modules)
print(','.join(dependencies) or 'base')
