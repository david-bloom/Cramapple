#!/usr/bin/env python3
"""Verify seeds_u3n.json: every choice text is parsed with sympy and compared with an
independently computed value; structural rules are checked too. Prints OK per question."""
import json, os, re, sys
import sympy as sp
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application

HERE = os.path.dirname(os.path.abspath(__file__))
seeds = json.load(open(os.path.join(HERE, "seeds_u3n.json")))
by = {s["key"]: s for s in seeds}
x, y = sp.symbols("x y")
T = standard_transformations + (implicit_multiplication_application,)
SUP = {"²": "**2", "³": "**3", "⁴": "**4", "⁵": "**5", "⁻¹": "**(-1)"}

def parse(t):
    t = t.replace("−", "-").replace("·", "*").replace("^", "**")
    for k, v in SUP.items():
        t = t.replace(k, v)
    t = re.sub(r"√(\d+)", r"sqrt(\1)", t).replace("√(", "sqrt(").replace("ln(", "log(")
    t = re.sub(r"(?<![A-Za-z])e(?![A-Za-z])", "E", t)
    return parse_expr(t, local_dict={"x": x, "E": sp.E}, transformations=T)

def same(a, b):
    return sp.simplify(sp.sympify(a) - sp.sympify(b)) == 0

def texts(s):
    return s["correct"]["text"], [w["text"] for w in s["wrong"]]

def check(key, expected_correct, expected_wrong):
    c, ws = texts(by[key])
    assert same(parse(c), expected_correct), (key, "correct", c, expected_correct)
    got = [parse(w) for w in ws]
    assert len(expected_wrong) == 3
    for e in expected_wrong:
        assert any(same(g, e) for g in got), (key, "missing wrong value", e, ws)
    for g in got:
        assert not same(g, expected_correct), (key, "wrong equals correct", g)

R = sp.Rational
# ---- Q1
f = (3*x**2 - 5)**4
check("apcalcab-mcq-u3n-001", sp.diff(f, x), [4*(3*x**2-5)**3, 4*(6*x)**3, 24*x*(3*x**2-5)**4])
# ---- Q2
f = sp.exp(3*x**2 - x); assert f.subs(x, 1) == sp.E**2
u = 3*x**2 - x; up = sp.diff(u, x)
check("apcalcab-mcq-u3n-002", sp.diff(f, x).subs(x, 1),
      [sp.exp(u).subs(x, 1), (u*sp.exp(u)).subs(x, 1), (up*sp.exp(up)).subs(x, 1)])
# ---- Q3 (table)
F = {2: (6, 4), 3: (1, 5)}; G = {2: (3, -2), 3: (7, 0)}
h2 = F[G[2][0]][1] * G[2][1]
check("apcalcab-mcq-u3n-003", h2, [F[2][1]*G[2][1], F[G[2][0]][1], F[3][1]*G[2][0]])
assert h2 == -10
# ---- Q4
L = sp.log(x**2 + 1); f = sp.sqrt(L)
check("apcalcab-mcq-u3n-004", sp.diff(f, x),
      [1/(2*(x**2+1)*sp.sqrt(L)), x/sp.sqrt(L), 2*x/((x**2+1)*sp.sqrt(L))])
# ---- Q5: x^2 y = 12 at (2,3)
yy = sp.Function("yy")
eq = x**2*yy(x) - 12
d = sp.solve(sp.diff(eq, x), sp.diff(yy(x), x))[0].subs(yy(x), 3).subs(x, 2)
assert (2**2)*3 == 12
# wrong: sign error, missing y in product rule, no division by x^2
check("apcalcab-mcq-u3n-005", d, [-d, -2*2/R(2**2), -2*2*3])
# ---- Q6: x y + ln y = 2 at (2,1)
yp = sp.symbols("yp")
assert 2*1 + sp.log(1) == 2
eq = 1 + 2*yp + yp/1             # y + x y' + y'/y at (2,1)
d = sp.solve(eq, yp)[0]
check("apcalcab-mcq-u3n-006", d, [sp.solve(1 + 2*yp + 1, yp)[0], sp.solve(2*yp + yp, yp)[0], sp.solve(1 + 3*yp - 2, yp)[0]])
# ---- Q7: x^2 - x y + y^2 = 3, vertical tangent in first quadrant
Y = sp.Function("Y")
curve = x**2 - x*Y(x) + Y(x)**2 - 3
dydx = sp.solve(sp.diff(curve, x), sp.diff(Y(x), x))[0]
num = sp.numer(sp.together(dydx.subs(Y(x), y))); den = sp.denom(sp.together(dydx.subs(Y(x), y)))
sols = sp.solve([x**2 - x*y + y**2 - 3, den], [x, y], dict=True)
first = [s for s in sols if s[x] > 0 and s[y] > 0]
assert first == [{x: 2, y: 1}], first
assert sp.simplify(num.subs({x: 2, y: 1})) != 0
c = by["apcalcab-mcq-u3n-007"]
def pt(t):
    return tuple(parse(p) for p in t.strip("()").replace("√3", "sqrt(3)").split(","))
