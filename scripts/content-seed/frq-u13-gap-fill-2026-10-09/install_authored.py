#!/usr/bin/env python3
"""Install hand-authored FRQs (authored/<group>.json) into their slots as given items awaiting the paid checks.
Refuses any topic that is accepted already or not in the plan. Keeps prior candidates as history."""
import json, glob, os, sys, datetime
HERE = os.path.dirname(os.path.abspath(__file__))
n = 0
for f in sys.argv[1:] or sorted(glob.glob(os.path.join(HERE, 'authored', '*.json'))):
    for r in json.load(open(f)):
        p = os.path.join(HERE, 'slots', f"{r['subject_key']}__{r['topic_code']}__1.json")
        if not os.path.exists(p): sys.exit(f'no slot for {r["subject_key"]} {r["topic_code"]}')
        s = json.load(open(p))
        if s['status'] == 'accepted': print('skip (already accepted):', s['id']); continue
        if s['slot'].get('existing'): sys.exit(f'{s["id"]}: topic already had an FRQ')
        if s.get('given') and s['status'] == 'pending_checks' and s['given'].get('source', '').startswith('Product Owner'):
            print('skip (Product Owner item in place):', s['id']); continue
        s.setdefault('history_before_session_authoring', []).extend(s['candidates']); s['candidates'] = []
        s['given'] = {'item': r['item'], 'source': f'Claude session author ({os.path.basename(f)}), Product Owner direction 2026-10-10',
                      'at': datetime.datetime.utcnow().isoformat() + 'Z'}
        s['status'] = 'pending_checks'; json.dump(s, open(p, 'w'), indent=1, ensure_ascii=False); n += 1
print(n, 'items installed as pending_checks')
