#!/usr/bin/env python3
"""Build the consolidated 40-item non-HDR Statistics FRQ pool and 10 packets."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from existing_stats_frq_data import STATS_FRQ_ITEMS as EXISTING
from frq_only_new_data import NEW_FRQ_ONLY_ITEMS as NEW

REPO_ROOT = "/Users/davidbloom/Documents/Cramapple"
OUT_DIR = os.path.join(REPO_ROOT, "docs/research/apstats_packet_bundle_2026_07_07")

# Map existing items' lowercase ids -> sequential APSTATS-FRQ-0NN ids, keep
# their full 5-6 response labeled corpus reference for provenance, but the
# pool entry itself only needs the FRQ definition (stem/criteria/canonical
# answer) per grading_test_packet_requirements.md section 2.
EXISTING_ID_MAP = {f"statistics_frq_{i:02d}": f"APSTATS-FRQ-{i:03d}" for i in range(1, 11)}


def build_pool():
    pool = []
    for it in EXISTING:
        new_key = EXISTING_ID_MAP[it["id"]]
        pool.append({
            "content_key": new_key,
            "source": "existing",
            "source_ref": f"docs/research/benchmark_corpus_2026_07_06/{it['id']}/ (branch claude/benchmark-corpus-2026-07-06, PR #30 -- AI-provisional, unapproved)",
            "unit": it["unit"],
            "difficulty": it["difficulty"],
            "content_type": it["content_type"],
            "stem": it["stem"],
            "criteria": [
                {"key": c["id"], "text": c["text"], "notes": c["notes"]}
                for c in it["criteria"]
            ],
            "canonical_answer": next(
                (r["text"] for r in it["responses"] if all(v == "earned" for v in r["labels"].values())),
                None,
            ),
        })
    for it in NEW:
        pool.append({
            "content_key": it["content_key"],
            "source": "new_2026_07_07",
            "source_ref": None,
            "unit": it["unit"],
            "difficulty": it["difficulty"],
            "content_type": ", ".join(it["subtopics"]),
            "stem": it["stem"],
            "criteria": [
                {"key": c["key"], "points": c["points"], "text": c["text"], "evidence": c["evidence"]}
                for c in it["criteria"]
            ],
            "canonical_answer": it["canonical_answer"],
        })
    return pool


def build_packets(pool):
    packets = []
    for i in range(10):
        chunk = pool[i * 4:(i + 1) * 4]
        packets.append({
            "packet_id": f"APSTATS-FRQ-PKT-{i+1:02d}",
            "mode": "frq_only",
            "frqs": [item["content_key"] for item in chunk],
            "units": sorted(set(item["unit"] for item in chunk)),
            "difficulties": [item["difficulty"] for item in chunk],
        })
    return packets


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    pool = build_pool()
    assert len(pool) == 40, len(pool)
    packets = build_packets(pool)
    assert sum(len(p["frqs"]) for p in packets) == 40

    with open(os.path.join(OUT_DIR, "frq_only_pool.json"), "w") as f:
        json.dump(pool, f, indent=2)

    return pool, packets


if __name__ == "__main__":
    pool, packets = main()
    print(f"pool: {len(pool)} items")
    for p in packets:
        print(p["packet_id"], p["frqs"], p["units"], p["difficulties"])
