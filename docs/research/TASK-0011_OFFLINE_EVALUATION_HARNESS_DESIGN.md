# TASK-0011 Offline Evaluation Harness Design

**Status:** Internal specification/tooling work, not a participant-labeling
or production-grading authorization
**Related Tasks:** `TASK-0010`, `TASK-0011`
**Source Specification:** `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`
(sections 8.2-8.5, supporting sections 4-7)
**Owner:** Grading Lead / Technical Owner
**Last Updated:** 2026-06-18

## 1. Purpose

This is the tooling design for the locked offline evaluation in phase-1
spec section 8: comparing the four candidate grading methods (section 8.2)
against locked human gold labels, computing the section 8.3 metrics,
checking them against the section 8.4 decision gates, and producing the
section 8.5 outcome classification per criterion.

It exists because section 10 of the phase-1 spec lists "offline evaluation
harness design" as work that may proceed now, ahead of item authoring,
participant collection, or any approval gate. Building this now means the
metric definitions and decision-gate logic get scrutinized before real
labeled data exists, instead of being improvised under time pressure once a
locked holdout is ready.

No real corpus data exists yet. Everything in this document and the scripts
it describes has been validated against synthetic fixtures only (see
section 6). This harness does not authorize, perform, or imply any
production grading.

## 2. Inputs

| Input | Schema | Required? | Produced by |
| --- | --- | --- | --- |
| Gold criterion decisions | `scripts/drawn_response/schemas/criterion_decision_record.schema.json`, `method: human_lead_adjudication` | Yes | Human-labeling protocol, `docs/research/DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md` section 2 |
| Method criterion decisions | Same schema, `method` set to one of the four section 8.2 method enums | Yes | The candidate grading pipeline under test |
| Weights file | `{criterion_id: points}` JSON, ad hoc (not yet a formal schema -- see section 7) | Optional | Each item's locked `criterion_definitions` package (spec section 3) |
| Method run log | `scripts/drawn_response/schemas/method_run_log.schema.json` | Optional | The candidate grading pipeline's instrumentation |

Both criterion-decision inputs must be JSONL, one record per
`(item_id, response_id, criterion_id)`. The harness pairs gold and method
records on that exact key.

## 3. Pipeline

```text
gold.jsonl + method.jsonl
  -> validate_records.py criterion_decision <file>   (structural check, run separately first)
  -> evaluate_offline.py
       -> pair_records (key on item_id/response_id/criterion_id; report unmatched)
       -> compute_criterion_level_metrics (section 8.3, by criterion_label and overall)
       -> compute_response_level_metrics (section 8.3 response-level exact agreement)
       -> compute_total_score_metrics (section 8.3 total-score metrics, needs weights)
       -> check_decision_gates (section 8.4 thresholds, PASS/FAIL/INSUFFICIENT_N/NOT_COMPUTABLE)
       -> classify_outcomes (section 8.5: AUTOMATION_CANDIDATE / HUMAN_REVIEW_REQUIRED / UNSUPPORTED / MORE_EVIDENCE_REQUIRED)
       -> summary.json
  -> report_offline_eval.py summary.json -> markdown report
```

Run one `evaluate_offline.py` invocation per method per locked-holdout
snapshot. Section 8.2 requires running "the same locked inputs" through all
four methods -- that means four separate runs against the same gold file,
not one combined run, so that each method's report stands on its own and
reports can be diffed method-to-method.

## 4. Metric Definitions Where The Spec Names But Doesn't Formula

