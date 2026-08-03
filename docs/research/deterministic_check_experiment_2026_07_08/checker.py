#!/usr/bin/env python3
"""
Experiment #1: deterministic (zero-API-cost) numeric-answer checker.

For each item, SPEC encodes the CORRECT keyed answer(s) recomputed from the
question's givens (the value a verification_profile would carry). The checker
extracts numbers from a response and flags it if a keyed answer is missing. It
never inspects what wrong value a response contains, so it detects ANY numeric
error, not a pre-known one. Conceptual items are marked None -> the checker
ABSTAINS (correctly out of scope; those are the language-model grader's job).

Verdict per response: PASS (all keyed answers present) / FLAG (a keyed answer
missing) / ABSTAIN (item has no numeric key).

Sources:
  - AP Chemistry: full corpus (100 items, 300 responses, v2 wrong-reasoning).
  - AP Statistics: the 5-item gold-set-candidate slice (20 responses).
"""
import json, os, re, math

RESEARCH = "/Users/davidbloom/Documents/Cramapple/docs/research"
CHEM = os.path.join(RESEARCH, "ap_chemistry_frq_grading_experiment_batch_2026_07_07",
                    "ap_chemistry_frq_grading_experiment_batch_2026_07_07.json")
STATS = os.path.join(RESEARCH, "ap_statistics_gold_set_candidate_2026_07_08", "provisional_labels.json")
OUT = os.path.dirname(os.path.abspath(__file__))

# ---- number extraction -----------------------------------------------------
SCI = re.compile(r'([+-]?\d+(?:\.\d+)?)\s*[xX*]\s*10\s*\^?\s*([+-]?\d+)')
EXP = re.compile(r'([+-]?\d+(?:\.\d+)?)[eE]([+-]?\d+)')
NUM = re.compile(r'[+-]?\d+(?:\.\d+)?')

OP = set("+-*/x×^±")

def extract_numbers(text):
    """Extract RESULT numbers only: a number is dropped if it is an operand
    (immediately followed by an arithmetic operator), so intermediates like the
    pKa in 'pKa + log(...)' don't get mistaken for the final answer."""
    t = text.replace(",", "")           # 10,346 -> 10346
    def after_ok(end):                  # not a left operand ('X +', 'X /')
        j = end
        while j < len(t) and t[j] == ' ':
            j += 1
        return j >= len(t) or t[j] not in OP
    def before_ok(start, token):        # not a binary operand ('850-800' -> 800 is an operand)
        if token and token[0] in "+-":
            j = start - 1
            while j >= 0 and t[j] == ' ':
                j -= 1
            if j >= 0 and (t[j].isdigit() or t[j] == ')'):
                return False
        return True
    vals, spans = [], []
    for m in SCI.finditer(t):
        spans.append(m.span())
        if after_ok(m.end()) and before_ok(m.start(), m.group()):
            vals.append(float(m.group(1)) * (10 ** int(m.group(2))))
    for m in EXP.finditer(t):
        spans.append(m.span())
        if after_ok(m.end()) and before_ok(m.start(), m.group()):
            vals.append(float(m.group(1)) * (10 ** int(m.group(2))))
    for m in NUM.finditer(t):
        if any(s0 <= m.start() < s1 for s0, s1 in spans):
            continue
        if after_ok(m.end()) and before_ok(m.start(), m.group()):
            try:
                vals.append(float(m.group()))
            except ValueError:
                pass
    return vals

def match(n, target, sign_sensitive, rel=0.02):
    if sign_sensitive and ((n < 0) != (target < 0)):
        return False
    a, b = abs(n), abs(target)
    if b == 0:
        return a < 1e-12
    return abs(a - b) <= rel * b

def verdict(text, keys):
    if keys is None:
        return "ABSTAIN"
    nums = extract_numbers(text)
    for val, ss in keys:
        if not any(match(n, val, ss) for n in nums):
            return "FLAG"
    return "PASS"

