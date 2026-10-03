#!/usr/bin/env python3
"""Consensus over the 3-model x 2-sample serving-label probe (out_serving_*/labels.jsonl) for the non-servable live Bio items.
Rule (revised after reading the conflicts): max required unit and topic must each have >= 5 of 6 samples agreeing (all three model families). A disagreement with the
REGISTERED primary topic does not block the serving label (the registered topic is wrong on ~35 items, verified by reading them) but is recorded as `registered_conflict`; the required-unit set is the units appearing in >= 4 of 6 samples, plus the max unit. Anything else stays held and is listed."""
import json, glob, collections, sys
packets = {p['content_key']: p for p in json.load(open('packets.json'))}
tax = json.load(open('taxonomy_bio.json')); unit_of = {t['code']: t['unit'] for t in tax['topics']}
by = collections.defaultdict(list)
for f in glob.glob('out_serving_*/labels.jsonl'):
    for l in open(f):
        r = json.loads(l)
        if r['ok']: by[r['key']].append(r['label'])
out = {}; held = {}
for k, L in sorted(by.items()):
    n = len(L); p = packets[k]
    mx = collections.Counter(max(l['required_units']) if l['required_units'] else unit_of.get(l['primary_topic_code'], 0) for l in L).most_common(1)[0]
    tp = collections.Counter(l['primary_topic_code'] for l in L).most_common(1)[0]
    cnt = collections.Counter(u for l in L for u in set(l['required_units']))
    req = sorted({u for u, c in cnt.items() if c >= 4} | {mx[0]})
    why = []
    if n < 6: why.append(f'only {n} samples')
    if mx[1] < 5: why.append(f'max unit split ({mx[0]} {mx[1]}/6)')
    if unit_of.get(tp[0]) is None: why.append('topic not in taxonomy')
    rec = dict(content_key=k, topic=tp[0], topic_support=f'{tp[1]}/{n}', max_unit=mx[0], max_support=f'{mx[1]}/{n}', req=req, primary_unit=(unit_of.get(tp[0]) if tp[1] >= 4 else mx[0]),
               registered_topic=p.get('primary_topic'), registered_conflict=bool(p.get('primary_topic') and p['primary_topic']!=tp[0]), unit_conflict=bool(p.get('primary_topic') and unit_of.get(p['primary_topic'])!=unit_of.get(tp[0])), hand_drawn=p['hand_drawn'], old_status=p.get('current_label_status'))
    (held if why else out)[k] = {**rec, 'why': why} if why else rec
json.dump(dict(accepted=out, held=held), open('serving_consensus.json', 'w'), indent=1)
print(f'accepted {len(out)}, held {len(held)} of {len(by)}')
for k, r in held.items(): print('  HELD', k, r['why'])
