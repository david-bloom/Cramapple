#!/usr/bin/env python3
"""Assign first-pass AP Precalculus difficulty from a Production packet export.

Usage:
  python3 assign_difficulty_apprecalc.py /path/to/items.json /path/to/frq_criteria.json

The output path is fixed beside this script so the run is reproducible.

This is the corrected replacement for a Precalculus difficulty classifier that
was run once (2026-09-25) but never committed to the repository -- see
docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md for the full story.
The uncommitted original scored an entire FRQ's stem+criteria text as one blob
and applied its hard-cue regex once per item, so a single "justify" anywhere
in a three-part item (even in a part that was otherwise pure mechanical
algebra) marked every criterion in every part of that item Hard. That is a
different method than Method A (README Sec 3): the tier is the MODAL tier of
an item's *individual* rubric criteria, ties broken upward -- not "any hard
cue anywhere in the item."

This implementation classifies each FRQ criterion's own `learner_facing_text`
independently, then takes the modal tier across that item's criteria (upward
tie-break). MCQ is classified from the stem's own task verb/cue (single
judgement, no per-criterion aggregation needed since there is one graded
unit).

The generic Method A verb list (README Sec 3) does not fit this corpus:
"find", "solve", "give five consecutive key points", "average rate of
change", and "construct/write a model" are the load-bearing phrases and none
of them appear in the generic Easy/Medium/Hard verb lists. This adds
Precalculus-specific regex cues on top of the generic tiers, matched against
each criterion's own text (never against a concatenated whole-item blob).
"""

import csv
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "APPRECALC_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"
TIERS = {"Easy": 1, "Medium": 2, "Hard": 3}

# --- Hard cues -------------------------------------------------------------
# Argumentation/justification, extrapolation-limitation reasoning, and a
# handful of MCQ-specific non-routine cues found during corpus spot-checks.
HARD = re.compile(
    r"\bjustif\w*|\bprove\w*|\bproof\b|"
    r"\bexplain\b.*\b(why|one (limitation|reason)|is (an )?extrapolation)\b|"
    r"\bshould not\b|\bcannot be used\b|\bmay not\b|\bunreasonable\b|"
    r"\bextrapolat\w*|\bat most one solution\b|"
    r"\bcritique\w*|\bevaluate the design\b|\bdesign\w*|\bpropose\w*|"
    r"\bgreatest caution\b|"
    r"\bresidual plot\b.*\bmost strongly indicates\b|\bmost strongly indicates\b",
    re.I,
)

# --- Medium cues -------------------------------------------------------------
MEDIUM = re.compile(
    r"\bconstruct\w*|\bwrite (a |an )?(model|equation|inverse)\b|"
    r"\baverage rate of change\b|\bcompar\w*|\bdescrib\w*|\binterpret\w*|"
    r"\bexplain\w*|\bgraph\w*|\bplot\w*|\bverif\w*|\bfind\w*|\bsolv\w*|"
    r"\bdetermin\w*|\bgive\b.*\bkey points\b|\bstate whether\b|"
    r"\bapproximat\w*|\bcomput\w*|\bconvert\w*|\brewrit\w*|\bsimplif\w*|"
    r"\bidentify why\b|\bfactor\w*|\bdivid\w*|\bexpress\w*|\bpredict\w*|"
    r"\bset up\b",
    re.I,
)

# --- Easy cues (generic Method A list, unchanged) ---------------------------
EASY = re.compile(
    # "\bstate\w*" would also match "statement" ("which statement is true");
    # anchor to the verb forms (state/states/stated), not the noun.
    r"\bidentif\w*|\bstate[sd]?\b|\bname\w*|\blist\w*|\blabel\w*|\bannotate\w*|"
    r"\bindicat\w*|\bselect\w*|\bclassif\w*|\brecall\w*",
    re.I,
)

# `explain` is Medium unless it carries an argumentation/limitation marker
# (the generic Method A "explain split" rule, reused as-is).
ARGUMENT_MARKER = re.compile(
    r"\bclaim\b|\bargument|\bsupports? the\b|\brefut|\bjustif|\bevidence that\b|"
    r"\bwhy\b|\bone (limitation|reason)\b|\bextrapolat\w*|\bunreasonable\b",
    re.I,
)

MCQ_HARD = re.compile(
    r"\bgreatest caution\b|\bresidual plot\b|\bmost strongly indicates\b|"
    r"\bjustif\w*|\bunreasonable\b|\bextrapolat\w*",
    re.I,
)
MCQ_EASY = re.compile(
    r"^solve\b|^convert\b|^what is the exact value\b|^for which value of x is\b.*undefined",
    re.I,
)


def text(value):
    if value is None:
        return ""
    if isinstance(value, (dict, list)):
        return json.dumps(value, ensure_ascii=False)
    return str(value)


def criterion_tier(criterion_text):
    """Classify ONE criterion's (or one part's) own text, never a whole-item blob."""
    blob = criterion_text or ""
    if HARD.search(blob):
        return "Hard", "hard cue (justify/prove/extrapolation-limitation/etc.)"
    if re.search(r"\bexplain\w*", blob, re.I):
        if ARGUMENT_MARKER.search(blob):
            return "Hard", "explain + argumentation/limitation marker"
        return "Medium", "explain (non-argumentation)"
    if MEDIUM.search(blob):
        return "Medium", "medium cue (construct/find/solve/determine/etc.)"
    if EASY.search(blob):
        return "Easy", "easy cue (identify/state/name/list/etc.)"
    return None, "no cue"


