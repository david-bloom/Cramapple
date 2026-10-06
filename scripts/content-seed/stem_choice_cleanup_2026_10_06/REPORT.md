# MCQ stem cleanup — choices repeated inside the question (2026-10-06)

**Status:** prepared and rehearsed. **Not applied to Production.** Needs David's approval (Hard-Gate).

## Defect
198 published MCQs carry their answer choices a second time, as a trailing `A. … B. … C. … D. …` list inside the
stem. Students see the choices twice. In all 198 the inline list matches `app.mcq_choices` exactly.

## Classification
| Subject | Clean | Needs review | Mismatch | False positive |
|---|---:|---:|---:|---:|
| AP Chemistry | 62 | 6 | 0 | 0 |
| AP Calculus BC | 42 | 0 | 0 | 0 |
| AP Calculus AB | 26 | 0 | 0 | 0 |
| AP Physics C: Mechanics | 22 | 0 | 0 | 0 |
| AP Physics 2 | 20 | 0 | 0 | 0 |
| AP Physics C: E&M | 19 | 1 | 0 | 0 |
| **Total** | **191** | **7** | **0** | **0** |

The 7 review items (apchem-mcq-006, -007, -017, -057, -061, -066; apphycem-mcq-013) have an assumption sentence after
the list (e.g. "Assume 25 C."). `prod_apply_review7.sql` removes the list and keeps that sentence after a blank line.

Examples (the trailing list is removed; the text before it is unchanged):
- apcalcab-mcq-021 → "What is lim(x→2) (x²−4)/(x−2)?"
- apchem-mcq-021 → "A sample of pure glucose (C6H12O6, molar mass = 180.16 g/mol) has a mass of 90.0 g. How many moles of glucose does the sample contain?"
- apchem-mcq-017 (review) → "The pH of 1.0×10⁻³ M HCl is approximately" + blank line + "Assume 25 C."

## Why a bare UPDATE is wrong
No publish gate blocks an in-place stem edit. But the stem is part of `taxonomy_relevant_hash`, so the stale-label
trigger marks the item's serving labels `stale` and clears their validator fields. Serving requires a validated
label with a matching hash, so a bare UPDATE would pull **142 served items** out of Practice (148 with the review 7).
A new `version_num` has the same effect and adds more churn.

**Path used:** the canonical-answers precedent (APPROVAL-0116/0066). The stem is updated in place, and in the same
statement each label's prior status and validator fields are restored. The stored hash is refreshed where it matched
before, including on 33 `held` labels, so a later hold release is not blocked. Provenance is written to
`source_payload.carried_forward_stem_choice_cleanup_2026_10_06`.

The apply is idempotent and guarded. It only touches rows whose stem md5, latest-published status and choices
signature still match the snapshot. It checks postconditions and raises on any failure, which rolls everything back.

## Rehearsal (Development)
None of the 198 exist in Development, and Development lacks the taxonomy-hash functions. The Production definitions
were installed inside one self-rolled-back block, 14 snapshot rows were seeded, and the exact generated SQL was run.
- **Control (bare update):** 1 label went stale and served dropped from 10 to 9.
- **With carry-forward:** apply cleaned 11; a re-run did nothing; the review-7 file cleaned 3; rollback restored 5.
- Choices were unchanged, everything stayed published, label states matched the start, served stayed at 10, and
  there were no trigger errors.

## Runbook (Production)
1. Run `prod_verify.sql`. Baseline: 198 rows still old; labels validated 148 / provisional 15 / provisional with null
   hash 1 / held 32 / held stale 2; servable 148.
2. Set `v_approval` in `prod_apply.sql` (and optionally `prod_apply_review7.sql`), then run it. The file is 66 KB:
   use the Supabase SQL editor or psql, or split it, because large MCP calls time out.
3. Run `prod_verify.sql` again. Expect: cleaned 191 (198 with review 7); label counts unchanged; no stale labels;
   servable 148.
4. Rollback: set `v_approval` in `prod_rollback.sql` and run it. It restores the snapshot stems and labels.

## Notes
- 66 completion-style stems end without terminal punctuation. That is acceptable for "…is" stems.
- Two stems end in "--" (apphy2-mcq-010, apphycem-mcq-016); an editor may want to drop the dashes.
- **Upstream gap:** `enforce_mcq_stem_choice_sync` only catches lists that disagree with `mcq_choices`. An identical
  copy passes, so the import path that wrote these needs a fix.
- **Leftover:** Development table `public.scc_rehearsal_chunks_20261006` from the rehearsal. The DROP timed out
  through the MCP; drop it from the SQL editor.
