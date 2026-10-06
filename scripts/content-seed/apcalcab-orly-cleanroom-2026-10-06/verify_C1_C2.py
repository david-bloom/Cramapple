"""Verify items_C1_C2.json (C1/C2, topic 2.1). Recomputes keys and distractors with sympy."""
import json, re, os
import sympy as sp
from sympy.parsing.sympy_parser import parse_expr, standard_transformations, implicit_multiplication_application

HERE = os.path.dirname(os.path.abspath(__file__))
items = {it["key"]: it for it in json.load(open(os.path.join(HERE, "items_C1_C2.json"), encoding="utf-8"))}
T = standard_transformations + (implicit_multiplication_application,)
x = sp.symbols("x")

def parse_val(text):
    s = re.sub(r"\s*cm per second$", "", text.strip())
    s = s.replace("π", "pi").replace("−", "-")
    s = re.sub(r"√(\d+)", r"sqrt(\1)", s)
    return sp.nsimplify(parse_expr(s, transformations=T))

def parse_iv(text):
    a, b = re.fullmatch(r"\[(-?\d+), (-?\d+)\]", text.strip()).groups()
    return (int(a), int(b))

def choices(it):
    assert len(it["choices"]) == 4 and [c["label"] for c in it["choices"]] == list("ABCD")
    assert it["keyed_label"] == "A"
    return {c["label"]: c["text"] for c in it["choices"]}

def eq(a, b):
    return sp.simplify(a - b) == 0

def check_values(key, expected):
    ch = choices(items[key])
    vals = {L: parse_val(ch[L]) for L in "ABCD"}
    for L in "ABCD":
        assert eq(vals[L], expected[L]), (key, L, vals[L], expected[L])
    for L1 in "ABCD":
        for L2 in "ABCD":
            if L1 < L2:
                assert not eq(vals[L1], vals[L2]), (key, "duplicate", L1, L2)
    print("PASS", key, {L: str(v) for L, v in vals.items()})

arc = lambda f, a, b: (f.subs(x, b) - f.subs(x, a)) / (b - a)
P = sp.pi

# C1 v1: f = sin(2x) on [0, pi/4]
f = sp.sin(2 * x); a, b = 0, P / 4
check_values("apcalcab-mcq-orly-c1-v1", {
    "A": arc(f, a, b),
    "B": (f.subs(x, a) - f.subs(x, b)) / (b - a),                     # sign reversed
    "C": f.subs(x, b) - f.subs(x, a),                                 # no divide
    "D": arc(sp.sin(x), a, b),                                        # dropped inner coefficient
})

# C1 v2: g = 3cos(2x)+1 on [pi/6, 5pi/6]; endpoint values equal, g not constant
g = 3 * sp.cos(2 * x) + 1; a, b = P / 6, 5 * P / 6
dg = sp.diff(g, x)
assert eq(g.subs(x, a), g.subs(x, b)) and not eq(g.subs(x, P / 2), g.subs(x, a))
check_values("apcalcab-mcq-orly-c1-v2", {
    "A": arc(g, a, b),
    "B": dg.subs(x, a),                                               # derivative at left endpoint
    "C": dg.subs(x, b),                                               # derivative at right endpoint
    "D": arc(3 * sp.cos(x) + 1, a, b),                                # dropped inner coefficient
})
assert arc(g, a, b) == 0

# C1 v3: h = 12 + 5 sin(2t) on [pi/6, pi/2] (context, units cm/s)
h = 12 + 5 * sp.sin(2 * x); a, b = P / 6, P / 2
check_values("apcalcab-mcq-orly-c1-v3", {
    "A": arc(h, a, b),
    "B": sp.diff(h, x).subs(x, (a + b) / 2),                          # derivative at midpoint
    "C": (h.subs(x, a) - h.subs(x, b)) / (b - a),                     # sign reversed
    "D": h.subs(x, b) - h.subs(x, a),                                 # no divide
})
assert all("cm per second" in c["text"] for c in items["apcalcab-mcq-orly-c1-v3"]["choices"])

