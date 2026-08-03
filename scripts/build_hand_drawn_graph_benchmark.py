#!/usr/bin/env python3
"""Build a deterministic benchmark manifest for hand-drawn graph grading.

The benchmark is intentionally split into two layers:

1. A stratified 150-item synthetic corpus split into dev, calibration,
   holdout, and internal challenge partitions.
2. A separate trace-set challenge corpus drawn from the frozen v0.1 trace
   packets.

The script does not run any model calls. It creates a reproducible manifest
that can be used by downstream labelers, graders, and reporting harnesses.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CORPUS = ROOT / "docs" / "research" / "hand_drawn_graph_corpus_2026_06_30" / "hand_drawn_graph_questions_2026_06_30.jsonl"
DEFAULT_TRACE_DIR = ROOT / "docs" / "research" / "hand_drawn_graph_corpus_2026_06_29" / "trace_sets"
DEFAULT_OUT_DIR = ROOT / "docs" / "research" / "hand_drawn_graph_benchmark_2026_06_30"

SYNTHETIC_SPLITS = [
    ("dev", 20),
    ("calibration", 10),
    ("holdout", 10),
    ("internal_challenge", 10),
]

PASS_THRESHOLDS = {
    "exact_criterion_vector_agreement": 0.95,
    "min_criterion_f1": 0.90,
    "false_accept_rate": 0.02,
    "false_reject_rate": 0.05,
}


def load_jsonl(path: Path) -> list[dict[str, Any]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def stable_hash(*parts: str) -> str:
    h = hashlib.sha256()
    for part in parts:
        h.update(part.encode("utf-8"))
        h.update(b"\0")
    return h.hexdigest()


def stable_order(rows: list[dict[str, Any]], *, seed: int, salt: str) -> list[dict[str, Any]]:
    return sorted(rows, key=lambda row: stable_hash(str(seed), salt, row["item_id"]))


def criterion_ids(row: dict[str, Any]) -> list[str]:
    defs = row.get("criterion_definitions") or []
    return [str(entry["criterion_id"]) for entry in defs if isinstance(entry, dict) and entry.get("criterion_id")]


def build_synthetic_records(rows: list[dict[str, Any]], seed: int) -> list[dict[str, Any]]:
    groups: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in rows:
        groups[str(row["archetype"])].append(row)

    records: list[dict[str, Any]] = []
    for archetype in sorted(groups):
        ordered = stable_order(groups[archetype], seed=seed, salt=archetype)
        cursor = 0
        for split_name, split_size in SYNTHETIC_SPLITS:
            for row in ordered[cursor : cursor + split_size]:
                records.append(
                    {
                        "item_id": row["item_id"],
                        "split": split_name,
                        "source_type": "synthetic_corpus",
                        "source_package": "hand_drawn_graph_corpus_2026_06_30",
                        "source_path": str(DEFAULT_CORPUS.relative_to(ROOT)),
                        "item_version": row.get("item_version"),
                        "archetype": row.get("archetype"),
                        "relation_subtype": row.get("relation_subtype"),
                        "expected_image_filename": row.get("expected_image_filename"),
                        "criterion_ids": criterion_ids(row),
                        "criterion_count": len(criterion_ids(row)),
                        "rights_status": row.get("rights_status"),
                        "gold_label_source": "embedded_criterion_definitions",
                        "challenge_track": None,
                    }
                )
            cursor += split_size
    return records


def load_trace_records(trace_dir: Path) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    for manifest_path in sorted(trace_dir.glob("set_*/set_*_manifest.json")):
        set_name = manifest_path.parent.name
        rows = json.loads(manifest_path.read_text(encoding="utf-8"))
        for row in rows:
            records.append(
                {
                    "item_id": row["item_id"],
                    "split": "external_challenge",
                    "source_type": "trace_set",
                    "source_package": str(manifest_path.relative_to(ROOT).parent),
                    "source_path": str(manifest_path.relative_to(ROOT)),
                    "item_version": row.get("item_version"),
                    "archetype": row.get("archetype"),
                    "relation_subtype": row.get("relation_subtype"),
                    "expected_image_filename": row.get("expected_image_filename"),
                    "criterion_ids": criterion_ids(row),
                    "criterion_count": len(criterion_ids(row)),
                    "rights_status": row.get("rights_status"),
                    "gold_label_source": "embedded_trace_manifest",
                    "challenge_track": set_name,
                }
            )
    return records


def summarize(records: list[dict[str, Any]]) -> dict[str, Any]:
    split_counts = Counter(record["split"] for record in records)
    archetype_counts = Counter(record["archetype"] for record in records)
    split_archetype_counts: dict[str, dict[str, int]] = defaultdict(dict)
    for record in records:
        split = record["split"]
        archetype = record["archetype"]
        split_archetype_counts[split][archetype] = split_archetype_counts[split].get(archetype, 0) + 1
    return {
        "total_records": len(records),
        "split_counts": dict(sorted(split_counts.items())),
        "archetype_counts": dict(sorted(archetype_counts.items())),
        "split_archetype_counts": {k: dict(sorted(v.items())) for k, v in sorted(split_archetype_counts.items())},
    }


def write_csv(path: Path, records: list[dict[str, Any]]) -> None:
    fieldnames = [
        "item_id",
        "split",
        "source_type",
        "source_package",
        "source_path",
        "item_version",
        "archetype",
        "relation_subtype",
        "expected_image_filename",
        "criterion_count",
        "criterion_ids",
        "rights_status",
        "gold_label_source",
        "challenge_track",
    ]
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for record in records:
            row = dict(record)
            row["criterion_ids"] = json.dumps(row["criterion_ids"], ensure_ascii=True)
            writer.writerow(row)


def write_readme(path: Path, summary: dict[str, Any], total_records: int, trace_total: int) -> None:
    text = f"""# Hand-Drawn Graph Benchmark - 2026-06-30

