# Grading Branch Consolidation — Resolution Ledger (2026-07-27)

Tied to the classification manifest merged in [PR #58](https://github.com/david-bloom/Cramapple/pull/58),
commit `b1733e10bbf6e43c4b1a251bdb536a9ce6d34550` on `main`
(`docs/research/grading_branch_consolidation_manifest_2026_07_26/manifest.csv`).

This ledger reconciles all 23 `cross-branch-conflict` paths from that
manifest. Current `main` is treated as base; every branch version is
evidence, not a candidate to simply "pick." Composites are proposed where
mechanical and safe. Where reconciliation needs engineering judgment, a
schema/data check, or a product decision, that is stated explicitly.

**Status: proposed analysis, still not approved.** Nothing here has been
merged to `main`, no migration has been applied, no source branch has been
touched, and no disposition or discard has been approved. This PR stays
draft until every path below is either resolved or explicitly handed to
David for a decision, per review feedback on the first version of this
ledger.

## Corrections from the first version of this ledger

A review pass caught one factual error and two incomplete dependency/test
claims, corrected below:

1. **`LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md` is not delete-vs-keep.**
   The first version of this ledger claimed the codex branch deletes this
   file outright. It does not — `git cat-file -e` confirms the file exists
   on that branch; the diff is a 39-line *removal of one section* ("Backend
   Contract") within the file, not a file deletion. Re-examined: that
   section described the curated `public.*` interface, which had real
   column-reference bugs found by QA on 2026-07-09 and fixed the same day
   (see the PASS re-QA note in the history of that same commit); the
   section's removal from this prompt doc, 5 days later, reads as a
   documentation-consolidation move (the same commit added
   `PHASE1_CURATED_INTERFACE_NOTES.md` and several other architecture docs
   covering this content), not an abandonment of the curated interface —
   its migrations are still part of the same branch. **No product-level
   keep/delete decision is required; this composes.**
2. **`admin-content`'s dependency set was incomplete.** In addition to
   `publication-request.ts` and `content-preflight.ts` already named, the
   atomic publication path also requires (all confirmed present on
   `codex/five-subject-harness-and-content`): `supabase/migrations/202607130001_atomic_content_publication.sql`,
   `supabase/functions/admin-content/publication-request_test.ts`, and
   `supabase/functions/_shared/content-preflight_test.ts`.
3. **`statistics-verifier.ts` and `evaluate-attempt` were marked "ready to
   land" / "resolved" — downgraded.** Checked directly: `codex`'s existing
   `statistics-verifier_test.ts` exercises `APSTAT-MOD3-H001-INV` /
   `APSTAT-MOD6-H001`, but every case includes a numeric SE approximation
   in the response text (e.g. "SE = 120/√30 = 21.9") — none test the exact
   bug PR #38 fixes (a response with *only* the symbolic form, no decimal
   value at all). PR #38 itself doesn't have this test file. **No existing
   test proves the fix.** Same issue for `evaluate-attempt`:
   `growth-events_test.ts` exists but doesn't test the ownership-replay
   check (`existingAttempt.user_id` gate) — confirmed by grep, no match
   anywhere. Both downgraded from "resolved" to "resolution selected,
   needs a regression test before landing."
4. **Bookkeeping fixed.** The previous version's summary said 7 evidence
   files were unexamined; the actual count was 8. All 8 have now been
   examined (see table below) — some fully resolved, some still needing a
   decision, none left unlooked-at.

---

## Per-path summary table

All 23 conflicts. "Owner" is who makes the remaining call — "none" means
the path is mechanically resolved and just needs the composite/merge
applied; a name means a real decision is still open.

| # | Path | Sources (blob) | Status | Dependencies | Required validation | Lane | Owner |
|---|---|---|---|---|---|---|---|
| 1 | `docs/MASTER_TODO.md` | mlr0o1 `59a2248b9eb6` · codex `eaaf9981e542` | **Resolved — compose** (non-overlapping rows) | none | none | governance-history | none |
| 2 | `docs/README.md` | codex `b51a9f03abbd` · recovery `ce650b7b28d8` | **Resolved — adopt codex** (strict superset of recovery) | none | none | governance-history | none |
| 3 | `docs/activity_log/ACTIVITY_LOG.md` | 5 sources, see manifest | **Resolved direction — append-only merge**; 24 new entries identified, 0 id-conflicts (title/date-keyed) | none | manual scan of merged draft (`logs_reconciliation/ACTIVITY_LOG.md.merged.proposed.md`); update the Index section | governance-history | David (sign-off on audit-log content, standard practice) |
| 4 | `docs/activity_log/APPROVALS_LOG.md` | mlr0o1 `73efb0bf3098` · codex `146540c6e838` | **Blocked — real ID collision.** `APPROVAL-0026`/`0027` mean different things on `main` vs. `codex` (codex forked before those numbers were assigned on `main`'s timeline) | must renumber codex's colliding entries to next free IDs (`0028`+) before appending | verify no other doc cross-references codex's old `APPROVAL-0026`/`0027` numbers | governance-history | **David** (approval numbering is his authority) |
| 5 | `docs/activity_log/DECISIONS_LOG.md` | mlr0o1 `192a0414d8af` · codex `5f5b9fd09f09` | **Blocked — real ID collision.** `DECISION-0035`/`0036`/`0039` mean different things on `main` vs. `codex` — `DECISION-0039` is "Adopt Branch Hygiene Rules" on `main`, "TASK-0017 P0 Publication Repair" on codex | must renumber codex's colliding entries to next free IDs (`0040`+) before appending | verify no other doc cross-references codex's old numbers | governance-history | **David** |
| 6 | `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` | codex `1cb40c49e291` · recovery `16a29dafb42e` · worktree `e906212e5e2e` | **Resolved direction — compose.** codex's "5.1 Platform vs. Subject-Specific" section is byte-identical to recovery's only hunk — recovery contributes nothing unique. This session's own dirty-checkout adds a separate, non-overlapping scatterplot-guardrail section (§ near line 247) | none | verify the worktree insertion point doesn't collide with codex's third hunk (lines ~240-380) at actual splice time | governance-history | none, pending splice verification |
| 7 | `docs/research/MCQ_ANSWER_LENGTH_PARITY_QA_2026_07_21.md` | experiments (committed) `b3e63b052844` · WORKTREE `a5e4dc06b953` | **Not a real conflict** — both rows are the same branch (committed vs. its own dirty layer) | none | none | grading-evidence | none |
| 8 | `docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` | mlr0o1 `3ce1b151e2d2` · codex `38f7f5a08fc2` | **Resolved — not a real conflict.** Diff is entirely `±`/`√`-style JSON Unicode escapes (mlr0o1) vs. literal `±`/`√` characters (codex) — same semantic content, different serializer | none | none | grading-evidence | none |
| 9 | `docs/research/ap_statistics_graph_response_seed_2026_07_02/README.md` | codex `5816a0776976` · recovery `8064aec2f7e2` | **Resolved — adopt codex.** codex's 131-line version is a superset of recovery's 40-line version, plus documents a real QA finding (an outlier-rule miscall in item `GRAPH-010`, independently recomputed and fixed) that recovery's version lacks entirely | none | none | grading-evidence | none |
| 10 | `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/approval_packet.md` | mlr0o1 `ebd563519bd8` · codex `1cd5279ff780` | **Real conflict** — difficulty-distribution counts differ (hard 44/medium 35/very_hard 6 vs. hard 40/medium 30/very_hard 15) for what should be the same batch | none | confirm which distribution reflects the actual current classification of the batch | grading-evidence | **Orly** (curriculum/content classification) |
| 11 | `docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/bulk_import_payload.json` | mlr0o1 `87dbd7480cb9` · codex `ee823ff0eeef` | **Real conflict** — `APSTAT-MOD4-M004` has two different authored stems/rubrics (specific vs. generic scatterplot description) under the same content_key | none | determine which authored version is the intended final content | grading-evidence | **Orly** |
| 12 | `docs/research/hand_drawn_graph_benchmark_2026_06_30/benchmark_manifest.csv` | codex `e0fb9f552f6a` · recovery `1e88afc98e62` | **Resolved — trivial.** Single-line diff is whitespace/trailing-newline only, same data | none | none | grading-evidence | none |
| 13 | `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json` | mlr0o1 `32346239c72e` · codex `91be343b3440` (= WORKTREE) | **Real content-correctness conflict, codex's version is more honest.** The item text says "sample standard deviation," but the authored rubric/canonical answer actually use the **population** SD formula (7.07, not the sample-SD 7.91 mlr0o1 silently computes). codex's version keeps the flawed rubric's value *and* adds an explicit comment flagging the item/rubric mismatch for content review, rather than silently "fixing" it | none | content team must decide: fix the item wording to say "population," or fix the rubric/canonical answer to expect sample SD | grading-evidence | **Orly** (content correctness call) |
| 14 | `docs/tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md` | mlr0o1 `8bcf5be8f61d` · codex `e281f73025b7` | **Resolved — compose** (non-overlapping: mlr0o1 updates frontmatter + adds a conflict-of-interest note; codex adds a new DECISION-0034 standards section) | none | none | governance-history | none |
| 15 | `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` | codex `9158275e6c6e` · recovery `b58299c7a093` | **Not mechanically mergeable** — both sides assert contradictory facts about Phase 5/6 status. Per existing project memory, the real current state (36/48 Phase-4 items published, Phase 5 built but unpublished, DECISION-0033) is more current than either branch's account | none | rewrite this section from current authoritative state, not a merge of two stale narratives | governance-history | **David** (or whoever owns task-doc accuracy) |
| 16 | `prompts/LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md` | codex `1168c38083be` · experiments `8a22470b97f4` | **Resolved direction — compose** (see Correction #1 above: not delete-vs-keep). codex removes a stale/superseded Backend Contract section; experiments adds unrelated `answer_approvals`/locking notes. Non-overlapping | none | none | content-CED | none |
| 17 | `scripts/evaluate_hand_drawn_graph_benchmark.py` | codex `b0dcfa5eb2a3` · recovery `dc78796f946b` | **Small real behavior difference** — one version upper-cases status-map keys, one doesn't | none | quick check: do callers compare these keys case-sensitively against upper-case constants elsewhere in the script | grading-evidence | none, pending a quick technical check |
| 18 | `scripts/vercel-gateway-check/hand_drawn_graph_benchmark_run.mjs` | codex `7a4ce704dc50` · recovery `a779e2a13928` | **Not fully examined.** codex's version removes several helper functions (`loadJson`, `loadCriterionContract`, `criterionIdsFromRow`, `loadCorpusItemMap`, `loadBenchmarkRecords`) present in recovery's version | none | dedicated read needed: confirm codex's simplification doesn't silently drop capability, or that it's reimplemented elsewhere | grading-evidence | none, pending review |
| 19 | `supabase/functions/_shared/statistics-verifier.ts` | mlr0o1 `20ff1f4b4d63` · codex `f7ef08aef9c0` (= main) | **Resolution selected, not ready to land.** Adopt mlr0o1's fix (removes 2 over-strict SE checks, dated/reasoned). No existing test proves the exact symbolic-only-SE scenario now passes | none | **write a regression test** with a response that never states a decimal SE value, asserting `pass` | capability | none, needs test written |
| 20 | `supabase/functions/admin-content/index.ts` | codex `6249e678be68` · experiments `e119928d96b2` | **Composite built** (`composites/admin-content.index.ts.proposed`), diff-verified against both parents | `202607130001_atomic_content_publication.sql`, `publication-request.ts` + `_test.ts`, `content-preflight.ts` + `_test.ts` (all codex), `mcq-quality.ts` + `_test.ts` (experiments/`a654276`) | typecheck the composite; run/extend `mcq-quality_test.ts` and `publication-request_test.ts` against it | capability | none, needs test execution |
| 21 | `supabase/functions/evaluate-attempt/index.ts` | codex `4f002646aa11` (= main) · experiments `6d6fbbd0bbcc` | **Resolution selected, not ready to land.** Adopt experiments' security fix (ownership-replay check + entitlement gate) | `20260720122542_free_score_check_growth_funnel.sql`, `_shared/growth-events.ts` + `_test.ts`, `free-score-check/index.ts` | **write a dedicated ownership-replay regression test** — none exists | capability | none, needs test written |
| 22 | `supabase/functions/review-decision/index.ts` | codex `ed9751eb966e` · experiments `be9f8077d7f8` | **Direction identified, needs dedicated implementation.** Base = experiments (stronger validation/locking); graft in codex's removal of the now-redundant `tutor_answer` fan-out in `advanceWorkflow` — experiments' version left that dead/buggy code path in place | `20260721143031_lock_content_review_submission.sql`, `20260721172940_enforce_content_review_qualification.sql` | write a regression test asserting no `tutor_answer`-stage assignment rows are created when `answer_approvals` is submitted at `tutor_question` | capability | none (technical), significant follow-up engineering |
| 23 | `supabase/functions/review-queue/index.ts` | codex `a28015758ab6` · experiments `a57376d63ed9` | **Resolved direction, one open question.** Adopt experiments' version (strict superset, fixes a real production-scale bug: unchunked `.in()` queries failing past 711 pending assignments) | none | confirm whether `assigned`/`opened` are live values of `content_review_assignments.status` — codex's `OPEN_STATUSES` includes them, experiments' filter doesn't | capability | **schema/data check** (technical, but worth a name — flag to whoever owns that table) |

---

## Append-only log reconciliation (paths 3-5)

Reproducible script: `scripts/branch_consolidation/reconcile_append_only_logs.py`.
For each log, parses `main` and every conflicting source into individual
entries (keyed by `APPROVAL-NNNN`/`DECISION-NNNN` id for the two ID-based
logs, by exact header text for `ACTIVITY_LOG`), finds entries missing from
`main`, flags any id/title reused for different content, and produces a
merged draft — never picks one whole-file winner.

Output: `logs_reconciliation/*.merged.proposed.md` (one per file) and
`logs_reconciliation/append_only_reconciliation_report.json` (machine-readable).

| file | main entries | new entries found | id/title conflicts |
|---|---|---|---|
| `ACTIVITY_LOG.md` | 49 | 24 | 0 |
| `APPROVALS_LOG.md` | 28 | 11 | **2** (`APPROVAL-0026`, `APPROVAL-0027`) |
| `DECISIONS_LOG.md` | 36 | 8 | **3** (`DECISION-0035`, `DECISION-0036`, `DECISION-0039`) |

The 5 id/title conflicts are a genuine governance finding, not a script
bug: `codex/five-subject-harness-and-content` forked before several of
these numbers were assigned their current meaning on `main`'s timeline,
and independently incremented its own approval/decision counter starting
from the same base. Appending codex's entries under their original numbers
would silently shadow real, already-referenced decisions (e.g. `main`'s
`DECISION-0039` — branch hygiene — is referenced by this very consolidation
effort's own governance). **These 5 entries must be renumbered to the next
free ID on each log before merging**, which is a numbering decision for
David, not something this script should do automatically.

The merged drafts do not yet reflect that renumbering — they're generated
as-is (by id, as authored) so the collision is visible in the diff. The
`## Index` section in every version is excluded from entry-level comparison
(every branch has its own curated index, which isn't a "conflict," just a
different summary of the same log) — each log's Index needs a manual
update once the new entries are actually appended.

---

## Summary

**8 of 23 fully resolved** (mechanical compose or "not actually a
conflict," no further input needed): `MASTER_TODO.md`, `README.md`,
`MCQ_ANSWER_LENGTH_PARITY_QA` doc, `provisional_labels.json`,
`graph_response_seed/README.md`, `benchmark_manifest.csv`, `TASK-0010` doc,
`LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md`.

**8 need dedicated engineering follow-up** (direction identified, no
product decision required, but real implementation/test work remains):
`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` (splice verification),
`statistics-verifier.ts` (write test), `admin-content` (typecheck + test),
`evaluate-attempt` (write test), `review-decision` (implement + test),
`review-queue` (schema check), `evaluate_hand_drawn_graph_benchmark.py`
(quick check), `hand_drawn_graph_benchmark_run.mjs` (dedicated read still
needed).

**6 need an explicit product/content decision**, named above: `APPROVALS_LOG.md`
and `DECISIONS_LOG.md` (ID renumbering — David), `approval_packet.md` and
`bulk_import_payload.json` and `statistics_item_keys.json` (content
correctness — Orly), `TASK-0013-AP-STATISTICS-LAUNCH.md` (rewrite from
current state — David).

**1 (`ACTIVITY_LOG.md`) is a mechanical append-only merge** with no id
conflicts, but still warrants David's sign-off since it's the audit trail.

This ledger is not a landing authorization. Next steps per the agreed
sequence: triage the 238 ambiguous rows, then bring the 6 decision items
above — plus the 26 pending dispositions from the manifest — to David
together, before any durable approval is drafted.
