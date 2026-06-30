# AP Biology Short-FRQ Canonical Answer Takeaways

**Status:** Completed summary for product decisioning
**Date:** 2026-06-27

## What We Tested

We ran two canonical-answer experiments on the AP Biology short-FRQ held-out
set used in the reference-layer spike:

1. `0 vs 1 vs 2` canonical answers on the same grading task.
2. `2 canonical answers` versus a compact boundary-table rewrite.

The purpose was to see whether canonical answers improved grading quality
enough to justify extra prompt weight before considering speed and cost.

## Findings

### 1. One canonical answer was not enough

The `1 canonical answer` arm did not improve criterion accuracy over the
baseline.

- `0 canonical answers`: `49 / 60` correct criteria, `81.67%`
- `1 canonical answer`: `49 / 60` correct criteria, `81.67%`

This suggests the first answer alone was not adding enough boundary signal.

### 2. Two canonical answers were the best canonical variant

The `2 canonical answers` arm was the best canonical configuration we tested.

- `2 canonical answers`: `52 / 60` correct criteria, `86.67%`
- Quality flags fell from `10` to `8` versus baseline
- Strict success rate stayed flat at `53.33%`

This is a real improvement, but it is modest rather than decisive.

### 3. Boundary-table rewrite underperformed canonical answers

The compact boundary-table rewrite was worse than the `2 canonical answers`
arm on quality and cost.

- `2 canonical answers`: `49 / 60` correct criteria, `81.67%`
- Boundary table: `45 / 60` correct criteria, `75.00%`
- Boundary table had more quality flags and higher average cost

So the canonical pair was carrying useful boundary information that the
boundary-table rewrite did not preserve.

## Decision

Canonical answers are **not promising enough to pursue as a standalone
direction**.

The strongest result we found still leaves us with:

- only a small quality gain;
- no strict-success improvement;
- slightly higher prompt cost than the cheapest arm;
- no clear production-grade win.

That is enough to document the idea and move on.

## Next Question

The next useful experiment is whether a low-cost gateway model can serve as a
cheap first-pass grader or fallback.

The current gateway installation already recognizes:

- `deepseek/deepseek-v4-flash`
- `alibaba/qwen3.5-flash`

DeepSeek is the cleanest first candidate because its official docs currently
show an OpenAI-compatible API and published flash-model pricing.

## Sources

- [`apbio_short_frq_canonical_ablation_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_short_frq_canonical_ablation_report.md)
- [`apbio_short_frq_boundary_table_test_report.md`](/Users/davidbloom/Documents/Cramapple/docs/research/apbio_short_frq_boundary_table_test_report.md)
- DeepSeek API docs: [Models & Pricing](https://api-docs.deepseek.com/quick_start/pricing)
- DeepSeek API docs: [Your First API Call](https://api-docs.deepseek.com/)
