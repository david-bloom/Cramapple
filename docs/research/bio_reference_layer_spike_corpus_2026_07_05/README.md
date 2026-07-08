# Bio Reference Layer Spike Corpus

**Status:** Labeled corpus package for the 3-FRQ summer-beta spike
**Created Date:** 2026-07-05
**Source of truth:** `docs/research/bio_reference_layer_spike_input_packet.md`
**Criterion contract:** `earned`, `not_earned`, `unable_to_determine`, `not_applicable`
**Grading contract:** same confirmed Learning Quality labels and reviewer notes
  as the spike input packet

## Scope

This package materializes the approved 3-FRQ spike set:

| FRQ ID | Source question | Difficulty | Unit |
| --- | --- | --- | --- |
| `SPIKE-FRQ-01` | Question 4 | Medium | Cellular Energetics |
| `SPIKE-FRQ-02` | Question 8 | Hard | Natural Selection |
| `SPIKE-FRQ-03` | Question 10 | Very Hard | Cellular Energetics |

The corpus contains 15 labeled responses total, five per FRQ.

## Files

- `spike_corpus.jsonl`: canonical flattened corpus with all 15 labeled rows
- `run_plan.md`: execution order and pooling rule

## How To Use

1. Filter `spike_corpus.jsonl` by `frq_id` to obtain the per-FRQ labeled corpus.
2. Run the same baseline arms on one FRQ at a time.
3. Write one report per FRQ.
4. Pool the results only after all three FRQ reports exist.

## Notes

- The corpus is derived from the approved spike packet, not from model output.
- Criteria and labels are preserved as confirmed by Orly / Learning Quality on
  2026-06-17.
- This package is intended for benchmark and calibration work, not learner-facing
  production content.
