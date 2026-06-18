# Grader Speed Subtask Profiling Protocol (SP-1)

**Status:** Approved for execution, pending second-opinion review. Gateway feature-verification gate (§12.2) is **complete** per `docs/research/sp1_gateway_verification.md`.
**Owner:** Product Owner with Technical Owner
**Last Updated:** 2026-06-17 (revised to add fast non-reasoning arms, multi-provider arms via Vercel AI Gateway, an explicit priority order, and to mark H8 and H9 decided after the gateway verification run)
**Related Plan:** `docs/product/BIO_REFERENCE_LAYER_PLAN.md` (§9, §10, §15)
**Related Reports:**
- `docs/research/sp1_gateway_verification.md`
- `docs/research/bio_reference_layer_oracle_boundary_test_report.md`
- `docs/research/bio_reference_layer_gated_prompt_test_report.md`
- `docs/research/bio_reference_layer_flywheel_volume_test_report.md`

## 1. Purpose

Identify exactly where time is lost in the FRQ grading path, characterize
tail latency, and identify the production-candidate grader configuration
for single-FRQ grading.

Single-question grading speed is the binding product constraint: during
trial and warm-up flows, students routinely grade one FRQ at a time. Slow
grading at that moment kills conversion and word of mouth, regardless of
how the multi-question practice flow is later sequenced.

## 2. Priority Order (Binding)

This run optimizes against the following priority order. Where these
conflict, decisions resolve in this order:

1. **Speed** — single-FRQ p50 latency and time-to-first-decision-token.
2. **Quality** — strict criterion agreement against adjudicated labels on
   the *clear* response subset.
3. **Cost** — per-FRQ cost up to ~$0.03 is acceptable. Lower is better,
   but is never traded against speed or quality.

Grading-quality go/no-go decisions remain gated on the Learning Quality
adjudication of the boundary-conflict cluster (`S010`, `S020`, `S028`,
`S066`, `S068`) per `BIO_REFERENCE_LAYER_PLAN.md` §15.

## 3. Goals

1. Produce per-span timing breakdowns for every grading call.
2. Separate time spent in app code, provider network/TTFT, output
   generation, schema validation, retry, and persistence.
3. Quantify the contribution of rubric ambiguity to reasoning-token use,
   output verbosity, schema-failure rate, and tail latency.
4. Test whether parallel per-criterion evaluation reduces end-to-end FRQ
   latency by the predicted margin.
5. Test whether a fast non-reasoning primary grader with reasoning-model
   escalation reaches single-FRQ p50 < 1.5s while preserving quality on
   the clear subset.
6. Compare fast non-reasoning models across three providers (OpenAI,
   Anthropic, Google) under identical prompt, boundary memory, and
   structured-output conditions.
7. Confirm prompt-caching state for stable rubric and boundary-table
   prefixes.
8. Measure the latency overhead of routing through Vercel AI Gateway vs
   direct provider calls on the same model.

## 4. Non-Goals

- Do not change the rubric or boundary contract text during this run.
- Do not retrieve reference cards, exemplars, or precedents into the
  prompt.
- Do not make a grading-quality release decision from this run.
- Do not change the perception-of-speed UX flow (background grading,
  streaming cards, progress narration) as part of this run. Those are
  tracked separately.
- Do not commit to a production gateway choice from this run alone.
  Gateway use here is for experimental flexibility; the production
  routing decision is a §16 open question informed by these results.

## 5. Hypotheses (Pre-Registered)

1. Provider time (T3 + T4) accounts for >75% of end-to-end per-criterion
   latency in all arms.
2. Reasoning tokens and end-to-end latency on the ambiguity cluster are
   materially higher than on the clear cluster (predicted: ≥1.5× avg
   reasoning tokens, ≥1.5× p95 latency).
3. Schema failures concentrate in the ambiguity cluster at a rate ≥2× the
   clear-cluster rate.
4. The `SP-1` reasoning-low arm reduces end-to-end FRQ p50 by ≥40% and
   p95 by ≥50% versus `BM-Control`, with strict agreement within −2 pp
   on the clear subset.
5. The `SP-FAST-ESC` fast-primary + reasoning-escalation arm reaches
   end-to-end FRQ p50 < 1.5s and p95 < 3.5s, with strict agreement
   within −5 pp on the clear subset.
6. Time-to-first-decision-token on `SP-FAST-ESC` is < 500ms at p50.
7. Stable rubric and boundary-table prefixes are not currently cached in
   the production runtime. **DEFERRED** — revisit after the production
   prompt shape is fixed (see `sp1_gateway_verification.md`).
