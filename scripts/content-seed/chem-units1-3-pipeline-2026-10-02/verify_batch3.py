import json, re, itertools, math, os
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
V = {v["id"]: v for v in json.load(open(os.path.join(HERE, "variants_batch3.json")))}
S = {s["key"]: s for s in json.load(open(os.path.join(HERE, "seeds_batch3.json")))}
assert len(V) == 15

def num(text):
    m = re.match(r"\s*([0-9.]+)", text)
    return float(m.group(1))

def shown_decimals(text):
    tok = re.match(r"\s*([0-9.]+)", text).group(1)
    return len(tok.split(".")[1]) if "." in tok else 0

def check(vid, key_val, wrong_vals):
    v = V[vid]
    texts = [v["correct"]["text"]] + [w["text"] for w in v["wrong"]]
    vals = [key_val] + wrong_vals
    assert len(vals) == 4
    for t, x in zip(texts, vals):
        d = shown_decimals(t)
        assert round(x, d) == round(num(t), d), (vid, t, x)
    shown = [num(t) for t in texts]
    assert len(set(shown)) == 4, vid
    for w in vals[1:]:
        assert round(w, 6) != round(vals[0], 6), (vid, "distractor equals key")

# 005-v3: speed ratio from equal KE, M(H2)=2.0, M(O2)=32
mH, mO = 2.0, 32.0
key = math.sqrt(mO / mH)
assert key == 4.0
v3 = V["apchem-mcq-005-v3"]
assert v3["correct"]["text"].startswith("H₂ particles are 4 times")
assert str(int(mO / mH)) in v3["wrong"][0]["text"]            # no sqrt -> 16
assert mO / mH == 16.0
assert math.sqrt(mH / mO) == 0.25 and "one-fourth" in v3["wrong"][1]["text"]  # inverted
assert "same average speed" in v3["wrong"][2]["text"]          # speed ratio 1

# 006-v1
check("apchem-mcq-006-v1", 0.80 / 4, [0.80 / 2, 0.80, 0.80 * 4])
# 006-v2: A proportional to b
check("apchem-mcq-006-v2", 0.45 * (2.0 / 1.0), [0.45 / 2.0, 0.45, 0.45 + (2.0 - 1.0)])
# 006-v3
c_std, A_std, A_unk = 0.020, 0.30, 0.75
check("apchem-mcq-006-v3", c_std * A_unk / A_std,
      [c_std * A_std / A_unk, c_std * A_unk, A_unk / A_std])
# 006-v1 text precision for 3.2 and 0.20 handled by shown_decimals

# 008-v1: V2 = P1V1/P2
P1, V1, P2 = 3.0, 6.0, 9.0
check("apchem-mcq-008-v1", P1 * V1 / P2, [V1, V1 * P2 / P1, P2])
# 008-v2
P1, V1, P2 = 2.0, 12.0, 0.50
check("apchem-mcq-008-v2", P1 * V1 / P2, [V1 * P2 / P1, V1, P2])
# 008-v3: P2 = P1V1/V2
P1, V1, V2 = 1.0, 5.0, 2.0
check("apchem-mcq-008-v3", P1 * V1 / V2, [P1 * V2 / V1, P1, V2])

# Conceptual variants must carry a choice_facts map for reviewers
for vid, v in V.items():
    if v["check"] == "conceptual":
        assert set(v["choice_facts"]) == {"correct", "wrong_1", "wrong_2", "wrong_3"}, vid
    assert len(v["wrong"]) == 3 and all(w["error_pattern"] and w["rationale"] for w in v["wrong"])

# Similarity
def toks(stem, texts):
    return set(re.findall(r"\w+", (stem + " " + " ".join(texts)).lower()))

def vt(v):
    return toks(v["stem"], [v["correct"]["text"]] + [w["text"] for w in v["wrong"]])

def st(s):
    return toks(s["stem"], [c["text"] for c in s["choices"]])

def jac(a, b):
    return len(a & b) / len(a | b)

mx = 0
for vid, v in V.items():
    j = jac(vt(v), st(S[v["seed"]]))
    mx = max(mx, j)
    assert j < 0.7, (vid, "seed", j)
for a, b in itertools.combinations(V, 2):
    if V[a]["seed"] == V[b]["seed"]:
        j = jac(vt(V[a]), vt(V[b]))
        mx = max(mx, j)
        assert j < 0.7, (a, b, j)
print("ALL CHECKS PASSED; max Jaccard = %.3f" % mx)
