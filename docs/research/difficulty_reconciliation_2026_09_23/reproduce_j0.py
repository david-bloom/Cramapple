#!/usr/bin/env python3
"""Reproduce J.0 bands and audit whether the requested ratios are derivable.

This intentionally emits no proposal row when provenance is insufficient. It
uses the original classifier verb sets and tie-breaking rules verbatim.
"""

import csv
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
CALIBRATION = HERE.parent / "apbio_difficulty_calibration_2026_09_22"

EASY = {
    "identify", "identifies", "state", "states", "name", "names", "list",
    "lists", "label", "labels", "annotate", "annotates", "indicate",
    "indicates", "select", "classify", "classifies", "recall",
}
MEDIUM = {
    "describe", "describes", "determine", "determines", "compare", "compares",
    "contrast", "contrasts", "distinguish", "distinguishes", "construct",
    "constructs", "represent", "represents", "write", "writes", "analyze",
    "analyzes", "apply", "applies", "trace", "traces", "graph", "plot",
    "explain", "explains",
}
HARD = {
    "predict", "predicts", "justify", "justifies", "design", "designs",
    "propose", "proposes", "evaluate", "evaluates", "support", "supports",
    "synthesize", "integrate", "critique", "calculate", "calculates",
}
ORDER = {"Easy": 0, "Medium": 1, "Hard": 2}
ARGUMENTATION = re.compile(
    r"\bclaim\b|\bargument|\bsupports? the\b|\brefut|\bjustif|"
    r"\bevidence that\b|\bevaluate\b",
    re.I,
)
VERB = re.compile(
    r"\b(" + "|".join(sorted(EASY | MEDIUM | HARD, key=len, reverse=True)) + r")\b",
    re.I,
)


def tier(verb: str, context: str) -> str:
    verb = verb.lower()
    if verb in {"explain", "explains"}:
        return "Hard" if ARGUMENTATION.search(context or "") else "Medium"
    if verb in EASY:
        return "Easy"
    if verb in MEDIUM:
        return "Medium"
    if verb in HARD:
        return "Hard"
    raise ValueError(f"unmapped verb: {verb}")


def base_form(verb: str) -> str:
    explicit = {
        "identifies": "identify", "states": "state", "names": "name",
        "labels": "label", "classifies": "classify", "describes": "describe",
        "determines": "determine", "compares": "compare", "contrasts": "contrast",
        "distinguishes": "distinguish", "constructs": "construct",
        "represents": "represent", "writes": "write", "analyzes": "analyze",
        "applies": "apply", "traces": "trace", "explains": "explain",
        "predicts": "predict", "justifies": "justify", "designs": "design",
        "proposes": "propose", "evaluates": "evaluate", "supports": "support",
        "calculates": "calculate",
    }
    return explicit.get(verb, verb)


def main() -> None:
    packet = [json.loads(line) for line in (HERE / "packet.jsonl").read_text().splitlines()]
    assignments = {
        row["content_key"]: row
        for row in csv.DictReader((CALIBRATION / "apbio_difficulty_assignments.csv").open())
    }
    crr_rows = [
        row for row in csv.DictReader((CALIBRATION / "crr_calibration_all_subjects.csv").open())
        if row["subject"] == "AP Biology"
    ]
    crr_by_auto_verb = defaultdict(list)
    for row in crr_rows:
        if row["verb_auto"]:
            crr_by_auto_verb[row["verb_auto"]].append(
                f"AP Biology Q{row['question']} {row['label']} ratio={row['ratio']}"
            )

    writer = csv.DictWriter(sys.stdout, fieldnames=[
        "content_key", "content_item_version_id", "version_num", "item_type",
        "committed_difficulty", "committed_basis", "reproduced_difficulty",
        "band_match", "detected_verbs", "exact_auto_verb_matches",
        "attainment_ratio", "ratio_status", "ratio_blocker",
    ])
    writer.writeheader()
    counts = Counter()

    for item in packet:
        committed = assignments[item["content_key"]]
        detected = []
        tiers = []
        reproduced = ""
        if committed["basis"] == "task verb":
            contexts = (
                [criterion["learner_facing_text"] or "" for criterion in item["criteria"]]
                if item["item_type"] == "frq" else [item["stem"] or ""]
            )
            for context in contexts:
                match = VERB.search(context)
                if match:
                    verb = match.group(1).lower()
                    detected.append(verb)
                    tiers.append(tier(verb, context))
            tier_counts = Counter(tiers)
            top = max(tier_counts.values())
            reproduced = max(
                (name for name, count in tier_counts.items() if count == top),
                key=ORDER.get,
            )
            counts["task_verb"] += 1
            counts["band_match"] += reproduced == committed["difficulty"]
        else:
            counts["judgement"] += 1

        sources = []
        matched_verbs = set()
        for verb in sorted({base_form(value) for value in detected}):
            if verb in crr_by_auto_verb:
                matched_verbs.add(verb)
                sources.extend(crr_by_auto_verb[verb])
        all_verbs = {base_form(value) for value in detected}
        if committed["basis"] == "judgement":
            status = "unavailable_by_design"
            blocker = "judgement basis has no task-verb attainment anchor"
        elif all_verbs and all_verbs == matched_verbs:
            status = "blocked_unverified_source_and_no_aggregation_rule"
            blocker = (
                "verb_auto is explicitly unverified and the method defines no rule "
                "for aggregating multiple CRR ratios into one item ratio"
            )
            counts["fully_exact_auto_joinable"] += 1
        elif matched_verbs:
            status = "blocked_partial_exact_join"
            blocker = "one or more detected verbs have no AP Biology CRR verb_auto rows"
            counts["partially_exact_auto_joinable"] += 1
        else:
            status = "blocked_no_exact_join"
            blocker = "no detected verb has an AP Biology CRR verb_auto row"
            counts["no_exact_auto_join"] += 1

        writer.writerow({
            "content_key": item["content_key"],
            "content_item_version_id": item["content_item_version_id"],
            "version_num": item["version_num"],
            "item_type": item["item_type"],
            "committed_difficulty": committed["difficulty"],
            "committed_basis": committed["basis"],
            "reproduced_difficulty": reproduced,
            "band_match": str(bool(reproduced) and reproduced == committed["difficulty"]).lower(),
            "detected_verbs": "|".join(sorted(set(detected))),
            "exact_auto_verb_matches": "|".join(sources),
            "attainment_ratio": "",
            "ratio_status": status,
            "ratio_blocker": blocker,
        })

if __name__ == "__main__":
    main()
