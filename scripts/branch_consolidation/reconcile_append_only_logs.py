#!/usr/bin/env python3
"""Append-only reconciliation for the three governance logs
(ACTIVITY_LOG.md, APPROVALS_LOG.md, DECISIONS_LOG.md) across the grading
branch consolidation's conflicting sources.

Never picks one whole-file winner. For each file:
  1. Parses main's entries (each `## ...` header + its body) and each
     conflicting source's entries, keyed by APPROVAL-NNNN/DECISION-NNNN id
     (for the two ID-based logs) or by exact header text (ACTIVITY_LOG,
     which has no numeric id).
  2. Any entry whose key exists in a source but not in main is a genuine
     gap — reported and merged in.
  3. Any entry whose key exists in BOTH but with a DIFFERENT body is an
     id/title reused for different content across branches — flagged as a
     real conflict for human review, NEVER auto-resolved by picking one.
  4. Entries that are byte-identical wherever they already appear are not
     duplicated.

Output per file: a merged draft (new entries inserted in date order,
newest-first, matching each log's existing convention) plus a plain-text
report of what changed and what's flagged. The merged draft is a proposal,
not applied to any repo file by this script.
"""

import argparse
import json
import re
import subprocess
from dataclasses import dataclass
from datetime import datetime


ID_PATTERN = re.compile(r"\b((?:APPROVAL|DECISION)-\d{4})\b")
DATE_PATTERN = re.compile(r"(\d{4}-\d{2}-\d{2})")


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
    date: str  # ISO date string, best-effort parsed


def parse_log(text, use_id_key):
    lines = text.split("\n")
    preamble_lines = []
    entries = []
    current_header = None
    current_body = []

    def flush():
        if current_header is None:
            return
        body = "\n".join(current_body).rstrip("\n")
        if use_id_key:
            m = ID_PATTERN.search(current_header)
            key = m.group(1) if m else current_header.strip()
        else:
            key = current_header.strip()
        date_m = DATE_PATTERN.search(current_header)
        date = date_m.group(1) if date_m else "0000-00-00"
        entries.append(Entry(key=key, header=current_header, body=body, date=date))

    for line in lines:
        if line.startswith("## "):
            header_text = line[3:].strip()
            if header_text == "Index":
                # Every version of these files has its own "## Index"
                # section (a curated recent-entries list, not a log entry
                # itself). Treat it as part of the preamble, not a content
                # entry — otherwise every file "conflicts" on Index by
                # construction, which is noise, not a finding.
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

    entries = [e for e in entries if e.key != "__INDEX__"]

    preamble = "\n".join(preamble_lines)
    return preamble, entries


def reconcile(main_text, source_texts, use_id_key):
    main_preamble, main_entries = parse_log(main_text, use_id_key)
    main_by_key = {e.key: e for e in main_entries}

    missing = []  # entries to append: (source_label, Entry)
    id_conflicts = []  # (key, main_entry, source_label, source_entry)
    seen_missing_keys = {}  # key -> Entry already queued to append

    for label, text in source_texts:
        _, entries = parse_log(text, use_id_key)
        for e in entries:
            if e.key in main_by_key:
                if e.body.strip() != main_by_key[e.key].body.strip():
                    id_conflicts.append((e.key, main_by_key[e.key], label, e))
                continue
            if e.key in seen_missing_keys:
                if seen_missing_keys[e.key].body.strip() != e.body.strip():
                    id_conflicts.append(
                        (e.key, seen_missing_keys[e.key], label, e)
                    )
                continue
            seen_missing_keys[e.key] = e
            missing.append((label, e))

    # Build merged entry list: existing main entries + new ones, sorted by
    # date descending (newest first), matching the log's stated convention.
    # Stable sort keeps main's existing relative order for same-day entries,
    # and puts new entries in position by date rather than dumping them all
    # at the top or bottom.
    all_entries = list(main_entries) + [e for _, e in missing]

    def sort_key(entry):
        try:
            d = datetime.strptime(entry.date, "%Y-%m-%d")
        except ValueError:
            d = datetime.min
        return d

    # Sort descending by date, stable so ties preserve main's original order
    # for pre-existing entries and insertion order for same-day new ones.
    indexed = list(enumerate(all_entries))
    indexed.sort(key=lambda pair: (sort_key(pair[1]), -pair[0]), reverse=True)
    merged_entries = [e for _, e in indexed]

    merged_text = main_preamble.rstrip("\n") + "\n\n" + "\n\n".join(
        f"## {e.header}\n{e.body}".rstrip("\n") for e in merged_entries
    ) + "\n"

    return {
        "main_entry_count": len(main_entries),
        "missing_count": len(missing),
        "missing": [
            {"source": label, "key": e.key, "header": e.header, "date": e.date}
            for label, e in missing
        ],
        "id_conflicts": [
            {
                "key": key,
                "main_header": main_e.header,
                "conflicting_source": label,
                "conflicting_header": src_e.header,
            }
            for key, main_e, label, src_e in id_conflicts
        ],
        "merged_entry_count": len(merged_entries),
        "merged_text": merged_text,
    }


FILES = {
    "docs/activity_log/ACTIVITY_LOG.md": {
        "use_id_key": False,
        "sources": [
            "origin/claude/cramapple-grading-mlr0o1",
            "origin/codex/five-subject-harness-and-content",
            "origin/recovery/ap-statistics-benchmark-content-20260721",
            "origin/claude/cramapple-grading-experiments-9lkjqc",
        ],
    },
    "docs/activity_log/APPROVALS_LOG.md": {
        "use_id_key": True,
        "sources": [
            "origin/claude/cramapple-grading-mlr0o1",
            "origin/codex/five-subject-harness-and-content",
        ],
    },
    "docs/activity_log/DECISIONS_LOG.md": {
        "use_id_key": True,
        "sources": [
            "origin/claude/cramapple-grading-mlr0o1",
            "origin/codex/five-subject-harness-and-content",
        ],
    },
}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True)
    parser.add_argument("--out-dir", required=True)
    args = parser.parse_args()

    import os

    os.makedirs(args.out_dir, exist_ok=True)
    report = {}

    for path, cfg in FILES.items():
        main_text = run_git(args.repo, "show", f"origin/main:{path}")
        source_texts = []
        for branch in cfg["sources"]:
            try:
                text = run_git(args.repo, "show", f"{branch}:{path}")
            except RuntimeError:
                continue
            source_texts.append((branch, text))

        result = reconcile(main_text, source_texts, cfg["use_id_key"])
        report[path] = {k: v for k, v in result.items() if k != "merged_text"}

        base = os.path.basename(path)
        with open(os.path.join(args.out_dir, base + ".merged.proposed.md"), "w") as f:
            f.write(result["merged_text"])

    with open(os.path.join(args.out_dir, "append_only_reconciliation_report.json"), "w") as f:
        json.dump(report, f, indent=2)

    for path, r in report.items():
        print(f"{path}: main={r['main_entry_count']} missing={r['missing_count']} "
              f"merged={r['merged_entry_count']} id_conflicts={len(r['id_conflicts'])}")


if __name__ == "__main__":
    main()
