# Grading Branch Consolidation — Resolution Ledger (2026-07-27)

Tied to the classification manifest merged in [PR #58](https://github.com/david-bloom/Cramapple/pull/58),
commit `b1733e10bbf6e43c4b1a251bdb536a9ce6d34550` on `main`
(`docs/research/grading_branch_consolidation_manifest_2026_07_26/manifest.csv`).

This ledger reconciles the 23 `cross-branch-conflict` paths identified in that
manifest. Per the agreed sequence: current `main` is treated as the base;
every branch version is evidence, not a candidate to simply "pick." Where a
composite is safe and mechanical, it's proposed here (code included under
`composites/`). Where reconciliation requires engineering judgment, a live
schema check, or a product decision, that is stated explicitly rather than
guessed.

**Status of this ledger: proposed analysis, not yet approved or landed.**
Nothing here has been merged to `main`. See the open status of each item
below.

---

## Runtime code conflicts (5)

### 1. `supabase/functions/_shared/statistics-verifier.ts` — RESOLVED, ready to land

Not a real conflict: `codex/five-subject-harness-and-content`'s copy is
byte-identical to current `main` (`main_equivalence: identical`) — it simply
forked before this file existed and never touched it further. Only
`claude/cramapple-grading-mlr0o1` (PR #38) actually changed it.

**Resolution:** adopt PR #38's version wholesale. Verified independently
(see PR #58 discussion): it removes two over-strict SE (standard-error)
checks that were zero-crediting mathematically-correct responses, with
dated, reasoned inline comments citing a specific provisional-labeled-earned
case from `provisional_labels.json` (response_index 2 and response_index 1)
that the old check wrongly flagged. No composite needed.

**Test:** PR #38 should carry its own regression case; confirm one exists
covering `APSTAT-MOD3-H001-INV` and `APSTAT-MOD6-H001` before landing, add
one if not.

### 2. `supabase/functions/evaluate-attempt/index.ts` — RESOLVED, pending migration dependency

Not a real conflict: `codex`'s copy is byte-identical to `main`. Only
`claude/cramapple-grading-experiments-9lkjqc` changed it — this is this
session's own unlanded security fix (part of commit `cceb01b`, "server-mediated
acquisition funnel"), confirmed **not** an ancestor of `origin/main`.

**What it does:** (a) closes an idempotent-replay authorization gap — the
existing-result-replay path returned another user's grading result to
whoever guessed the `attempt_id`, now checks `attempt.user_id` ownership
first; (b) adds a server-side `authorize_grading_access` RPC gate for
free-score-check entitlement (one free initial grade + one free repair
grade per user, enforced server-side, admin bypass).

**Resolution:** adopt this branch's version. **Hard dependency:** the RPC
`authorize_grading_access` is defined in migration
`supabase/migrations/20260720122542_free_score_check_growth_funnel.sql`,
which is *also* not on `main` yet. This function cannot land before that
migration (and its companion files `_shared/growth-events.ts`,
`_shared/growth-events_test.ts`, `free-score-check/index.ts`) — capabilities
lane, strict dependency order.

**Test:** `_shared/growth-events_test.ts` already exists on this branch;
confirm it covers the ownership-check path added here, or add a case.

### 3. `supabase/functions/admin-content/index.ts` — COMPOSITE PROPOSED

Both sides changed `main` independently, but in **non-overlapping functions**
— this is exactly the "composite, not either branch version" case:

- `codex/five-subject-harness-and-content` implements the atomic publication
  RPC (`invokeAtomicPublicationRpc`) and a completeness preflight gate
  (`assertPreflight`), replacing the old client-asserted `enforceGatePolicy`
  gate check. This is the fix for the known publication-trust bug (memory:
  "verified unfixed publication-trust bug — admin-content publishes before
  validating gates"; TASK-0017). High-value, security-relevant.
- `claude/cramapple-grading-experiments-9lkjqc` (commit `a654276`, this
  session, 2026-07-21) adds `checkAnswerLengthParity` as a non-blocking QA
  warning on MCQ ingestion — an unrelated, purely additive feature that
  never touches the publish path.

**Resolution:** composite, built and diff-verified at
`composites/admin-content.index.ts.proposed`. Base = codex's full file;
grafted in, in the exact 4 spots the original `a654276` diff touched (import,
`ensureLegacyProjection`'s MCQ block, its return value, `createArtifactDraft`'s
plumbing of `quality_warnings` through to its own return). Diffed against
both parents to confirm: retains all 4 codex-unique publication-RPC/preflight
hunks, retains all 6 experiments-unique length-parity hunks, touches nothing
else.

**Not yet done:** this has not been run through `deno check`/tests — no Deno
runtime available in this pass. **Before landing:** typecheck the composite
and run/extend `mcq-quality_test.ts` against it; also confirm
`./publication-request.ts` and `../_shared/content-preflight.ts` (codex's new
shared modules, referenced but not yet reviewed here) land alongside it.

### 4. `supabase/functions/review-decision/index.ts` — NEEDS DEDICATED ENGINEERING PASS

Both sides independently implemented the **same underlying design change**
(MCQ tutors approve/reject answer choices alongside question review, instead
of a separate post-approval `tutor_answer` fan-out stage) — but at different
levels of completeness, and comparing them surfaced a real latent bug.

- `codex`: inline validation, and **correctly removes** the now-redundant
  `tutor_answer` fan-out block from `advanceWorkflow` (the block that used to
  spin up 4-choices × 2-tutors follow-up assignments after reader approval).
- `claude/cramapple-grading-experiments-9lkjqc`: imports validation from a
  new shared `./review-payload.ts` module (`hasExactChoiceKeys`,
  `normalizeAnswerApprovals`, `requiresTutorNote`, `resolveTutorScore`),
  adds an `assignment_locked` (409) concurrency guard, requires a tutor note
  on revision/rejection, and relies on a DB trigger to atomically mark the
  assignment submitted instead of a separate update call — materially more
  defensive. **But it never removes the old `tutor_answer` fan-out block.**
  Landed as-is, this branch would collect `answer_approvals` at the
  `tutor_question` stage *and* still spin up a redundant, now-orphaned
  `tutor_answer` review stage afterward — a real bug, caught only by
  comparing the two branches against each other.

**Resolution direction (not yet coded):** base = experiments-branch's
version (stronger validation, locking, atomicity) + graft in codex's removal
of the `advanceWorkflow` `tutor_answer` fan-out block. This is a genuine
logic splice inside a single function (`advanceWorkflow`'s `isApprove` /
`reviewKind === "mcq"` branch), not a mechanical line-append — flagged for a
dedicated implementation + test pass rather than done blind here.

**Dependency:** the `assignment_locked` trigger requires migrations
`20260721143031_lock_content_review_submission.sql` and
`20260721172940_enforce_content_review_qualification.sql` (both on the
experiments branch, not on `main`) to land first.

**Test needed:** a focused case asserting that approving an MCQ's
`tutor_question` review with `answer_approvals` present does **not** create
any `tutor_answer`-stage `content_review_assignments` rows (regression test
for the exact bug found above).

### 5. `supabase/functions/review-queue/index.ts` — NEEDS ONE DECISION, then land

Both sides independently built the same feature (admin "CC mode": see all
pending review assignments, not just the caller's own) — `experiments`'s
version is a strict superset of `codex`'s and fixes a real production-scale
bug on top:

- `codex`: minimal implementation, filters by an `OPEN_STATUSES` set
  (`assigned`, `pending`, `opened`, `in_progress`).
- `experiments`: same feature, plus (a) **chunks every `.in()` query** at 150
  IDs — necessary because admin CC mode was hitting 711 pending assignments
  and blowing past the PostgREST/gateway request-size limit with an
  undifferentiated 500 error; (b) reviewer name/role attribution for CC-mode
  cards; (c) signed stimulus-image URLs; (d) a heuristic soft-flag for
  likely-missing stimulus images; (e) correctly sources `frq_form` from
  `content_items` (both branches independently found and fixed this same
  schema misplacement).

**Resolution:** adopt `experiments`-branch's version as base — it is more
complete and fixes a real bug codex's version doesn't address.

**One open discrepancy needing a decision, not a guess:** `codex`'s
`OPEN_STATUSES` includes `assigned` and `opened` as queueable states;
`experiments`'s own-queue filter only checks `["pending", "in_progress"]`
(its admin-CC-mode filter only checks `"pending"`). If `assigned`/`opened`
are real, reachable values in the `content_review_assignments.status`
column, adopting `experiments`'s version as-is would silently stop surfacing
those assignments in reviewers' queues. **Needs a check against the actual
column's use (schema/data), not a guess, before landing.**

---

## Append-only logs (3) — SCOPED, NOT YET EXECUTED (large, mechanical)

`docs/activity_log/ACTIVITY_LOG.md` (+474 to +564 lines across 4 sources),
`APPROVALS_LOG.md` (+21 to +358 across 2 sources), `DECISIONS_LOG.md` (+44 to
+460 across 2 sources). Per Codex's instruction, these require append-only
reconciliation — never picking one whole-file winner. Correct method:
extract every dated entry from every source, dedupe by date+content, sort
chronologically, append after `main`'s current tail.

**This is real, voluminous work (~1,500+ lines of entries to dedupe across 3
files) that was not attempted in this pass** to avoid rushing a governance
audit trail. Recommend a dedicated pass (mechanical — good candidate for a
script that extracts dated `##`/`###` entry blocks and diffs by content hash
rather than a manual line-by-line read).

---

## Remaining 15 conflicts — mixed

Quick real diffs done on 7 of the 15; the pattern that emerged is important:
**most of these are non-overlapping parallel edits from concurrent work
streams, not genuine disagreements** — composable by simple append, same
shape as the admin-content case above but at the doc level.

- **`docs/MASTER_TODO.md`** — compose: PR #38 updates the `TASK-0010`/`NOW-013`
  status row; codex adds a new `TASK-0017` row. Different rows, no overlap.
- **`docs/README.md`** — compose is trivial: codex's version is already a
  strict superset (includes the identical `legacy/` line-6 edit the recovery
  branch also made, plus a `research/` bullet the recovery branch lacks).
  Adopt codex's version; recovery contributes nothing not already in it.
- **`docs/tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`** — compose:
  PR #38 updates frontmatter (Owner/Status/Approved Date) and adds a
  conflict-of-interest note to Phase 2; codex adds a new "Adopted Grading
  Standard (DECISION-0034)" section. No overlapping lines.
- **`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`** — **NOT a mechanical
  compose.** Both sides edited the *same* Phase 4/5/6 status cells with
  *different factual claims* about project state (codex: Phase 5 "already
  fully implemented"; recovery: Phase 5 "still blocked on Phase 4 content" —
  these directly contradict). This needs reconciliation against actual
  current state, not either stale narrative — and per existing project
  memory (`project_task0013_status.md`), the real current state (36/48
  Phase-4 items published, Phase 5 built but unpublished, DECISION-0033) is
  already more current than either branch version. Recommend: rewrite this
  section from the current authoritative state rather than merging two
  stale accounts.
- **`docs/research/MCQ_ANSWER_LENGTH_PARITY_QA_2026_07_21.md`** — **not
  actually a cross-branch conflict.** Both flagged rows are the *same*
  branch (`claude/cramapple-grading-experiments-9lkjqc`, committed vs. its
  own dirty-checkout layer) — just this session's further edits on top of
  its own prior commit. Trivial: take the current (dirty-checkout) version.
- **`prompts/LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md`** — **genuine
  conflict of intent, not a merge.** `codex` deletes this file outright (-39
  lines, 0 additions); `claude/cramapple-grading-experiments-9lkjqc` modifies
  and keeps it (+11 lines). One side wants it gone, one wants it expanded.
  **This needs an explicit decision** (presumably David's, since it's a
  product/process call, not a technical one) — not something to resolve by
  picking a side.
- **`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`** — 3-way
  (codex +190/-8, recovery +29/-0, and this session's own dirty-checkout
  layer also touches it — the scatterplot residual-pattern guardrail added
  2026-07-24). Largest of the doc conflicts; not yet diffed in full. Likely
  composable given the pattern above, but deserves its own careful read
  rather than the quick pass given to the smaller docs — **not done in this
  pass.**

**Not yet examined at all (8 of 15):** the `docs/research/` evidence-corpus
conflicts (`ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json`,
`ap_statistics_graph_response_seed_2026_07_02/README.md`,
`ap_statistics_phase_c_publish_staging_2026_07_11/approval_packet.md` +
`bulk_import_payload.json`, `hand_drawn_graph_benchmark_2026_06_30/benchmark_manifest.csv`,
`statistics_phase_b_2026_07_08/statistics_item_keys.json`,
`scripts/evaluate_hand_drawn_graph_benchmark.py`,
`scripts/vercel-gateway-check/hand_drawn_graph_benchmark_run.mjs`). All show
`main_equivalence: absent` on both sides in the manifest — i.e. two branches
independently built evidence artifacts main has neither of. These are likely
near-duplicate corpora from parallel research sessions rather than
line-mergeable text; each needs a content-level "is this the same data or
different" check before deciding whether to land one, land both under
differentiated names, or pick the more complete one. **Not started.**

---

## Summary

| item | status |
|---|---|
| statistics-verifier.ts | resolved, ready to land |
| evaluate-attempt | resolved, blocked on migration landing first |
| admin-content | composite built, needs typecheck/test pass before landing |
| review-decision | direction identified, needs dedicated implementation + regression test |
| review-queue | needs one schema/data check (assigned/opened statuses), then land experiments' version |
| 3 append-only logs | scoped, not executed — recommend a dedicated dedup pass |
| MASTER_TODO / README / TASK-0010 | compose, straightforward |
| TASK-0013 | needs rewrite from current authoritative state, not a merge |
| MCQ_ANSWER_LENGTH_PARITY_QA doc | not a real conflict — trivial |
| LOVABLE_TUTOR_READER prompt | genuine delete-vs-keep conflict — needs a product decision |
| CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md | not yet reconciled |
| 7 evidence-corpus files | not yet examined |

**9 of 23 conflicts have a concrete resolution direction in this pass** (2
fully resolved and ready, 1 composite built pending verification, 3 more
compose-pattern docs identified, 1 correctly identified as *not* a real
conflict, 1 flagged as needing a product decision, 1 flagged as needing a
rewrite-from-current-state rather than a merge). The remaining 14 (3 logs +
3 not-yet-diffed docs + 7 evidence corpora + 1 architecture doc) are scoped
but not yet executed.

This ledger is not a landing authorization. Nothing here is approved. Next
steps per the agreed sequence: complete the remaining conflict analysis,
triage the 238 ambiguous rows, then bring all of this — plus the 26 pending
dispositions — to David for explicit decisions before any durable approval
is drafted.
