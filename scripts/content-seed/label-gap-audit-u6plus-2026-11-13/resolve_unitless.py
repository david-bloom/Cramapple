#!/usr/bin/env python3
"""Tally the six-vote probes for the unit-less set (stage8 = 64 vote-only items, stage10 = 11 repaired items).
Accept: topic named by >= 5 of the votes cast (6 when GPT sample 2 ran; otherwise the runner already required >= 3 of 4 cheap + GPT 1), required units named by >= 4 votes.
Writes resolved_unitless.json (accepted) and residue_unitless.json."""
import json, collections as C, os, glob
HERE = os.path.dirname(os.path.abspath(__file__))
acc, res = [], []
for d in ('stage8', 'stage10'):
    tax = {}
    for f in glob.glob(f'{HERE}/{d}/taxonomy_*.json'):
        sub = os.path.basename(f)[9:-5]; tax[sub] = {t['code']: int(t['code'].split('.')[0]) for t in json.load(open(f))['topics']}
    pk = {}
    for f in glob.glob(f'{HERE}/{d}/packets_*.json'):
        sub = os.path.basename(f)[8:-5]
        for p in json.load(open(f)): pk[p['content_key']] = dict(p, sub=sub)
    V = C.defaultdict(list)
    for l in open(f'{HERE}/{d}/votes.jsonl'):
        r = json.loads(l)
        if r['ok']: V[r['key']].append(r)
    for k, p in pk.items():
        vs = V.get(k, []); n = len(vs); t = C.Counter(v['label']['primary_topic_code'] for v in vs); u = C.Counter(x for v in vs for x in set(v['label']['required_units']))
        top, tc = (t.most_common(1) or [(None, 0)])[0]
        row = dict(content_key=k, subject=p['sub'], vid=p['vid'], item_type=p['item_type'], set=d, votes=n, topic_votes=dict(t), unit_votes={str(a): b for a, b in sorted(u.items())})
        if n < 4 or tc < 5 or top not in tax[p['sub']]: row['reason'] = 'no_majority_or_unknown_topic'; res.append(row); continue
        pu = tax[p['sub']][top]; ru = sorted(x for x, c in u.items() if c >= 4)
        if pu not in ru: row['reason'] = f'primary unit {pu} not named by >= 4 votes'; row['topic'] = top; res.append(row); continue
        row.update(topic=top, primary_unit=pu, required_units=ru, max_required_unit=max(ru)); acc.append(row)
json.dump(acc, open(f'{HERE}/resolved_unitless.json', 'w'), indent=1); json.dump(res, open(f'{HERE}/residue_unitless.json', 'w'), indent=1)
print('accepted', len(acc), 'residue', len(res)); print(C.Counter(r['votes'] for r in acc))
for r in res: print('RESIDUE', r['content_key'], r['reason'], r['topic_votes'], r.get('unit_votes'))
