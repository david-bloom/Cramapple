"""Compare every accepted batch item with every published AP Chemistry MCQ in Production (read-only export in
bank_prod.json), using the seed pipeline's own similarity measures (word Jaccard and word 3-gram Jaccard over
stem + choice texts; seed-vs-seed thresholds 0.45 / 0.12). Writes bank_dedupe.json."""
import json, re, glob, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
bank = json.load(open('bank_prod.json'))
def toks(it): return re.findall(r'[a-z0-9]+', (it['stem'] + ' ' + ' '.join(c['choice_text'] for c in it['choices'] or [])).lower())
def wj(a, b):
    A, B = set(toks(a)), set(toks(b)); return len(A & B) / max(1, len(A | B))
def gj(a, b):
    def g(it):
        w = toks(it); return {' '.join(w[i:i + 3]) for i in range(len(w) - 2)}
    A, B = g(a), g(b); return len(A & B) / max(1, len(A | B))
items = []
for f in sorted(glob.glob('batch/topics/*.json')):
    st = json.load(open(f))
    for s in st['seeds']:
        if s.get('seed'): items.append((s['seed']['id'], s['seed']['item']))
        for v in s['variants']:
            if v.get('accepted'): items.append((v['accepted']['id'], v['accepted']['item']))
out = []
for cid, it in items:
    best = sorted(({'bank': b['content_key'], 'teaching': b['teaching'], 'topic': b['topic'], 'words': round(wj(it, b), 3), 'gram3': round(gj(it, b), 3)} for b in bank), key=lambda r: -r['words'])[:3]
    flag = any(r['words'] > 0.45 or r['gram3'] > 0.12 for r in best)
    out.append({'candidate': cid, 'over_seed_gate': flag, 'closest': best})
    print(cid, 'OVER' if flag else 'ok', [(r['bank'], r['words'], r['gram3']) for r in best])
json.dump(out, open('bank_dedupe.json', 'w'), indent=1)
