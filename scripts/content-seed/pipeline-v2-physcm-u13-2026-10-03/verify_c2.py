import json, re, os, math
import sympy as sp
d = os.path.dirname(os.path.abspath(__file__))
V = {v['id']: v for v in json.load(open(os.path.join(d, 'variants_c2.json')))}
seeds = {s['key']: s for s in json.load(open(os.path.join(d, 'seeds_all.json')))['candidate_seeds']}
t, x, A, B, C, D, E, F0, L, b, m, c, v0, k = sp.symbols('t x A B C D E F0 L b m c v0 k', positive=True)
S = 'apphycm-mcq-'
SUP = str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹₀−', '-0123456789' + '0-')
SUPD = {'²': '^2', '³': '^3', '⁴': '^4', '⁵': '^5'}
def norm(s):  # ascii, no spaces
    for a_, b_ in SUPD.items(): s = s.replace(a_, b_)
    return s.translate(SUP).replace(' ', '').replace('·', '*').lower()
def sym_check(id, items):
    """items: list of (expected ascii text, sympy value) in order correct, w1, w2, w3. Texts compared after normalisation; values must be distinct."""
    v = V[id]; texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    for (asc, val), tx in zip(items, texts):
        assert norm(tx) == norm(asc), (id, tx, asc)
    vals = [sp.simplify(val) for _, val in items]
    for i in range(4):
        for j in range(i + 1, 4):
            assert sp.simplify(vals[i] - vals[j]) != 0, (id, 'duplicate values', i, j)
def num_check(id, vals, tol=0.03):
    v = V[id]; texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    for val, tx in zip(vals, texts):
        m_ = re.search(r'([+-]?\d+(?:\.\d+)?)', tx.replace('−', '-'))
        p = float(m_.group(1)); val = float(val)
        assert abs(p - val) <= max(tol * abs(val), 0.06), (id, tx, val)
    assert len({round(float(x_), 6) for x_ in vals}) == 4, (id, 'duplicate numeric values')