Section 8.3 names metrics (e.g. "precision," "coverage versus error after
abstention," "severe error rate") without fixing a formula for a
4-way-labeled (`MET`/`NOT_MET`/`ABSTAIN`/`NOT_APPLICABLE`), abstention-aware
system. `evaluate_offline.py` had to pick concrete formulas to be runnable.
Every such choice is marked `HARNESS CONVENTION` in the code and repeated
here so it can be reviewed in one place:

- **Precision/recall** treat `MET` as the positive class and are computed
  only over "confident" method decisions (method gave `MET` or `NOT_MET`,
  not `ABSTAIN`). Abstaining behavior is reported separately
  (`coverage`, `false_abstention_rate`, `ambiguity_escalation_recall`) so it
  is never silently absorbed into precision/recall. This mirrors the
  quality/strict split in
  `scripts/report_bio_reference_layer_oracle_boundary.py`.
- **Exact agreement** is the literal reading: method decision string equals
  gold decision string, including `ABSTAIN == ABSTAIN`, over every pair
  where gold is not `NOT_APPLICABLE`.
- **Severe error rate** = over-scoring rate + under-scoring rate, computed
  over confident pairs only (a `MET`/`NOT_MET` mismatch where the method
  did not abstain). The spec does not define "severe" as distinct from
  ordinary over/under-scoring for this binary-decision setting; this
  harness treats them as identical until a sharper definition is approved
  (e.g. one that distinguishes severity by point value or rubric stakes).
- **Coverage** = confident decisions / scorable (decisive-gold) decisions.
  It excludes truly abstention-worthy gold cases from the denominator, so a
  method that correctly abstains on hard cases is not penalized as "low
  coverage."
- **False-abstention rate** = method abstained / gold decisive (scorable).
- **Ambiguity/escalation recall** = method abstained / gold abstained
  (i.e., did the method correctly flag the cases humans themselves
  couldn't decide).
- **`NOT_APPLICABLE` scope mismatches** (one side says a criterion doesn't
  apply, the other gives a real decision) are tracked separately as an
  integrity finding, not folded into any rate. A scope mismatch usually
  indicates an item-package or method bug, not a grading judgment call.
- **Outcome classification** (section 8.5) sample-size gating borrows the
  Decision-Grade `n >= 30` threshold from
  `docs/research/bio_reference_layer_reporting_standard.md` for cross-track
  consistency. The phase-1 spec doesn't define its own tiering.
  `UNSUPPORTED` fires when a criterion never produced a scorable gold case
  in the run (every gold decision was `ABSTAIN`); `MORE_EVIDENCE_REQUIRED`
  fires below the decision-grade `n`; otherwise `AUTOMATION_CANDIDATE` if
  every section 8.4 per-criterion threshold passes, else
  `HUMAN_REVIEW_REQUIRED`.

None of these are Learning Quality-approved policy. They are working
definitions so the harness can run today. Confirm or override them before
treating any locked-holdout run as the phase-1 decision packet input.

## 5. What This Harness Does Not Cover Yet

- **Capture-quality sensitivity/specificity** (section 8.3): the
  `capture_quality_record.schema.json` envelope currently only models a
  human Capture Reviewer's label (`capture_reviewer_id`), not a competing
  automated detector's output. UX-008/TASK-0011 do not yet authorize an
  automated capture-quality prototype (`docs/product/HANDWRITTEN_GRAPH
  _CAPTURE_EXPERIENCE_DESIGN.md` section 2: "No prototype is authorized by
  this task"), so there is no automated output to compare against yet. When
  one exists, extend the capture-quality schema with a `method` field
  (mirroring `criterion_decision_record.schema.json`) and add a
  `compute_capture_quality_metrics` function parallel to the criterion-level
  one in `evaluate_offline.py`.
- **Robustness by capture condition / preprocessing path** (section 8.3):
  requires capture-quality and preprocessing-variant metadata joined onto
  each criterion decision. Once capture-quality records exist for the same
  responses, join on `(item_id, response_id)` and slice the existing
  criterion-level metrics by capture-quality label instead of building a
  new computation path.
- **Localization accuracy**: explicitly out of scope per section 8.3
  ("Do not report localization accuracy unless a separate approved
  evidence-region benchmark exists").

## 6. Validation Status

All scripts were smoke-tested against synthetic fixtures covering: simple
agreement, over-scoring, under-scoring, false abstention, correct
escalation, an abstain-override, a `NOT_APPLICABLE` scope mismatch,
duplicate-key rejection, and unmatched-record reporting. Metric outputs
were independently hand-calculated and matched exactly (see commit history
for the worked examples). No item has reached the phase-1 section 3.2
authoring/preflight gate, so no real or development-corpus run has
happened yet.

## 7. Open Items For A Future Revision

- A formal `criterion_weights.schema.json` once an item's
  `criterion_definitions` package settles on a stable points representation
  (currently ad hoc `{criterion_id: points}`).
- A `method` field on `capture_quality_record.schema.json` when an
  automated capture-quality detector is approved for prototyping.
- Confirmation or replacement of every `HARNESS CONVENTION` in section 4
  by the Learning Quality Owner before the first locked-holdout run.

## 8. File Map

```text
scripts/drawn_response/
  schemas/
    observation_record.schema.json
    criterion_decision_record.schema.json
    capture_quality_record.schema.json
    partition_manifest.schema.json
    method_run_log.schema.json
  validate_records.py          # structural validation for the four JSONL/record schemas
  check_partition_manifest.py  # section 8.1 partition + governance-coverage aggregate checks
  evaluate_offline.py          # section 8.3 metrics, section 8.4 gates, section 8.5 classification
  report_offline_eval.py       # summary.json -> markdown report

docs/research/
  DRAWN_RESPONSE_ANNOTATION_HANDBOOK.md          # human-labeler procedure (spec sections 4-7)
  TASK-0011_OFFLINE_EVALUATION_HARNESS_DESIGN.md # this document
```
