# TASK-0013 — AP Statistics Launch (Subject 2)

**Task ID:** TASK-0013
**Title:** Expand Cramapple to AP Statistics as the second subject
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-06-30
**Approved Date:** 2026-06-30

## Product Goal

Launch AP Statistics as Cramapple's second subject, reusing the multi-subject
logical model already designed in
`docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6 and the
`app.subjects` schema normalization
(`supabase/migrations/202606230002_subjects_normalization.sql`), while closing
the gap between that design and the AP-Biology-only shortcuts currently in the
grading and verification code.

AP Statistics was selected over AP Calculus AB, AP English Literature, and AP
World History because its FRQs are criterion/rubric-scored with quantitative
thresholds — the same scoring shape as AP Biology's FRQ criterion contracts —
and because it shares a curriculum owner (Orly) with AP Biology, avoiding a
new content-ownership relationship at the same time as a new subject.

## Technical Scope

1. **Grading/prompt generalization (blocks any second subject, do first).**
   De-hardcode the "AP Biology" literals in `grade-frq` and `evaluate-attempt`
   and wire grading prompt composition to `subject_id` /
   `taxonomy_scheme_id` via the prompt-build manifest already specified in
   `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5, instead of inventing a
   parallel path.
2. **Net-new verification technique.** AP Statistics FRQ criteria need
   deterministic calculation checks (e.g., verifying a computed test
   statistic, p-value, or confidence interval against the student's stated
   work) — a verification technique named in §7 but not yet built for any
   subject. The hand-drawn-graph grading work from TASK-0011 was built for
   Biology's graph-construction FRQs and is not assumed to transfer; Stats
   FRQs more often require typed numeric/calculation responses than freehand
   sketches, so this needs its own scoping pass before assuming reuse.
3. **Schema/content instantiation.** Insert an `AP Statistics` row into
   `app.subjects`; create an `exam_pack` version and a new `taxonomy_scheme`
   for AP Statistics (units, practices, task types) — distinct from Biology's
   scheme per §6 ("a single generalized list is insufficient").
4. **Content authoring.** A pilot content batch (not the full Biology-scale
   30 long FRQ / 100 short FRQ / 100 MCQ) authored under the existing
   governance rules in `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` and
   `CONTENT_GOVERNANCE_AND_VALIDATION.md` — no official College Board
   questions or scoring material as model input, same originality/rights
   gates as Biology.
5. **Frontend/UX.** Subject selection and AP Statistics practice/assessment
   routes. Scope and input UI (e.g., typed numeric/calculation entry vs the
   freehand canvas built for Biology graphs) to be defined once Phase 1
   confirms what the grader actually needs from the student response.
6. **Calibration.** A scaled-down version of the SP-1 calibration protocol
   (`docs/research/grader_speed_sp1_report.md`) against an AP Statistics gold
   set, using the subject-agnostic reviewer tables already live
   (`content_review_assignments`, `content_review_decisions`) — but a new,
   Stats-credentialed tutor pool, since the current reviewers are
   Biology-credentialed.

## Out of Scope

- Any other AP subject (Calculus AB, English Lit, World History) — this task
  is AP Statistics only.
- Full Biology-scale content volume for the pilot batch.
- Production deployment or public launch — those are separate Hard Gates
  under `STANDING_APPROVAL_LANES.md` Lane 3 and are not pre-authorized by
  approval of this task.
- Pricing, bundling, or marketing sequencing decisions (the SEO phased plan
  already lists AP Statistics as a Phase 2 candidate in
  `docs/proposals/2026-06-23-codex-phased-plan.md`, but that's a separate
  workstream from this task).

## Routes / Components / Systems Affected

- `supabase/functions/grade-frq/index.ts`,
  `supabase/functions/evaluate-attempt/index.ts` (prompt generalization)
- `app.subjects`, `app.exam_packs`, new taxonomy_scheme tables (schema)
- New verification service/module for deterministic calculation checks
- Frontend: subject selector, new AP Statistics routes (Lovable)
- Reviewer/tutor workflow: new Stats-credentialed reviewer accounts

## Data / Security / Integration Impact

- New `app.subjects` row and exam_pack/taxonomy rows — additive schema data,
  not a destructive migration, but still routed through the Database
  Migrations hard gate per `STANDING_APPROVAL_LANES.md`.
- No change to student-data handling, auth, or secrets boundaries.
- Reviewer/tutor onboarding for AP Statistics is a new credentialing decision,
  not just a config change — flagged as a pending owner decision below.

## Acceptance Criteria

- [ ] Grading prompt composition for at least one FRQ task type is
      subject-driven (manifest pulls `subject_id`), not hardcoded to "AP
      Biology," and AP Biology grading output is unchanged (regression-safe).
- [ ] A deterministic calculation-check verifier exists for at least one AP
      Statistics FRQ criterion type and is demonstrated against a test case.
