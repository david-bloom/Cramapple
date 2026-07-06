#!/usr/bin/env python3
"""Generate the 40 benchmark-grade grading corpus packages.

AI-provisional (Claude-authored) content. NOT Learning-Quality-approved.
See each package's label_validation.md for the explicit readiness statement.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))

from bio_frq_data import BIO_FRQ_ITEMS
from stats_frq_data import STATS_FRQ_ITEMS
from bio_hand_drawn_data import BIO_HAND_DRAWN_ITEMS
from stats_hand_drawn_data import STATS_HAND_DRAWN_ITEMS

# This script lives at docs/research/benchmark_corpus_2026_07_06/scripts/,
# so the package output root is simply its grandparent directory.
OUT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CREATED_DATE = "2026-07-06"
VERSION = "v1.0-ai-provisional-2026-07-06"
LABEL_STATUS = "ai_provisional_unapproved"


def ensure_dir(path):
    os.makedirs(path, exist_ok=True)


def points_earned(labels):
    return sum(1 for v in labels.values() if v == "earned")


def has_utd(labels):
    return any(v == "unable_to_determine" for v in labels.values())


def validate_corpus(records, id_field="response_id"):
    ids = [r[id_field] for r in records]
    n = len(ids)
    id_nums = []
    for rid in ids:
        # response ids are like R1..R10
        num = int(rid.lstrip("R"))
        id_nums.append(num)
    expected = set(range(1, n + 1))
    actual = set(id_nums)
    missing = sorted(expected - actual)
    id_range = f"R1 through R{n}" if n else "none"

    texts = [r.get("text") or r.get("description") or r.get("response_description") or "" for r in records]
    dup_texts = []
    seen = {}
    for i, t in enumerate(texts):
        if t in seen:
            dup_texts.append((ids[seen[t]], ids[i]))
        else:
            seen[t] = i

    score_dist = {}
    for r in records:
        pts = points_earned(r["criterion_labels"])
        score_dist[pts] = score_dist.get(pts, 0) + 1

    crit_dist = {}
    for r in records:
        for cid, val in r["criterion_labels"].items():
            crit_dist.setdefault(cid, {"earned": 0, "not_earned": 0, "unable_to_determine": 0, "not_applicable": 0})
            crit_dist[cid][val] = crit_dist[cid].get(val, 0) + 1

    utd_count = sum(1 for r in records if has_utd(r["criterion_labels"]))

    return {
        "n": n,
        "id_range": id_range,
        "missing_ids": missing,
        "dup_texts": dup_texts,
        "score_dist": score_dist,
        "crit_dist": crit_dist,
        "utd_count": utd_count,
    }


def render_score_dist_table(score_dist, max_points=4):
    lines = ["| Labeled points | Count |", "| --- | ---: |"]
    for p in range(max_points + 1):
        lines.append(f"| `{p}` | `{score_dist.get(p, 0)}` |")
    return "\n".join(lines)


def render_crit_dist_table(crit_dist, criteria):
    lines = ["| Criterion | Earned | Not earned | Unable to determine |", "| --- | ---: | ---: | ---: |"]
    for c in criteria:
        cid = c["id"]
        d = crit_dist.get(cid, {})
        lines.append(f"| `{cid}` | `{d.get('earned', 0)}` | `{d.get('not_earned', 0)}` | `{d.get('unable_to_determine', 0)}` |")
    return "\n".join(lines)


def readiness_section(val):
    lines = [
        "## Readiness",
        "",
        "**Not ready for benchmark execution.** This packet is AI-provisional "
        "(Claude-authored) and has not been reviewed or approved by Learning "
        "Quality (Orly) or any human subject-matter reviewer. Per standing "
        "practice for this kind of packet (see the Bio reference-layer spike "
        "packet and the FRQ02 generated-answer corpus), draft labels produced "
        "by an AI are not sufficient for a benchmark quality gate on their own.",
        "",
        "Ready:",
        "",
        "- use as a draft structural example of a labeled grading corpus;",
        "- use as a starting point for a Learning Quality review pass;",
        "- run mechanical validation (duplicate/ID/distribution checks -- see below).",
        "",
        "Not ready:",
        "",
        "- use for learner-facing production grading;",
        "- use to drive benchmark execution or grader calibration decisions;",
        "- cite as Learning-Quality-approved ground truth.",
        "",
    ]
    if val["utd_count"]:
        lines.insert(
            2,
            f"\nThis packet also contains {val['utd_count']} response(s) with at least "
            "one `unable_to_determine` criterion label, flagging a genuine "
            "ambiguity for reviewer judgment rather than a scored pass/fail -- "
            "see individual reviewer notes.\n",
        )
    return "\n".join(lines)


def frq_readme(item, subject, package_dir_name):
    return f"""# {item['title']}

