import os
import base64
from support import model, assert_equal, assert_true
from dsl_helpers import parse_domain, build_search_domain, parse_table_values


@step('I attach a file "{filepath}" to "{res_model}" oid: {oid}')
def attach_file(ctx, filepath, res_model, oid):
    rec = model(res_model).get(oid)
    assert rec, "xmlid not found for this object"

    tmp_path = ctx.feature.filename.split(os.path.sep)
    tmp_path = tmp_path[:tmp_path.index('features')] + ['data', filepath]
    tmp_path = [str(x) for x in tmp_path]
    path = os.path.join(*tmp_path)
    with open(path, "rb") as f:
        file_data = base64.b64encode(f.read())

    values = {
        'name': os.path.basename(filepath),
        'res_id': rec.id,
        'res_model': res_model,
        'datas': file_data,
    }

    model('ir.attachment').create(values)
