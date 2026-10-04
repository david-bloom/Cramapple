import json, re, os, math
import sympy as sp
d = os.path.dirname(os.path.abspath(__file__))
V = json.load(open(os.path.join(d, 'variants_c3.json')))
byid = {v['id']: v for v in V}
x, t, C = sp.symbols('x t C', positive=True)
xr = sp.symbols('xr', real=True)
pi = sp.pi
SEEDS = {
 'apphycm-mcq-026': "A particle in uniform circular motion has zero acceleration constant velocity vector inward acceleration v²/r outward net force",
 'apphycm-mcq-027': "The work done from x=a to x=b by F(x) is ∫ₐᵇF(x)dx F(b)(b-a) (1/2)[F(a)+F(b)](b-a) always ∫F(t)dt",
 'apphycm-mcq-028': "For U(x)=Ax³, the force is 3Ax² -3Ax² -Ax² -(A/3)x²",
 'apphycm-mcq-029': "At a one-dimensional classical turning point with total energy E, U=0 always U=E and speed is zero force must be zero kinetic energy is maximum",
 'apphycm-mcq-030': "A force F acts on a particle with velocity v. Instantaneous power is F·v F×v Fv regardless of direction F·a"}

# ---- numeric recomputation (all calculus done with sympy); list = [correct, w1, w2, w3] magnitudes/values
E = {}
# 026
E['apphycm-mcq-026-v1'] = [20**2/50, 0, 20/50, 20**2/50]            # last differs only in direction (outward)
v = sp.Rational(1) * 2 * pi * sp.Rational(3, 2) / sp.Rational(1, 2)
m, r, T = 4, sp.Rational(3, 2), sp.Rational(1, 2)
v = 2 * pi * r / T
E['apphycm-mcq-026-v3'] = [float(m * v**2 / r), float(m * v), float(m * 4 * pi**2 * r / T), float(m * v**2 * r)]
# 027
F1 = 3 * x**2
W1 = sp.integrate(F1, (x, 1, 3))
E['apphycm-mcq-027-v1'] = [float(W1), float(F1.subs(x, 3) * 2), float((F1.subs(x, 1) + F1.subs(x, 3)) / 2 * 2), float(sp.integrate(F1, x).subs(x, 3))]
F2 = 8 - 2 * x
W2 = sp.integrate(F2, (x, 0, 6)); Wpos = sp.integrate(F2, (x, 0, 4)); Wneg = sp.integrate(F2, (x, 4, 6))
assert Wpos == 16 and Wneg == -4
E['apphycm-mcq-027-v2'] = [float(W2), float(Wpos), float(Wpos - Wneg), float(F2.subs(x, 6) * 6)]
F3 = 20 * sp.exp(-sp.Rational(1, 2) * x)
W3 = sp.integrate(F3, (x, 0, 2))
E['apphycm-mcq-027-v3'] = [float(W3), float(F3.subs(x, 2) * 2), float(20 * (1 - sp.exp(-1))), float((F3.subs(x, 0) + F3.subs(x, 2)) / 2 * 2)]
# 028 symbolic v1
Ux = C * x**4
assert sp.simplify(-sp.diff(Ux, x) - (-4 * C * x**3)) == 0
assert sp.simplify(-C * x**3 - (-sp.diff(Ux, x))) != 0              # wrong: dropped factor
assert sp.simplify(-4 * C * x**4 - (-sp.diff(Ux, x))) != 0          # wrong: exponent
assert sp.simplify(-sp.integrate(Ux, x) - (-(C / 5) * x**5)) == 0   # wrong: antiderivative
U2 = 3 * x**2 - 2 * x**3
F28 = -sp.diff(U2, x)
E['apphycm-mcq-028-v2'] = [float(F28.subs(x, 2)), float(sp.diff(U2, x).subs(x, 2)), float(U2.subs(x, 2)), float((-(6 * x - 3 * x**2)).subs(x, 2))]
assert F28.subs(x, 2) == 12 and U2.subs(x, 2) == -4
U3 = 4 / x**2
F28c = -sp.diff(U3, x)
E['apphycm-mcq-028-v3'] = [float(F28c.subs(x, sp.Rational(1, 2))), float((4 / x**3).subs(x, sp.Rational(1, 2))), float(U3.subs(x, sp.Rational(1, 2))), float((8 / x**4).subs(x, sp.Rational(1, 2)))]
assert F28c.subs(x, sp.Rational(1, 2)) > 0 and sp.simplify(F28c - 8 / x**3) == 0
# 029 v2
U29 = 2 * x**2
sol = sorted(sp.solve(sp.Eq(2 * xr**2, 8), xr))
assert sol == [-2, 2]
assert abs(math.sqrt(8) - 2.83) < 0.01 and 8 / 2 == 4
assert (-sp.diff(U29, x)).subs(x, 2) == -8 != 0
# 029 v3
U3d = sp.Rational(1, 2) * (x**2 - 4)**2
ET = sp.Rational(9, 2)
assert U3d.subs(x, 2) == 0 and U3d.subs(x, 0) == 8 > ET
pts = sorted(sp.solve(sp.Eq(U3d.subs(x, xr), ET), xr))                       # turning points
fl = [float(p) for p in pts]
assert len(pts) == 4 and abs(fl[0] + math.sqrt(7)) < 1e-9 and abs(fl[1] + 1) < 1e-9 and abs(fl[2] - 1) < 1e-9 and abs(fl[3] - math.sqrt(7)) < 1e-9
assert abs(math.sqrt(7) - 2.65) < 0.005
assert all(U3d.subs(x, s) <= ET for s in [sp.Rational(11, 10), 2, sp.Rational(26, 10)]) and all(U3d.subs(x, s) > ET for s in [0, sp.Rational(1, 2), sp.Rational(9, 10), sp.Rational(27, 10)])
# 030
E['apphycm-mcq-030-v1'] = [50 * 4 * math.cos(math.pi / 3), 50 * 4, 50 * 4 * math.sin(math.pi / 3), 50 * math.cos(math.pi / 3) / 4]
Wt = 2 * t**3
P2 = sp.diff(Wt, t).subs(t, 2)
E['apphycm-mcq-030-v2'] = [float(P2), float(Wt.subs(t, 2) / 2), float(Wt.subs(t, 2)), float((3 * t**2).subs(t, 2))]
mm = 2; Ft = 8 * t
at = Ft / mm; vt = sp.integrate(at, (t, 0, t)); Pt = Ft * vt
assert sp.simplify(vt - 2 * t**2) == 0
tt = sp.Rational(3, 2)
Wint = sp.integrate(Pt, (t, 0, t))
E['apphycm-mcq-030-v3'] = [float(Pt.subs(t, tt)), float((Ft * at.subs(t, tt) * tt).subs(t, tt)), float((Ft * at).subs(t, tt)), float(Wint.subs(t, tt) / tt)]
assert float(Pt.subs(t, tt)) == 54 and float(Wint.subs(t, tt)) == 20.25

