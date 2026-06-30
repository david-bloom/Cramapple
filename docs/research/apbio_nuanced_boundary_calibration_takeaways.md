# AP Biology Nuanced Boundary Calibration Takeaways

**Status:** Completed summary for product decisioning  
**Date:** 2026-06-27

## What We Tested

We ran a nuanced synthetic AP Biology packet with borderline answers and
compared three models side by side:

- `openai/gpt-4o-mini`
- `openai/gpt-5.5`
- `deepseek/deepseek-v4-flash`

This was a calibration test, not a routing test. The goal was to see whether
multiple models could help expose unclear rubric boundaries.

## Results

### Overall quality

- `gpt-4o-mini`: `58 / 80` criteria correct, `72.50%`
- `gpt-5.5`: `58 / 80` criteria correct, `72.50%`
- `deepseek-v4-flash`: `58 / 80` criteria correct, `72.50%`

All three models tied on total criterion accuracy in this run, which means the
useful signal was not overall score. The useful signal was **where they
disagreed**.

### Borderline behavior

The borderline rows did produce meaningful disagreement. That is useful for
boundary calibration because it shows which criteria are actually fuzzy.

Examples:

- `FRQ01-R2`: `gpt-4o-mini` earned both criteria, while `gpt-5.5` and
  DeepSeek both under-credited one or both parts.
- `FRQ08-R3`: `gpt-5.5` earned both criteria, while `gpt-4o-mini` and
  DeepSeek each missed one part.
- `FRQ04-R3` and `FRQ06-R3`: the models split on which specific criterion was
  earned, showing the boundary is genuinely ambiguous rather than merely noisy.

## Interpretation

This run supports using multiple models as **boundary auditors**, not as a
grading ensemble.

What the models can do well:

- reveal which responses sit on the boundary;
- show where the rubric language is too vague;
- expose criteria where one model consistently over-credits or under-credits;
- give us candidate rewrite targets for the weakest boundary language.

What they did not do here:

- produce a better ensemble score than the best single primary model;
- create a reliable fallback policy;
- solve the grading problem by voting.

## Practical Takeaway

`gpt-4o-mini` remained the strongest single model on this nuanced packet, but
the disagreement pattern is still valuable. The right use of other models is to
identify weak criteria and guide boundary rewrites, then re-test with a single
primary grader.

## Sources

- [`apbio_nuanced_three_model_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_nuanced_three_model_report.md)
- [`apbio_primary_fallback_comparison_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_primary_fallback_comparison_report.md)
