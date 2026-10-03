#!/usr/bin/env python3
"""DECISION-0085 rule: all three models on every item; validated on >= 2 of 3 agreeing (tier recorded: unanimous / majority); no majority -> held (not written).
Topic paired with the skill: the serving-probe consensus topic when >= 5/6 samples agree (the registered topic is wrong on ~58 items), else the registered primary topic,
else the consensus topic at >= 4/6, else the item is skipped."""
import json, glob, collections
P = {p['content_key']: p for p in json.load(open('packets.json'))}
sk = set(json.load(open('bio_skills.json'))); serv = json.load(open('serving_consensus.json'))
sv = {**serv['accepted'], **serv['held']}
by = collections.defaultdict(dict)
# MCQs: first pass (student-visible text). FRQs: criteria-enriched pass (the visible FRQ text is often only a scenario sentence).
for f in glob.glob('out_skill_*/labels.jsonl'):
    for l in open(f):
        r = json.loads(l)
        if r['ok'] and P[r['key']]['item_type'] == 'mcq': by[r['key']][r['model']] = r['label']['skill_code'].strip()
for f in glob.glob('out_skillrich_*/labels.jsonl'):
    for l in open(f):
        r = json.loads(l)
        if r['ok']: by[r['key']][r['model']] = r['label']['skill_code'].strip()
out, held, skipped = {}, {}, {}
agree = collections.Counter()
for k, m in sorted(by.items()):
    assert len(m) == 3, k
    bad = [v for v in m.values() if v not in sk]
    c = collections.Counter(m.values()); top, n = c.most_common(1)[0]
    if bad or n < 2: held[k] = dict(votes=m); continue
    tier = 'unanimous' if n == 3 else 'majority'; agree[tier] += 1
    s = sv.get(k); reg = P[k].get('primary_topic')
    ts = int(s['topic_support'].split('/')[0]) if s else 0
    if s and ts >= 5: topic, why = s['topic'], 'consensus'
    elif reg: topic, why = reg, 'registered'
    elif s and ts >= 4: topic, why = s['topic'], 'consensus_4of6'
    else: skipped[k] = dict(votes=m, reason='no usable topic'); continue
    out[k] = dict(skill=top, tier=tier, topic=topic, topic_basis=why, votes=m, item_id=P[k]['item_id'], version_id=P[k]['version_id'], registered=reg)
json.dump(dict(accepted=out, held=held, skipped=skipped), open('skill_consensus_final.json', 'w'), indent=1)
print('accepted', len(out), dict(agree), '| held (no majority)', len(held), '| skipped', len(skipped))
print('topic basis:', dict(collections.Counter(r['topic_basis'] for r in out.values())))
print('skill distribution:', dict(sorted(collections.Counter(r['skill'] for r in out.values()).items())))
mods = collections.Counter(); 
for k, m in by.items():
    top = collections.Counter(m.values()).most_common(1)[0][0]
    for mod, v in m.items(): mods[mod.split('/')[1]] += (v == top)
print('agreement with the majority label per model (of', len(by), '):', dict(mods))
print('held:', {k: v['votes'] for k, v in list(held.items())[:8]})
