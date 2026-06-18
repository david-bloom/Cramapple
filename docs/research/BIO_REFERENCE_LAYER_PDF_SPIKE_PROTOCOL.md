# Bio Reference Layer PDF Spike Protocol

**Status:** Research protocol for Product Owner review
**Owner:** Product Owner with Learning Quality Owner
**Created Date:** 2026-06-16
**Related Plan:** `docs/product/BIO_REFERENCE_LAYER_PLAN.md`

## 1. Purpose

Test whether a compact biology reference layer is likely to reduce grading
latency, token use, and cost before Cramapple invests in production design,
development, expert authoring, or source licensing.

This spike may use the local PDF `AP-Biology-Study-Guide.pdf` as a temporary,
rights-restricted research input. The spike must not turn the PDF into
Cramapple source material.

## 2. Source Classification

```text
source_name: AP-Biology-Study-Guide.pdf
observed_title: AP Biology Study Guide
observed_author_metadata: Eric Titner
observed_created_date: 2020-04-20
observed_page_count: 69
source_status: needs_rights_review
rights_status: unlicensed for product use
allowed_spike_use: temporary internal concept test only
model_input_allowed: spike_only_with_product_owner_direction
content_generation_allowed: no
learner_display_allowed: no
committed_content_allowed: no
```

## 3. Non-Negotiable Boundaries

- Do not commit extracted PDF text, sample questions, explanations, figures, or
  derivative cards to the repository.
- Do not use PDF sample questions as Cramapple beta questions.
- Do not adapt PDF explanations into learner-facing Cramapple feedback.
- Do not use the PDF to generate production-ready content.
- Do not mark any PDF-derived card as reviewed, licensed, released, or
  Cramapple-authored.
- Do not send PDF-derived text or cards to a model provider until the Product
  Owner confirms the provider's data-retention, training, and model-input
  settings are acceptable for this spike.
- Store temporary extraction and generated cards only outside the repository,
  preferably under `/private/tmp/cramapple-bio-ref-spike/`.
- Delete or quarantine temporary artifacts after the spike report is written.

## 4. Test Question Inputs

Preferred inputs:

1. The six original Cramapple summer-beta short FRQs, once available.
2. If the six FRQs are not yet available, use two to four original throwaway
   AP-style short FRQs created from blank briefs solely for measurement.

These are different test modes. A six-beta-FRQ run can inform beta-specific
cost, speed, and quality risk. A throwaway-FRQ run is only a concept test for
whether compact reference context is worth further investment.

The PDF should supply temporary biology reference context only. It should not
supply test questions, rubrics, student responses, or answer keys.

Each test item needs:

- original question text;
- four independent rubric criteria;
- three to five synthetic student responses spanning weak, partial, and strong;
- expected human criterion labels before the run;
- topic tags that can select the relevant PDF section.

## 5. Experiment Arms

### Arm A - Current Baseline

Grade each response with the current rubric-only grading prompt and current
output format:

- question;
- rubric;
- student response;
- no biology reference cards;
- current structured output.

Record the exact prompt version or hash used for Arm A. Reuse the same base
prompt hash across all arms unless the arm explicitly varies the output schema
or reference context.

### Arm B - Compact Schema Only

Grade each response with no reference cards but with the strict compact output
schema proposed for the reference-layer grader.

This arm tests the cheapest thing that might work: prompt and output-format
compression without any card infrastructure.

### Arm C - Verbose Biology Context

Grade the same response with a short, non-card-format biology paragraph
covering the same relevant concept as the compact cards.

This arm tests whether the improvement comes from having relevant biology in
context at all, rather than from the card structure.

Match Arm C's reference-context token count to Arm D's reference token count
within approximately 10% whenever possible. This isolates card structure from
mere compression.

### Arm D - Disposable Compact Cards

Grade the same response with temporary cards made from the PDF section relevant
to the question topic.

Temporary cards should be generated or drafted outside the repository and
passed into the grader as:

- concept card;
- mechanism-chain card where relevant;
- accepted-variant card only when explicitly rubric-bound;
- insufficient-wording card where over-credit risk is likely;
- misconception card where relevant;
- repair-move card where relevant.

Hard caps:

```text
max_cards: 8
max_total_reference_tokens: 900
```

### Arm D-prime - Compact Cards Without Mechanism Chain