8. Vercel AI Gateway adds < 30ms median per-call latency overhead vs
   direct provider calls on the same model and region. **PASS** —
   measured +7ms median TTFB, −51ms median total on N=30 each
   (`openai/gpt-4o-mini`). Gateway p95 was 40–50% tighter than direct.
   See `sp1_gateway_verification.md`.
9. Native structured output and `reasoningEffort` pass through the gateway
   without functional regression. **PASS** — all four candidate models
   returned schema-valid structured output; `gpt-5.5` reasoning-token
   counts differ by effort level. See `sp1_gateway_verification.md`.

## 6. Arms

| Arm | Primary model | Reasoning | Boundary memory | Output | Structured output | Parallel per criterion | Prefilter | Escalation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `BM-Control` | `gpt-5.5` | medium | none | compact | free-form JSON + bounded retry | no | none | none |
| `SP-1` | `gpt-5.5` | low | boundary table v0 | compact, capped | native | yes (8s timeout) | none | none |
| `SP-1-Serial` | `gpt-5.5` | low | boundary table v0 | compact, capped | native | no | none | none |
| `SP-1-Medium` | `gpt-5.5` | medium | boundary table v0 | compact, capped | native | yes | none | none |
| `SP-FAST` | `gpt-4o-mini` | n/a | boundary table v0 | 80-token cap | native | yes (4s timeout) | obvious-case (§6.1) | none |
| `SP-FAST-ESC` | `gpt-4o-mini` → `gpt-5.5` medium reasoning on escalation | n/a → medium | boundary table v0 | 80-token cap primary; uncapped on escalation | native | yes | obvious-case (§6.1) | per §6.2 |
| `SP-FAST-Haiku` | `claude-haiku-4-5` | n/a | boundary table v0 | 80-token cap | native | yes (4s timeout) | obvious-case (§6.1) | none |
| `SP-FAST-Gemini` | `gemini-2.5-flash` | n/a | boundary table v0 | 80-token cap | native | yes (4s timeout) | obvious-case (§6.1) | none |

Arm roles:

- `BM-Control` — current production baseline; the reference point for every delta.
- `SP-1` — secondary production candidate. The reasoning-low bundle.
- `SP-1-Serial` — isolates the contribution of parallel fanout.
- `SP-1-Medium` — isolates the contribution of low reasoning effort.
- `SP-FAST` — primary fast-model quality test without an escalation safety net.
- `SP-FAST-ESC` — **primary production candidate**. Fast primary + reasoning escalation.
- `SP-FAST-Haiku` / `SP-FAST-Gemini` — provider comparison on identical conditions to `SP-FAST`. If either materially beats `SP-FAST`, a follow-up will run its `-ESC` variant.

### 6.1 Deterministic Prefilter

Used by `SP-FAST`, `SP-FAST-ESC`, `SP-FAST-Haiku`, and `SP-FAST-Gemini`.
A criterion resolves in code without any model call when:

- response text is empty, whitespace-only, or below a per-question
  minimum length floor → `status: not_earned`, `gate: fail`,
  `evidence_quote: ""`;
- response fails a per-question key-term presence check on every key
  term (off-topic detection) → `status: unable_to_determine`,
  `gate: fail`;
- response matches an explicit refusal pattern ("I don't know", "skip",
  "n/a", etc.) → `status: not_earned`, `gate: fail`.

The prefilter is conservative. It does not attempt accepted-variant or
insufficient-wording matching, which would inherit any current rubric
ambiguity. Prefilter scope is restricted to verifiably non-substantive
cases.

Prefilter resolutions emit the same `T1`–`T6` spans as model-resolved
criteria, with `T3 = T4 = 0` and a `prefilter_reason` tag.

### 6.2 Escalation Pattern

Used by `SP-FAST-ESC`. A `SP-FAST` per-criterion result escalates to
`gpt-5.5` medium reasoning when any of:

- primary structured output reports `confidence < 0.7`;
- schema validation fails after one bounded retry on the primary;
- gate/status invariant violation detected (`empty evidence quote + earned`,
  `gate fail + earned`);
- contradiction between the evidence quote and the assigned status as
  detected by deterministic post-checks.

Escalation calls use the same prompt and L2 boundary memory as `SP-1`. If
escalation also returns low-confidence or schema-fails, the criterion is
marked `unable_to_determine` and routed to the human review queue.

