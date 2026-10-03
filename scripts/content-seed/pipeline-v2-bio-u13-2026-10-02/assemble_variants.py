#!/usr/bin/env python3
"""Validate the five authored batches, check similarity (< 0.7 vs seed and vs siblings and vs every other variant), randomize correct-answer letters ONCE, export:
math_items.json (key, kind, stem, choices, keyed_label, rationales), ced_items.json, variants_manifest.json.  usage: python3 assemble_variants.py check | export
WARNING: export re-randomizes letters; run it once, never rebuild after anything is loaded."""
import json, re, sys, secrets, itertools, glob
seeds = {s['key']: s for s in json.load(open('seeds_u13.json'))}
V = []
for f in sorted(glob.glob('variants_b*.json')): V += json.load(open(f))
def toks(t): return set(re.findall(r"\w+", t.lower()))
def jac(a, b): a, b = toks(a), toks(b); return len(a & b) / len(a | b) if a | b else 0
def vt(v): return v['stem'] + ' ' + ' '.join([v['correct']['text']] + [w['text'] for w in v['wrong']])
def st(s): return s['stem'] + ' ' + ' '.join(c['text'] for c in s['choices'])
def check():
    f = []
    ids = [v['id'] for v in V]
    if len(set(ids)) != len(ids): f.append('duplicate ids')
    per = {}
    for v in V:
        per.setdefault(v['seed'], []).append(v)
        if v['seed'] not in seeds: f.append(f"{v['id']}: unknown seed"); continue
        if len(v['wrong']) != 3: f.append(f"{v['id']}: needs 3 distractors")
        txt = [v['correct']['text']] + [w['text'] for w in v['wrong']]
        if len({t.strip().lower() for t in txt}) != 4: f.append(f"{v['id']}: duplicate choice text")
        if any(not (t.get('rationale') or '').strip() for t in [v['correct']] + v['wrong']): f.append(f"{v['id']}: blank rationale")
        if jac(vt(v), st(seeds[v['seed']])) >= 0.7: f.append(f"{v['id']}: similar to its seed ({jac(vt(v), st(seeds[v['seed']])):.2f})")
        L = [len(t) for t in txt]
        if L[0] == max(L) and L[0] > 1.4 * sorted(L)[-2]: f.append(f"{v['id']}: correct answer much longer than every distractor")
    for s, vs in per.items():
        if len(vs) != 3: f.append(f"{s}: has {len(vs)} variants, expected 3")
    for a, b in itertools.combinations(V, 2):
        if jac(vt(a), vt(b)) >= 0.7: f.append(f"{a['id']}/{b['id']} similar ({jac(vt(a), vt(b)):.2f})")
    print('FAILED:' if f else f'OK: {len(V)} variants from {len(per)} seeds')
    for x in f: print('  -', x)
    print('max similarity to own seed: %.2f' % max(jac(vt(v), st(seeds[v['seed']])) for v in V if v['seed'] in seeds))
    return 1 if f else 0
def export():
    rng = secrets.SystemRandom(); L = 'ABCD'; rows = []; ced = []; man = []
    for v in V:
        ch = [(v['correct']['text'], v['correct']['rationale'], True)] + [(w['text'], w['rationale'], False) for w in v['wrong']]; rng.shuffle(ch)
        key = 'u13-' + v['id']
        rows.append(dict(key=key, kind='mcq', stem=v['stem'], choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)], keyed_label=next(L[i] for i, c in enumerate(ch) if c[2]), rationales={L[i]: c[1] for i, c in enumerate(ch)}))
        ced.append(dict(content_key=key, item_type='mcq', stem=v['stem'], stimulus=None, criteria=[f"{L[i]}." + (' (correct)' if c[2] else '') + f" {c[0]}" for i, c in enumerate(ch)]))
        man.append(dict(key=key, id=v['id'], seed=v['seed'], title=v['title'], difficulty=v['difficulty'], change=v['change_note'], check=v.get('check')))
    json.dump(rows, open('math_items.json', 'w'), indent=1, ensure_ascii=False); json.dump(ced, open('ced_items.json', 'w'), indent=1, ensure_ascii=False); json.dump(man, open('variants_manifest.json', 'w'), indent=1, ensure_ascii=False)
    print(len(rows), 'exported; letters:', ''.join(r['keyed_label'] for r in rows))
if __name__ == '__main__':
    if sys.argv[1] == 'check': sys.exit(check())
    if sys.argv[1] == 'export':
        if check() == 0: export()
