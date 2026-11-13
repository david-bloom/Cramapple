"""Check consistency and the computed answers in review14_draft_successors.json."""

import json
import math
from pathlib import Path

drafts = json.loads(Path(__file__).with_name('review14_draft_successors.json').read_text())
by_key = {d['content_key']: d['proposed_content'] for d in drafts}
assert len(drafts) == len(by_key) == 12

for d in drafts:
    p = d['proposed_content']
    j = p['prompt_json']
    assert d['source_version_id'] and d['source_content_hash']
    assert p['stimulus'] == j['stimulus']
    if d['content_key'].startswith('APSTATS-HDG-'):
        assert j['parts'][0]['prompt_text'] == p['stimulus']
        assert sum(c['points_possible'] for c in j['criteria']) == j['parts'][0]['points_possible'] == 4
    else:
        assert p['stem'] == j['stem']
        assert [{k: c[k] for k in ('choice_key', 'choice_text', 'is_correct', 'rationale')}
                for c in j['choices']] == p['choices']
        assert len(p['choices']) == 4 and sum(c['is_correct'] for c in p['choices']) == 1

tables = {k: by_key['APSTATS-HDG-2026-GRAPH-' + k]['prompt_json']['stimulus_table']
          for k in ('021', '022', '024', '026')}
assert [sum(v for v in row.values() if isinstance(v, int)) for row in tables['021']] == [80, 60]
assert 24/80 > 9/60
assert [sum(v for v in row.values() if isinstance(v, int)) for row in tables['022']] == [120, 80]
assert 44/80 > 30/120
assert [sum(v for v in row.values() if isinstance(v, int)) for row in tables['024']] == [70, 90, 115]
assert [row['In-person'] for row in tables['024']] == [50, 15, 40]
assert [sum(v for v in row.values() if isinstance(v, int)) for row in tables['026']] == [70, 100, 85]
assert [row['No-show'] for row in tables['026']] == [10, 35, 20]

scores = [row['Test score'] for row in by_key['APSTATS-HDG-2026-GRAPH-029']['prompt_json']['stimulus_table']]
assert len(scores) == 12 and scores == sorted(scores)
q1 = (scores[2] + scores[3]) / 2
q3 = (scores[8] + scores[9]) / 2
assert (q1, q3, q1 - 1.5*(q3-q1)) == (80.5, 85.5, 73)
assert scores[0] < 73

x = [.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5]
y = [33, 30, 38, 23, 21, 29, 28, 14, 14]
mx, my = sum(x)/len(x), sum(y)/len(y)
sxy = sum((a-mx)*(b-my) for a,b in zip(x,y))
sxx = sum((a-mx)**2 for a in x)
syy = sum((b-my)**2 for b in y)
r = sxy / math.sqrt(sxx*syy)
slope = sxy/sxx
assert abs(r + .7650940154) < 1e-8 and abs(slope + 4.6) < 1e-8
assert '37.06 - 4.60' in by_key['APSTATS-HDG-2026-GRAPH-036']['canonical_answer_1']

z = ((248/620)-(203/580)) / math.sqrt((451/1200)*(749/1200)*(1/620+1/580))
pvalue = math.erfc(z/math.sqrt(2))/2
assert .0365 < pvalue < .0375
assert '248 completed' in by_key['APSTATS-MCQ-012']['stimulus']
assert '0.037' in by_key['APSTATS-MCQ-012']['stimulus']
assert '0.038' not in json.dumps(by_key['APSTATS-MCQ-012'])
assert all('0.037' in c['choice_text'] for c in by_key['APSTATS-MCQ-012']['choices'])
assert 'fifth power' in by_key['APSTATS-MCQ-007']['choices'][3]['choice_text']
assert 'fifth power' in by_key['APSTATS-MCQ-007-CAL']['choices'][3]['choice_text']
assert 'H0:' not in by_key['APSTATS-MCQ-017']['stimulus']
assert 'standard error' not in by_key['APSTATS-MCQ-017']['stem'].lower()

print(f'{len(drafts)} draft successors verified; MCQ-012 one-sided p={pvalue:.6f}; GRAPH-036 r={r:.6f}')