- [ ] `app.subjects` contains an `ap-statistics` row; a versioned exam_pack
      and taxonomy_scheme exist for it.
- [ ] A pilot content batch (size TBD by Orly/David) passes the same
      originality/rights/scientific(statistical)-consistency gates Biology
      content passes.
- [ ] A calibration run against an AP Statistics gold set produces
      documented grader agreement/confidence numbers, not just a "looks
      right" judgment call.
- [ ] Frontend exposes AP Statistics as a selectable subject end-to-end in a
      non-production environment.

## QA Plan

- Manual QA: spot-check AP Biology grading output before/after the
  generalization change to confirm no regression.
- Automated tests: unit tests on the deterministic calculation-check verifier
  against known correct/incorrect statistical work.
- Regression areas: AP Biology grading paths, prompt-build manifest resolution
  for both subjects.
- Failure cases: malformed/partial calculation work, ambiguous notation,
  criterion boundary cases (reuse the boundary-contract pattern from Biology's
  C2 misattribution work where applicable).
- Security/data/integration checks: confirm subject_id is read from the
  immutable question-version the student saw, not re-resolved against a
  later-edited taxonomy (same caveat already on record for MCQ lookup-table
  grading in `[[project_multisubject_grading_strategy]]`).

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved
**Approved By:** David Bloom
**Date:** 2026-06-30
**Recorded:** `DECISION-0031`, `APPROVAL-0024` (`docs/activity_log/DECISIONS_LOG.md`,
`docs/activity_log/APPROVALS_LOG.md`)

**Owner decisions (resolved 2026-06-30):**

1. **Confirmed.** AP Statistics is Subject 2.
2. **Confirmed.** Reuse the existing tutor-authored-base-package content model
   (TASK-0007/0008) under Orly — no new authoring arm for this subject.
3. **Confirmed.** Pilot batch sized and distributed across all 9 AP
   Statistics units (College Board unit numbering), David-provided:

   | Module | MCQs | FRQs |
   |---|---|---|
   | 1 | 15 | 6 |
   | 2 | 5 | 2 |
   | 3 | 10 | 4 |
   | 4 | 6 | 5 |
   | 5 | 5 | 4 |
   | 6 | 10 | 4 |
   | 7 | 10 | 4 |
   | 8 | 5 | 2 |
   | 9 | 5 | 2 |
   | **Total** | **71** | **33** |

   Plus an investigative-task item — form and count **TBD**, separate from the
   table above; needs its own scoping pass before Phase 4 content authoring
   starts (investigative tasks are a distinct AP Statistics task archetype,
   not a long/short FRQ variant, so they need an archetype definition under
   §6/§9 of `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` before Orly can
   author against them). Target date: not yet set — revisit once Orly
   confirms bandwidth alongside ongoing Bio work.
4. **Confirmed.** Existing reviewers can be cross-credentialed across
   subjects, including AP Statistics — no new tutor pool required.
5. **Confirmed.** Same rights posture as AP Biology (no official CollegeBoard
   material as model input or exemplar) — this was already settled policy,
   restated here for the record, not reopened.

**Phase 0 is closed.** Phase 1 is cleared to start —
`prompts/CODEX_AP_STATISTICS_PHASE1_GRADING_GENERALIZATION.md`'s
do-not-execute condition is satisfied.

**Phase 1 status: implemented, awaiting QA.** Executed by Claude (not Codex —
Codex was occupied productionalizing the hand-drawn graph grader at the time;
this is implementation work either actor can do, the delegation table is a
default assignment, not an exclusivity rule). Findings and changes:

- `supabase/functions/evaluate-attempt/index.ts` (the actual production
  grading path — idempotent, budget-capped, prompt-versioned) is now
  subject-driven with **no new manifest infrastructure needed**:
  `app.exam_packs.exam_name` already existed as a per-exam-pack column
  (seeded `'AP Biology'` in `202606200003_seed_ap_biology_exam_pack.sql`) but
  `evaluate-attempt` never selected it, hardcoding the literal instead. Fixed
  by fetching `exam_packs` via `examPackVersion.exam_pack_id` and using
  `exam_name` for both the `examName` prompt field and the system-prompt
  string. Fails loudly (`exam_pack_not_found`, 404) if the row can't be
  resolved, per the original Phase 1 requirement. Zero schema migration
  needed — this was a missing `select` column, not a missing manifest.
- `supabase/functions/grade-frq/index.ts` was **not** changed. It turns out
  to run against a completely different, Biology-only prototype schema
  (`public.questions` from `202606230001_prototype_student_schema.sql`) that
  has no subject concept at all — `unit` is a hard `check (unit between 1 and
  8)` constraint, `science_practice between 1 and 6`, no `subject_id` or
  equivalent linkage anywhere in that table. Swapping its hardcoded prompt
  string alone would be cosmetic, not a real generalization, since there's no
  subject data behind it to drive the swap. True support would require schema
  work on `public.questions` (or retiring it in favor of the `app.*` path
  `evaluate-attempt` already uses) — out of this phase's "no migrations"
  scope and a separate decision (is `public.questions` still meant to be
  live, or is it a superseded prototype?) worth a explicit answer before
  investing in it.