Per-criterion timeout for `SP-FAST` is 4s. Per-criterion timeout for the
escalation step is 8s. Total per-criterion budget is 12s including
escalation; any criterion exceeding 12s returns `unable_to_determine` and
routes to human review.

### 6.3 Gateway and Provider Routing

All arms in this run are issued through **Vercel AI Gateway** unless a
verification step (§12.2) finds a provider-feature regression. The
gateway is used here for experimental flexibility, not as a committed
production choice.

Gateway feature-verification gate (§12.2) confirms before any arm runs:

- native structured output / strict JSON schema passes through for each
  primary model;
- prompt caching is exposed and observable for each primary model;
- `reasoning_effort` parameter passes through for `gpt-5.5`;
- streaming token events arrive at byte-level granularity (required for
  TTFD measurement).

If the gate fails for a specific provider/model, that arm falls back to
direct provider calls and the calibration step (§12.6) is repeated for
that model.

Gateway overhead calibration (§12.6): 30 sequential identical calls
direct-to-provider and 30 sequential identical calls through the gateway
on `SP-FAST` (gpt-4o-mini) using the same single fixed prompt. Compute
the median and p95 latency delta. This decides H8.

## 7. Subtask Instrumentation

Every grading call emits a structured span set:

| Span | Boundary | What it captures |
| --- | --- | --- |
| `T1` | request received → grading package resolved | rubric, boundary contract, content-package version lookups |
| `T2` | package resolved → prompt and structured-output schema compiled | template hydration, manifest hash, prompt serialization |
| `T3` | provider request sent → first output token | network, queue, input-token processing, reasoning (opaque on reasoning models — log explicitly) |
| `T4` | first output token → last output token | output generation only |
| `T5` | last output token → response validated and accepted | schema validate; if malformed, retry round-trip recorded as `T5_retry` |
| `T6` | validated → grade persisted, audit written, response returned | immutable submission link, outbox write, response shaping |

End-to-end per criterion = T1 + T2 + T3 + T4 + T5 (+ T5_retry) + T6.

End-to-end per FRQ:

- Serial arms: sum across criteria.
- Parallel arms: max across criteria + orchestration overhead.

For `SP-FAST-ESC`, the span set is emitted for both the primary call and
the escalation call (when triggered). End-to-end per-criterion is
primary + escalation when escalation fires.

Time-to-first-decision-token (`TTFD`) is captured separately for arms
with streaming output. `TTFD` is the elapsed time from request received
to the arrival of the structured-output token carrying the `status`
decision.

## 8. Token and Provider Instrumentation

Per call, capture:

- `input_tokens`
- `cached_input_tokens` (provider-reported)
- `reasoning_tokens` (non-reasoning models report 0)
- `output_tokens`
- `retry_count`
- `schema_failure_count`
- `escalation_triggered` (bool; `SP-FAST-ESC` only)
- `escalation_reason` (when triggered)
- `prefilter_resolved` (bool; when applicable)
- `prefilter_reason` (when applicable)
- `provider_request_id`
- `prompt_prefix_hash` (rubric + boundary table)
- `model_id`, `reasoning_effort` (where applicable), `max_output_tokens`
- `routing` — `direct` or `vercel_ai_gateway`
- `gateway_request_id` (when routed through the gateway)

## 9. Ambiguity Tagging

Before the run, tag every response in the corpus with `clarity`:

- `clear` — Learning Quality reviewers agree the label is straightforward
  against the current rubric.
- `ambiguous` — at least one of: in the named cluster (`S010`, `S020`,
  `S028`, `S066`, `S068`), reviewer disagreement at adjudication, or a
  previously logged label/rubric mismatch on this response.

Tagging is recorded in `docs/research/sp1_ambiguity_tags.jsonl` with
reviewer ID and timestamp. Tags are frozen before any arm runs to prevent
post-hoc selection bias.

## 10. Corpus

- All six summer-beta FRQs.
- For each FRQ, the response set used in the prior spike runs, expanded
  to a minimum of 30 responses per FRQ where available.
- Synthetic responses are acceptable for arm-comparison runs but must be
  flagged distinctly in the result set.
- The ambiguity cluster from `FRQ02-C2` is retained and tagged; do not
  drop these responses, they are the test of H2 and H3.

## 11. Metrics and Pass Thresholds

Speed (primary):

