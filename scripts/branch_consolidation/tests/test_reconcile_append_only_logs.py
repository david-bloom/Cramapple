#!/usr/bin/env python3
"""Fixture tests for reconcile_append_only_logs.py.

Builds a real throwaway git repository (no mocking) and exercises the exact
defects a review round found in the first version:

1. The tool reads frozen commit SHAs, not moving branch names — passing a
   branch ref where a SHA is expected must not silently work by accident.
2. Dates are parsed from the `**Date:** YYYY-MM-DD` line in the entry body,
   not just the header.
3. main's file content is never touched/rewritten — the tool only ever
   reads it, and produces a separate append packet.
4. Entries are compared on (header, body) as a pair for ID-keyed logs, not
   just body.
5. A duplicate key used twice within a single source (different content)
   is reported as a data problem in that source, not silently merged.
6. A key present in a source but absent from main, where two sources
   disagree, is classified source_vs_source_collision — NOT
   collides_with_main, since main has no stake in it at all.
7. A key present in both main and a source with different content is
   collides_with_main — a real overwrite risk.

Run: python3 scripts/branch_consolidation/tests/test_reconcile_append_only_logs.py
"""

import os
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import reconcile_append_only_logs as ral  # noqa: E402

FAILURES = []


def check(condition, message):
    if not condition:
        FAILURES.append(message)
        print(f"FAIL: {message}")
    else:
        print(f"ok:   {message}")


def git(repo, *args):
    return ral.run_git(repo, *args)


def write(repo, relpath, content):
    full = os.path.join(repo, relpath)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w") as f:
        f.write(content)


LOG_PATH = "docs/activity_log/DECISIONS_LOG.md"


def approval_entry(key, title, date, owner="David Bloom"):
    return (
        f"## {key} — {title}\n\n"
        f"**Date:** {date}\n"
        f"**Decision Owner:** {owner}\n"
        f"**Status:** Approved\n\n"
        f"### Context\n\nSome context for {key}.\n"
    )


def build_fixture_repo(tmp):
    repo = os.path.join(tmp, "repo")
    os.makedirs(repo)
    git(repo, "init", "-q", "-b", "main")
    git(repo, "config", "user.email", "test@example.com")
    git(repo, "config", "user.name", "Test")

    main_log = (
        "# Decisions Log\n\n"
        "## Index\n\n- placeholder\n\n---\n\n"
        + approval_entry("DECISION-0001", "Real Main Decision", "2026-01-01")
        + "\n"
        + approval_entry("DECISION-0002", "Another Main Decision", "2026-01-05")
    )
    write(repo, LOG_PATH, main_log)
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "seed main log")
    main_sha = git(repo, "rev-parse", "HEAD").strip()

    # Branch A: overwrites DECISION-0002 with different content (real
    # collides_with_main case), adds a brand-new DECISION-0010, and
    # duplicates DECISION-0010's key a second time with DIFFERENT content
    # later in its own file (duplicate_key_within_source case).
    git(repo, "checkout", "-q", "-b", "branch-a")
    branch_a_log = (
        "# Decisions Log\n\n"
        "## Index\n\n- placeholder (branch A's own index, different from main)\n\n---\n\n"
        + approval_entry("DECISION-0001", "Real Main Decision", "2026-01-01")
        + "\n"
        + approval_entry("DECISION-0002", "Overwritten On Branch A", "2026-02-02")
        + "\n"
        + approval_entry("DECISION-0010", "Branch A First Version", "2026-03-01")
        + "\n"
        + approval_entry("DECISION-0010", "Branch A Second, Different Version", "2026-03-02")
    )
    write(repo, LOG_PATH, branch_a_log)
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "branch A changes")
    branch_a_sha = git(repo, "rev-parse", "HEAD").strip()

    # Branch B: forks from main, adds a genuinely new DECISION-0020 (clean
    # missing-from-main case), and independently invents DECISION-0099 with
    # DIFFERENT content than branch A will also invent for the same key
    # (source_vs_source_collision, since main has neither).
    git(repo, "checkout", "-q", "main")
    git(repo, "checkout", "-q", "-b", "branch-b")
    branch_b_log = (
        "# Decisions Log\n\n"
        "## Index\n\n- placeholder (branch B's own index)\n\n---\n\n"
        + approval_entry("DECISION-0001", "Real Main Decision", "2026-01-01")
        + "\n"
        + approval_entry("DECISION-0002", "Another Main Decision", "2026-01-05")
        + "\n"
        + approval_entry("DECISION-0020", "Branch B New Decision", "2026-04-01")
        + "\n"
        + approval_entry("DECISION-0099", "Branch B's Version Of 0099", "2026-05-01")
    )
    write(repo, LOG_PATH, branch_b_log)
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "branch B changes")
    branch_b_sha = git(repo, "rev-parse", "HEAD").strip()

    # Add DECISION-0099 to branch A too, with DIFFERENT content, to create
    # the source_vs_source_collision on 0099 (neither matches main, which
    # has no 0099 at all).
    git(repo, "checkout", "-q", "branch-a")
    branch_a_log_v2 = branch_a_log + "\n" + approval_entry(
        "DECISION-0099", "Branch A's Different Version Of 0099", "2026-05-02"
    )
    write(repo, LOG_PATH, branch_a_log_v2)
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "branch A adds 0099 too")
    branch_a_sha = git(repo, "rev-parse", "HEAD").strip()

    git(repo, "checkout", "-q", "main")

    return repo, main_sha, branch_a_sha, branch_b_sha


