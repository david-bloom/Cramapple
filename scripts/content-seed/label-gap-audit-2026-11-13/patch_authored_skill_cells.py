#!/usr/bin/env python3
"""Stage 4 prep: 173 AP Statistics legacy items carry an `authored` PRIMARY cell that has a skill_code (topic x skill, e.g. 1.9 x 4.B). Promoting it would
validate a skill, which is out of scope (owner: serving and topic only). The selector already resolves topic through `authored` cells, so those rows keep
their cell (cell_action 'keep_authored', the voted topic must equal the cell's topic) and only receive the serving label."""
import importlib.util, json, os
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
f = os.path.join(HERE, 'stage3', 'load_ap_statistics.json'); L = json.load(open(f))
pr = [r for r in L if r['cell_action'] == 'promote_in_place']
sk = {r['id']: r['s'] for r in pmb.query(pmb.ENVS['prod'], "select content_item_cell_id::text id, skill_code s from app.content_item_cells where content_item_cell_id in (%s)" % ','.join("'%s'" % r['cell_id'] for r in pr))}
n = 0
for r in pr:
    if sk[r['cell_id']] is not None: r['cell_action'] = 'keep_authored'; r['cell_note'] = 'authored topic x skill primary cell retained; skill not validated (out of scope)'; n += 1
json.dump(L, open(f, 'w'), indent=0); print('patched', n, 'of', len(pr), 'promote rows to keep_authored')