| Metric | Target |
| --- | --- |
| End-to-end FRQ p50 on `SP-FAST-ESC` | < 1.5s |
| End-to-end FRQ p95 on `SP-FAST-ESC` | < 3.5s |
| TTFD p50 on `SP-FAST-ESC` | < 500ms |
| End-to-end FRQ p50 on `SP-1` (secondary baseline) | < 4.0s |
| End-to-end FRQ p95 on `SP-1` (secondary baseline) | < 10.0s |
| Per-criterion timeout rate on any arm | < 2% |
| Schema-failure rate (post-retry) on any `SP-FAST*` primary | < 3% |
| Schema-failure rate (post-escalation) on `SP-FAST-ESC` | < 1% |
| Gateway overhead (median) vs direct on same model | < 30ms |
| Prefilter resolution rate | report per arm |
| Escalation rate on `SP-FAST-ESC` | report; expected 10–20% of criteria |

Quality (secondary, do not release on quality alone):

| Metric | Target |
| --- | --- |
| Strict criterion agreement on the *clear* subset on `SP-FAST-ESC` | within −5 pp of `BM-Control` |
| Strict criterion agreement on the *clear* subset on `SP-1` | within −2 pp of `BM-Control` |
| Strict criterion agreement on the *clear* subset on `SP-FAST-Haiku` and `SP-FAST-Gemini` | report; compare to `SP-FAST` to decide whether either warrants a follow-up `-ESC` arm |
| Under-credit and over-credit counts by criterion | report; flag any new significant pattern vs `BM-Control` |
| Strict criterion agreement on the *ambiguous* subset | report only; not gated (label quality is the confound) |

Cost (tertiary):

| Metric | Target |
| --- | --- |
| Avg cost per FRQ on `SP-FAST-ESC` | < $0.03 |
| Avg cost per FRQ on `SP-1` | < $0.015 |
| Avg cost per FRQ on `SP-FAST`, `SP-FAST-Haiku`, `SP-FAST-Gemini` | report |
| Cached-input-token share on stable prefixes | > 70% (when caching is confirmed enabled, per H7) |

Subtask attribution (H1):

- Report the share of end-to-end time in each of T1–T6 per arm. If
  app-side spans (T1 + T2 + T6) exceed 15% of end-to-end on any arm,
  raise a separate orchestration-overhead defect.

Ambiguity attribution (H2, H3):

- Report avg reasoning tokens, avg output tokens, p50/p95 latency, and
  schema-failure rate separately for `clear` and `ambiguous` subsets
  within each arm. Run paired comparisons.

## 12. Procedure

1. **Instrumentation landing.** Implement the span set (§7) and the
   token / provider instrumentation (§8) in the grading service behind a
   per-request flag. Span emission writes to the existing observability
   pipeline; do not mix with production traffic until the flag is
   removed.
2. **Gateway feature-verification gate.** Confirm native structured
   output, prompt caching, `reasoning_effort` passthrough, and
   streaming-token granularity for each primary model (§6.3). Record
   results in `docs/research/sp1_gateway_verification.md`. Any failed
   item routes the affected arm to direct-provider for the run.
3. **Provider-side caching check.** Confirm cached-input-token reporting
   appears for stable rubric / boundary-table prefixes. Record the
   answer before any arm runs — H7 is decided here.
4. **Ambiguity tagging.** Freeze tags (§9).
5. **Prefilter and escalation implementation.** Land §6.1 and §6.2
   behind the per-request flag.
6. **Gateway overhead calibration.** Run the 30+30 calibration on
   `SP-FAST` (gpt-4o-mini) direct vs gateway. Record results.
   Decide H8.
7. **Baseline run.** `BM-Control` against the full corpus. Persist raw
   results to `/private/tmp/cramapple-grader-sp1/bm_control_<date>.jsonl`.
8. **Treatment arms.** Run `SP-1`, `SP-1-Serial`, `SP-1-Medium`,
   `SP-FAST`, `SP-FAST-ESC`, `SP-FAST-Haiku`, `SP-FAST-Gemini` against
   the same corpus, same submission ordering, same content-package
   versions, same gateway routing decision (except where §12.2 forced a
   fallback).
9. **Result emission.** Each arm emits all spans, token counts, prefilter
   and escalation flags, routing tag, and gateway request IDs. No arm
   modifies the submission record or the immutable grade history.
10. **Aggregation.** Write `docs/research/grader_speed_sp1_report.md`
    using the table shapes from prior spike reports.

## 13. Analysis Plan

- Decide each hypothesis (H1–H8) directly from the pre-registered metric
  in §11. Do not introduce new metrics post-run.
