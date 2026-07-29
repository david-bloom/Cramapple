#!/usr/bin/env python3
"""
Experiment #2: label-robustness cross-check of the three silver (calibration)
gold-set-candidate label sets. Independent, reproducible checks hunting two
failure modes: (i) a wrong-typed response that is accidentally fully credited,
(ii) a confident label that conflicts with an independent signal.

Checks:
  A. Canonical integrity      - every fully_correct response must earn all criteria.
  B. Accidentally-right hunt   - a wrong-typed response earning ALL criteria.
  C. Deterministic vs label    - numeric criterion labels vs the Exp#1 checker's
                                 number-right/number-wrong verdict (fully model-
                                 judgment-independent). Over-credit = number wrong
                                 but 'earned'; under-credit = number right but 'not_earned'.
  E. Distribution sanity       - subtly_wrong/incorrect responses should skew away
                                 from 'earned'; flag if >50% earned.
"""
import json, os, re

RESEARCH = "/Users/davidbloom/Documents/Cramapple/docs/research"
CHK = os.path.join(RESEARCH, "deterministic_check_experiment_2026_07_08", "checker.py")
OUT = os.path.dirname(os.path.abspath(__file__))

# reuse Exp#1 number extraction + match (exec the top of checker.py; stop before it loads data)
ns = {"__file__": CHK}
exec(open(CHK).read().split("# ---- load responses")[0], ns)
extract_numbers = ns["extract_numbers"]; match = ns["match"]

def key_present(text, value, sign_sensitive=False):
    return any(match(n, value, sign_sensitive) for n in extract_numbers(text))

FILES = {
 "biology":    os.path.join(RESEARCH, "ap_biology_gold_set_candidate_2026_07_08", "provisional_labels.json"),
 "statistics": os.path.join(RESEARCH, "ap_statistics_gold_set_candidate_2026_07_08", "provisional_labels.json"),
 "chemistry":  os.path.join(RESEARCH, "ap_chemistry_gold_set_candidate_2026_07_08", "provisional_labels.json"),
}

# numeric criterion -> (correct value, sign_sensitive) for Check C
NUMERIC_CRIT = {
 "APCHEM-FRQ-L-011": {"osmotic_pressure_1": (1.22, False), "osmotic_pressure_2": (3.67, False)},
 "APCHEM-FRQ-L-021": {"mass_caco3": (8.76, False), "percent_purity": (73.0, False)},
 "APCHEM-FRQ-L-041": {"first_step_calc": (2.02, False), "a2_estimate": (1.0e-7, False)},
 "APSTAT-MOD3-H001-INV": {"ci_calculation": (807.0, False)},
 "APSTAT-MOD6-H001": {"test_calculation": (2.06, False)},
 "APSTAT-MOD7-H001": {"calculation": (0.65, False)},
}

def resp_text(r):
    return r.get("response_text") or r.get("student_response") or ""
def resp_type(r):
    return r.get("synthetic_type") or r.get("type")
def crit_label(c):
    return c.get("provisional_label")

flags = []       # each: dict(check, severity, subject, item, response, criterion, detail)
counts = {"criterion_judgments": 0, "responses": 0}
dist = {}        # (subject,type) -> Counter of labels

for subject, path in FILES.items():
    data = json.load(open(path))
    for it in data["items"]:
        ck = it["content_key"]
        for r in it["responses"]:
            rt = resp_type(r); text = resp_text(r); crits = r["criteria"]
            counts["responses"] += 1
            labels = [crit_label(c) for c in crits.values()]
            counts["criterion_judgments"] += len(labels)
            dist.setdefault((subject, rt), {})
            for lab in labels:
                dist[(subject, rt)][lab] = dist[(subject, rt)].get(lab, 0) + 1

            # A. canonical integrity
            if rt == "fully_correct":
                bad = [k for k, c in crits.items() if crit_label(c) != "earned"]
                if bad:
                    flags.append(dict(check="A_canonical_integrity", severity="high", subject=subject,
                                      item=ck, response=rt, criterion=",".join(bad),
                                      detail="canonical response not fully earned"))
            # B. accidentally-right
            else:
                if labels and all(l == "earned" for l in labels):
                    sev = "high" if rt in ("incorrect", "subtly_wrong") else "low"
                    flags.append(dict(check="B_accidentally_right", severity=sev, subject=subject,
                                      item=ck, response=rt, criterion="ALL",
                                      detail=f"{rt} response earns every criterion"))
            # C. deterministic vs label
            for crit_key, (val, ss) in NUMERIC_CRIT.get(ck, {}).items():
                if crit_key in crits:
                    lab = crit_label(crits[crit_key])
                    present = key_present(text, val, ss)
                    if lab == "earned" and not present:
                        flags.append(dict(check="C_over_credit", severity="high", subject=subject,
                                          item=ck, response=rt, criterion=crit_key,
                                          detail=f"labeled earned but correct value {val} absent (number wrong)"))
                    elif lab == "not_earned" and present:
                        flags.append(dict(check="C_under_credit", severity="high", subject=subject,
                                          item=ck, response=rt, criterion=crit_key,
                                          detail=f"labeled not_earned but correct value {val} present (number right)"))

# E. distribution sanity
dist_flags = []
for (subject, rt), c in dist.items():
    tot = sum(c.values()); earned = c.get("earned", 0)
    if rt in ("incorrect", "subtly_wrong") and tot and earned / tot > 0.5:
        dist_flags.append(dict(subject=subject, type=rt, earned=earned, total=tot,
                               earned_frac=round(earned / tot, 2)))

summary = {
 "date": "2026-07-08",
 "label_sets": list(FILES.keys()),
 "responses_checked": counts["responses"],
 "criterion_judgments_checked": counts["criterion_judgments"],
 "numeric_criteria_cross_checked_vs_deterministic": sum(len(v) for k, v in NUMERIC_CRIT.items()),
 "flags_total": len(flags),
 "flags_by_check": {},
 "flags_high_severity": [f for f in flags if f["severity"] == "high"],
 "flags_low_severity": [f for f in flags if f["severity"] == "low"],
 "distribution_flags": dist_flags,
 "label_distribution_by_subject_type": {f"{s}/{t}": c for (s, t), c in sorted(dist.items())},
}
for f in flags:
    summary["flags_by_check"][f["check"]] = summary["flags_by_check"].get(f["check"], 0) + 1

json.dump(summary, open(os.path.join(OUT, "summary.json"), "w"), indent=1)

print("=== Label-robustness cross-check ===")
print("responses checked:", counts["responses"], "| criterion judgments:", counts["criterion_judgments"])
print("numeric criteria cross-checked vs deterministic checker:", summary["numeric_criteria_cross_checked_vs_deterministic"])
print("flags by check:", summary["flags_by_check"])
print("\n-- HIGH severity flags --")
for f in summary["flags_high_severity"]:
    print(f"  [{f['check']}] {f['subject']} {f['item']} / {f['response']} / {f['criterion']}: {f['detail']}")
print("\n-- LOW severity flags (borderline earns all - expected-by-design, human glance) --")
for f in summary["flags_low_severity"]:
    print(f"  [{f['check']}] {f['subject']} {f['item']} / {f['response']}")
print("\n-- distribution flags --")
for f in dist_flags:
    print(f"  {f['subject']}/{f['type']}: {f['earned']}/{f['total']} earned ({f['earned_frac']})")
