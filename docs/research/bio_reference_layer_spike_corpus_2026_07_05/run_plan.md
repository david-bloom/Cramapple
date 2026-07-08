# 3-FRQ Run Plan

**Status:** Ready to execute once a live grading path is available
**Corpus:** `docs/research/bio_reference_layer_spike_corpus_2026_07_05/spike_corpus.jsonl`
**Selection rule:** `frq_id`

## Required Order

1. Run `SPIKE-FRQ-01` only.
2. Write and review the `SPIKE-FRQ-01` report.
3. Run `SPIKE-FRQ-02` only.
4. Write and review the `SPIKE-FRQ-02` report.
5. Run `SPIKE-FRQ-03` only.
6. Write and review the `SPIKE-FRQ-03` report.
7. Pool the three FRQ-level results only after all three reports exist.

## Baseline Arms

Use the same baseline arm set as the prior spike:

- `arm_a_high_current_no_cards`
- `arm_b_high_compact_no_cards`
- `arm_bm_medium_compact_no_cards`
- `arm_c_medium_verbose_context`
- `arm_d_medium_compact_cards`
- `arm_dprime_medium_cards_no_mechanism`

## Reporting Rule

Each FRQ-specific report should be treated as a smoke test because n = 5
responses per FRQ. Do not claim decision-grade behavior from an individual FRQ
report. Pool only after each FRQ has its own completed report.
