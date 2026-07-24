#!/usr/bin/env python3
"""Reactive coverage/variation check for collected drawn-response data.

This is deliberately a post-hoc check, not an upfront content assignment.
Tutors producing development responses are given no per-criterion or
per-misconception assignment (a documented decision: undirected human
error production is more representative of real student variance than
scripted error production). This script instead audits whatever came back
to find any criterion or composition category that ended up with no
coverage at all -- the one failure mode undirected collection can produce
that an assignment sheet would have prevented -- so a small, targeted
top-up round can be requested only where needed.

This is NOT a production release gate. It does not enforce
docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md section 12.2's
held-out-set minimums or
docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md section 8.1's locked-
corpus partition targets -- those apply to the full assembled corpus.
Tutor/expert-pilot responses are development evidence only (spec section
8.1: "Expert pilot responses, author-generated cases... do not count as
independent holdout responses"), so this script reports against those
targets for visibility only, clearly labeled as a development-stage read.

Response tags (partial_credit / contradictory_or_inconsistent /
ambiguous_or_adversarial) can be supplied explicitly via --tags, or
derived automatically from the file-naming convention already given to
tutors: <item_id>_<initials>_<tier>_<photo_number>.jpg, where <tier> is
one of full_credit / partial / no_credit / borderline. See
_TIER_NAME_TO_TAG below for the mapping and its known gap.
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

# Spec section 8.1 targets, restated here for visibility only -- these are
# full-corpus targets, not development-partition requirements. See the
# Composition section of the printed report for the caveat.
COMPOSITION_TARGETS = {
    "partial_credit": 0.15,
    "contradictory_or_inconsistent": 0.10,
    "ambiguous_or_adversarial": 0.10,
}
# Maps the tier token in the established filename convention
# (<item_id>_<initials>_<tier>_<n>.jpg) to a characteristic_tag. Note the
# known gap: no tier in the current tutor instructions maps to
# contradictory_or_inconsistent. "no_credit" misconception responses are
# clean wrong answers, not necessarily internally-contradictory ones.
_TIER_NAME_TO_TAG = {
    "full_credit": None,
    "partial": "partial_credit",
    "no_credit": None,
    "borderline": "ambiguous_or_adversarial",
}
_FILENAME_RE = re.compile(r"^(?P<item_id>[^_]+)_(?P<initials>[^_]+)_(?P<tier>[a-z_]+)_(?P<n>\d+)$")


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def derive_tags_from_filenames(filenames: list[str]) -> dict[str, list[str]]:
    """Best-effort tag derivation from the existing naming convention.

    Returns response_id (here treated as the <item_id>_<initials> prefix,
    since one response may have multiple photo files) -> tags. Filenames
    that don't match the convention are skipped and reported separately by
    the caller.
    """
    tags: dict[str, list[str]] = defaultdict(list)
    for filename in filenames:
        stem = Path(filename).stem
        match = _FILENAME_RE.match(stem)
        if not match:
            continue
        response_key = f"{match.group('item_id')}_{match.group('initials')}_{match.group('tier')}"
        tier = match.group("tier")
        tag = _TIER_NAME_TO_TAG.get(tier)
        if tag and tag not in tags[response_key]:
            tags[response_key].append(tag)
    return dict(tags)


def load_tags(tags_path: Path | None) -> dict[str, list[str]]:
    if tags_path is None:
        return {}
    return json.loads(tags_path.read_text(encoding="utf-8"))


def check_criterion_coverage(records: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    by_label: dict[str, Counter] = defaultdict(Counter)
    for record in records:
        by_label[record["criterion_label"]][record["decision"]] += 1

    coverage = {}
    for label, counts in by_label.items():
        met = counts.get("MET", 0)
        not_met = counts.get("NOT_MET", 0)
        abstain = counts.get("ABSTAIN", 0)
        coverage[label] = {
            "MET": met,
            "NOT_MET": not_met,
            "ABSTAIN": abstain,
            "total": met + not_met + abstain + counts.get("NOT_APPLICABLE", 0),
            "missing_positive": met == 0,
            "missing_negative": not_met == 0,
        }
    return coverage


def check_composition(records: list[dict[str, Any]], tags_by_response: dict[str, list[str]]) -> dict[str, Any]:
    response_ids = {(r["item_id"], r["response_id"]) for r in records}
    total = len(response_ids)
    if total == 0:
        return {"total_responses": 0}

    response_keys = {f"{item_id}_{response_id}" for item_id, response_id in response_ids}
    matched_tag_keys = set(tags_by_response.keys()) & response_keys

    result: dict[str, Any] = {"total_responses": total, "responses_with_tags": len(matched_tag_keys)}
    for category, target_fraction in COMPOSITION_TARGETS.items():
        count = sum(1 for key, tags in tags_by_response.items() if key in response_keys and category in tags)
        fraction = count / total if total else 0.0
        result[category] = {
            "count": count,
            "fraction": fraction,
            "target_fraction_full_corpus": target_fraction,
            "below_target": fraction < target_fraction,
        }
    return result


def check_archetype_counts(records: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = defaultdict(int)
    seen = set()
    for record in records:
        key = (record["item_id"], record["response_id"])
        if key in seen:
            continue
        seen.add(key)
        counts[record["item_id"]] += 1
    return dict(counts)


def render_report(
    coverage: dict[str, dict[str, Any]],
    composition: dict[str, Any],
    item_counts: dict[str, int],
    unmatched_filenames: list[str],
) -> str:
    lines = [
        "# Drawn-Response Collected-Data Variation Check",
        "",
        "Development-stage informational read. Not a production release gate",
        "-- see script docstring for why tutor/expert-pilot data does not count",
        "toward the full-corpus targets shown for reference below.",
        "",
        "## Criterion Coverage",
        "",
        "| Criterion label | MET | NOT_MET | ABSTAIN | Total | Gap |",
        "| --- | ---: | ---: | ---: | ---: | --- |",
    ]
    gaps = []
    for label, c in sorted(coverage.items()):
        gap_notes = []
        if c["missing_positive"]:
            gap_notes.append("NO POSITIVE (MET) EXAMPLES")
        if c["missing_negative"]:
            gap_notes.append("NO NEGATIVE (NOT_MET) EXAMPLES")
        gap_text = "; ".join(gap_notes) if gap_notes else "ok"
        if gap_notes:
            gaps.append(f"{label}: {gap_text}")
        lines.append(f"| {label} | {c['MET']} | {c['NOT_MET']} | {c['ABSTAIN']} | {c['total']} | {gap_text} |")

    lines += ["", "## Item / Response Counts", "", "| Item | Responses |", "| --- | ---: |"]
    for item_id, count in sorted(item_counts.items()):
        lines.append(f"| {item_id} | {count} |")

    lines += ["", "## Composition (tagged subset only)", ""]
    if composition.get("total_responses", 0) == 0:
        lines.append("No responses found.")
    else:
        lines.append(f"Total responses: {composition['total_responses']}; tagged: {composition['responses_with_tags']}")
        lines.append("")
        lines.append("| Category | Count | Fraction | Full-corpus target (reference only) | Status |")
        lines.append("| --- | ---: | ---: | ---: | --- |")
        for category in COMPOSITION_TARGETS:
            c = composition[category]
            status = "below reference target" if c["below_target"] else "ok"
            lines.append(f"| {category} | {c['count']} | {c['fraction']:.1%} | {c['target_fraction_full_corpus']:.0%} | {status} |")

    lines += ["", "## Known Structural Gap", ""]
    lines.append(
        "No tier in the current tutor instructions (full_credit / partial / "
        "no_credit / borderline) is designed to produce a "
        "contradictory_or_inconsistent response -- a misconception response "
        "is a clean wrong answer, not an internally-conflicting one. If the "
        "table above shows zero contradictory_or_inconsistent coverage, "
        "that is expected from the current instructions, not a sign tutors "
        "avoided producing one."
    )

    if unmatched_filenames:
        lines += ["", "## Filenames Not Matching The Naming Convention", "", "```"]
        lines += unmatched_filenames[:50]
        lines.append("```")

    lines += ["", "## Findings Requiring A Possible Top-Up Round", ""]
    if gaps:
        for gap in gaps:
            lines.append(f"- {gap}")
    else:
        lines.append("- None. Every criterion has at least one positive and one negative example.")

    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--criterion-decisions", type=Path, required=True, help="JSONL of gold criterion_decision records from labeled tutor responses.")
    parser.add_argument("--tags", type=Path, default=None, help="Optional JSON file: {response_key: [tags]}. If omitted, tags are derived from --filenames.")
    parser.add_argument("--filenames", type=Path, default=None, help="Optional text file, one submitted image filename per line, used to derive tags from the naming convention when --tags is not supplied.")
    parser.add_argument("--output", type=Path, default=None, help="Optional path to write the markdown report.")
    args = parser.parse_args()

    records = load_jsonl(args.criterion_decisions)

    tags_by_response = load_tags(args.tags)
    unmatched_filenames: list[str] = []
    if not tags_by_response and args.filenames and args.filenames.exists():
        filenames = [line.strip() for line in args.filenames.read_text(encoding="utf-8").splitlines() if line.strip()]
        tags_by_response = derive_tags_from_filenames(filenames)
        unmatched_filenames = [f for f in filenames if not _FILENAME_RE.match(Path(f).stem)]

    coverage = check_criterion_coverage(records)
    composition = check_composition(records, tags_by_response)
    item_counts = check_archetype_counts(records)

    report = render_report(coverage, composition, item_counts, unmatched_filenames)

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(report, encoding="utf-8")
        print(f"Wrote {args.output}")
    else:
        print(report)

    gap_count = sum(1 for c in coverage.values() if c["missing_positive"] or c["missing_negative"])
    print(f"\n{gap_count} criterion coverage gap(s) found across {len(coverage)} criteria.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
