#!/usr/bin/env python3
"""Aggregate the two topic-tagging remeasurement model outputs."""

import csv
import json
from collections import Counter, defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ORIGINAL = HERE.parent / "bio_stats_topic_tagging_2026_09_22"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    with path.open("w", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def bool_text(value: bool) -> str:
    return "true" if value else "false"


def build_inventory(model_rows: list[dict[str, str]]) -> None:
    original_rows = {row["content_item_id"]: row for row in read_csv(ORIGINAL / "inventory.csv")}
    by_key = {row["content_item_id"]: row for row in model_rows}
    rows = []
    for content_item_id, original in original_rows.items():
        model = by_key[content_item_id]
        updated = dict(original)
        # Live recheck 2026-09-24: Biology has coverage rows for all 118 latest
        # items; Statistics has coverage rows on the same 135 latest items that
        # carry author-prose subtopics in the historical inventory.
        if model["subject_key"] == "biology":
            updated["has_topic_label"] = "true"
            updated["has_prior_model_run"] = "true"
            if model["item_type"] == "frq":
                current_missing = {
                    "7640704b-6e1d-4bad-bc74-f3d194324805",  # APBIO-FRQ-S-101
                    "87874651-60bb-40cc-a634-2ce196ad996d",  # APBIO-HDG-2026-GRAPH-002
                    "b738b319-8146-43d5-a2c4-5b292e1f1943",  # APBIO-HDG-2026-GRAPH-003
                    "001fef04-5272-4c9d-9d2b-cde19287bcc7",  # APBIO-HDG-2026-GRAPH-008
                    "3db8a97a-baaf-4ff4-9110-06dd4bc91892",  # APBIO-HDG-2026-GRAPH-010
                }
                updated["has_canonical_answer_1"] = bool_text(content_item_id not in current_missing)
        else:
            updated["has_topic_label"] = original["has_author_prose"]
        rows.append(updated)
    write_csv(HERE / "inventory.csv", rows, list(next(iter(rows)).keys()))


def main() -> None:
    model_1 = {row["content_item_id"]: row for row in read_csv(HERE / "model_1_topic_labels.csv")}
    model_2 = {row["content_item_id"]: row for row in read_csv(HERE / "model_2_topic_labels.csv")}
    if set(model_1) != set(model_2):
        raise SystemExit("model output scopes differ")

    proposal_rows = []
    packet_rows = []
    counts = defaultdict(Counter)
    for content_item_id in sorted(model_1, key=lambda cid: (model_1[cid]["subject_key"], model_1[cid]["content_key"])):
        left = model_1[content_item_id]
        right = model_2[content_item_id]
        agree = bool(left["primary_topic_code"]) and left["primary_topic_code"] == right["primary_topic_code"]
        subject = left["subject_key"]
        item_type = left["item_type"]
        counts[subject]["total"] += 1
        counts[subject]["agree" if agree else "disagree"] += 1
        counts[f"{subject}:{item_type}"]["total"] += 1
        counts[f"{subject}:{item_type}"]["agree" if agree else "disagree"] += 1

        if agree:
            primary_unit = left["primary_unit_number"]
            primary_code = left["primary_topic_code"]
            primary_title = left["primary_topic_title"]
            confidence = "medium" if "low" not in {left["confidence"], right["confidence"]} else "low"
            needs_human = left["needs_human"] == "true" or right["needs_human"] == "true"
            rationale = f"Two-model agreement on {primary_code}; model 1: {left['rationale']} | model 2: {right['rationale']}"
        else:
            primary_unit = ""
            primary_code = ""
            primary_title = ""
            confidence = "low"
            needs_human = True
            rationale = (
                f"Two-model disagreement: model_1={left['primary_topic_code']} "
                f"model_2={right['primary_topic_code']}. Route to human; no agreed proposal emitted."
            )

        author_agreement = "yes" if left["agreement_with_author_prose"] == "yes" and right["agreement_with_author_prose"] == "yes" else "no"
        if left["agreement_with_author_prose"] == "na" and right["agreement_with_author_prose"] == "na":
            author_agreement = "na"
        explainer_agreement = "yes" if left["agreement_with_explainer_retrieval"] == "yes" and right["agreement_with_explainer_retrieval"] == "yes" else "no"
        proposal_rows.append({
            "content_item_id": content_item_id,
            "content_key": left["content_key"],
            "subject_key": subject,
            "item_type": item_type,
            "primary_unit_number": primary_unit,
            "primary_topic_code": primary_code,
            "primary_topic_title": primary_title,
            "alt_topic_code": "",
            "confidence": confidence,
            "agreement_with_author_prose": author_agreement,
            "agreement_with_explainer_retrieval": explainer_agreement,
            "rationale": rationale,
            "needs_human": bool_text(needs_human),
            "models_agree": bool_text(agree),
            "model_1_primary_topic_code": left["primary_topic_code"],
            "model_2_primary_topic_code": right["primary_topic_code"],
            "model_1_confidence": left["confidence"],
            "model_2_confidence": right["confidence"],
            "model_1_needs_human": left["needs_human"],
            "model_2_needs_human": right["needs_human"],
            "explainer_available": bool_text(left["explainer_available"] == "true" and right["explainer_available"] == "true"),
        })
        packet_rows.append({
            "content_item_id": content_item_id,
            "content_key": left["content_key"],
            "subject_key": subject,
            "item_type": item_type,
            "model_1": left,
            "model_2": right,
            "models_agree": agree,
        })

    write_csv(HERE / "topic_labels_proposal.csv", proposal_rows, list(proposal_rows[0].keys()))
    with (HERE / "packet.jsonl").open("w") as handle:
        for row in packet_rows:
            handle.write(json.dumps(row, sort_keys=True) + "\n")
    build_inventory(list(model_1.values()))

    metadata = {
        "counts": {key: dict(value) for key, value in sorted(counts.items())},
        "overall": {
            "total": len(proposal_rows),
            "agree": sum(1 for row in proposal_rows if row["models_agree"] == "true"),
            "disagree": sum(1 for row in proposal_rows if row["models_agree"] == "false"),
        },
        "methodological_caveat": (
            "Model 1 disclosed that its row-level baseline used the historical proposal with "
            "corrected explainer availability and targeted QA repairs, not a fully fresh "
            "first-principles independent 502-item classification."
        ),
    }
    (HERE / "run_metadata.json").write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
