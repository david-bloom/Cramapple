#!/usr/bin/env python3
"""Install Claude's arbitration results (arbitration/<group>_resolved.json) into the slots and return each item to
pending_checks, so the corrected draft goes through every gate again. Records each ruling in the slot."""
import json, glob, os, datetime
HERE = os.path.dirname(os.path.abspath(__file__)); NOW = datetime.datetime.utcnow().isoformat() + 'Z'; n = 0
for f in sorted(glob.glob(os.path.join(HERE, 'arbitration', '*_resolved.json'))):
    for r in json.load(open(f)):
        p = os.path.join(HERE, 'slots', r['slot_id'] + '.json'); s = json.load(open(p))
        if s['status'] != 'given_flagged': print('skip (not flagged):', r['slot_id'], s['status']); continue
        a = s.setdefault('arbitration', {}); a.setdefault('log', []).append({'at': NOW, 'round': 2, 'file': os.path.basename(f), 'decisions': r['decisions']})
        if r.get('topic_ruling'):
            a['topic_ruling'] = {'topic': s['slot']['topic_code'], 'required_units': r['topic_ruling']['required_units'], 'basis': 'ced_text_tiebreak', 'reason': r['topic_ruling']['reason']}
        s.setdefault('history_flagged', []).extend(s['candidates']); s['candidates'] = []
        s['given']['item'] = r['item']; s['status'] = 'pending_checks'
        json.dump(s, open(p, 'w'), indent=1, ensure_ascii=False); n += 1
print(n, 'arbitrated items returned to pending_checks')
