# Bio Reference Layer Baseline

**Status:** Arm A baseline measured at aggregate level
**Owner:** Product Owner
**Created Date:** 2026-06-17
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`
**Input Packet:** `docs/research/bio_reference_layer_spike_input_packet.md`

## 1. Purpose

This artifact records the Arm A baseline for the biology reference-layer spike.
Arm A is the current high-quality, rubric-only grading path with the current
output format and no biology reference cards.

The baseline aggregate is complete. Per-call model outputs remain outside the
repository in the approved temporary spike workspace.

## 2. Scope

Baseline sample:

```text
FRQs: SPIKE-FRQ-01, SPIKE-FRQ-02, SPIKE-FRQ-03
Responses: five per FRQ
Total responses: 15
Experiment arm: Arm A - current rubric-only baseline
Reference cards: none
```

## 3. Baseline Configuration

| Field | Value |
| --- | --- |
| Model endpoint | OpenAI Responses API, direct standard endpoint unless production account config specifies otherwise |
| Model ID | `gpt-5.5` |
| Reasoning effort | `high` |
| API surface | OpenAI Responses API |
| Prompt version | `bio-ref-spike-v1:arm_a_high_current_no_cards` |
| Prompt hash | Per-call prompt hash recorded in raw JSONL outside the repo |
| Output schema version | `bio-ref-spike-v1` |
| Compactness setting | Current output format |
| Prompt caching mode | Record cached and uncached token fields when available |
| Pricing source | `https://developers.openai.com/api/docs/pricing`, captured 2026-06-17 |
| Provider settings review | `docs/governance/provider_settings_review.md` |
| Storage setting | `store: false` where available |

Product Owner approval recorded 2026-06-17: Arm A should use the same API
surface and intended production model configuration so the baseline mimics the
production grading experience.

Product Owner confirmation recorded 2026-06-17: use production-mimic
configuration: `gpt-5.5`, reasoning effort `high`, OpenAI Responses API, and
`store: false` where available.

Pricing table for this baseline:

| Model | Input / 1M tokens | Cached input / 1M tokens | Output / 1M tokens |
| --- | ---: | ---: | ---: |
| `gpt-5.5` | `$5.00` | `$0.50` | `$30.00` |

## 4. Required Per-Call Records

Every Arm A result must record:

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
- estimated full-attempt cost when applicable;
- schema-valid output;
- timeout or retry;
- points earned;
- criterion statuses;
- highest-value gap;
- minimum fix length;
- confidence;
- uncertainty reason.

## 5. Baseline Results

Arm A was run on 2026-06-17 as part of the full gate sample.

Raw per-call JSONL:

```text
/private/tmp/cramapple-bio-ref-spike/gate_results_2026-06-17.jsonl
```

Committed aggregate report:

```text
docs/research/bio_reference_layer_gate_aggregate_report.md
```

Aggregate Arm A results:

| Metric | Value |
| --- | ---: |
| Calls | 15 |
| Average initial-grade cost | `$0.0280` |
| Average full-attempt cost | `$0.0280` |
| p50 latency | `12083.4930 ms` |
| p95 latency | `26156.7188 ms` |
| Average input tokens | `554.2667` |
| Average output tokens | `842.0000` |
| Average cached tokens | `0.0000` |
| Schema-valid rate | `0.9333` |
| Retries/timeouts | `0` |
| Automated criterion agreement | `48 / 60 = 80.0%` |

One Arm A row (`SPIKE-FRQ-01` / `FRQ01-R4`) did not produce parseable JSON
under the runner's schema check.

## 6. Quality Comparison

Compare Arm A criterion statuses against the prewritten labels in
`docs/research/bio_reference_layer_spike_input_packet.md`.

Record:

- exact match count by criterion;
- over-credit count;
- under-credit count;
- rubric-expansion count;
- invented-biology count;
- unsafe repair count;
- malformed-output count;
- timeout or retry count.

## 7. Completion Criteria

This baseline is complete when:

- aggregate Section 5 is populated from the measurement harness: complete;
- per-call prompt hashes are recorded in raw JSONL: complete;
- pricing source is recorded: complete;
- provider settings review is linked: complete;
- automated quality comparison against labels is complete: complete.
