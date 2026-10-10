"""Independent, deterministic re-derivation of every key in the accepted 1.2/1.8 batch (protocol §0.3 rule 5, §9).
Each check recomputes the keyed value AND the named-trap distractor values from the stem data, then asserts the keyed
letter in the batch file is the choice whose text matches the recomputed answer. Writes recompute.json."""
import json, os
from fractions import Fraction as F
os.chdir(os.path.dirname(os.path.abspath(__file__)))

def items():
    for t in ('1.2', '1.8'):
        st = json.load(open(f'batch/topics/ap-chemistry__{t}.json'))
        for s in st['seeds']:
            if s.get('seed'): yield s['seed']['id'], s['seed']['item']
            for v in s['variants']:
                if v.get('accepted'): yield v['accepted']['id'], v['accepted']['item']
IT = dict(items())
key = lambda cid: next(c for c in IT[cid]['choices'] if c['is_correct'])
txt = lambda cid, L: next(c['choice_text'] for c in IT[cid]['choices'] if c['choice_key'] == L)
R = {}
def check(cid, expect_text_start, extra=True, note=''):
    k = key(cid)
    R[cid] = {'keyed': k['choice_key'], 'keyed_text': k['choice_text'], 'recomputed': expect_text_start, 'note': note,
              'ok': k['choice_text'].startswith(expect_text_start) and bool(extra)}

def avg(pairs):  # pairs of (mass, weight); weights normalised by their sum
    tot = sum(F(str(w)) for _, w in pairs); return sum(F(str(m)) * F(str(w)) for m, w in pairs) / tot
r1 = lambda x: f'{float(x):.1f}'

# 1.2 C: two samples, isotopes 50.0/54.0; sample 1 30/70, sample 2 70/30 -> average decreases; peak positions unchanged
a1, a2 = avg([(50, 30), (54, 70)]), avg([(50, 70), (54, 30)])
check('ap-chemistry__1.2__C__seed#r1-openai', 'The average atomic mass decreases, and the isotope peak positions remain unchanged', a2 < a1,
      f'sample1 {float(a1)} > sample2 {float(a2)}; peak position = isotope mass, independent of abundance')

# 1.2 D seed: masses 35.0 (light), 37.0 (heavy, fraction f), average 35.5 -> 35.0(1-f)+37.0f = 35.5, f = 0.25 in (0,1)
f = (F('35.5') - 35) / (37 - 35)
check('ap-chemistry__1.2__D__seed#r2-openai', '35.0(1 − f) + 37.0f = 35.5', 0 < f < 1, f'f = {f}')
# 1.2 D v1: masses 10.0 (light, fraction p), 11.0; average 10.7 -> 10.0p + 11.0(1-p) = 10.7, p = 0.3
p = (11 - F('10.7')) / (11 - 10)
check('ap-chemistry__1.2__D__v1#r1-openai', '10.0p + 11.0(1 − p) = 10.7', 0 < p < 1, f'p = {p}')

# 1.2 E seed: heights 100/12.5/12.5 at 24/25/26 -> 24.3; traps: /100 -> 30.4, unweighted 25.0, tallest 24.0
e = [(24, 100), (25, 12.5), (26, 12.5)]
trap = sum(F(str(m)) * F(str(w)) for m, w in e) / 100
check('ap-chemistry__1.2__E__seed#r1-anthropic', r1(avg(e)) + ' u',
      {r1(trap), '25.0', '24.0'} == {txt('ap-chemistry__1.2__E__seed#r1-anthropic', L).split()[0] for L in 'ACD'},
      f'avg {float(avg(e))}; /100 trap {float(trap)}')
# 1.2 E v1: heights 100/15/10 at 28/29/30 -> 28.28 -> 28.3; traps 35.35 -> 35.4, 29.0, 28.0
e = [(28, 100), (29, 15), (30, 10)]
trap = sum(F(str(m)) * F(str(w)) for m, w in e) / 100
check('ap-chemistry__1.2__E__v1#r1-anthropic', r1(avg(e)) + ' u',
      {r1(trap), '29.0', '28.0'} == {txt('ap-chemistry__1.2__E__v1#r1-anthropic', L).split()[0] for L in 'ACD'},
      f'avg {float(avg(e))}; /100 trap {float(trap)}')

# 1.8: typical charge = group 1,2 -> +1,+2; group 13 -> +3; group 15,16,17 -> -(18-g)
charge = lambda g: {1: 1, 2: 2, 13: 3}.get(g, -(18 - g))
# 1.8 B seed: Na2O -> K2O with K+ (group 1) and O2- (group 16): 2(+1) + (-2) = 0 -> model consistent ("Yes")
check('ap-chemistry__1.8__B__seed#r1-openai', 'Yes;', charge(1) == 1 and 2 * charge(1) + charge(16) == 0, 'K+ = Na+; 2(+1)-2 = 0')
# 1.8 B v1: CaF2 -> CaCl2 with Cl- (group 17): (+2) + 2(-1) = 0 -> "Yes"
check('ap-chemistry__1.8__B__v1#r1-openai', 'Yes;', charge(17) == -1 and charge(2) + 2 * charge(17) == 0, 'Cl- = F-; 2-2 = 0')
# 1.8 C seed: Al group 13 -> loses 3 -> Al3+
check('ap-chemistry__1.8__C__seed#r1-openai', 'Al³⁺ forms when an aluminum atom loses three', charge(13) == 3)
# 1.8 C v1: Sr group 2 -> loses 2 -> Sr2+
check('ap-chemistry__1.8__C__v1#r1-anthropic', 'Sr²⁺ forms when a strontium atom loses its two', charge(2) == 2)

assert set(R) == set(IT), f'unchecked items: {set(IT) - set(R)}'
json.dump(R, open('recompute.json', 'w'), indent=1, ensure_ascii=False)
for k, v in R.items(): print('OK ' if v['ok'] else 'BAD', k, v['keyed'], v['note'])
print('ALL OK' if all(v['ok'] for v in R.values()) else 'FAILURES')
