<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0037 — TASK-0016 Phase A Dev Execution (full, incl. review pipeline)

**Date:** 2026-07-14
**Approved By:** David Bloom
**Related Task:** TASK-0016 (Phase A)
**Decision:** Approved with Notes

### Summary

Authorized Dev execution of TASK-0016 Phase A (evaluator-strategy router,
Engine 1 deterministic-before-LLM, Engine 3 typed dispatch, and the shadow-review
pipeline), scope confirmed as **full Phase A including the review pipeline**.
Target environment: `wmgjsdkphcyhngaffbqf` (Development) only; Production
untouched. Executed 2026-07-14: 7 additive/idempotent migrations applied via MCP,
6 edge functions deployed via CLI, boundary-verified (401 on unauth, GET route
live, CORS preflight 200).

Evidence: `docs/qa/TASK0016_PHASE_A_DEV_EXECUTION_EVIDENCE_2026_07_14.md`.

### Notes

- Preflight revealed Dev's migration history is **diverged / partly managed
  outside this repo** (rubric-routing columns applied under foreign Jul-11 version
  ids). `db push` was therefore not used; migrations applied individually.
- Deferred within Phase A: HDG spatial remediation (content guard would abort — 0
  published HDG on Dev); `202607080003/004` (queue-scope backfill + **promote
  dbloom01→admin**, a role/privilege change not made autonomously). Available on
  request.
- **Not approved by this record:** any Production change; and the full end-to-end
  shadow-grading Dev evidence run (needs seeded AP Statistics content + a test
  student), which remains the next step. `QA-pass ≠ launch approval`.
- Recommended follow-up: a separate migration-history reconciliation task to
  realign Dev `schema_migrations` with the repo.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0034 — TASK-0017 Manifest Naming, Validation Registry, and Content-Clearance Exception Design

**Date:** 2026-07-13
**Approved By:** David Bloom
**Related Task:** TASK-0017
**Decision:** Approved

### Summary

Approves three subject-onboarding harness design directions:

1. Formally deprecate `exam_pack_manifests.artifact_version_ids` for the canonical v1 content-version path and design a correctly named, typed, backward-compatible replacement.
2. Replace unconstrained validation-suite category text with a typed/versioned registry that includes `security_privacy` as a first-class publication-gate category.
3. Introduce an immutable, typed H5 content-clearance-exception record with explicit scope, Product Owner approval, rationale/evidence, effective/expiry bounds, and revocation/supersession.

The exception record may waive content clearance only. Grading/calibration, rights, and security/privacy gates remain non-waivable.

### Not Approved

- No Dev or Production migration/application.
- No schema implementation before the H0/H1 design packet and migration review.
- No publication, launch, or bypass of existing P0 fail-closed behavior.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0035 — August Pilot Bio/Stats Release Intent; TASK-0017/0009 Split; Chemistry Scaffold-Only AC4

**Date:** 2026-07-13
**Approved By:** David Bloom
**Related Tasks:** TASK-0017, TASK-0009, TASK-0010, TASK-0013, TASK-0014
**Decision:** Approved with execution prerequisites

### Summary

- Authorizes release intent for human-verified, AI-generated AP Biology and AP Statistics content for the August pilot, with live checking/monitoring.
- Approves the authority split: TASK-0017 defines v1 consumer constraints but does not supersede TASK-0009; TASK-0009 retains conceptual schema/governance authority and must ratify the related designs before DDL.
- Revises TASK-0017 AC4 so AP Chemistry tests reconciliation of its existing subject/exam-pack/taxonomy scaffold, not nonexistent governed content.
- Directs that AP Chemistry content must not be published.

### Execution Prerequisites and Limits

- P0 remains implemented but unverified until rollback and exact-version tests pass against real Postgres.
- Product Owner authorization does not substitute for authoritative source, rights, human-verification/content-clearance, grading/calibration, or security/privacy evidence required by the release path.
- Grading/calibration and security/privacy remain non-waivable under DECISION-0037.
- This record does not itself apply a migration, publish rows, deploy an Edge Function, or authorize AP Chemistry publication.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0036 — AP Statistics 2026-27 Content-Bank Inventory Split (100 MCQ / 70 FRQ)

**Date:** 2026-07-13
**Approved By:** Orly (Curriculum Owner), relayed by David Bloom
**Related Tasks:** TASK-0017, TASK-0013
**Decision:** Approved

### Summary

