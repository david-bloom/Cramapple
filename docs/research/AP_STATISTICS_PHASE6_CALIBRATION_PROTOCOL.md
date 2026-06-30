# AP Statistics Phase 6 Calibration Protocol

**Status:** Draft protocol; not a grading-quality or launch approval
**Related Task:** `TASK-0013`
**Owner:** Main Conductor (Claude) with QA Agent execution
**Product Owner:** David Bloom
**Prepared:** 2026-06-30

**Blocked on:** Phase 3 (`prompts/CODEX_AP_STATISTICS_PHASE3_CALCULATION_VERIFIER.md`)
shipping and Phase 4 (`docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`)
producing authored content with independent blind tutor scores. This
protocol cannot run against synthetic test cases alone — it needs real
content and real human-scored responses, the same way AP Biology's SP-1
protocol did.

## 1. Purpose

Produce a documented grader-agreement number for AP Statistics before any
grading-quality claim is made — per `TASK-0013`'s acceptance criteria
("documented grader agreement/confidence numbers, not just a 'looks right'
judgment call"). This is the AP Statistics equivalent of
`GRADER_SPEED_SUBTASK_PROTOCOL.md` (SP-1), scaled to a pilot batch, not a
full production-readiness run.

## 2. Priority Order (Binding)

Per `[[feedback_grader_priority]]`, the project-wide priority order is
**Speed > Quality > Cost**, up to ~$0.03/FRQ — never trade speed for cost.
This protocol inherits that order but is explicitly a quality-calibration
run first; speed profiling for AP Statistics specifically is out of scope
here unless this run surfaces a speed regression worth flagging separately.

## 3. Goals

1. Measure agreement between `evaluate-attempt`'s LLM-based criterion
   grading and independent blind tutor scores on the AP Statistics pilot
   batch (`DECISION-0031`'s 71 MCQ / 33 FRQ batch, or whatever subset of it
   is authored and published by the time this runs).
2. Measure agreement specifically on criteria the Phase 3 deterministic
   calculation-check verifier covers (test statistic, p-value, confidence
   interval) — compare LLM-alone agreement against LLM+verifier agreement,
   to establish whether the verifier is actually pulling its weight before
   any decision to wire it into the live grading path.
3. Identify boundary-conflict clusters the same way SP-1 did for AP
   Biology (`S010`/`S020`/`S028`/`S066`/`S068`-style flagged disagreement
   cases) — surface them for Learning Quality adjudication, don't resolve
   them unilaterally in this protocol.
4. Confirm MCQ grading (rule-based lookup, no model call, per
   `evaluate-attempt`'s existing `isMcq` branch) needs no AP-Statistics-
   specific calibration — it's pure key-matching, already validated by
   construction the same way it was for Biology. State this explicitly
   rather than silently skipping it.

## 4. Sample Size

Follow SP-1's precedent: meaningful signal starts around n=40, full
confidence around n=100. Given the AP Statistics pilot batch is smaller
than Biology's full content set (33 FRQs total vs. Biology's 30 long + 100
short), this run will likely calibrate against the full FRQ batch rather
than a sample of it — note in the run report if batch size meaningfully
limits statistical confidence, don't overstate it.

## 5. Non-Goals

- Do not make a grading-quality release/launch decision from this run
  alone — that's a separate Hard Gate (`STANDING_APPROVAL_LANES.md`,
  "Expert-quality gate acceptance").
- Do not change Phase 3's verifier logic mid-run to chase a better number —
  if it underperforms, report that, don't quietly patch it during
  calibration (same discipline as SP-1's non-goal #1).
- Do not extend this run to a full-scale production calibration — that's a
  later, separately-scoped task once the pilot batch result is in hand.
- Do not skip the MCQ confirmation step (§3.4) even though it's
  low-risk — silent assumptions are how gaps get missed at launch.

## 6. Required Inputs Before Starting

- Published AP Statistics content (Phase 4) with independent blind tutor
  scores recorded via the existing `content_review_decisions` /
  `content_review_assignments` tables (already subject-agnostic, per
  `[[project_database_schema_status]]`).
- Phase 3's verifier, runnable against the same response set.
- Confirmation that reviewers scoring this batch are the cross-credentialed
  existing tutors per `DECISION-0031`, not new/unvetted reviewers.

## 7. Output

A report in `docs/research/` (naming convention:
`ap_statistics_phase6_calibration_report_<date>.md`, mirroring
`grader_speed_sp1_report.md`) with: agreement numbers, boundary-conflict
cases flagged for adjudication, the LLM-alone vs. LLM+verifier comparison,
and an explicit recommendation (not a decision) on whether the verifier is
ready to wire into `evaluate-attempt`'s live grading path.
