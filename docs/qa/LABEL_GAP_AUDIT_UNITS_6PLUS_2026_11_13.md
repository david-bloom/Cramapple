# Label gap audit, Units 6 and above, all ten AP subjects: Stage 1 (read-only) (2026-11-13)

Production `pcntajvbdfqhbeewmdry`, read-only (SELECTs only). Method and definitions as in `LABEL_GAP_AUDIT_UNITS_1_5_2026_11_13.md`. Scripts: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/` (`export_prod.py`, `analyze.py`, `report.py`). Machine-readable: `LABEL_GAP_AUDIT_UNITS_6PLUS_2026_11_13_ITEMS.json`.

## Unit mapping (registry `taxonomy_topics` units; `home_release_manifest.allowed_unit_numbers` agrees for every subject)
| Subject (registry key) | Registry units | Done last round | In scope now |
|---|---|---|---|
| Biology | 1-8 | 1-5 | 6, 7, 8 |
| Calculus AB | 1-8 | 1-5 | 6, 7, 8 |
| Calculus BC | 1-10 | 1-5 | 6-10 |
| Chemistry | 1-9 | 1-5 | 6-9 |
| Physics 1 | 1-8 | 1-5 | 6-8 |
| Physics 2 | 9-15 | 9-13 | 14, 15 |
| Physics C: Mechanics | 1-7 | 1-5 | 6, 7 |
| Physics C: E&M | 8-13 | 8-12 | 13 |
| Precalculus | 1-4 | all | none |
| Statistics | 1-5 | all | none |

Subject keys in the export use the taxonomy underscore form (`ap_calculus_ab`) for the join to `taxonomy_topics`; the exam-code export is keyed the same way (a mismatch would have returned 0 rows; it returned 4,792 published items).

## Definitions of "missing"
Unchanged from the Units 1-5 audit. Topic cell: primary cell, `skill_code` null, `validated`, on the latest published version. Serving label: latest non-superseded serving label, `validated`, `max_required_unit` set, hash equals `taxonomy_relevant_hash(latest version)`. Unit of an item = validated cell, else authored/provisional cell, else label, else `prompt_json`. Difficulty and skill cells are reported but out of scope. Statistics skill cells nullable by design.

## Result (recounted from the raw export)
4,792 published item rows. **242 are in scope (Units 6+, published latest version, not teaching).** **141 have a gap**: 141 lack a validated topic cell, 86 of those also lack a servable serving label; 55 have a servable label but no validated topic cell.

| Subject | u | MCQ | FRQ | no topic cell | no serving label |
|---|---|---|---|---|---|
| Biology | 6 / 7 / 8 | 5/5/5 | 10/14/12 | 0/1/1 | 0/0/1 |
| Calculus AB | 6 / 7 / 8 | 11/4/9 | 6/3/9 | 17/7/18 | 9/4/16 |
| Calculus BC | 6 / 7 / 8 / 9 / 10 | 7/2/4/3/8 | 4/1/2/0/5 | 5/3/6/3/4 | 5/3/6/3/4 |
| Chemistry | 6 / 7 / 8 / 9 | 5/6/9/7 | 6/5/11/5 | 3/4/9/3 | 3/4/9/3 |
| Physics 1 | 6 / 7 / 8 | 2/4/8 | 1/4/2 | 2/8/10 | 1/3/1 |
| Physics 2 | 14 / 15 | 6/4 | 1/2 | 7/6 | 0/2 |
| Mechanics | 6 / 7 | 6/6 | 1/2 | 7/7 | 3/3 |
| E&M | 13 | 6 | 4 | 10 | 3 |
Full table: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/gap_table_u6plus.txt`.

Gap items by type (all subjects): **all 141 are seeds except 6 Calculus AB MCQ variants**; MCQ 82 (76 seeds + 6 variants), FRQ 59.
Topic cell state of the 141: 97 none, 41 `provisional_model` (Calculus AB; the selector ignores a provisional cell for topic_match), 3 `authored`.
Serving state of the 141: 55 ok (cell gap only), 50 only `provisional_model`, 35 only `held`, 1 stale hash.
Out of scope, unchanged: difficulty rows missing 0 of 242 (all present); skill cells missing 200 of 242.

## Excluded, as directed
`apphy1-mcq-022` (Unit 6), `apphycm-frq-003` (Unit 7), `apchem-frq-l-017` (Unit 8) were labeled last round and read back as fully labeled (validated cell, hash-fresh label); they are not in the 141.

## Open questions (flagged, not fixed)
1. **74 published items have no resolvable unit** (no cell, no label, no unit in `prompt_json`; Calc BC 37, Chemistry 8, Physics 1 7, Mechanics 7, Physics 2 6, E&M 5, Precalc 3, Biology 1). All 74 are held or legacy-unvalidated (44 FRQ held, 29 MCQ held, 1 FRQ legacy), so none is served today; this is the same population Units 1-5 left aside (74 there too). They cannot be assigned to "units 6+" without a vote. Proposal: out of scope unless the owner wants a vote over all 74 (about $0.5-1).
2. 35 gap items have only a **held** label. Hold reasons are read in Stage 2; `rubric_preflight_failure` holds stay held (owner decision per class).
3. `APBIO-FRQ-S-103` (cell unit vs label unit differ) and `apchem-frq-l-017` (cell vs prompt unit, already labeled) show unit conflicts; `apcalcab-mcq-016` and `apcalcab-mcq-np2-006` have cells on an older version (a version bump left them behind).
4. Of the 242, 65-style lifecycle defects (published item, retired latest version) are excluded by the published-latest-version filter and not touched.

Stage boundary: stopping here for Stage 1 report before the Stage 2 plan.
