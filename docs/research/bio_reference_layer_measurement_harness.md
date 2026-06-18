# Bio Reference Layer Measurement Harness

**Status:** Harness prepared for aggregate validation; API execution pending
**Owner:** Product Owner / Technical Owner
**Created Date:** 2026-06-17
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`
**Script:** `scripts/bio_reference_layer_measurement_harness.py`

## 1. Purpose

This harness records, validates, and aggregates results for the biology
reference-layer spike. It does not itself authorize API calls.

The current script is an aggregate harness: it validates a JSONL result file
containing per-call records and emits an aggregate Markdown report suitable for
the spike report. API-call execution can be added only after provider settings,
labels, pricing, and endpoint configuration are approved.

## 2. Input Format

The harness expects one JSON object per line with these fields:

```text
experiment_arm
model_id
reasoning_effort
prompt_version
prompt_hash
output_schema_version
prompt_caching_status
cached_tokens
question_id
response_id
input_tokens
output_tokens
reasoning_tokens
reference_tokens
app_latency_ms
provider_latency_ms
total_latency_ms
estimated_initial_grade_cost_usd
estimated_full_attempt_cost_usd
schema_valid
timeout_or_retry
points_earned
criterion_statuses
highest_value_gap
minimum_fix_length
confidence
uncertainty_reason
quality_flags
```

## 3. Usage

After API results are collected into JSONL:

```bash
python3 scripts/bio_reference_layer_measurement_harness.py \
  --input /path/to/results.jsonl \
  --output docs/research/bio_reference_layer_spike_aggregate_report.md
```

The output is aggregate-only and should not include PDF excerpts,
PDF-derived card text, copied sample questions, or proprietary explanations.

## 4. Prepared Status

```text
harness script: created
API caller: not created
aggregate report writer: created
pricing table: selected for `gpt-5.5` direct standard endpoint
input JSONL: pending model run
```

Selected pricing table, captured from OpenAI API pricing on 2026-06-17:

| Model | Input / 1M tokens | Cached input / 1M tokens | Output / 1M tokens |
| --- | ---: | ---: | ---: |
| `gpt-5.5` | `$5.00` | `$0.50` | `$30.00` |
