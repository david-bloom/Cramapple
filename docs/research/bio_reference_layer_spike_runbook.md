# Bio Reference Layer Spike Runbook

**Status:** Smoke and gate API runs completed
**Owner:** Product Owner / Technical Owner
**Created Date:** 2026-06-17
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_PDF_SPIKE_PROTOCOL.md`
**Input Packet:** `docs/research/bio_reference_layer_spike_input_packet.md`

## 1. Current State

Ready:

- selected FRQs confirmed;
- five responses exist for each selected FRQ;
- criteria confirmed;
- labels confirmed by Orly / Learning Quality on 2026-06-17;
- baseline artifact created;
- provider settings documented and Product Owner approved PDF-derived text
  transmission for this internal spike;
- aggregate measurement harness created and locally verified;
- OpenAI API key was available in the run environment for execution;
- production-mimic config selected and used;
- temporary workspace path created:

```text
/private/tmp/cramapple-bio-ref-spike/
```

Completed model runs:

- smoke run raw JSONL:
  `/private/tmp/cramapple-bio-ref-spike/smoke_results_2026-06-17_network.jsonl`;
- smoke aggregate report:
  `docs/research/bio_reference_layer_smoke_aggregate_report.md`;
- gate run raw JSONL:
  `/private/tmp/cramapple-bio-ref-spike/gate_results_2026-06-17.jsonl`;
- gate aggregate report:
  `docs/research/bio_reference_layer_gate_aggregate_report.md`.

The failed sandboxed smoke attempt is preserved separately at
`/private/tmp/cramapple-bio-ref-spike/smoke_results_2026-06-17.jsonl`; it
contains only network-resolution failures and should not be used for analysis.

## 2. Execution Sequence

### Step 1 - Select Endpoint and Models

Record in `docs/research/bio_reference_layer_baseline.md`:

- API surface;
- production-mimic model ID for Arm A;
- candidate comparison model ID;
- reasoning setting;
- pricing source;
- output schema version;
- prompt version;
- prompt hash.

Product Owner approval recorded 2026-06-17: Arm A should use the same API
surface and intended production model configuration so the baseline mimics the
production grading experience. Candidate lower-cost or faster model arms remain
in scope for comparison.

Product Owner confirmation recorded 2026-06-17: use the production-mimic
configuration for the spike:

- API surface: OpenAI Responses API;
- production-mimic model ID: `gpt-5.5`;
- production-mimic reasoning effort: `high`;
- storage: `store: false` where available;
- comparison model ID: `gpt-5.5`;
- comparison reasoning effort: `medium`;
- pricing source: OpenAI API pricing page, captured 2026-06-17:
  `https://developers.openai.com/api/docs/pricing`.

Pricing table for the selected direct OpenAI standard endpoint:

| Model | Input / 1M tokens | Cached input / 1M tokens | Output / 1M tokens |
| --- | ---: | ---: | ---: |
| `gpt-5.5` | `$5.00` | `$0.50` | `$30.00` |

The spike matrix is:

```text
gpt-5.5 high / no cards / current output
gpt-5.5 high / compact output / no cards
gpt-5.5 medium / compact output / no cards
gpt-5.5 medium / compact cards
```

### Step 2 - Draft Temporary Cards Outside the Repo

Codex drafts temporary Arm D cards under:

```text
/private/tmp/cramapple-bio-ref-spike/
```

Do not commit PDF-derived card text. Do not paste it into tracked docs.

Required temporary card sets:

- Arm D compact cards;
- Arm D-prime compact cards without mechanism-chain cards for mechanism-heavy
  FRQs;
- Arm C token-matched verbose biology context.

### Step 3 - Run Smoke Test

Small smoke test:

```text
1 FRQ x 3 responses x Arms A-D
```

Purpose:

- verify API calls;
- verify schema-valid output;
- verify token/cost/latency capture;
- verify prompt hash capture;
- verify no PDF-derived text is emitted into tracked files.

### Step 4 - Run Gate Sample

Recommended gate sample:

```text
3 FRQs x 5 responses x selected arms
```

Minimum larger pilot:

```text
2 FRQs x 5 responses x selected arms
```

Apply continue/stop thresholds only to the larger pilot, not the one-FRQ smoke
test.

### Step 5 - Aggregate Results

The API runner should write JSONL outside the repo first:

```text
/private/tmp/cramapple-bio-ref-spike/results.jsonl
```

Then run:

```bash
python3 scripts/bio_reference_layer_measurement_harness.py \
  --input /private/tmp/cramapple-bio-ref-spike/results.jsonl \
  --output docs/research/bio_reference_layer_spike_aggregate_report.md
```

The aggregate report may be committed because it contains no PDF excerpts,
PDF-derived card text, copied sample questions, or proprietary explanations.

### Step 6 - Update Baseline

After Arm A runs, populate:

```text
docs/research/bio_reference_layer_baseline.md
```

Required:

- model ID;
- prompt hash;
- input/output/reasoning/cached tokens;
- latency;
- cost;
- schema validity;
- criterion comparison against confirmed labels.

## 3. Run Outcome

The full gate run completed 85 calls:

- 15 Arm A high/current/no-cards calls;
- 15 Arm B high/compact/no-cards calls;
- 15 Arm BM medium/compact/no-cards calls;
- 15 Arm C medium/verbose-context calls;
- 15 Arm D medium/compact-card calls;
- 10 Arm D-prime medium/cards-without-mechanism calls.

Initial interpretation is recorded in
`docs/research/bio_reference_layer_gate_aggregate_report.md`.
