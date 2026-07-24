# AP Statistics Gold-Set Candidate Adjudication Workflow

**Package:** `ap_statistics_gold_set_candidate_2026_07_09`
**Scope:** Convert the full-corpus calibration candidate set into `adjudicated_gold` under `CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.1.

This document is a working workflow, not an adjudication result.

## Inputs

- `manifest.json`
- `provisional_labels.json`
- `blind_scoring_template.csv`
- `adjudication_queue.csv`
- `README.md`

## Roles

- **Validator A:** first blind scorer.
- **Validator B:** second blind scorer.
- **Lead adjudicator:** resolves disagreements and freezes final labels.
- **Learning Quality:** resolves boundary-contract questions when the rubric is ambiguous or the key payload admits multiple accepted variants.

## Adjudication steps

1. Freeze the candidate slice.
2. Assign response batches to Validator A and Validator B independently.
3. Record criterion-level labels and evidence quotes in `blind_scoring_template.csv`.
4. Compare the two blind passes.
5. For agreement, mark `agreement=YES` and carry the shared label forward.
6. For disagreement, route to the lead adjudicator.
7. If the disagreement reflects a rubric boundary rather than a scoring error, escalate to Learning Quality and update the boundary contract before freezing final labels.
8. Export the final adjudicated set and re-tier the package from calibration to `adjudicated_gold`.

## Promotion criteria

- Both blind scorers have completed the full slice.
- The lead adjudicator has resolved every disagreement.
- Boundary-contract questions are either resolved or explicitly excluded.
- Corpus defects are either repaired or isolated from gold claims.
- The final package is internally consistent with the declared key payload.

## Current open items

- MOD3 z-versus-t boundary question - resolved 2026-07-09 by tolerance.
- MOD6 sign-sensitive t-statistic convention - resolved 2026-07-09 by dropping sign sensitivity.
- MOD8 corpus defect - resolved 2026-07-09 by method-only/self-consistency grading.
- Full launch-bar expansion beyond the current five-item calibration slice.

## Feedback-quality note

If a criterion is conceptually ambiguous, prefer a clear minimum-fix and evidence quote over a vague full-credit or zero-credit label.