# C1 family requirements
c1A = {k: parse_val(choices(items[k])["A"]) for k in items if "-c1-" in k}
assert any(v == 0 for v in c1A.values()), "C1 needs a zero answer"
assert any(sp.denom(sp.together(v)).has(sp.pi) for v in c1A.values()), "C1 needs pi in denominator"

# ---- C2 interval items ----
def check_intervals(key, fval, pick, mis):
    """fval: dict point->exact value. pick: max or min. mis: label -> misconception metric name."""
    ch = choices(items[key])
    ivs = {L: parse_iv(ch[L]) for L in "ABCD"}
    assert len(set(ivs.values())) == 4, (key, "duplicate intervals")
    metrics = {
        "rate": lambda a, b: sp.Rational(fval[b] - fval[a]) / (b - a) if not isinstance(fval[a], sp.Basic) else (fval[b] - fval[a]) / (b - a),
        "right": lambda a, b: fval[b],
        "divb": lambda a, b: (fval[b] - fval[a]) / sp.Integer(b),
        "neg": lambda a, b: ((fval[b] + fval[a]) if fval[a] < 0 else (fval[b] - fval[a])) / sp.Integer(b - a),
        "mean": lambda a, b: (fval[a] + fval[b]) / sp.Integer(2),
    }
    def unique_best(metric):
        vals = {L: sp.nsimplify(metrics[metric](*ivs[L])) for L in "ABCD"}
        best = pick(vals.values())
        winners = [L for L in "ABCD" if eq(vals[L], best)]
        assert len(winners) == 1, (key, metric, vals)
        return winners[0], vals
    w, rates = unique_best("rate")
    assert w == "A", (key, "keyed not unique best", rates)
    for L, m in mis.items():
        wm, vals = unique_best(m)
        assert wm == L, (key, L, m, vals)
    print("PASS", key, {L: (ivs[L], str(rates[L])) for L in "ABCD"})
    return ivs

# C2 v1: table
tab = {0: 1, 2: 10, 3: 16, 5: 28, 7: 24, 9: 26}
stem = items["apcalcab-mcq-orly-c2-v1"]["stem"]
assert "x: 0, 2, 3, 5, 7, 9" in stem and "f(x): 1, 10, 16, 28, 24, 26" in stem
check_intervals("apcalcab-mcq-orly-c2-v1", {k: sp.Integer(v) for k, v in tab.items()}, max,
                {"B": "divb", "C": "right", "D": "mean"})

# C2 v2: f = x^3 - 6x, negative left-endpoint value
f2 = x**3 - 6 * x
fv = {k: f2.subs(x, k) for k in range(0, 6)}
ivs = check_intervals("apcalcab-mcq-orly-c2-v2", fv, max, {"B": "neg", "C": "divb", "D": "mean"})
assert fv[ivs["A"][0]] < 0, "keyed interval should have negative left-endpoint value"

# C2 v3: V = 40 sqrt(t+1) - 4t, context, least
V = 40 * sp.sqrt(x + 1) - 4 * x
fv = {k: V.subs(x, k) for k in (0, 3, 8, 15, 24, 35)}
assert all(v.is_Integer for v in fv.values())
check_intervals("apcalcab-mcq-orly-c2-v3", fv, min, {"B": "right", "C": "divb", "D": "mean"})

# shared checks
for it in items.values():
    assert set(it["rationales"]) == set("ABCD") and set(it["misconception_map"]) == set("BCD")
    for L in "BCD":
        txt = choices(it)[L]
        core = re.sub(r"\s*cm per second$", "", txt)
        assert core in it["rationales"][L] or txt in it["rationales"][L], (it["key"], L, "rationale must reproduce choice")
    assert not re.search(r"\(A\)|\bA\)", it["stem"])
print("ALL CHECKS PASSED (6 items)")
