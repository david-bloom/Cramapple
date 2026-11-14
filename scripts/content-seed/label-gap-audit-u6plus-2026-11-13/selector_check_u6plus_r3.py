#!/usr/bin/env python3
"""Stage 5 (read-only): call the LIVE `public.select_student_practice_items` for every newly labeled item (rounds 1 and 2) with its own topic and
confirm it is returned with topic_match = true; plus a sample of previously served items per subject. Uses a random user id (no attempts).
The selector is called, not modelled."""
import importlib.util, json, os, glob, uuid, collections as C
HERE = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('pmb', os.path.join(HERE, '..', 'publish_mcq_batch.py')); pmb = importlib.util.module_from_spec(spec); spec.loader.exec_module(pmb)
REF = pmb.ENVS['prod']; USER = str(uuid.uuid4())
epv = {}
for f in glob.glob(os.path.join(HERE, 'raw', 'ap_*.json')):
    for r in json.load(open(f)): epv[r['content_key']] = r['epv']
rows = [dict(r, rnd=rn) for rn, pat in (('u6', 'stage5v/load/load_*.json'),) for f in glob.glob(os.path.join(HERE, pat)) for r in json.load(open(f))]
allowed = {r['exam_pack_version_id']: max(r['allowed_unit_numbers']) for r in pmb.query(REF, 'select exam_pack_version_id::text, allowed_unit_numbers from app.home_release_manifest')}
groups = C.defaultdict(list)
for r in rows: groups[(epv[r['content_key']], r['topic'], r['item_type'])].append(r)
found, topic_ok, missing, errs = 0, 0, [], 0
for (e, t, ty), rs in groups.items():
    want = {r['content_key'] for r in rs}; got = {}; off = 0
    for _ in range(40):
        try: page = pmb.query(REF, f"select content_key, topic_match from public.select_student_practice_items('{e}'::uuid, {allowed[e]}, '{USER}'::uuid, null, '{ty}', '{t}', 51, {off})")
        except Exception as ex: errs += 1; print('ERR', e, t, ty, str(ex)[:150]); break
        for p in page: got[p['content_key']] = p['topic_match']
        off += 51
        if len(page) < 51 or want <= set(got): break
    for k in want:
        if k in got: found += 1; topic_ok += bool(got[k])
        else: missing.append(k)
print(f'newly labeled items {len(rows)} in {len(groups)} topic/type groups: returned {found}, returned with topic_match=true {topic_ok}, not returned {len(missing)}, query errors {errs}')
print('not returned:', missing[:40])
# regression sample: in-scope items fully served BEFORE (validated cell + fresh validated label per Stage 1 export), 6 per subject
import random; random.seed(20261113)
d = json.load(open(os.path.join(HERE, 'gap_items_u6plus.json'))); new = {r['content_key'] for r in rows}
cells = {}
for sub in {i['subject'] for i in d['items']}:
    for r in json.load(open(os.path.join(HERE, 'raw', sub + '.json'))):
        pc = [c['t'] for c in r['cells'] if c['p'] and c['st'] == 'validated' and not c['s']]
        if pc: cells[r['content_key']] = pc[0]
base = [i for i in d['items'] if i['in_scope'] and i['f']['topic_validated'] and i['f']['serving'] == 'ok' and i['content_key'] not in new]
bysub = C.defaultdict(list)
for i in base: bysub[i['subject']].append(i)
rg = [i for s_, v in bysub.items() for i in random.sample(v, min(6, len(v)))]
rfound = rtm = 0; rmiss = []
for i in rg:
    k = i['content_key']; e = epv[k]; t = cells[k]; got = {}; off = 0
    for _ in range(40):
        page = pmb.query(REF, f"select content_key, topic_match from public.select_student_practice_items('{e}'::uuid, {allowed[e]}, '{USER}'::uuid, null, '{i['item_type']}', '{t}', 51, {off})")
        for p in page: got[p['content_key']] = p['topic_match']
        off += 51
        if len(page) < 51 or k in got: break
    if k in got: rfound += 1; rtm += bool(got[k])
    else: rmiss.append(k)
print(f'regression sample {len(rg)} previously served items: returned {rfound}, topic_match {rtm}, missing {rmiss}')
json.dump({'returned': found, 'topic_match': topic_ok, 'missing': missing, 'total': len(rows), 'regression': {'n': len(rg), 'returned': rfound, 'topic_match': rtm, 'missing': rmiss}}, open(os.path.join(HERE, 'stage4', 'selector_check_r3.json'), 'w'))
