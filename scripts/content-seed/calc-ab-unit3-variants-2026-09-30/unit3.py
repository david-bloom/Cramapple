#!/usr/bin/env python3
"""Unit 3 seeded variants (2026-09-30). Seeds: 005, 007, 030, 008 (029 was done in the pilot). Seeds were audited first (S0a):
all four had distractor-rationale defects (see ../calc-ab-seed-audit-2026-09-30/AUDIT_REPORT.md), keys correct. Variants are written from
the seed's problem structure with fully re-derived rationales; the seed defects are not copied. Usage: python3 unit3.py check | export <math.json> <ced.json>"""
import itertools, json, re, secrets, sys
sys.path.insert(0, "../calc-ab-pilot-2026-09-30")
import sympy as sp
from sympy import symbols, diff, exp, cos, sin, sqrt, Rational, S, idiff
from pilot import same, jaccard
x = symbols("x", real=True); y = symbols("y", real=True)

SEEDS = {
 "apcalcab-mcq-005": ("Find d/dx [e^(2x) sin x].", ["e^(2x)(2 sin x+cos x)", "2e^(2x) cos x", "e^(2x)(sin x+2 cos x)", "2e^x sin x"]),
 "apcalcab-mcq-007": ("Find d/dx √(1+x³).", ["3x²/(2√(1+x³))", "3x²√(1+x³)", "1/(2√(1+x³))", "3x/(2√(1+x³))"]),
 "apcalcab-mcq-030": ("For the curve x²+y²=25, what is dy/dx at (3,4)?", ["−3/4", "−4/3", "3/4", "4/3"]),
 "apcalcab-mcq-008": ("On x²+xy+y²=7, what is dy/dx at (1,2)?", ["−4/5", "−5/4", "4/5", "5/4"]),
}
V = []
def add(vid, seed, diff_, title, stem, stimulus, correct, wrong, key_calc, wrong_calcs, change):
    V.append(dict(id=vid, seed=seed, diff=diff_, title=title, stem=stem, stimulus=stimulus, correct=correct, wrong=wrong,
                  key_calc=key_calc, wrong_calcs=wrong_calcs, change=change))

# ---- 005: product rule with a chain-rule factor
add("005-v1", "apcalcab-mcq-005", "medium", "Signal Decay With a Cosine Carrier",
    "A signal is modeled by S(x) = e^(3x) cos x. What is S'(x)?", None,
    ("e^(3x)(3cos(x) - sin(x))", "By the product rule with the chain rule on e^(3x): S'(x) = 3e^(3x) cos x + e^(3x)(-sin x) = e^(3x)(3 cos x - sin x)."),
    [("-3e^(3x) sin(x)", "Multiplies the derivatives of the two factors, 3e^(3x) and -sin x, instead of applying the product rule."),
     ("e^(3x)(cos(x) - 3sin(x))", "Attaches the factor 3 to the wrong term: the 3 comes from differentiating e^(3x), which multiplies cos x, not sin x."),
     ("3e^x cos(x)", "Writes the derivative of e^(3x) as 3e^x, changing the exponent 3x to x, and omits the second product-rule term.")],
    lambda: same(diff(exp(3 * x) * cos(x), x), "e^(3x)(3cos(x) - sin(x))"),
    [lambda: same(diff(exp(3 * x), x) * diff(cos(x), x), "-3e^(3x) sin(x)"), lambda: same(exp(3 * x) * (cos(x) - 3 * sin(x)), "e^(3x)(cos(x) - 3sin(x))"),
     lambda: same(3 * exp(x) * cos(x), "3e^x cos(x)")], "2x -> 3x, sin -> cos (sign enters); context: signal")
add("005-v2", "apcalcab-mcq-005", "medium", "Concentration Times a Decaying Exponential",
    "A concentration is modeled by C(x) = x^2 e^(-x). What is C'(x)?", None,
    ("e^(-x)(2x - x^2)", "By the product rule with the chain rule on e^(-x): C'(x) = 2x e^(-x) + x^2(-e^(-x)) = e^(-x)(2x - x^2)."),
    [("-2x e^(-x)", "Multiplies the derivatives of the two factors, 2x and -e^(-x), instead of applying the product rule."),
     ("e^(-x)(2x + x^2)", "Loses the negative sign from the chain rule on e^(-x) in the second product-rule term."),
     ("2x e^(-x)", "Omits the second product-rule term x^2(-e^(-x)).")],
    lambda: same(diff(x**2 * exp(-x), x), "e^(-x)(2x - x^2)"),
    [lambda: same(diff(x**2, x) * diff(exp(-x), x), "-2x e^(-x)"), lambda: same(exp(-x) * (2 * x + x**2), "e^(-x)(2x + x^2)"),
     lambda: same(2 * x * exp(-x), "2x e^(-x)")], "trig factor -> power factor; exponent 2x -> -x (negative chain factor); context: concentration")

