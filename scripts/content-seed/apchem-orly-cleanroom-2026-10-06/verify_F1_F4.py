#!/usr/bin/env python3
"""Verify items_F1_F4.json: recompute correct answers and every distractor from the
stem's stated data via its named misconception, and check them against the choice texts.
Plain python (math / fractions only)."""
import json, math, os, re
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
items = {it["key"]: it for it in json.load(open(os.path.join(HERE, "items_F1_F4.json")))}
NA = 6.022e23
SUB = str.maketrans("₀₁₂₃₄₅₆₇₈₉", "0123456789")
SUP = str.maketrans("⁻⁰¹²³⁴⁵⁶⁷⁸⁹", "-0123456789")
fails = []


def check(cond, msg):
    if not cond:
        fails.append(msg)


def texts(it):
    return {c["label"]: c["text"] for c in it["choices"]}


def in_stem(it, *vals):
    for v in vals:
        check(v in it["stem"], f"{it['key']}: stem missing '{v}'")


def parse_formula(s):
    """Parse a formula like Ca3(PO4)2 or (NH4)2HPO4 into element counts."""
    s = s.translate(SUB)
    def parse(i):
        counts = {}
        while i < len(s):
            ch = s[i]
            if ch == "(":
                inner, i = parse(i + 1)
                m = re.match(r"\d*", s[i:]); k = int(m.group() or 1); i += len(m.group())
                for e, c in inner.items(): counts[e] = counts.get(e, 0) + c * k
            elif ch == ")":
                return counts, i + 1
            else:
                m = re.match(r"([A-Z][a-z]?)(\d*)", s[i:])
                e, k = m.group(1), int(m.group(2) or 1)
                counts[e] = counts.get(e, 0) + k; i += len(m.group())
        return counts, i
    return parse(0)[0]


