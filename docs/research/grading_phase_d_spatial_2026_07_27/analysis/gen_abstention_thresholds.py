#!/usr/bin/env python3
"""
Generate abstention_thresholds.json deterministically from the observed
per-(archetype,criterion) calibration errors in d4_d5_summary.json.

Per the Stage D5 spec: thresholds are built from OBSERVED calibration errors,
not model confidence. A criterion cell is 'auto_eligible_provisional' only if
its observed false-accept rate is low enough with adequate negative support;
otherwise it is 'human_review_required' (the automated verdict abstains from
being authoritative). The response-level 'withhold total if any point-bearing
criterion abstains' rule then routes the whole response to human review whenever
it contains any human_review_required (or model-abstained) point-bearing
criterion.

HONEST CEILING: no cell clears the DR-1 FAR gate (<=2%) with real negative
support, so the entire policy is SHADOW-ONLY until reader-certified gold exists.
The provisional bar below is an R&D triage bar, not a launch gate.
"""
import json, os

HERE = os.path.dirname(__file__)
SUMMARY = os.path.join(HERE, "d4_d5_summary.json")
OUT = os.path.join(os.path.dirname(HERE), "abstention_thresholds.json")

# Point-bearing criteria: any criterion whose miss should withhold the response
# total. For this graph rubric family every rubric criterion is point-bearing;
# we treat all as point-bearing (conservative — withhold on any abstention).
# R&D triage bar for provisional auto-eligibility.
FAR_AUTO_BAR = 0.05          # observed FAR must be <= this
MIN_NEG_SUPPORT = 8          # fp + tn >= this, else too little evidence -> abstain
DR1_FAR_GATE = 0.02          # the real launch gate; documented, not met anywhere


def main():
    d = json.load(open(SUMMARY))
    cells = d["all_responses"]["by_archetype_criterion"]

    dispositions = {}
    auto = 0
    human = 0
    insufficient = 0
    for cell, m in sorted(cells.items()):
        far = m["far"]
        neg_support = m["fp"] + m["tn"]
        if neg_support < MIN_NEG_SUPPORT:
            action = "human_review_required"
            reason = f"insufficient negative support (fp+tn={neg_support}<{MIN_NEG_SUPPORT}) — cannot certify FAR"
            insufficient += 1
        elif far is not None and far <= FAR_AUTO_BAR:
            action = "auto_eligible_provisional"
            reason = f"observed FAR={far} <= R&D bar {FAR_AUTO_BAR} with negative support {neg_support}"
            auto += 1
        else:
            action = "human_review_required"
            reason = f"observed FAR={far} > R&D bar {FAR_AUTO_BAR}"
            human += 1
        dispositions[cell] = {
            "action": action,
            "observed_far": far,
            "observed_frr": m["frr"],
            "negative_support_fp_plus_tn": neg_support,
            "n_scored": m["n"],
            "reason": reason,
        }

    out = {
        "artifact": "abstention_thresholds.json",
        "stage": "TASK-0016 Phase D — Stage D5",
        "generated": "2026-08-20",
        "generator": "analysis/gen_abstention_thresholds.py (deterministic from analysis/d4_d5_summary.json)",
        "evidence_tier": "ai_provisional gold, iterated corpus, no locked holdout — R&D-tier ONLY, SHADOW-ONLY policy",
        "source_run": "hand_drawn_graph_real_photo_benchmark_2026_08_18/runs/real_photo_benchmark_gpt52_results.jsonl (openai/gpt-5.2, 200 photos)",
        "honest_ceiling": (
            "No (archetype,criterion) cell clears the DR-1 FAR gate (<=2%) with real negative "
            "support. Even the best response-level auto slice (high-confidence gate) sits at ~12% "
            "FAR. This policy is NOT launch-authoritative; it defines what would go to human review "
            "in a 100%-human-reviewed shadow (Stage D6), and where automated output is least "
            "untrustworthy. All thresholds are provisional pending reader-certified gold (D3)."
        ),
        "global_rules": {
            "withhold_total_if_any_point_bearing_criterion_abstains": True,
            "all_rubric_criteria_treated_as_point_bearing": True,
            "retake_new_photo_only_for_fixable_capture_defect": True,
            "non_fixable_or_ambiguous_defect_routes_to": "human_review",
            "response_level_confidence_gate": {
                "auto_grade_only_if_response_confidence": "high",
                "observed_auto_slice": {"coverage": 0.475, "far": 0.1218, "frr": 0.0411, "f1": 0.9623, "exact_match": 0.60},
                "note": "auto slice still fails DR-1 FAR by ~6x; shadow-only",
            },
        },
        "escalation_policy": {
            "EST_medium_confidence_to_gpt_5_2_pro": True,
            "rationale": "archetype-gated escalation (option c') — confirmed clean win on EST only; blanket escalation rejected at full scale",
            "effect_full_corpus": {"exact": "38.5->41.5", "f1": "93.3->93.4", "far": "19.0->13.6", "frr": "8.0->9.0"},
            "hybrid_gate_on_escalation_arm4_option_d": "near-neutral vs gate-alone (see BAKEOFF_RESULTS.md §4); does not clear FAR",
        },
        "self_consistency_policy": {
            "method": "asymmetric majority-earned (2 of 3 gpt-5.2 runs must say 'earned'; 'not_earned' never overridden)",
            "status": "CONFIRMED at full corpus (n=200, 0 missing, 2026-08-20) — directional read holds, magnitude attenuates vs pilot; did NOT reverse",
            "cost": "2 extra gpt-5.2 calls per response (~3x primary cost); $6.64 for the 322-call confirmation run",
            "full_corpus_result": {
                "baseline_run1": {"far": 19.0, "frr": 8.0, "f1": 93.3, "exact": 38.5},
                "majority_earned_2of3": {"far": 14.7, "frr": 9.4, "f1": 93.0, "exact": 38.0},
                "unanimous_earned_3of3": {"far": 9.5, "frr": 11.7, "f1": 92.5, "exact": 36.0},
                "per_archetype_majority_far": {"CAT": "46.9->37.5", "EST": "12.3->7.8", "SER": "33.3->33.3 (no effect — SER errors are not lone-earned-vote shaped)"},
                "pilot_n39_for_reference": "FAR 33.3->21.4 on a hand-picked medium-confidence subsample (harder population than full corpus)",
            },
            "note": "Real FAR lever (19.0->14.7 majority; ->9.5 unanimous) but still fails the <=2% DR-1 gate; costs 3x. Candidate shadow-mode lever, not adopted as default.",
        },
        "criterion_dispositions_summary": {
            "auto_eligible_provisional": auto,
            "human_review_required_high_far": human,
            "human_review_required_insufficient_support": insufficient,
            "total_cells": len(dispositions),
        },
        "criterion_dispositions": dispositions,
    }
    json.dump(out, open(OUT, "w"), indent=2)
    print(f"wrote {OUT}")
    print(f"cells: auto={auto} human(high-FAR)={human} human(insufficient)={insufficient} total={len(dispositions)}")


if __name__ == "__main__":
    main()
