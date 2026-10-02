#!/usr/bin/env python3
"""Option 2 (David, 2026-10-02): four voters (claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash); `validated` only when >= 3 of 4 agree;
a unique 2-of-4 plurality is written as `provisional_model`; 2-2 ties and 1-1-1-1 splits get no cell. MCQs from visible text, FRQs from text + scoring criteria.
Topic pairing as before (serving consensus topic at >= 5/6, else registered, else consensus at >= 4/6)."""
import json, glob, collections
P = {p['content_key']: p for p in json.load(open('packets.json'))}
sk = set(json.load(open('bio_skills.json'))); serv = json.load(open('serving_consensus.json')); sv = {**serv['accepted'], **serv['held']}
by = collections.defaultdict(dict)
for pat, only in (('out_skill_*/labels.jsonl', 'mcq'), ('out_skillrich_*/labels.jsonl', 'frq'), ('out_skill38_*/labels.jsonl', None)):
    for f in glob.glob(pat):
        for l in open(f):
            r = json.loads(l)
            if r['ok'] and (only is None or P[r['key']]['item_type'] == only): by[r['key']][r['model'].split('/')[1]] = r['label']['skill_code'].strip()
VOTERS = ['claude-opus-5', 'gpt-5.5', 'gemini-2.5-pro', 'gemini-3.8-flash']
cur = json.load(open('skill_consensus_final.json'))['accepted']
plan = {}; none = {}; skipped = {}
for k, m in sorted(by.items()):
    assert all(v in m for v in VOTERS), k
    votes = [m[v] for v in VOTERS]; c = collections.Counter(votes).most_common()
    top, n = c[0]; tie = len(c) > 1 and c[1][1] == n
    if n >= 3: status, tier = 'validated', ('4of4' if n == 4 else '3of4')
    elif n == 2 and not tie: status, tier = 'provisional_model', '2of4'
    else: none[k] = dict(votes=votes); continue
    s = sv.get(k); reg = P[k].get('primary_topic'); ts = int(s['topic_support'].split('/')[0]) if s else 0
    if s and ts >= 5: topic = s['topic']
    elif reg: topic = reg
    elif s and ts >= 4: topic = s['topic']
    else: skipped[k] = dict(votes=votes); continue
    plan[k] = dict(skill=top, status=status, tier=tier, topic=topic, version_id=P[k]['version_id'], votes=votes,
                   was=(cur[k]['skill'], cur[k]['topic']) if k in cur else None)
json.dump(dict(plan=plan, none=none, skipped=skipped), open('skill_4voter_plan.json', 'w'), indent=1)
print('validated', sum(p['status'] == 'validated' for p in plan.values()), dict(collections.Counter(p['tier'] for p in plan.values() if p['status'] == 'validated')))
print('provisional_model', sum(p['status'] != 'validated' for p in plan.values()), '| no cell (tie/split)', len(none), '| skipped (no topic)', len(skipped))
had = [k for k, p in plan.items() if p['was']]
print('of the 104 written today:', len(cur), '-> still validated same label:', sum(plan[k]['status'] == 'validated' and plan[k]['skill'] == cur[k]['skill'] and plan[k]['topic'] == cur[k]['topic'] for k in cur if k in plan),
      '| validated, label changes:', sum(plan[k]['status'] == 'validated' and plan[k]['skill'] != cur[k]['skill'] for k in cur if k in plan),
      '| demoted to provisional:', sum(plan[k]['status'] != 'validated' for k in cur if k in plan), '| lose their cell (tie/split):', sum(k in none for k in cur), '| lose (skipped):', sum(k in skipped for k in cur))
print('new provisional cells for items with no cell today:', sum(1 for k, p in plan.items() if not p['was']))
print('topic changes among existing:', sum(1 for k in cur if k in plan and plan[k]['topic'] != cur[k]['topic']))
