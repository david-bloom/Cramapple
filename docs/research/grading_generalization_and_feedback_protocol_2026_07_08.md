# Grading Generalization and Feedback Protocol — 2026-07-08

**Status:** Preregistered protocol for external execution
**Owner:** Product Owner with Learning Quality Owner
**Related:** `GRADING_RESEARCH_CANONICAL_PROCESS.md`,
`grading_cross_subject_takeaways.md`,
`../tasks/TASK-0010-GRADER-CONFIDENCE-AND-CALIBRATION.md`,
`../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`

## Purpose

This protocol preregisters two linked experiments:

1. a cross-subject generalization test of the winning grading architecture
   against a frontier-model control on the three silver corpora; and
2. a feedback-and-diagnosis quality test that evaluates whether the feedback
   explains the right withheld point, the minimum fix, and the evidence in the
   student response.

The point of the run is to find out whether the fast architecture with the
correct boundary contract and deterministic checks generalizes beyond FRQ02,
and whether it also improves the product-critical feedback loop.

## Locked Inputs

Use the three calibration-tier silver packages already built on 2026-07-08:

- [AP Biology gold-set candidate](./ap_biology_gold_set_candidate_2026_07_08/README.md)
- [AP Chemistry gold-set candidate](./ap_chemistry_gold_set_candidate_2026_07_08/README.md)
- [AP Statistics gold-set candidate](./ap_statistics_gold_set_candidate_2026_07_08/README.md)

Use the package manifests, provisional labels, adjudication queues, and the
subject-specific verification profiles as frozen inputs. Do not edit the
packages while the run is in progress.

## Experiment A: Cross-Subject Generalization

### Question

Does the winning architecture generalize across subjects and question types
better than a frontier-model control, while also staying cheaper and faster?

### Arms

- **Winning architecture.** The default single fast grader for the subject,
  plus the required criterion-boundary contract and the subject verification
  profile. Deterministic checks run where the profile declares them. No
  ensemble. No extra escalation unless the subject package explicitly already
  requires a direct route for a pre-approved hard criterion.
- **Frontier-model control.** The best direct single-model scorer available for
  the run, frozen in the manifest before any scoring starts. Same rubric
  package, same response order, same output schema, no deterministic checks,
  no retrieval, no escalation stack, and no extra boundary memory beyond the
  rubric text itself.

If the control model name changes during setup, the manifest must record the
change before any scored output is examined.

### Primary endpoint

Micro-averaged criterion exact agreement across all three corpora.

### Secondary endpoints

- subject-level criterion exact agreement;
- total-point exact agreement where applicable;
- over-credit and under-credit counts;
- schema validity;
- p50 and p95 latency;
- average cost per response;
- disagreement clusters that deserve Learning Quality review.

### Generalization success hypothesis

The winning architecture is the better generalizing system if it:

- ties or beats the frontier-model control on pooled criterion exact agreement;
- does not regress materially on any subject slice; and
- is cheaper and faster on average.

Report any subject-specific regression even if the pooled result wins.

## Experiment B: Feedback and Diagnosis Quality

### Question

When the model withholds a point, does its feedback name the right reason, give
the smallest fix that actually earns the point, and stay grounded in the
student response?

### Unit of analysis

Score each criterion-level missed point, not just each whole response.

- If a response misses multiple criteria, score each missed criterion
  separately.
- If a response is fully correct, do not manufacture feedback metrics for it.
- If a response is a known corpus defect, record that explicitly and scope the
  metric accordingly.

### Required feedback fields

For every missed criterion, the model must emit:

- the withheld-point reason;
- the minimum fix;
- a concise improved answer;
- the error classification.

### Feedback metrics

Score each missed criterion on three checks:

- **Reason match.** Does the stated reason for withholding the point match the
  corpus error signal?
  - Chemistry: the injected error in the wrong-response record.
  - Biology: the adjudication queue note and boundary contract.
  - Statistics: the deterministic-check target or corpus defect note.
- **Minimum-fix sufficiency.** Would the stated minimum fix actually earn the
  point under the rubric and boundary contract?
- **Grounding.** Is the feedback supported by the student response text rather
  than by a generic rubric paraphrase or an invented detail?

Use `match | partial | mismatch | unable_to_determine` for each metric.

### Feedback success hypothesis

The winning architecture should be at least as good as the frontier-model
control on all three feedback metrics, and ideally better on the two that matter
most to students: minimum-fix sufficiency and grounding.

## Corpus-Specific Notes

- **AP Biology:** judgment-heavy; rely on the boundary contract and adjudication
  notes for reason-matching.
- **AP Chemistry:** use the regenerated wrong-reasoning corpus; the injected
  misconception field is the cleanest reason-matching signal.
- **AP Statistics:** exclude or separately flag any item that has no dataset.
  `APSTAT-MOD8-H001` is a corpus defect, so its value-specific claims should not
  be treated like normal gold evidence.

## Budget and Stop Rules

The run must obey the daily budget cap and the budget-burn rule in
`DECISION-0030`:

- check remaining budget before every provider call;
- estimate the next call conservatively;
- stop if the next call would exceed the remaining cap;
- burn actual known cost even when a call fails or is rejected after the
  provider already incurred spend;
- do not rerun a failed arm unless the remaining budget can absorb the rerun;
- log the actual cost for completed, failed, and rejected calls alike.

If a call returns no usable cost data, burn zero and mark the cost as unknown.

## Provider and Auth Requirements

Use the approved multi-provider path for the external run:

- gateway/OIDC or BYOK where configured;
- no static API keys in the run artifact;
- model and provider names frozen in the manifest before score review;
- identical prompts, output schema, and corpus order across arms.

## Reporting Requirements

Write a report that includes:

- the exact corpus package versions used;
- the frozen control model and the winning architecture configuration;
- pooled and per-subject agreement;
- feedback-metric results by subject and by arm;
- cost and latency;
- any corpus defects or exclusions;
- any adjudication queue items that look like rubric or label problems rather
  than model failures;
- a plain-language recommendation on whether the fast architecture should stay
  the default.

Save the output as a dated report in `docs/research/` plus a machine-readable
summary if the runner produces one.

## Do Not

- Do not alter the rubric, boundary contract, or corpus during the run.
- Do not use chat history as evidence.
- Do not pool corpus defects into the main accuracy claim.
- Do not treat a same-model regrade as a substitute for independent
  adjudication.

## Pass / Fail Logic

- **Pass for generalization:** the winning architecture ties or beats the
  frontier-model control on pooled agreement and is lower cost / lower latency.
- **Pass for feedback:** the winning architecture is at least as strong as the
  control on reason match, minimum-fix sufficiency, and grounding.
- **Fail:** any subject-specific regression that breaks the guardrail, any
  corpus defect that is not isolated, or any result that cannot be traced back
  to the frozen inputs.
