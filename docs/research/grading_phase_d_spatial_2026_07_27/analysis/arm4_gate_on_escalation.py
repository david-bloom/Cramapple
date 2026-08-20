#!/usr/bin/env python3
"""
D4 arm 4 (owner-selected reading: design-doc option (d) — "hybrid: escalate
first, then confidence-gate the result before treating it as authoritative").

Zero new model spend: reuses the already-collected gpt-5.2 baseline (200) and
gpt-5.2-pro escalation (105 medium-confidence) runs. Builds the confirmed
EST-gated escalation corpus (option c'), then applies a response-level
confidence gate on the *post-escalation* result, and compares the resulting
authoritative slice against option (b) (confidence-gate the raw primary output).

R&D-tier only — ai_provisional gold, iterated corpus, no locked holdout.
"""
import json, os
from collections import Counter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "..", ".."))
BENCH = os.path.join(ROOT, "docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18")
BASELINE = os.path.join(BENCH, "runs/real_photo_benchmark_gpt52_results.jsonl")
ESCAL = os.path.join(BENCH, "runs/escalation_full_results.jsonl")
EST = "continuous_relationship_graph_derived_estimate"
ABSTAIN = {"unable_to_determine", "abstain", None, ""}


def load(p):
    return [json.loads(l) for l in open(p) if l.strip()]


def key(r):
    return f"{r['item_id']} {r['file_name']}"


def confusion(records):
    tp = fp = fn = tn = 0
    exact = 0
    for r in records:
        if r.get("exact_match"):
            exact += 1
        gold = r.get("gold_criterion_statuses", {})
        pred = r.get("criterion_statuses", {})
        for c, g in gold.items():
            p = pred.get(c)
            if g in ABSTAIN or p in ABSTAIN:
                continue
            if g == "earned" and p == "earned":
                tp += 1
            elif g == "not_earned" and p == "earned":
                fp += 1
            elif g == "earned" and p == "not_earned":
                fn += 1
            elif g == "not_earned" and p == "not_earned":
                tn += 1
    prec = tp / (tp + fp) if (tp + fp) else None
    rec = tp / (tp + fn) if (tp + fn) else None
    f1 = (2 * prec * rec / (prec + rec)) if (prec and rec) else None
    return {
        "response_n": len(records),
        "exact_match": round(exact / len(records), 4) if records else None,
        "far": round(fp / (fp + tn), 4) if (fp + tn) else None,
        "frr": round(fn / (fn + tp), 4) if (fn + tp) else None,
        "f1": round(f1, 4) if f1 is not None else None,
        "tp": tp, "fp": fp, "fn": fn, "tn": tn,
    }


def main():
    baseline = load(BASELINE)
    escal = {key(r): r for r in load(ESCAL)}

    # Option c': EST-gated escalation — replace EST medium-confidence responses
    # with their escalated result, keep everyone else on the primary call.
    est_gated = []
    for r in baseline:
        if r.get("confidence") == "medium" and r.get("archetype") == EST and key(r) in escal:
            est_gated.append(escal[key(r)])
        else:
            est_gated.append(r)

    # Option (d): confidence-gate the post-escalation corpus. Auto-grade only
    # responses whose FINAL (post-escalation) confidence is 'high'; route the
    # rest to human review.
    d_auto = [r for r in est_gated if r.get("confidence") == "high"]
    d_routed = [r for r in est_gated if r.get("confidence") != "high"]

    # Option (b) reference: confidence-gate the raw primary output.
    b_auto = [r for r in baseline if r.get("confidence") == "high"]

    out = {
        "note": "R&D-tier; ai_provisional gold; no locked holdout. Zero new spend (reuses existing runs).",
        "arm4_reading": "design-doc option (d): EST-gated escalation, then confidence-gate the result",
        "full_corpus_gpt52_baseline": confusion(baseline),
        "option_c_prime_EST_gated_full_corpus": confusion(est_gated),
        "post_escalation_confidence_distribution": dict(Counter(r.get("confidence") for r in est_gated)),
        "option_d_autograde_slice": {
            **confusion(d_auto),
            "response_coverage": round(len(d_auto) / len(est_gated), 4),
        },
        "option_d_routed_to_human_slice": {
            **confusion(d_routed),
            "response_coverage": round(len(d_routed) / len(est_gated), 4),
        },
        "option_b_reference_autograde_raw_primary": {
            **confusion(b_auto),
            "response_coverage": round(len(b_auto) / len(baseline), 4),
        },
    }
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
