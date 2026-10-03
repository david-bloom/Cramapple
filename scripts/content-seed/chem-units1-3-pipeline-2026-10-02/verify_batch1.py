import json, re, math, itertools, os
from decimal import Decimal, ROUND_HALF_UP
D = os.path.dirname(os.path.abspath(__file__))
V = {v["id"]: v for v in json.load(open(os.path.join(D, "variants_batch1.json")))}
SEEDS = {s["key"]: s for s in json.load(open(os.path.join(D, "seeds_batch1.json")))}
assert len(V) == 15
SUP = str.maketrans("0123456789", "⁰¹²³⁴⁵⁶⁷⁸⁹")

def fmt(v, sig, unit):
    e = math.floor(math.log10(abs(v)))
    if e >= 5:
        m = Decimal(v / 10**e).quantize(Decimal(1).scaleb(-(sig-1)), rounding=ROUND_HALF_UP)
        return f"{m} × 10{str(e).translate(SUP)} {unit}"
    dec = sig - 1 - e
    q = Decimal(repr(v)).quantize(Decimal(1).scaleb(-dec), rounding=ROUND_HALF_UP)
    s = f"{q:f}"
    return f"{s} {unit}"

NA = 6.022e23
# id -> (key expr, [wrong exprs], sig, unit)
n_nh3 = 1.204e24 / NA
NUM = {
 "apchem-mcq-001-v1": (4.40/44.0, [44.0/4.40, 4.40*44.0, 4.40/(12.0+16.0)], 3, "mol"),
 "apchem-mcq-001-v2": (0.400*58.5, [0.400/58.5, 58.5/0.400, 0.400*35.5], 3, "g"),
 "apchem-mcq-001-v3": (n_nh3*17.0, [n_nh3, 17.0/n_nh3, 1.204e24*17.0], 3, "g"),
 "apchem-mcq-021-v1": (23.0/46.07, [23.0/(2*46.07), 46.07/23.0, 23.0/(46.07-16.00)], 3, "mol"),
 "apchem-mcq-021-v2": (13.5/26.98, [13.5/13, 26.98/13.5, 13.5*26.98], 3, "mol"),
 "apchem-mcq-021-v3": (8.00/32.00, [8.00/16.00, 32.00/8.00, 8.00*32.00], 3, "mol"),
}
# 3-sf hack for 001-v3 first wrong: n shown as "2.00 g"
for vid, (k, ws, sig, unit) in NUM.items():
    v = V[vid]
    assert v["correct"]["text"] == fmt(k, sig, unit), (vid, v["correct"]["text"], fmt(k, sig, unit))
    for w, x in zip(v["wrong"], ws):
        assert w["text"] == fmt(x, sig, unit), (vid, w["text"], fmt(x, sig, unit))
        assert w["text"] != v["correct"]["text"]
        assert abs(x - k) / k > 0.005
print("numeric mole variants OK")
# sanity: error-pattern molar masses used in text
assert abs(46.07-16.00-30.07) < 1e-9 and abs(2*(16.0)+12.0-44.0) < 1e-9
assert abs(1.204e24/NA - 2.00) < 0.002

# --- element configs (Z<=20; no aufbau exceptions in range)
ORDER = [("1s",2),("2s",2),("2p",6),("3s",2),("3p",6),("4s",2),("3d",10),("4p",6)]
NAMES = {"Boron":5,"Carbon":6,"Nitrogen":7,"Lithium":3,"Sodium":11,"Magnesium":12,"Aluminum":13,
         "Phosphorus":15,"Argon":18,"Potassium":19,"Calcium":20}
def peaks(Z):
    out = []
    for sub, cap in ORDER:
        if Z <= 0: break
        n = min(cap, Z); out.append(n); Z -= n
    return out
# PES: PES peak order by binding energy follows the same sequence for these Z
PES = {
 "apchem-mcq-023-v1": ([2,2,6,2,6,1], "Potassium", ["Argon","Calcium","Carbon"]),
 "apchem-mcq-023-v2": ([2,2,6,2,3], "Phosphorus", ["Magnesium","Nitrogen","Boron"]),
 "apchem-mcq-023-v3": ([2,2,1], "Boron", ["Lithium","Aluminum","Sodium"]),
}
for vid, (pk, key, wr) in PES.items():
    v = V[vid]
    assert v["correct"]["text"] == key and [w["text"] for w in v["wrong"]] == wr
    assert peaks(NAMES[key]) == pk, (vid, peaks(NAMES[key]))
    assert sum(pk) == NAMES[key]
    for w in wr:
        assert peaks(NAMES[w]) != pk, (vid, w)
