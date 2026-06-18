# Bio Reference Layer Flywheel Volume Test Protocol

**Status:** Draft protocol for Product Owner review
**Owner:** Product Owner with Learning Quality Owner
**Created Date:** 2026-06-17
**Related Results:** `docs/research/bio_reference_layer_exemplar_test_report.md`

## 1. Purpose

Test whether a growing scored-answer corpus improves grading performance over
time for a single FRQ.

The prior BM-E test showed that same-FRQ scored exemplars moved one recurring
criterion error but did not justify a broad whole-response exemplar layer. This
protocol tests a sharper flywheel hypothesis:

```text
As Cramapple accumulates more confirmed scored answers for one FRQ, grading
agreement should improve on later answers because the model retrieves better
criterion-level precedents.
```

This test comes before broader grader-agent optimization. It asks whether
scored-answer volume compounds at all.

## 2. Primary Hypothesis

For one FRQ with many fresh answers, online retrieval from an expanding
confirmed-precedent library improves criterion-level agreement over the
no-memory BM control.

Expected signal:

- early answers perform near BM;
- later answers perform better as the precedent library grows;
- recurring rubric-threshold misses drop as relevant precedents accumulate;
- improvement is visible in moving-window agreement, not only final aggregate.

The hypothesis is rejected if performance does not improve as confirmed
precedent volume increases, or if gains come with unacceptable new over-credit
or under-credit patterns.

## 3. Recommended FRQ

Start with `SPIKE-FRQ-02` from the prior spike.

Reason:

- It produced the clearest calibration miss: `FRQ02-C2` under-credit.
- The scoring boundary is conceptually narrow: random/non-selective bottleneck
  versus natural selection.
- Synthetic answer variation is easy to generate without needing complex
  long-tail biology.

Target criterion:

```text
FRQ02-C2: Explains that the construction event is random/non-selective with
respect to flower-color fitness.
```

Secondary criteria:

```text
FRQ02-C1: identifies drift/bottleneck.
FRQ02-C3: predicts reduced genetic diversity.
FRQ02-C4: explains small-population drift, allele loss/fixation, or reduced
heterozygosity without mutation/gene flow restoring variation.
```

## 4. Test Shape

Use an online replay design.

1. Generate a large set of fresh synthetic answers for one FRQ.
2. Label the answers before scoring analysis uses them as ground truth.
3. Randomize answer order.
4. For answer `N`, grade using only confirmed precedents from answers
   `1..N-1`.
5. After grading answer `N`, reveal its confirmed label and add it to the
   precedent library.
6. Track performance after every answer.

Important: never add the model's unverified score as a precedent. Only add a
confirmed label.

## 5. Data Generation

Initial batch size:

```text
100 fresh synthetic responses for SPIKE-FRQ-02
```

Recommended distribution:

- 20 clearly full-credit answers;
- 20 clearly wrong natural-selection answers;
- 20 near-miss answers that identify bottleneck/drift but omit or blur
  randomness/non-selectiveness;
- 20 answers with correct random/non-selective logic but weak later diversity
  reasoning;
- 20 mixed, messy, student-like partial answers with irrelevant details,
  imprecise vocabulary, or contradictions.

Generation should be done with a lower-cost model if desired, but the generated
answers must not include labels in the same text shown to the grader.

## 6. Ground Truth Labels

Each generated response needs criterion-level labels before it can be used for
measurement.

Allowed label sources, in descending confidence:

1. Learning Quality human labels.
2. Product Owner provisional labels plus Learning Quality spot-check.
3. Separate adjudication model plus human spot-check of all borderline cases.

Do not use the BM or BM-flywheel grader's own output as the ground-truth label.

Minimum label fields:

```text
response_id
criterion_id
label: earned | not_earned | unable_to_determine
reviewer_note
boundary_tags
```

Boundary tags should be compact, for example:

```text
random_nonselective_explicit
allele_loss_implies_random_bottleneck
selection_language
random_mating_fallacy
mutation_gene_flow_contradiction
```

## 7. Precedent Unit

Use criterion-level precedents, not whole-response blocks.

Format:

```text
Precedent ID: FRQ02-C2-P0031
Criterion: FRQ02-C2
Response phrase or compact excerpt: "the alleles were lost by chance when most
plants were destroyed"
Label: earned
Boundary reason: Treats survival/allele loss as random sampling, not
fitness-based selection.
Tags: random_nonselective_explicit, allele_loss
Rubric version: spike-frq02-v1
```

