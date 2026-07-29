# AP Physics content expansion — production audit

Date: 2026-07-24  
Supabase project: `pcntajvbdfqhbeewmdry`  
Schema: `app`

## Outcome

Inserted exactly 160 new review-pipeline items: 40 each for `apphy1`, `apphy2`, `apphycm`, and `apphycem`. No existing content was modified or deleted.

| Subject | Frozen old total | Old FRQ / MCQ | Added FRQ / MCQ | Current total | Current FRQ / MCQ | Final max FRQ / MCQ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `apphy1` | 44 | 18 / 26 | 16 / 24 | 84 | 34 / 50 | 034 / 050 |
| `apphy2` | 36 | 16 / 20 | 18 / 22 | 76 | 34 / 42 | 034 / 042 |
| `apphycm` | 36 | 16 / 20 | 18 / 22 | 76 | 34 / 42 | 034 / 042 |
| `apphycem` | 36 | 16 / 20 | 18 / 22 | 76 | 34 / 42 | 034 / 042 |

## Authoritative sources

The exact current Google Drive fact packs were read before the content audit and authoring:

| Subject | Fact pack | Drive file ID | Live `exam_pack_version_id` |
| --- | --- | --- | --- |
| `apphy1` | AP Physics 1 2026-27 — CED Fact Pack (v3, primary source Fall 2024, use this one) | `1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g` | `29c719dc-701b-470f-9e49-fab981722d3f` |
| `apphy2` | AP Physics 2 2026-27 — CED Fact Pack (v3, primary source, use this one — v2 was a placeholder error) | `10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84` | `f584ab0d-114a-4520-9649-42e3e9a2fd22` |
| `apphycm` | AP Physics C Mechanics 2026-27 — CED Fact Pack (v2, primary source, use this one) | `1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0` | `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9` |
| `apphycem` | AP Physics C E&M 2026-27 — CED Fact Pack (v2, primary source, use this one) | `1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0` | `841a88cc-773c-44e5-97fa-6504f8667689` |

The taxonomy used is the restructured current CED taxonomy: Physics 1 Units 1–8 (including Fluids in Unit 8 and orbital motion in Topic 6.6), Physics 2 Units 9–15, C: Mechanics Units 1–7 (orbital motion in Topic 6.6), and C: E&M Units 8–13. Physics 1 and 2 content is algebra-based; both Physics C banks are calculus-based.

## Actual-content baseline and allocation

The old baseline was reproduced by reading each version's stimulus, stem, choices/criteria, and answer, then mapping the physics actually tested to the current fact-pack taxonomy. Unit labels were not assumed from key order or counts because the schema has no unit column.

### AP Physics 1

| Unit | Old | Added (FRQ / MCQ) | Current |
| --- | ---: | ---: | ---: |
| 1 | 4 | 5 (2 / 3) | 9 |
| 2 | 6 | 10 (4 / 6) | 16 |
| 3 | 6 | 10 (4 / 6) | 16 |
| 4 | 4 | 5 (2 / 3) | 9 |
| 5 | 4 | 5 (2 / 3) | 9 |
| 6 | 8 | 0 (0 / 0) | 8 |
| 7 | 4 | 4 (2 / 2) | 8 |
| 8 | 8 | 1 (0 / 1) | 9 |

Units 2 and 3 received the largest additions because of their exam importance and broad topic surface. Units 1, 4, 5, and 7 received gap-filling representation. Units 6 and 8 already contained the recent orbital-motion and fluids patch, so only one targeted fluids item was added and Unit 6 was not padded.

### AP Physics 2

| Unit | Old | Added (FRQ / MCQ) | Current |
| --- | ---: | ---: | ---: |
| 9 | 6 | 6 (3 / 3) | 12 |
| 10 | 6 | 6 (3 / 3) | 12 |
| 11 | 5 | 7 (3 / 4) | 12 |
| 12 | 5 | 5 (2 / 3) | 10 |
| 13 | 5 | 5 (2 / 3) | 10 |
| 14 | 5 | 5 (2 / 3) | 10 |
| 15 | 4 | 6 (3 / 3) | 10 |

The allocation kept the current CED's full Units 9–15 spread, emphasizing electric circuits and the thin modern-physics Unit 15 while restoring representation in electrostatics, magnetism, waves/optics, and thermodynamics. No fluids content was added to Physics 2.

### AP Physics C: Mechanics

| Unit | Old | Added (FRQ / MCQ) | Current |
| --- | ---: | ---: | ---: |
| 1 | 6 | 3 (1 / 2) | 9 |
| 2 | 7 | 8 (4 / 4) | 15 |
| 3 | 5 | 7 (3 / 4) | 12 |
| 4 | 4 | 7 (3 / 4) | 11 |
| 5 | 5 | 4 (2 / 2) | 9 |
| 6 | 4 | 8 (4 / 4) | 12 |
| 7 | 5 | 3 (1 / 2) | 8 |

The audit found no actual Topic 6.6 orbital item and thin collision, rolling/rotational-energy, and calculus-based force/energy coverage. Units 2, 3, 4, and 6 therefore received the largest additions. Orbital mechanics was authored under Topic 6.6 rather than as a standalone gravitation unit.

### AP Physics C: Electricity and Magnetism