# conceptual checks
assert (2 * 1)**2 == 4 and 2**1 != 4                                  # 026-v2: F ~ v^2, doubling -> 4
assert 4 * 0.20 != 0                                                  # 029-v1: spring force k*x nonzero at x=A
# 029-v1: E = U(A) = 1/2 k A^2 with K = 0 at x = A; K+U=E with K=U would need U = E/2 -> x = A/sqrt2 != A
assert abs(0.20 / math.sqrt(2) - 0.20) > 0.01

# ---- text agreement, structure and similarity
SUP = str.maketrans('⁻⁰¹²³⁴⁵⁶⁷⁸⁹', '-0123456789')
def num(txt):
    txt = txt.replace('−', '-').translate(SUP)
    m_ = re.search(r'([+-]?\d+(?:\.\d+)?)', txt)
    return float(m_.group(1))
W = lambda s: set(re.findall(r"[a-z0-9]+", s.lower()))
def jac(a, b): return len(a & b) / len(a | b)
def vtext(v): return v['stem'] + ' ' + v['correct']['text'] + ' ' + ' '.join(w['text'] for w in v['wrong'])
SAME_MAG = {'apphycm-mcq-026-v1', 'apphycm-mcq-028-v2'}                # the one sign/direction-only variant per seed
bad = 0
assert len(V) == 15
assert {v['seed'] for v in V} == set(SEEDS)
for v in V:
    i = v['id']; errs = []
    assert len(v['wrong']) == 3 and i.rsplit('-v', 1)[0] == v['seed']
    texts = [v['correct']['text']] + [w['text'] for w in v['wrong']]
    if re.search(r'(^|\s)[A-D][\.\)]\s', v['stem']): errs.append('option list in stem')
    if i in E:
        for val, txt in zip(E[i], texts):
            if abs(abs(val) - abs(num(txt))) > 0.05 * abs(val) + 0.06 * (abs(val) < 100): errs.append(f'value {val} vs {txt}')
        # signs: only checked where text carries explicit sign
        if len({round(abs(q), 6) for q in E[i]}) < 4 and i not in SAME_MAG: errs.append('computed values not distinct')
    L_ = [len(s) for s in texts]
    if L_[0] == max(L_) and L_[0] > 1.4 * sorted(L_)[-2]: errs.append('key much longer than others')
    if len(set(texts)) != 4: errs.append('dup choice')
    if any(not w['error_pattern'] or not w['rationale'] for w in v['wrong']) or not v['correct']['rationale']: errs.append('missing rationale/error_pattern')
    if re.search(r'\b(choice|option|answer)\s+[A-D]\b|\b[A-D] is\b', json.dumps(v, ensure_ascii=False)): errs.append('letter mention')
    if re.search(r'\b(may|might|possibly|perhaps)\b', ' '.join([v['correct']['rationale']] + [w['rationale'] for w in v['wrong']]), re.I): errs.append('hedging')
    sj = jac(W(vtext(v)), W(SEEDS[v['seed']]))
    if sj >= 0.7: errs.append(f'seed jaccard {sj:.2f}')
    for o in V:
        if o['id'] != i and jac(W(vtext(v)), W(vtext(o))) >= 0.7: errs.append('similar ' + o['id'])
    print(('FAIL ' if errs else 'OK   ') + i, errs if errs else '(seed jac %.2f)' % sj)
    bad += bool(errs)
print('ALL OK' if not bad else f'{bad} FAILURES')
