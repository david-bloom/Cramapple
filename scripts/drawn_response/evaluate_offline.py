#!/usr/bin/env python3
"""Offline evaluation harness for drawn-response criterion-decision methods.

Implements the metric computations and locked decision gates from
docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md sections 8.2-8.5: compares
one candidate method's criterion_decision records against locked gold
(human_lead_adjudication) records on the same response set, computes
agreement/precision/recall/abstention metrics, checks them against the
section 8.4 thresholds, and classifies each criterion per section 8.5.

This is scaffolding. It has no real corpus data behind it yet (no item has
finished the Phase-1 authoring/preflight gate in section 3.2). Run it on
synthetic fixtures to validate the harness; do not cite its output as
evidence about any method's real grading quality until it runs against a
locked holdout produced under the full section 3.2/6/8.1 process.

Several metric definitions in spec section 8.3 are named but not formulaic
(e.g. "precision," "severe error rate," "coverage after abstention"). Where
this harness had to pick a concrete formula, it is marked
HARNESS CONVENTION in a comment -- these are working definitions for this
tooling, not Learning Quality-approved policy, and should be confirmed or
overridden before any locked holdout run is treated as decision-grade.
"""

from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

DECISIVE = {"MET", "NOT_MET"}
DECISION_GRADE_N_DEFAULT = 30  # HARNESS CONVENTION: borrowed from
# docs/research/bio_reference_layer_reporting_standard.md's read-tier (n>=30)
# for cross-track consistency. TASK-0011 phase-1 spec does not define its
# own sample-size tiering.

# Section 8.4 locked decision gates (criterion-level subset; the long-FRQ
# total-score rows are checked separately in check_decision_gates when a
# weights file is supplied).
CRITERION_GATES = {
    "criterion_exact_agreement_overall": {"required": 0.95, "comparison": "min", "section": "8.4"},
    "criterion_exact_agreement_per_criterion_min": {"required": 0.90, "comparison": "min", "section": "8.4"},
    "criterion_precision_per_criterion_min": {"required": 0.93, "comparison": "min", "section": "8.4"},
    "criterion_precision_macro": {"required": 0.95, "comparison": "min", "section": "8.4"},
    "criterion_recall_per_criterion_min": {"required": 0.93, "comparison": "min", "section": "8.4"},
    "criterion_recall_macro": {"required": 0.95, "comparison": "min", "section": "8.4"},
    "over_scoring_rate": {"required": 0.05, "comparison": "max", "section": "8.4"},
    "under_scoring_rate": {"required": 0.05, "comparison": "max", "section": "8.4"},
    "severe_error_rate": {"required": 0.0, "comparison": "max", "section": "8.4"},
    "ambiguity_escalation_recall": {"required": 0.90, "comparison": "min", "section": "8.4"},
    "false_abstention_rate": {"required": 0.10, "comparison": "max", "section": "8.4"},
}
TOTAL_SCORE_GATES = {
    "total_score_exact_agreement": {"required": 0.80, "comparison": "min", "section": "8.4"},
    "total_score_within_one_point": {"required": 0.98, "comparison": "min", "section": "8.4"},
    "mean_absolute_total_score_error": {"required": 0.25, "comparison": "max", "section": "8.4"},
    "weighted_kappa": {"required": 0.80, "comparison": "min", "section": "8.4"},
}


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def load_weights(path: Path | None) -> dict[str, float] | None:
    if path is None:
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def key_of(record: dict[str, Any]) -> tuple[str, str, str]:
    return (record["item_id"], record["response_id"], record["criterion_id"])


def pair_records(
    gold: list[dict[str, Any]], method: list[dict[str, Any]]
) -> tuple[dict[tuple[str, str, str], tuple[dict[str, Any], dict[str, Any]]], list[str], list[str]]:
    gold_by_key = {key_of(record): record for record in gold}
    method_by_key = {key_of(record): record for record in method}
    if len(gold_by_key) != len(gold):
        raise ValueError("Duplicate (item_id, response_id, criterion_id) keys in gold records")
    if len(method_by_key) != len(method):
        raise ValueError("Duplicate (item_id, response_id, criterion_id) keys in method records")

    paired = {}
    for key in gold_by_key.keys() & method_by_key.keys():
        paired[key] = (gold_by_key[key], method_by_key[key])
    unmatched_gold = [str(key) for key in gold_by_key.keys() - method_by_key.keys()]
    unmatched_method = [str(key) for key in method_by_key.keys() - gold_by_key.keys()]
    return paired, unmatched_gold, unmatched_method


