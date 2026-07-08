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

## Adopted Grading Standard (2026-07-08, DECISION-0034)

Five directions are now standing policy for this task and the grading program.
Details live in the architecture and research docs; this task operationalizes
them.

1. **Criterion-boundary contract is a required authored artifact** — authored
   with the rubric, sharpened not invented during calibration
   (`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9.1;
   `../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §10.5).
2. **Depth over breadth** — effort goes to one fully-adjudicated AP Biology gold
   set before more synthetic breadth corpora
   (`../research/grading_packet_backlog_2026_07_07.md` revised priority).
3. **Per-subject deterministic-check layer** is required and version-pinned
   (`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7.1;
   per-subject verification profiles in `../research/`).
4. **Feedback quality is measured, not only the score decision** — grounding,
   minimum-fix sufficiency, and error-classification accuracy are reported
   alongside criterion agreement (`../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
   §12.3; `../research/GRADING_RESEARCH_CANONICAL_PROCESS.md`).
5. **Single fast grader is the default runtime** — escalation-on-confidence,
   ensembles, and reference layers are retired from the default; multiple models
   are boundary auditors only (`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
   §7.2). Rationale and evidence: `../research/grading_cross_subject_takeaways.md`.

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
- For new BYOQ or rubric revisions, require a calibration pass with
  `gpt-4o-mini` plus a secondary audit model before the combination is treated
  as production-ready.
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

**Relevant to Phase 5 (BYOQ calibration rule):** user-provided questions and any material rubric revision should be calibrated with `gpt-4o-mini` as the primary boundary scorer and a secondary audit model on the disagreement set before entering the production grading path. The secondary model is for boundary diagnosis and rubric tightening, not for default live fallback scoring.

## Acceptance Criteria

- [ ] Criterion-level rubric contract approved.
- [ ] Criterion-boundary contract authored for every launch-question criterion
      (required package element, per §9.1).
- [ ] Per-subject deterministic-check layer implemented and version-pinned for
      the launch subject (AP Biology verification profile).
- [ ] One fully-adjudicated AP Biology gold set exists (depth-first), meeting the
      §12.2 held-out minimums for at least the launch questions.
- [ ] Adjudicated gold-set process operational.
- [ ] Development, calibration, holdout, and challenge sets are access-isolated
      and tier-labeled (development / calibration / adjudicated-gold / held-out /
      challenge / sentinel).
- [ ] Release thresholds are reviewed against pilot feasibility using the real
      adjudicated gold set.
- [ ] Confidence and abstention are empirically calibrated against observed
      error, not model self-report.
- [ ] Feedback-quality metrics (grounding, minimum-fix sufficiency, error
      classification) are measured and pass §12.3 thresholds.
- [ ] Default single-fast-grader runtime is validated; any hard-criterion direct
      route is chosen from calibration evidence, not runtime confidence.
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
