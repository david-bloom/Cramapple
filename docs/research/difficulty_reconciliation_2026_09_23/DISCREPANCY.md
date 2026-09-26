# J.0 discrepancy — the committed method does not contain per-item ratios

Status: **blocked; packet and reproduction evidence only; no data-load proposal**

J.0 says to re-run the existing calibrated method and emit the continuous ratio it “currently
throws away.” Inspection and execution show that premise is false: the committed method never
computes a per-item ratio. Producing 81 numeric values would require inventing a new mapping or
aggregation rule, which J.0 expressly forbids.

## Evidence

1. `assign_difficulty.py` reads `bio_full.json`, categorizes the first recognized verb in each
   criterion, takes the modal categorical tier with upward tie-breaking, and writes only
   `content_key,item_type,difficulty,basis,rationale` (lines 3–58). It never reads
   `crr_calibration_all_subjects.csv`, never calculates a ratio, and never applies numeric cut
   points.
2. The task-verb classifier's two source inputs were not committed: `bio_full.json` and `judge.py`
   are absent. The current Production content needed by `bio_full.json` was reconstructed read-only
   into `packet.jsonl`; the 37 judgment decisions survive only as final rows and rationale in
   `apbio_difficulty_assignments.csv`.
3. The live packet contains exactly 118 latest-published Biology items (75 FRQ, 43 MCQ), and its
   identities match the re-queried Production digest `0fd8ab863891be18662c1fe3ac08c891`.
4. Reapplying the committed classifier to the current packet reproduces all 81 task-verb bands with
   **zero band drift**. The 37 judgment bands cannot be independently regenerated because the
   committed judgment mapping is missing.
5. The AP Biology CRR file has only six distinct non-empty `verb_auto` values: `construct`,
   `describe`, `design`, `find`, `identify`, and `use`. Against the 81 task-verb items:

   - 51 have no exact normalized verb match;
   - 24 have only a partial match among multiple detected verbs;
   - 6 have all detected verbs represented.

6. Even those six cannot yield an approved item ratio. The calibration README explicitly says
   `verb_auto` and `attr_method` are unverified and “must not be used as-is” because they mislabel
   Biology Q1 D1/D2. The method also defines no rule for turning several matched CRR point ratios
   into one item ratio (mean, median, modal-tier anchor, minimum, or another operator).
7. The published cut-point language overlaps at both boundaries (`Hard <= 0.49`, Medium
   `0.49–0.75`, `Easy >= 0.75`). That does not affect the categorical rerun, but it must be made
   unambiguous before claiming a stored ratio re-derives a band at an exact boundary.

The row-level evidence is in `j0_reproduction.csv`. `attainment_ratio` is intentionally blank on
every row. Its `ratio_status` and `ratio_blocker` columns state the per-item reason instead of
hiding the gap behind an aggregate zero.

## Required decision/input before J.0 can resume

Provide and ratify all of the following:

1. the hand-verified mapping from each AP Biology CRR row to its task verb or Science Practice;
2. a mapping for every classifier verb that has no direct measured CRR observation, or an explicit
   decision that such items remain null;
3. the item-level aggregation rule when an item contains several verbs/criteria; and
4. non-overlapping inclusivity rules for the 0.49 and 0.75 cut points.

Once those exist, Codex can add the calculation to the regeneration script and re-run it. Until
then, an 81/37 numeric/null split is not supported by the recorded evidence. The honest measured
split is **0 ratios emitted / 118 withheld**, with 37 unavailable by design and 81 blocked on
missing methodology/provenance.

No Production write was made, and no migration or application SQL was produced.
