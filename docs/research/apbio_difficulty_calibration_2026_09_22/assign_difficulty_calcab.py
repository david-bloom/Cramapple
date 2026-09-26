#!/usr/bin/env python3
"""Assign first-pass AP Calculus AB difficulty from a Production packet export.

Usage:
  python3 assign_difficulty_calcab.py /path/to/apcalcab_difficulty_items.json

The output path is fixed beside this script so the run is reproducible. This is
a Calculus-specific variant of Method A: it preserves the modal criterion tier
and upward tie-break, but recognizes the phrasing actually used in this corpus.
Routine calculation is Medium; argumentation/proof or non-routine multi-stage
work is Hard; direct recall/read-off/definition recognition is Easy.
"""

import csv
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"
TIERS = {"Easy": 1, "Medium": 2, "Hard": 3}

ARGUMENT = re.compile(
    r"\b(justif\w*|argument\w*|support\w* (?:the |a )?claim|refut\w*|"
    r"evidence that|prove\w*|show that|"
    r"sign analysis|sign change|compare\w* (?:the )?(?:endpoints|candidates)|"
    r"insufficient)\b",
    re.I,
)
DIRECT = re.compile(
    r"\b(identif\w*|state\w*|name\w*|list\w*|label\w*|indicat\w*|"
    r"select\w*|recall\w*|read\w*|recogniz\w*|substitut\w*|"
    r"from (?:the )?(?:table|graph)|definition)\b",
    re.I,
)
ROUTINE = re.compile(
    r"\b(find\w*|determin\w*|calculat\w*|comput\w*|evaluat\w*|"
    r"differentiat\w*|integrat\w*|solv\w*|set\w* up|write\w*|"
    r"classif\w*|construct\w*|represent\w*|graph\w*|plot\w*|draw\w*|"
    r"sketch\w*|estimat\w*|approximat\w*|obtain\w*|deriv\w*|"
    r"explain\w*|reasoning|because|why|guarantee\w*|theorem)\b",
    re.I,
)

MCQ_EASY = re.compile(
    r"which (?:conclusion|statement|expression) is (?:guaranteed|always true|equals f)|"
    r"based on the table, what is lim|graph of g consists|"
    r"if f is odd and integrable|definite integral from 2 to x|"
    r"2 - 3\(x - 1\)\^2 <= f\(x\)",
    re.I,
)
MCQ_HARD = re.compile(
    r"euler'?s method|length of y=|particular solution|"
    r"greatest possible area|additional information is required|"
    r"population .*growth rate greatest|overestimate or underestimate",
    re.I,
)


def text(value):
    if value is None:
        return ""
    if isinstance(value, (dict, list)):
        return json.dumps(value, ensure_ascii=False)
    return str(value)


def criterion_tier(criterion):
    blob = " ".join(
        text(criterion.get(field))
        for field in ("learner_facing_text", "evidence_requirements")
    )
    # Legacy rubric boilerplate describes the scorer's evidence standard, not
    # the student's task verb; remove it before cue classification.
    blob = re.sub(
        r"This criterion requires the displayed expected value and enough justification "
        r"to distinguish a shown argument from a bare assertion\.?",
        "",
        blob,
        flags=re.I,
    )
    # Argumentation outranks calculation when both occur in one scored point.
    if ARGUMENT.search(blob):
        return "Hard", "argumentation/proof cue"
    if DIRECT.search(blob) and not ROUTINE.search(blob):
        return "Easy", "direct recognition/read-off cue"
    if ROUTINE.search(blob):
        return "Medium", "routine calculus operation cue"
    return None, "no explicit criterion cue"


def modal_upward(tiers):
    counts = Counter(tiers)
    top = max(counts.values())
    return max((tier for tier, count in counts.items() if count == top), key=TIERS.get)


def classify_frq(item):
    criteria = item.get("frq_criteria") or []
    classified = [criterion_tier(c) for c in criteria]
    tiers = [tier for tier, _ in classified if tier]
    if not tiers:
        stem = text(item.get("stem"))
        if ARGUMENT.search(stem):
            return "Hard", "judgement", "No criterion verb; stem requires explicit justification/reasoning."
        return "Medium", "judgement", "No usable criterion task cue; standard calculus application judged Medium."
    level = modal_upward(tiers)
    counts = Counter(tiers)
    missing = len(classified) - len(tiers)
    rationale = (
        "Modal criterion cue tier with upward tie-break: "
        + ", ".join(f"{k}={counts.get(k, 0)}" for k in ("Easy", "Medium", "Hard"))
        + f"; uncued={missing}."
    )
    return level, "calculus_regex_cue", rationale


def classify_mcq(item):
    stem = text(item.get("stem"))
    if MCQ_HARD.search(stem):
        return "Hard", "calculus_regex_cue", "Non-routine or multi-stage Calculus cue in MCQ stem."
    if MCQ_EASY.search(stem):
        return "Easy", "calculus_regex_cue", "Direct theorem/definition/read-off cue in MCQ stem."
    if re.search(r"\b(evaluate lim|what is lim|which interval.*concave|critical numbers|average value|area|volume|d/dx|f['′]?)\b", stem, re.I):
        return "Medium", "calculus_regex_cue", "Standard single-concept Calculus operation in MCQ stem."
    return "Medium", "judgement", "No decisive cue; standard one-concept MCQ judged Medium."


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: assign_difficulty_calcab.py ITEMS.json")
    items = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    rows = []
    for item in items:
        if item.get("item_type") == "frq":
            difficulty, basis, rationale = classify_frq(item)
        else:
            difficulty, basis, rationale = classify_mcq(item)
        rows.append({
            "content_key": item["content_key"],
            "item_type": item["item_type"],
            "difficulty": difficulty,
            "basis": basis,
            "rationale": rationale,
        })
    rows.sort(key=lambda row: (row["item_type"], row["content_key"]))
    with OUTPUT.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["content_key", "item_type", "difficulty", "basis", "rationale"],
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)

    print(f"rows={len(rows)} output={OUTPUT}")
    for kind in (None, "frq", "mcq"):
        subset = rows if kind is None else [row for row in rows if row["item_type"] == kind]
        bands = Counter(row["difficulty"] for row in subset)
        bases = Counter(row["basis"] for row in subset)
        print(kind or "all", len(subset), dict(bands), dict(bases))


if __name__ == "__main__":
    main()
