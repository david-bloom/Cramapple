#!/usr/bin/env python3
"""Append-only reconciliation for the three governance logs
(ACTIVITY_LOG.md, APPROVALS_LOG.md, DECISIONS_LOG.md) across the grading
branch consolidation's conflicting sources.

Fixed after review of the first version, which:
  - read moving branch names instead of frozen commit SHAs (not reproducible
    if a branch is force-pushed or advances);
  - parsed dates only from entry headers, when they actually live in the
    body as a `**Date:** YYYY-MM-DD` line, producing 0000-00-00 for every
    entry;
  - emitted a full regenerated/reordered replacement file, which is not a
    safe "append-only" operation and risked silently reordering or dropping
    the Index;
  - only compared entry bodies for ID-keyed logs, not headers, and never
    checked for a source reusing the same ID twice internally;
  - conflated "this ID collides with what main already has" with "two
    sources independently invented the same unused ID" — these need
    different resolutions (the former is a real overwrite risk; the latter
    just needs one of the two renumbered before it can be appended at all).

This version:
  - takes a frozen commit SHA per source (never a branch ref) — pass
    `--source-sha LABEL=SHA` once per source, or use the manifest-derived
    defaults via `--use-manifest-defaults`.
  - parses the date from the body's `**Date:** YYYY-MM-DD` line, falling
    back to the header's date if the body has none.
  - is byte-for-byte non-destructive of main: it never rewrites main's file.
    Output is an append packet (new entries only, in insertion order) and a
    separate index-update suggestion, per file.
  - compares (header, body) as a pair for every entry, and separately
    rejects/reports any key that appears more than once within a single
    source (a data-quality problem in that source, not a cross-source
    conflict).
  - classifies every anomaly as exactly one of:
      - "missing_from_main": key absent from main, no source disagreement
        (or all agreeing sources) — safe to append as-is.
      - "collides_with_main": key present in main AND at least one source
        has a different (header, body) for that same key — a real
        overwrite risk, never auto-resolved.
      - "source_vs_source_collision": key absent from main, but 2+ sources
        disagree on it — main is not at risk, but the ID cannot be
        appended as-is; at least one side needs a fresh ID.
      - "duplicate_key_within_source": the same source uses one key twice
        with different content — a data problem in that source itself.
"""

import argparse
import json
import re
import subprocess
from collections import defaultdict
from dataclasses import dataclass


ID_PATTERN = re.compile(r"\b((?:APPROVAL|DECISION)-\d{4})\b")
BODY_DATE_PATTERN = re.compile(r"^\*\*(?:[A-Za-z ]*Date[A-Za-z ]*):\*\*\s*(\d{4}-\d{2}-\d{2})", re.MULTILINE)
HEADER_DATE_PATTERN = re.compile(r"(\d{4}-\d{2}-\d{2})")

# Frozen at the time this script's first version was authored, from
# docs/research/grading_branch_consolidation_manifest_2026_07_26/manifest.csv
# (`source_tip_sha` column). Re-derive from that manifest rather than
# hand-editing this dict if any of these branches move.
MANIFEST_SOURCE_SHAS = {
    "claude/cramapple-grading-mlr0o1": "7f02b9c305c7c590d01229f9932acfc3a5d12f88",
    "codex/five-subject-harness-and-content": "c5f539294c4df217b268fa8951bc0e024fd84b0c",
    "recovery/ap-statistics-benchmark-content-20260721": "48194689e25e90fba5f975c9130e21c85d6be978",
    "claude/cramapple-grading-experiments-9lkjqc": "ddf2d4472d9ed72fd3df86a3d7c6db79c35db6f5",
}
MANIFEST_MAIN_SHA = "b1733e10bbf6e43c4b1a251bdb536a9ce6d34550"


def run_git(repo, *args):
    result = subprocess.run(
        ["git", "-C", repo, *args], capture_output=True, text=True, check=False
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip())
    return result.stdout


@dataclass
class Entry:
    key: str
    header: str
    body: str
    date: str


