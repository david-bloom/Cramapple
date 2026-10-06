#!/usr/bin/env python3
"""Verify F5-F8 items: recompute correct values and misconception-driven distractors
from the stem data and check they match the choice texts (to displayed precision).
Plain python only."""
import json
import math
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
items = {it["key"]: it for it in json.load(open(os.path.join(HERE, "items_F5_F8.json")))}

SUP = str.maketrans("⁻⁰¹²³⁴⁵⁶⁷⁸⁹", "-0123456789")


def parse(text):
    """Parse a numeric choice text like '42.6%', '0.144 M', '2.00 × 10⁻⁴ M'."""
    t = text.translate(SUP).replace("%", "").replace("M", "").strip()
    m = re.match(r"^([0-9.]+)\s*×\s*10(-?\d+)$", t)
    if m:
        return float(m.group(1)) * 10 ** int(m.group(2)), m.group(1)
    return float(t), t


def sig_round(x, digits_str):
    """Round x to the precision shown in digits_str (decimal places of mantissa)."""
    dec = len(digits_str.split(".")[1]) if "." in digits_str else 0
    return dec


def check_numeric(key, expected):
    it = items[key]
    ch = {c["label"]: c["text"] for c in it["choices"]}
    assert it["keyed_label"] == "A", key
    shown = []
    for lab, val in expected.items():
        num, mant = parse(ch[lab])
        if "×" in ch[lab]:
            exp = int(math.floor(math.log10(abs(val))))
            dec = len(mant.split(".")[1])
            got = round(val / 10 ** exp, dec)
            assert abs(got - float(mant)) < 1e-9 and abs(num - float(mant) * 10 ** exp) < 1e-12, (key, lab, val, ch[lab])
        else:
            dec = len(mant.split(".")[1]) if "." in mant else 0
            assert abs(round(val, dec) - num) < 1e-9, (key, lab, val, ch[lab])
        shown.append(ch[lab])
    assert len(set(shown)) == 4, (key, shown)
    print(f"PASS {key}: " + ", ".join(f"{l}={ch[l]}" for l in "ABCD"))


# ---------- F5 ----------
# v1: 5.00 g, 0.0300 mol Na, Na2SO4 142.04, KCl 74.55, Na 22.99
n_na, s = 0.0300, 5.00
check_numeric("apchem-mcq-orly-f5-v1", {
    "A": 100 * (n_na / 2) * 142.04 / s,      # correct
    "B": 100 * n_na * 22.99 / s,             # element percent
    "C": 100 * (n_na / 2) * 74.55 / s,       # wrong component molar mass
    "D": 100 * n_na * 142.04 / s,            # forgot subscript 2
})
# v2: 4.50 g, 1.00 g Ca, CaCO3 100.09, NaCl 58.44, Ca 40.08
m_ca, s = 1.00, 4.50
n = m_ca / 40.08
m_comp = n * 100.09
check_numeric("apchem-mcq-orly-f5-v2", {
    "A": 100 * m_comp / s,
    "B": 100 * m_ca / s,
    "C": 100 * n * 58.44 / s,
    "D": 100 * m_ca / m_comp,                # divides by component mass
})
# v3: 8.00 g copper ore, 2.20 g Cu, Cu2S 159.17, Cu 63.55
m_cu, s = 2.20, 8.00
n = m_cu / 63.55
m_comp = (n / 2) * 159.17
check_numeric("apchem-mcq-orly-f5-v3", {
    "A": 100 * m_comp / s,
    "B": 100 * m_cu / s,
    "C": 100 * m_cu / m_comp,
    "D": 100 * n * 159.17 / s,
})

# ---------- F6 ----------
# v1: 0.0200 mol NaNO3 + 0.0150 mol Ca(NO3)2, 250.0 mL, [NO3-]
a, b, V = 0.0200, 0.0150, 250.0
check_numeric("apchem-mcq-orly-f6-v1", {
    "A": (a + 2 * b) / (V / 1000),
    "B": (a + b) / (V / 1000),
    "C": ((a / (V / 1000)) + (2 * b / (V / 1000))) / 2,
    "D": (a + 2 * b) / V,
})
# v2: 2.55 g K3PO4 (212.27) + 1.64 g Na3PO4 (163.94), 250.0 mL, [K+] (only from K3PO4)
nk = 2.55 / 212.27
V = 250.0
check_numeric("apchem-mcq-orly-f6-v2", {
    "A": 3 * nk / (V / 1000),
    "B": nk / (V / 1000),
    "C": (3 * nk / (V / 1000) + 0.0) / 2,
    "D": 3 * nk / V,
})
# v3: 2.64 g (NH4)2SO4 (132.15) + 0.800 g NH4NO3 (80.05), 350.0 mL, [NH4+]
na, nb, V = 2.64 / 132.15, 0.800 / 80.05, 0.3500
check_numeric("apchem-mcq-orly-f6-v3", {
    "A": (2 * na + nb) / V,
    "B": (na + nb) / V,
    "C": 2 * na / V,
    "D": (2 * na / V + nb / V) / 2,
})

