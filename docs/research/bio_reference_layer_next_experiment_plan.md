# Bio Reference Layer Next Experiment Protocol

**Status:** Draft protocol for planning review  
**Date:** 2026-06-18  
**Owner:** Product Owner with Learning Quality Owner  
**Routing:** Vercel AI Gateway by default  
**Related Memo:** `docs/research/bio_reference_layer_next_planning_memo.md`  
**Related Results:**  
- `docs/research/bio_reference_layer_gated_prompt_test_report.md`
- `docs/research/bio_reference_layer_oracle_boundary_test_report.md`
- `docs/research/bio_reference_layer_flywheel_volume_test_report.md`

## 1. Purpose

Test whether the next useful gain comes from boundary precision and compact
boundary memory rather than exemplar-heavy retrieval or online flywheel volume.

This protocol is deliberately narrower than the prior reference-layer spike.
It does not try to prove that references are generally useful. It tries to
identify the smallest change that improves single-FRQ grading speed without
creating new boundary errors.

## 2. Working Conclusion From Prior Runs

The prior runs support three narrow conclusions:

1. Gated prompting alone did not improve strict C2 agreement.
2. Oracle-selected precedents contain some calibration signal, but the exemplar
   retrieval design was not operationally competitive.
3. The 100-answer flywheel validated the harness, but did not improve final-50
   quality or reduce FRQ02-C2 under-credit.

The practical implication is that rubric-boundary precision and grader
orchestration are the more likely bottlenecks than raw reference volume.

The SP-1 summary adds one more constraint on the next pass: before we make any
promotion decision, apply the same error-vs-reviewer-note diagnostic to
FRQ02-C1, FRQ02-C3, and FRQ02-C4 so the C2 findings stay interpreted in the
full rubric context.

## 3. Core Hypothesis

If the recurring FRQ02-C2 errors are boundary-definition problems rather than
memory-coverage problems, then:

- a compact boundary-table memory will outperform exemplar retrieval on the
  clear subset;
- lower-reasoning boundary memory will be sufficient for the clear subset;
- a fast primary model with escalation will recover most of the speed win
  without introducing unacceptable quality loss.

## 4. Hypotheses

### H1: Boundary clarification reduces the recurring FRQ02-C2 cluster.

If the FRQ02-C2 rubric boundary is rewritten into a sharper contract, then the
boundary-conflict cluster should move toward the intended labels without a
material increase in opposite-direction errors.

Expected signal:

- lower over-credit on the recurring FRQ02-C2 cluster;
- no new under-credit spike on the same cluster;
- fewer boundary-interpretation disagreements in review.

### H2: Compact boundary-table memory beats exemplar retrieval.

If bulky exemplars are replaced with a short boundary table plus required
evidence extraction, then quality should be at least as good as the exemplar
arms while cost and latency drop.

Expected signal:

- better strict agreement than the exemplar arms on the clear subset;
- lower input tokens than the oracle-precedent arm;
- lower p50 and p95 latency than the oracle-precedent arm;
- no increase in schema failures.

### H3: Lower-reasoning boundary memory is sufficient on the clear subset.

If the boundary table is compact enough, then `gpt-5.5` low reasoning should
stay close to `gpt-5.5` medium reasoning on the clear subset while reducing
cost and latency.

Expected signal:

- clear-subset strict agreement within 2 percentage points of `BM-Control`;
- lower latency than medium-reasoning control;
- lower cost than medium-reasoning control;
- stable schema validity.

### H4: Fast-primary plus escalation can replace the medium-reasoning baseline.

If a fast primary model is paired with `gpt-5.5` medium escalation, then the
result should hit the speed target while keeping clear-subset quality within an
acceptable band.

Expected signal:

- FRQ p50 materially below `BM-Control`;
- escalation rate remains modest;
- schema failures remain rare after escalation;
- clear-subset strict agreement stays within 5 points of control.

### H5: Provider choice matters less than prompt shape once routed through the gateway.

If prompt shape and boundary memory are held constant, then the fastest usable
provider/model combination should be identifiable through the gateway without a
new retrieval strategy.

Expected signal:

- one of `gpt-4o-mini`, `claude-haiku-4-5`, or `gemini-2.5-flash` matches or
  beats the current fast arm on clear-subset quality at similar latency;
- no provider-specific prompt rewrite is required;
- gateway routing overhead stays small enough to keep the gateway in the
  production path.

## 5. Test Arms

### Control

- `BM-Control`: `gpt-5.5` medium, no memory, compact output.

### Boundary-Memory Arms

- `Boundary-Table`: compact rubric-boundary memory with required evidence
  extraction.
- `Boundary-Table-Low`: same as above with `gpt-5.5` low reasoning.

### Fast-Primary Arms

