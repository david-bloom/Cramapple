#!/usr/bin/env python3
"""Standing check: how many items can each subject actually serve, and did that drop?

Why this exists
---------------
On 2026-09-24 three separate silent serving failures were found by hand:

  * 20 AP Biology MCQ were republished in August. Every serving label stopped matching its
    content hash and nothing noticed for six weeks.
  * A canonical-answer migration rewrote 67 items and instantly dropped 28 more out of serving.
  * The unit-gated path had never served a single Biology item, because it requires
    label_status='validated' and Biology has none.

None of these produced an error. Both serving functions treat all of these conditions as
"no rows", which is indistinguishable from "this subject has no content".

What it does
------------
1. Runs app.servable_items_census_selftest(), which checks the census's mirrored predicates
   against the REAL serving RPCs. Any MISMATCH fails the run: a census that has drifted from
   production is worse than none, because it reports confidently while being wrong.
2. Runs app.servable_items_census() and compares to the committed baseline.
3. Fails on any DECREASE. Increases are reported and require a baseline update.

Usage
-----
    CRAMAPPLE_DB_URL=postgres://... python3 scripts/qa/servable_items_check.py
    CRAMAPPLE_DB_URL=postgres://... python3 scripts/qa/servable_items_check.py --update-baseline

Exit codes: 0 pass, 1 regression or drift, 2 could not run.
"""

import json
import os
import pathlib
import subprocess
import sys

BASELINE = pathlib.Path(__file__).resolve().parents[2] / "docs/research/servable_items_baseline.json"

# Counters that must never silently fall. Diagnostics are reported but not gated, because a
# diagnostic moving is often the intended result of a fix.
GATED = ("unit_gated", "drill", "full_exam")


def psql(dsn: str, sql: str) -> str:
    try:
        out = subprocess.run(
            ["psql", dsn, "-At", "-c", sql],
            capture_output=True, text=True, timeout=180,
        )
    except FileNotFoundError:
        sys.exit("psql not found on PATH")
    if out.returncode != 0:
        sys.exit(f"query failed:\n{out.stderr.strip()}")
    return out.stdout.strip()


def fetch(dsn: str):
    selftest = json.loads(psql(dsn, """
        select coalesce(jsonb_agg(jsonb_build_object(
          'subject', exam_code, 'path', path, 'probe', probe,
          'rpc', rpc_rows, 'mirror', mirrored, 'status', status)), '[]'::jsonb)
        from app.servable_items_census_selftest();"""))
    census = json.loads(psql(dsn, """
        select coalesce(jsonb_agg(jsonb_build_object(
          'subject', exam_code, 'epv', exam_pack_version_id,
          'published', published_items, 'unit_gated', unit_gated_servable,
          'drill', practice_targeted_drill, 'full_exam', practice_full_exam_frq,
          'labels', serving_labels_total, 'validated', serving_labels_validated,
          'hash_mismatch', serving_label_hash_mismatch, 'no_label', items_with_no_serving_label,
          'latest_ver_unpublished', latest_version_not_published) order by exam_code, exam_pack_version_id),
          '[]'::jsonb) from app.servable_items_census();"""))
    return selftest, census


def main() -> int:
    dsn = os.environ.get("CRAMAPPLE_DB_URL")
    if not dsn:
        print("CRAMAPPLE_DB_URL is not set. It must point at the database to check.", file=sys.stderr)
        return 2

    selftest, census = fetch(dsn)
    failed = False

    # 1. the mirror must still describe production
    mismatches = [r for r in selftest if r["status"] == "MISMATCH"]
    capped = [r for r in selftest if r["status"] == "skipped_capped"]
    print(f"self-test: {len(selftest) - len(mismatches) - len(capped)} ok, "
          f"{len(capped)} skipped (RPC caps at 50), {len(mismatches)} MISMATCH")
    for r in mismatches:
        print(f"  DRIFT {r['subject']:<24} {r['path']}/{r['probe']}: "
              f"rpc={r['rpc']} mirror={r['mirror']}")
        failed = True
    if mismatches:
        print("\nThe census no longer matches the live serving functions. Fix the mirror before\n"
              "trusting any number below.\n")

    # 2. compare against the baseline
    if not BASELINE.exists():
        print(f"\nno baseline at {BASELINE}; run with --update-baseline to create one")
        _print_census(census)
        return 1 if failed else 0

    base = {(r["subject"], r["epv"]): r for r in json.loads(BASELINE.read_text())["census"]}
    print()
    _print_census(census)
    print()

    for row in census:
        key = (row["subject"], row["epv"])
        if key not in base:
            print(f"NEW    {row['subject']} ({row['epv'][:8]}) — not in baseline")
            continue
        for field in GATED:
            was, now = base[key][field], row[field]
            if now < was:
                print(f"DROP   {row['subject']:<24} {field}: {was} -> {now}")
                failed = True
            elif now > was:
                print(f"up     {row['subject']:<24} {field}: {was} -> {now}  (update the baseline)")

    for key in base:
        if not any((r["subject"], r["epv"]) == key for r in census):
            print(f"GONE   {key[0]} ({key[1][:8]}) — in baseline, absent now")
            failed = True

    print("\nFAIL" if failed else "\nPASS")
    return 1 if failed else 0


def _print_census(census):
    hdr = f"{'subject':<24}{'pub':>5}{'gated':>7}{'drill':>7}{'exam':>6}   {'why not serving'}"
    print(hdr)
    print("-" * len(hdr))
    for r in census:
        why = []
        if r["validated"] == 0:
            why.append("0 validated labels")
        if r["no_label"]:
            why.append(f"{r['no_label']} unlabelled")
        if r["hash_mismatch"]:
            why.append(f"{r['hash_mismatch']} hash-stale")
        if r["latest_ver_unpublished"]:
            why.append(f"{r['latest_ver_unpublished']} latest-ver draft")
        print(f"{r['subject']:<24}{r['published']:>5}{r['unit_gated']:>7}{r['drill']:>7}"
              f"{r['full_exam']:>6}   {', '.join(why) or '—'}")


if __name__ == "__main__":
    if "--update-baseline" in sys.argv:
        dsn = os.environ.get("CRAMAPPLE_DB_URL")
        if not dsn:
            sys.exit("CRAMAPPLE_DB_URL is not set")
        _, census = fetch(dsn)
        BASELINE.parent.mkdir(parents=True, exist_ok=True)
        BASELINE.write_text(json.dumps({"census": census}, indent=2) + "\n")
        print(f"baseline written: {BASELINE}")
        sys.exit(0)
    sys.exit(main())
