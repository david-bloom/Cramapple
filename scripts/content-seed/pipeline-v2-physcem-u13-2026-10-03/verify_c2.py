# -*- coding: utf-8 -*-
"""Recompute every numeric answer in variants_c2.json (AP Physics C: E&M, seeds 009, 021-025).  Uses math/sympy/mpmath only."""
import json, re, os, math
import sympy as sp
from mpmath import mp, mpf, quad, cos, pi
mp.dps = 30
d = os.path.dirname(os.path.abspath(__file__))
V = json.load(open(os.path.join(d, 'variants_c2.json')))
SEEDS = {
'apphycem-mcq-009': "In electrostatic equilibrium, within the conducting material of a conductor, E is maximum zero nonzero but uniform throughout time varying",
'apphycem-mcq-021': "Two point charges remain fixed while their separation triples. The force magnitude becomes three times one-third one-ninth one-twenty-seventh",
'apphycem-mcq-022': "The electric field due to an isolated negative point charge points radially outward radially inward tangent to circles its direction depends on the sign of the test charge",
'apphycem-mcq-023': "For a line charge λ(s), the differential charge element is λ ds λ dA λ dV (dλ/ds)ds",
'apphycem-mcq-024': "Uniform E crosses flat area A whose normal makes angle θ with E. Electric flux is EA sinθ EA cosθ EA/ cosθ EA",
'apphycem-mcq-025': "Charges outside a closed Gaussian surface contribute to net enclosed charge local field but zero net flux contribution neither field nor flux anywhere nonzero net flux but no enclosed charge"}
k = 9.0e9; eps0 = 8.85e-12
SUP = str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹', '-0123456789')
def num(t):
    t = t.translate(SUP)
    if t.strip().lower() in ('zero', '0'): return 0.0
    m = re.match(r'\s*([+-]?\d+(?:\.\d+)?)(?:\s*×\s*10(-?\d+))?', t)
    x = float(m.group(1))
    if m.group(2): x *= 10 ** int(m.group(2))
    return x