**Package:** `{package_dir_name}`
**Subject:** {subject}
**Answer type:** Text FRQ
**Unit:** {item['unit']}
**Difficulty:** {item['difficulty']}
**Content type:** {item['content_type']}
**Version:** `{VERSION}`
**Created date:** {CREATED_DATE}
**Label status:** `{LABEL_STATUS}` (Claude-authored draft; not reviewed or approved by Learning Quality)

## Purpose

This package is a benchmark-grade grading corpus spike input packet for a
single free-response question (FRQ) item. It is modeled on the structure of
`docs/research/bio_reference_layer_spike_input_packet.md` and
`docs/research/frq02_generated_answer_corpus_validation.md`, but every
response, label, reviewer note, and boundary tag in this package was
authored directly by Claude in one pass -- there is no independent human
labeling step behind it (unlike those reference artifacts, where Learning
Quality confirmed every label). See `label_validation.md` for the explicit
readiness statement.

## Files

- `README.md` -- this file.
- `spike_input_packet.md` -- question stem, rubric criteria, full response
  set, and the draft label matrix.
- `corpus.jsonl` -- one record per response, machine-readable.
- `label_validation.md` -- validation summary (counts, ID range, duplicate
  check, score/criterion distributions) and the readiness statement.

## Next step

Route this packet to Learning Quality (Orly) for a real review pass before
any use in benchmark execution or grader calibration.
"""


def hand_drawn_readme(item, subject, package_dir_name):
    return f"""# {item['title']}

**Package:** `{package_dir_name}`
**Subject:** {subject}
**Answer type:** Hand-drawn graph response
**Source item:** `{item['source_item_id']}` (reused from the existing in-repo
hand-drawn item pool; question stem, data table, and capture instruction are
not new authoring)
**Archetype:** {item['archetype']}
**Version:** `{VERSION}`
**Created date:** {CREATED_DATE}
**Label status:** `{LABEL_STATUS}` (Claude-authored draft; not reviewed or approved by Learning Quality)

## Purpose

This package is a benchmark-grade grading corpus spike input packet for a
single hand-drawn graph-response item. The question stem, data table, and
capture instruction are reused directly from the existing in-repo hand-drawn
item pool (see Source item above) rather than newly authored, per the agreed
plan to extend rather than duplicate that pool. This package adds the
missing layer on top: a condensed 4-criterion grading contract and a labeled
response set.

**Important limitation:** no real photographed student responses exist for
this item. Every "response" in this package is a textual description of
what a hypothetical drawn page would show, standing in for an actual
photograph. This is explicitly not the same as real hand-drawn capture data
and must not be represented as such downstream. See `label_validation.md`
for the explicit readiness statement.

## Files

- `README.md` -- this file.
- `hand_drawn_input_packet.md` -- question stem, data table, capture
  instruction, visual grading contract (4-criterion rubric), full response
  set, and the draft label matrix.
- `corpus.jsonl` -- one record per response, machine-readable.
- `label_validation.md` -- validation summary (counts, ID range, duplicate
  check, score/criterion distributions) and the readiness statement.

## Next step

