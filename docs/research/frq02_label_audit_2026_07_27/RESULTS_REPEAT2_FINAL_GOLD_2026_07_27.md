# FRQ-02 Frozen Repeat Against Final Gold — 2026-07-27

## Decision

The grader's quality and cost are confirmed at n=40. Its 1,000-ms speed target
is not confirmed. Do not spend on the FRQ-02 n=100 run yet.

The next experiment should be a small, paired, cross-subject architecture test
of four parallel criterion calls versus one structured multi-criterion call.
The purpose is to reduce request fan-out and max-of-four tail latency while
holding the adjudicated criterion contracts and model constant.

## Final-gold adjudication

The 23 audited corrections were promoted to final gold by repository-owner
direction:

- 17 C2 corrections: `earned` → `not_earned`
- 5 C3 corrections: `not_earned` → `earned`
- 1 C1 correction: `earned` → `not_earned`
- 0 C4 corrections

The original generated JSONL remains unchanged. The final-gold JSONL contains
100 responses and 400 labels, recomputes `points_labeled` and reviewer
summaries, and stores the prior value and rationale for every changed label.

## Frozen repeat

The repeat used the same model, prompt, boundary tables, token cap, timeout,
parallelism, prefilter, response selector, and 40 response IDs as the first
confirmation. No audit or escalation ran after the model. The only input change
was using the adjudicated JSONL for the recorded `human_status`; gold labels are
not included in model prompts.

| Measure | Confirmation 1 | Confirmation 2 | Combined interpretation |
| --- | ---: | ---: | --- |
| Final-gold agreement | 151/160 (94.4%) | 155/160 (96.9%) | Quality confirmed above 90% |
| Schema-valid | 159/160 (99.4%) | 160/160 (100%) | One transient failure across 320 calls |
| FRQ p50 | 1,041 ms | 1,348 ms | Speed target failed twice |
| FRQ p95 | 2,411 ms | 2,395 ms | Tail is stable around 2.4 seconds |
| FRQ max | 3,163 ms | 3,570 ms | High but below criterion timeout |
| Answers ≤1,000 ms | 15/40 | 1/40 | Repeat was materially slower |
| Mean cost/FRQ | $0.001393 | $0.001398 | Cost is stable and well below $0.01 |
| Total paid cost | $0.05572 | $0.05590 | $0.11162 across both confirmations |

The two runs returned the same verdict on 156/160 criteria (97.5%). All four
verdict changes improved from incorrect in run 1 to correct in run 2. Pooled
final-gold agreement is 306/320 (95.6%).

## Criterion behavior

| Criterion | Confirmation 1 | Confirmation 2 |
| --- | ---: | ---: |
| C1 — identify drift/bottleneck | 40/40 | 40/40 |
| C2 — event-level randomness/non-selection | 33/40 | 36/40 |
| C3 — reduced later diversity | 40/40 | 40/40 |
| C4 — small-population mechanism | 38/40 | 39/40 |

Five errors persisted identically across both runs:

- C2 false positives: `S020`, `S028`, `S062`, and `S068`
- C4 false negative: `S067`

The C2 errors share one structure: the model infers event-level randomness from
nearby statements about random outcomes, fitness, or survivors instead of
enforcing the frozen attribution boundary. The C4 error shows a different
structure: a correct local mechanism is under-credited because the response
also contains an incorrect conclusion. This is criterion leakage.

## Extensible lessons across subjects

