# Third-Opinion Grading Issues — 2026-07-08

Scope: reviewed the adjudication queues plus a random sample of high-confidence
labels across AP Biology, AP Chemistry, and AP Statistics. Most sampled
high-confidence labels were consistent with the rubric. The items below are the
best candidates for a third opinion because they look like genuine boundary
calls, possible under-credit, or corpus defects that would distort gold-set use.

## Likely boundary calls

| Priority | Subject | Item | Criterion | Current label | Why this needs a third opinion |
| --- | --- | --- | --- | --- | --- |
| High | Biology | `APBIO-FRQ-L-001` | `a_i` | `partially_correct` | The value is right, but the explanation only says "net O2 = 0" instead of explicitly stating photosynthesis rate = respiration rate. Need a decision on whether the partial explanation still earns. |
| High | Biology | `APBIO-FRQ-L-001` | `b` | `not_earned` | The response gets one mechanistic piece right but reverses proton pumping. Need a strictness call on whether one correct element should earn partial credit. |
| High | Biology | `APBIO-FRQ-L-009` | `b` | `borderline` | The pathway is mostly right, but the response omits organism names and nitrate reduction. Need a call on how much named detail the rubric requires. |
| Medium | Biology | `APBIO-FRQ-L-033` | `b` / `c` | `borderline` | The response implies alcoholic fermentation and a shift to aerobic respiration, but does not name pyruvate decarboxylation or give deeper CO2/NADH detail. Need a depth threshold decision. |
| Medium | Chemistry | `APCHEM-FRQ-L-041` | `verification` | `borderline` | The comparison is stated, but magnitudes are not fully spelled out. Need a call on whether that is enough for the verification criterion. |
| High | Statistics | `APSTAT-MOD5-H001-INV` | `experimental_conclusion` | `borderline` | The conclusion is in context, but only one assumption is stated and the rubric wants at least two. Need a strictness decision on assumption count. |
| High | Statistics | `APSTAT-MOD6-H001` | `conclusion` | `partially_correct` | The response reads like full credit: correct hypotheses, correct t/p, correct conclusion. Need a third opinion on whether the current partial label is under-credit. |
| High | Statistics | `APSTAT-MOD7-H001` | `calculation` | `partially_correct` | The response appears to compute the correct value cleanly. Need a third opinion on whether this is also under-credit. |

## Corpus defects to exclude or fix

| Priority | Subject | Item | Issue |
| --- | --- | --- | --- |
| High | Statistics | `APSTAT-MOD8-H001` | No dataset is supplied, so correlation/regression values are unverifiable. This should be excluded from gold-set decisions or rewritten with actual data. |

## Already-resolved or not worth re-litigating

- `APBIO-FRQ-L-009 / subtly_wrong / a` was already corrected to `partially_earned` in the label file after review, so it is not a live discrepancy.
- Most other high-confidence labels in the sampled set looked aligned with the rubric and do not need third review.

## Suggested question for the third reviewer

For each issue above, answer: "Does this response earn the current label as written, or should the label move one step up or down based on the rubric language?"
