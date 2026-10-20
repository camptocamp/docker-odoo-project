#!/usr/bin/env python3
# Provide a list of modules which are dependencies
# of local modules excluding local modules themselves
#
# Arguments:
#  list of modules (coma separated), restrict list of
#  dependencies to the dependencies of this list.
#
# Usage:
#   ./odoo/bin/list_dependencies.py local_module1,local_module2
import ast
import os
import pathlib
import sys

CWD = pathlib.Path.cwd()

if path_from_env := os.getenv("LOCAL_CODE_PATH"):
    LOCAL_CODE_PATH = CWD / path_from_env
else:
    LOCAL_CODE_PATH = CWD / "odoo" / "local-src"

dependencies = set()
local_modules = {mod.name for mod in LOCAL_CODE_PATH.iterdir()}

if len(sys.argv) > 1:
    modules = sys.argv[1].split(",")
else:
    modules = local_modules

for mod_name in modules:
    # read __manifest__
    manifest = LOCAL_CODE_PATH / mod_name / "__manifest__.py"
    if manifest.is_file():
        data = ast.literal_eval(manifest.read_text())
        dependencies.update(data["depends"])

# remove local modules from list of dependencies
dependencies = dependencies.difference(local_modules)
print(",".join(sorted(dependencies)) or "base")
