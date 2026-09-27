# Codex QA Task — Readiness Audit: Work-Order Accuracy & Live Selector Validation (2026-09-25)

**Why this task is separate.** A reviewer of the canonical-answer QA task (see
`docs/content/CODEX_QA_TASK_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md`) correctly flagged
that a single "content readiness" task trying to cover both (a) deep canonical-answer correctness review
of 372 items and (b) broader readiness-state validation would be unwieldy, and that the two are different
enough in method (independent problem re-derivation vs. live system calls and doc-vs-Production diffing)
that combining them invites both being done shallowly. This task is (b): it does NOT re-derive any
canonical answer's correctness — that is the other task's job. This task validates whether the *session's
broader readiness claims* — the six-criteria measurements written into each not-yet-run work order, and
the six-criteria tracking table in `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` — still match what
Production and the live serving selectors actually say, today.

**Context.** Between 2026-09-24 and 2026-09-25, Claude measured and/or wrote not-yet-executed Codex work
orders for nine subjects' launch readiness (AP Calculus AB, AP Chemistry, AP Physics 2, AP Physics C:
Mechanics, AP Physics C: E&M, AP Statistics, AP Physics 1, AP Precalculus, AP Calculus BC), and
separately closed criterion 4 (canonical answers) directly for seven of those nine. That means five of
the existing work orders (Physics 2, Physics C: Mechanics, Physics C: E&M, AP Statistics, AP Physics 1)
are now **known-stale on criterion 4 specifically** — their "current measured state" tables still show
canonical-answer gaps that this week's authoring work already closed. That specific staleness is expected
and does not need re-discovering. What this task actually checks is whether every *other* number in each
work order — labels, difficulty, item/MCQ counts, exam-pack-version state — is still accurate, and
whether the live serving path actually behaves the way those numbers imply it should.

Proposal/report only — no Production writes, no work-order edits, no gap-closing.

Paste the block below into Codex.

