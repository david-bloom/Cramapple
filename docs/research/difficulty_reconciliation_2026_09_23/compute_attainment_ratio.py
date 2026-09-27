#!/usr/bin/env python3
"""Compute the DECISION-0065 AP Biology attainment-ratio proposal.

Inputs:
- j0_reproduction.csv: existing item scope and detected task verbs.
- crr_rows_to_verify.csv: the approved 87-row CRR scope.
- verb_verification.csv: two-model verification output for those 87 rows.

Output:
- attainment_ratio_proposal.csv
"""

import csv
import json
from collections import Counter, defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
DECISION_DIR = HERE.parent / "apbio_j0_ratio_decision_2026_09_24"

SUBJECT_MEANS = {
    "AP Physics 2": 0.653,
    "AP Physics C: E&M": 0.603,
    "AP Biology": 0.549,
    "AP Physics C: Mech": 0.548,
    "AP Calculus BC": 0.546,
    "AP Precalculus": 0.448,
    "AP Chemistry": 0.440,
    "AP Calculus AB": 0.439,
}
BIOLOGY_MEAN = SUBJECT_MEANS["AP Biology"]

EASY = {"identify", "state", "name", "list", "label", "annotate", "indicate", "select", "classify", "recall"}
MEDIUM = {
    "describe", "explain", "determine", "compare", "contrast", "distinguish", "construct",
    "represent", "write", "analyze", "apply", "trace", "graph", "plot",
}
HARD = {"justify", "predict", "evaluate", "design", "propose", "support", "synthesize", "integrate", "critique", "calculate"}
ZERO_CRR_VERBS = {"apply", "classify", "contrast", "distinguish", "label", "name", "support", "trace"}

BASE_FORM = {
    "identifies": "identify",
    "states": "state",
    "names": "name",
    "labels": "label",
    "classifies": "classify",
    "describes": "describe",
    "determines": "determine",
    "compares": "compare",
    "contrasts": "contrast",
    "distinguishes": "distinguish",
    "constructs": "construct",
    "represents": "represent",
    "writes": "write",
    "analyzes": "analyze",
    "applies": "apply",
    "traces": "trace",
    "explains": "explain",
    "predicts": "predict",
    "justifies": "justify",
    "designs": "design",
    "proposes": "propose",
    "evaluates": "evaluate",
    "supports": "support",
    "calculates": "calculate",
}


def base_form(verb: str) -> str:
    value = (verb or "").strip().lower()
    return BASE_FORM.get(value, value)


def tier_for(verb: str) -> str:
    if verb in EASY:
        return "Easy"
    if verb in MEDIUM:
        return "Medium"
    if verb in HARD:
        return "Hard"
    raise ValueError(f"unmapped verb tier: {verb}")


def ratio_band(value: float) -> str:
    if value <= 0.49:
        return "Hard"
    if value >= 0.75:
        return "Easy"
    return "Medium"


def mean(values: list[float]) -> float:
    return sum(values) / len(values)


def normalized_ratio(row: dict[str, str]) -> float:
    raw = float(row["ratio"])
    if row["subject"] == "AP Biology":
        return raw
    shifted = BIOLOGY_MEAN + (raw - SUBJECT_MEANS[row["subject"]])
    return min(1.0, max(0.0, shifted))


