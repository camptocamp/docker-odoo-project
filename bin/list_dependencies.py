#!/usr/bin/env python3
# Provide a list of module which are dependencies
# of odoo/addons modules excluding odoo/addons modules
#
# Arguments:
#  list of module (coma separated), restrict list of
#  dependencies to the dependencies of this list.
#
# Usage:
#   ./odoo/bin/list_dependencies.py local_module1,local_module2
import ast
import os
import sys

LOCAL_CODE_PATH = os.getenv("LOCAL_CODE_PATH", "/odoo/odoo/addons")

dependencies = set()
local_modules = os.listdir(LOCAL_CODE_PATH)
if len(sys.argv) > 1:
    modules = sys.argv[1].split(",")
else:
    modules = local_modules
for mod in modules:
    # read __manifest__
    manifest_path = os.path.join(LOCAL_CODE_PATH, mod, "__manifest__.py")
    if not os.path.isfile(manifest_path):
        continue
    with open(manifest_path) as manifest:
        data = ast.literal_eval(manifest.read())
    dependencies.update(data["depends"])

# remove local-src from list of dependencies
dependencies = dependencies.difference(local_modules)
print(",".join(dependencies) or "base")