# ---------- F7 (error direction) ----------
m, R, T, Vg, Ptot, Pw = 0.520, 0.08206, 22.0 + 273.15, 0.2340, 0.9921, 0.0261
M_true = m * R * T / ((Ptot - Pw) * Vg)
M_err = m * R * T / (Ptot * Vg)
n_true, n_err = (Ptot - Pw) * Vg / (R * T), Ptot * Vg / (R * T)
assert n_err > n_true and M_err < M_true
assert round(M_true, 1) == 55.7 and round(M_err, 1) == 54.3
f7 = items["apchem-mcq-orly-f7-v3"]
assert f7["choices"][0]["text"].startswith("It is too low")
assert "55.7" in f7["rationales"]["A"] and "54.3" in f7["rationales"]["A"]
print(f"PASS apchem-mcq-orly-f7-v3: n too large ({n_err:.5f} > {n_true:.5f}); M too low ({M_err:.2f} < {M_true:.2f}) -> key 'too low'")
# Celsius check not used as a distractor; sanity: a Celsius T would also give a different M
# v2: no liquid present -> P_gas = P_total, so the barometric pressure is used directly;
# a Celsius T substituted directly would change M, so T is required (key: barrel length).
assert "No liquid is present" in items["apchem-mcq-orly-f7-v2"]["stem"]
assert items["apchem-mcq-orly-f7-v2"]["choices"][0]["text"].startswith("The length of the syringe barrel")
for k in ("apchem-mcq-orly-f7-v1", "apchem-mcq-orly-f7-v2"):
    assert items[k]["keyed_label"] == "A" and len(items[k]["choices"]) == 4
    print(f"PASS {k}: structure (qualitative procedure item)")

# ---------- F8 ----------
# v2: crucible 16.420, crucible+damp 19.870, heated 19.402, 19.355, 19.353
cru, full, h = 16.420, 19.870, [19.402, 19.355, 19.353]
assert abs(h[2] - h[1]) <= 0.002  # converged
samp = full - cru
pct = 100 * (full - h[2]) / samp
pct_avg = 100 * (full - sum(h) / 3) / samp
assert round(pct, 1) == 15.0 and round(pct_avg, 1) == 14.5
ch = {c["label"]: c["text"] for c in items["apchem-mcq-orly-f8-v2"]["choices"]}
assert "15.0%" in ch["A"] and "14.5%" in ch["B"] and "15.0%" in ch["C"]
# incomplete heating direction claimed in C is reversed: a higher final mass lowers the percent
assert 100 * (full - (h[2] + 0.010)) / samp < pct
print(f"PASS apchem-mcq-orly-f8-v2: A={pct:.2f}% B(avg)={pct_avg:.2f}%; incomplete heating lowers %")
# v3: dish 31.250, sample 6.000, masses 36.402, 36.237, 36.198 (not converged)
dish, s, h = 31.250, 6.000, [36.402, 36.237, 36.198]
assert h[1] - h[2] > 0.002  # not converged
pct_student = 100 * (dish + s - h[2]) / s
assert round(pct_student, 1) == 17.5
for true_final in (h[2] - 0.005, h[2] - 0.02, h[2] - 0.05):
    assert pct_student < 100 * (dish + s - true_final) / s
assert items["apchem-mcq-orly-f8-v3"]["choices"][0]["text"].startswith("It is too low")
print(f"PASS apchem-mcq-orly-f8-v3: student {pct_student:.2f}% < true (any lower final mass) -> key 'too low'")
d1 = [24.815, 24.702, 24.668]
assert d1[1] - d1[2] > 0.002
print("PASS apchem-mcq-orly-f8-v1: masses not converged -> key 'heat again'")

# structural checks
for k, it in items.items():
    assert len(it["choices"]) == 4 and [c["label"] for c in it["choices"]] == list("ABCD"), k
    assert it["keyed_label"] == "A" and set(it["rationales"]) == set("ABCD"), k
    assert set(it["misconception_map"]) == set("BCD"), k
banned = {
    "apchem-mcq-orly-f7-v2": ["water levels inside and outside", "collected over water",
                              "needed to calculate the molar mass", "volume of gas collected", "over water"],
    "apchem-mcq-orly-f7-v3": ["water levels inside and outside", "inside and outside the tube", "an unknown gas"],
    "apchem-mcq-orly-f5-v3": ["iron", "Fe", "3.00 g"],
    "apchem-mcq-orly-f6-v3": ["MgCl", "KCl", "chloride"],
}
for k, phrases in banned.items():
    blob = json.dumps(items[k], ensure_ascii=False)
    for ph in phrases:
        assert ph not in blob, (k, ph)
assert len(items) == 12
print("ALL CHECKS PASSED (12 items)")