# ---- SPEC: correct keyed answers (value, sign_sensitive). None = conceptual/abstain
K = lambda *vals: [(v, False) for v in vals]          # sign-insensitive keys
KS = lambda *vals: [(v, True) for v in vals]           # sign-sensitive keys
SPEC = {
 # ----- Chemistry short -----
 "APCHEM-FRQ-S-001": None, "APCHEM-FRQ-S-002": None, "APCHEM-FRQ-S-003": None,
 "APCHEM-FRQ-S-004": None, "APCHEM-FRQ-S-005": None, "APCHEM-FRQ-S-006": None,
 "APCHEM-FRQ-S-007": None, "APCHEM-FRQ-S-008": None,
 "APCHEM-FRQ-S-009": K(4.00), "APCHEM-FRQ-S-010": None, "APCHEM-FRQ-S-011": K(0.768),
 "APCHEM-FRQ-S-012": None, "APCHEM-FRQ-S-013": None, "APCHEM-FRQ-S-014": K(3.20),
 "APCHEM-FRQ-S-015": K(1.06), "APCHEM-FRQ-S-016": K(72.0), "APCHEM-FRQ-S-017": None,
 "APCHEM-FRQ-S-018": K(128.0), "APCHEM-FRQ-S-019": None, "APCHEM-FRQ-S-020": K(15.2),
 "APCHEM-FRQ-S-021": K(0.1065), "APCHEM-FRQ-S-022": K(0.700), "APCHEM-FRQ-S-023": None,
 "APCHEM-FRQ-S-024": K(20.0), "APCHEM-FRQ-S-025": None, "APCHEM-FRQ-S-026": K(0.200),
 "APCHEM-FRQ-S-027": K(10.3), "APCHEM-FRQ-S-028": KS(-393.5), "APCHEM-FRQ-S-029": K(440.0),
 "APCHEM-FRQ-S-030": KS(-34.3), "APCHEM-FRQ-S-031": None, "APCHEM-FRQ-S-032": None,
 "APCHEM-FRQ-S-033": K(0.0159), "APCHEM-FRQ-S-034": K(0.0159), "APCHEM-FRQ-S-035": K(3.40),
 "APCHEM-FRQ-S-036": None, "APCHEM-FRQ-S-037": K(2.05), "APCHEM-FRQ-S-038": None,
 "APCHEM-FRQ-S-039": K(4.67), "APCHEM-FRQ-S-040": K(20.0), "APCHEM-FRQ-S-041": K(9.47),
 "APCHEM-FRQ-S-042": None, "APCHEM-FRQ-S-043": None, "APCHEM-FRQ-S-044": K(11.30),
 "APCHEM-FRQ-S-045": K(7.03), "APCHEM-FRQ-S-046": K(3.26), "APCHEM-FRQ-S-047": None,
 "APCHEM-FRQ-S-048": KS(-154.0), "APCHEM-FRQ-S-049": None, "APCHEM-FRQ-S-050": K(3.4e15),
 # ----- Chemistry long -----
 "APCHEM-FRQ-L-001": None, "APCHEM-FRQ-L-002": None, "APCHEM-FRQ-L-003": None,
 "APCHEM-FRQ-L-004": None, "APCHEM-FRQ-L-005": K(109.5), "APCHEM-FRQ-L-006": None,
 "APCHEM-FRQ-L-007": None, "APCHEM-FRQ-L-008": None,
 "APCHEM-FRQ-L-009": K(0.122, 3.00), "APCHEM-FRQ-L-010": K(0.500),
 "APCHEM-FRQ-L-011": K(1.22, 3.67), "APCHEM-FRQ-L-012": K(5.16),
 "APCHEM-FRQ-L-013": None, "APCHEM-FRQ-L-014": K(76.0, 0.931),
 "APCHEM-FRQ-L-015": K(8.89), "APCHEM-FRQ-L-016": K(0.305, 8.00),
 "APCHEM-FRQ-L-017": K(35.0), "APCHEM-FRQ-L-018": K(12.3),
 "APCHEM-FRQ-L-019": K(2.67, 1.33), "APCHEM-FRQ-L-020": None,
 "APCHEM-FRQ-L-021": K(8.76, 73.0), "APCHEM-FRQ-L-022": K(82.4),
 "APCHEM-FRQ-L-023": K(8.0), "APCHEM-FRQ-L-024": K(12000.0), "APCHEM-FRQ-L-025": None,
 "APCHEM-FRQ-L-026": K(50.0, 0.300), "APCHEM-FRQ-L-027": KS(-53.9),
 "APCHEM-FRQ-L-028": KS(-20.1), "APCHEM-FRQ-L-029": KS(-2881.0),
 "APCHEM-FRQ-L-030": K(462.0) + KS(-32.7), "APCHEM-FRQ-L-031": None,
 "APCHEM-FRQ-L-032": K(1.58), "APCHEM-FRQ-L-033": K(6.5e-5, 1.1e-10),
 "APCHEM-FRQ-L-034": K(0.124), "APCHEM-FRQ-L-035": K(12.40),
 "APCHEM-FRQ-L-036": K(9.25), "APCHEM-FRQ-L-037": K(4.77e-5),
 "APCHEM-FRQ-L-038": K(1.62), "APCHEM-FRQ-L-039": K(1.48, 7.00),
 "APCHEM-FRQ-L-040": K(8.72), "APCHEM-FRQ-L-041": K(2.02, 1.0e-7),
 "APCHEM-FRQ-L-042": K(1.10, 2.87), "APCHEM-FRQ-L-043": K(80.0, 5.50),
 "APCHEM-FRQ-L-044": K(33.3), "APCHEM-FRQ-L-045": K(11.00),
 "APCHEM-FRQ-L-046": K(1.6e-5, 11.10), "APCHEM-FRQ-L-047": KS(1.10),
 "APCHEM-FRQ-L-048": KS(0.62), "APCHEM-FRQ-L-049": KS(0.118), "APCHEM-FRQ-L-050": KS(-357.0),
 # ----- Statistics gold-set slice -----
 "APSTAT-MOD3-H001-INV": K(807.0, 893.0), "APSTAT-MOD5-H001-INV": None,
 "APSTAT-MOD6-H001": K(2.06), "APSTAT-MOD7-H001": K(0.65), "APSTAT-MOD8-H001": None,
}