Approves the AP Statistics 2026-27 practice content-bank inventory split proposed in
`docs/product/AP_STATISTICS_2027_INVENTORY_SPLIT_PROPOSAL.md`, superseding the fact-pack §9.5
placeholder (71 MCQ / 33 FRQ):

- **MCQ — 100 items** across the five units by CED MC weight band: Unit 1 = 26, Unit 2 = 21,
  Unit 3 = 21, Unit 4 = 16, Unit 5 = 16 (each share lands inside its CED band).
- **FRQ — 70 items** by archetype, recorded as the **recommended inference-weighted** split:
  `frq-practices-1-2` = 14, `frq-practices-3-4` = 16, `frq-inference` = 22,
  `frq-multifocus-2-3-4` = 18. (If Orly intended the even exam-mirror alternative 18/18/17/17,
  amend this record.)
- Suggested per-unit FRQ coverage (~U1 18 / U2 12 / U3 20 / U4 14 / U5 6) confirmed as guidance,
  adjustable during authoring.

These are **authoring-bank targets** (how many distinct items to write), not per-exam-form counts.

### Not Approved / Still Gated

- This approves the *plan/counts only*. It does **not** authorize bulk authoring (G2), which still
  requires the AP Statistics tutor's G0A sign-off on the fact pack and the vertical slice clearing
  Codex G3V.
- No content is cleared or published by this record (`QA-pass ≠ launch approval`).
- The harness `inventory.targets` bank-vs-per-form modeling gap (raised in the proposal, for Codex)
  should be resolved before these counts enter a SubjectPackage.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0032 — AI Provisional Grading Labels as Calibration Evidence (Gold-Set Candidates)

**Date:** 2026-07-08
**Approved By:** David Bloom
**Related Task:** TASK-0010
**Decision:** Approved

### Summary

