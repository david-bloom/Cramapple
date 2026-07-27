#!/usr/bin/env python3
"""Reproducible classification manifest for the grading-branch consolidation.

Analyzes the four grading source branches (plus the dirty uncommitted
checkout on claude/cramapple-grading-experiments-9lkjqc) against
origin/main, using merge-base-aware diffs so files added on main after a
branch forked are never misread as source-branch deletions.

This script is read-only: it never stages, stashes, commits, or otherwise
mutates any of the repositories/worktrees it inspects. It only writes its
own output files (CSV/JSONL/summary) into the current working tree.

Usage:
    python3 scripts/branch_consolidation/classify_grading_branches.py \
        --repo /Users/davidbloom/Documents/Cramapple \
        --dirty-checkout-repo /Users/davidbloom/Documents/Cramapple \
        --out-dir docs/research/grading_branch_consolidation_manifest_2026_07_26

`--dirty-checkout-repo` defaults to `--repo` and only needs to differ if the
dirty uncommitted checkout being inventoried lives in a different working
tree than the one holding the source-branch refs (e.g. a bare mirror used
for the branch diffs, with the real working tree elsewhere).
"""

import argparse
import csv
import json
import os
import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass, field, asdict
from typing import Optional

MAIN_REF = "origin/main"

SOURCE_BRANCHES = [
    "origin/claude/cramapple-grading-mlr0o1",
    "origin/codex/five-subject-harness-and-content",
    "origin/recovery/ap-statistics-benchmark-content-20260721",
    "origin/claude/cramapple-grading-experiments-9lkjqc",
]

DIRTY_CHECKOUT_BRANCH = "claude/cramapple-grading-experiments-9lkjqc"

CLASSIFICATIONS = (
    "capability",
    "grading-evidence",
    "content-CED",
    "governance-history",
    "discard-candidate",
    "ambiguous",
)


