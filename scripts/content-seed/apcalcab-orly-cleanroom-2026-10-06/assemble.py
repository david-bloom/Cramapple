"""Merge the two authors' item files, draw each item's correct-answer letter at random (once),
remap choices and rationales, and run the sibling/bank near-duplicate check (Jaccard < 0.7).
Usage: python3 assemble.py            -> writes items_assembled.json (refuses to overwrite)
Never re-run after the letters have been checked: it would redraw them."""
import json, os, re, secrets, sys

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'items_assembled.json')
if os.path.exists(OUT) and '--force' not in sys.argv:
    sys.exit('items_assembled.json exists; letters already drawn. Use --force only before any check has run.')

items = []
for f in ('items_C1_C2.json',):
    items += json.load(open(os.path.join(HERE, f)))
assert len(items) == 6, len(items)

LABELS = 'ABCD'
# Balanced draw: each letter keys len/4 items, assignment shuffled with a CSPRNG (an unbalanced 11-of-24 D draw prompted this).
pool = [LABELS[i % 4] for i in range(len(items))]
for i in range(len(pool) - 1, 0, -1):
    j = secrets.randbelow(i + 1); pool[i], pool[j] = pool[j], pool[i]
for it, target in zip(items, pool):
    assert it['keyed_label'] == 'A'
    assert not re.search(r'(^|\n)\s*\(?A[.)]\s', it['stem']), it['key'] + ': embedded choice list'
    others = [l for l in LABELS if l != target]
    rest = ['B', 'C', 'D']
    order = [None] * 4
    order[LABELS.index(target)] = 'A'
    perm = rest[:]
    # shuffle distractors too
    for i in range(len(perm) - 1, 0, -1):
        j = secrets.randbelow(i + 1)
        perm[i], perm[j] = perm[j], perm[i]
    for slot, old in zip(others, perm):
        order[LABELS.index(slot)] = old
    by_old = {c['label']: c['text'] for c in it['choices']}
    it['choices'] = [{'label': LABELS[i], 'text': by_old[old]} for i, old in enumerate(order)]
    it['rationales'] = {LABELS[i]: it['rationales'][old] for i, old in enumerate(order)}
    it['misconception_map'] = {LABELS[i]: it['misconception_map'][old] for i, old in enumerate(order) if old != 'A'}
    it['keyed_label'] = target
    it['author_letter_map'] = {LABELS[i]: old for i, old in enumerate(order)}

def words(it):
    t = it['stem'] + ' ' + ' '.join(c['text'] for c in it.get('choices', []))
    return set(re.findall(r'[a-z0-9.]+', t.lower()))

def jac(a, b):
    return len(a & b) / len(a | b) if a | b else 0.0

bank = json.load(open(os.path.join(HERE, 'bank_existing_21.json')))
report = {'max_sibling': [], 'max_bank': []}
for it in items:
    w = words(it)
    sib = max(jac(w, words(o)) for o in items if o is not it)
    bk = max((jac(w, words(b)), b['key']) for b in bank)
    report['max_sibling'].append((it['key'], round(sib, 3)))
    report['max_bank'].append((it['key'], round(bk[0], 3), bk[1]))
bad = [r for r in report['max_sibling'] if r[1] >= 0.7] + [r for r in report['max_bank'] if r[1] >= 0.7]
json.dump(items, open(OUT, 'w'), ensure_ascii=False, indent=1)
json.dump(report, open(os.path.join(HERE, 'similarity_report.json'), 'w'), indent=1)
print('letters:', ''.join(i['keyed_label'] for i in items))
print('max sibling J:', max(r[1] for r in report['max_sibling']), ' max bank J:', max(r[1] for r in report['max_bank']))
print('>=0.7:', bad or 'none')