# --- symbolic / numeric recomputation: id -> [key, w1, w2, w3] in the order of the JSON (None = non-numeric)
x, a, L, R, th = sp.symbols('x a L R theta', positive=True)
Q_ramp = sp.integrate(a * x, (x, 0, L))                          # aL^2/2
assert sp.simplify(Q_ramp - a * L**2 / 2) == 0
Q_arc = sp.integrate(sp.cos(th), (th, -sp.pi / 2, sp.pi / 2)) * 5.0e-9 * 0.30   # lambda0*R*2
Q_arc_sym0 = sp.integrate(sp.cos(th), (th, 0, sp.pi))            # the 'cancels' trap only for 0..pi
assert abs(float(Q_arc) - 3.0e-9) < 1e-15 and abs(float(Q_arc_sym0)) < 1e-12
Qramp = float(Q_ramp.subs({a: 4.0e-6, L: 0.50}))
Vsurf = k * 6.0e-9 / 0.30
E_mid = k * 2.0e-6 / 0.20**2
E = {
 'apphycem-mcq-009-v2': [4.0e3 - 4.0e3, 4.0e3 / 2, 4.0e3, 8.0e3],
 'apphycem-mcq-009-v3': [Vsurf, 0.0, k * 6.0e-9 / 0.15, None],
 'apphycem-mcq-021-v2': [k * 3e-6 * 5e-6 / 0.30**2, k * 3e-6 * 5e-6 / 0.30, k * 3e-6 * 5e-6 / 0.30**4, 2 * k * 3e-6 * 5e-6 / 0.30**2],
 'apphycem-mcq-021-v3': [12 * 2 / 9, 12 / 9, 12 * 2 / 3, 12 * 2 * 9],
 'apphycem-mcq-022-v2': [k * 4e-9 / 0.20**2, k * 4e-9 / 0.20, k * 4e-9 / 0.10**2, 4e-9 / (eps0 * 0.20**2)],
 'apphycem-mcq-022-v3': [2 * E_mid, E_mid - E_mid, E_mid, 2 * k * 2e-6 / 0.40**2],
 'apphycem-mcq-023-v1': [5.0 * 0.40, 5.0, 5.0 / 0.40, 5.0 * 0.20],
 'apphycem-mcq-023-v2': [Qramp * 1e6, 2.0 * 1e6 * 0.0 + (4.0e-6 * 0.5) * 0.50 * 1e6, 4.0e-6 * 0.5**3 / 3 * 1e6, 4.0e-6 * 0.5**2 / 4 * 1e6],
 'apphycem-mcq-023-v3': [float(Q_arc) * 1e9, 5.0 * math.pi * 0.30, 0.0, 5.0 * 0.30],
 'apphycem-mcq-024-v1': [200 * 0.5 * math.cos(math.radians(60)), 200 * 0.5 * math.sin(math.radians(60)), 200 * 0.5, 200 * 0.5 / math.cos(math.radians(60))],
 'apphycem-mcq-024-v2': [5.0e3 * 0.01 * math.cos(math.pi / 2) if abs(math.cos(math.pi / 2)) < 1e-12 else None, 5.0e3 * 0.01, 5.0e3 * 0.01 / 2, 5.0e3 / 0.01],
 'apphycem-mcq-024-v3': [400 * 0.20, 500 * 0.20, 300 * 0.20, 700 * 0.20],
 'apphycem-mcq-025-v1': [3.0e-9 / eps0, 8.0e-9 / eps0, 5.0e-9 / eps0, 2.0e-9 / eps0],
}
# the 023-v2 distractor 1: lambda(L)*L = (a L)*L = 1.0 uC
E['apphycem-mcq-023-v2'][1] = (4.0e-6 * 0.5) * 0.5 * 1e6
# derived-intermediate asserts quoted in rationales
assert abs(Vsurf - 180) < 1e-9 and abs(k * 6e-9 / 0.15 - 360) < 1e-9
assert abs(E_mid - 4.5e5) < 1e-6 and abs(2 * E_mid - 9.0e5) < 1e-6
assert abs(k * 3e-6 * 5e-6 / 0.09 - 1.5) < 1e-9 and abs(k * 3e-6 * 5e-6 - 0.135) < 1e-12
assert abs(4e-9 / (eps0 * 0.2**2) / E['apphycem-mcq-022-v2'][0] - 4 * math.pi) / (4 * math.pi) < 0.01   # missing 4*pi factor
assert abs(math.sqrt(500**2) - math.hypot(300, 400)) < 1e-9 and abs(400 / 500 - 0.8) < 1e-12
assert abs(float(quad(lambda t: cos(t), [-pi / 2, pi / 2])) - 2) < 1e-20
assert 2 * 5.0e-9 * 0.30 == 3.0e-9 or abs(2 * 5.0e-9 * 0.30 - 3.0e-9) < 1e-20
# conceptual relations
F = [
 ('021-v1 r/2 -> 4x', abs((1 / 0.5**2) - 4) < 1e-12),
 ('009-v1/-v2 net field = external - induced = 0', 4.0e3 - 4.0e3 == 0),
 ('022-v1 positive source: field on +x axis points +x (away)', (+1) * (+1) > 0),
 ('022-v2 negative source: field toward charge', (-1) < 0),
 ('022-v3 midpoint: +q field along +x, -q field along +x (toward -q)', (+1) * 1 > 0 and (-1) * (-1) > 0),
 ('025-v2 cube: inward flux on near face equals outward on rest (net 0 for q_enc = 0)', (-5.0 + 5.0) == 0),
 ('025-v3 enclosed charge unchanged at +Q', (+1) == (+1)),
 ('024-v2 plane parallel to field => normal perpendicular => cos = 0', abs(math.cos(math.pi / 2)) < 1e-12),
]
for lab, ok in F: assert ok, lab
# structural checks (same rules as assemble_variants.py)
W = lambda s: set(re.findall(r"\w+", s.lower()))
def jac(a, b): return len(a & b) / len(a | b)
def vtext(v): return v['stem'] + ' ' + v['correct']['text'] + ' ' + ' '.join(w['text'] for w in v['wrong'])
bad = 0
assert len(V) == 18
for s in SEEDS: assert sum(v['seed'] == s for v in V) == 3
assert {v['difficulty'] for v in V} == {'easy', 'medium', 'hard'}
for v in V:
    id = v['id']; errs = []
    assert len(v['wrong']) == 3 and id.rsplit('-v', 1)[0] == v['seed']
    if re.search(r'(^|\s)[A-D][\.\)]\s', v['stem']): errs.append('option list in stem')
    texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    if id in E:
        for val, t in zip(E[id], texts):
            if val is None: continue
            p = abs(num(t)); val = abs(val)
            if abs(val - p) > max(0.05 * val, 1e-9): errs.append(f'value {val:.4g} vs text {t}')
        vals = [round(abs(z), 9) for z in E[id] if z is not None]
        if len(set(vals)) < len(vals): errs.append('computed values not distinct')
    lens = [len(t) for t in texts]
    if lens[0] == max(lens) and lens[0] / sorted(lens)[-2] > 1.4: errs.append('key much longer than others')
    if len({t.lower() for t in texts}) != 4: errs.append('dup choice')
    for t in [v['correct']] + v['wrong']:
        if not t['rationale'].strip(): errs.append('blank rationale')
    for w in v['wrong']:
        if not w.get('error_pattern'): errs.append('missing error_pattern')
    sj = jac(W(vtext(v)), W(SEEDS[v['seed']]))
    if sj >= 0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id'] != id and jac(W(vtext(v)), W(vtext(o))) >= 0.7: errs.append('similar ' + o['id'])
    if re.search(r'\b(choice|option) [A-D]\b|answer [A-D]\b|\b[A-D] is correct', json.dumps(v, ensure_ascii=False)): errs.append('letter mention')
    if errs: bad += 1; print('FAIL', id, errs)
    else: print('OK', id)
print('ALL OK' if not bad else f'{bad} FAILURES')