cv = lambda a, b: sp.simplify(a**2 - a*b + b**2 - 3) == 0
assert pt(c["correct"]["text"]) == (2, 1)
wp = [tuple(sp.sympify(v) for v in pt(w["text"])) for w in c["wrong"]]
assert set(wp) == {(1, 2), (4, 2), (sp.sqrt(3), sp.sqrt(3))}, wp
assert cv(1, 2) and sp.simplify(dydx.subs({x: 1, Y(x): 2})) == 0          # horizontal
assert not cv(4, 2)                                                      # not on curve
assert cv(sp.sqrt(3), sp.sqrt(3)) and sp.simplify(dydx.subs({x: sp.sqrt(3), Y(x): sp.sqrt(3)})) == -1
# ---- Q8 table
fx = {1: (2, 3), 2: (5, 4), 3: (8, 6), 5: (9, 7)}
inv5 = [k for k, v in fx.items() if v[0] == 5][0]
check("apcalcab-mcq-u3n-008", R(1, fx[inv5][1]), [fx[2][1], R(1, fx[5][1]), R(1, 5)])
# ---- Q9
f = x**3 + 2*x + 1; assert f.subs(x, 1) == 4 and sp.diff(f, x) == 3*x**2 + 2
check("apcalcab-mcq-u3n-009", R(1, sp.diff(f, x).subs(x, 1)),
      [sp.diff(f, x).subs(x, 1), R(1, sp.diff(f, x).subs(x, 4)), R(1, 4)])
# ---- Q10
f = sp.asin(2*x); a = R(1, 4)
check("apcalcab-mcq-u3n-010", sp.diff(f, x).subs(x, a),
      [(1/sp.sqrt(1-4*x**2)).subs(x, a), (2/(1-4*x**2)).subs(x, a), (2/sp.sqrt(1+4*x**2)).subs(x, a)])
# ---- Q11
f = sp.atan(5*x)
check("apcalcab-mcq-u3n-011", sp.diff(f, x), [1/(1+25*x**2), 5/(1+5*x**2), 5/sp.sqrt(1-25*x**2)])
# ---- Q12 conceptual: f = x^2 ln(5x+1); structure checks
f = x**2*sp.log(5*x+1)
assert sp.simplify(sp.diff(f, x) - (2*x*sp.log(5*x+1) + 5*x**2/(5*x+1))) == 0
assert sp.simplify(sp.diff(f, x) - (2*x*sp.log(5*x+1) + x**2/(5*x+1))) != 0   # product-only drops the 5
# ---- Q13
f = sp.exp(2*x)/(x+1)
check("apcalcab-mcq-u3n-013", sp.diff(f, x).subs(x, 1),
      [-3*sp.E**2/4, sp.E**2/4, 3*sp.E**2/2])
assert same(sp.diff(f, x).subs(x, 1), 3*sp.E**2/4)
assert same((sp.exp(2)*2 - sp.exp(2))/4, sp.E**2/4)            # no chain factor
assert same((sp.exp(2) - 2*sp.exp(2)*2)/4, -3*sp.E**2/4)       # reversed numerator
# ---- Q14 conceptual
f = x**2*sp.exp(3*x)
assert same(sp.diff(f, x), 2*x*sp.exp(3*x) + x**2*3*sp.exp(3*x))
assert not same(sp.diff(f, x), 6*x*sp.exp(3*x))                # student's answer is wrong
assert same(sp.diff(x**2, x), 2*x) and same(sp.diff(sp.exp(3*x), x), 3*sp.exp(3*x))  # factors were right
# ---- Q15
f = sp.exp(-x**2); f2 = sp.diff(f, x, 2)
assert same(f2, (4*x**2-2)*sp.exp(-x**2))
check("apcalcab-mcq-u3n-015", f2.subs(x, 1), [-2/sp.E, -4/sp.E, 4/sp.E])
assert same(((-2*sp.exp(-x**2)) - 2*x*sp.exp(-x**2)).subs(x, 1), -4/sp.E)

# ---- structural checks
quota = {"3.1": 4, "3.2": 3, "3.3": 2, "3.4": 2, "3.5": 3, "3.6": 1}
diffs = {"easy": 5, "medium": 7, "hard": 3}
from collections import Counter
assert len(seeds) == 15
assert Counter(s["topic"] for s in seeds) == quota
assert Counter(s["difficulty"] for s in seeds) == diffs
assert [s["key"] for s in seeds] == [f"apcalcab-mcq-u3n-{i:03d}" for i in range(1, 16)]
for s in seeds:
    assert not re.search(r"(^|\n)\s*[A-D][\.\)]\s", s["stem"]), s["key"]
    assert len(s["wrong"]) == 3
    allt = [s["correct"]["text"]] + [w["text"] for w in s["wrong"]]
    assert len(set(allt)) == 4, s["key"]
    mw = max(len(w["text"]) for w in s["wrong"])
    if mw >= 8:   # bare-number options (e.g. "5", "−10") are exempt from the length ratio
        assert len(s["correct"]["text"]) <= 1.4 * mw, (s["key"], "length")
    for ch in [s["correct"]] + s["wrong"]:
        assert ch["rationale"].strip(), s["key"]
    print("OK", s["key"], s["topic"], s["difficulty"])
print("ALL OK")
