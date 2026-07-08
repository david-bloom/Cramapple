# Bio Reference Layer Strict Context v2 Takeaways

**Run date:** 2026-07-07
**Input JSONL:** `/private/tmp/cramapple-bio-ref-spike/results_2026_07_07_strict_context_v2.jsonl`
**Report:** `/private/tmp/cramapple-bio-ref-spike/results_2026_07_07_strict_context_v2_report.md`

## What changed

- The temporary Biology reference context was tightened to add:
  - explicit criterion independence;
  - accepted shorthand for random bottleneck language;
  - clearer "do not require exact stoichiometry" guidance for FRQ03;
  - clearer "later mistakes do not erase earlier correct claims" guidance.

## What happened

- The tightened context did not improve the recurring FRQ02-C2 miss.
- The no-card baseline remained the best operational arm on this rerun.
- Reference-heavy arms were not better on quality and were slower or more expensive.
- The tightened cards made some FRQ03 boundary behavior worse, especially around C3/C4.

## Practical conclusion

The current bottleneck is not reference volume.
It is still rubric-boundary definition and criterion coupling.

The next useful step is to rewrite the problematic criterion boundaries themselves,
especially:

- FRQ02-C2, so the random/non-selective bottleneck distinction is clearer;
- FRQ03-C3 and FRQ03-C4, so reduced electron flow and NADPH:NADP+ ratio changes
  are not over-constrained by exact percentages or compensation claims.

Until that rewrite exists, `arm_bm_medium_compact_no_cards` remains the
best baseline for the Biology spike family.