R = sp.Rational
# ---- 017 ----
xt = 2*t**3 - 5*t; vt = sp.diff(xt, t)
num_check(S+'017-v1', [vt.subs(t, 2), (2*t**2 - 5).subs(t, 2), (sp.diff(2*t**3, t) - 5*t).subs(t, 2), xt.subs(t, 2)])
assert vt.subs(t, 2) == 19
xt = B*t**4 - C*t**2
sym_check(S+'017-v2', [('4Bt^3-2Ct', sp.diff(xt, t)), ('Bt^3-Ct', B*t**3 - C*t), ('12Bt^2-2C', sp.diff(xt, t, 2)), ('4Bt^3-Ct', 4*B*t**3 - C*t)])
xt = 3*t**2 - t**3; vt = sp.diff(xt, t)
assert sp.solve(vt, t) == [2] or set(sp.solve(sp.Eq(vt, 0), t)) == {2}   # positive symbol: only t=2 (t=0 excluded by positivity)
tt = sp.symbols('tt')
vt_ = sp.diff(3*tt**2 - tt**3, tt); assert set(sp.solve(vt_, tt)) == {0, 2}
assert sp.solve(3*tt**2 - tt**3, tt) and 3 in sp.solve(3*tt**2 - tt**3, tt)              # position zero at 3
assert 1 in sp.solve(sp.diff(3*tt**2 - tt**3, tt, 2), tt) and vt_.subs(tt, 1) == 3       # a=0 at 1, v=3
assert 6 in sp.solve(6*tt - tt**2, tt) and vt_.subs(tt, 6) == -72                         # dropped-multiplier root; true v(6)
assert (3*tt**2 - tt**3).subs(tt, 3) == 0 and vt_.subs(tt, 3) == -9
num_check(S+'017-v3', [2, 3, 1, 6])
# ---- 021 ----
xt = 2*t**3; a_ = sp.diff(xt, t, 2)
num_check(S+'021-v1', [a_.subs(t, 3), sp.diff(xt, t).subs(t, 3), (6*t).subs(t, 3), 12])
assert a_ == 12*t and sp.diff(xt, t) == 6*t**2
xt = D*t**5 - E*t
sym_check(S+'021-v2', [('20Dt^3', sp.diff(xt, t, 2)), ('5Dt^4-E', sp.diff(xt, t)), ('20Dt^3-E', 20*D*t**3 - E), ('5Dt^3', 5*D*t**3)])
xt = A*sp.exp(-b*t)
assert sp.simplify(sp.diff(xt, t) + A*b*sp.exp(-b*t)) == 0
sym_check(S+'021-v3', [('Ab^2e^(-bt)', sp.diff(xt, t, 2)), ('-Abe^(-bt)', sp.diff(xt, t)), ('-Ab^2e^(-bt)', -A*b**2*sp.exp(-b*t)), ('Ae^(-bt)/b^2', sp.integrate(sp.integrate(xt, t), t) * 1)])
assert sp.simplify(sp.integrate(sp.integrate(xt, t), t) - A*sp.exp(-b*t)/b**2) == 0   # w3 claim: double integral
assert sp.simplify(sp.diff(xt, t, 2) - A*b**2*sp.exp(-b*t)) == 0
# ---- 022 ----
disp = 4.0*3.0 + (-2.0)*2.0; dist = 4.0*3.0 + 2.0*2.0
num_check(S+'022-v1', [disp, dist, 12.0, 4.0 + (-2.0)]); assert disp == 8 and dist == 16
vt = 8 - 2*t
disp = sp.integrate(vt, (t, 0, 6)); zero = sp.solve(vt, t)[0]
dist = sp.integrate(vt, (t, 0, zero)) + sp.Abs(sp.integrate(vt, (t, zero, 6)))
assert zero == 4 and sp.integrate(vt, (t, 0, 4)) == 16 and sp.integrate(vt, (t, 4, 6)) == -4 and dist == 20
num_check(S+'022-v2', [disp, dist, 8*6, vt.subs(t, 6)]); assert disp == 12
a_ = 6*t; vt = -10 + sp.integrate(a_, t)
assert vt == 3*t**2 - 10
disp = sp.integrate(vt, (t, 0, 4))
w_noV0 = sp.integrate(3*t**2, (t, 0, 4))
w_ca = -10*4 + R(1, 2)*a_.subs(t, 4)*4**2
w_avg = (vt.subs(t, 0) + vt.subs(t, 4))/2*4
num_check(S+'022-v3', [disp, w_noV0, w_ca, w_avg]); assert (disp, w_noV0, w_ca, w_avg) == (24, 64, 152, 56)
# ---- 018 ----
F = 4*x**2
W = sp.integrate(F, (x, 0, 3))
num_check(S+'018-v1', [W, F.subs(x, 3)*3, sp.diff(F, x).subs(x, 3), 4*sp.Integer(3)**3/2]); assert W == 36
F = F0*(1 - x**2/L**2)
sym_check(S+'018-v2', [('2F0L/3', sp.integrate(F, (x, 0, L))), ('F0L', F0*L), ('F0L/3', sp.integrate(F0*x**2/L**2, (x, 0, L))), ('Zero', F.subs(x, L))])
assert sp.simplify(sp.integrate(F, (x, 0, L)) - 2*F0*L/3) == 0 and F.subs(x, L) == 0
F = F0*L**3/(x + L)**3
Wk = sp.integrate(F, (x, 0, sp.oo))
anti = sp.integrate(F, x)
assert sp.simplify(anti - (-F0*L**3/(2*(x + L)**2))) == 0
sym_check(S+'018-v3', [('F0L/2', Wk), ('F0L', F0*L), ('Infinite', sp.Symbol('INF')), ('F0L/8', sp.simplify(-anti.subs(x, L)))])
assert sp.simplify(Wk - F0*L/2) == 0 and sp.simplify(-anti.subs(x, L) - F0*L/8) == 0
# ---- 024 ----
Ux = -R(1, 2)*c*x**2; Fx = -sp.diff(Ux, x)
assert Fx == c*x and Fx.subs(x, 0) == 0 and sp.diff(Ux, x, 2) < 0      # equilibrium at 0, curvature negative => maximum => unstable
xx = sp.symbols('xx', real=True)
Ux = xx**3 - 12*xx; eq = sp.solve(sp.diff(Ux, xx), xx); assert set(eq) == {-2, 2}
assert sp.diff(Ux, xx, 2).subs(xx, 2) > 0 and sp.diff(Ux, xx, 2).subs(xx, -2) < 0
assert (-sp.diff(Ux, xx)).subs(xx, 0) == 12 and sp.diff(Ux, xx, 2).subs(xx, 0) == 0
rt = sp.sqrt(12); assert Ux.subs(xx, rt) == 0 and (-sp.diff(Ux, xx)).subs(xx, rt) == -24
num_check(S+'024-v2', [2, -2, 0, float(rt)])
xs = sp.symbols('xs', positive=True)
Ux = A/xs**2 - B/xs
eq = sp.solve(sp.diff(Ux, xs), xs); assert eq == [2*A/B]
curv = sp.simplify(sp.diff(Ux, xs, 2).subs(xs, 2*A/B))
assert sp.simplify(curv - B/(2*A/B)**3) == 0 and curv.is_positive
assert sp.simplify(Ux.subs(xs, 2*A/B) + B**2/(4*A)) == 0
# wrong root A/B: derivative with dropped multiplier vanishes there; true force/derivative does not
assert sp.solve(-A/xs**3 + B/xs**2, xs) == [A/B]
assert sp.simplify(sp.diff(Ux, xs).subs(xs, A/B) + B**3/A**2) == 0          # U' = -B^3/A^2 != 0 at A/B
assert sp.simplify(sp.diff(Ux, xs).subs(xs, B/(2*A))) != 0
# ---- 025 ----
vf = sp.Function('v')
sol = sp.dsolve(sp.Eq(m*vf(t).diff(t), -b*vf(t)), vf(t), ics={vf(0): v0})
assert sp.simplify(sol.rhs - v0*sp.exp(-b*t/m)) == 0
tau = lambda mm, bb: sp.Rational(mm)/sp.Rational(bb)
tau1 = tau('2.0', '0.50'); assert tau1 == 4
assert sp.simplify((v0*sp.exp(-b*t/m)).subs({m: 2, b: R(1, 2), t: tau1}) - v0/sp.E) == 0
num_check(S+'025-v1', [tau1, 1/tau1, tau1*sp.log(2), 2*R(1, 2)])
v2 = (12*sp.exp(-b*t/m)).subs({m: 3, b: R(3, 2), t: 4})
a0 = R(3, 2)*12/3
num_check(S+'025-v2', [v2, 12*2**(-2), 12*sp.exp(-R(3, 2)*4), 12 - a0*(12/a0)], tol=0.05)
assert sp.simplify(v2 - 12*sp.exp(-2)) == 0 and a0 == 6 and 12/a0 == 2          # constant-decel stop time is 2 s => 0 m/s
dist = sp.integrate((8*sp.exp(-b*t/m)).subs({m: 5, b: 2}), (t, 0, sp.oo)); tau3 = R(5, 2)
first = sp.integrate((8*sp.exp(-t/tau3)), (t, 0, tau3))
assert dist == 20 and sp.simplify(first - 8*tau3*(1 - sp.exp(-1))) == 0 and abs(float(first) - 12.64) < 0.01
vals = [float(dist), float(first), 8*2/5.0]
for val, tx in zip(vals, [V[S+'025-v3']['correct']['text']] + [w['text'] for w in V[S+'025-v3']['wrong']][:2]):
    assert abs(float(re.search(r'\d+(?:\.\d+)?', tx).group()) - val) <= max(0.03*val, 0.06), (tx, val)