def row_key(row: dict[str, str]) -> tuple[str, str, str]:
    return row["subject"], row["question"], row["label"]


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def main() -> None:
    crr_rows = read_csv(DECISION_DIR / "crr_rows_to_verify.csv")
    verifications = read_csv(HERE / "verb_verification.csv")
    items = read_csv(HERE / "j0_reproduction.csv")

    crr_by_key = {row_key(row): row for row in crr_rows}
    verification_by_key = {row_key(row): row for row in verifications}
    if set(crr_by_key) != set(verification_by_key):
        missing = sorted(set(crr_by_key) - set(verification_by_key))
        extra = sorted(set(verification_by_key) - set(crr_by_key))
        raise SystemExit(f"verification scope mismatch: missing={missing} extra={extra}")

    exact_rows_by_verb: dict[str, list[dict[str, object]]] = defaultdict(list)
    verification_counts = Counter()
    for key, crr_row in crr_by_key.items():
        verified = verification_by_key[key]
        agree = verified["agree"].strip().lower() == "true"
        verification_counts["rows"] += 1
        verification_counts["agree" if agree else "disagree"] += 1
        if not agree:
            continue
        verb = base_form(verified["verified_verb"])
        if not verb:
            continue
        ratio = normalized_ratio(crr_row)
        exact_rows_by_verb[verb].append({
            "subject": crr_row["subject"],
            "question": crr_row["question"],
            "label": crr_row["label"],
            "raw_ratio": float(crr_row["ratio"]),
            "normalized_ratio": ratio,
            "normalization": (
                "none"
                if crr_row["subject"] == "AP Biology"
                else f"{crr_row['ratio']}-{SUBJECT_MEANS[crr_row['subject']]:.3f}+{BIOLOGY_MEAN:.3f}"
            ),
        })

    exact_ratio_by_verb = {
        verb: mean([float(row["normalized_ratio"]) for row in rows])
        for verb, rows in exact_rows_by_verb.items()
    }

    tier_exact_ratios: dict[str, list[tuple[str, float]]] = defaultdict(list)
    for verb, ratio in exact_ratio_by_verb.items():
        tier_exact_ratios[tier_for(verb)].append((verb, ratio))

    fieldnames = [
        "content_key",
        "content_item_version_id",
        "attainment_ratio",
        "ratio_status",
        "ratio_basis",
        "contributing_verbs",
        "committed_difficulty",
        "ratio_cutpoint_band",
        "cutpoint_vs_committed",
    ]
    output_path = HERE / "attainment_ratio_proposal.csv"
    with output_path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()

        item_counts = Counter()
        contribution_counts = Counter()
        for item in items:
            if item["committed_basis"] == "judgement":
                writer.writerow({
                    "content_key": item["content_key"],
                    "content_item_version_id": item["content_item_version_id"],
                    "attainment_ratio": "",
                    "ratio_status": "unavailable",
                    "ratio_basis": "",
                    "contributing_verbs": "[]",
                    "committed_difficulty": item["committed_difficulty"],
                    "ratio_cutpoint_band": "",
                    "cutpoint_vs_committed": "unavailable_judgement_basis",
                })
                item_counts["judgement_null"] += 1
                continue

            verbs = sorted({base_form(value) for value in item["detected_verbs"].split("|") if value})
            contributions = []
            for verb in verbs:
                if verb in exact_ratio_by_verb:
                    ratio = exact_ratio_by_verb[verb]
                    contributions.append({
                        "verb": verb,
                        "ratio": round(ratio, 6),
                        "ratio_source": "exact_verb",
                        "source_rows": exact_rows_by_verb[verb],
                    })
                    contribution_counts["exact_verb"] += 1
                    continue

                if verb in ZERO_CRR_VERBS:
                    tier = tier_for(verb)
                    siblings = [(v, r) for v, r in tier_exact_ratios[tier] if v != verb]
                    if siblings:
                        ratio = mean([r for _, r in siblings])
                        contributions.append({
                            "verb": verb,
                            "ratio": round(ratio, 6),
                            "ratio_source": "tier_fallback",
                            "source_verbs": [{"verb": v, "ratio": round(r, 6)} for v, r in siblings],
                        })
                        contribution_counts["tier_fallback"] += 1
                        continue

                contribution_counts["unresolved"] += 1

            if not contributions:
                writer.writerow({
                    "content_key": item["content_key"],
                    "content_item_version_id": item["content_item_version_id"],
                    "attainment_ratio": "",
                    "ratio_status": "unavailable",
                    "ratio_basis": "",
                    "contributing_verbs": "[]",
                    "committed_difficulty": item["committed_difficulty"],
                    "ratio_cutpoint_band": "",
                    "cutpoint_vs_committed": "unavailable_no_resolved_verb",
                })
                item_counts["task_verb_unavailable"] += 1
                continue

            value = mean([float(contribution["ratio"]) for contribution in contributions])
            sources = {str(contribution["ratio_source"]) for contribution in contributions}
            if sources == {"exact_verb"}:
                basis = "all_exact"
            elif sources == {"tier_fallback"}:
                basis = "all_tier_fallback"
            else:
                basis = "mixed"
            band = ratio_band(value)
            comparison = "same" if band == item["committed_difficulty"] else "different"
            writer.writerow({
                "content_key": item["content_key"],
                "content_item_version_id": item["content_item_version_id"],
                "attainment_ratio": f"{value:.6f}",
                "ratio_status": "computed",
                "ratio_basis": basis,
                "contributing_verbs": json.dumps(contributions, sort_keys=True),
                "committed_difficulty": item["committed_difficulty"],
                "ratio_cutpoint_band": band,
                "cutpoint_vs_committed": comparison,
            })
            item_counts["task_verb_computed"] += 1
            item_counts[f"basis_{basis}"] += 1
            item_counts[f"cutpoint_{comparison}"] += 1

    metadata = {
        "verification_counts": dict(verification_counts),
        "item_counts": dict(item_counts),
        "contribution_counts": dict(contribution_counts),
        "exact_ratio_by_verb": {verb: round(value, 6) for verb, value in sorted(exact_ratio_by_verb.items())},
        "subject_means_source": "docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2",
        "normalization_rule": "AP Biology mean + (source ratio - source subject mean), clipped to [0, 1]",
        "exact_verb_aggregation": "mean of normalized verified CRR rows for the verified verb",
        "tier_fallback_aggregation": "mean of same-tier exact verb-level ratios, excluding the fallback verb",
    }
    (HERE / "attainment_ratio_run_metadata.json").write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