- `SP-FAST`: `gpt-4o-mini` primary, no escalation.
- `SP-FAST-ESC`: `gpt-4o-mini` primary with `gpt-5.5` medium escalation.
- `SP-FAST-Haiku`: `claude-haiku-4-5` primary, no escalation.
- `SP-FAST-Gemini`: `gemini-2.5-flash` primary, no escalation.

## 6. Non-Negotiable Boundaries

- Use Vercel AI Gateway for the default route.
- Do not change rubric text during the run.
- Do not reintroduce exemplar retrieval into the primary test arms.
- Do not use the raw flywheel volume design as a production candidate unless a
  later run is explicitly designed to test that hypothesis.
- Keep the FRQ02-C2 boundary-conflict cluster frozen for comparison.
- Do not interpret ambiguous-cluster movement as a model-quality win until the
  boundary is adjudicated.

## 7. Test Inputs

Use the same FRQ02 response corpus family already used in the prior spike runs,
with the FRQ02-C2 ambiguity cluster retained. If a new corpus is used, it must
be explicitly labeled as harder or borderline and must preserve paired control
comparison.

The preferred corpus properties are:

- enough borderline cases to expose boundary precision;
- enough clear cases to measure speed-quality tradeoffs;
- no synthetic reshaping that would hide the recurring C2 failure mode.

## 8. Required Measurements

For every arm, record:

- strict agreement;
- clear-subset strict agreement;
- under-credit and over-credit counts by criterion;
- schema validity;
- input, output, and reasoning tokens;
- p50 and p95 latency;
- cost per FRQ;
- escalation rate, where applicable;
- gateway routing metadata;
- paired changes versus control.

For paired changes versus control, record:

- fixed errors;
- new errors;
- unchanged calls;
- regressions concentrated in the FRQ02-C2 boundary cluster;
- whether any new error pattern appears outside the boundary-conflict slice.

## 9. Success Thresholds

### Boundary-Memory Success

The boundary-memory path is promising if `Boundary-Table` or
`Boundary-Table-Low` shows all of:

- better strict agreement than exemplar-heavy arms on the clear subset;
- lower cost than `oracle_precedents`;
- lower latency than `oracle_precedents`;
- no schema-regression relative to `BM-Control`;
- at least 75% of decision changes versus control are fixes rather than new
  errors.

### Fast-Path Success

The fast-path is promising if `SP-FAST-ESC` shows all of:

- FRQ p50 materially below `BM-Control`;
- FRQ p95 materially below `BM-Control` or at least stays within the current
  speed target;
- clear-subset strict agreement within 5 percentage points of `BM-Control`;
- schema-failure rate below 1 percent after escalation;
- per-criterion timeout rate below 2 percent.

### Provider Comparison Success

A provider comparison arm is promising if it matches or beats `SP-FAST` on the
clear subset at similar latency and does not require a different prompt shape.

## 10. Kill Criteria

Stop or redesign the next step if any of the following happens:

- `Boundary-Table` does not beat the exemplar-heavy arms on quality and cost;
- `Boundary-Table-Low` loses the clear subset and gains nothing on speed;
- `SP-FAST-ESC` misses the speed target and fails to stay close enough in
  quality;
- schema failures rise instead of falling after escalation;
- the recurrence on FRQ02-C2 still looks like a rubric-definition problem
  rather than a memory problem.

If all arms fail, the conclusion should be that boundary redesign is the next
lever, not another reference-layer variant.

## 11. Procedure

1. Freeze the current interpretation of the FRQ02-C2 boundary-conflict cluster.
2. Run `BM-Control` on the chosen corpus.
3. Run `Boundary-Table` and `Boundary-Table-Low`.
4. Run `SP-FAST`, `SP-FAST-Haiku`, and `SP-FAST-Gemini` through the gateway.
5. Add `SP-FAST-ESC` if the fast primary appears viable but needs a safety net.
6. Compare all arms against control with paired response-by-criterion changes.
7. Apply the same boundary diagnostic to FRQ02-C1, FRQ02-C3, and FRQ02-C4
   before any promotion or kill decision.
8. Write the follow-up report using the same table shapes as the prior
   reference-layer reports.

## 12. Analysis Plan

- Decide the hypotheses directly from the pre-registered metrics above.
- Report clear-subset and ambiguous-subset results separately.
- Do not present ambiguous-cluster movement as evidence of model quality until
  the boundary is adjudicated.
- For `SP-FAST-ESC`, report primary-only and escalated cases separately before
  pooling them.
- For provider comparisons, treat latency parity as a prerequisite for any
  quality-based recommendation.

## 13. Decision Rule

Promote the next direction based on the first arm that clears both of these:

- it improves the relevant speed metric;
- it does not introduce a new grading-quality problem.

If no arm clears both, then the next experiment should focus on boundary
redesign rather than more reference material.