assert V[S+'025-v3']['wrong'][2]['text'] == 'Infinite' and sp.limit(sp.integrate(8*sp.exp(-t/tau3), (t, 0, sp.Symbol('T', positive=True))), sp.Symbol('T', positive=True), sp.oo) == 20
# ---- structural / similarity checks ----
W_ = lambda s: set(re.findall(r'[a-z0-9]+', s.lower()))
jac = lambda a, b: len(a & b)/len(a | b)
vtext = lambda v: v['stem'] + ' ' + v['correct']['text'] + ' ' + ' '.join(w['text'] for w in v['wrong'])
stext = lambda s: s['stem'] + ' ' + ' '.join(ch['choice_text'] for ch in s['choices'])
assert len(V) == 18
bad = 0
for id, v in V.items():
    errs = []
    assert len(v['wrong']) == 3 and id.rsplit('-v', 1)[0] == v['seed'] and v['seed'] in seeds
    if re.search(r'(^|\s)[A-D][\.\)]\s', v['stem']) or '\n' in v['stem']: errs.append('option list in stem')
    texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    if len(set(texts)) != 4: errs.append('dup choice')
    ln = [len(q) for q in texts]
    if ln[0] == max(ln) and ln[0] > 1.4*sorted(ln)[-2]: errs.append('key much longer')
    if re.search(r'\b(choice|option|answer) [A-D]\b|\b[A-D] is\b', json.dumps(v)): errs.append('letter mention')
    if any(not q['rationale'].strip() or not q.get('error_pattern', 'x').strip() for q in [v['correct']] + v['wrong']): errs.append('blank')
    if re.search(r'\b(may|might|perhaps|possibly)\b', json.dumps([v['correct']] + v['wrong'])): errs.append('hedging')
    sj = jac(W_(vtext(v)), W_(stext(seeds[v['seed']])))
    if sj >= 0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V.values():
        if o['id'] != id and jac(W_(vtext(v)), W_(vtext(o))) >= 0.7: errs.append('similar ' + o['id'])
    if errs: bad += 1; print('FAIL', id, errs)
    else: print('OK', id, 'seedJ=%.2f' % sj)
assert {v['difficulty'] for v in V.values()} == {'easy', 'medium', 'hard'}
print('ALL OK' if not bad else f'{bad} FAILURES')