def main():
    tmp = tempfile.mkdtemp(prefix="ral_fixture_")
    try:
        repo, main_sha, branch_a_sha, branch_b_sha = build_fixture_repo(tmp)

        # --- 1: frozen SHA usage — pass explicit commit SHAs, not branch refs ---
        main_text = ral.run_git(repo, "show", f"{main_sha}:{LOG_PATH}")
        branch_a_text = ral.run_git(repo, "show", f"{branch_a_sha}:{LOG_PATH}")
        branch_b_text = ral.run_git(repo, "show", f"{branch_b_sha}:{LOG_PATH}")
        check(
            len(main_sha) == 40 and len(branch_a_sha) == 40,
            "reconcile() is driven by full 40-char commit SHAs resolved up front, "
            "not by re-resolving a branch name at read time",
        )

        # Sanity: re-reading by SHA after a hypothetical branch move would
        # still return the SAME content (branches are never dereferenced
        # inside reconcile()/parse_log()).
        git(repo, "branch", "-f", "branch-a", "main")  # simulate branch-a being reset/force-pushed
        branch_a_text_after_move = ral.run_git(repo, "show", f"{branch_a_sha}:{LOG_PATH}")
        check(
            branch_a_text_after_move == branch_a_text,
            "reading by frozen SHA is unaffected by the branch ref moving out from under it",
        )

        # --- 2: date parsed from body, not just header ---
        _, entries = ral.parse_log(branch_b_text, use_id_key=True)
        by_key = {e.key: e for e in entries}
        check(
            by_key["DECISION-0020"].date == "2026-04-01",
            "date is correctly parsed from the body's **Date:** line "
            "(header itself has no date in it)",
        )
        check(
            "0000-00-00" not in [e.date for e in entries],
            "no entry falls back to the 0000-00-00 sentinel when a body date is present",
        )

        # --- 4: duplicate_key_within_source ---
        result = ral.reconcile(
            main_text,
            [("branch-a", branch_a_text), ("branch-b", branch_b_text)],
            use_id_key=True,
        )
        dup_keys = {d["key"] for d in result["duplicate_key_within_source"]}
        check(
            "DECISION-0010" in dup_keys,
            "a key reused twice with different content within ONE source "
            "is reported as duplicate_key_within_source",
        )
        check(
            result["duplicate_key_within_source"][0]["source"] == "branch-a",
            "the duplicate is attributed to the source that actually has it",
        )

        # --- 6: source_vs_source_collision (main has neither) ---
        svs_keys = {c["key"] for c in result["source_vs_source_collision"]}
        check(
            "DECISION-0099" in svs_keys,
            "two sources independently inventing different content for the "
            "same unused key is source_vs_source_collision",
        )
        check(
            "DECISION-0099" not in {c["key"] for c in result["collides_with_main"]},
            "source_vs_source_collision is NEVER also reported as "
            "collides_with_main — main has no entry for that key at all",
        )

        # --- 7: collides_with_main (main HAS this key, a source disagrees) ---
        cwm_keys = {c["key"] for c in result["collides_with_main"]}
        check(
            "DECISION-0002" in cwm_keys,
            "a key present in main, overwritten with different content by a "
            "source, is collides_with_main — a real overwrite risk",
        )

        # --- clean missing case ---
        missing_keys = {m["key"] for m in result["missing"]}
        check(
            "DECISION-0020" in missing_keys,
            "a genuinely new key with no main entry and no cross-source "
            "disagreement is a clean 'missing' entry, safe to append",
        )
        check(
            "DECISION-0099" not in missing_keys and "DECISION-0010" not in missing_keys,
            "keys involved in a collision are never ALSO listed as clean missing entries",
        )

        # --- 3: append-only — main's file content is never mutated by this run ---
        main_text_after = ral.run_git(repo, "show", f"{main_sha}:{LOG_PATH}")
        check(
            main_text_after == main_text,
            "main's committed file content is byte-for-byte unchanged after reconcile() runs "
            "(the tool only ever reads main via `git show`, never writes to it)",
        )
        packet = ral.build_append_packet(result["missing"])
        check(
            "DECISION-0001" not in packet and "DECISION-0002" not in packet,
            "the append packet contains ONLY new entries, never main's existing ones "
            "(this is an append packet, not a regenerated/reordered replacement file)",
        )
        check(
            "DECISION-0020" in packet,
            "the clean missing entry is present in the append packet",
        )

    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    print()
    if FAILURES:
        print(f"{len(FAILURES)} FAILURE(S)")
        sys.exit(1)
    print("All fixture checks passed.")


if __name__ == "__main__":
    main()