def compute_criterion_level_metrics(
    paired: dict[tuple[str, str, str], tuple[dict[str, Any], dict[str, Any]]]
) -> dict[str, Any]:
    """Section 8.3 criterion-level metrics, computed overall and per criterion_label.

    HARNESS CONVENTION: precision/recall use MET as the positive class and
    are computed only over "confident" pairs (method decision is MET or
    NOT_MET, i.e. not ABSTAIN). Abstaining behavior is reported separately
    via coverage, false_abstention_rate, and ambiguity_escalation_recall so
    it is never silently folded into precision/recall. "Strict" agreement
    additionally counts a false abstention as a miss against decisive gold;
    "quality" (confident-only) agreement does not. This mirrors the
    quality/strict split already used in
    scripts/report_bio_reference_layer_oracle_boundary.py.
    """
    by_label: dict[str, Counter] = defaultdict(Counter)
    scope_mismatches: list[str] = []

    for key, (gold, method) in paired.items():
        g, m = gold["decision"], method["decision"]
        label = gold["criterion_label"]
        counters = by_label[label]
        counters["total_pairs"] += 1

        if g == "NOT_APPLICABLE" or m == "NOT_APPLICABLE":
            if g != m:
                scope_mismatches.append(f"{key}: gold={g} method={m}")
                counters["scope_mismatch"] += 1
            else:
                counters["both_not_applicable"] += 1
            continue

        if g in DECISIVE:
            counters["scorable"] += 1
            if m == g:
                counters["strict_correct"] += 1
            if m == "ABSTAIN":
                counters["false_abstentions"] += 1
            else:
                counters["confident"] += 1
                if m == g:
                    counters["quality_correct"] += 1
                elif m == "MET" and g == "NOT_MET":
                    counters["over_scoring"] += 1
                elif m == "NOT_MET" and g == "MET":
                    counters["under_scoring"] += 1
                if m == "MET" and g == "MET":
                    counters["tp"] += 1
                if m == "MET" and g == "NOT_MET":
                    counters["fp"] += 1
                if m == "NOT_MET" and g == "MET":
                    counters["fn"] += 1
        elif g == "ABSTAIN":
            counters["abstain_total"] += 1
            if m == "ABSTAIN":
                counters["escalation_hits"] += 1
            else:
                counters["abstain_overrides"] += 1

    per_label = {}
    for label, c in by_label.items():
        scorable = c["scorable"]
        confident = c["confident"]
        abstain_total = c["abstain_total"]
        denom_all = scorable + abstain_total  # excludes NOT_APPLICABLE/scope_mismatch by construction
        per_label[label] = {
            "n_pairs": c["total_pairs"],
            "n_scorable": scorable,
            "n_abstain_worthy": abstain_total,
            "n_scope_mismatch": c["scope_mismatch"],
            "exact_agreement": ((c["strict_correct"] + c["escalation_hits"]) / denom_all) if denom_all else None,
            "quality_agreement": (c["quality_correct"] / confident) if confident else None,
            "strict_agreement": (c["strict_correct"] / scorable) if scorable else None,
            "precision": (c["tp"] / (c["tp"] + c["fp"])) if (c["tp"] + c["fp"]) else None,
            "recall": (c["tp"] / (c["tp"] + c["fn"])) if (c["tp"] + c["fn"]) else None,
            "coverage": (confident / scorable) if scorable else None,
            "false_abstention_rate": (c["false_abstentions"] / scorable) if scorable else None,
            "over_scoring_rate": (c["over_scoring"] / confident) if confident else None,
            "under_scoring_rate": (c["under_scoring"] / confident) if confident else None,
            "severe_error_rate": ((c["over_scoring"] + c["under_scoring"]) / confident) if confident else None,
            "ambiguity_escalation_recall": (c["escalation_hits"] / abstain_total) if abstain_total else None,
            "abstain_override_count": c["abstain_overrides"],
        }

    overall_denom = sum(c["scorable"] + c["abstain_total"] for c in by_label.values())
    overall_correct = sum(c["strict_correct"] + c["escalation_hits"] for c in by_label.values())
    overall_exact_agreement = (overall_correct / overall_denom) if overall_denom else None

    precisions = [v["precision"] for v in per_label.values() if v["precision"] is not None]
    recalls = [v["recall"] for v in per_label.values() if v["recall"] is not None]

    return {
        "by_criterion_label": per_label,
        "overall_exact_agreement": overall_exact_agreement,
        "overall_n_pairs": sum(c["total_pairs"] for c in by_label.values()),
        "precision_macro": statistics.mean(precisions) if precisions else None,
        "recall_macro": statistics.mean(recalls) if recalls else None,
        "scope_mismatches": scope_mismatches,
    }


