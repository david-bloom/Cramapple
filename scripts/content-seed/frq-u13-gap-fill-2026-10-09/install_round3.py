#!/usr/bin/env python3
"""Install round-3 arbitration results. Corrected items return to pending_checks (every gate runs again).
Items Claude rules correct as they stand ("accept_as_is": every objection rejected after re-deriving) are accepted on
the arbitration record: the last checked candidate (which passed lint, recompute and the topic gate or a CED ruling)
becomes the accepted candidate, with the overruled objections kept in the slot."""
import json, glob, os, datetime, collections
HERE = os.path.dirname(os.path.abspath(__file__)); NOW = datetime.datetime.utcnow().isoformat() + 'Z'; n = {'recheck': 0, 'accept': 0}
for f in sorted(glob.glob(os.path.join(HERE, 'arbitration', 'round3', '*_resolved.json'))):
    for r in json.load(open(f)):
        p = os.path.join(HERE, 'slots', r['slot_id'] + '.json'); s = json.load(open(p))
        if s['status'] != 'given_flagged': print('skip:', r['slot_id'], s['status']); continue
        a = s.setdefault('arbitration', {}); a.setdefault('log', []).append({'at': NOW, 'round': 3, 'file': os.path.basename(f), 'decisions': r['decisions'], 'accept_as_is': bool(r.get('accept_as_is'))})
        if r.get('topic_ruling'):
            a['topic_ruling'] = {'topic': s['slot']['topic_code'], 'required_units': r['topic_ruling']['required_units'], 'basis': 'ced_text_tiebreak', 'reason': r['topic_ruling']['reason']}
        if r.get('accept_as_is'):
            c = s['candidates'][-1]
            if not c['probe']['pass']:
                assert a.get('topic_ruling'), r['slot_id'] + ': topic vote failed and no ruling'
                c['probe'].update({'vote_pass': False, 'pass': True, 'overridden_by': a['topic_ruling'], 'required_units': a['topic_ruling']['required_units']})
            d = [x.get('difficulty') for x in c.get('checks') or [] if x.get('difficulty')] or ['Medium']
            top = collections.Counter(d).most_common(1)[0]; c['difficulty'] = top[0] if top[1] > len(d) / 2 else 'Medium'
            c['stage'] = 'accepted'; c['accepted_by_arbitration'] = True; s['status'] = 'accepted'; s['accepted_round'] = c['round']; n['accept'] += 1
        else:
            s.setdefault('history_flagged', []).extend(s['candidates']); s['candidates'] = []; s['given']['item'] = r['item']; s['status'] = 'pending_checks'; n['recheck'] += 1
        json.dump(s, open(p, 'w'), indent=1, ensure_ascii=False)
print(n)
