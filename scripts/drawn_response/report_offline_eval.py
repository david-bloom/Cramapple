#!/usr/bin/env python3
"""Render an evaluate_offline.py summary.json into a markdown report.

Follows the spirit of docs/research/bio_reference_layer_reporting_standard.md
(run metadata, an integrity check before any metric is trusted, fixed-order
tables, and an explicit claims-supported/not-supported close) by choice, for
consistency with this repo's other research reports. That standard's scope
line names bio reference-layer reports specifically; this script is not
bound by it, but reuses its discipline because the failure mode it guards
against (a report claiming more than its sample size supports) applies
identically to drawn-response evaluation runs.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def pct(value: float | None) -> str:
    return f"{value * 100:.1f}%" if value is not None else "n/a"


def num(value: float | None, digits: int = 3) -> str:
    return f"{value:.{digits}f}" if value is not None else "n/a"


def read_tier(n: int) -> str:
    if n < 10:
        return "Smoke Test"
    if n < 30:
        return "Directional"
    return "Decision-Grade"


def render(summary: dict[str, Any], summary_path: Path) -> str:
    lines: list[str] = []
    lines += [
        "# Drawn-Response Offline Evaluation Report",
        "",
        f"**Method:** `{summary['method_name']}`",
        "**Protocol doc:** `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md` (sections 8.2-8.5)",
        f"**Gold path:** `{summary['gold_path']}`",
        f"**Method path:** `{summary['method_path']}`",
        f"**Weights path:** `{summary['weights_path'] or 'none -- total-score metrics not computed'}`",
        f"**Run-log path:** `{summary['run_log_path'] or 'none -- latency/cost/reviewer-burden metrics not computed'}`",
        f"**Summary file:** `{summary_path}`",
        f"**Decision-grade n threshold:** {summary['decision_grade_n']} (harness convention, see evaluate_offline.py docstring)",
        "",
        "## Integrity Check",
        "",
    ]

    n_paired = summary["n_paired"]
    n_gold = summary["n_gold_records"]
    n_method = summary["n_method_records"]
    checks = [
        (n_paired > 0, f"At least one record paired between gold and method ({n_paired} paired)"),
        (
            len(summary["unmatched_gold"]) == 0 and len(summary["unmatched_method"]) == 0,
            f"Every gold and method record paired (unmatched gold: {len(summary['unmatched_gold'])}, unmatched method: {len(summary['unmatched_method'])})",
        ),
        (
            len(summary["criterion_metrics"]["scope_mismatches"]) == 0,
            f"No NOT_APPLICABLE scope mismatches between gold and method ({len(summary['criterion_metrics']['scope_mismatches'])} found)",
        ),
        (n_gold == n_method, f"Gold and method record counts match ({n_gold} vs {n_method}) -- a mismatch alone is not an error if unmatched records explain it, but should be checked"),
    ]
    for passed, label in checks:
        lines.append(f"- [{'x' if passed else ' '}] {label}")
    lines.append("")

    if summary["unmatched_gold"]:
        lines += ["**Unmatched gold keys (not scored by method):**", "", "```", *summary["unmatched_gold"][:50], "```", ""]
    if summary["unmatched_method"]:
        lines += ["**Unmatched method keys (no gold label):**", "", "```", *summary["unmatched_method"][:50], "```", ""]
    if summary["criterion_metrics"]["scope_mismatches"]:
        lines += ["**Scope mismatches (NOT_APPLICABLE disagreement):**", "", "```", *summary["criterion_metrics"]["scope_mismatches"][:50], "```", ""]

    tier = read_tier(n_paired)
    lines += [
        "## Read Tier",
        "",
        f"**{tier}** (n={n_paired} paired records).",
        "",
    ]
    if tier == "Smoke Test":
        lines.append("This run only demonstrates the harness executes end-to-end. It does not support any quality claim about the method.")
    elif tier == "Directional":
        lines.append("This run may suggest a direction worth scaling to confirm. It must not be cited to apply the section 8.4 decision gates.")
    else:
        lines.append("This run has enough paired records to apply the section 8.4 decision gates, subject to the per-row n shown in the gates table.")
    lines.append("")

    lines += [
        "## Decision Gates (section 8.4)",
        "",
        "| Gate | Required | Observed | n | Status |",
        "| --- | --- | ---: | ---: | --- |",
    ]
    for gate in summary["decision_gates"]:
        comparison = "<=" if gate["gate"] in {"over_scoring_rate", "under_scoring_rate", "severe_error_rate", "false_abstention_rate", "mean_absolute_total_score_error"} else ">="
        observed = pct(gate["observed"]) if gate["gate"] not in {"mean_absolute_total_score_error", "weighted_kappa"} else num(gate["observed"])
        required = pct(gate["required"]) if gate["gate"] not in {"mean_absolute_total_score_error", "weighted_kappa"} else num(gate["required"])
        lines.append(f"| {gate['gate']} | {comparison} {required} | {observed} | {gate['n']} | {gate['status']} |")
    lines.append("")

    lines += [
        "## By Criterion Label",
        "",
        "| Criterion label | n scorable | n abstain-worthy | Exact agreement | Precision | Recall | Coverage | False abstention | Severe error | Escalation recall |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for label, m in sorted(summary["criterion_metrics"]["by_criterion_label"].items()):
        lines.append(
            f"| {label} | {m['n_scorable']} | {m['n_abstain_worthy']} | {pct(m['exact_agreement'])} | "
            f"{pct(m['precision'])} | {pct(m['recall'])} | {pct(m['coverage'])} | "
            f"{pct(m['false_abstention_rate'])} | {pct(m['severe_error_rate'])} | {pct(m['ambiguity_escalation_recall'])} |"
        )
    lines.append("")

    lines += [
        "## Outcome Classification (section 8.5)",
        "",
        "| Criterion label | Outcome | n | Reason |",
        "| --- | --- | ---: | --- |",
    ]
    for label, c in sorted(summary["outcome_classification"].items()):
        lines.append(f"| {label} | `{c['outcome']}` | {c['n']} | {c['reason']} |")
    lines.append("")

    lines += [
        "## Response-Level Agreement",
        "",
        f"Exact criterion-vector agreement: {pct(summary['response_metrics']['exact_criterion_vector_agreement'])} "
        f"({summary['response_metrics']['n_responses']} responses)",
        "",
    ]

    if summary["total_score_metrics"] is not None:
        t = summary["total_score_metrics"]
        lines += [
            "## Total-Score Metrics",
            "",
            f"- Computable responses: {t['n_computable_responses']} (withheld due to abstention: {t['n_withheld_responses']})",
            f"- Total-score exact agreement: {pct(t['total_score_exact_agreement'])}",
            f"- Total-score within one point: {pct(t['total_score_within_one_point'])}",
            f"- Mean absolute total-score error: {num(t['mean_absolute_total_score_error'])}",
            f"- Weighted kappa: {num(t['weighted_kappa'])}",
            "",
        ]

    if summary["run_log_metrics"] is not None:
        r = summary["run_log_metrics"]
        lines += [
            "## Latency, Cost, and Reviewer Burden",
            "",
            f"- Invocations: {r['n_invocations']}",
            f"- p50 latency: {num(r['p50_latency_ms'], 0)} ms",
            f"- p95 latency: {num(r['p95_latency_ms'], 0)} ms",
            f"- Avg cost: ${num(r['avg_cost_usd'], 5)}",
            f"- Cost per accepted result: ${num(r['cost_per_accepted_usd'], 5)}",
            f"- Cost per human-reviewed result: ${num(r['cost_per_reviewed_usd'], 5)}",
            f"- Avg reviewer minutes: {num(r['avg_reviewer_minutes'], 1)}",
            "",
        ]

    pass_gates = [g["gate"] for g in summary["decision_gates"] if g["status"] == "PASS"]
    fail_gates = [g["gate"] for g in summary["decision_gates"] if g["status"] == "FAIL"]
    lines += [
        "## Claims Supported / Claims Not Supported",
        "",
        "**Supported by this run:**",
        "",
    ]
    if tier == "Decision-Grade":
        lines.append(f"- Gates passed at decision-grade sample size: {', '.join(pass_gates) if pass_gates else 'none'}")
        lines.append(f"- Gates failed at decision-grade sample size: {', '.join(fail_gates) if fail_gates else 'none'}")
    else:
        lines.append(f"- The harness ran end-to-end on {n_paired} paired record(s) for method `{summary['method_name']}`")
    lines += [
        "",
        "**Not supported by this run:**",
        "",
        "- Any conclusion about real grading quality: no item in this run has completed the phase-1 section 3.2 authoring/preflight gate, so these are synthetic or development-only labels, not a locked holdout",
    ]
    if tier != "Decision-Grade":
        lines.append("- Application of the section 8.4 decision gates (sample size below decision-grade threshold)")
    lines.append("")

    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("summary", type=Path, help="Path to a summary.json written by evaluate_offline.py")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    summary = json.loads(args.summary.read_text(encoding="utf-8"))
    report = render(summary, args.summary)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(report, encoding="utf-8")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
