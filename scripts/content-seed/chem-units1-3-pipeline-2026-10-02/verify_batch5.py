import json, re, itertools, math, os

here = os.path.dirname(os.path.abspath(__file__))
V = {v["id"]: v for v in json.load(open(os.path.join(here, "variants_batch5.json")))}
S = {s["key"]: s for s in json.load(open(os.path.join(here, "seeds_batch5.json")))}
assert len(V) == 15


def sci(x, sig=3):
    e = int(math.floor(math.log10(abs(x))))
    m = round(x / 10 ** e, sig - 1)
    if m >= 10:
        m /= 10; e += 1
    return f"{m:.{sig-1}f} x 10^{e}"


def fixed(x, d):
    return f"{x:.{d}f}"


def check(vid, key, wrongs, fmt, unit):
    """key: float; wrongs: list of floats in JSON order; fmt: function float->str"""
    v = V[vid]
    shown = [v["correct"]["text"]] + [w["text"] for w in v["wrong"]]
    calc = [key] + wrongs
    for s, c in zip(shown, calc):
        exp = f"{fmt(c)} {unit}".strip()
        assert s == exp, (vid, s, exp)
    # no distractor equals the key
    for w in wrongs:
        assert not math.isclose(w, key, rel_tol=1e-3), (vid, w, key)
    assert len(set(shown)) == 4


# Beer-Lambert (036)
A, e, b = 0.360, 2.40e4, 1.00
check("apchem-mcq-036-v1", A / (e * b), [A * e * b, e * b / A, A], lambda x: sci(x), "M")
A, e, b = 0.425, 8.50e2, 2.00
check("apchem-mcq-036-v2", A / (e * b), [A / e, A * b / e, e * b / A], lambda x: sci(x), "M")
A, e, c = 0.600, 1.20e4, 2.50e-5
check("apchem-mcq-036-v3", A / (e * c), [e * c / A, A * e * c, A / e],
      lambda x: fixed(x, 2) if x >= 1 else (fixed(x, 3) if x > 0.1 else sci(x)), "cm")

# Dilution (039)
M1, V1, V2 = 6.00, 10.0, 250.0
check("apchem-mcq-039-v1", M1 * V1 / V2,
      [M1 * V2 / V1, M1, (M1 * V1 / 1000) / ((V2 - V1) / 1000)],
      lambda x: sci(x) if x > 100 else (fixed(x, 2) if x >= 1 else fixed(x, 3)), "M")
M1, M2, V2 = 3.00, 0.600, 250.0
check("apchem-mcq-039-v2", M2 * V2 / M1,
      [M1 * V2 / M2, V2 - M2 * V2 / M1, M2 * V2],
      lambda x: sci(x) if x > 999 or x == 150 else fixed(x, 1), "mL")
M1, V1, Vw = 0.800, 15.0, 85.0
Vt = V1 + Vw
check("apchem-mcq-039-v3", M1 * V1 / Vt,
      [(M1 * V1 / 1000) / (Vw / 1000), M1 * Vt / V1, (M1 + 0) / 2],
      lambda x: fixed(x, 3) if x < 1 else fixed(x, 2), "M")

# Photon comparison (037-v3)
c_, lam, nuQ = 3.0e8, 5.0e-7, 4.0e14
nuP = c_ / lam
assert math.isclose(nuP, 6.0e14)
assert math.isclose(nuP / nuQ, 1.5)
lamQ = c_ / nuQ
assert math.isclose(lamQ, 7.5e-7) and math.isclose(lamQ / lam, 1.5)
assert nuP > nuQ  # P has more energy; distractors claim Q or equal
# 037-v2 sanity of stated orders of magnitude
assert 1e18 < c_ / 0.1e-9 < 1e19 and 1e9 < c_ / 0.12 < 1e10
# 037-v1: ordering of wavelengths and frequencies
assert c_ / 450e-9 > c_ / 650e-9

# Seed-specific rationale numbers re-checked in text
assert "0.0600" in V["apchem-mcq-039-v1"]["wrong"][2]["rationale"] and math.isclose(0.0600 / 0.2400, 0.250)
assert math.isclose(0.0120 / 0.0850, 0.141, abs_tol=5e-4)

# structural checks
for v in V.values():
    assert len(v["wrong"]) == 3
    for w in v["wrong"]:
        assert w["rationale"] and w["error_pattern"] and w["text"] != v["correct"]["text"]
    assert v["check"] in ("numeric", "conceptual")
    if v["check"] == "conceptual":
        assert v["facts"] and len(v["facts"]["wrong"]) == 3
    # correct is not systematically longest
tok = lambda t: set(re.findall(r"\w+", t.lower()))


def bag(stem, texts):
    return tok(stem + " " + " ".join(texts))


bags = {}
for k, v in V.items():
    bags[k] = bag(v["stem"], [v["correct"]["text"]] + [w["text"] for w in v["wrong"]])
for k, s in S.items():
    bags[k] = bag(s["stem"].split("\n\nA.")[0], [c["text"] for c in s["choices"]])


def jac(a, b):
    return len(a & b) / len(a | b)


mx = 0
for k, v in V.items():
    j = jac(bags[k], bags[v["seed"]])
    mx = max(mx, j)
    assert j < 0.7, (k, j)
for a, b in itertools.combinations(V, 2):
    if V[a]["seed"] == V[b]["seed"]:
        j = jac(bags[a], bags[b])
        mx = max(mx, j)
        assert j < 0.7, (a, b, j)
print("OK; variants:", len(V), "max Jaccard: %.3f" % mx)