| Unit | Old | Added (FRQ / MCQ) | Current |
| --- | ---: | ---: | ---: |
| 8 | 7 | 9 (4 / 5) | 16 |
| 9 | 6 | 6 (3 / 3) | 12 |
| 10 | 6 | 4 (2 / 2) | 10 |
| 11 | 6 | 10 (4 / 6) | 16 |
| 12 | 5 | 6 (3 / 3) | 11 |
| 13 | 6 | 5 (2 / 3) | 11 |

Units 8 and 11 received the largest allocations because continuous charge distributions/Gauss-law reasoning and multi-loop/transient circuit analysis have broad calculus-based scope and notable observed gaps. The remaining units received balanced additions across potential, capacitance, magnetism, induction, and Maxwell-equation applications.

## Generated content keys

The following inclusive, zero-padded ranges are the complete set of generated keys:

- `apphy1` FRQs: `apphy1-frq-019` through `apphy1-frq-034`; MCQs: `apphy1-mcq-027` through `apphy1-mcq-050`.
- `apphy2` FRQs: `apphy2-frq-017` through `apphy2-frq-034`; MCQs: `apphy2-mcq-021` through `apphy2-mcq-042`.
- `apphycm` FRQs: `apphycm-frq-017` through `apphycm-frq-034`; MCQs: `apphycm-mcq-021` through `apphycm-mcq-042`.
- `apphycem` FRQs: `apphycem-frq-017` through `apphycem-frq-034`; MCQs: `apphycem-mcq-021` through `apphycem-mcq-042`.

These ranges contain 160 unique keys. The deterministic authoring sources and resumable SQL generator are in `scripts/content-seed/physics-expansion/`.

## FRQ archetype mix

| Subject | Mathematical Routines | Translation Between Representations | Experimental Design and Analysis | Qualitative/Quantitative Translation |
| --- | ---: | ---: | ---: | ---: |
| `apphy1` | 3 | 5 | 5 | 3 |
| `apphy2` | 4 | 4 | 7 | 3 |
| `apphycm` | 5 | 7 | 5 | 1 |
| `apphycem` | 5 | 4 | 5 | 4 |

## Insertion and validation approach

Each subject was built and accepted as a separate transaction. The generated SQL:

1. Creates a temporary JSONB payload for exactly one subject.
2. Re-reads live FRQ/MCQ maxima and candidate-key occupancy inside the transaction.
3. Accepts either a pristine frozen baseline or an exact already-inserted 40-row batch, making reruns resumable.
4. Rejects an occupied deterministic key whose version-1 stem hash differs.
5. Rejects a candidate with token-set Jaccard similarity at or above 0.72 against an existing subject stem. `pg_trgm` was not installed, so the check uses normalized database-side token sets.
6. Inserts `content_items`, version 1, FRQ criteria or MCQ choices, and one review assignment.
7. Verifies `content_hash = md5(stem)`, assigned item/version statuses, component completeness, one correct MCQ answer, and exactly one matching review assignment before commit.

The local gate independently checked exact item and type counts, deterministic unique keys, FRQ point/form bounds, choice and criterion completeness, rationale specificity, within-batch near-duplicates, and the algebra-only boundary for Physics 1/2.

One pre-insert candidate (`apphy1-mcq-045`) was correctly rejected as too similar to existing `apphy1-mcq-011` (token Jaccard 0.727). The uninserted draft was replaced with a distinct disk-versus-ring angular-acceleration item and the batch was regenerated. No existing row was changed.

## Final reconciliation

Production reconciliation results:

- New versions: **160**.
- Per subject: **40** each.
- New FRQ/MCQ counts: `apphy1` **16/24**; `apphy2`, `apphycm`, and `apphycem` **18/22** each.
- New item and version statuses equal to `assigned`: **160/160**.
- `content_hash = md5(stem)`: **160/160**.
- Exact duplicate content hashes against any other version: **0**.
- MCQs with anything other than four choices, exactly one correct choice, or a specific nonempty rationale: **0**.
- FRQs with missing criteria, evidence requirements, minimum fixes, or accepted-variant data: **0**.
- New versions with exactly one review assignment: **160/160**.
- Assignments matching reviewer `cee0cee4-fc59-4084-9a83-b24ccca940b9`, `review_stage='tutor_question'`, `status='pending'`, and item-matching `review_kind`: **160/160**.

Representative reconciliation query shape:

```sql
with new_versions as (
  -- Select each subject's frozen pack and keys above its frozen FRQ/MCQ maximum.
)
select
  count(*) as new_versions,
  count(*) filter (where content_hash = md5(stem)) as hash_ok,
  count(*) filter (
    where (select count(*) from app.content_review_assignments a
           where a.content_item_version_id = new_versions.version_id) = 1
  ) as exactly_one_assignment
from new_versions;
```

The final returned values were `160`, `160`, and `160`. The per-subject and per-unit results in the tables above were separately grouped from the same frozen pack IDs and deterministic new-key boundaries.

## Caveat

The old per-unit baseline is an actual-content taxonomy audit rather than a stored unit-field aggregation, because legacy `content_items` do not have a unit/topic column and many old version payloads cannot be treated as a reliable current-CED label. New items carry the current topic and unit module in `prompt_json`, so their unit reconciliation is directly reproducible.
