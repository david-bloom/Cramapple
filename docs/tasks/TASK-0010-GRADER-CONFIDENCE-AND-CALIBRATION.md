# TASK-0010 — Grader Confidence and Calibration

**Task ID:** TASK-0010
**Title:** Establish Reasonable Confidence in FRQ Grading
**Owner:** Learning Quality Owner / Grading Lead / Technical Owner
**Product Owner:** David Bloom
**Status:** Proposed
**Priority:** Critical
**Created Date:** 2026-06-13
**Approved Date:** Pending

## Product Goal

Establish evidence-based confidence that Cramapple's FRQ grader scores each
criterion consistently, abstains when appropriate, grounds feedback in the
student response, and remains reliable after release.

## Confidence Program

### Phase 1 - Rubric and Development Cases

- Validators make every criterion independently decidable where possible.
- Authors provide full, partial, no-credit, equivalent-language,
  contradiction, ambiguity, and boundary cases.
- Deterministic checks handle calculations, units, required fields, and
  internally inconsistent totals where possible.
- Author-generated cases test implementation but do not count as gold evidence.

### Phase 2 - Adjudicated Gold Sets

- Two qualified Grading Validators score every case blind at criterion level.
- A Lead Grading Validator adjudicates every disagreement.
- Model output remains hidden until gold labels are locked.
- Development, calibration, held-out, and challenge sets remain separate.
- Held-out cases and near-neighbor variants are inaccessible to prompt authors
  and model-tuning workflows.

### Phase 3 - Locked Evaluation

- Run the full criterion and total-score metric suite in
  `CONTENT_GOVERNANCE_AND_VALIDATION.md`.
- Report results by criterion, FRQ archetype, score band, response style,
  assistance level, and any lawfully evaluated learner group.
- Calibrate confidence bands and abstention thresholds against observed error,
  not the model's unsupported self-reported confidence.
- Use independent grading passes or model configurations for high-value or
  high-risk responses; disagreement lowers confidence and triggers escalation.

### Phase 4 - Shadow Operation

- Grade real or pilot responses without showing the AI score as authoritative.
- Human reviewers score 100% of the initial shadow cohort.
- Compare score, criterion, feedback grounding, abstention, latency, and
  disagreement before learner-facing use.
- Reopen rubrics when disagreement reveals ambiguity rather than forcing the
  grader to match a defective rule.

### Phase 5 - Limited Release

- Release only validated question, rubric, prompt, model, and confidence-policy
  combinations.
- Human-review all low-confidence, conflicting, novel, disputed, and
  high-impact cases.
- Random-review at least 20% of apparently high-confidence cases during the
  first limited cohort, in addition to all escalations.
- End limited release only through a recorded gate decision. General release
  then starts the separate first-30-days monitoring regime in the governance
  procedure; the 5% production sample is not a substitute for the limited
  cohort's 20% sample.

### Phase 6 - Continuous Monitoring

- Maintain hidden sentinel cases and run them after every relevant change.
- Monitor criterion agreement, severe errors, over- and under-scoring,
  feedback grounding, abstention, disputes, and drift.
- Version-pin every grading result to the question, rubric, prompt, model,
  parameters, deterministic checks, and confidence policy.
- Suspend affected combinations when governance triggers fire.

## Acceptance Criteria

- [ ] Criterion-level rubric contract approved.
- [ ] Adjudicated gold-set process operational.
- [ ] Development, calibration, holdout, and challenge sets are access-isolated.
- [ ] Release thresholds are reviewed against pilot feasibility.
- [ ] Confidence and abstention are empirically calibrated.
- [ ] Independent-pass disagreement policy is approved.
- [ ] Shadow cohort passes before learner-facing automated scores.
- [ ] Limited-release human sampling and escalation are operational.
- [ ] Limited-to-general-release graduation criteria and decision record are
  approved.
- [ ] Drift, sentinel, dispute, regrading, and suspension workflows pass QA.
- [ ] Product Owner approves learner-facing use.

## Approval State

**Approval Required:** Yes
**Approval Type:** Product and Learning Quality hard gate
**Decision:** Pending

## Done Decision

**Decision:** Pending
**Date:** Pending