- For H4 and H5, report the arm vs `BM-Control` delta for each FRQ, then
  the pooled delta. Do not pool across FRQs if per-FRQ deltas disagree in
  sign.
- For H2 and H3, report the clear-vs-ambiguous comparison within
  `BM-Control` first, then within each treatment arm.
- For `SP-FAST-ESC`, report end-to-end latency separately for criteria
  that did not escalate (pure primary path) and criteria that did
  escalate (primary + escalation), then pooled. The pure-primary slice
  is best-case latency; pooled is the realistic average.
- For `SP-FAST-Haiku` and `SP-FAST-Gemini`, compare clear-subset
  agreement and end-to-end speed against `SP-FAST`. Recommend a
  follow-up `-ESC` arm for any provider that matches or beats `SP-FAST`
  on clear-subset agreement at parity speed.
- All quality comparisons are descriptive statistics with sample sizes.
  Do not present agreement deltas inside the boundary-conflict cluster
  as model-quality findings until `BIO_REFERENCE_LAYER_PLAN.md` §15
  adjudicates them.

## 14. Decision Gates

Promote `SP-FAST-ESC` to production candidate if **all** of:

- End-to-end FRQ p50 < 1.5s,
- End-to-end FRQ p95 < 3.5s,
- TTFD p50 < 500ms,
- Schema-failure rate post-escalation < 1%,
- Per-criterion timeout rate < 2%,
- Clear-subset strict agreement within −5 pp of `BM-Control` on every
  FRQ,
- No FRQ shows a clear-subset agreement regression > 8 pp.

Promote `SP-1` (reasoning-low) as production candidate if `SP-FAST-ESC`
fails any of the above and `SP-1` meets:

- End-to-end FRQ p50 < 4s,
- End-to-end FRQ p95 < 10s,
- Schema-failure rate post-retry < 1%,
- Clear-subset agreement within −2 pp of `BM-Control` on every FRQ.

If both fast paths fail quality but speed targets are met, do not
promote; escalate to a follow-up that includes prompt and L2
boundary-table revisions.

Recommend a follow-up `-ESC` arm for `SP-FAST-Haiku` and/or
`SP-FAST-Gemini` if either matches `SP-FAST` clear-subset agreement at
≤ `SP-FAST` end-to-end p50.

Production-routing decision (gateway vs direct provider in production):
**Use the gateway.** H8 passed with +7ms median TTFB overhead and
−51ms median total (gateway slightly faster). Gateway p95 was tighter
than direct. The multi-provider, observability, BYOK billing, and
failover benefits exceed any plausible latency cost. The privacy review
of provider settings required by `BIO_REFERENCE_LAYER_PLAN.md` §12 still
applies and must cover gateway-routed traffic before production launch.

Kill the experiment and revisit if app-side overhead (T1 + T2 + T6)
exceeds 30% of end-to-end on any arm — that is an orchestration problem
and arm comparison is uninformative until fixed.

## 15. Out of Scope

- Reference card retrieval, exemplar retrieval, precedent retrieval.
- Changes to rubric text or boundary contract content.
- Learner-facing UI changes including streaming card display.
- Background grading on the multi-question practice flow.
- MCQ grading.
- Multi-provider racing or failover in production.
- Fine-tuning or distilled-model paths.
- `-ESC` variants of `SP-FAST-Haiku` and `SP-FAST-Gemini` (held for a
  follow-up if the non-`-ESC` arm shows promise).

## 16. Open Questions for Reviewers

1. Is provider-side caching enableable for the synthetic-corpus run, or
   only in the production runtime? If only production, H7 is answered
   there.
2. Who owns the ambiguity tagging, and what is the conflict-resolution
   rule when reviewers disagree on a `clear`/`ambiguous` call?
3. Should the deterministic prefilter (§6.1) be allowed to extend to
   accepted and insufficient wording lists once the boundary-conflict
   cluster is adjudicated, or kept strictly to non-substantive cases
   permanently?
4. Should the `confidence < 0.7` escalation threshold be tuned per
   criterion or held global for this run? Per-criterion tuning is
   post-hoc unless pre-registered.
5. ~~If H8 confirms gateway overhead < 30ms, do we keep Vercel AI Gateway
   in production for observability and failover, or route direct and
   trade that ergonomics for the latency margin?~~ **RESOLVED** — use the
   gateway. See §14 Decision Gates and `sp1_gateway_verification.md`.