Keep each precedent short. The goal is calibrated scoring boundary memory, not
full answer replay.

## 8. Retrieval Rule

For each criterion, retrieve:

```text
up to 3 earned precedents
up to 3 not-earned precedents
```

Hard cap:

```text
max_total_precedent_tokens: 500
```

Retrieval should prefer:

- same criterion;
- matching boundary tags;
- lexical similarity to the held-out response phrase;
- diversity of labels, so the prompt includes both earned and not-earned
  boundaries when possible.

For the first prototype, retrieval can be deterministic and tag-based before
embedding search exists.

## 9. Experiment Arms

### Arm BM-Control

Grade every fresh answer with the existing BM prompt:

```text
gpt-5.5 medium + compact output + no exemplars
```

This can be run once across all 100 answers.

### Arm BM-Flywheel

Grade the same answer sequence with:

```text
gpt-5.5 medium + compact output + retrieved criterion precedents
```

For answer `N`, the precedent library may only contain labels from answers
`1..N-1`.

### Arm BM-Oracle-Retrieval, Optional Diagnostic

Same as BM-Flywheel, but allows retrieval from the full labeled corpus except
the held-out answer.

This estimates the upper bound if the corpus were already mature. It must not
be confused with the online flywheel result.

## 10. Metrics

Record after every answer:

- criterion-level agreement for BM-Control;
- criterion-level agreement for BM-Flywheel;
- per-criterion over-credit and under-credit;
- moving-window agreement over the last 10 answers;
- cumulative agreement through answer `N`;
- number of confirmed precedents available before the call;
- number of precedents retrieved;
- retrieved precedent token count;
- input tokens;
- output tokens;
- reasoning tokens;
- latency;
- estimated cost;
- schema validity.

Primary chart:

```text
x-axis: answer index
y-axis: moving-window criterion agreement
series: BM-Control, BM-Flywheel
```

Secondary charts:

- `FRQ02-C2` under-credit rate by answer index bucket;
- cost per answer by answer index;
- reasoning tokens by answer index;
- precedent-library size versus agreement.

## 11. Success Thresholds

The flywheel hypothesis is supported if:

- BM-Flywheel beats BM-Control by at least 5 percentage points in criterion
  agreement over the final 50 answers;
- `FRQ02-C2` under-credit is at least 50% lower than BM-Control over the final
  50 answers;
- no criterion shows a new over-credit or under-credit pattern worse than
  BM-Control;
- schema validity remains 100%;
- p50 latency increase is under 30%;
- average cost increase is under 50%.

The hypothesis is strongly supported if performance improves monotonically or
near-monotonically across precedent-volume buckets:

```text
0-9 precedents
10-24 precedents
25-49 precedents
50-99 precedents
```

## 12. Kill Criteria

Stop or redesign the flywheel approach if:

- BM-Flywheel does not beat BM-Control over the final 50 answers;
- improvement appears only in the oracle-retrieval diagnostic, not the online
  flywheel arm;
- BM-Flywheel reduces under-credit by becoming broadly over-generous;
- retrieved precedents increase reasoning tokens or latency without quality
  gain;
- performance depends on full-response exemplars rather than compact
  criterion-level precedents.

## 13. Order Effects

Because online learning depends on answer order, run at least three shuffled
orders if the first run is promising.

Minimum:

```text
one 100-answer order for a smoke result
three 100-answer orders for a decision result
```

Report mean and range across orders.

## 14. What This Test Settles

This test can answer:

- whether confirmed scored-answer volume compounds for one FRQ;
- whether criterion-level precedents beat no-memory BM on rubric calibration;
- whether the memory layer improves as the library grows;
- whether the value comes before or only after a corpus reaches meaningful
  size.

This test does not answer:

- whether precedents generalize across FRQs;
- whether real student responses can be used without additional consent and
  privacy policy work;
- whether fine-tuning would beat retrieval;
- whether this works in other AP subjects.

## 15. Recommended Next Action

Create the 100-answer synthetic FRQ02 corpus and label it before running model
grades. The smallest useful execution sequence is:

1. Generate 100 synthetic FRQ02 answers.
2. Create provisional criterion labels and boundary tags.
3. Spot-check labels before model grading.
4. Run BM-Control and BM-Flywheel on one randomized order.
5. Review the moving-window curve and `FRQ02-C2` error curve.