def compute_response_level_metrics(
    paired: dict[tuple[str, str, str], tuple[dict[str, Any], dict[str, Any]]]
) -> dict[str, Any]:
    """Section 8.3 'response-level exact criterion-vector agreement.'"""
    by_response: dict[tuple[str, str], list[bool]] = defaultdict(list)
    for (item_id, response_id, _criterion_id), (gold, method) in paired.items():
        by_response[(item_id, response_id)].append(gold["decision"] == method["decision"])

    n_responses = len(by_response)
    n_exact = sum(1 for matches in by_response.values() if all(matches))
    return {
        "n_responses": n_responses,
        "exact_criterion_vector_agreement": (n_exact / n_responses) if n_responses else None,
    }


def quadratic_weighted_kappa(pairs: list[tuple[int, int]], max_score: int) -> float | None:
    if not pairs:
        return None
    n_categories = max_score + 1
    observed = [[0] * n_categories for _ in range(n_categories)]
    for gold_score, method_score in pairs:
        observed[gold_score][method_score] += 1

    gold_marginal = [sum(row) for row in observed]
    method_marginal = [sum(observed[i][j] for i in range(n_categories)) for j in range(n_categories)]
    total = len(pairs)

    weights = [[((i - j) ** 2) / ((n_categories - 1) ** 2) if n_categories > 1 else 0.0 for j in range(n_categories)] for i in range(n_categories)]

    observed_weighted = sum(weights[i][j] * observed[i][j] for i in range(n_categories) for j in range(n_categories))
    expected_weighted = sum(
        weights[i][j] * (gold_marginal[i] * method_marginal[j] / total)
        for i in range(n_categories)
        for j in range(n_categories)
    )
    if expected_weighted == 0:
        return 1.0 if observed_weighted == 0 else None
    return 1 - (observed_weighted / expected_weighted)


