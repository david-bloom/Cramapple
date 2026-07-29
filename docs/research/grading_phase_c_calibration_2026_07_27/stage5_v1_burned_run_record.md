# Stage 5 v1 — Burned Run Record

**Run date:** 2026-07-27
**Status:** Burned. Do not reuse this n=20 item selection for the repaired
rerun (Stage 5 v2) — a fresh held-out slice is required per protocol ("do not
tune prompts after viewing accuracy and then reuse the same test set").

## What happened

The v1 low-number gate ran 20 items (4/subject family, biased toward
ECF/contradiction hard cases) through both frozen arms
(`frozen_arm_manifest.json`) via real paid Vercel AI Gateway calls to
`google/gemini-2.5-flash`. Total cost: **$0.12123** of the $1.00 cap (89 calls:
69 Arm A + 20 Arm B).

| Metric | Arm A (parallel per-criterion) | Arm B (single structured call) | Gate bar |
|---|---:|---:|---|
| Schema-valid | 100% (69/69) | 100% (20/20) | ≥95% |
| Criterion agreement vs Stage 3 gold | 91.3% (63/69) | 95.7% (66/69) | ≥85% |
| p50 latency | 1,685 ms | **3,252 ms** | ≤3,000 ms |
| p90 latency | 2,691 ms | 5,859 ms | measure |

**Gate result: FAIL**, specifically on Arm B's p50 latency. Every other bar
(schema validity, criterion agreement, Arm A latency) cleared comfortably.

Full v1 raw records preserved at `raw/stage5_arm_a.jsonl` and
`raw/stage5_arm_b.jsonl`; gate summary at `stage5_n20_gate_summary.json`.
Selected item set preserved at (scratchpad, not committed)
`stage5_selected_20.json` — content_keys listed below for provenance.

v1 selected items (burned, do not reuse):
`APBIO-FRQ-L-007, APBIO-FRQ-L-025, APBIO-FRQ-L-009, APBIO-FRQ-L-012,
apprecalc-frq-005, apprecalc-frq-013, apcalcab-frq-016, apprecalc-frq-008,
apchem-sfrq-002, apchem-sfrq-006, apchem-sfrq-003, apchem-frq-l-004,
apphy1-frq-019, apphy1-frq-030, apphycm-frq-029, apphy1-frq-021,
APSTATS-SFRQ-005, STATS-MOD4-H012, STATS-MOD1-E004, STATS-MOD1-E005`

## Root cause (confirmed from logged token usage, not guessed)

Per-call output-token counts were pulled directly from the Vercel AI Gateway
usage response for every Arm B call and cross-checked against latency:

| content_key | criteria count | output tokens | latency |
|---|---:|---:|---:|
| apprecalc-frq-008 | 6 | 1,490 | 7,034 ms |
| APBIO-FRQ-L-009 | 4 | 1,389 | 6,011 ms |
| APBIO-FRQ-L-007 | 4 | 1,325 | 5,580 ms |
| APBIO-FRQ-L-012 | 4 | 1,214 | 5,842 ms |
| STATS-MOD1-E004 | 1 | 118 | 1,032 ms |
| STATS-MOD4-H012 | 1 | 198 | 1,117 ms |

Latency scales directly with output-token count (~4-5 ms/output-token
observed), and output-token count scales with the number of criteria packed
into the single Arm B call. This is **architectural, not incidental**: Arm B
generates every criterion's full feedback object (evidence_quote,
withheld_point_reason, minimum_fix, improved_answer, error_classification,
etc.) serially in one stream, with no parallelism, so multi-criterion items
(4-6 criteria in this corpus) pay the full serial cost. Arm A pays only the
slowest *single* small call because its criteria run in parallel — the
max-of-N tail stays low precisely because each N is small and fast (mean 237
output tokens/call).

This directly reproduces the FRQ-02 finding that motivated testing Arm B in
the first place ("parallel criterion calls amplify tail latency... reduce
request fan-out and max-of-four tail latency") — except here, for
multi-criterion items, batching into one call traded a parallelism penalty
for a serialization penalty, and lost.

## Repair applied for Stage 5 v2 (see `frozen_arm_manifest_v2.json`)

1. **Per-field brevity constraints added to the Arm B prompt.** `evidence_quote`,
   `withheld_point_reason`, `minimum_fix`, and `improved_answer` are now
   explicitly capped at ~20 words each in the prompt instructions (Arm A is
   unaffected -- its per-criterion calls were never the latency problem).
2. **Dynamic `max_output_tokens` for Arm B**, proportional to criteria count
   (`180 + 160 * n_criteria`, capped at 2200) instead of a flat 3,500 -- this
   both signals the shorter target length to the model and prevents runaway
   generation on the largest items.
3. Arm A configuration is **unchanged** from v1 (it already passed every
   gate bar).

This is a mechanical harness fix (prompt brevity + token-budget correction),
not a rubric or accuracy-driven prompt tune -- no criterion-contract content
changed, only verbosity constraints on already-required fields. Per protocol,
scored only against a fresh, previously-unseen 20-item slice.
