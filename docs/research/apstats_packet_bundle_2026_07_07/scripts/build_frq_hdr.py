#!/usr/bin/env python3
"""Build the consolidated 40-item HDR-capable Statistics FRQ pool and 10 packets."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from hdr_new_data import NEW_HDR_ITEMS

REPO_ROOT = "/Users/davidbloom/Documents/Cramapple"
OUT_DIR = os.path.join(REPO_ROOT, "docs/research/apstats_packet_bundle_2026_07_07")
SOURCE_JSONL = os.path.join(REPO_ROOT, "docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl")
PROPOSED_LABELS_JSONL = os.path.join(REPO_ROOT, "docs/research/ap_statistics_hdr_grading_experiment_2026_07_06/proposed_gold_labels.jsonl")


def load_jsonl(path):
    with open(path) as f:
        return [json.loads(l) for l in f]


def build_pool():
    existing = load_jsonl(SOURCE_JSONL)
    proposed_labels = {r["item_id"]: r for r in load_jsonl(PROPOSED_LABELS_JSONL)}
    pool = []
    for it in existing:
        label_rec = proposed_labels.get(it["item_id"])
        pool.append({
            "item_id": it["item_id"],
            "archetype": it["archetype"],
            "status": "graded",
            "stem": it["stem"],
            "criteria": it["criterion_definitions"],
            "canonical_answer": it["canonical_answer"],
            "hdr_image_path": label_rec["hdr_image_path"] if label_rec else None,
            "hdr_image_version": label_rec["hdr_image_version"] if label_rec else None,
            "proposed_points": label_rec["points_proposed"] if label_rec else None,
            "gold_label_status": label_rec["label_status"] if label_rec else None,
        })
    for it in NEW_HDR_ITEMS:
        idx = NEW_HDR_ITEMS.index(it) + 1
        pool.append({
            "item_id": it["item_id"],
            "archetype": it["archetype"],
            "status": "shell_needs_hdr_drawing",
            "stem": it["stem"],
            "criteria": it["criteria"],
            "canonical_answer": it["canonical_answer"],
            "trace_page_path": f"docs/research/apstats_packet_bundle_2026_07_07/trace_pages/pages/{idx:02d}_{it['item_id']}.png",
            "hdr_image_path": None,
            "hdr_image_version": None,
            "proposed_points": None,
            "gold_label_status": "no_response_yet",
        })
    return pool


def build_packets(pool):
    packets = []
    # Packets 1-3: existing 12 graded items, in their natural GRAPH-001..012 order
    for i in range(3):
        chunk = pool[i * 4:(i + 1) * 4]
        packets.append({
            "packet_id": f"APSTATS-FRQ-HDR-PKT-{i+1:02d}",
            "mode": "frq_with_hdr",
            "status": "concrete_graded",
            "frqs": [item["item_id"] for item in chunk],
            "archetypes": [item["archetype"] for item in chunk],
        })
    # Packets 4-10: 28 new shell items
    for i in range(7):
        chunk = pool[12 + i * 4: 12 + (i + 1) * 4]
        packets.append({
            "packet_id": f"APSTATS-FRQ-HDR-PKT-{i+4:02d}",
            "mode": "frq_with_hdr",
            "status": "shell_needs_hdr_drawing",
            "frqs": [item["item_id"] for item in chunk],
            "archetypes": [item["archetype"] for item in chunk],
            "trace_pages": [item["trace_page_path"] for item in chunk],
        })
    return packets


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    pool = build_pool()
    assert len(pool) == 40, len(pool)
    packets = build_packets(pool)
    assert sum(len(p["frqs"]) for p in packets) == 40

    with open(os.path.join(OUT_DIR, "hdr_frq_pool.json"), "w") as f:
        json.dump(pool, f, indent=2)

    return pool, packets


if __name__ == "__main__":
    pool, packets = main()
    print(f"pool: {len(pool)} items")
    for p in packets:
        print(p["packet_id"], p["status"], p["frqs"])