def parse_log(text, use_id_key):
    lines = text.split("\n")
    preamble_lines = []
    entries = []
    current_header = None
    current_body = []

    def flush():
        if current_header is None or current_header == "__INDEX__":
            return
        body = "\n".join(current_body).rstrip("\n")
        if use_id_key:
            m = ID_PATTERN.search(current_header)
            key = m.group(1) if m else current_header.strip()
        else:
            key = current_header.strip()
        body_date_m = BODY_DATE_PATTERN.search(body)
        if body_date_m:
            date = body_date_m.group(1)
        else:
            header_date_m = HEADER_DATE_PATTERN.search(current_header)
            date = header_date_m.group(1) if header_date_m else "0000-00-00"
        entries.append(Entry(key=key, header=current_header, body=body, date=date))

    for line in lines:
        if line.startswith("## "):
            header_text = line[3:].strip()
            if header_text == "Index":
                flush()
                current_header = "__INDEX__"
                current_body = []
                continue
            flush()
            current_header = header_text
            current_body = []
        elif current_header is None:
            preamble_lines.append(line)
        else:
            current_body.append(line)
    flush()

    preamble = "\n".join(preamble_lines)
    return preamble, entries


def reconcile(main_text, source_texts, use_id_key):
    """source_texts: list of (label, text) using FROZEN identifiers as label."""
    _, main_entries = parse_log(main_text, use_id_key)
    main_by_key = {e.key: e for e in main_entries}

    # First pass: detect duplicate keys *within* a single source.
    duplicate_within_source = []
    per_source_entries = {}
    for label, text in source_texts:
        _, entries = parse_log(text, use_id_key)
        per_source_entries[label] = entries
        seen = {}
        for e in entries:
            if e.key in seen:
                if (seen[e.key].header, seen[e.key].body) != (e.header, e.body):
                    duplicate_within_source.append(
                        {"source": label, "key": e.key,
                         "first_header": seen[e.key].header,
                         "second_header": e.header}
                    )
            else:
                seen[e.key] = e

    # A key with an unresolved duplicate within one source can't be safely
    # classified as a clean "missing" entry (we don't know which of the two
    # duplicate versions would be the one appended) or silently folded into
    # a collision bucket either — it's excluded from both and left to be
    # resolved via duplicate_key_within_source alone.
    keys_with_internal_duplicates = {d["key"] for d in duplicate_within_source}

    # Second pass: bucket every (key -> [(label, entry), ...]) across all sources.
    by_key = defaultdict(list)
    for label, entries in per_source_entries.items():
        by_key_seen_this_source = set()
        for e in entries:
            if e.key in keys_with_internal_duplicates:
                continue
            if e.key in by_key_seen_this_source:
                continue  # already recorded once for this source above
            by_key_seen_this_source.add(e.key)
            by_key[e.key].append((label, e))

    missing = []
    collides_with_main = []
    source_vs_source = []

    for key, occurrences in by_key.items():
        distinct = {}
        for label, e in occurrences:
            sig = (e.header, e.body)
            distinct.setdefault(sig, []).append((label, e))

        if key in main_by_key:
            main_entry = main_by_key[key]
            main_sig = (main_entry.header, main_entry.body)
            disagreeing = [sig for sig in distinct if sig != main_sig]
            if disagreeing:
                for sig in disagreeing:
                    for label, e in distinct[sig]:
                        collides_with_main.append(
                            {
                                "key": key,
                                "main_header": main_entry.header,
                                "main_date": main_entry.date,
                                "conflicting_source": label,
                                "conflicting_header": e.header,
                                "conflicting_date": e.date,
                            }
                        )
            # Entries matching main exactly need no action either way.
        else:
            if len(distinct) == 1:
                # All sources that have this key agree with each other;
                # main just doesn't have it yet.
                (label, e) = next(iter(distinct.values()))[0]
                missing.append({"source": label, "key": e.key, "header": e.header,
                                 "date": e.date, "entry": e})
            else:
                # 2+ distinct (header, body) pairs, none of them in main.
                labels_and_entries = [
                    (label, e) for sig_group in distinct.values() for label, e in sig_group
                ]
                for label, e in labels_and_entries:
                    source_vs_source.append(
                        {"key": key, "source": label, "header": e.header, "date": e.date}
                    )

    return {
        "main_entry_count": len(main_entries),
        "missing": missing,
        "collides_with_main": collides_with_main,
        "source_vs_source_collision": source_vs_source,
        "duplicate_key_within_source": duplicate_within_source,
    }