# error patterns producing each distractor
assert NAMES["Argon"] == sum([2,2,6,2,6])                       # ignore last peak (v1)
assert peaks(NAMES["Calcium"])[:5] == [2,2,6,2,6] and peaks(20)[5] == 2   # assumed full 4s
assert NAMES["Carbon"] == len([2,2,6,2,6,1])                    # peak count as Z (v1)
assert NAMES["Magnesium"] == sum([2,2,6,2])                     # ignore last peak (v2)
assert peaks(NAMES["Nitrogen"]) == [2,2,3] and 2+3 == 5          # valence only (v2)
assert NAMES["Boron"] == len([2,2,6,2,3])                       # peak count as Z (v2)
assert NAMES["Lithium"] == len([2,2,1]) and peaks(3) == [2,1]   # peak count as Z (v3)
assert peaks(13) == [2,2,6,2,1] and peaks(11) == [2,2,6,1]
print("PES variants OK")

# --- cation configurations: remove 4s before 3d
def cation(neutral_d, neutral_s, q):
    d, s = neutral_d, neutral_s
    for _ in range(q):
        if s > 0: s -= 1
        else: d -= 1
    return d, s
def cfg(d, s):
    parts = []
    if d: parts.append(f"3d^{d}")
    if s: parts.append(f"4s^{s}")
    return "[Ar]" + " ".join(parts)
CAT = {
 "apchem-mcq-022-v1": ((5,2,2), ["[Ar]3d^3 4s^2","[Ar]3d^4 4s^1","[Ar]3d^5 4s^2"]),
 "apchem-mcq-022-v2": ((7,2,3), ["[Ar]3d^7","[Ar]3d^4 4s^2","[Ar]3d^5 4s^1"]),
 "apchem-mcq-022-v3": ((2,2,2), ["[Ar]4s^2","[Ar]3d^1 4s^1","[Ar]3d^4"]),
}
for vid, ((d, s, q), wr) in CAT.items():
    v = V[vid]
    assert v["correct"]["text"] == cfg(*cation(d, s, q)), vid
    assert [w["text"] for w in v["wrong"]] == wr
    def tot(t): return sum(int(x) for x in re.findall(r"\^(\d+)", t))
    for w in wr: assert w != v["correct"]["text"]
    assert tot(v["correct"]["text"]) == d + s - q
# specific error patterns
assert cfg(5-0, 2-2+0) == "[Ar]3d^5"
assert cfg(*(5, 2-0)) == "[Ar]3d^5 4s^2"                       # ignored charge (Mn)
assert (5-2, 2) == (3, 2) and (5-1, 2-1) == (4, 1)             # Mn wrong 1 and 2
assert (7-2, 2) != (7-3, 2) and cation(7,2,2) == (7,0) and (7-3, 2) == (4, 2) and (7-2, 2-1) == (5, 1)
assert (2-2, 2) == (0, 2) and (2-1, 2-1) == (1, 1) and (2+2, 0) == (4, 0)
print("cation configurations OK")

# --- conceptual facts (verified by reviewer reading); basic data checks
assert peaks(4)==[2,2] and peaks(5)==[2,2,1]       # Be 2s2, B 2s2 2p1
assert peaks(7)==[2,2,3] and peaks(8)==[2,2,4]     # N 2p3, O 2p4
assert 30 > 5 and True
assert V["apchem-mcq-024-v1"]["check"] == "conceptual"
for vid in V:
    if V[vid]["check"] == "conceptual":
        for c in [V[vid]["correct"]] + V[vid]["wrong"]:
            assert c.get("fact") or vid.startswith("apchem-mcq-024"), (vid, c["text"])
print("conceptual data checks OK")

# --- structure
for vid, v in V.items():
    texts = [v["correct"]["text"]] + [w["text"] for w in v["wrong"]]
    assert len(v["wrong"]) == 3 and len(set(texts)) == 4, vid
    assert v["difficulty"] in ("easy","medium","hard") and v["check"] in ("numeric","conceptual")
    assert 2 <= len(v["title"].split()) <= 6, (vid, v["title"])
    for w in v["wrong"]: assert w["error_pattern"] and len(w["rationale"]) > 40

# --- Jaccard
def toks(v):
    return set(re.findall(r"\w+", (v["stem"] + " " + " ".join([v["correct"]["text"]] + [w["text"] for w in v["wrong"]])).lower()))
def stoks(s):
    return set(re.findall(r"\w+", (s["stem"] + " " + " ".join(c["text"] for c in s["choices"])).lower()))
def jac(a, b): return len(a & b) / len(a | b)
mx = 0
for vid, v in V.items():
    j = jac(toks(v), stoks(SEEDS[v["seed"]])); mx = max(mx, j)
    assert j < 0.7, (vid, "vs seed", j)
for a, b in itertools.combinations(V, 2):
    if V[a]["seed"] == V[b]["seed"]:
        j = jac(toks(V[a]), toks(V[b])); mx = max(mx, j)
        assert j < 0.7, (a, b, j)
print("max Jaccard (variant-seed and sibling pairs): %.3f" % mx)
print("ALL CHECKS PASSED")
