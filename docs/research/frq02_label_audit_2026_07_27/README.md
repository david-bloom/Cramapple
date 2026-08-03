# FRQ-02 Label Audit — 2026-07-27

## Outcome

All 100 responses and all 400 criterion labels were reviewed against the
boundary definitions used by the grading harness. The generated label file was
not edited. `audit_overrides.json` is a separate candidate correction layer so
the run can be scored against both the original labels and the audited labels.

The audit adjudicates 23 changes:

- 17 changes to C2, all from `earned` to `not_earned`. These answers describe
  random allele-frequency change or allele loss after the bottleneck, but do
  not say the construction/destruction event randomly selected survivors.
- 5 changes to C3, all from `not_earned` to `earned`, where the answer directly
  predicts decreased diversity in later generations.
- 1 change to C1, from `earned` to `not_earned`, where genetic drift is
  explicitly denied.

No C4 changes are proposed.

## Interpretation

This audit confirms that the source JSON is structurally complete, but its
labels are not reliable enough to treat as adjudicated gold. The errors are
systematic rather than random: most collapse the distinction between
event-level randomness (C2) and later random allele-frequency change (C4).

On 2026-07-27 the repository owner directed that these 23 corrections be
promoted to final gold. The materialized corpus is
`frq02_adjudicated_final_gold_2026_07_27.jsonl`; it preserves the original
source rows and records every changed criterion and rationale. The five closest
labels were retained as written under the frozen v2 boundary contract and
remain documented in the overlay.