Authorizes treating the AI-authored (Claude Fable) criterion-level provisional
labels in the three gold-set-candidate packages as `calibration`-tier evidence,
usable now for grader iteration and boundary-contract sharpening. This is the
"treating generated samples as calibration evidence" Hard Gate
(`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §11), approved as Option B of the
gold-set build under `DECISION-0034`.

Covers:
- `docs/research/ap_biology_gold_set_candidate_2026_07_08/`
- `docs/research/ap_statistics_gold_set_candidate_2026_07_08/`
- `docs/research/ap_chemistry_gold_set_candidate_2026_07_08/`

### Not Approved

- These are **not** `adjudicated_gold`. They do not satisfy the §12 grading
  release gate and must not be cited for a release-threshold quality claim.
- Upgrade to `adjudicated_gold` requires two qualified human Grading Validators
  scoring blind + Lead adjudication (§12.1), then a recorded re-tier decision.
- No learner-facing grading, launch readiness, or Done decision is implied.

### Notes

- AI labels are provisional judgments against each item's rubric
  `evidence_requirements`/`accepted_variants`; the adjudication queue and
  deterministic-check targets in each package's `provisional_labels.json` are the
  priority items for the human pass.
- Chemistry package carries a blocking corpus defect (truncation-degenerate
  variants) — see its README; it calibrates incompleteness only until
  wrong-reasoning responses are authored.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0033 — TASK-0016 Multi-Rubric Grading Engine Rollout (Open + Phase A Go-Ahead)

**Date:** 2026-07-08
**Approved By:** David Bloom
**Related Task:** TASK-0016
**Decision:** Approved

### Summary

Opens TASK-0016 (build the four-rubric-type grading/feedback engines, launching
AP Statistics end-to-end first) and authorizes Phase A to start: the
evaluator-strategy router, wiring the deterministic + boundary-contract layer
into production (Engine 1), and integrating the symbolic + Error-Carried-Forward
typed path (Engine 3). Phase A needs no gateway credentials or student-image
data. All Tier-1 owner decisions are resolved and recorded in
`docs/research/grading_engine_rollout_plan_2026_07_08.md`.

Also confirmed:
- **Launch-bar targets are ceilings ("stay under"):** p50 latency ≤ 1000 ms and
  cost ≤ $0.01/item; accuracy ≥ 95% (criterion-level agreement).
- **Latency is measured end-to-end (student experience: submit → feedback
  rendered), at p50 / p90 / p99, segmented per engine / input modality.** p90/p99
  are measure-and-report first to characterize the long tail; hard p90/p99 gates
  set by the Product Owner after the first distribution is observed.

### Not Approved

- No production launch (separate Hard Gate). Shadow-first only; no learner-facing
  authoritative score before shadow gates pass.
- Engine 2 (Holistic) build is deferred, not authorized here.
- Phases B/D still require gateway credentials before their live runs.

### Notes

- Reference implementations built this session:
  `docs/research/math_formula_grading_experiment_2026_07_08/formula_checker.py`
  (62/62) and `ecf_engine.py` (6/6).
- The adjudicated AP Statistics gold set (Phase C) remains the true launch gate
  per `grading_cross_subject_takeaways.md` Lesson 7.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0028 — AP Chemistry Content-Sourcing Model (TASK-0014)

**Date:** 2026-07-07
**Approved By:** David Bloom
**Related Task:** TASK-0014
**Decision:** Approved

### Summary

Resolves the open item flagged in `APPROVAL-0026`'s Notes: AP Chemistry
reuses the same content-sourcing model approved for AP Statistics under
`APPROVAL-0024`/`DECISION-0031` — the existing tutor-authored-base-package
model under Orly; existing reviewers may be cross-credentialed across
subjects without standing up a new Chemistry-specific tutor pool; rights/
licensing posture is unchanged from AP Biology (no official College Board
material as input or exemplar).

### Notes

- Pilot-batch unit/item distribution (the Chemistry analogue of AP
  Statistics' 71 MCQ / 33 FRQ, 9-unit split) is not set by this approval —
  that is a content-planning detail for Phase 4, not a sourcing-model
  decision, and should be derived from the AP Chemistry Course and Exam
  framework the same way AP Statistics' was.
- Does not change Phase 2 (migration) or production-launch Hard Gate
  status — see `APPROVAL-0026`.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0029 — AP Physics Content-Sourcing Model (TASK-0015)

**Date:** 2026-07-07
**Approved By:** David Bloom
**Related Task:** TASK-0015
**Decision:** Approved

### Summary

Resolves the open item flagged in `APPROVAL-0027`'s Notes: AP Physics reuses
the same content-sourcing model approved for AP Statistics under
`APPROVAL-0024`/`DECISION-0031` — the existing tutor-authored-base-package
model under Orly; existing reviewers may be cross-credentialed across
subjects without standing up a new Physics-specific tutor pool; rights/
licensing posture is unchanged from AP Biology (no official College Board
material as input or exemplar).

### Notes

- Pilot-batch unit/item distribution is not set by this approval — Physics
  is also likely to need reusable verification capability (symbolic math,
  units, vectors) beyond what Statistics or Chemistry require; that
  verification-profile design work is Phase 3, not gated by this content-
  sourcing approval.
- Does not change Phase 2 (migration) or production-launch Hard Gate
  status — see `APPROVAL-0027`.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0030 — TASK-0014 Phase 2 Migration Go-Ahead

**Date:** 2026-07-07
**Approved By:** David Bloom
**Related Task:** TASK-0014
**Decision:** Approved

### Summary

Authorizes the Phase 2 database migration seeding `ap-chemistry` as an
`app.subjects` row, plus its `exam_pack`/`exam_pack_version` and
`app.content_labels` unit/topic/skill scaffold, to execute — same Hard Gate
category as `APPROVAL-0025` for AP Statistics. Covers
`supabase/migrations/202607070005_chemistry_physics_schema_instantiation.sql`
(Chemistry portion).

### Notes

- Scope is exactly the migration file as drafted — no broader migration
  authority granted.
- Publishing the resulting exam pack/content is explicitly not covered.
- This migration was drafted by a concurrent Codex session working the
  platform-adaptation side of `TASK-0014`/`TASK-0015` in the same working
  tree; David committed it directly (`e37b3e5`) alongside the Chemistry/
  Physics taxonomy and verification-profile artifacts.

<!-- source: codex/five-subject-harness-and-content@c5f539294c4d -->
## APPROVAL-0031 — TASK-0015 Phase 2 Migration Go-Ahead

**Date:** 2026-07-07
**Approved By:** David Bloom
**Related Task:** TASK-0015
**Decision:** Approved

### Summary

Authorizes the Phase 2 database migration seeding `ap-physics-1` as an
`app.subjects` row, plus its `exam_pack`/`exam_pack_version` and
`app.content_labels` unit/topic/skill scaffold, to execute — same Hard Gate
category as `APPROVAL-0025` for AP Statistics. Covers
`supabase/migrations/202607070005_chemistry_physics_schema_instantiation.sql`
(Physics portion).

### Notes

- Scope is exactly the migration file as drafted — no broader migration
  authority granted.
- Publishing the resulting exam pack/content is explicitly not covered.
- Same concurrent-Codex-session origin as `APPROVAL-0030`; see that entry's
  notes.