FILES = {
    "docs/activity_log/ACTIVITY_LOG.md": {
        "use_id_key": False,
        "sources": [
            "claude/cramapple-grading-mlr0o1",
            "codex/five-subject-harness-and-content",
            "recovery/ap-statistics-benchmark-content-20260721",
            "claude/cramapple-grading-experiments-9lkjqc",
        ],
    },
    "docs/activity_log/APPROVALS_LOG.md": {
        "use_id_key": True,
        "sources": [
            "claude/cramapple-grading-mlr0o1",
            "codex/five-subject-harness-and-content",
        ],
    },
    "docs/activity_log/DECISIONS_LOG.md": {
        "use_id_key": True,
        "sources": [
            "claude/cramapple-grading-mlr0o1",
            "codex/five-subject-harness-and-content",
        ],
    },
}


def build_append_packet(missing_entries):
    """Sorted newest-first by date; ties keep discovery order."""
    ordered = sorted(missing_entries, key=lambda m: m["date"], reverse=True)
    parts = []
    for m in ordered:
        parts.append(f"<!-- source: {m['source']} -->\n## {m['header']}\n{m['entry'].body}")
    return "\n\n".join(parts) + ("\n" if parts else "")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True)
    parser.add_argument("--main-sha", default=MANIFEST_MAIN_SHA)
    parser.add_argument(
        "--source-sha", action="append", default=[],
        help="LABEL=SHA, repeatable. Overrides manifest defaults for that label.",
    )
    parser.add_argument("--out-dir", required=True)
    args = parser.parse_args()

    source_shas = dict(MANIFEST_SOURCE_SHAS)
    for pair in args.source_sha:
        label, sha = pair.split("=", 1)
        source_shas[label] = sha

    import os

    os.makedirs(args.out_dir, exist_ok=True)
    report = {}

    for path, cfg in FILES.items():
        main_text = run_git(args.repo, "show", f"{args.main_sha}:{path}")
        source_texts = []
        for label in cfg["sources"]:
            sha = source_shas[label]
            try:
                text = run_git(args.repo, "show", f"{sha}:{path}")
            except RuntimeError:
                continue
            source_texts.append((f"{label}@{sha[:12]}", text))

        result = reconcile(main_text, source_texts, cfg["use_id_key"])
        base = path.rsplit("/", 1)[-1]

        packet = build_append_packet(result["missing"])
        with open(os.path.join(args.out_dir, base + ".append_packet.md"), "w") as f:
            f.write(packet)

        index_lines = [m["header"] for m in sorted(result["missing"], key=lambda m: m["date"], reverse=True)]
        with open(os.path.join(args.out_dir, base + ".index_additions.txt"), "w") as f:
            f.write("\n".join(f"- {h}" for h in index_lines) + ("\n" if index_lines else ""))

        report[path] = {
            "main_entry_count": result["main_entry_count"],
            "missing_count": len(result["missing"]),
            "missing": [
                {"source": m["source"], "key": m["key"], "header": m["header"], "date": m["date"]}
                for m in result["missing"]
            ],
            "collides_with_main": result["collides_with_main"],
            "source_vs_source_collision": result["source_vs_source_collision"],
            "duplicate_key_within_source": result["duplicate_key_within_source"],
        }

    with open(os.path.join(args.out_dir, "append_only_reconciliation_report.json"), "w") as f:
        json.dump(report, f, indent=2)

    for path, r in report.items():
        print(
            f"{path}: main={r['main_entry_count']} missing={r['missing_count']} "
            f"collides_with_main={len(r['collides_with_main'])} "
            f"source_vs_source={len(r['source_vs_source_collision'])} "
            f"dup_within_source={len(r['duplicate_key_within_source'])}"
        )


if __name__ == "__main__":
    main()