def ratio_formula(a, b, x, y):
    """Lowest whole-number formula for x mol of a : y mol of b (x, y small integers)."""
    g = math.gcd(x, y)
    return {a: x // g, b: y // g}


def snap(r, maxden=4, tol=0.03):
    """Nearest simple fraction to ratio r (as a careful student would multiply through)."""
    fr = Fraction(r).limit_denominator(maxden)
    assert abs(float(fr) - r) / r < tol, (r, fr)
    return fr


def naive_round(r):
    return max(1, int(math.floor(r + 0.5)))


def formula_from_ratio(a, b, ratio_b_over_a):
    fr = ratio_b_over_a if isinstance(ratio_b_over_a, Fraction) else Fraction(ratio_b_over_a)
    return ratio_formula(a, b, fr.denominator, fr.numerator)


def sci(x, n=3):
    e = math.floor(math.log10(abs(x))); m = x / 10 ** e
    if round(m, n - 1) >= 10: m /= 10; e += 1
    return f"{m:.{n-1}f} × 10{e}"


def num_of(text):
    """Extract the leading numeric value (decimal or a × 10^b) from a choice text."""
    t = text.translate(SUP).replace(",", "")
    m = re.search(r"(-?\d+\.?\d*)\s*×\s*10(-?\d+)", t)
    if m: return float(m.group(1)) * 10 ** int(m.group(2)), m.group(0)
    m = re.search(r"-?\d+\.?\d*", t)
    return float(m.group()), m.group()


def matches(value, text):
    """Value rounded to the displayed precision equals the displayed number."""
    shown, raw = num_of(text)
    if "×" in raw:
        mant, exp = [x.strip() for x in raw.split("× 10")]
        dec = len(mant.split(".")[1]) if "." in mant else 0
        return sci(value, dec + 1) == f"{mant} × 10{exp}"
    dec = len(raw.split(".")[1]) if "." in raw else 0
    return round(value, dec) == round(shown, dec)


def assert_num(key, label, value, it):
    t = texts(it)[label]
    check(matches(value, t), f"{key} {label}: computed {value:.6g} but choice shows '{t}'")


def distinct(it):
    t = texts(it)
    check(len(set(t.values())) == 4, f"{it['key']}: duplicate choice texts")
    check(it["keyed_label"] == "A", f"{it['key']}: key not A")
    check(len(it["choices"]) == 4, f"{it['key']}: not 4 choices")


def assert_formula(key, label, counts, it):
    got = parse_formula(texts(it)[label])
    check(got == counts, f"{key} {label}: expected {counts}, choice parses as {got}")


# ---------------- F1: empirical formula from composition ----------------
def f1(key, a, b, ma, mb, Ma, Mb, stem_vals, swap_or_invert, mass_label="B", ss_label="C", round_label="D"):
    it = items[key]; in_stem(it, *stem_vals); distinct(it)
    na, nb = ma / Ma, mb / Mb
    # correct: divide by smaller, multiply through to a simple fraction
    r = nb / na
    fr = snap(r)
    correct = formula_from_ratio(a, b, fr)
    assert_formula(key, "A", correct, it)
    # mass ratio as mole ratio
    rm = mb / ma
    assert_formula(key, mass_label, formula_from_ratio(a, b, snap(rm, 4, 0.03)), it)
    # inverted (molar mass / mass) or swapped subscripts -- both give the swapped formula
    inv = (Mb / mb) / (Ma / ma)
    swapped = {a: correct[b], b: correct[a]}
    check(formula_from_ratio(a, b, snap(inv)) == swapped, f"{key}: inverted != swapped")
    assert_formula(key, ss_label, swapped, it)
    # rounding: smaller ratio element = 1, round the other naively
    if r >= 1:
        rd = {a: 1, b: naive_round(r)}
    else:
        rd = {a: naive_round(1 / r), b: 1}
    check(rd != correct, f"{key}: rounding gives the correct answer")
    assert_formula(key, round_label, rd, it)
    check(abs(float(fr) - round(float(fr))) > 0.2 or fr.denominator == 1, f"{key}: ratio note")
    return fr


fr1 = f1("apchem-mcq-orly-f1-v1", "Si", "N", 60.06, 39.94, 28.09, 14.01, ["60.06%", "39.94%", "28.09", "14.01"], "invert")
fr2 = f1("apchem-mcq-orly-f1-v2", "Al", "C", 3.238, 1.081, 26.98, 12.01, ["3.238 g", "1.081 g", "26.98", "12.01"], "swap")
fr3 = f1("apchem-mcq-orly-f1-v3", "Ga", "O", 2.789, 0.955, 69.72, 16.00, ["2.789 g", "0.955 g", "69.72", "16.00"], "invert")
# structure rules: >=1 member in grams (v2, v3); >=1 member with a non-whole ratio needing multiplication (all three)
check(all(f.denominator > 1 for f in (fr1, fr2, fr3)), "F1: non-whole ratio rule")
check("C" not in parse_formula(texts(items["apchem-mcq-orly-f1-v1"])["A"]) or "H" not in parse_formula(texts(items["apchem-mcq-orly-f1-v1"])["A"]), "F1 hydrocarbon")


# ---------------- F2: one percent stated; empirical vs multiple ----------------
def f2(key, a, b, Ma, Mb, stated_el, pct, molar_mass=None):
    it = items[key]; distinct(it)
    in_stem(it, f"{pct:.2f}%")
    other = 100.0 - pct
    m = {stated_el: pct, (b if stated_el == a else a): other}
    na, nb = m[a] / Ma, m[b] / Mb
    emp = formula_from_ratio(a, b, snap(nb / na))
    emp_mass = emp[a] * Ma + emp[b] * Mb
    # forgot-subtraction: unstated element taken as 100 g
    mf = {stated_el: pct, (b if stated_el == a else a): 100.0}
    forgot = formula_from_ratio(a, b, snap((mf[b] / Mb) / (mf[a] / Ma), 4, 0.03))
    one_one = {a: 1, b: 1}
    check(emp != one_one and forgot not in (emp, one_one), f"{key}: misconception collisions")
    if molar_mass is None:
        assert_formula(key, "A", emp, it)
        assert_formula(key, "B", {a: 2 * emp[a], b: 2 * emp[b]}, it)  # whole-number multiple
        assert_formula(key, "C", one_one, it)
        assert_formula(key, "D", forgot, it)
    else:
        in_stem(it, f"{molar_mass}")
        k = molar_mass / emp_mass
        check(abs(k - round(k)) < 0.02, f"{key}: molar mass not a multiple")
        assert_formula(key, "A", {a: emp[a] * round(k), b: emp[b] * round(k)}, it)
        assert_formula(key, "B", emp, it)  # stops at empirical
        k11 = molar_mass / (Ma + Mb)
        assert_formula(key, "C", {a: naive_round(k11), b: naive_round(k11)}, it)
        assert_formula(key, "D", forgot, it)
    return emp


f2("apchem-mcq-orly-f2-v1", "Ge", "Cl", 72.63, 35.45, "Ge", 33.87)
f2("apchem-mcq-orly-f2-v2", "Sb", "Cl", 121.76, 35.45, "Cl", 59.28)
f2("apchem-mcq-orly-f2-v3", "B", "H", 10.81, 1.008, "H", 21.86, molar_mass=27.67)
pairs = [frozenset(parse_formula(texts(items[f"apchem-mcq-orly-f2-v{i}"])["A"])) for i in (1, 2, 3)]
check(len(set(pairs)) == 3, "F2: element pairs not distinct")
banned = [{"S", "O"}, {"N", "O"}, {"Si", "N"}, {"Al", "C"}, {"Ga", "O"}]
check(set(pairs[0]) not in banned, "F2 v1: banned element pair")

# ---------------- F3: atoms in an ionic compound with polyatomic ions ----------------
it = items["apchem-mcq-orly-f3-v1"]; distinct(it); in_stem(it, "2.00 mol", "Ba(NO₃)₂")
fu = parse_formula("Ba(NO3)2"); n = 2.00
check("(" in "Ba(NO3)2", "F3 v1 parentheses")
assert_num(it["key"], "A", n * fu["O"], it)
assert_num(it["key"], "B", n * parse_formula("BaNO3")["O"], it)      # ignores outside subscript
assert_num(it["key"], "C", n, it)                                     # moles of formula units
assert_num(it["key"], "D", n * fu["O"] * NA, it); check("mol" in texts(it)["D"], "F3v1 D unit")

it = items["apchem-mcq-orly-f3-v2"]; distinct(it); in_stem(it, "0.250 mol", "(NH₄)₂HPO₄")
fu = parse_formula("(NH4)2HPO4"); n = 0.250
check(fu == {"N": 2, "H": 9, "P": 1, "O": 4}, f"F3v2 parse {fu}")
assert_num(it["key"], "A", n * fu["H"], it); check("H atoms" in texts(it)["A"], "F3v2 A el")
assert_num(it["key"], "B", n * 2 * parse_formula("NH4")["H"], it)   # H only in ammonium
check(n * 2 * 4 != n * fu["H"], "F3v2 B collision")
assert_num(it["key"], "C", n * parse_formula("NH4HPO4")["N"], it)    # ignores subscript 2
check(n * parse_formula("NH4HPO4")["N"] != n * fu["N"], "F3v2 C should be false")
assert_num(it["key"], "D", n * fu["O"] * NA, it); check("mol of O" in texts(it)["D"], "F3v2 D unit")

it = items["apchem-mcq-orly-f3-v3"]; distinct(it); in_stem(it, "0.120 mol", "Ca₃(PO₄)₂")
fu = parse_formula("Ca3(PO4)2"); n = 0.120
assert_num(it["key"], "A", n * fu["O"] * NA, it); check("O atoms" in texts(it)["A"] and "mol" not in texts(it)["A"], "F3v3 A")
assert_num(it["key"], "B", n * parse_formula("Ca3PO4")["O"] * NA, it)
assert_num(it["key"], "C", n * NA, it); check(abs(n * NA - n * fu["Ca"] * NA) > 1e22, "F3v3 C false")
assert_num(it["key"], "D", n * fu["P"] * NA, it); check("mol of P" in texts(it)["D"], "F3v3 D unit")
# structure: at least one member not 1 mol (all three); element in two ions used (v2)

# ---------------- F4: density + molar mass for condensed phases ----------------
it = items["apchem-mcq-orly-f4-v1"]; distinct(it); in_stem(it, "8.96 g/cm³", "63.55")
M, d = 63.55, 8.96
assert_num(it["key"], "A", M / d, it)
assert_num(it["key"], "B", M * d, it)
assert_num(it["key"], "C", d / M, it)
assert_num(it["key"], "D", 22.4 * 1000, it)

it = items["apchem-mcq-orly-f4-v2"]; distinct(it); in_stem(it, "3.10 g/mL", "25.0 mL", "159.8")
M, d, V = 159.8, 3.10, 25.0
assert_num(it["key"], "A", V * d / M * NA, it)
assert_num(it["key"], "B", V / (M * d) * NA, it)
assert_num(it["key"], "C", V / (d / M) * NA, it)
assert_num(it["key"], "D", (V / 1000) / 22.4 * NA, it)
check(all("molecules" in t for t in texts(it).values()), "F4v2 asks particles")

it = items["apchem-mcq-orly-f4-v3"]; distinct(it); in_stem(it, "19.3 g/cm³", "196.97")
M, d = 196.97, 19.3
assert_num(it["key"], "A", M / d / NA, it)
assert_num(it["key"], "B", M / d, it)            # omits Avogadro
assert_num(it["key"], "C", M * d / NA, it)
assert_num(it["key"], "D", 22400 / NA, it)

# ---------------- global checks ----------------
for k, it in items.items():
    check(set(it["rationales"]) == set("ABCD"), f"{k}: rationales")
    check(set(it["misconception_map"]) == set("BCD"), f"{k}: misconception_map")
    check(not re.search(r"\(A\)|\bA\)\s|\bA\.\s", it["stem"]), f"{k}: A-D list in stem")
    for word in ("hydrate", "·"):
        check(word not in it["stem"].lower() and all(word not in c["text"] for c in it["choices"]), f"{k}: banned '{word}'")
    # shown values in each rationale should appear (the choice's value)
    for L, c in texts(it).items():
        core = c.replace("The sample contains ", "").split(" mol")[0].split(" cm³")[0].split(" molecules")[0].split(" O atoms")[0].split(" Ca atoms")[0].rstrip(".")
        check(core.split()[0] in it["rationales"][L] or core in it["rationales"][L], f"{k} {L}: rationale does not reproduce '{core}'")
check(len(items) == 12, "item count")

if fails:
    print("FAIL"); [print(" -", f) for f in fails]; raise SystemExit(1)
print(f"PASS: {len(items)} items verified")
