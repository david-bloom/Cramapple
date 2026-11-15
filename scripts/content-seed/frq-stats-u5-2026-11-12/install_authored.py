#!/usr/bin/env python3
"""Install authored seeds (authored/seeds.json) into slots as given items awaiting the paid full check."""
import json, os, datetime, sys
HERE = os.path.dirname(os.path.abspath(__file__))
slots = {s['topic_code']: s for s in json.load(open(os.path.join(HERE, 'inputs', 'slots.json')))}
os.makedirs(os.path.join(HERE, 'slots'), exist_ok=True)
n = 0
for r in json.load(open(os.path.join(HERE, 'authored', sys.argv[1] if len(sys.argv) > 1 else 'seeds.json'))):
    sl = slots[r['topic_code']]; p = os.path.join(HERE, 'slots', f"{r['subject_key']}__{r['topic_code']}__1.json")
    if os.path.exists(p) and json.load(open(p))['status'] == 'accepted': print('skip accepted', p); continue
    old = json.load(open(p)) if os.path.exists(p) else None
    st = {'id': f"{r['subject_key']}__{r['topic_code']}__1", 'slot': sl, 'n': 1, 'status': 'pending_checks', 'candidates': [],
          'given': {'item': r['item'], 'source': 'Claude session author (build_items.py, rubric_patterns.json), 2026-11-12',
                    'at': datetime.datetime.utcnow().isoformat() + 'Z'}}
    if old: st['history_before_patch'] = old.get('history_before_patch', []) + old['candidates']; st['arbitration'] = old.get('arbitration', {})
    json.dump(st, open(p, 'w'), indent=1, ensure_ascii=False); n += 1
print(n, 'installed')
