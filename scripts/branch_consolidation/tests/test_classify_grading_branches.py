#!/usr/bin/env python3
"""Fixture tests for classify_grading_branches.py.

Builds a real throwaway git repository under a temp directory (no mocking
of git itself) and exercises the exact scenarios that a prior review round
found broken:

1. Untracked directories are expanded to their individual files, not
   collapsed into one directory entry.
2. Filenames containing spaces survive the dirty-checkout inventory without
   retaining porcelain quote characters.
3. Committed-diff blob hashes and dirty-checkout blob hashes are the same
   width (full 40-char), so cross-checks between them are meaningful.
4. Byte-identical content across two sources is flagged
   duplicate-blob-across-sources, not cross-branch-conflict.
5. Divergent content at the same path across two sources is flagged
   cross-branch-conflict.
6. A deletion whose target still exists on current main is distinguished
   (main_equivalence: deletion) from one that's already gone (absent).
7. A "none"-destination row (governance-history) gets
   disposition_approval: pending unless it is byte-identical to main, in
   which case it's `represented-on-main` — never silently `n/a`.

Run with: python3 scripts/branch_consolidation/tests/test_classify_grading_branches.py
"""

import os
import shutil
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import classify_grading_branches as czb  # noqa: E402

FAILURES = []


def check(condition, message):
    if not condition:
        FAILURES.append(message)
        print(f"FAIL: {message}")
    else:
        print(f"ok:   {message}")


def git(repo, *args):
    return czb.run_git(repo, *args)


def write(repo, relpath, content):
    full = os.path.join(repo, relpath)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "w") as f:
        f.write(content)


def build_fixture_repo(tmp):
    repo = os.path.join(tmp, "repo")
    os.makedirs(repo)
    git(repo, "init", "-q", "-b", "main")
    git(repo, "config", "user.email", "test@example.com")
    git(repo, "config", "user.name", "Test")

    # --- C0 on main: baseline shared by both feature branches ---
    write(repo, "docs/team_charter/GOV.md", "gov v1\n")
    write(repo, "docs/research/benchmark/report.md", "evidence v1\n")
    write(repo, "docs/old/todelete.md", "bye\n")
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "C0")

    # --- feature branch forks from C0 ---
    git(repo, "checkout", "-q", "-b", "feature")
    write(repo, "docs/research/benchmark/report.md", "evidence v2 (feature)\n")
    write(repo, "supabase/functions/foo/index.ts", "export const foo = 1;\n")
    write(repo, "docs/research/dup/a.md", "dup content\n")
    write(repo, "docs/research/benchmark/already_landed.md", "already there\n")
    os.remove(os.path.join(repo, "docs/old/todelete.md"))
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "feature C1")

    # --- feature2 branch also forks from C0 ---
    git(repo, "checkout", "-q", "main")
    git(repo, "checkout", "-q", "-b", "feature2")
    write(repo, "docs/research/benchmark/report.md", "evidence v3 (feature2, conflicts)\n")
    write(repo, "docs/research/dup/b.md", "dup content\n")  # same blob as feature's a.md, different path
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "feature2 C2")

    # --- main advances after both branches forked ---
    git(repo, "checkout", "-q", "main")
    write(repo, "docs/new_on_main_after_fork.md", "new on main\n")
    write(repo, "docs/research/benchmark/already_landed.md", "already there\n")  # identical to feature's copy
    git(repo, "add", "-A")
    git(repo, "commit", "-q", "-m", "C0b on main")

    # --- dirty uncommitted working tree, checked out on feature ---
    git(repo, "checkout", "-q", "feature")
    os.makedirs(os.path.join(repo, "untracked_dir/nested"), exist_ok=True)
    write(repo, "untracked_dir/x.txt", "x\n")
    write(repo, "untracked_dir/nested/y.txt", "y\n")
    write(repo, "file with space.txt", "space file\n")
    write(repo, "docs/research/dup/dirty_dup.md", "dup content\n")  # identical to committed dup blob

    # --- nested git repository, e.g. a `git worktree add` checkout of an
    #     entirely different project, sitting untracked inside the tree ---
    upstream_bare = os.path.join(tmp, "nested_upstream.git")
    subprocess.run(
        ["git", "init", "-q", "--bare", upstream_bare], check=True
    )
    seed = os.path.join(tmp, "nested_seed")
    os.makedirs(seed)
    git(seed, "init", "-q", "-b", "main")
    git(seed, "config", "user.email", "test@example.com")
    git(seed, "config", "user.name", "Test")
    write(seed, "README.md", "nested project\n")
    git(seed, "add", "-A")
    git(seed, "commit", "-q", "-m", "seed")
    git(seed, "remote", "add", "origin", upstream_bare)
    git(seed, "push", "-q", "-u", "origin", "main")

    nested_dir = os.path.join(repo, "nested_project")
    subprocess.run(
        ["git", "clone", "-q", upstream_bare, nested_dir], check=True
    )

    return repo, nested_dir


