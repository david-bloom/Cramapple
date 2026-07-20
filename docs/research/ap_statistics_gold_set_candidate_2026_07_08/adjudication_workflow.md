# AP Statistics Gold-Set Candidate Adjudication Workflow

**Package:** `ap_statistics_gold_set_candidate_2026_07_08`
**Scope:** Convert the calibration candidate slice into `adjudicated_gold`
under `CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.1.

This document is a working workflow, not an adjudication result. It exists so
the launch-gate path is explicit and repeatable.

## Inputs

- `manifest.json`
- `provisional_labels.json`
- `blind_scoring_template.csv`
- `README.md`

## Roles

- **Validator A:** first blind scorer.
- **Validator B:** second blind scorer.
- **Lead adjudicator:** resolves disagreements and freezes final labels.
- **Learning Quality:** resolves boundary-contract questions when the rubric is
  ambiguous or the key payload admits multiple accepted variants.

## Adjudication steps

1. Freeze the candidate slice.
2. Assign response batches to Validator A and Validator B independently.
3. Record criterion-level labels and evidence quotes in
   `blind_scoring_template.csv`.
4. Compare the two blind passes.
5. For agreement, mark `agreement=YES` and carry the shared label forward.
6. For disagreement, route to the lead adjudicator.
7. If the disagreement reflects a rubric boundary rather than a scoring error,
   escalate to Learning Quality and update the boundary contract before freezing
   final labels.
8. Export the final adjudicated set and re-tier the package from calibration to
   `adjudicated_gold`.

## Required adjudication records

Each criterion row should end with:

- `validator_A_label`
- `validator_A_evidence_quote`
- `validator_B_label`
- `validator_B_evidence_quote`
- `agreement`
- `lead_adjudication`
- `final_gold_label`

## Promotion criteria

The package may be promoted only when all of the following are true:

- Both blind scorers have completed the full slice.
- The lead adjudicator has resolved every disagreement.
- Boundary-contract questions are either resolved or explicitly excluded.
- Corpus defects are either repaired or isolated from gold claims.
- The final package is internally consistent with the declared key payload.

## Current open items

- ~~MOD3 z-versus-t boundary question~~ — **resolved 2026-07-09**: the existing
  2% relative tolerance in `statistics-verifier.ts` already accepts either
  z*=1.96 or t*(df=29)≈2.045 for this item's CI (rel. diff ~0.2%); no code
  change needed, regression test added
  (`statistics-verifier_test.ts`, "passes a t*-based AP Statistics confidence
  interval"). See `../AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md`
  §1.
- ~~MOD6 sign-sensitive t-statistic convention~~ — **resolved 2026-07-09**
  (Product Owner approved): `sign_sensitive` dropped on the MOD6 test-statistic
  target in `statistics-verifier.ts` and `statistics_item_keys.json`, since
  `H₁: μ₁≠μ₂` is non-directional and the corpus's own provisionally-earned
  response uses the flipped subtraction order. Tests rewritten to assert either
  sign passes and wrong magnitude still flags; `validate_keys.py` updated to
  compare magnitude for non-sign-sensitive parts (8/8 integrity, 3/3 ECF pass).
  See `../AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md` §2.
- Full launch-bar expansion beyond the current five-item calibration slice.
- ~~Corpus defect isolation for `APSTAT-MOD8-H001`~~ — **resolved 2026-07-09**
  (Product Owner approved path a): rubric scoped to method-only/self-consistency
  grading rather than fixed-value matching. See
  `../AP_STATISTICS_MOD3_MOD6_BOUNDARY_CONTRACTS_2026_07_09.md` §3.

## Feedback-quality note

This workflow is designed to preserve the feedback signal, not just the point
score. If a criterion is conceptually ambiguous, the adjudicator should prefer a
clear minimum-fix and evidence quote over a vague full-credit or zero-credit
label.