# ---- load responses --------------------------------------------------------
rows = []  # (subject, content_key, resp_type, text)
chem = json.load(open(CHEM))["items"]
for it in chem:
    for r in it["synthetic_responses"]:
        rows.append(("chem", it["content_key"], r["type"], r["student_response"]))
stats = json.load(open(STATS))["items"]
for it in stats:
    for r in it["responses"]:
        rows.append(("stats", it["content_key"], r["synthetic_type"], r["response_text"]))

# ---- run -------------------------------------------------------------------
from collections import Counter, defaultdict
res = []
for subj, ck, rt, text in rows:
    keys = SPEC.get(ck, "MISSING")
    if keys == "MISSING":
        raise SystemExit(f"no SPEC for {ck}")
    v = verdict(text, keys)
    res.append({"subject": subj, "content_key": ck, "type": rt, "verdict": v,
                "numeric_item": keys is not None, "canonical": rt == "fully_correct"})

# ---- metrics ---------------------------------------------------------------
num_items = [r for r in res if r["numeric_item"]]
canon_num = [r for r in num_items if r["canonical"]]
wrong_num = [r for r in num_items if not r["canonical"]]
concept = [r for r in res if not r["numeric_item"]]

false_flags = [r for r in canon_num if r["verdict"] == "FLAG"]
caught = [r for r in wrong_num if r["verdict"] == "FLAG"]
wrong_passed = [r for r in wrong_num if r["verdict"] == "PASS"]

summary = {
 "date": "2026-07-08",
 "total_responses": len(res),
 "numeric_keyed_items_responses": len(num_items),
 "conceptual_items_responses": len(concept),
 "canonical_on_numeric_items": len(canon_num),
 "canonical_PASS_specificity": round(sum(1 for r in canon_num if r["verdict"] == "PASS") / len(canon_num), 4),
 "false_flags_on_canonical": len(false_flags),
 "wrong_on_numeric_items": len(wrong_num),
 "wrong_FLAGged_detection_rate": round(len(caught) / len(wrong_num), 4),
 "wrong_PASSED_conceptual_on_numeric_item": len(wrong_passed),
 "conceptual_items_all_ABSTAIN": all(r["verdict"] == "ABSTAIN" for r in concept),
 "false_flag_keys": [r["content_key"] for r in false_flags],
 "wrong_passed_detail": [{"item": r["content_key"], "type": r["type"]} for r in wrong_passed],
 "verdict_counts": dict(Counter(r["verdict"] for r in res)),
}
json.dump(summary, open(os.path.join(OUT, "summary.json"), "w"), indent=1)

print("=== Deterministic numeric-check experiment ===")
for k, v in summary.items():
    if k in ("false_flag_keys", "wrong_passed_detail"):
        print(f"{k}: {v}")
    else:
        print(f"{k}: {v}")