def run_git(repo, *args):
    result = subprocess.run(
        ["git", "-C", repo, *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(
            f"git -C {repo} {' '.join(args)} failed: {result.stderr.strip()}"
        )
    return result.stdout


@dataclass
class Row:
    source: str
    source_tip_sha: str
    baseline_sha: str
    layer: str  # "committed" | "uncommitted-worktree"
    path: str
    change_type: str
    old_blob: Optional[str]
    new_blob: Optional[str]
    main_blob: Optional[str] = None
    main_equivalence: str = "unknown"  # identical | divergent | absent | deletion | not-applicable-nested-repo
    needs_landing: bool = True
    classification: str = "ambiguous"
    confidence: str = "low"
    rationale: str = ""
    flags: list = field(default_factory=list)
    intended_destination: str = "pending-review"
    disposition_approval: str = "n/a"
    dependency_notes: str = ""
    nested_repo_remote: Optional[str] = None
    nested_repo_branch: Optional[str] = None
    nested_repo_head: Optional[str] = None
    nested_repo_clean: Optional[bool] = None
    nested_repo_upstream_ref: Optional[str] = None
    nested_repo_upstream_equivalence: Optional[str] = None  # identical | ahead | behind-or-diverged | no-upstream-configured


# --- Classification rule engine -------------------------------------------
# Ordered (pattern, classification, confidence, rationale) rules.
# First match wins. Everything else falls through to "ambiguous"/low.

RULES = [
    # --- Governance / history -------------------------------------------
    (r"^docs/team_charter/", "governance-history", "high",
     "Charter document; governed by its own Hard-Gate change process, not grading scope."),
    (r"^docs/activity_log/", "governance-history", "high",
     "Activity log entry; historical record, not runtime/evidence content."),
    (r"^docs/proposals/BRANCH_HYGIENE", "governance-history", "high",
     "Branch/process governance proposal, unrelated to grading engine or evidence."),
    (r"APPROVAL-\d{4}|DECISION-\d{4}", "governance-history", "medium",
     "Filename references an approval/decision record."),
    (r"^prompts/.*HANDOFF", "governance-history", "medium",
     "Session handoff prompt; process artifact, not grading capability/evidence."),
    (r"^legacy/", "discard-candidate", "medium",
     "Legacy planning/blueprint doc predating current architecture; likely superseded."),

    # --- Capability (runtime, verifiers, harness, tests) ------------------
    (r"^supabase/functions/_shared/.*verifier", "capability", "high",
     "Deterministic verifier implementation — core grading capability."),
    (r"^supabase/functions/.*grad", "capability", "high",
     "Edge function implementing grading behavior."),
    (r"^supabase/functions/", "capability", "medium",
     "Supabase edge function; runtime backend code."),
    (r"^supabase/migrations/.*(harness|grading|verifier|rubric|calibration|frq)",
     "capability", "high",
     "Schema migration supporting the grading harness/verifier/rubric pipeline."),
    (r"^supabase/migrations/", "capability", "medium",
     "Schema migration; runtime/DB change requiring migration-safety review."),
    (r"^supabase/seed/.*(grad|calibr|frq|harness)", "capability", "high",
     "Seed data required to bootstrap the grading harness schema."),
    (r"^supabase/tests/", "capability", "high",
     "Automated regression test for grading/harness backend behavior."),
    (r"^docs/tasks/TASK-0016", "capability", "high",
     "Grading-engine rollout task doc (TASK-0016 program)."),
    (r"^docs/tasks/TASK-0017", "capability", "high",
     "Subject-onboarding harness task doc (TASK-0017 program)."),
    (r"^docs/research/grading_(engine|launch_gate)", "capability", "high",
     "Grading-engine architecture/rollout research doc."),

    # --- Grading evidence (benchmarks, corpora, calibration results) ------
    (r"benchmark", "grading-evidence", "high", "Benchmark corpus/report artifact."),
    (r"bakeoff", "grading-evidence", "high", "Model bakeoff evaluation artifact."),
    (r"phase_b|phase4|phase_c|phase6", "grading-evidence", "high",
     "Phased grading-evaluation artifact (Phase B/C/4/6 research)."),
    (r"gold_set|calibration", "grading-evidence", "high",
     "Calibration/gold-set evidence artifact."),
    (r"hand_drawn|trace_images|trace_set", "grading-evidence", "medium",
     "Hand-drawn/graph-response evaluation evidence."),
    (r"^docs/research/math_formula_grading_experiment", "grading-evidence", "high",
     "Math-formula symbolic-equivalence experiment corpus."),
    (r"^docs/research/statistics_phase_b", "grading-evidence", "high",
     "AP Statistics Phase B evaluation evidence."),
    (r"^docs/research/AP_STATISTICS_VERIFICATION_PROFILE", "grading-evidence",
     "high", "AP Statistics verification profile evidence artifact."),
    (r"records_.*\.jsonl$", "grading-evidence", "high",
     "Raw model-response evaluation records."),
    (r"^scripts/.*benchmark", "grading-evidence", "high",
     "Script used to build/evaluate a benchmark corpus (evidence tooling, not runtime)."),
    (r"^scripts/drawn_response/", "grading-evidence", "medium",
     "Drawn-response evaluation tooling; treat as evidence pipeline unless it is called from runtime code."),
    (r"hdr_trace_ready|hdr_grading_experiment|hdr_experiment|_hdr_|hdg_spatial|"
     r"grading_experiment_batch|deterministic_check_experiment|"
     r"label_robustness_crosscheck|trace_image_set", "grading-evidence", "medium",
     "Hand-drawn-response/grading-experiment research artifact (pattern matched on directory name)."),
    (r"^docs/research/ap_statistics_mcq_launch_bank|"
     r"^docs/research/bio_reference_layer_spike_corpus|"
     r"^docs/research/apstats_packet_bundle|"
     r"graph_response_seed|stimulus_images|AP Stats HDR Images", "grading-evidence", "medium",
     "AP Statistics/Biology grading-research artifact (stimulus/graph-response seed evidence)."),
    (r"^schemas/subject-onboarding/", "capability", "medium",
     "Subject-onboarding harness schema/fixtures (TASK-0017 program)."),
    (r"^scripts/grading-model-assessment/", "capability", "medium",
     "Grading-model assessment harness tooling."),

    # --- Content / CED (subject content, not grading harness) -------------
    (r"^content/item-packages/", "content-CED", "high",
     "Subject item-package content (question bank content), not grading harness code."),
    (r"^docs/content/", "content-CED", "medium",
     "Subject-content planning/probe document."),

    # --- Content / CED operations -----------------------------------------
    (r"^docs/teaching/.*\.pdf$", "content-CED", "high",
     "Official CED reference document; content-authoring input, not grading logic."),
    (r"FRQ_STRUCTURE", "content-CED", "high",
     "FRQ structure validation/correction work for a specific subject's content."),
    (r"CONTENT_EXPANSION", "content-CED", "high",
     "Subject content-expansion work."),
    (r"REVIEWER_QA_REMEDIATION", "content-CED", "high",
     "Reviewer QA remediation content work."),
    (r"^scripts/content-seed/", "content-CED", "high",
     "Content-seeding script for subject-content authoring, not the grading harness."),
    (r"^prompts/CODEX_.*CONTENT", "content-CED", "medium",
     "Content-authoring task prompt."),
    (r"^prompts/CLAUDE_.*FRQ_STRUCTURE", "content-CED", "medium",
     "FRQ structure repair task prompt."),
    (r"DRAWN_RESPONSE_FRQs.*images", "content-CED", "medium",
     "Drawn-response FRQ content assets."),

    # --- Discard candidates -------------------------------------------------
    (r"^\.worktrees/", "discard-candidate", "medium",
     "Local worktree scratch directory; not intended to be tracked content."),
]

COMPILED_RULES = [(re.compile(p), c, conf, r) for p, c, conf, r in RULES]

SECURITY_SENSITIVE_RE = re.compile(
    r"rls|policy|polic|auth|admin|promote|grant|revoke|secret|token|_key|"
    r"role|permission|storage-sign-url",
    re.IGNORECASE,
)
MIGRATION_RE = re.compile(r"^supabase/migrations/")
RUNTIME_RE = re.compile(r"^supabase/functions/")


def classify(path: str):
    for regex, classification, confidence, rationale in COMPILED_RULES:
        if regex.search(path):
            return classification, confidence, rationale
    return "ambiguous", "low", "No rule matched this path; needs human classification."


def compute_flags(path: str, layer: str, change_type: str):
    flags = []
    if SECURITY_SENSITIVE_RE.search(path):
        flags.append("security-sensitive")
    if MIGRATION_RE.search(path):
        flags.append("migration")
    if RUNTIME_RE.search(path):
        flags.append("runtime")
    if layer == "uncommitted-worktree":
        flags.append("uncommitted-worktree")
    if change_type == "D":
        flags.append("deletion")
    return flags


def diff_branch_against_main(repo, branch):
    """Merge-base-aware diff: git diff <merge-base>...<branch>.

    Using the three-dot form (main...branch) is equivalent to diffing
    merge-base(main, branch) against branch, which is exactly what we want:
    files added to main after branch forked never show up as "deleted by
    branch".
    """
    tip = run_git(repo, "rev-parse", branch).strip()
    baseline = run_git(repo, "merge-base", MAIN_REF, branch).strip()
    # --abbrev=40 forces full-length blob SHAs. Without it, git defaults to
    # 7-char abbreviations, which collide across unrelated blobs at this
    # corpus size and made every cross-check against the (full-length)
    # dirty-checkout hashes silently wrong.
    raw = run_git(
        repo, "diff", "--raw", "-z", "--abbrev=40", f"{MAIN_REF}...{branch}"
    )
    return tip, baseline, parse_raw_diff_z(raw)


def parse_raw_diff_z(raw: str):
    """Parse NUL-separated `git diff --raw -z` output into structured rows."""
    parts = raw.split("\x00")
    i = 0
    entries = []
    while i < len(parts):
        rec = parts[i]
        if not rec:
            i += 1
            continue
        # format: :old_mode new_mode old_blob new_blob status
        fields = rec.lstrip(":").split(" ")
        old_blob, new_blob, status = fields[2], fields[3], fields[4]
        change_type = status[0]
        if change_type == "R" or change_type == "C":
            old_path = parts[i + 1]
            new_path = parts[i + 2]
            i += 3
            entries.append((new_path, change_type, old_blob, new_blob, old_path))
        else:
            path = parts[i + 1]
            i += 2
            entries.append((path, change_type, old_blob, new_blob, None))
    return entries


def inspect_nested_repository(repo, rel_path):
    """Identify a nested git repository (e.g. a `git worktree add` checkout
    of an entirely different project) found inside the Cramapple working
    tree, without recursing into its files.

    `git status` never expands a directory that is itself a git repository
    — it reports the directory path with a trailing slash instead, even
    under `--untracked-files=all`. That boundary is correct git behavior,
    not a bug: the nested repo has its own history, remote, and identity,
    and its files are not Cramapple content. Recursing into it and
    classifying its files as capability/evidence/content-CED/discard would
    misrepresent a separate project as part of this repo's grading
    consolidation.

    Returns a dict describing the nested repo's remote, branch, HEAD,
    working-tree cleanliness, and upstream equivalence — enough for a human
    to judge durability without needing to open it.
    """
    nested_path = os.path.join(repo, rel_path)
    remotes = run_git(nested_path, "remote", "-v").strip()
    remote_url = None
    for line in remotes.splitlines():
        parts = line.split()
        if len(parts) >= 2 and parts[0] == "origin":
            remote_url = parts[1]
            break

    branch = run_git(nested_path, "rev-parse", "--abbrev-ref", "HEAD").strip()
    head = run_git(nested_path, "rev-parse", "HEAD").strip()
    dirty_count = len(
        [
            line
            for line in run_git(nested_path, "status", "--porcelain=1").splitlines()
            if line.strip()
        ]
    )
    clean = dirty_count == 0

    upstream_ref = None
    upstream_equivalence = "no-upstream-configured"
    try:
        upstream_ref = run_git(
            nested_path, "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"
        ).strip()
        upstream_sha = run_git(nested_path, "rev-parse", "@{u}").strip()
        if upstream_sha == head:
            upstream_equivalence = "identical"
        else:
            ahead_behind = run_git(
                nested_path, "rev-list", "--left-right", "--count", f"{upstream_ref}...HEAD"
            ).strip()
            behind, ahead = (ahead_behind.split() + ["0", "0"])[:2]
            if behind == "0" and ahead != "0":
                upstream_equivalence = "ahead"
            else:
                upstream_equivalence = "behind-or-diverged"
    except RuntimeError:
        pass

    return {
        "remote": remote_url,
        "branch": branch,
        "head": head,
        "clean": clean,
        "upstream_ref": upstream_ref,
        "upstream_equivalence": upstream_equivalence,
    }


def inventory_dirty_checkout(repo, branch):
    """Read-only inventory of the uncommitted working-tree state.

    Uses `git status --porcelain=1 -z --untracked-files=all` (read-only)
    and `git hash-object` (read-only — computes a blob hash without writing
    it or touching the index) to fingerprint every individual file without
    staging anything.

    Two deliberate choices fix real bugs found in the first version:
    - `--untracked-files=all` expands untracked directories into their
      individual files. The default "normal" mode collapses an untracked
      directory into a single directory-path entry, silently dropping every
      file inside it from the manifest.
    - `-z` (NUL-terminated, unquoted paths) avoids porcelain's C-style
      quoting of paths containing spaces or other special characters, which
      otherwise leaves literal quote characters in the path and breaks
      `git hash-object` lookups for those files.
    """
    tip = run_git(repo, "rev-parse", "HEAD").strip()
    baseline = run_git(repo, "merge-base", MAIN_REF, branch).strip()
    status_out = run_git(
        repo, "status", "--porcelain=1", "-z", "--untracked-files=all"
    )
    parts = status_out.split("\x00")
    entries = []
    nested_repos = []
    i = 0
    while i < len(parts):
        rec = parts[i]
        if not rec:
            i += 1
            continue
        code = rec[:2]
        path = rec[3:]
        i += 1
        if "R" in code or "C" in code:
            # Rename/copy records carry the destination path in this field
            # and consume one extra NUL-separated field for the origin path.
            i += 1  # skip ORIG_PATH — not needed for this inventory
        if code.strip() == "??":
            change_type = "A"
        elif "D" in code:
            change_type = "D"
        else:
            change_type = "M"

        # An untracked path reported with a trailing slash is a directory
        # git refused to expand — the signature of a nested git repository
        # (its own .git boundary), not an ordinary untracked directory.
        if change_type == "A" and path.endswith("/"):
            rel = path.rstrip("/")
            if os.path.exists(os.path.join(repo, rel, ".git")):
                info = inspect_nested_repository(repo, rel)
                info["path"] = rel
                nested_repos.append(info)
                continue

        new_blob = None
        if change_type != "D":
            try:
                new_blob = run_git(repo, "hash-object", path).strip()
            except RuntimeError:
                new_blob = None
        entries.append((path, change_type, None, new_blob, None))
    return tip, baseline, entries, nested_repos


def load_main_blob_map(repo):
    """Full path -> blob-SHA map for the current origin/main tree.

    Built once via `git ls-tree -r -z`, which is read-only and returns
    full-length (40-char) blob SHAs by default — no abbreviation mismatch
    to worry about here.
    """
    raw = run_git(repo, "ls-tree", "-r", "-z", MAIN_REF)
    mapping = {}
    for rec in raw.split("\x00"):
        if not rec:
            continue
        meta, path = rec.split("\t", 1)
        # meta = "<mode> blob <sha>"
        blob = meta.split(" ")[2]
        mapping[path] = blob
    return mapping


def build_rows(repo, dirty_checkout_repo):
    main_blob_map = load_main_blob_map(repo)
    rows = []
    for branch in SOURCE_BRANCHES:
        tip, baseline, entries = diff_branch_against_main(repo, branch)
        for path, change_type, old_blob, new_blob, old_path in entries:
            classification, confidence, rationale = classify(path)
            flags = compute_flags(path, "committed", change_type)
            row = Row(
                source=branch,
                source_tip_sha=tip,
                baseline_sha=baseline,
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
            finalize_row(row, old_path, main_blob_map)
            rows.append(row)

    # Dirty uncommitted checkout — read-only inventory, separate layer.
    tip, baseline, entries, nested_repos = inventory_dirty_checkout(
        dirty_checkout_repo, DIRTY_CHECKOUT_BRANCH
    )

    for info in nested_repos:
        row = Row(
            source=f"WORKTREE:{DIRTY_CHECKOUT_BRANCH}",
            source_tip_sha=f"{tip}+dirty",
            baseline_sha=baseline,
            layer="uncommitted-worktree",
            path=info["path"],
            change_type="A",
            old_blob=None,
            new_blob=None,
            classification="nested-repository",
            confidence="high",
            rationale=(
                "Nested git repository (separate remote/history) found inside "
                "the working tree — not Cramapple content, excluded from the "
                "per-file inventory. See nested_repo_* fields."
            ),
            flags=["nested-repository"],
        )
        row.nested_repo_remote = info["remote"]
        row.nested_repo_branch = info["branch"]
        row.nested_repo_head = info["head"]
        row.nested_repo_clean = info["clean"]
        row.nested_repo_upstream_ref = info["upstream_ref"]
        row.nested_repo_upstream_equivalence = info["upstream_equivalence"]
        row.main_equivalence = "not-applicable-nested-repo"
        row.needs_landing = False
        row.intended_destination = (
            f"none — separate repository ({info['remote'] or 'remote unknown'}), "
            "not part of the Cramapple grading consolidation"
        )
        if info["clean"] and info["upstream_equivalence"] == "identical":
            row.disposition_approval = "not-applicable-durable-elsewhere"
        else:
            row.disposition_approval = "pending"
            row.flags.append("nested-repo-not-verified-durable")
        rows.append(row)

    for path, change_type, old_blob, new_blob, old_path in entries:
        classification, confidence, rationale = classify(path)
        flags = compute_flags(path, "uncommitted-worktree", change_type)
        row = Row(
            source=f"WORKTREE:{DIRTY_CHECKOUT_BRANCH}",
            source_tip_sha=f"{tip}+dirty",
            baseline_sha=baseline,
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
        finalize_row(row, old_path, main_blob_map)
        rows.append(row)

    return rows


def finalize_row(row: Row, old_path, main_blob_map):
    row.main_blob = main_blob_map.get(row.path)

    if row.change_type == "D":
        if row.main_blob is None:
            row.main_equivalence = "absent"
            row.needs_landing = False
        else:
            row.main_equivalence = "deletion"
            row.needs_landing = True
    else:
        if row.main_blob is None:
            row.main_equivalence = "absent"
            row.needs_landing = True
        elif row.main_blob == row.new_blob:
            row.main_equivalence = "identical"
            row.needs_landing = False
            row.flags.append("already-on-main")
        else:
            row.main_equivalence = "divergent"
            row.needs_landing = True

    if row.classification == "discard-candidate":
        row.disposition_approval = "pending"
        row.intended_destination = "none — awaiting David's explicit discard acceptance"
    elif row.classification == "capability":
        row.intended_destination = "grading-capabilities-pr"
    elif row.classification == "grading-evidence":
        row.intended_destination = "grading-evidence-pr"
    elif row.classification == "content-CED":
        row.intended_destination = "content-ced-pr(s)"
    elif row.classification == "governance-history":
        row.intended_destination = "none — reference/history only, not landed via a grading PR"
    else:
        row.intended_destination = "pending-review"

    # Any row with a "none" destination would otherwise land nowhere and
    # vanish from reconciliation with no record of why. Treat it exactly
    # like a discard-candidate — pending explicit sign-off — unless it is
    # independently proven to already be represented on main byte-for-byte.
    if row.intended_destination.startswith("none"):
        if row.main_equivalence == "identical":
            row.disposition_approval = "represented-on-main"
        else:
            row.disposition_approval = "pending"

    if row.confidence == "low":
        row.flags.append("low-confidence")
    if old_path:
        row.dependency_notes = f"renamed from {old_path}"


def detect_overlaps(rows):
    """Detect duplicate blobs (same content landed via >1 source) and
    conflicting overlaps (same path, different content, across sources)."""
    by_blob = defaultdict(list)
    by_path = defaultdict(list)
    for r in rows:
        if r.new_blob:
            by_blob[r.new_blob].append(r)
        by_path[r.path].append(r)

    for blob, group in by_blob.items():
        sources = {g.source for g in group}
        if len(sources) > 1:
            for r in group:
                r.flags.append("duplicate-blob-across-sources")
                r.dependency_notes = (
                    r.dependency_notes
                    + f" | identical content also present via: "
                    + ", ".join(sorted(sources - {r.source}))
                ).strip(" |")

    for path, group in by_path.items():
        sources = {g.source for g in group}
        if len(sources) > 1:
            blobs = {g.new_blob for g in group if g.new_blob}
            if len(blobs) > 1:
                for r in group:
                    if r.path == path:
                        r.flags.append("cross-branch-conflict")
                        r.confidence = "low"
                        r.flags.append("low-confidence")
                        r.dependency_notes = (
                            r.dependency_notes
                            + " | CONFLICT: divergent content for this path across: "
                            + ", ".join(sorted(sources))
                        ).strip(" |")


def write_outputs(rows, out_dir):
    import os

    os.makedirs(out_dir, exist_ok=True)
    csv_path = os.path.join(out_dir, "manifest.csv")
    jsonl_path = os.path.join(out_dir, "manifest.jsonl")
    fieldnames = list(asdict(rows[0]).keys()) if rows else []

    with open(csv_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for r in rows:
            d = asdict(r)
            d["flags"] = ";".join(sorted(set(r.flags)))
            writer.writerow(d)

    with open(jsonl_path, "w") as f:
        for r in rows:
            d = asdict(r)
            d["flags"] = sorted(set(r.flags))
            f.write(json.dumps(d) + "\n")

    return csv_path, jsonl_path


def summarize(rows):
    total = len(rows)
    by_class = defaultdict(int)
    by_source = defaultdict(int)
    flagged = defaultdict(int)
    by_equivalence = defaultdict(int)
    discard_pending = 0
    pending_disposition = 0
    already_on_main = 0
    conflicts = set()
    nested_repos = []
    for r in rows:
        if r.classification == "nested-repository":
            nested_repos.append(r)
        by_class[r.classification] += 1
        by_source[r.source] += 1
        by_equivalence[r.main_equivalence] += 1
        for fl in set(r.flags):
            flagged[fl] += 1
        if r.classification == "discard-candidate":
            discard_pending += 1
        if r.disposition_approval == "pending":
            pending_disposition += 1
        if r.main_equivalence == "identical":
            already_on_main += 1
        if "cross-branch-conflict" in r.flags:
            conflicts.add(r.path)
    return {
        "total_rows": total,
        "by_classification": dict(sorted(by_class.items())),
        "by_source": dict(sorted(by_source.items())),
        "flag_counts": dict(sorted(flagged.items())),
        "by_main_equivalence": dict(sorted(by_equivalence.items())),
        "discard_candidates_pending_approval": discard_pending,
        "rows_pending_disposition_approval": pending_disposition,
        "rows_already_identical_on_main": already_on_main,
        "conflicting_paths": sorted(conflicts),
        "nested_repos": nested_repos,
    }


def write_summary_md(summary, out_dir, rows):
    import os

    path = os.path.join(out_dir, "SUMMARY.md")
    lines = []
    lines.append("# Grading Branch Consolidation — Classification Manifest Summary")
    lines.append("")
    lines.append(
        "Generated by `scripts/branch_consolidation/classify_grading_branches.py`. "
        "This is an analysis artifact only — it does not authorize merging, "
        "discarding, or deleting anything."
    )
    lines.append("")
    lines.append(f"**Total rows (path x source):** {summary['total_rows']}")
    lines.append("")
    lines.append("## By classification")
    lines.append("")
    lines.append("| classification | count |")
    lines.append("|---|---|")
    for k, v in summary["by_classification"].items():
        lines.append(f"| {k} | {v} |")
    lines.append("")
    lines.append("## By source")
    lines.append("")
    lines.append("| source | rows |")
    lines.append("|---|---|")
    for k, v in summary["by_source"].items():
        lines.append(f"| {k} | {v} |")
    lines.append("")
    lines.append("## Flags requiring human attention")
    lines.append("")
    lines.append("| flag | count |")
    lines.append("|---|---|")
    for k, v in summary["flag_counts"].items():
        lines.append(f"| {k} | {v} |")
    lines.append("")
    lines.append("## Main-equivalence (is this content already on `main`?)")
    lines.append("")
    lines.append("| main_equivalence | count |")
    lines.append("|---|---|")
    for k, v in summary["by_main_equivalence"].items():
        lines.append(f"| {k} | {v} |")
    lines.append("")
    lines.append(
        f"**{summary['rows_already_identical_on_main']} rows are already byte-identical "
        "on `main`** (`main_equivalence: identical`, `needs_landing: false`). These do not "
        "need to be carried into any destination PR — filter them out before assembling "
        "the capabilities/evidence/content-CED PRs to avoid re-landing content that is "
        "already there."
    )
    lines.append("")
    lines.append(
        f"## Disposition approval — **{summary['rows_pending_disposition_approval']} rows "
        "pending** (discard-candidates + any other row whose destination is `none`)"
    )
    lines.append("")
    lines.append(
        "No row with `disposition_approval: pending` may be dropped, omitted from "
        "reconciliation, or used to justify branch deletion until David explicitly "
        "reviews and accepts it — this includes the `discard-candidate` rows and any "
        "`governance-history` (or other `none`-destination) row that is not already "
        "proven identical to `main`. See manifest.csv filtered on "
        "`disposition_approval=pending`."
    )
    lines.append("")
    if summary["conflicting_paths"]:
        lines.append(
            f"## Cross-branch conflicts ({len(summary['conflicting_paths'])} paths)"
        )
        lines.append("")
        lines.append(
            "These paths were changed differently by more than one source "
            "branch. They need explicit human reconciliation before any "
            "destination PR is assembled:"
        )
        lines.append("")
        for p in summary["conflicting_paths"][:200]:
            lines.append(f"- `{p}`")
        lines.append("")
    nested_repos = summary.get("nested_repos") or []
    if nested_repos:
        lines.append(f"## Nested repositories detected ({len(nested_repos)})")
        lines.append("")
        lines.append(
            "These are separate git repositories (their own remote/history) "
            "found inside the working tree — e.g. a `git worktree add` "
            "checkout of a different project. Their files are excluded from "
            "the per-file inventory above; only this identity/durability "
            "record is kept for each."
        )
        lines.append("")
        for r in nested_repos:
            lines.append(f"### `{r.path}`")
            lines.append("")
            lines.append(f"- remote: `{r.nested_repo_remote}`")
            lines.append(f"- branch: `{r.nested_repo_branch}`")
            lines.append(f"- HEAD: `{r.nested_repo_head}`")
            lines.append(f"- working tree clean: `{r.nested_repo_clean}`")
            lines.append(
                f"- upstream (`{r.nested_repo_upstream_ref}`) equivalence: "
                f"`{r.nested_repo_upstream_equivalence}`"
            )
            lines.append(f"- disposition_approval: `{r.disposition_approval}`")
            lines.append("")
        lines.append(
            "A nested repo with `clean: True` and upstream equivalence "
            "`identical` is fully durable on its own remote — nothing in it "
            "would be lost if this directory were removed. That is a factual "
            "finding, not an approval: removal is still a decision for a "
            "human to make explicitly, and is entirely out of scope for the "
            "Cramapple grading-branch consolidation this manifest covers."
        )
        lines.append("")
    lines.append("## Known limitations of this pass")
    lines.append("")
    lines.append(
        "- Classification is path-pattern based (regex over file paths), not "
        "static code/content analysis. Every `ambiguous` row and every "
        "`low-confidence` flag needs a human look before it is assigned to a "
        "destination PR.\n"
        "- Cross-lane dependency detection is heuristic (migration/runtime "
        "path flags only) — it does not trace actual code imports or SQL "
        "foreign-key relationships between migrations.\n"
        "- PR #38 (`claude/cramapple-grading-mlr0o1`) is covered here as a "
        "source branch, not touched, closed, or altered. Its content is "
        "represented in the manifest for downstream harvesting into the "
        "capabilities PR."
    )
    with open(path, "w") as f:
        f.write("\n".join(lines) + "\n")
    return path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", required=True)
    parser.add_argument(
        "--dirty-checkout-repo",
        default=None,
        help="Working tree to inventory for the uncommitted dirty-checkout "
        "layer. Defaults to --repo.",
    )
    parser.add_argument("--out-dir", required=True)
    args = parser.parse_args()
    dirty_checkout_repo = args.dirty_checkout_repo or args.repo

    rows = build_rows(args.repo, dirty_checkout_repo)
    detect_overlaps(rows)
    csv_path, jsonl_path = write_outputs(rows, args.out_dir)
    summary = summarize(rows)
    summary_path = write_summary_md(summary, args.out_dir, rows)

    print(f"Wrote {len(rows)} rows.", file=sys.stderr)
    print(f"CSV: {csv_path}", file=sys.stderr)
    print(f"JSONL: {jsonl_path}", file=sys.stderr)
    print(f"Summary: {summary_path}", file=sys.stderr)


if __name__ == "__main__":
    main()
