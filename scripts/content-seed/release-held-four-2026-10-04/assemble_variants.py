#!/usr/bin/env python3
"""Held-four variants: validate, similarity < 0.7, randomize correct letters ONCE (secrets), export math_items/ced_items/variants_manifest (+ per-pack blind files).
usage: python3 assemble_variants.py check | export.  export re-randomizes: run once, never rebuild after anything is loaded."""
import json, re, sys, secrets, itertools
IT = json.load(open('items.json'))
PK = {'apphycem-mcq-003': 'em', 'apphycm-mcq-023': 'cm', 'apphycm-mcq-031': 'cm', 'apphy2-mcq-001': 'p2'}
V = json.load(open('variants_c1.json'))
def toks(t): return set(re.findall(r"\w+", t.lower()))
def jac(a, b): a, b = toks(a), toks(b); return len(a & b) / len(a | b) if a | b else 0
def vt(v): return v['stem'] + ' ' + ' '.join([v['correct']['text']] + [w['text'] for w in v['wrong']])
def st(k): return IT[k][1] + ' ' + ' '.join(IT[k][2])
def check():
    f = []; per = {}
    ids = [v['id'] for v in V]
    if len(set(ids)) != len(ids): f.append('duplicate ids')
    for v in V:
        per.setdefault(v['seed'], []).append(v)
        if v['seed'] not in IT: f.append(f"{v['id']}: unknown seed"); continue
        if len(v['wrong']) != 3: f.append(f"{v['id']}: needs 3 distractors")
        txt = [v['correct']['text']] + [w['text'] for w in v['wrong']]
        if len({t.strip().lower() for t in txt}) != 4: f.append(f"{v['id']}: duplicate choice text")
        if any(not (t.get('rationale') or '').strip() for t in [v['correct']] + v['wrong']): f.append(f"{v['id']}: blank rationale")
        if re.search(r'(^|\s)[A-D][\.\)]\s', v['stem']): f.append(f"{v['id']}: option list in stem")
        if jac(vt(v), st(v['seed'])) >= 0.7: f.append(f"{v['id']}: similar to seed")
        L = [len(t) for t in txt]
        if L[0] == max(L) and L[0] > 1.4 * sorted(L)[-2]: f.append(f"{v['id']}: key much longer")
    for s, vs in per.items():
        if len(vs) != 3: f.append(f"{s}: {len(vs)} variants")
    for a, b in itertools.combinations(V, 2):
        if jac(vt(a), vt(b)) >= 0.7: f.append(f"{a['id']}/{b['id']} similar")
    print('FAILED:' if f else f'OK: {len(V)} variants from {len(per)} seeds'); [print('  -', x) for x in f]
    return 1 if f else 0
def export():
    rng = secrets.SystemRandom(); L = 'ABCD'; rows = []; ced = []; man = []
    for v in V:
        ch = [(v['correct']['text'], v['correct']['rationale'], True)] + [(w['text'], w['rationale'], False) for w in v['wrong']]; rng.shuffle(ch)
        key = 'hf4-' + v['id']
        rows.append(dict(key=key, kind='mcq', stem=v['stem'], choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)], keyed_label=next(L[i] for i, c in enumerate(ch) if c[2]), rationales={L[i]: c[1] for i, c in enumerate(ch)}))
        ced.append(dict(content_key=key, item_type='mcq', stem=v['stem'], stimulus=None, criteria=[f"{L[i]}." + (' (correct)' if c[2] else '') + f" {c[0]}" for i, c in enumerate(ch)]))
        man.append(dict(key=key, id=v['id'], seed=v['seed'], pack=PK[v['seed']], title=v['title'], difficulty=v['difficulty'], change=v['change_note'], check=v.get('check')))
    json.dump(rows, open('math_items.json', 'w'), indent=1, ensure_ascii=False); json.dump(ced, open('ced_items.json', 'w'), indent=1, ensure_ascii=False); json.dump(man, open('variants_manifest.json', 'w'), indent=1, ensure_ascii=False)
    blind = []
    for r in rows:
        body = "Question:\n" + r['stem'] + "\n\n" + "\n".join(f"{c['label']}. {c['text']}" for c in r['choices'])
        blind.append(dict(content_key=r['key'], item_type='mcq', body=body))
    json.dump(blind, open('blind_vars.json', 'w'), indent=1, ensure_ascii=False)
    for p in ('em', 'cm', 'p2'):
        ks = {m['key'] for m in man if m['pack'] == p}
        for nm, arr, kk in (('blind', blind, 'content_key'), ('math', rows, 'key'), ('ced', ced, 'content_key')):
            json.dump([x for x in arr if x[kk] in ks], open(f'{nm}_{p}.json', 'w'), indent=1, ensure_ascii=False)
    print(len(rows), 'exported; letters:', ''.join(r['keyed_label'] for r in rows))
if __name__ == '__main__':
    if sys.argv[1] == 'check': sys.exit(check())
    if sys.argv[1] == 'export' and check() == 0: export()