This package is the execution scaffold for the hand-drawn graph grading benchmark.
It combines the frozen 2026-06-30 synthetic corpus with the v0.1 trace-set challenge pages.

## Purpose

Validate hand-drawn response grading for:

1. Accuracy first
2. Speed second
3. Cost third

## Benchmark Shape

- Synthetic corpus: 150 items
- Synthetic split: 60 dev / 30 calibration / 30 holdout / 30 internal challenge
- Trace-set challenge: {trace_total} items across the frozen trace packets
- Total benchmark records: {total_records}

## Pass Thresholds

- Exact criterion-vector agreement >= 95%
- Minimum per-criterion F1 >= 90%
- False accept rate <= 2%
- False reject rate <= 5%
- p95 latency within product target
- Cost per accepted grade within budget target

## Output Files

- `benchmark_manifest.json`
- `benchmark_manifest.csv`

## Source Inputs

- `docs/research/hand_drawn_graph_corpus_2026_06_30/hand_drawn_graph_questions_2026_06_30.jsonl`
- `docs/research/hand_drawn_graph_corpus_2026_06_29/trace_sets/set_*/set_*_manifest.json`

## Notes

- The synthetic corpus is stratified by archetype before splitting.
- The trace-set pages are held out as a separate external challenge set.
- This package does not run model calls or score any results by itself.
"""
    path.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--corpus", type=Path, default=DEFAULT_CORPUS)
    parser.add_argument("--trace-dir", type=Path, default=DEFAULT_TRACE_DIR)
    parser.add_argument("--out-dir", type=Path, default=DEFAULT_OUT_DIR)
    parser.add_argument("--seed", type=int, default=20260630)
    args = parser.parse_args()

    corpus_rows = load_jsonl(args.corpus)
    synthetic_records = build_synthetic_records(corpus_rows, seed=args.seed)
    trace_records = load_trace_records(args.trace_dir)
    records = synthetic_records + trace_records

    args.out_dir.mkdir(parents=True, exist_ok=True)

    manifest = {
        "experiment_name": "hand_drawn_graph_benchmark",
        "experiment_version": "2026-06-30",
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "seed": args.seed,
        "source_inputs": {
            "synthetic_corpus": str(args.corpus.relative_to(ROOT)),
            "trace_dir": str(args.trace_dir.relative_to(ROOT)),
        },
        "split_policy": {
            "synthetic_corpus": {
                "method": "stratified_by_archetype_then_stable_hash_order",
                "split_sizes_per_archetype": dict(SYNTHETIC_SPLITS),
            },
            "trace_set": {
                "method": "external_challenge",
                "assignment": "all trace pages are held out of the synthetic split",
            },
        },
        "pass_thresholds": PASS_THRESHOLDS,
        "summary": summarize(records),
        "records": records,
    }

    manifest_json = args.out_dir / "benchmark_manifest.json"
    manifest_csv = args.out_dir / "benchmark_manifest.csv"
    readme_path = args.out_dir / "README.md"

    manifest_json.write_text(json.dumps(manifest, indent=2, sort_keys=True), encoding="utf-8")
    write_csv(manifest_csv, records)
    write_readme(readme_path, manifest["summary"], len(records), len(trace_records))

    print(f"Wrote {manifest_json}")
    print(f"Wrote {manifest_csv}")
    print(f"Wrote {readme_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