- **Verification:** `deno check` passes on the modified file. No live
  Supabase/Postgres instance is available in this environment (consistent
  with prior sessions' notes in `docs/research/supabase-token-deployment-postmortem.md`),
  so this follows the same verification precedent used for
  `DECISION-0030`'s Edge Function change: type-check plus manual
  cross-reference against the seed data, not a live integration run.
  Cross-reference confirms `exam_packs.exam_name = 'AP Biology'` exactly
  matches the removed literal, so existing AP Biology grading output is
  unchanged. A pre-existing, unrelated `deno fmt` formatting violation at
  line 832 (outside this diff) was left untouched rather than expanding
  scope.
- **Where Phase 2 plugs in:** once an `app.exam_packs` row exists for AP
  Statistics with `exam_name = 'AP Statistics'` and `subject_id` pointing at
  a new `app.subjects` row, `evaluate-attempt` requires no further code
  change to grade it — the exam-pack lookup added in this phase already
  generalizes by data, not by branching logic.

## Implementation Notes — Delegation Plan

Phased so Phase 1 unblocks everything else and nothing downstream starts
before its inputs exist.

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — the 5 pending owner decisions above | **David** | — | **Done** (`DECISION-0031`) |
| 1 | De-hardcode grading prompts; resolve subject from `app.exam_packs` per attempt; regression-test against AP Biology | **Codex** (backend) | Phase 0 approval | **Done, merged** (PR #20) |
| 2 | `app.subjects` row, exam_pack + content_labels for AP Statistics, additive migration | **Codex** (backend), reviewed by **Orly** for label correctness | Phase 1 | **Done, merged** (PR #26) — one QA round found a fatal bug (stale reference to a column dropped by an earlier migration; would have failed to apply), fixed, re-QA Pass |
| 3 | Deterministic calculation-check verifier for Stats FRQ criteria | **Codex** (backend) | Phase 1 | **Done, merged** (PR #24 + follow-up PR #27) — three QA rounds total across both PRs, all ultimately Pass |
| 4 | Pilot content batch (governed authoring, no official material) | **Orly** (curriculum), same governance gates as Biology | Phase 2 | Brief ready (`docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`); execution prompt drafted (`prompts/CODEX_AP_STATISTICS_PHASE4_PILOT_CONTENT_BATCH.md`); smoke batch published live in Production after QA fixup |
| 5 | Subject selector + AP Statistics practice/assessment routes | **Lovable** (frontend) | Phase 2 + 4 (real content to render) | Validated in Lovable; AP Statistics-ready subject-aware onboarding is already fully implemented and no frontend changes are needed right now |
| 6 | Calibration run against AP Statistics gold set; tutor credentialing | **Claude/QA Agent** (protocol) + **David** (tutor pool decision) | Phases 3–4 | Protocol drafted (`docs/research/AP_STATISTICS_PHASE6_CALIBRATION_PROTOCOL.md`) and execution prompt drafted (`prompts/CLAUDE_AP_STATISTICS_PHASE6_CALIBRATION_RUN.md`); execution thread launched, still waiting on real blind tutor-scored data |
| 7 | Launch readiness review (separate Hard Gate — not granted by this task) | **David** | All above | Not started |

Every phase now has a handoff or live artifact in place. Phase 5 is now
validated as already implemented; Phase 6 still needs real blind tutor-scored
data before it can be called fully complete, but the execution packets are no
longer the blocker.

Rule of thumb: Phases 1 and 3 are platform-level capabilities that should
generalize to later subjects; Phases 2 and 4 are subject-specific instantiation
and content; Phase 5 mixes shared platform UI with subject-specific content
once content exists.

A ready-to-fire Codex prompt for Phase 1 is drafted at
`prompts/CODEX_AP_STATISTICS_PHASE1_GRADING_GENERALIZATION.md`, marked
do-not-execute until this task's Approval State changes to Approved.
Phase 4's execution prompt is now drafted at
`prompts/CODEX_AP_STATISTICS_PHASE4_PILOT_CONTENT_BATCH.md` and the smoke
batch has been published live after QA fixup; the Lovable subject-aware
onboarding prompt lives at
`prompts/LOVABLE_AP_STATISTICS_SUBJECT_AWARE_ONBOARDING.md` and Lovable
confirmed the frontend is already implemented; and the Phase 6 calibration
run prompt lives at `prompts/CLAUDE_AP_STATISTICS_PHASE6_CALIBRATION_RUN.md`
and has been launched as a separate execution thread.

**Phase 3 status: implemented as a standalone checker.** Added
`scripts/ap_statistics_calculation_check/checker.py` plus synthetic tests in
`scripts/ap_statistics_calculation_check/test_checker.py`. The assumed input
shape is `expected_answer_spec = {calculation_type, target, tolerance,
comparison?}` with confidence intervals represented as `{lower, upper}`.
The checker returns `matches`, `does_not_match`, or `indeterminate` and is
kept independent of `evaluate-attempt` until the Phase 2/4 data exists to
drive it. Validation: `python3 -m unittest discover -s
scripts/ap_statistics_calculation_check -p 'test_*.py' -v`.

## QA Review

**Phase 1 (PR #20) QA Verdict: Pass** — two independent reviews, no blocking
findings.

- **Claude QA agent** (fresh/independent context, spawned 2026-06-30):
  Pass. Verified the `exam_pack_not_found` guard precedes every use of
  `exam_name`, the diff is surgical (3 hunks, no unrelated files), `deno
  check` passes, the one `deno fmt` violation at line 832 is pre-existing
  and outside the changed hunks, the `public.questions` no-subject-concept
  claim checks out, and the activity-log entries are structurally
  consistent. Non-blocking notes: no live Supabase integration test was
  possible in this environment; `exam_packs.subject` (free-text) and
  `exam_packs.subject_id` (FK) coexist and should be reconciled in Phase 2.
- **Codex** (independent second pass, `prompts/CODEX_TASK0013_PHASE1_QA_REVIEW.md`):
  Pass. No blocking findings.

QA pass is not launch or merge approval — David decides whether PR #20
merges. Remaining task-level work (Phases 2–7) is unaffected by this
verdict; it covers Phase 1 only.

**Phase 3 (PR #24) QA Verdict: Pass, on second round.** First round (fresh
Claude QA agent) found two real, reproduced blocking bugs in the
confidence-interval calculation checker: (1) ambiguity detection silently
picked the wrong CI pair when a response contained more than one (e.g. a
corrected answer after a crossed-out attempt) instead of returning
`indeterminate`; (2) tolerance comparisons had no float-epsilon cushion,
so a value exactly at the boundary could fail due to IEEE imprecision.
Codex remediated both (fail-closed ambiguity rule, epsilon-safe tolerance
helper) with two new regression tests; re-QA (separate fresh agent)
independently re-ran the original adversarial reproduction case plus a
3-pair variant, confirmed both fixes hold, confirmed no regression on the
previously-working single-pair case, and found one new non-blocking
cosmetic gap (diagnostic `reason` text doesn't distinguish 0-claims from
multi-claims for the CI path) — queued as a follow-up, not a blocker.
9/9 tests passing. Demonstrates the value of the two-round QA pattern: the
first round's adversarial verification (not just "tests pass") is what
caught bugs a less skeptical review would have missed.

**Phase 3 follow-up (PR #27) QA Verdict: Pass.** Fixed the diagnostic-text
gap PR #24's re-QA flagged (CI 0-claims vs. multi-claims now produce
distinct `reason`/`detected_claims` output instead of collapsing to the
same generic message). QA independently ran adversarial inputs beyond the
new tests (0, 1, 3, and 4-pair cases), confirmed verdict logic (still
`indeterminate` either way) was genuinely unchanged, and confirmed no
scope creep. One pre-existing (not introduced by this PR) cosmetic note:
the underlying pair-extraction regex can produce near-duplicate candidates
in `detected_claims` at 3+ pairs — harmless, flagged for a future
follow-up, not blocking. 10/10 tests passing.

**Phase 2 (PR #26) QA Verdict: Pass, on second round.** First round found
one fatal, blocking bug: the migration inserted into
`app.exam_packs.subject`, a column dropped six days earlier by
`202606230002_subjects_normalization.sql` — this would have made the
migration fail outright at apply time with "column does not exist." Every
other structural check passed clean on the first round (constraint names,
`draft` status on the new exam_pack_version, valid check-constraint values,
no collision with the AP Biology row, exam date verified correct against
College Board's published 2026 schedule). Fixed by removing the stale
`subject`/`excluded.subject` references and confirming `subject_id` (the FK
that replaced it) was already wired correctly. Re-QA independently
confirmed the column no longer appears anywhere in the file, the on-conflict
SET clause is syntactically valid after the removal, and did a full fresh
read of the file rather than trusting the diff alone.

This is the second QA round in this task to catch a real, would-have-shipped
defect before merge (the first being Phase 3's CI ambiguity bug) — both
caught by adversarial/structural verification a "does it look right"
pass would have missed, and both on changes that had already been
authorized/cleared, since QA is independent of and does not substitute for
approval.

## Done Decision

**Decision:** Pending
**Date:** Pending
