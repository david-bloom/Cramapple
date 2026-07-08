#!/usr/bin/env python3
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from proposed_labels_data import PROPOSED_LABELS

REPO_ROOT = "/Users/davidbloom/Documents/Cramapple"
SOURCE_JSONL = os.path.join(
    REPO_ROOT,
    "docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl",
)
OUT_DIR = os.path.join(REPO_ROOT, "docs/research/ap_statistics_hdr_grading_experiment_2026_07_06")
IMAGES_DIR = os.path.join(OUT_DIR, "images")

GRAPH010_CORRECTED_OUTLIER_NOTE_MET_RULE = (
    "Does not overstate 82 cm as a definite outlier without checking a rule, OR "
    "correctly applies the 1.5xIQR rule (Q1=71.5, Q3=75.5, IQR=4, upper fence=81.5) "
    "and identifies 82 cm as a mild outlier by that rule."
)
GRAPH010_CORRECTED_CANONICAL_ANSWER = (
    "Dotplot places dots at 68, 70, 71, two at 72, one at 73, two at 74, one at 75, "
    "one at 76, one at 78, and one at 82. The distribution is roughly unimodal with "
    "a slight right tail. By the 1.5xIQR rule (Q1=71.5, Q3=75.5, IQR=4, upper "
    "fence=81.5), 82 cm exceeds the fence and is a mild outlier."
)


def load_source():
    with open(SOURCE_JSONL) as f:
        return [json.loads(l) for l in f]


def build_manifest(items):
    rows = []
    for it in items:
        item_id = it["item_id"]
        version = PROPOSED_LABELS[item_id].get("image_version", "v1")
        suffix = "_v2" if version == "v2" else ""
        rows.append({
            "item_id": item_id,
            "archetype": it["archetype"],
            "frq_source_file": "docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl",
            "frq_packet_section": f"frq_packets.md#{item_id.lower()}",
            "rubric_status": "proposed_frozen_pending_approval",
            "hdr_image_path": f"docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/images/{item_id}__hdr_photo{suffix}.jpeg",
            "hdr_image_version": version,
            "hdr_image_original_filename_note": "renamed from a generic IMG_#### camera filename; see README provenance table",
            "gold_label_status": "claude_proposed_pending_approval",
            "gold_label_source": f"proposed_gold_labels.jsonl#{item_id}",
        })
    return rows


def frq_packets_md(items):
    lines = ["# AP Statistics HDR Grading Experiment -- FRQ Packets", ""]
    lines += [
        "Reused verbatim from "
        "`docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl` "
        "for all 12 items -- no re-authoring. One correction applied inline "
        "(GRAPH-010, flagged below); everything else is exactly as staged "
        "2026-07-02.",
        "",
    ]
    for it in items:
        item_id = it["item_id"]
        anchor = item_id.lower()
        lines.append(f"## {item_id} {{#{anchor}}}")
        lines.append("")
        lines.append(f"**Archetype:** {it['archetype']}")
        lines.append("")
        lines.append("### Stem")
        lines.append("")
        lines.append(it["stem"])
        lines.append("")
        lines.append("### Rubric criteria")
        lines.append("")
        lines.append("| Criterion ID | Met rule |")
        lines.append("| --- | --- |")
        for c in it["criterion_definitions"]:
            met_rule = c["met_rule"]
            if item_id == "APSTATS-HDG-2026-GRAPH-010" and c["criterion_id"] == "OUTLIER_NOTE":
                lines.append(f"| `{c['criterion_id']}` | ~~{met_rule}~~ **CORRECTED (see note below):** {GRAPH010_CORRECTED_OUTLIER_NOTE_MET_RULE} |")
            else:
                lines.append(f"| `{c['criterion_id']}` | {met_rule} |")
        lines.append("")
        lines.append("### Canonical answer")
        lines.append("")
        if item_id == "APSTATS-HDG-2026-GRAPH-010":
            lines.append(f"~~{it['canonical_answer']}~~")
            lines.append("")
            lines.append(
                "**CORRECTED** (per "
                "`ap_statistics_graph_response_seed_2026_07_02/README.md`'s QA "
                "section -- the original claim that 82 cm is not an outlier does "
                "not survive independently recomputing the 1.5xIQR rule on this "
                "item's own data; fixed in the staged Supabase row 2026-07-02 but "
                "never fixed in this source JSONL file, kept there for "
                "provenance):"
            )
            lines.append("")
            lines.append(f"> {GRAPH010_CORRECTED_CANONICAL_ANSWER}")
        else:
            lines.append(it["canonical_answer"])
        lines.append("")
    return "\n".join(lines)


def proposed_labels_md(items):
    lines = ["# Proposed Gold Labels -- Claude Visual Grading Pass (2026-07-06)", ""]
    lines += [
        "**Status: `claude_proposed_pending_approval`. NOT authoritative.** These "
        "are Claude's criterion-level judgments from looking at each photographed "
        "response against its canonical answer and data table. They have not been "
        "confirmed by David or Learning Quality. See README.md for what's needed "
        "before Codex can treat any of this as gold.",
        "",
    ]
    for it in items:
        item_id = it["item_id"]
        entry = PROPOSED_LABELS[item_id]
        lines.append(f"## {item_id}")
        lines.append("")
        lines.append("| Criterion | Proposed label |")
        lines.append("| --- | --- |")
        for cid, val in entry["labels"].items():
            lines.append(f"| `{cid}` | `{val}` |")
        lines.append("")
        lines.append(f"**Note:** {entry['note']}")
        lines.append("")
    return "\n".join(lines)


def proposed_labels_jsonl(items):
    out = []
    for it in items:
        item_id = it["item_id"]
        entry = PROPOSED_LABELS[item_id]
        version = entry.get("image_version", "v1")
        suffix = "_v2" if version == "v2" else ""
        out.append({
            "item_id": item_id,
            "hdr_image_path": f"docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/images/{item_id}__hdr_photo{suffix}.jpeg",
            "hdr_image_version": version,
            "criterion_labels": entry["labels"],
            "points_proposed": sum(1 for v in entry["labels"].values() if v == "earned"),
            "reviewer_note": entry["note"],
            "label_status": "claude_proposed_pending_approval",
            "approved_by": None,
            "approved_date": None,
        })
    return out


def main():
    items = load_source()
    os.makedirs(OUT_DIR, exist_ok=True)

    manifest = build_manifest(items)
    with open(os.path.join(OUT_DIR, "manifest.jsonl"), "w") as f:
        for row in manifest:
            f.write(json.dumps(row) + "\n")

    import csv
    with open(os.path.join(OUT_DIR, "manifest.csv"), "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(manifest[0].keys()))
        writer.writeheader()
        writer.writerows(manifest)

    with open(os.path.join(OUT_DIR, "frq_packets.md"), "w") as f:
        f.write(frq_packets_md(items))

    with open(os.path.join(OUT_DIR, "proposed_gold_labels.md"), "w") as f:
        f.write(proposed_labels_md(items))

    with open(os.path.join(OUT_DIR, "proposed_gold_labels.jsonl"), "w") as f:
        for rec in proposed_labels_jsonl(items):
            f.write(json.dumps(rec) + "\n")

    print(f"Wrote manifest.jsonl/csv, frq_packets.md, proposed_gold_labels.md/jsonl to {OUT_DIR}")


if __name__ == "__main__":
    main()
