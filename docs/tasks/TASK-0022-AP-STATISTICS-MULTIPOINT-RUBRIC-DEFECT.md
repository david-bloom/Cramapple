# TASK-0022 — AP Statistics FRQ Rubric Uniform-1pt-Atomization Defect

**Task ID:** TASK-0022
**Title:** AP Statistics FRQ rubric uniform-1pt-atomization defect
**Owner:** Main Conductor (Claude)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress (pilot slice executed; full-corpus remediation not scoped)
**Priority:** Medium
**Created Date:** 2026-08-07
**Approved Date:** Pending (owner directed the pilot slice in chat, 2026-08-07; no formal APPROVAL/DECISION record yet)

## Product Goal

Every one of the 573 published AP Statistics FRQ criteria in Production is
`points_possible=1` — no exceptions, across all 182 published item versions —
while Biology, Chemistry, and Calculus AB/BC all carry genuine bundled 2pt/3pt
criteria matching real AP scoring conventions. No decision record, authoring
brief, or CED fact pack anywhere in the repo documents this as intentional.
This blocks the gold-set pipeline's decomposition-confirmation step
(`docs/research/GOLD_SET_GENERATION_PROTOCOL.md` Phase 0.5 / §6) from ever
running against Statistics content, and it likely means live grading awards
partial credit at a finer (and possibly less accurate) granularity than the
real exam does for these items.

## Technical Scope

- Documented the defect (this record) with the supporting query evidence.
- Re-decomposed 4 already-published AP Statistics short FRQs
  (`APSTATS-SFRQ-007/008/009/010`, chosen because they were not already in
  the Set B gold-set pilot) from 4×1pt criteria each into genuine mixed
  1/2/3pt criteria, using two standard AP Statistics scoring bundles already
  implied by the CED task-verb conventions: "compute the mean and standard
  deviation together" (2pt) and "describe the sampling distribution — mean +
  standard deviation + condition check" (3pt). Each item's total point value
  was preserved (4 points each); no new claims were introduced.
  Script: `scripts/content-seed/gold-set/20260807_apstats_multipoint_redecomposition.sql`.
