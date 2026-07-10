# AP Statistics Gold-Set Candidate - 2026-07-09

**Corpus tier:** `calibration` (silver) - NOT governance `adjudicated_gold`
**Status:** Full-corpus adjudication-ready package with AI provisional labels
**Related:** DECISION-0034 (Option B); `../grading_cross_subject_takeaways.md`; `../../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12

**Calibration note:** this 2026-07-09 100-item package supersedes the 2026-07-08
5-item package for calibration runs.

## What this is / is not

- **Is:** the full 100-item AP Statistics FRQ calibration candidate set, with all synthetic responses preserved and criterion-level provisional labels attached.
- **Is not:** `adjudicated_gold`. These labels are AI provisional judgments against each item's rubric. They become gold only after two human validators score blind and a Lead adjudicates disagreements (§12.1).

## Run metadata

| Field | Value |
| --- | --- |
| Source corpus | `../ap_statistics_frq_bootstrap_corpus_2026_07_07.json` |
| Selection | full 100-item corpus export; 10 long investigative items retained for boundary calibration |
| Items / responses / criterion judgments | 100 / 220 / 320 |
| Read tier | Directional (full-corpus calibration set) |
| Label authority | AI provisional vs rubric; human adjudication pending |

## Composition

220 responses = 100 fully_correct, 58 incorrect, 42 borderline, 10 partially_correct, 10 subtly_wrong.

The 10 long items are the calibration core. They preserve the boundary-heavy response styles needed for launch-gate tuning: sampling bias and CI, experimental design, causation vs correlation, sampling design / margin of error, two-sample t inference, regression diagnostics, Bayes' theorem, chi-square / conditional probability, and the method-only regression corpus-defect item.

## Provisional label distribution

| Label | Count |
| --- | ---: |
| earned | 163 |
| partially_earned | 74 |
| not_earned | 83 |
| unable_to_determine | 0 |

## Deterministic-check targets (3)

The highest-value deterministic findings remain the familiar AP Statistics numeric slips and the method-only regression defect:

- MOD3 CI standard-error error: `120/30` instead of `120/√30`.
- MOD6 two-sample t-statistic magnitude error.
- MOD8 method-only / self-consistency grading because no dataset exists.

Those are the cases the deterministic layer should catch or explicitly abstain from before human scoring.

## Adjudication queue (30 rows)

The queue stays focused on boundary and over/under-credit risks rather than routine binary items. Highest-value rows include the long investigative tasks, with the deterministic numeric misses and the MOD8 corpus defect explicitly flagged.

## Corpus defect - resolved 2026-07-09

- **APSTAT-MOD8-H001 supplies no dataset.** Responses fabricate `r` and regression values, so numeric claims are not fixed-keyed. The rubric is scoped to method/self-consistency grading, not real-data value matching.
- **APSTAT-MOD6-H007 rounds the confidence level too high.** The authored response says roughly 67% for a halved-width interval, but the exact two-sided confidence implied by halving the 90% interval width is about 58.9%. The deterministic key file uses the exact value and flags this item for content review.

## How to upgrade to `adjudicated_gold`

1. Assign `blind_scoring_template.csv` to two qualified Grading Validators; they fill `validator_A/B_label` + evidence quotes blind to the AI labels and each other.
2. Lead adjudicates every disagreement; record in `final_gold_label`.
3. Where adjudication reveals rubric ambiguity, revise the boundary contract rather than flattening the label.
4. Re-tier the package `adjudicated_gold` and record the promotion decision.

## Files

- `manifest.json` - package metadata, composition, distribution
- `provisional_labels.json` - criterion-level AI labels with evidence, confidence, adjudication flags
- `blind_scoring_template.csv` - empty dual-scoring sheet for human validators
- `adjudication_queue.csv` - response-level shortlist of boundary cases for human focus
- `adjudication_workflow.md` - operational workflow for promotion
