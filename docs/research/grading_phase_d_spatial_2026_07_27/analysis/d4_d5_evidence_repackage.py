#!/usr/bin/env python3
"""
D4/D5 evidence repackaging — deterministic re-analysis of the already-collected
2026-08-18 Biology real-photo benchmark run (`real_photo_benchmark_gpt52_results.jsonl`),
plus the archetype-gated escalation run, to ground BAKEOFF_RESULTS.md /
ABSTENTION_CALIBRATION.md / abstention_thresholds.json in observed calibration
errors rather than restated prose.

Reads only existing run artifacts; makes no model calls; writes a single JSON
summary to stdout (redirect to d4_d5_summary.json). Nothing here is release-grade:
the gold is `ai_provisional` (single-pass AI, DECISION-0050 method not yet
reader-certified), and the corpus was iterated on. Every number this emits is
R&D-tier by construction.
"""
import json, os, sys
from collections import defaultdict

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BENCH = os.path.join(ROOT, "docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18")
GPT52 = os.path.join(BENCH, "runs/real_photo_benchmark_gpt52_results.jsonl")
ESCAL = os.path.join(BENCH, "runs/escalation_gemini_results.jsonl")  # 21-photo pilot
ESCAL_FULL = os.path.join(BENCH, "runs/escalation_full_results.jsonl")  # 105 full

ARCH_SHORT = {
    "categorical_comparison_supplied_uncertainty": "CAT",
    "continuous_measured_series_supplied_uncertainty": "SER",
    "continuous_relationship_graph_derived_estimate": "EST",
}
ABSTAIN = {"unable_to_determine", "abstain", None, ""}


def load_jsonl(p):
    return [json.loads(l) for l in open(p) if l.strip()]


def new_conf():
    return {"tp": 0, "fp": 0, "fn": 0, "tn": 0, "abstain": 0}


def tally(conf, gold, pred):
    if gold in ABSTAIN:
        return  # cannot score against an abstaining gold
    if pred in ABSTAIN:
        conf["abstain"] += 1
        return
    if gold == "earned" and pred == "earned":
        conf["tp"] += 1
    elif gold == "not_earned" and pred == "earned":
        conf["fp"] += 1
    elif gold == "earned" and pred == "not_earned":
        conf["fn"] += 1
    elif gold == "not_earned" and pred == "not_earned":
        conf["tn"] += 1


def metrics(c):
    tp, fp, fn, tn = c["tp"], c["fp"], c["fn"], c["tn"]
    prec = tp / (tp + fp) if (tp + fp) else None
    rec = tp / (tp + fn) if (tp + fn) else None
    f1 = (2 * prec * rec / (prec + rec)) if (prec and rec) else None
    far = fp / (fp + tn) if (fp + tn) else None
    frr = fn / (fn + tp) if (fn + tp) else None
    n = tp + fp + fn + tn
    return {
        "n": n, "tp": tp, "fp": fp, "fn": fn, "tn": tn, "abstain": c["abstain"],
        "far": round(far, 4) if far is not None else None,
        "frr": round(frr, 4) if frr is not None else None,
        "f1": round(f1, 4) if f1 is not None else None,
        "precision": round(prec, 4) if prec is not None else None,
        "recall": round(rec, 4) if rec is not None else None,
    }


def analyze(records, restrict_conf=None):
    overall = new_conf()
    by_crit = defaultdict(new_conf)
    by_arch_crit = defaultdict(new_conf)
    resp_exact = 0
    resp_n = 0
    for r in records:
        if restrict_conf and r.get("confidence") not in restrict_conf:
            continue
        resp_n += 1
        if r.get("exact_match"):
            resp_exact += 1
        arch = ARCH_SHORT.get(r.get("archetype"), r.get("archetype"))
        gold_map = r.get("gold_criterion_statuses", {})
        pred_map = r.get("criterion_statuses", {})
        for crit, gold in gold_map.items():
            pred = pred_map.get(crit)
            tally(overall, gold, pred)
            tally(by_crit[crit], gold, pred)
            tally(by_arch_crit[f"{arch}:{crit}"], gold, pred)
    return {
        "response_n": resp_n,
        "response_exact_match": round(resp_exact / resp_n, 4) if resp_n else None,
        "response_exact_count": resp_exact,
        "overall": metrics(overall),
        "by_criterion": {k: metrics(v) for k, v in sorted(by_crit.items())},
        "by_archetype_criterion": {k: metrics(v) for k, v in sorted(by_arch_crit.items())},
    }


def main():
    gpt52 = load_jsonl(GPT52)
    out = {
        "source": "real_photo_benchmark_gpt52_results.jsonl (openai/gpt-5.2, joint judgment, single pass)",
        "gold_tier": "ai_provisional (single-pass AI; NOT reader-certified; corpus iterated on) — R&D-tier only",
        "corpus_n": len(gpt52),
        "confidence_distribution": {},
        "all_responses": analyze(gpt52),
        "high_confidence_slice": analyze(gpt52, restrict_conf={"high"}),
        "medium_confidence_slice": analyze(gpt52, restrict_conf={"medium"}),
    }
    from collections import Counter
    out["confidence_distribution"] = dict(Counter(r.get("confidence") for r in gpt52))

    # Response-level selective-automation coverage curve (gate = auto-grade only
    # responses at/above a confidence level; route the rest to human/escalation).
    conf_order = ["high", "medium", "low"]
    curve = []
    cum = set()
    for lvl in conf_order:
        cum.add(lvl)
        slc = analyze(gpt52, restrict_conf=cum)
        curve.append({
            "gate_auto_grade_at": "+".join([c for c in conf_order if c in cum]),
            "response_coverage": round(slc["response_n"] / len(gpt52), 4),
            "response_n": slc["response_n"],
            "auto_slice_far": slc["overall"]["far"],
            "auto_slice_frr": slc["overall"]["frr"],
            "auto_slice_f1": slc["overall"]["f1"],
            "auto_slice_exact_match": slc["response_exact_match"],
        })
    out["selective_automation_curve"] = curve

    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