```text
QA task — readiness audit, work-order accuracy and live selector validation, 2026-09-25.

Merge main first:

    git fetch origin
    git switch codex/qa-readiness-audit-work-orders-selectors-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-readiness-audit-work-orders-selectors-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL and read-only edge function/RPC calls only, report findings as a
doc, no writes, no work-order edits, no gap-closing.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria, how to measure each one, and the
  "How to measure, not assume" section -- this task exists specifically to enforce that section's
  discipline: call the real serving RPCs, don't model what they should return)
- docs/content/CODEX_QA_TASK_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md (the sibling
  canonical-answer QA task -- read it to understand the scope boundary; do not duplicate its Part A/E/F)
- Every not-yet-executed work order for the nine subjects in scope:
  prompts/CODEX_WORK_ORDER_AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_PHYSICS_2_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_PHYSICS_C_EM_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_PHYSICS_C_MECHANICS_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md
  prompts/CODEX_WORK_ORDER_AP_STATISTICS_LAUNCH_READINESS_2026_09_24.md
  prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md (labels only, for Physics C:
  Mechanics and Calc BC -- read for its stated baseline even though it's a relabel order, not a full
  readiness order)
- docs/content/CLAUDE_QA_REPORT_AP_STATISTICS_AND_PHYSICS_1_2026_09_25.md (Claude's own prior read-only
  measurement pass on Statistics/Physics 1 -- useful as a second data point on what "measured, not
  assumed" looks like for those two subjects)

PART A -- WORK ORDER ACCURACY, ALL NINE SUBJECTS

For each of the nine subjects listed above, independently re-measure ALL SIX servability criteria
directly against Production (do not copy any doc's stated numbers) and diff against what that subject's
work order currently states as its baseline:

1. Criterion 1 (reviewed/approved): item-level AND current-version-level status counts -- these are
   different facts (see SUBJECT_SERVABILITY_CRITERIA.md); confirm the work order used the right one.
2. Criterion 2 (rubric/MCQ correctness): every FRQ has >=1 frq_criteria row; every MCQ has exactly one
   is_correct choice.
3. Criterion 3 (serving labels): validated/non-validated counts.
4. Criterion 4 (canonical answer): for the five known-stale work orders (Physics 2, Physics C:
   Mechanics, Physics C: E&M, AP Statistics, AP Physics 1), simply confirm this criterion is now closed
   per the canonical-answer QA task's findings (cross-reference, don't re-derive correctness yourself --
   that task owns correctness). For AP Calculus BC and AP Precalculus, confirm the work order's stated
   canonical-answer gap is still accurate as of today.
5. Criterion 5 (difficulty): row counts in app.content_item_difficulty.
6. Criterion 6 (exam pack version): exactly one published, non-retired version, with AP Statistics as
   the sole known exception (confirm it is still exactly the documented two-version state, no change).

For every number that has drifted from what the work order states (other than the five subjects'
expected criterion-4 staleness), report it explicitly: which criterion, what the work order says, what
Production actually shows today, and whether that drift makes the work order's proposed task materially
wrong (e.g., a work order that plans to relabel N items when the actual non-validated count is now
different) or just numerically stale (doesn't change what needs doing, just the stated count).

PART B -- LIVE SELECTOR VALIDATION (not modeled, not assumed -- actually called)

For each of the nine subjects, call the actual serving selector(s) directly:
- public.select_practice_frqs
- app.select_unit_gated_practice_items (if the subject is on the unit-gated path -- confirm which path
  each subject is actually on before assuming; see docs/product/SUBJECT_SERVABILITY_CRITERIA.md and any
  serving-path-topology doc for the two-path split)
- Any subject-specific selector RPC, if one exists (check for it, don't assume there isn't one)

For each call: record the exact item count and content_keys returned, and compare that against what the
six-criteria measurements in Part A imply should be servable. If a selector returns fewer items than the
criteria imply are servable, or zero items where the criteria imply servability, do not just note the
number -- identify which specific criterion is actually gating the shortfall (wrong exam-pack-version
routing, a missing label, a null canonical answer, something else). An empty or short result needs a
named reason, not just a count -- this is the same discipline that caught a prior serving-reports-absence-
as-normality failure elsewhere in this codebase, and it applies here too.

PART C -- EXAM-PACK-VERSION SINGULARITY, PLATFORM-WIDE (not just these nine subjects)

Query app.exam_pack_versions across the ENTIRE platform (every exam_pack, not just the nine subjects in
this task's scope) for count of published, non-retired versions per exam_pack. Confirm AP Statistics is
the only subject with more than one, and that its count and identity (both version_ids) match what is
already documented. Report any other subject found with more than one published, non-retired version as
a new P0 routing hazard -- this check exists specifically because a second published version silently
appearing anywhere is exactly the failure mode Statistics already demonstrated once, and nothing has
actively prevented it from happening again elsewhere.

DELIVERABLE

`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`:

- One section per subject (nine total) with: freshly-measured six-criteria table, a diff table against
  that subject's work order (criterion, work-order value, Production value, drift/stale/match), and a
  one-line verdict on whether the work order needs a numbers update before it should be run.
- A section per subject with the Part B live selector results: exact call made, exact result (count and
  content_keys, or a representative sample if very large), and the named criterion explanation for any
  shortfall versus what Part A implies should be servable.
- A single top-line section on Part C's platform-wide exam-pack-version singularity check, listing every
  exam_pack with more than one published non-retired version -- written so it's visible without reading
  the rest of the report, since a newly-found second published version anywhere is a P0.
- A summary table across all nine subjects: criteria drifted (count), selector-vs-criteria mismatches
  (count), work orders needing a numbers refresh before execution (yes/no).

WHAT WOULD MAKE THIS REJECTED

- Re-deriving canonical-answer correctness for any item -- that is the sibling task's job, not this
  one's.
- Reporting Part A's six-criteria numbers by copying SUBJECT_SERVABILITY_CRITERIA.md's or a work
  order's stated table instead of independently re-querying Production.
- Treating Part B as satisfied by reasoning from the six-criteria data about what a selector "should"
  return, instead of actually calling the selector and recording its real output.
- Reporting a selector shortfall as just a number without identifying which specific criterion is
  gating it.
- Scoping Part C to only the nine subjects in this task instead of the whole platform.
- Proposing fixes, closing gaps, or editing any work order file -- this is a report-only audit.
- Any Production write.
```