# ---- 007: chain rule with a radical
add("007-v1", "apcalcab-mcq-007", "medium", "Rate of a Radical Response",
    "A response is modeled by R(x) = √(4x^2 + 9). What is R'(x)?", None,
    ("4x/√(4x^2+9)", "By the chain rule, R'(x) = 1/(2√(4x^2+9)) times the inner derivative 8x, which simplifies to 4x/√(4x^2+9)."),
    [("8x√(4x^2+9)", "Multiplies the inner derivative 8x by √(4x^2+9) instead of by the derivative of the square root, 1/(2√(4x^2+9))."),
     ("1/(2√(4x^2+9))", "Omits the inner derivative 8x."),
     ("2x/√(4x^2+9)", "Differentiates the inner function 4x^2 as 4x instead of 8x, then simplifies (4x)/(2√(4x^2+9)).")],
    lambda: same(diff(sqrt(4 * x**2 + 9), x), "4x/√(4x^2+9)"),
    [lambda: same(8 * x * sqrt(4 * x**2 + 9), "8x√(4x^2+9)"), lambda: same(1 / (2 * sqrt(4 * x**2 + 9)), "1/(2√(4x^2+9))"),
     lambda: same(4 * x / (2 * sqrt(4 * x**2 + 9)), "2x/√(4x^2+9)")], "1+x^3 -> 4x^2+9; inner coefficient makes simplification a step; context: response")
add("007-v2", "apcalcab-mcq-007", "medium", "Cube-Root Growth Index",
    "An index is modeled by G(x) = (1 + x^4)^(1/3). What is G'(x)?", None,
    ("4x^3/(3(1+x^4)^(2/3))", "By the chain rule, G'(x) = (1/3)(1+x^4)^(-2/3) times the inner derivative 4x^3, which is 4x^3/(3(1+x^4)^(2/3))."),
    [("4x^3/(3(1+x^4)^(1/3))", "Negates the exponent 1/3 to -1/3 instead of reducing it by 1 to -2/3 when applying the power rule."),
     ("1/(3(1+x^4)^(2/3))", "Omits the inner derivative 4x^3."),
     ("4x^3(1+x^4)^(2/3)/3", "Uses the exponent +2/3 instead of -2/3 after reducing the power.")],
    lambda: same(diff((1 + x**4) ** Rational(1, 3), x), "4x^3/(3(1+x^4)^(2/3))"),
    [lambda: same(4 * x**3 / (3 * (1 + x**4) ** Rational(1, 3)), "4x^3/(3(1+x^4)^(1/3))"), lambda: same(1 / (3 * (1 + x**4) ** Rational(2, 3)), "1/(3(1+x^4)^(2/3))"),
     lambda: same(4 * x**3 * (1 + x**4) ** Rational(2, 3) / 3, "4x^3(1+x^4)^(2/3)/3")], "square root -> cube root (fractional exponent); x^3 -> x^4; context: index")

# ---- 030: implicit differentiation of a circle
def slope(F, pt):
    return idiff(F, y, x).subs({x: pt[0], y: pt[1]})
add("030-v1", "apcalcab-mcq-030", "medium", "Slope on a Circular Boundary",
    "The boundary of a circular field satisfies x^2 + y^2 = 169. What is dy/dx at the point (5, 12)?", None,
    ("-5/12", "Differentiating implicitly gives 2x + 2y(dy/dx) = 0, so dy/dx = -x/y. At (5, 12) this is -5/12."),
    [("-12/5", "Uses -y/x instead of -x/y, which is the reciprocal of the correct slope."),
     ("5/12", "Drops the negative sign when solving for dy/dx."),
     ("12/5", "Interchanges x and y and drops the negative sign.")],
    lambda: same(slope(x**2 + y**2 - 169, (5, 12)), "-5/12"),
    [lambda: same(-Rational(12, 5), "-12/5"), lambda: same(Rational(5, 12), "5/12"), lambda: same(Rational(12, 5), "12/5")], "radius 5 -> 13; point (3,4) -> (5,12); context: field boundary")
add("030-v2", "apcalcab-mcq-030", "medium", "Slope on a Circle at a Negative x-Value",
    "A curve satisfies x^2 + y^2 = 50. What is dy/dx at the point (-1, 7)?", None,
    ("1/7", "Differentiating implicitly gives 2x + 2y(dy/dx) = 0, so dy/dx = -x/y. At (-1, 7) this is -(-1)/7 = 1/7."),
    [("-1/7", "Substitutes x = -1 as if it were +1, giving -x/y = -1/7 instead of -(-1)/7 = 1/7."),
     ("7", "Uses -y/x instead of -x/y: -7/(-1) = 7, the reciprocal of the correct slope."),
     ("-7", "Uses y/x instead of -x/y.")],
    lambda: same(slope(x**2 + y**2 - 50, (-1, 7)), "1/7"),
    [lambda: same(-Rational(1, 7), "-1/7"), lambda: same(-7 / S(-1), "7"), lambda: same(Rational(7, -1), "-7")], "negative x-coordinate flips the sign; context: none")