def compute_total_score_metrics(
    paired: dict[tuple[str, str, str], tuple[dict[str, Any], dict[str, Any]]],
    weights: dict[str, float] | None,
) -> dict[str, Any] | None:
    """Section 8.3 total-score metrics. Requires a criterion_id -> points weights file.

    Section 7.2: "A response-level total is withheld whenever any
    point-bearing criterion abstains." This harness withholds a response's
    total (on whichever side abstained) and excludes it from these metrics,
    reporting how many responses were withheld.
    """
    if weights is None:
        return None

    by_response: dict[tuple[str, str], dict[str, list[dict[str, Any]]]] = defaultdict(lambda: {"gold": [], "method": []})
    for (item_id, response_id, criterion_id), (gold, method) in paired.items():
        if criterion_id not in weights:
            continue
        by_response[(item_id, response_id)]["gold"].append(gold)
        by_response[(item_id, response_id)]["method"].append(method)

    max_score = round(sum(weights.values()))
    score_pairs: list[tuple[int, int]] = []
    diffs: list[int] = []
    withheld = 0

    for records in by_response.values():
        gold_decisions = records["gold"]
        method_decisions = records["method"]
        if any(r["decision"] == "ABSTAIN" for r in gold_decisions + method_decisions):
            withheld += 1
            continue
        gold_total = round(sum(weights[r["criterion_id"]] for r in gold_decisions if r["decision"] == "MET"))
        method_total = round(sum(weights[r["criterion_id"]] for r in method_decisions if r["decision"] == "MET"))
        score_pairs.append((gold_total, method_total))
        diffs.append(abs(gold_total - method_total))

    n = len(score_pairs)
    if n == 0:
        return {
            "n_computable_responses": 0,
            "n_withheld_responses": withheld,
            "total_score_exact_agreement": None,
            "total_score_within_one_point": None,
            "mean_absolute_total_score_error": None,
            "weighted_kappa": None,
        }

    exact = sum(1 for g, m in score_pairs if g == m) / n
    within_one = sum(1 for d in diffs if d <= 1) / n
    mae = statistics.mean(diffs)
    kappa = quadratic_weighted_kappa(score_pairs, max_score)

    return {
        "n_computable_responses": n,
        "n_withheld_responses": withheld,
        "total_score_exact_agreement": exact,
        "total_score_within_one_point": within_one,
        "mean_absolute_total_score_error": mae,
        "weighted_kappa": kappa,
    }


def _gate_status(value: float | None, required: float, comparison: str, min_n: int, n: int) -> str:
    if value is None or n == 0:
        return "NOT_COMPUTABLE"
    if n < min_n:
        return "INSUFFICIENT_N"
    if comparison == "min":
        return "PASS" if value >= required else "FAIL"
    return "PASS" if value <= required else "FAIL"


def check_decision_gates(
    criterion_metrics: dict[str, Any],
    total_score_metrics: dict[str, Any] | None,
    decision_grade_n: int,
) -> list[dict[str, Any]]:
    rows = []
    by_label = criterion_metrics["by_criterion_label"]

    per_criterion_min = {
        "criterion_exact_agreement_per_criterion_min": "exact_agreement",
        "criterion_precision_per_criterion_min": "precision",
        "criterion_recall_per_criterion_min": "recall",
    }
    for gate_name, field in per_criterion_min.items():
        gate = CRITERION_GATES[gate_name]
        values = [(label, m[field], m["n_scorable"]) for label, m in by_label.items() if m[field] is not None]
        if not values:
            rows.append({"gate": gate_name, "section": gate["section"], "required": gate["required"], "observed": None, "n": 0, "status": "NOT_COMPUTABLE"})
            continue
        worst_label, worst_value, worst_n = min(values, key=lambda item: item[1])
        rows.append(
            {
                "gate": gate_name,
                "section": gate["section"],
                "required": gate["required"],
                "observed": worst_value,
                "observed_at": worst_label,
                "n": worst_n,
                "status": _gate_status(worst_value, gate["required"], gate["comparison"], decision_grade_n, worst_n),
            }
        )

    macro_rows = {
        "criterion_exact_agreement_overall": (criterion_metrics["overall_exact_agreement"], criterion_metrics["overall_n_pairs"]),
        "criterion_precision_macro": (criterion_metrics["precision_macro"], criterion_metrics["overall_n_pairs"]),
        "criterion_recall_macro": (criterion_metrics["recall_macro"], criterion_metrics["overall_n_pairs"]),
    }
    for gate_name, (value, n) in macro_rows.items():
        gate = CRITERION_GATES[gate_name]
        rows.append(
            {
                "gate": gate_name,
                "section": gate["section"],
                "required": gate["required"],
                "observed": value,
                "n": n,
                "status": _gate_status(value, gate["required"], gate["comparison"], decision_grade_n, n),
            }
        )

    pooled_rate_gates = {
        "over_scoring_rate": "over_scoring_rate",
        "under_scoring_rate": "under_scoring_rate",
        "severe_error_rate": "severe_error_rate",
        "ambiguity_escalation_recall": "ambiguity_escalation_recall",
        "false_abstention_rate": "false_abstention_rate",
    }
    for gate_name, field in pooled_rate_gates.items():
        gate = CRITERION_GATES[gate_name]
        n_field = "n_abstain_worthy" if field == "ambiguity_escalation_recall" else "n_scorable"
        values = [(m[field], m[n_field]) for m in by_label.values() if m[field] is not None]
        if not values:
            rows.append({"gate": gate_name, "section": gate["section"], "required": gate["required"], "observed": None, "n": 0, "status": "NOT_COMPUTABLE"})
            continue
        total_n = sum(n for _, n in values)
        weighted = sum(v * n for v, n in values) / total_n if total_n else None
        rows.append(
            {
                "gate": gate_name,
                "section": gate["section"],
                "required": gate["required"],
                "observed": weighted,
                "n": total_n,
                "status": _gate_status(weighted, gate["required"], gate["comparison"], decision_grade_n, total_n),
            }
        )

    if total_score_metrics is None:
        for gate_name, gate in TOTAL_SCORE_GATES.items():
            rows.append({"gate": gate_name, "section": gate["section"], "required": gate["required"], "observed": None, "n": 0, "status": "NOT_COMPUTABLE", "reason": "no weights file provided"})
    else:
        n = total_score_metrics["n_computable_responses"]
        for gate_name, gate in TOTAL_SCORE_GATES.items():
            value = total_score_metrics[gate_name]
            rows.append(
                {
                    "gate": gate_name,
                    "section": gate["section"],
                    "required": gate["required"],
                    "observed": value,
                    "n": n,
                    "status": _gate_status(value, gate["required"], gate["comparison"], decision_grade_n, n),
                }
            )

    return rows


