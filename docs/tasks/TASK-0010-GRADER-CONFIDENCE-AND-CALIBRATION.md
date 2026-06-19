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

## Evidence from SP-1 Speed/Quality Investigation (2026-06-18)

Findings from `docs/research/grader_speed_sp1_report.md` and `frq_grading_status_2026-06-18.md` that bear directly on specific phases above. This is FRQ02-only evidence (AP Biology, single question); treat as input to this task's design, not as already-satisfied acceptance criteria.

**Relevant to Phase 3 ("calibrate confidence... not the model's unsupported self-reported confidence"):** this phase's design principle is no longer just a precaution — it has direct empirical confirmation. `gpt-4o-mini`'s self-reported confidence on the FRQ02 corpus never dropped below 0.8 even on criteria it graded incorrectly (correct calls averaged 0.938 confidence; wrong calls averaged 0.880–0.908 — real separation, but compressed into a narrow high range that makes any naive threshold either useless or wildly over-triggering). A flat `confidence < 0.7` escalation rule essentially never fired. Whatever confidence/abstention calibration this task builds should be validated against observed error empirically per question and criterion, not assumed to transfer from one model's confidence distribution to another's.

**Relevant to Phase 2 ("Lead Grading Validator adjudicates every disagreement") and Phase 4 ("reopen rubrics when disagreement reveals ambiguity rather than forcing the grader to match a defective rule"):** one response (`S020`) was graded incorrectly by every model/architecture combination tested this session — multiple providers, multiple reasoning efforts, direct routing, escalation, and unconstrained reasoning budget. No tested configuration resolved it. This is a concrete, ready-made case for this task's adjudication process: it needs a human decision on whether the current label is correct and the boundary contract needs sharpening, or the grader's read is defensible and the rubric language itself is the problem. `S028` and `S068` are nearly as persistent. Don't treat these as "the grader needs to get smarter" — treat them as the adjudication queue this task is designed to handle.

**Relevant to Phase 2 ("gold-set" integrity):** five responses in the current provisional FRQ02 corpus (`S014`, `S054`, `S058`, `S062`, `S070`) have labels that appear inconsistent with the rubric note attached to a near-identical, confirmed-correct-labeled response. Worth a Learning Quality pass on these specific labels before the corpus is used as locked gold evidence anywhere in this program — not a grading defect, a labeling-process question.

**Relevant to Phase 3/5 (confidence-based escalation design):** a deterministic, zero-marginal-cost audit (dependency-parse check, not a model call) was built and validated as one input to a disagreement-based escalation policy — catching an over-credit error class that confidence-based escalation structurally cannot, since a confidently-wrong model never self-flags. One open design question from that work, not yet decided, worth resolving as part of this task's confidence-policy design rather than left to the research script: the audit currently credits a response if *any* sentence anywhere in it contains qualifying language, with no check for a contradicting sentence elsewhere in the same response. One concrete failure of this policy was found and patched (a single overly-generic match word was removed after it caused a false credit), but the underlying "any qualifying evidence anywhere" policy itself hasn't been validated against genuinely mixed or self-contradictory responses — only against the one case that happened to surface it. This needs an explicit decision (e.g., should contradictory evidence be required to be reconciled, or does the most recent/most specific statement win) before any audit of this shape is relied on for real scores.

**Relevant to Phase 5 ("release only validated question, rubric, prompt, model, and confidence-policy combinations"):** as of 2026-06-18, no single combination from the speed/quality investigation has been validated to decision-grade rigor end-to-end — the most-tested architecture (full n=100 validation) and the best-performing single number found (n=40 only, one provider) are two different, not-yet-reconciled candidates. Don't read either as a release recommendation; both need this task's actual process applied before either is a release candidate.

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