def main():
    tmp = tempfile.mkdtemp(prefix="czb_fixture_")
    old_main_ref = czb.MAIN_REF
    try:
        repo, nested_dir = build_fixture_repo(tmp)
        czb.MAIN_REF = "main"  # no "origin" remote in this throwaway repo

        # --- 1 & 2: dirty-checkout inventory (untracked dirs + spaces) ---
        tip, baseline, entries, nested_repos = czb.inventory_dirty_checkout(repo, "feature")

        # --- nested-repository detection ---
        check(
            len(nested_repos) == 1,
            "exactly one nested git repository detected under the dirty checkout",
        )
        check(
            all(p != "nested_project" and not p.startswith("nested_project/")
                for p, *_ in entries),
            "the nested repository's files are excluded from the per-file "
            "dirty-checkout inventory entirely (not expanded, not hashed)",
        )
        if nested_repos:
            info = nested_repos[0]
            check(info["path"] == "nested_project", "nested repo path recorded correctly")
            check(
                info["remote"] is not None and info["remote"].endswith("nested_upstream.git"),
                "nested repo's origin remote URL captured",
            )
            check(info["branch"] == "main", "nested repo's current branch captured")
            check(info["clean"] is True, "nested repo correctly identified as clean")
            check(
                info["upstream_equivalence"] == "identical",
                "nested repo HEAD correctly identified as identical to its upstream",
            )
            check(
                info["clean"] and info["upstream_equivalence"] == "identical",
                "nested repo is verified clean + identical-to-upstream, which is "
                "exactly the condition build_rows uses to set "
                "disposition_approval=not-applicable-durable-elsewhere instead "
                "of pending",
            )
        by_path = {p: (ct, blob) for p, ct, _, blob, _ in entries}

        check(
            "untracked_dir/x.txt" in by_path,
            "untracked directory top-level file is inventoried individually",
        )
        check(
            "untracked_dir/nested/y.txt" in by_path,
            "untracked directory nested file is inventoried individually "
            "(not collapsed as a single directory entry)",
        )
        check(
            "untracked_dir" not in by_path,
            "the directory path itself is never emitted as a collapsed entry",
        )
        check(
            "file with space.txt" in by_path,
            "filename with a space is present under its real, unquoted name",
        )
        space_blob = by_path.get("file with space.txt", (None, None))[1]
        check(
            space_blob is not None and len(space_blob) == 40,
            "filename-with-space got a real 40-char blob hash (hash-object "
            "succeeded — porcelain quoting did not corrupt the path)",
        )

        # --- 3: hash width consistency between committed diff and dirty ---
        _, _, feature_entries = czb.diff_branch_against_main(repo, "feature")
        committed_blobs = [
            new_blob for _, _, _, new_blob, _ in feature_entries if new_blob
        ]
        dirty_blobs = [blob for _, blob in by_path.values() if blob]
        check(
            all(len(b) == 40 for b in committed_blobs),
            "committed-diff blobs are full 40-char SHAs (--abbrev=40 applied)",
        )
        check(
            all(len(b) == 40 for b in dirty_blobs),
            "dirty-checkout blobs are full 40-char SHAs",
        )

        # --- Build full rows via the real pipeline for the remaining checks ---
        main_blob_map = czb.load_main_blob_map(repo)

        def rows_for(branch):
            _, _, ents = czb.diff_branch_against_main(repo, branch)
            out = []
            for path, change_type, old_blob, new_blob, old_path in ents:
                classification, confidence, rationale = czb.classify(path)
                flags = czb.compute_flags(path, "committed", change_type)
                row = czb.Row(
                    source=branch,
                    source_tip_sha="x",
                    baseline_sha="y",
                    layer="committed",
                    path=path,
                    change_type=change_type,
                    old_blob=old_blob,
                    new_blob=new_blob,
                    classification=classification,
                    confidence=confidence,
                    rationale=rationale,
                    flags=flags,
                )
                czb.finalize_row(row, old_path, main_blob_map)
                out.append(row)
            return out

        feature_rows = rows_for("feature")
        feature2_rows = rows_for("feature2")

        dirty_rows = []
        for path, change_type, old_blob, new_blob, old_path in entries:
            classification, confidence, rationale = czb.classify(path)
            flags = czb.compute_flags(path, "uncommitted-worktree", change_type)
            row = czb.Row(
                source="WORKTREE:feature",
                source_tip_sha="z+dirty",
                baseline_sha="y",
                layer="uncommitted-worktree",
                path=path,
                change_type=change_type,
                old_blob=old_blob,
                new_blob=new_blob,
                classification=classification,
                confidence=confidence,
                rationale=rationale,
                flags=flags,
            )
            czb.finalize_row(row, old_path, main_blob_map)
            dirty_rows.append(row)

        all_rows = feature_rows + feature2_rows + dirty_rows
        czb.detect_overlaps(all_rows)

        by_key = {(r.source, r.path): r for r in all_rows}

        # --- 4: duplicate blob across sources (different paths, same content) ---
        a = by_key[("feature", "docs/research/dup/a.md")]
        b = by_key[("feature2", "docs/research/dup/b.md")]
        check(
            "duplicate-blob-across-sources" in a.flags
            and "duplicate-blob-across-sources" in b.flags,
            "byte-identical content at different paths across two branches "
            "is flagged duplicate-blob-across-sources",
        )
        check(
            "cross-branch-conflict" not in a.flags
            and "cross-branch-conflict" not in b.flags,
            "duplicate-blob paths are NOT also flagged as conflicts",
        )

        # --- 4b: dirty layer participates correctly in duplicate detection ---
        dirty_dup = by_key[("WORKTREE:feature", "docs/research/dup/dirty_dup.md")]
        check(
            "duplicate-blob-across-sources" in dirty_dup.flags,
            "dirty-checkout content identical to a committed blob elsewhere "
            "is correctly matched via full-length hashes (this was "
            "impossible before the abbrev=40 fix)",
        )

        # --- 5: cross-branch conflict (same path, divergent content) ---
        report_feature = by_key[("feature", "docs/research/benchmark/report.md")]
        report_feature2 = by_key[("feature2", "docs/research/benchmark/report.md")]
        check(
            "cross-branch-conflict" in report_feature.flags
            and "cross-branch-conflict" in report_feature2.flags,
            "same path with divergent content across two branches is "
            "flagged cross-branch-conflict",
        )

        # --- 6: deletion vs absent main_equivalence ---
        deletion_row = by_key[("feature", "docs/old/todelete.md")]
        check(
            deletion_row.change_type == "D" and deletion_row.main_equivalence == "deletion",
            "a path deleted by a branch that still exists on current main is "
            "main_equivalence=deletion (not silently equated with 'absent')",
        )

        # --- main_equivalence: identical (already landed) ---
        already_landed = by_key[("feature", "docs/research/benchmark/already_landed.md")]
        check(
            already_landed.main_equivalence == "identical"
            and already_landed.needs_landing is False,
            "content byte-identical to what's already on main is "
            "main_equivalence=identical with needs_landing=False",
        )
        check(
            "already-on-main" in already_landed.flags,
            "already-landed row carries the already-on-main flag",
        )

        # --- main_equivalence: divergent ---
        check(
            report_feature.main_equivalence == "divergent",
            "content that differs from what's on main is main_equivalence=divergent",
        )

        # --- merge-base-awareness: new-on-main file must not appear as a
        #     deletion or otherwise pollute the feature-branch diff ---
        check(
            ("feature", "docs/new_on_main_after_fork.md") not in by_key,
            "a file added to main after the branch forked never appears in "
            "the branch's own diff (three-dot / merge-base-aware diff)",
        )

        # --- 7: "none"-destination disposition-approval gating ---
        gov_row = by_key[("feature", "docs/team_charter/GOV.md")] if (
            "feature", "docs/team_charter/GOV.md"
        ) in by_key else None
        # GOV.md wasn't touched by feature in this fixture; build a
        # governance-history row directly to test the gating logic in
        # isolation instead.
        gov_test_row = czb.Row(
            source="feature",
            source_tip_sha="x",
            baseline_sha="y",
            layer="committed",
            path="docs/team_charter/GOV_DIVERGENT.md",
            change_type="M",
            old_blob="0" * 40,
            new_blob="1" * 40,
        )
        gov_test_row.classification, gov_test_row.confidence, gov_test_row.rationale = (
            "governance-history",
            "high",
            "test",
        )
        czb.finalize_row(gov_test_row, None, {"docs/team_charter/GOV_DIVERGENT.md": "2" * 40})
        check(
            gov_test_row.intended_destination.startswith("none")
            and gov_test_row.disposition_approval == "pending",
            "a governance-history row that diverges from main gets "
            "disposition_approval=pending, not n/a — it cannot silently "
            "disappear",
        )

        gov_identical_row = czb.Row(
            source="feature",
            source_tip_sha="x",
            baseline_sha="y",
            layer="committed",
            path="docs/team_charter/GOV_SAME.md",
            change_type="M",
            old_blob="0" * 40,
            new_blob="3" * 40,
        )
        gov_identical_row.classification, gov_identical_row.confidence, gov_identical_row.rationale = (
            "governance-history",
            "high",
            "test",
        )
        czb.finalize_row(
            gov_identical_row, None, {"docs/team_charter/GOV_SAME.md": "3" * 40}
        )
        check(
            gov_identical_row.disposition_approval == "represented-on-main",
            "a governance-history row already byte-identical on main gets "
            "disposition_approval=represented-on-main, not a silent n/a",
        )

    finally:
        czb.MAIN_REF = old_main_ref
        shutil.rmtree(tmp, ignore_errors=True)

    print()
    if FAILURES:
        print(f"{len(FAILURES)} FAILURE(S)")
        sys.exit(1)
    print("All fixture checks passed.")


if __name__ == "__main__":
    main()
