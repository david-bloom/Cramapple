# Bio Reference Layer Next Protocol Pilot Report

## Run Metadata

| Field | Value |
| --- | --- |
| Protocol doc + version | `docs/research/bio_reference_layer_next_experiment_plan.md`, draft protocol dated 2026-06-18 |
| Script + commit hash | `scripts/vercel-gateway-check/next_protocol.mjs`; repo HEAD `3d8324198d695b1f5ef209df59a0b15dc308afff`; script has uncommitted runner changes |
| Run date, owner | 2026-06-18; Product Owner with Learning Quality Owner |
| Raw results path | `/private/tmp/cramapple-bio-ref-next/pilot_results_2026-06-18_gateway.jsonl` |
| Summary path | `docs/research/bio_reference_layer_next_pilot_2026-06-18_summary.json` |
| Supersedes | `/private/tmp/cramapple-bio-ref-next/pilot_results_2026-06-18.jsonl` is invalid for analysis |
| Sample selection method | `selectHardSet`, deliberately high-ambiguity FRQ02-C2 cases |
| n per arm, response IDs | `n=6`; `S009`, `S019`, `S020`, `S029`, `S031`, `S068` |
| Gateway used? | `true`; Vercel AI Gateway used for all main pilot arms |
| Read tier | **Smoke Test** |

## Integrity Gate

- [x] Token usage is nonzero for at least one row where a billed call succeeded.
- [x] Cost is greater than $0 for at least one successful row.
- [x] Escalation rate is nonzero and the report states which condition fired and on how many rows.
- [x] The same response-ID set was used across all arms being compared.
- [x] p95 is computed on fewer than 20 samples and is explicitly labeled single-point, not a real percentile.
- [x] Schema-invalid rows are listed by response ID with their raw error.

## Known Issues

- This is a Smoke Test (`n=6` per arm), so it cannot support arm promotion,
  arm killing, or claims that one arm beats another.
- The sample is intentionally adversarial. It must not be mixed with random or
  representative corpus rows in one aggregate.
- Every p95 value below is a single-point statistic from `n=6`, not a real
  percentile.
- Schema-invalid rows often lack usage from the AI SDK object parser, so token
  and cost averages understate billed usage for arms with schema failures.
- The superseded first pilot had invalid cost extraction and an inverted
  escalation condition. It is preserved but not used here.

## Executive Summary

This authenticated Vercel AI Gateway smoke test verifies that the next-protocol
runner can execute all planned provider families and emit comparable raw rows.
It does not provide decision-grade evidence about quality, latency, cost, or
provider choice.

The run reached OpenAI, Anthropic, and Google model IDs through the gateway.
The main operational issue exposed by the smoke test is structured-output
compatibility: Gemini produced no schema-valid rows with the current prompt and
schema, and Haiku was mixed. The recurring FRQ02-C2 boundary cluster remained
visible: valid arms over-credited `S020` and `S068`.

`SP-FAST-ESC` escalated on `1/6` rows. The escalation condition was `gate_fail`
on `S009`.

## Per-Arm Metrics

| Arm | n | Routing | Strict agreement | Clear-subset agreement | Schema valid | Under-credit | Over-credit | p50 latency | p95 latency | Avg input tok | Avg output tok | Avg reasoning tok | Avg cost | Escalation rate |
| --- | ---: | --- | ---: | --- | ---: | ---: | ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: |
| `BM-Control` | 6 | Vercel AI Gateway | 3/6 (50.0%) | n/a | 5/6 (83.3%) | 0 | 2 | 5138ms | 11406ms* | 364 | 88 | 47 | $0.00445 | 0/6 (0.0%) |
| `Boundary-Table` | 6 | Vercel AI Gateway | 3/6 (50.0%) | n/a | 5/6 (83.3%) | 0 | 2 | 1996ms | 4042ms* | 494 | 75 | 32 | $0.00472 | 0/6 (0.0%) |
| `Boundary-Table-Low` | 6 | Vercel AI Gateway | 4/6 (66.7%) | n/a | 6/6 (100.0%) | 0 | 2 | 1840ms | 3974ms* | 585 | 79 | 28 | $0.00529 | 0/6 (0.0%) |
| `SP-FAST` | 6 | Vercel AI Gateway | 3/6 (50.0%) | n/a | 5/6 (83.3%) | 0 | 2 | 1544ms | 2756ms* | 496 | 46 | 0 | $0.00010 | 0/6 (0.0%) |
| `SP-FAST-ESC` | 6 | Vercel AI Gateway | 3/6 (50.0%) | n/a | 5/6 (83.3%) | 0 | 2 | 1541ms | 6163ms* | 587 | 60 | 0 | $0.00012 | 1/6 (16.7%) |
| `SP-FAST-Haiku` | 6 | Vercel AI Gateway | 2/6 (33.3%) | n/a | 4/6 (66.7%) | 1 | 2 | 1171ms | 3610ms* | 603 | 39 | 0 | $0.00064 | 0/6 (0.0%) |
| `SP-FAST-Gemini` | 6 | Vercel AI Gateway | 0/6 (0.0%) | n/a | 0/6 (0.0%) | 3 | 0 | 1000ms | 3359ms* | 0 | 0 | 0 | $0.00000 | 0/6 (0.0%) |

`*` p95 is single-point, not a real percentile, because `n=6`.

## Paired Changes Vs. Control

| Arm | Fixed (control wrong, arm right) | New errors (control right, arm wrong) | Unchanged | Regressions in frozen boundary cluster |
| --- | ---: | ---: | ---: | ---: |
| `Boundary-Table` | 0 | 0 | 6 | 0 |
| `Boundary-Table-Low` | 1 | 0 | 5 | 0 |
| `SP-FAST` | 0 | 0 | 6 | 0 |
| `SP-FAST-ESC` | 0 | 0 | 6 | 0 |
| `SP-FAST-Haiku` | 0 | 1 | 5 | 0 |
| `SP-FAST-Gemini` | 0 | 3 | 3 | 0 |

## Schema-Invalid Rows

| Arm | Response ID | Raw error |
| --- | --- | --- |
| `BM-Control` | `S009` | No object generated: could not parse the response. |
| `Boundary-Table` | `S009` | No object generated: could not parse the response. |
| `SP-FAST` | `S009` | No object generated: could not parse the response. |
| `SP-FAST-ESC` | `S009` | No object generated: could not parse the response. |
| `SP-FAST-Haiku` | `S009` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S009` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S019` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S020` | No object generated: could not parse the response. |
| `SP-FAST-Haiku` | `S029` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S029` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S031` | No object generated: could not parse the response. |
| `SP-FAST-Gemini` | `S068` | No object generated: could not parse the response. |

## Claims Supported / Claims Not Supported

**Supported by this run:**

- The next-protocol runner executes all planned model families through Vercel
  AI Gateway on the selected adversarial FRQ02-C2 smoke sample.
- The runner now emits nonzero token and cost fields for successful billed
  calls.
- The corrected escalation condition is no longer always-on; `SP-FAST-ESC`
  escalated on `1/6` rows in this smoke test.
- The current Gemini prompt/schema path did not produce schema-valid rows in
  this sample.
- The current Haiku prompt/schema path produced mixed schema validity in this
  sample.

**Not supported by this run:**

- No arm can be described as promising, better than control, promoted, or killed.
- No corpus-level latency, cost, or schema-validity conclusion is supported.
- No production quality decision is supported.
- No H5 provider-quality conclusion is supported; this only tests reachability
  and smoke-level structured-output behavior.
- No conclusion is supported about whether the FRQ02-C2 boundary cluster should
  be labeled earned or not earned.