Route this packet to Learning Quality (Orly) for a real review pass before
any use in benchmark execution or grader calibration. Real photographed
responses would also be needed before this package could support actual
visual-grading benchmark execution.
"""


def frq_packet_md(item, subject):
    lines = [f"# Spike Input Packet -- {item['title']}", ""]
    lines += [
        f"**Subject:** {subject}",
        "**Answer type:** Text FRQ",
        f"**Unit:** {item['unit']}",
        f"**Difficulty:** {item['difficulty']}",
        f"**Content type:** {item['content_type']}",
        f"**Version:** `{VERSION}`",
        f"**Label status:** `{LABEL_STATUS}`",
        "",
        "## Prompt",
        "",
        item["stem"],
        "",
        "## Draft Rubric Criteria",
        "",
        "| Criterion ID | Criterion | Notes for reviewer |",
        "| --- | --- | --- |",
    ]
    for c in item["criteria"]:
        lines.append(f"| `{c['id']}` | {c['text']} | {c['notes']} |")
    lines += ["", "## Response Set", ""]
    lines += ["| Response ID | Points (Claude-provisional) |", "| --- | ---: |"]
    for r in item["responses"]:
        lines.append(f"| `{r['id']}` | {points_earned(r['labels'])} |")
    lines.append("")
    for r in item["responses"]:
        lines.append(f"#### {r['id']}")
        lines.append("")
        lines.append("```text")
        lines.append(r["text"])
        lines.append("```")
        lines.append("")
    lines += [
        "## Draft Label Matrix",
        "",
        "**Label status:** Claude-authored draft, `ai_provisional_unapproved`. "
        "NOT confirmed by Learning Quality. Contrast with the Bio reference "
        "packet, where an equivalent matrix was confirmed by Orly / Learning "
        "Quality before use.",
        "",
    ]
    crit_ids = [c["id"] for c in item["criteria"]]
    header = "| Response ID | " + " | ".join(f"`{c}`" for c in crit_ids) + " | Reviewer notes |"
    sep = "| --- | " + " | ".join("---" for _ in crit_ids) + " | --- |"
    lines += [header, sep]
    for r in item["responses"]:
        vals = " | ".join(r["labels"][c] for c in crit_ids)
        lines.append(f"| `{r['id']}` | {vals} | {r['reviewer_note']} |")
    lines.append("")
    lines += ["## Boundary Tags Index", ""]
    for r in item["responses"]:
        tags = ", ".join(f"`{t}`" for t in r["boundary_tags"]) if r["boundary_tags"] else "(none)"
        lines.append(f"- `{r['id']}`: {tags}")
    lines.append("")
    return "\n".join(lines)


def hand_drawn_packet_md(item, subject):
    lines = [f"# Hand-Drawn Input Packet -- {item['title']}", ""]
    lines += [
        f"**Subject:** {subject}",
        "**Answer type:** Hand-drawn graph response",
        f"**Source item:** `{item['source_item_id']}`",
        f"**Archetype:** {item['archetype']}",
        f"**Version:** `{VERSION}`",
        f"**Label status:** `{LABEL_STATUS}`",
        "",
        "## Prompt (reused from source item)",
        "",
        item["stem"],
        "",
        "## Data Table (reused from source item)",
        "",
    ]
    cols = list(item["display_table"][0].keys())
    lines.append("| " + " | ".join(cols) + " |")
    lines.append("| " + " | ".join("---" for _ in cols) + " |")
    for row in item["display_table"]:
        lines.append("| " + " | ".join(str(row[c]) for c in cols) + " |")
    lines += [
        "",
        "## Capture Instruction (reused from source item)",
        "",
        item.get("capture_instruction") or "Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.",
        "",
        "## Visual Grading Contract (condensed to 4 criteria for this package)",
        "",
        "| Criterion ID | Criterion | Notes for reviewer |",
        "| --- | --- | --- |",
    ]
    for c in item["criteria"]:
        lines.append(f"| `{c['id']}` | {c['text']} | {c['notes']} |")
    lines += [
        "",
        "**Important:** no real photographed student responses exist for this "
        "item. Each response below is a textual description of a hypothetical "
        "drawn page, not an actual photograph.",
        "",
        "## Response Set",
        "",
    ]
    lines += ["| Response ID | Points (Claude-provisional) |", "| --- | ---: |"]
    for r in item["responses"]:
        lines.append(f"| `{r['id']}` | {points_earned(r['labels'])} |")
    lines.append("")
    for r in item["responses"]:
        lines.append(f"#### {r['id']}")
        lines.append("")
        lines.append(r["description"])
        lines.append("")
    lines += [
        "## Draft Label Matrix",
        "",
        "**Label status:** Claude-authored draft, `ai_provisional_unapproved`. "
        "NOT confirmed by Learning Quality.",
        "",
    ]
    crit_ids = [c["id"] for c in item["criteria"]]
    header = "| Response ID | " + " | ".join(f"`{c}`" for c in crit_ids) + " | Reviewer notes |"
    sep = "| --- | " + " | ".join("---" for _ in crit_ids) + " | --- |"
    lines += [header, sep]
    for r in item["responses"]:
        vals = " | ".join(r["labels"][c] for c in crit_ids)
        lines.append(f"| `{r['id']}` | {vals} | {r['reviewer_note']} |")
    lines.append("")
    lines += ["## Boundary Tags Index (visual failure modes)", ""]
    for r in item["responses"]:
        tags = ", ".join(f"`{t}`" for t in r["boundary_tags"]) if r["boundary_tags"] else "(none)"
        lines.append(f"- `{r['id']}`: {tags}")
    lines.append("")
    return "\n".join(lines)


def corpus_records_frq(item, subject, package_id):
    crit_ids = [c["id"] for c in item["criteria"]]
    records = []
    for r in item["responses"]:
        records.append({
            "response_id": r["id"],
            "package_id": package_id,
            "item_id": item["id"],
            "subject": subject,
            "answer_type": "text_frq",
            "content_type": item["content_type"],
            "unit": item["unit"],
            "difficulty": item["difficulty"],
            "text": r["text"],
            "criterion_labels": {c: r["labels"][c] for c in crit_ids},
            "points_labeled": points_earned(r["labels"]),
            "reviewer_note": r["reviewer_note"],
            "boundary_tags": r["boundary_tags"],
            "label_status": LABEL_STATUS,
            "use_as_ground_truth": False,
            "approved_by": None,
            "approved_date": None,
            "version": VERSION,
        })
    return records


def corpus_records_hand_drawn(item, subject, package_id):
    crit_ids = [c["id"] for c in item["criteria"]]
    records = []
    for r in item["responses"]:
        records.append({
            "response_id": r["id"],
            "package_id": package_id,
            "item_id": item["id"],
            "source_item_id": item["source_item_id"],
            "subject": subject,
            "answer_type": "hand_drawn_graph_response",
            "archetype": item["archetype"],
            "response_description": r["description"],
            "image_path": None,
            "image_available": False,
            "criterion_labels": {c: r["labels"][c] for c in crit_ids},
            "points_labeled": points_earned(r["labels"]),
            "reviewer_note": r["reviewer_note"],
            "boundary_tags": r["boundary_tags"],
            "label_status": LABEL_STATUS,
            "use_as_ground_truth": False,
            "approved_by": None,
            "approved_date": None,
            "version": VERSION,
        })
    return records


def label_validation_md(item, records, criteria):
    val = validate_corpus(records)
    lines = [
        f"# Label Validation -- {item['title']}",
        "",
        f"**Status:** Generated corpus labeled by Claude; NOT approved for benchmark use.",
        f"**Version:** `{VERSION}`",
        f"**Created date:** {CREATED_DATE}",
        "",
        "## Summary",
        "",
        "| Check | Result |",
        "| --- | --- |",
        f"| Parsed response records | `{val['n']}` |",
        f"| Response ID range | `{val['id_range']}` |",
        f"| Missing IDs | {'none' if not val['missing_ids'] else val['missing_ids']} |",
        f"| Exact duplicate answer texts | {'none' if not val['dup_texts'] else val['dup_texts']} |",
        f"| Responses with `unable_to_determine` on any criterion | `{val['utd_count']}` |",
        "",
        "## Labeled Point Distribution",
        "",
        render_score_dist_table(val["score_dist"]),
        "",
        "## Criterion-Level Distribution",
        "",
        render_crit_dist_table(val["crit_dist"], criteria),
        "",
        readiness_section(val),
    ]
    return "\n".join(lines)


def build_frq_package(item, subject, prefix):
    package_id = item["id"]
    package_dir = os.path.join(OUT_ROOT, package_id)
    ensure_dir(package_dir)
    with open(os.path.join(package_dir, "README.md"), "w") as f:
        f.write(frq_readme(item, subject, package_id))
    with open(os.path.join(package_dir, "spike_input_packet.md"), "w") as f:
        f.write(frq_packet_md(item, subject))
    records = corpus_records_frq(item, subject, package_id)
    with open(os.path.join(package_dir, "corpus.jsonl"), "w") as f:
        for rec in records:
            f.write(json.dumps(rec) + "\n")
    with open(os.path.join(package_dir, "label_validation.md"), "w") as f:
        f.write(label_validation_md(item, records, item["criteria"]))
    return package_id, len(records)


def build_hand_drawn_package(item, subject, prefix):
    package_id = item["id"]
    package_dir = os.path.join(OUT_ROOT, package_id)
    ensure_dir(package_dir)
    with open(os.path.join(package_dir, "README.md"), "w") as f:
        f.write(hand_drawn_readme(item, subject, package_id))
    with open(os.path.join(package_dir, "hand_drawn_input_packet.md"), "w") as f:
        f.write(hand_drawn_packet_md(item, subject))
    records = corpus_records_hand_drawn(item, subject, package_id)
    with open(os.path.join(package_dir, "corpus.jsonl"), "w") as f:
        for rec in records:
            f.write(json.dumps(rec) + "\n")
    with open(os.path.join(package_dir, "label_validation.md"), "w") as f:
        f.write(label_validation_md(item, records, item["criteria"]))
    return package_id, len(records)


def build_top_level_readme(built):
    lines = [
        "# Benchmark-Grade Grading Corpus -- 2026-07-06",
        "",
        f"**Version:** `{VERSION}`",
        f"**Label status:** `{LABEL_STATUS}` across all 40 packages -- Claude-authored "
        "drafts, NOT reviewed or approved by Learning Quality (Orly). Every package's "
        "own `label_validation.md` restates this explicitly; do not use any package "
        "for benchmark execution or grader calibration before a real Learning Quality "
        "review pass.",
        "",
        "## Contents",
        "",
        "40 packages, each with `README.md`, a packet document, `corpus.jsonl`, and "
        "`label_validation.md`:",
        "",
        "- 10 `biology_frq_*` -- newly authored Biology FRQ stems (mechanism-heavy, "
        "concept-heavy, and boundary-sensitive mix).",
        "- 10 `statistics_frq_*` -- newly authored Statistics FRQ stems (interpretation, "
        "inference, modeling, and reasoning mix).",
        "- 10 `biology_hand_drawn_*` -- built on 10 items reused from "
        "`docs/research/hand_drawn_graph_corpus_2026_06_30/` (HDG-2026-P2-*), with each "
        "item's original 6-9-criterion rubric condensed to a 4-criterion grading "
        "contract for this package.",
        "- 10 `statistics_hand_drawn_*` -- built on 10 of the 12 items in "
        "`docs/research/ap_statistics_graph_response_seed_2026_07_02/` (already "
        "exactly 4 criteria each, reused as-is).",
        "",
        "Hand-drawn packages contain textual *descriptions* of hypothetical drawn "
        "responses, not real photographs -- see each package's README for the "
        "explicit limitation.",
        "",
        "## Package Index",
        "",
        "| Package | Responses |",
        "| --- | ---: |",
    ]
    for package_id, n in built:
        lines.append(f"| `{package_id}` | {n} |")
    lines += [
        "",
        "## Next Step",
        "",
        "Route this entire batch to Learning Quality (Orly) for a real review pass "
        "before any use in benchmark execution or grader calibration, per "
        "`DECISION`-style governance used elsewhere in this repo for AP Biology and "
        "AP Statistics content.",
        "",
    ]
    ensure_dir(OUT_ROOT)
    with open(os.path.join(OUT_ROOT, "README.md"), "w") as f:
        f.write("\n".join(lines))


def main():
    built = []
    for item in BIO_FRQ_ITEMS:
        built.append(build_frq_package(item, "AP Biology", "biology_frq"))
    for item in STATS_FRQ_ITEMS:
        built.append(build_frq_package(item, "AP Statistics", "statistics_frq"))
    for item in BIO_HAND_DRAWN_ITEMS:
        built.append(build_hand_drawn_package(item, "AP Biology", "biology_hand_drawn"))
    for item in STATS_HAND_DRAWN_ITEMS:
        built.append(build_hand_drawn_package(item, "AP Statistics", "statistics_hand_drawn"))
    build_top_level_readme(built)
    print(f"Built {len(built)} packages under {OUT_ROOT}")
    for package_id, n in built:
        print(f"  {package_id}: {n} responses")


if __name__ == "__main__":
    main()