def classify_outcomes(criterion_metrics: dict[str, Any], decision_grade_n: int) -> dict[str, dict[str, Any]]:
    """Section 8.5 outcome classification, per criterion_label.

    HARNESS CONVENTION (section 8.5 names the four outcomes but not a
    decision rule): UNSUPPORTED if every gold decision in scope is
    ABSTAIN/NOT_APPLICABLE with zero scorable cases observed (the rubric
    never produced a decidable gold case in this run); MORE_EVIDENCE_REQUIRED
    if n_scorable + n_abstain_worthy is below decision_grade_n; otherwise
    AUTOMATION_CANDIDATE if every section 8.4 per-criterion threshold for
    that label passes, else HUMAN_REVIEW_REQUIRED.
    """
    classifications = {}
    for label, m in criterion_metrics["by_criterion_label"].items():
        n = m["n_scorable"] + m["n_abstain_worthy"]
        if m["n_scorable"] == 0 and m["n_abstain_worthy"] > 0:
            classifications[label] = {"outcome": "UNSUPPORTED", "n": n, "reason": "no scorable gold decisions observed; all cases abstained"}
        elif n < decision_grade_n:
            classifications[label] = {"outcome": "MORE_EVIDENCE_REQUIRED", "n": n, "reason": f"n={n} below decision-grade threshold {decision_grade_n}"}
        else:
            passes = (
                (m["exact_agreement"] or 0) >= 0.90
                and (m["precision"] or 0) >= 0.93
                and (m["recall"] or 0) >= 0.93
                and (m["false_abstention_rate"] if m["false_abstention_rate"] is not None else 1.0) <= 0.10
                and m["abstain_override_count"] == 0
            )
            classifications[label] = {
                "outcome": "AUTOMATION_CANDIDATE" if passes else "HUMAN_REVIEW_REQUIRED",
                "n": n,
                "reason": "meets section 8.4 per-criterion thresholds" if passes else "fails one or more section 8.4 per-criterion thresholds",
            }
    return classifications