| General grading rule | Evidence here | Cross-subject application |
| --- | --- | --- |
| Separate cause, operation, and outcome into distinct criterion contracts. | C2 and C4 were conflated in the source labels and by the model. | Statistics: method conditions vs. numerical conclusion. Chemistry: causal particle explanation vs. observed trend. Physics: force model vs. resulting motion. |
| Specify semantic attachment, not just keywords. | “Random” must modify destruction/survival, not merely allele frequency. | Calculus: a theorem condition must apply to the stated interval/function. Statistics: randomization must apply to treatment assignment or sampling, not merely a variable. |
| Grade criteria locally unless the rubric explicitly couples them. | `S067` earns the small-population mechanism even though its diversity conclusion is wrong. | Error-carried-forward in statistics, calculus, chemistry calculations, economics, and physics should preserve downstream method credit when appropriate. |
| Treat negation, hedging, temporal scope, and contradiction policy as first-class boundary fields. | C1 negation and C3 “later generations” produced five source-label errors. | “Not significant,” “may,” “initially,” “at equilibrium,” and contradictory later sentences routinely reverse credit across subjects. |
| Accept equivalent representations; do not require canonical wording. | Boundary tables credit drift/bottleneck variants while rejecting wrong relationships. | Algebraic equivalence, units, graph encodings, chemical equations, and statistically equivalent interpretations need deterministic or enumerated equivalence handling. |
| Use deterministic verification where the construct permits it; abstain on ambiguity. | C2’s grammatical target is structurally checkable, though brittle parser rules previously overfit. | Formula equivalence, numeric tolerance, units, graph coordinates, and ECF propagation should be checked deterministically; ambiguous transcription should route to review rather than false-fail. |
| Gold creation is semantic work, not JSON validation. | The source was structurally complete and marked approved, yet 23/400 labels required correction. | Every subject needs criterion-level adjudication, invariant checks, and documented near-misses before model accuracy is meaningful. |
| Measure repeatability and weak criteria, not only aggregate accuracy. | Overall quality exceeded 94%, while C2 remained the persistent error cluster. | Report by skill/criterion archetype and use paired repeats; an aggregate subject score can hide a launch-blocking boundary. |
| Parallel criterion calls amplify tail latency. | FRQ latency is the maximum of four model calls; p50 missed twice despite cheap, accurate outputs. | Any multi-part FRQ in any subject will inherit the same max-of-N latency penalty. Request architecture is a cross-subject concern, not a biology concern. |
| Use multiple models to audit boundaries, not to vote on grades. | Persistent disagreement localized ambiguous contracts; routing/escalation did not reliably solve them. | Model disagreement should trigger rubric review and corpus enrichment, while production keeps one measurable primary path. |

## Reusable criterion-contract schema

Every subject's rubric criterion should carry the same fields:

1. **Target proposition** — the single fact, operation, relationship, or
   conclusion being scored.
2. **Sufficient evidence** — affirmative examples and accepted equivalents.
3. **Insufficient near-misses** — adjacent ideas, correct keywords attached to
   the wrong object, and incomplete work.
4. **Scope** — which part, variable, interval, population, time horizon, or
   experimental stage the statement must concern.
5. **Polarity policy** — treatment of negation, hedging, uncertainty, and
   self-correction.
6. **Contradiction policy** — whether a later error cancels local credit.
7. **Dependency/ECF policy** — whether correct downstream work using an earlier
   wrong value earns credit.
8. **Deterministic checks** — equivalence, arithmetic, units, graph structure,
   or other checks that can safely return pass/flag/abstain.
9. **Minimal repair** — the smallest change that would earn the criterion.

This schema is the portable result of the FRQ-02 work. The biology-specific
boundary text is not.

## Next experiment

Build a 20-answer adjudicated anchor set:

- one representative FRQ each from Biology, Statistics, Calculus, Chemistry,
  and Physics;
- four answers per FRQ: clearly correct, clearly incorrect, one
  cause/operation/outcome near-miss, and one contradiction/ECF near-miss.

Run two otherwise identical Gemini arms:

1. current four-parallel-criterion calls;
2. one structured call returning all criterion verdicts.

Use one paired run first. Gate advancement on:

- ≥90% strict criterion agreement overall and no subject below 85%;
- 100% schema validity;
- p50 end-to-end ≤1,000 ms;
- no material regression on contradiction/ECF cases;
- cost ≤$0.01 per FRQ.

Only after that architecture clears the cross-subject anchor should FRQ-02
expand to n=100.