For any FRQ where a mechanism chain is central to a high-value criterion, run
an additional compact-card variant that excludes mechanism-chain cards.

This isolates whether mechanism-chain cards improve grading or cause
over-generous pattern matching.

### Arm E - Overstuffed Context Check

Optionally grade with a larger topic excerpt or overlong reference summary to
confirm that compact cards, not raw context stuffing, are responsible for any
improvement.

This arm is diagnostic only. It is not a proposed product design.

## 6. Required Measurements

For every grading call, record:

- experiment arm;
- model identifier;
- reasoning effort or equivalent setting;
- prompt version;
- prompt hash;
- output schema version;
- prompt-caching status;
- cached-token count when available;
- question ID;
- response ID;
- input tokens;
- output tokens;
- reasoning tokens when available;
- reference token count;
- app latency;
- provider latency;
- total latency;
- estimated initial-grade call cost;
- estimated full-attempt cost when repair, regrade, malformed-output retries,
  or provider retries are included;
- schema-valid output;
- timeout or retry;
- points earned;
- criterion statuses;
- highest-value gap;
- minimum fix length;
- confidence;
- uncertainty reason.

Run the model comparison in a way that directly tests the business case:

```text
high model / no cards / current output
high model / compact output / no cards
medium model / compact output / no cards
medium model / compact cards
```

If prompt caching is available in the expected runtime, measure with caching on
and off or explicitly state which mode the results assume.

Evaluate kill criteria against uncached numbers unless the intended production
runtime is already confirmed to use prompt caching for the stable prompt,
rubric, and card prefixes. Cached results may be reported as upside before
production caching is confirmed.

## 7. Quality Checks

For each response, compare all arms against human labels when available. At
minimum, manually inspect:

- over-credit;
- under-credit;
- rubric expansion;
- invented biology;
- vague feedback;
- unsafe or answer-leaking repair;
- whether the highest-value gap is useful;
- whether the output is shorter without becoming less helpful.

Internal model-to-model agreement is not enough. A faster, cheaper grader that
is consistently wrong does not validate the reference-layer concept.

A one-question, three-response pilot cannot statistically prove quality
non-regression. Report quality from that run as manual spot-check only. Use a
larger sample before making a beta-shipping quality claim.

## 8. Success Thresholds

The spike supports further investment only if compact cards show value beyond
compact schema alone and beyond token-matched generic biology context.

For the smallest pilot, treat thresholds as directional investment signals,
not statistical proof. Apply the 25% cost and 20% latency gates as actual
continue/stop criteria only after a larger pilot. Two FRQs with five responses
each is the floor; three FRQs with five responses each is the recommended gate
sample.

Continue only if Arm D shows:

- at least 25% lower estimated initial-grade cost than the relevant baseline,
  or a clear path to that reduction under prompt caching;
- at least 20% lower p50 latency than the relevant baseline;
- better cost or latency than Arm B compact-schema-only;
- better cost, latency, or quality than Arm C token-matched verbose biology
  context;
- no worse manual over-credit behavior than Arm D-prime where D-prime is run;
- no material increase in over-credit, under-credit, or rubric-expansion
  defects;
- equal or better schema validity;
- more precise highest-value-gap and minimum-fix outputs.

The spike does not approve production use of the PDF or any PDF-derived cards.

## 8.1 Kill Criteria

Stop or redesign the reference-layer investment if:

- Arm B, compact schema only, delivers most of the savings without cards;
- Arm D is not at least 25% cheaper and 20% faster than the relevant baseline
  in the larger pilot;
- Arm C token-matched verbose biology context performs as well as Arm D;
- Arm D-prime shows materially safer grading than Arm D for mechanism-heavy
  FRQs;
- Arm D increases over-credit, rubric expansion, invented biology, or unsafe
  repair in manual review;
- medium-with-cards does not approach high-baseline quality closely enough to
  justify authoring and review cost;
- provider terms do not allow sending PDF-derived text for the spike;
- the six beta FRQs are unavailable and no Product Owner-approved
  throwaway-FRQ scope exists.

## 9. Spike Report

Create only an aggregate report in the repository. The report may include:

- source classification;
- experiment setup;
- model settings;
- aggregate token, latency, and cost table;
- aggregate quality observations;
- kill-criteria result;
- recommendation on whether to invest in Cramapple-authored or licensed
  reference cards.