# ---- 008: implicit differentiation with an xy term
add("008-v1", "apcalcab-mcq-008", "medium", "Slope on a Cross-Term Curve",
    "A curve is given by x^2 + 3xy - y^2 = 9. What is dy/dx at the point (2, 1)?", None,
    ("-7/4", "Differentiating gives 2x + 3y + 3x(dy/dx) - 2y(dy/dx) = 0, so dy/dx = -(2x + 3y)/(3x - 2y). At (2, 1) this is -7/4."),
    [("7/4", "Loses the negative sign when moving 2x + 3y to the other side."),
     ("-4/7", "Inverts the fraction, using -(3x - 2y)/(2x + 3y)."),
     ("7/2", "Omits the term 3x(dy/dx) from the product rule on 3xy, leaving (2x + 3y)/(2y).")],
    lambda: same(slope(x**2 + 3 * x * y - y**2 - 9, (2, 1)), "-7/4"),
    [lambda: same(Rational(7, 4), "7/4"), lambda: same(-Rational(4, 7), "-4/7"), lambda: same(Rational(2 * 2 + 3 * 1, 2 * 1), "7/2")], "x^2+xy+y^2=7 -> x^2+3xy-y^2=9; point (1,2) -> (2,1)")
add("008-v2", "apcalcab-mcq-008", "medium", "Slope on a Conic With a Cross Term",
    "A curve is given by 2x^2 - xy + y^2 = 8. What is dy/dx at the point (1, 3)?", None,
    ("-1/5", "Differentiating gives 4x - y - x(dy/dx) + 2y(dy/dx) = 0, so dy/dx = (y - 4x)/(2y - x). At (1, 3) this is (3 - 4)/(6 - 1) = -1/5."),
    [("1/5", "Loses the sign when solving, giving (4x - y)/(2y - x)."),
     ("-5", "Inverts the fraction, using (2y - x)/(y - 4x)."),
     ("-1/6", "Omits the term -x(dy/dx) from the product rule on -xy, leaving 4x - y + 2y(dy/dx) = 0 and dy/dx = (y - 4x)/(2y).")],
    lambda: same(slope(2 * x**2 - x * y + y**2 - 8, (1, 3)), "-1/5"),
    [lambda: same(Rational(4 * 1 - 3, 2 * 3 - 1), "1/5"), lambda: same(Rational(2 * 3 - 1, 3 - 4), "-5"), lambda: same(Rational(3 - 4 * 1, 2 * 3), "-1/6")],
    "different coefficients and a subtraction cross term; point (1,3)")

def vt(v): return v["stem"] + " " + " ".join([v["correct"][0]] + [w[0] for w in v["wrong"]])
def check():
    fails = []
    for v in V:
        for name, fn, txt in [("key", v["key_calc"], v["correct"][0])] + [(f"distractor {i}", w, v["wrong"][i][0]) for i, w in enumerate(v["wrong_calcs"]) if w]:
            try:
                got = fn()
                if got != txt: fails.append(f"{v['id']} {name}: {got!r} != {txt!r}")
            except Exception as e: fails.append(f"{v['id']} {name} raised {e}")
        if len({t[0].lower() for t in [v['correct']] + v['wrong']}) != 4: fails.append(f"{v['id']}: duplicate choices")
        st, sc = SEEDS[v["seed"]]; j = jaccard(vt(v), st + " " + " ".join(sc))
        if j >= 0.7: fails.append(f"{v['id']}: similar to seed {j:.2f}")
    for a, b in itertools.combinations(V, 2):
        if a["seed"] == b["seed"] and jaccard(vt(a), vt(b)) >= 0.7: fails.append(f"{a['id']}/{b['id']} similar")
    print("FAILED:" if fails else f"OK: {len(V)} variants verified")
    for f in fails: print("  -", f)
    return 1 if fails else 0

def export(mo, co):
    rng = secrets.SystemRandom(); L = "ABCD"; rows = []; ced = []
    for v in V:
        ch = [(v["correct"][0], v["correct"][1], True)] + [(w[0], w[1], False) for w in v["wrong"]]; rng.shuffle(ch)
        key = f"u3-{v['id']}"
        rows.append(dict(key=key, kind="mcq", stem=v["stem"], choices=[dict(label=L[i], text=c[0]) for i, c in enumerate(ch)],
                         keyed_label=next(L[i] for i, c in enumerate(ch) if c[2]), rationales={L[i]: c[1] for i, c in enumerate(ch)}))
        ced.append(dict(content_key=key, item_type="mcq", stem=v["stem"], stimulus=v["stimulus"],
                        criteria=[f"{L[i]}." + (" (correct)" if c[2] else "") + f" {c[0]}" for i, c in enumerate(ch)]))
    json.dump(rows, open(mo, "w"), indent=1); json.dump(ced, open(co, "w"), indent=1); print(len(rows), "exported")

if __name__ == "__main__":
    if sys.argv[1] == "check": sys.exit(check())
    if sys.argv[1] == "export":
        rc = check()
        if rc == 0: export(sys.argv[2], sys.argv[3])
        sys.exit(rc)