def compute_run_log_metrics(run_log: list[dict[str, Any]] | None) -> dict[str, Any] | None:
    if not run_log:
        return None
    latencies = [r["latency_ms"] for r in run_log if r.get("latency_ms") is not None]
    costs = [r["cost_usd"] for r in run_log if r.get("cost_usd") is not None]
    reviewer_minutes = [r["reviewer_minutes"] for r in run_log if r.get("reviewer_minutes") is not None]
    accepted = [r for r in run_log if not r.get("human_reviewed")]
    reviewed = [r for r in run_log if r.get("human_reviewed")]

    def p95(values: list[float]) -> float | None:
        if not values:
            return None
        ordered = sorted(values)
        return ordered[min(int(len(ordered) * 0.95), len(ordered) - 1)]

    return {
        "n_invocations": len(run_log),
        "p50_latency_ms": statistics.median(latencies) if latencies else None,
        "p95_latency_ms": p95(latencies),
        "avg_cost_usd": statistics.mean(costs) if costs else None,
        "cost_per_accepted_usd": (sum(r.get("cost_usd") or 0 for r in accepted) / len(accepted)) if accepted else None,
        "cost_per_reviewed_usd": (sum(r.get("cost_usd") or 0 for r in reviewed) / len(reviewed)) if reviewed else None,
        "avg_reviewer_minutes": statistics.mean(reviewer_minutes) if reviewer_minutes else None,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--gold", type=Path, required=True, help="JSONL of human_lead_adjudication criterion_decision records.")
    parser.add_argument("--method", type=Path, required=True, help="JSONL of one candidate method's criterion_decision records.")
    parser.add_argument("--method-name", required=True, help="Label for this run, e.g. one of the section 8.2 method names.")
    parser.add_argument("--weights", type=Path, default=None, help="Optional JSON file mapping criterion_id -> points, for total-score metrics.")
    parser.add_argument("--run-log", type=Path, default=None, help="Optional JSONL of method_run_log records for latency/cost/reviewer-burden metrics.")
    parser.add_argument("--decision-grade-n", type=int, default=DECISION_GRADE_N_DEFAULT)
    parser.add_argument("--output", type=Path, required=True, help="Path to write the summary.json.")
    args = parser.parse_args()

    gold = load_jsonl(args.gold)
    method = load_jsonl(args.method)
    weights = load_weights(args.weights)
    run_log = load_jsonl(args.run_log) if args.run_log else None

    paired, unmatched_gold, unmatched_method = pair_records(gold, method)

    criterion_metrics = compute_criterion_level_metrics(paired)
    response_metrics = compute_response_level_metrics(paired)
    total_score_metrics = compute_total_score_metrics(paired, weights)
    gates = check_decision_gates(criterion_metrics, total_score_metrics, args.decision_grade_n)
    outcomes = classify_outcomes(criterion_metrics, args.decision_grade_n)
    run_log_metrics = compute_run_log_metrics(run_log)

    summary = {
        "method_name": args.method_name,
        "gold_path": str(args.gold),
        "method_path": str(args.method),
        "weights_path": str(args.weights) if args.weights else None,
        "run_log_path": str(args.run_log) if args.run_log else None,
        "decision_grade_n": args.decision_grade_n,
        "n_gold_records": len(gold),
        "n_method_records": len(method),
        "n_paired": len(paired),
        "unmatched_gold": unmatched_gold,
        "unmatched_method": unmatched_method,
        "criterion_metrics": criterion_metrics,
        "response_metrics": response_metrics,
        "total_score_metrics": total_score_metrics,
        "decision_gates": gates,
        "outcome_classification": outcomes,
        "run_log_metrics": run_log_metrics,
    }

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(summary, indent=2, sort_keys=True), encoding="utf-8")

    print(f"Wrote {args.output}")
    print(f"Paired {len(paired)} records ({len(unmatched_gold)} unmatched gold, {len(unmatched_method)} unmatched method)")
    if criterion_metrics["scope_mismatches"]:
        print(f"WARNING: {len(criterion_metrics['scope_mismatches'])} NOT_APPLICABLE scope mismatches -- see summary.json")
    failing = [g for g in gates if g["status"] == "FAIL"]
    print(f"Decision gates: {sum(1 for g in gates if g['status'] == 'PASS')} PASS, {len(failing)} FAIL, "
          f"{sum(1 for g in gates if g['status'] == 'INSUFFICIENT_N')} INSUFFICIENT_N, "
          f"{sum(1 for g in gates if g['status'] == 'NOT_COMPUTABLE')} NOT_COMPUTABLE")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