The report must not include PDF excerpts, PDF-derived card text, copied sample
questions, or proprietary explanations.

## 10. Recommended Next Action

Before any API run:

1. Confirm the test FRQs and synthetic responses.
2. Confirm human criterion labels for those responses.
3. Confirm the model endpoint and pricing source.
4. Confirm provider retention, training, caching, and model-input settings,
   including whether temporary PDF-derived cards may be sent to the provider
   for this internal spike.
5. Confirm whether the six summer-beta FRQs are available or define the
   Product Owner-approved throwaway-FRQ scope.
6. Run a small smoke test first: one question, three responses, Arms A-D.
7. Run the larger pilot before applying continue/stop thresholds.
8. Review the outputs manually before expanding to all six beta FRQs.

## 11. Pre-Flight Checklist

Do not run any API calls until the following items are complete.

### 11.1 Test Inputs

- [x] Decision recorded: use the six summer-beta FRQs or a Product
  Owner-approved throwaway scope.
- [x] FRQ texts written.
- [x] Four rubric criteria finalized for each FRQ.
- [x] Three to five synthetic student responses written for each FRQ.
- [x] Human criterion labels captured for every response before any grading
  run.

Without human criterion labels, Arms A-D can be compared only against each
other and the quality side of the kill criteria is unevaluable.

### 11.2 Baseline Artifact

- [x] `docs/research/bio_reference_layer_baseline.md` created.
- [x] Current high-model setting recorded.
- [ ] Prompt version and prompt hash recorded.
- [x] Compactness setting recorded.
- [ ] Cost, latency, schema validity, and criterion-level quality recorded
  against the prewritten human labels.

Arm A is the baseline run. Capture Arm A and the baseline artifact together
with the prompt hash pinned.

### 11.3 Provider Settings

- [x] Spike provider account and endpoint settings confirmed for retention,
  training, caching, regional processing, abuse monitoring, and deletion.
- [x] Confirmed whether PDF-derived text may be sent to the selected model
  endpoint for this internal spike.

The production-grading provider review described in
`docs/product/BIO_REFERENCE_LAYER_PLAN.md` remains separately required before
learner-facing Phase 1.

### 11.4 Model Endpoint and Pricing

- [x] Endpoint pinned, including model ID, region if applicable, and account.
- [x] Pricing source pinned.
- [x] Measurement harness pricing table distinguishes cached and uncached
  input when the provider exposes that distinction.

Selected spike configuration, confirmed by Product Owner on 2026-06-17:

- API surface: OpenAI Responses API;
- production-mimic model ID: `gpt-5.5`;
- production-mimic reasoning effort: `high`;
- comparison model ID: `gpt-5.5`;
- comparison reasoning effort: `medium`;
- storage: `store: false` where available;
- pricing source: `https://developers.openai.com/api/docs/pricing`;
- selected pricing row: `gpt-5.5` direct standard endpoint, `$5.00` input /
  `$0.50` cached input / `$30.00` output per 1M tokens.

### 11.5 Temporary Arm D Card Authoring

- [x] Owner named for drafting temporary Arm D cards from the PDF.
- [x] Temporary storage location confirmed as
  `/private/tmp/cramapple-bio-ref-spike/` or another out-of-repository path.
- [x] No extracted PDF text or PDF-derived cards are committed to the
  repository.

### 11.6 Measurement Harness

- [x] Harness records every field in Section 6, including prompt hash and
  cached-token count when available.
- [x] Harness computes initial-grade call cost and full-attempt cost
  separately.
- [x] Harness can emit aggregate-only output for the spike report without PDF
  excerpts, PDF-derived card text, copied sample questions, or proprietary
  explanations.

### 11.7 Manual Review

- [x] Learning Quality reviewer identified.
- [x] Spot-check template prepared for over-credit, under-credit, rubric
  expansion, invented biology, vague feedback, unsafe repair, highest-value
  gap usefulness, and minimum-fix usefulness.

## 12. Current Readiness

```text
documents: ready for Product Owner and Learning Quality review of results
pre-flight: complete
execution: smoke and full gate sample complete
current blockers: none for interpreting aggregate spike results
```

Next review steps:

1. Review `docs/research/bio_reference_layer_gate_aggregate_report.md`.
2. Manually inspect recurring criterion misses before changing production
   grading.
3. Decide whether to run a prompt/schema refinement spike before investing in
   production reference-card authoring.
