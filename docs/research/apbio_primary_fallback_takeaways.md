# AP Biology Primary/Fallback Takeaways

**Status:** Completed summary for product decisioning  
**Date:** 2026-06-27

## What We Tested

We ran a nuanced synthetic AP Biology short-FRQ packet designed to mimic real
grading use more closely than the earlier clean synthetic set. The packet
included:

- borderline answers;
- vague but on-topic answers;
- clear full-credit and no-credit answers;
- a primary model plus fallback policy.

Tested policy:

- primary: `openai/gpt-4o-mini`
- fallback: `openai/gpt-5.5`
- escalation trigger: primary confidence below `0.90` or schema/gate failure

We compared:

1. `primary_only`
2. `fallback_only`
3. `primary_then_fallback`

## Results

### 1. Primary-only was the best performer

- Criterion accuracy: `58 / 80 = 72.50%`
- Strict rate: `60.00%`
- p50 latency: `1931.4 ms`
- Avg cost: `0.000129`

This was the best result in the run.

### 2. Fallback-only was not a good safety net

- Criterion accuracy: `32 / 80 = 40.00%`
- Strict rate: `40.00%`
- p50 latency: `3035.0 ms`
- Avg cost: `0.002712`

The fallback model did not act like a reliable higher-quality adjudicator on
this packet.

### 3. Primary-plus-fallback was worse than primary-only

- Criterion accuracy: `43 / 80 = 53.75%`
- Strict rate: `52.50%`
- p50 latency: `4665.9 ms`
- Avg cost: `0.001506`

This policy was worse on quality, slower, and more expensive than the primary
model alone.

## What Happened

The main problem was not just model choice. It was routing quality:

- the confidence trigger escalated too many clear cases;
- ambiguous cases were not consistently rescued;
- the fallback sometimes failed to produce useful structured output on the
  harder rows;
- only `1` row improved relative to primary-only, while `13` rows worsened.

The fallback path therefore added cost and latency without improving grading
quality.

## Decision

The current hypothesis is **not supported**:

- a simple confidence-based fallback policy did not improve grading quality;
- it did not reduce risk on the ambiguous subset;
- it made the overall system worse.

The next promising direction, if we continue testing a two-stage workflow, is
to replace raw confidence with a more specific ambiguity gate or disagreement
check.

## Sources

- [`apbio_primary_fallback_comparison_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_primary_fallback_comparison_report.md)
- [`apbio_primary_fallback_primary_only_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_primary_fallback_primary_only_report.md)
- [`apbio_primary_fallback_primary_then_fallback_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_primary_fallback_primary_then_fallback_report.md)
