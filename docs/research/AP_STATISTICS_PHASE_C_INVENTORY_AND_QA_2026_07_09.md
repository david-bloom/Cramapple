# AP Statistics Phase C Inventory and QA - 2026-07-09

This note reconciles the existing AP Statistics source inventory before and during the Phase C corpus expansion pass. It is intentionally short so Learning Quality can spot the highest-risk items quickly.

## Inventory Reconciliation

| Source | Item count | Synthetic responses attached | Action |
| --- | ---: | --- | --- |
| `docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/` | 18 MCQ + 18 FRQ | No synthetic response corpus | Reused as-is. The MCQs already live in Production and the sibling FRQs were treated as published reference material. |
| `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` | 100 FRQ | Yes, 220 synthetic responses | Folded into the full FRQ calibration package as the primary source corpus. |
| `docs/research/apstats_packet_bundle_2026_07_07/frq_only_pool.json` | 40 FRQ | No | Set aside for now. Namespace does not overlap the bootstrap corpus, and there was no exact content-key overlap to justify a blind merge. |
| `docs/research/ap_statistics_gold_set_candidate_2026_07_09/` | 100 FRQ | Yes, 220 synthetic responses | Generated as the full-corpus provisional-label package for Phase C. |
| `docs/research/ap_statistics_mcq_launch_bank_2026_07_09/` | 100 MCQ | No synthetic response corpus | Generated as the launch-bar MCQ bank. 18 items were reused from the live smoke batch; 82 were authored net-new. |

## QA Findings

| File | Content key | Criterion | Finding | Confidence |
| --- | --- | --- | --- | --- |
| `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` | `APSTAT-MOD3-H001-INV` | `ci_calculation` | z* vs t* boundary case. The t-based interval stays inside the 2% deterministic tolerance, so either method should pass. | High |
| `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` | `APSTAT-MOD6-H001` | `test_calculation` | Two-tailed sign convention boundary case. The subtraction order is an artifact here, so the magnitude should grade, not the sign. | High |
| `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` | `APSTAT-MOD8-H001` | `correlation_calculation` / `regression_equation` | Corpus defect: no dataset is attached, so value-specific grading is not valid. Method-only/self-consistency grading is the right scope. | High |
| `docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` | `APSTAT-MOD6-H007` | `ci_width_calculation` | The authored response claims roughly 67% confidence, but the exact halved-width confidence is about 58.9%. This should be reviewed as a content defect, not silently normalized. | Medium-High |

## Notes

- The FRQ candidate package and the deterministic key set are now aligned at `100` items, `220` responses, and `21` keyed numeric/ECF parts.
- The deterministic validator passes at `21/21` canonical-integrity checks and `4/4` ECF checks.
- The packet-bundle pool was reviewed for overlap and kept separate because it has a different namespace and no exact content-key collision with the bootstrap corpus.
