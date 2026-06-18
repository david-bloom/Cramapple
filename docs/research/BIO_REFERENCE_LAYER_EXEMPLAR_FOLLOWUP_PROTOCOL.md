# Bio Reference Layer Exemplar Follow-up Protocol

**Status:** Research protocol for Product Owner review
**Owner:** Product Owner with Learning Quality Owner
**Created Date:** 2026-06-17
**Related Plan:** `docs/product/BIO_REFERENCE_LAYER_PLAN.md`
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`
**Related Inputs:** `docs/research/bio_reference_layer_spike_input_packet.md`
**Related Results:** `docs/research/bio_reference_layer_gate_aggregate_report.md`

## 1. Purpose

Test whether injecting previously-scored FRQ responses as labeled exemplars
at the top of the grading prompt closes the recurring criterion-interpretation
errors observed in the prior reference-layer gate run.

The prior gate run showed Arms BM, C, and D producing identical quality-flag
patterns. Biology reference context (cards or paragraphs) added no measurable
signal because the residual errors are rubric-interpretation errors, not
biology-knowledge errors. This protocol tests a different reference layer
shape: scored exemplars, not authored biology.

This is a narrow follow-up test, not a re-run of the gate. It reuses the
existing FRQs, responses, labels, model setting, and harness from the gate
run, and adds only one new variable: labeled exemplars in the prompt.

## 2. Hypothesis

Labeled exemplars from the same FRQ shift the model's calibration on
ambiguous criteria. Specifically:

- FRQ02-C2 under-credit (3/15 in BM) drops to 0 or 1.
- FRQ01-C2 under-credit (1/15 in BM) drops to 0.
- FRQ03-C3 under-credit (2/15 in BM) drops to 0 or 1.
- Reasoning tokens drop or hold flat versus BM, indicating the exemplars
  do real calibration work rather than triggering additional model effort.
- Schema validity stays at 100%.

The hypothesis is rejected if BM-E matches BM's 52/60 agreement without
per-criterion improvement on the targeted flags.

The primary unit of inference is paired response-by-criterion change versus
the existing BM call for the same response. Aggregate agreement is useful, but
the decisive question is whether BM-E changes the exact BM mistakes toward the
confirmed Learning Quality labels without creating new mistakes.

## 3. Source Classification

```text
exemplar source: docs/research/bio_reference_layer_spike_input_packet.md
label source: confirmed by Orly / Learning Quality on 2026-06-17
content rights: Cramapple-authored FRQs and synthetic responses
rights restrictions: none
committed_content_allowed: yes (the input packet is already committed)
model_input_allowed: yes
learner_display_allowed: no (internal test only)
```

This test does not involve the rights-restricted PDF. Exemplars are
Cramapple-authored content with confirmed internal labels.

## 4. Non-Negotiable Boundaries

- Do not modify the existing confirmed label matrix during this test.
- Do not change rubric criteria, response texts, or model setting from
  the BM baseline.
- Do not add biology-knowledge context (cards or paragraphs); this test
  isolates exemplar effect only.
- Held-out exclusion: a response is never retrieved as its own exemplar.
- Apply a near-duplicate check across response texts; if any two
  responses are near-identical, exclude one from the retrieval pool for
  the other and note the exclusion in the report.

## 5. Test Inputs

Use the exact 15 responses already confirmed in
`docs/research/bio_reference_layer_spike_input_packet.md`:

```text
FRQ01: R1, R2, R3, R4, R5
FRQ02: R1, R2, R3, R4, R5
FRQ03: R1, R2, R3, R4, R5
```

Labels come from the confirmed label matrices in Section 4, Section 5,
and Section 6 of the input packet.

## 6. Experiment Arms

### Arm BM (control, reuse prior run)

Already captured in the gate aggregate report. No new API calls required
for this arm; reuse the per-call results for comparison.

### Arm BM-E (primary treatment)

For each of the 15 responses, grade it with the other 4 responses from
the same FRQ injected as labeled exemplars at the top of the prompt.

Exemplar block format, one per exemplar:

```text
Example response:
[exemplar response text verbatim]

Criterion labels for the example:
- C1: earned | not_earned
- C2: earned | not_earned
- C3: earned | not_earned
- C4: earned | not_earned

