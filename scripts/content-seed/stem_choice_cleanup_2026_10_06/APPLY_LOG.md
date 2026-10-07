# Apply log: MCQ stem/choice cleanup, Production (2026-10-06)

- **Approval:** APPROVAL-0127 (David Bloom, Product Owner). Covers all 198 items: 191 clean + 7 review.
- **Project:** `pcntajvbdfqhbeewmdry`, through the Supabase MCP `execute_sql`.
- **Files:** `gen_chunks.py` built the chunked apply files with `gen_sql.body()` and `apply_targets()`. The logic is unchanged.
  Each chunk differs from `prod_apply.sql` only in `v_approval` and its own target count. All postconditions are scoped to the chunk.
  - `prod_apply_chunk_01.sql` … `_08.sql` (25 rows each × 7, then 16)
  - `prod_apply_review7_approved.sql` (7 rows)
  - `chunks_manifest.json`
- **Verify:** `prod_verify_compact.sql` is a read-only equivalent of `prod_verify.sql`. It uses 12-hex md5 prefixes and adds a residual count, because the original is 38 KB and too large for one MCP call.
- **Unchanged:** the original `prod_apply.sql`, `prod_apply_review7.sql`, `prod_verify.sql` and `prod_rollback.sql`. Their md5s were confirmed after the run.
- **Comments:** SQL comments were dropped from the DO blocks when they were sent. No code was changed.

## Baseline (before any write)
- rows 198; clean 191 still_old; review 7 still_old; other 0; not_published 0; not_latest 0; choices_changed 0
- labels: validated_fresh 148, provisional_model_fresh 15, provisional_model_null 1, held_fresh 32, held_nonfresh 2
- servable 148; desync 0; carried_forward 0; residual inline-list rows among all published MCQs: 198
- serving selector, as md5 of the version-id set (limit 500):
  - AB pack 826c8cf1, unit 1: 50 items, `b8bfbba2…`, 3 with an inline list
  - Chem pack c9ca46b2, unit 8: 50 items, `c9fa97d4…`, 43 with an inline list
  - Both deterministic across 2 runs.

## Dry run
- Chunk 01 ran as `begin; <DO>; rollback;` in one call with no error.
- A re-check showed 0 rows cleaned and 0 carried forward, so the rollback held.

## Chunks
Each chunk was applied as the DO block plus a check SELECT in one call. The check compares md5(stem) with the locally computed cleaned-stem md5, counts stale labels, and checks that validated labels have `validated_against_taxo_hash = app.taxonomy_relevant_hash(version)`.

| Chunk | Rows | Cleaned | Unpublished | Stale | Validated (fresh) | Carried forward |
|---|---:|---:|---:|---:|---:|---:|
| 01 | 25 | 25 | 0 | 0 | 16 (16) | 25 |
| 02 | 25 | 25 | 0 | 0 | 6 (6) | 25 |
| 03 | 25 | 25 | 0 | 0 | 19 (19) | 25 |
| 04 | 25 | 25 | 0 | 0 | 23 (23) | 25 |
| 05 | 25 | 25 | 0 | 0 | 21 (21) | 25 |
| 06 | 25 | 25 | 0 | 0 | 23 (23) | 25 |
| 07 | 25 | 25 | 0 | 0 | 22 (22) | 25 |
| 08 | 16 | 16 | 0 | 0 | 12 (12) | 16 |
| review7 | 7 | 7 | 0 | 0 | 6 (6) | 7 (review7 key) |

Validated across all chunks: 142 + 6 = 148. No chunk raised.

## Final verify
- rows 198; clean 191/191 cleaned; review 7/7 cleaned; other 0; not_published 0; not_latest 0; choices_changed 0
- by subject: apchem 68/68, apcalcbc 42/42, apcalcab 26/26, apphycm 22/22, apphy2 20/20, apphycem 20/20
- labels are identical to the baseline: validated_fresh 148, provisional_model_fresh 15, provisional_model_null 1, held_fresh 32, held_nonfresh 2. No stale labels.
- servable 148; desync 0; carried_forward 191 + 7 (review7 key)
- residual inline-list rows among all published MCQs: **0**
- Spot checks:
  - apcalcab-mcq-021: "What is lim(x→2) (x²−4)/(x−2)?"
  - apchem-mcq-021: "A sample of pure glucose (C6H12O6, molar mass = 180.16 g/mol) has a mass of 90.0 g. How many moles of glucose does the sample contain?"
  - apchem-mcq-017: "The pH of 1.0×10⁻³ M HCl is approximately\n\nAssume 25 C."
- Serving after the apply: AB unit 1 and Chem unit 8 return the same version-id sets (`b8bfbba2…`, `c9fa97d4…`, 50 each). Chem unit 8 now serves 0 stems with an inline list (43 before).

## Result
All 198 rows were applied. No rollback was needed or run, and nothing was committed to git.

## Still to do
- Drop the Development rehearsal table `public.scc_rehearsal_chunks_20261006`.
- Fix the upstream import (see REPORT.md).
