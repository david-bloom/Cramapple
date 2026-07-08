#!/usr/bin/env python3
"""Combine FRQ-only and FRQ+HDR packets into one packet_index.json, matching
apbio_packet_bundle_2026_07_07/packet_index.json's shape."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from build_frq_only import main as build_frq_only_main
from build_frq_hdr import main as build_frq_hdr_main

REPO_ROOT = "/Users/davidbloom/Documents/Cramapple"
OUT_DIR = os.path.join(REPO_ROOT, "docs/research/apstats_packet_bundle_2026_07_07")


def main():
    frq_only_pool, frq_only_packets = build_frq_only_main()
    frq_hdr_pool, frq_hdr_packets = build_frq_hdr_main()

    index = {
        "bundle_id": "apstats_packet_bundle_2026_07_07",
        "created_at": "2026-07-07",
        "frq_only_source_pool": {
            "total_items": len(frq_only_pool),
            "source": "docs/research/apstats_packet_bundle_2026_07_07/frq_only_pool.json",
            "packet_size": 4,
            "full_packet_count": len(frq_only_packets),
            "remainder_count": 0,
        },
        "frq_only_packets": frq_only_packets,
        "frq_hdr_source_pool": {
            "total_items": len(frq_hdr_pool),
            "source": "docs/research/apstats_packet_bundle_2026_07_07/hdr_frq_pool.json",
            "packet_size": 4,
            "full_packet_count": len(frq_hdr_packets),
            "concrete_graded_packet_count": sum(1 for p in frq_hdr_packets if p["status"] == "concrete_graded"),
            "shell_packet_count": sum(1 for p in frq_hdr_packets if p["status"] == "shell_needs_hdr_drawing"),
        },
        "frq_hdr_packets": frq_hdr_packets,
    }

    with open(os.path.join(OUT_DIR, "packet_index.json"), "w") as f:
        json.dump(index, f, indent=2)

    # Verification (grading_test_packet_requirements.md section 9 review gate)
    assert sum(len(p["frqs"]) for p in frq_only_packets) == 40
    assert sum(len(p["frqs"]) for p in frq_hdr_packets) == 40
    assert len(set(item["content_key"] for item in frq_only_pool)) == 40
    assert len(set(item["item_id"] for item in frq_hdr_pool)) == 40
    all_frq_only_ids = set(i for p in frq_only_packets for i in p["frqs"])
    all_frq_hdr_ids = set(i for p in frq_hdr_packets for i in p["frqs"])
    assert all_frq_only_ids == set(item["content_key"] for item in frq_only_pool)
    assert all_frq_hdr_ids == set(item["item_id"] for item in frq_hdr_pool)
    print("Review gate checks passed.")
    print(f"FRQ-only: {len(frq_only_packets)} packets, {sum(len(p['frqs']) for p in frq_only_packets)} FRQs")
    print(f"FRQ+HDR: {len(frq_hdr_packets)} packets ({index['frq_hdr_source_pool']['concrete_graded_packet_count']} concrete, {index['frq_hdr_source_pool']['shell_packet_count']} shell), {sum(len(p['frqs']) for p in frq_hdr_packets)} FRQs")


if __name__ == "__main__":
    main()