Reviewer rationale: [Orly's reviewer note from the input packet]
```

The grading prompt then proceeds with the rubric, the held-out response,
and the existing compact-output schema. Model setting matches BM:
gpt-5.5 medium, compact output, no biology cards.

Primary BM-E must not add any new rubric language, accepted-variant rules, or
generated criterion rationales beyond the confirmed labels and reviewer notes
already present in the input packet. If criterion-specific rationales are
created later, they are a separate diagnostic arm, not the primary treatment.

### Arm BM-E-bare (diagnostic, optional)

Identical to BM-E but with reviewer rationale lines removed from the
exemplar block. Tests whether labels alone are sufficient or whether
reviewer notes carry the calibration signal.

Run BM-E-bare only if BM-E shows a positive effect, to isolate which
part of the exemplar block is load-bearing.

### Arm BM-E-targeted (diagnostic, optional)

Identical to BM-E, but only includes exemplars whose labels are relevant to the
currently targeted recurring-miss criterion or whose reviewer note directly
mentions that criterion's scoring boundary.

This tests whether fewer, more targeted exemplars beat the full four-sibling
block. Run only after BM-E, because BM-E is the cleanest first test of whether
same-FRQ scored exemplars move decisions at all.

### Arm BM-E-quote (diagnostic, optional)

Identical to BM-E but adds a grader instruction:
"For each criterion you mark earned, quote the exact phrase from the
response that earns the criterion. For each criterion you mark
not_earned, quote the closest related phrase or note its absence."

Tests whether evidence quotation reduces the prediction-criterion
over-credit errors (FRQ01-C3, FRQ03-C4) that exemplars alone may not
fix.

Run BM-E-quote only after BM-E results are in.

## 7. Required Measurements

For each call, record everything in PDF-spike-protocol Section 6, plus:

- exemplar IDs included for this call;
- exemplar token count;
- exemplar label mix by criterion, for example how many included exemplars
  were earned versus not_earned for C2;
- whether the held-out response had any near-duplicate excluded from
  the retrieval pool;
- whether reviewer notes were included.

For each arm, aggregate:

- per-criterion flag counts (over-credit, under-credit);
- paired decision changes versus BM, grouped as:
  - fixed BM error;
  - preserved BM correct call;
  - introduced new error;
  - changed from one wrong label to another wrong label;
- automated criterion agreement (target metric, BM = 52/60);
- input tokens, output tokens, reasoning tokens (deltas vs BM are the
  most interesting numbers);
- p50 and p95 latency;
- cost per call;
- schema validity rate.

The reasoning-token delta is the single most informative measurement.
The gate run showed reasoning tokens were flat across BM/C/D (286/281/291),
which is strong evidence biology context was doing no model work. A
reasoning-token change under BM-E would be the first observed evidence
that a reference layer is changing the model's internal work.

Interpret reasoning-token deltas cautiously. They are an observable proxy that
the prompt changed the model's work pattern; they do not prove why the model
changed. Quality movement toward or away from labels remains the primary
outcome.

## 8. Success Thresholds

The test supports investment in a scored-FRQ corpus if BM-E shows:

- agreement at least 56/60 (improvement of at least 4 criterion calls
  versus BM);
- FRQ02-C2 under-credit at most 1 (down from 3);
- FRQ01-C2 under-credit equal to 0 (down from 1);
- FRQ03-C3 under-credit at most 1 (down from 2);
- no new criterion-flag regressions on previously clean criteria;
- schema validity equal to 100%;
- input-token cost increase under 2x BM (acceptable trade for quality);
- p50 latency increase under 30%;
- at least 75% of BM-E decision changes versus BM are fixes rather than newly
  introduced errors.

A favorable BM-E result that also shows reasoning-token reduction or
flatness versus BM is the strongest evidence to date that a reference
layer can do real calibration work for Cramapple grading.

## 8.1 Kill Criteria

Stop or redesign the scored-exemplar investment if:

- BM-E agreement at most 52/60 (no improvement over BM);
- BM-E introduces new under-credit or over-credit flags on previously
  clean criteria;
- BM-E doubles reasoning tokens without quality improvement;
- BM-E latency exceeds BM by more than 50% at p50 without quality gain.

If BM-E improves agreement but BM-E-bare matches it, labels alone are
sufficient and reviewer notes do not need to ride in the prompt.

If BM-E does not fix the prediction over-credits but BM-E-quote does,
quotation instructions are the lever for that error class, not
exemplars.

## 9. Test Report

Create an aggregate report at:

```text
docs/research/bio_reference_layer_exemplar_test_report.md
```

Include:

- per-criterion flag count delta versus BM;
- automated agreement delta;
- input, output, and reasoning token deltas;
- cost and latency deltas;
- per-FRQ summary;
- assessment against success thresholds and kill criteria;
- recommendation on whether to invest in a scored-FRQ retrieval layer
  and which architecture (in-prompt few-shot, fine-tune, or
  human-grader calibration) the data supports.

The report must call out the reasoning-token delta explicitly. That
number is the cleanest leading indicator of whether reference context
is doing observable model work.

## 10. Pre-Flight Checklist

Do not run any API calls until the following items are complete.

### 10.1 Inputs

- [ ] Confirmed label matrices in the input packet have not changed
  since 2026-06-17.
- [ ] Near-duplicate check completed across all five responses per FRQ;
  any duplicates flagged for exclusion.

### 10.2 Prompt Template

- [ ] Exemplar block format finalized.
- [ ] Hold-out logic implemented: a response never appears in its own
  retrieval pool.
- [ ] Prompt hash recorded.
- [ ] Exemplar ordering rule fixed (recommend stable ordering by
  response ID, ascending) and held constant across all 15 BM-E runs.
- [ ] Treatment prompt differs from BM only by the exemplar block and
  exemplar-use instruction.
- [ ] Output schema adds only experiment-audit fields needed to record
  exemplar use, or else preserves the exact BM schema and records exemplar
  metadata outside model output.

### 10.3 Harness

- [ ] Reuses the gate-run measurement harness.
- [ ] Records exemplar IDs and exemplar token count per call.
- [ ] Aggregates the same fields as the gate aggregate report so
  side-by-side comparison is direct.

### 10.4 Provider Settings

- [ ] Same account, endpoint, and pricing assumptions as the gate run.
- [ ] No PDF-derived material in this test; provider settings are not
  rights-sensitive for this run.

### 10.5 Review

- [ ] Learning Quality reviewer available to spot-check at least 5
  outputs per arm for over-credit, under-credit, rubric expansion,
  invented biology, and unsafe repair.
- [ ] Reviewer specifically spot-checks cases where BM-E changes a BM decision
  to confirm the automated flag calculation matches the human interpretation.

## 11. Estimated Cost and Time

- BM-E: 15 calls. Expected cost under $0.50. Expected wall time under
  one hour including review.
- BM-E-bare: 15 calls if run. Same scale.
- BM-E-quote: 15 calls if run. Same scale.

Total budget if all three arms run: under $2 and under three hours.

## 12. Decision Points

After BM-E:

- If success thresholds met, invest in scored-FRQ retrieval design;
  draft a minimal data model for response, criterion, label, reviewer
  note, rubric version, and provenance.
- If hypothesis rejected, invest in rubric rewrites with explicit
  accepted and insufficient wording embedded in the criterion text
  itself. Do not invest in any retrieval layer for grading on
  canonical FRQs.

After BM-E-bare (if run):

- If matches BM-E, drop reviewer notes from production exemplar format
  to save input tokens.
- If underperforms BM-E, reviewer notes are load-bearing; keep them.

After BM-E-quote (if run):

- If closes prediction over-credits, quotation instruction joins
  exemplars as a separate, stackable intervention. Both can be applied
  independently or together.

## 13. Generalization Boundary

This test measures within-FRQ calibration transfer: each response is
graded with siblings on the same FRQ as exemplars.

It does not measure cross-FRQ generalization. A successful BM-E result
does not prove that exemplars from FRQ02 would help grade a different,
unseen FRQ. That is a follow-up question requiring a separate test with
a held-out FRQ design, and should be considered only after BM-E
succeeds and a scored-FRQ corpus investment is approved.

## 14. What This Test Does Not Settle

- Whether scored exemplars help on long-tail topics where the model is
  weak. (Sample is still canonical AP Bio.)
- Whether scored exemplars reduce grader drift over time and across
  rubric versions.
- Whether scored exemplars improve the authoring workbench or
  user-provided-question flows.
- Whether a fine-tuned grader on the same corpus outperforms in-prompt
  retrieval.

These remain open questions. None are blocked by this test; all are
informed by its outcome.