- Drafted the `app.gold_set_elements` decomposition for each new multi-point
  criterion (Phase 0.5's AI-draft step), left unconfirmed
  (`confirmed_by IS NULL`) for reader confirmation.
- Published the 4 restructured versions (required precondition for the
  gold-set pipeline, which only draws from published items — Phase 0.3).
  Script: same file above, publish step.
- Ran the actual gold-set generation pipeline (`generate_generic.mjs`,
  AI writer + 2 independent non-OpenAI verifiers per DECISION-0045 R1-R5)
  against the 4 restructured items: 32 answers generated (8 types × 4 items),
  25 `provisional_accept`, 5 `reader_queue`, 2 `discard`. The 30 kept answers
  were loaded into `app.gold_set_answers` under `set_key='A'` (genuinely
  Set A material, distinct from the existing Set B pilot).
  Scripts: `scripts/content-seed/gold-set/apstats_multipoint_fixture.json`,
  `apstats_multipoint_answers.jsonl` (raw generation output, copied under
  `scripts/vercel-gateway-check/` where the pipeline actually ran — see
  Implementation Notes), and
  `scripts/content-seed/gold-set/20260807_apstats_multipoint_goldset_assignments.sql`
  for the load + assignment step.
- Assigned all 30 new answers to both Muhammad Saood and Jill Schmidlkofer
  (two-reader-per-answer, matching the existing Set B pilot design so a
  false-accept rate can eventually be computed the same way). Removed Jill's
  4 earliest pending single-point Set B assignments to hold her total load
  steady.

## Out of Scope

- Full-corpus remediation of the remaining 178 AP Statistics FRQ items still
  carrying uniform 1pt criteria. This task executed a 4-item pilot slice only,
  per owner instruction ("pick a small number"); a decision on whether/how to
  remediate the rest is a separate, larger call.
- Certifying the automated gold-set path for Set A (the §5 false-accept-rate
  gate). This task only generates and assigns the material; certification
  requires the full Phase 4 reader-audit cycle to run and land.
- Re-auditing whether the same atomization pattern exists in other subjects
  not checked here.

## Routes / Components / Systems Affected

- `app.content_items` / `app.content_item_versions` / `app.frq_criteria` for
  APSTATS-SFRQ-007/008/009/010 (new published versions).
- `app.gold_set_elements`, `app.gold_set_answers`,
  `app.gold_set_verification_assignments` (new rows, set_key='A').
- Live student grading for these 4 items changes from four independent 1pt
  checks to the new bundled structure the next time a student answers them.

## Data / Security / Integration Impact

- No schema changes. No secrets or credentials touched.
- Real external API calls were made (Anthropic, Google, DeepSeek via the
  Vercel AI Gateway) to generate the 32 candidate answers — real, if modest,
  API cost incurred.
- Changes live scoring granularity for 4 published items already reachable
  by students.

## Acceptance Criteria

- [x] Defect confirmed and documented with query evidence.
- [x] 4 items re-decomposed into genuine mixed-point criteria with total
      points preserved.
- [x] Element decomposition drafted and left unconfirmed for reader review.
- [x] 4 items published.
- [x] Gold-set answers generated via the real pipeline (not hand-authored).
- [x] Answers loaded to Production under set_key='A'.
- [x] Both Saood and Jill assigned all 30 new answers.
- [x] 4 single-point assignments removed from Jill's queue.
- [ ] Jill confirms (or corrects) the element decomposition during her pass.
- [ ] False-accept rate computed once both readers complete their pass.
- [ ] Owner decision on whether to remediate the remaining 178 AP Statistics
      FRQ items.

## QA Plan

- Manual QA: Jill's cold-verification pass doubles as decomposition
  confirmation (Phase 4 of the protocol).
- Automated tests: none added; this is a content/data pipeline task, not an
  application code change.
- Regression areas: live grading of APSTATS-SFRQ-007/008/009/010 (verify the
  new criteria grade correctly against real student answers post-launch).
- Failure cases: a criterion decomposition Jill disputes should be corrected,
  not silently accepted — matches the protocol's "genuine rubric ambiguity is
  flagged, not resolved" rule.
- Security/data/integration checks: none beyond the standard content-review
  pipeline; no PII or student data involved (fixture-generated answers only).

## Approval State

**Approval Required:** Yes — this is Standard tier, and it changes live
grading structure on published items.
**Approval Type:** Standing (routine content-ops execution directed live in
chat by the Product Owner) — no separate written APPROVAL/DECISION record
filed. Flagging here per Owner instruction "flag this as its own task."
**Decision:** Directed and executed 2026-08-07; formal Decision Log entry not
yet filed — recommend the Product Owner confirm whether one is wanted given
this changes live scoring structure.

## Implementation Notes

- `scripts/content-seed/gold-set/generate_generic.mjs` requires the `ai`/
  `zod` packages, which only exist in
  `scripts/vercel-gateway-check/node_modules`. The script and fixture were
  copied there to run (`NODE_PATH` does not work for ESM resolution in this
  Node version). The canonical copies stay in
  `scripts/content-seed/gold-set/` per `GOLD_SET_GENERATION_PROTOCOL.md`;
  the `vercel-gateway-check/` copies are working copies, consistent with the
  existing pattern in that directory (see commit
  "Add vercel-gateway-check copies of gold-set generation/verification
  scripts").
- `app.gold_set_verification_assignments` has no `skipped` status (only
  `pending`/`submitted`/`flagged_contaminated`); removing Jill's 4 single-point
  assignments meant deleting the still-pending rows outright, same approach
  used for the Tutor Beta cleanup earlier in this session.
- Publishing required setting `practice_format` — already set to
  `targeted_drill` for all 4 items (unlike `APBIO-FRQ-L-036` earlier in this
  session, which had the same gap).

## QA Review

**QA Verdict:** Pending (Pass / Fail) — a fresh independent QA pass on this
task has not yet been run.

## Done Decision

**Decision:** Pending
**Date:**