# --- Stem part splitting -----------------------------------------------------
# Most FRQ stems spell out per-part instructions ("Part A: ...", "(a) ...").
# The task verb that actually drives difficulty lives THERE, not in the
# rubric criterion (which usually states expected answer *content*, e.g.
# "The zeros are -1,1,4." with no verb at all). Criteria are keyed
# part-a-criterion-N / part-b-criterion-N / part-c-criterion-N (or, for
# single-criterion parts, just part-a / part-b / part-c), so each criterion
# can be matched back to its own part's instruction text. This is still a
# per-criterion classification -- it just sources each criterion's cue from
# the part instruction that criterion was written to grade, instead of from
# the criterion's own answer-content sentence, which is frequently verb-free.
#
# A handful of items (the apprecalc-frq-u12-* set) have a generic templated
# stem with no per-part breakdown at all; those fall back to the criterion's
# own learner_facing_text, which for that subset does carry verb-like cues
# ("Correctly applies...", "Correctly rejects... as extraneous").
PART_LABELED = re.compile(r"Part\s+([ABC])\s*:\s*(.*?)(?=(?:\n\s*\n\s*Part\s+[ABC]\s*:)|\Z)", re.I | re.S)
PART_LETTERED = re.compile(r"\(([abc])\)\s*(.*?)(?=(?:\n\s*\n\s*\([abc]\))|\Z)", re.I | re.S)


def split_stem_by_part(stem):
    """Return {'a': text, 'b': text, 'c': text} or {} if no part markers found."""
    blob = stem or ""
    parts = {}
    for m in PART_LABELED.finditer(blob):
        parts[m.group(1).lower()] = m.group(2).strip()
    if parts:
        return parts
    for m in PART_LETTERED.finditer(blob):
        parts[m.group(1).lower()] = m.group(2).strip()
    return parts


def criterion_part_letter(criterion_key):
    m = re.match(r"part-([abc])\b", criterion_key or "", re.I)
    return m.group(1).lower() if m else None


def modal_upward(tiers):
    counts = Counter(tiers)
    top = max(counts.values())
    return max((tier for tier, count in counts.items() if count == top), key=TIERS.get)


def classify_frq(content_key, stem, criteria_rows):
    """criteria_rows: list of (criterion_key, learner_facing_text) for this item."""
    stem_parts = split_stem_by_part(stem)
    classified = []
    for criterion_key, learner_text in criteria_rows:
        letter = criterion_part_letter(criterion_key)
        if stem_parts and letter and stem_parts.get(letter):
            tier, why = criterion_tier(stem_parts[letter])
            source = f"part-{letter} stem instruction"
        else:
            tier, why = criterion_tier(learner_text)
            source = "criterion's own learner_facing_text (no stem part breakdown)"
        classified.append((tier, why, source))

    tiers = [tier for tier, _, _ in classified if tier]
    if not tiers:
        return "Medium", "calibrated_judgement", "No criterion (or its owning stem part) carried a usable task cue; default Medium."
    level = modal_upward(tiers)
    counts = Counter(tiers)
    missing = len(classified) - len(tiers)
    source_used = classified[0][2] if classified else "n/a"
    rationale = (
        f"Per-criterion cue tiers via {source_used}, modal with upward tie-break: "
        + ", ".join(f"{k}={counts.get(k, 0)}" for k in ("Easy", "Medium", "Hard"))
        + f"; criteria_with_no_cue={missing}/{len(classified)}."
    )
    return level, "calibrated_task_verb", rationale


def classify_mcq(stem):
    blob = stem or ""
    if MCQ_HARD.search(blob):
        return "Hard", "calibrated_task_verb", "Hard cue in MCQ stem."
    if HARD.search(blob):
        return "Hard", "calibrated_task_verb", "Hard cue in MCQ stem."
    if MEDIUM.search(blob) or re.search(r"\bfor\b.*=|\bwhat is\b|\bwhich\b", blob, re.I):
        # Most Precalculus MCQ stems are terse computation/identification
        # prompts without an explicit verb; treat a recognizable Medium cue
        # as Medium, otherwise fall through to judgement.
        if MEDIUM.search(blob):
            return "Medium", "calibrated_task_verb", "Medium cue in MCQ stem."
    if EASY.search(blob):
        return "Easy", "calibrated_task_verb", "Easy cue in MCQ stem."
    return "Medium", "calibrated_judgement", "No decisive cue; standard one-concept MCQ judged Medium."


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: assign_difficulty_apprecalc.py ITEMS.json FRQ_CRITERIA.json")
    items = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    criteria_rows = json.loads(Path(sys.argv[2]).read_text(encoding="utf-8"))

    criteria_by_item = {}
    for row in criteria_rows:
        criteria_by_item.setdefault(row["content_key"], []).append(
            (row.get("criterion_key"), text(row.get("learner_facing_text")))
        )

    rows = []
    for item in items:
        content_key = item["content_key"]
        item_type = item["item_type"]
        if item_type == "frq":
            criteria_rows_for_item = criteria_by_item.get(content_key, [])
            difficulty, basis, rationale = classify_frq(content_key, text(item.get("stem")), criteria_rows_for_item)
        else:
            difficulty, basis, rationale = classify_mcq(text(item.get("stem")))
        confidence = "medium" if basis == "calibrated_task_verb" else "low"
        rows.append({
            "content_key": content_key,
            "item_type": item_type,
            "difficulty": difficulty,
            "basis": basis,
            "confidence": confidence,
            "rationale": rationale,
        })

    rows.sort(key=lambda row: (row["item_type"], row["content_key"]))
    with OUTPUT.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=["content_key", "item_type", "difficulty", "basis", "confidence", "rationale"],
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
