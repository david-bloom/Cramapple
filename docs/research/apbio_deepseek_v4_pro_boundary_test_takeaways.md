# AP Biology DeepSeek-V4-Pro Boundary Test Takeaways

**Status:** Completed summary for product decisioning  
**Date:** 2026-06-28

## What We Tested

We ran the same nuanced synthetic AP Biology short-FRQ packet used in the
primary/fallback diagnostic, but with `deepseek/deepseek-v4-pro` as the only
grader. The goal was to see whether a slower reasoning model improved boundary
quality enough to justify its higher latency.

Baseline for comparison:

- `openai/gpt-4o-mini` primary-only run on the same packet

## Results

### DeepSeek-V4-Pro

- Criterion accuracy: `55 / 80 = 68.75%`
- Strict success rate: `50.00%`
- p50 latency: `11.31 s`
- p95 latency: `20.92 s`
- Avg cost: about `$0.000326` per call
- Schema validity: `100%`

### Frozen GPT-4o-Mini Baseline

- Criterion accuracy: `58 / 80 = 72.50%`
- Strict success rate: `60.00%`
- p50 latency: `1.93 s`
- p95 latency: `3.24 s`
- Avg cost: about `$0.000129` per call

## Direct Comparison

- DeepSeek was worse on criterion accuracy.
- DeepSeek was worse on strict success rate.
- DeepSeek was about 5.9x slower on median latency.
- DeepSeek cost about 2.5x more per call.
- Only one response improved relative to the GPT baseline: `FRQ04-R3`.
- Four responses worsened relative to the GPT baseline: `FRQ03-R3`, `FRQ05-R5`, `FRQ06-R5`, and `FRQ07-R5`.
- Thirty-five responses were unchanged.

## Interpretation

This run does not support replacing the GPT boundary grader with
`deepseek/deepseek-v4-pro`.

The model is useful as a boundary auditor because it is slow enough to spend
more effort on ambiguous cases, and it produced valid JSON consistently. But on
this packet it did not improve grading quality, and it increased both latency
and cost.

The practical conclusion is the same one we were already converging on:

- keep `gpt-4o-mini` as the primary boundary grader;
- use DeepSeek only as an occasional auditor on especially ambiguous rows if we
  want a second opinion;
- do not promote DeepSeek to the default grader on this evidence.

## Raw Outputs

- DeepSeek JSONL: `/private/tmp/cramapple-bio-ref-nuanced/deepseek_v4_pro.jsonl`
- DeepSeek report: `/private/tmp/cramapple-bio-ref-nuanced/deepseek_v4_pro_report.md`
- GPT baseline report: [`apbio_primary_fallback_primary_only_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_primary_fallback_primary_only_report.md)
