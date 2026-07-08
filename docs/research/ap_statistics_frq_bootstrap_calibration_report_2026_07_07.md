# AP Statistics FRQ Bootstrap Calibration Report
**Date:** 2026-07-07  
**Corpus:** `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json`

## Calibration Result

The bootstrap corpus is a usable calibration set for grader-agent development, but it is intentionally skewed toward easy binary decisions. The strongest calibration signal comes from the 10 long-form AP Statistics items, which provide the only middle-tier and near-boundary responses.

### Corpus Snapshot

- Total FRQs: 100
- Total synthetic responses: 220
- Form mix: 90 short, 10 long
- HDR-marked items: 30
- Difficulty mix: 15 easy, 30 medium, 40 hard, 15 very hard

### Synthetic Response Mix

- `fully_correct`: 100
- `borderline`: 42
- `partially_correct`: 10
- `subtly_wrong`: 10
- `incorrect`: 58

The corpus has 62 non-binary boundary-oriented responses out of 220 total. All of those boundary-oriented responses live in the 10 long items, which makes the long-form subset the critical calibration slice.

## What This Means For Calibration

1. The short FRQs are good for checking whether the grader can make stable all-or-nothing decisions.
2. The long FRQs are where rubric threshold tuning happens.
3. The grader should not be evaluated on binary accuracy alone, because that would underweight the difficult cases.
4. HDR coverage is reasonable at 30 items, but only 2 of the long items are HDR-marked, so visual calibration is still mostly a short-form exercise.

## Data-Model Note

The corpus uses AP Statistics investigative-task labeling in two places:

- `codex.frq_subtype = investigative_task` on all long items
- `investigative_task: true` on only part of the long-item subset

For filtering and downstream reporting, treat `codex.frq_subtype` as canonical. The top-level boolean is helpful, but it is not the most reliable source of truth.

## Recommended Calibration Strategy

1. Use the 10 long items as the primary boundary set.
2. Split those long items across multiple raters or model families before freezing a consensus.
3. Use the 90 short items to test exact-match and over-credit behavior.
4. Add more long borderline examples if the grader is still unstable after this pass.
5. Keep the corpus versioned exactly as `ap_statistics_frq_v1_2026_07_07` so later disagreement analysis is reproducible.

## Verification

This report was produced from the local repo export and doc metadata. I could not directly re-query the live Supabase project from this environment, so the calibration pass here is a repository-backed validation of the loaded corpus rather than a live database readback.

