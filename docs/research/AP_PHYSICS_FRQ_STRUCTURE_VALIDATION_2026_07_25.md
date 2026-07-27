# AP Physics FRQ Structure Validation

Date: 2026-07-25  
Scope: Production content for `ap_physics_1`, `ap_physics_2`, `ap_physics_c_mechanics`, and `ap_physics_c_em`

## Executive conclusion

The prompt's central diagnosis is confirmed with one important qualification.

All 136 current production Physics FRQs are structurally too small to represent a complete current AP Physics free-response question. Their latest versions carry only 2, 3, or 6 points, while the four current CED archetypes require 8, 10, 10, or 12 points. None meets the point total of its mapped archetype.

However, the database does not contain 66 genuinely unclassified questions. Sixty-four of those questions use older deterministic family tags that map cleanly to the current archetypes. Only two questions lack a usable archetype tag. The present inventory is best understood as a bank of targeted FRQ drills that is incorrectly positioned if it is used as a bank of exam-representative, full-scale FRQs.

No production content was modified during this validation phase.

## Current CED sources

The following exact Google Drive files were fetched and searched in full:

| Subject | Drive file ID | File name |
|---|---|---|
| AP Physics 1 | `1cgb6SQ1YWzwoD1lNTVJ6TZEP17ypDHeg` | `ap-physics-1-course-and-exam-description.pdf` |
| AP Physics 2 | `1oE15zOd6YqBJ_MIgrg34s_toAT8_GbEq` | `ap-physics-2-course-and-exam-description.pdf` |
| AP Physics C: Mechanics | `16Oh-XnX2d9nGFTovmVJelWlK_f_37w80` | `ap-physics-c-mechanics-course-and-exam-description.pdf` |
| AP Physics C: Electricity and Magnetism | `1n5CKL7v5kyliZ2yN2VxDVHBHUASWIeqN` | `ap-physics-c-electricity-and-magnetism-course-and-exam-description.pdf` |

Each current CED specifies the same four-question, 40-point free-response structure:

| Question | Archetype | Total points | Scoring-guideline subparts |
|---|---|---:|---|
| Q1 | Mathematical Routines | 10 | A: 7, B: 3 |
| Q2 | Translation Between Representations | 12 | A: 3, B: 4, C: 3, D: 2 |
| Q3 | Experimental Design and Analysis | 10 | A: 2, B: 2, C: 4, D: 2 |
| Q4 | Qualitative/Quantitative Translation | 8 | A: 3, B: 3, C: 2 |

The scoring-guideline headers explicitly identify totals of 10, 12, 10, and 8 points, respectively. The four question totals sum to 40 points.

One extracted line in the Physics 2 PDF labels the three-point Q2 section as part D. The surrounding sequence, the following two-point part D, the 12-point total, and all three other current CEDs establish that this is a PDF text-extraction artifact: the three-point section is part C.

## Production audit

Project: `pcntajvbdfqhbeewmdry`

The audit evaluated every latest production FRQ version for the four subjects by actual stem content, points, tags, review decisions, and active review assignments.

| Subject | Latest FRQs | Exact current archetype-name tag | Latest versions with a decision | Latest versions with active assignment |
|---|---:|---:|---:|---:|
| AP Physics 1 | 34 | 16 | 31 | 17 |
| AP Physics 2 | 34 | 18 | 15 | 19 |
| AP Physics C: Mechanics | 34 | 18 | 16 | 18 |
| AP Physics C: E&M | 34 | 18 | 15 | 19 |
| **Total** | **136** | **70** | **77** | **73** |

Point-value histogram:

| Subject | 2 points | 3 points | 6 points | Meets mapped full-question total |
|---|---:|---:|---:|---:|
| AP Physics 1 | 18 | 11 | 5 | 0 |
| AP Physics 2 | 16 | 13 | 5 | 0 |
| AP Physics C: Mechanics | 16 | 11 | 7 | 0 |
| AP Physics C: E&M | 16 | 11 | 7 | 0 |
| **Total** | **66** | **46** | **24** | **0** |

The latest-version point range is 2–6. Even the largest item falls below the smallest current full-question total of 8 points.

## Archetype normalization

The older tags are deterministic and match the actual content families:

| Legacy tag suffix | Current archetype |
|---|---|
| `-frq-math` | Mathematical Routines |
| `-frq-representation` | Translation Between Representations |
| `-frq-experimental` | Experimental Design and Analysis |
| `-frq-translation` | Qualitative/Quantitative Translation |

Applying this normalization classifies 134 of 136 FRQs. The two remaining items are:

- `apphy1-frq-017`: satellite derivation and period prediction; best-fit archetype is Mathematical Routines.
- `apphy1-frq-018`: free-body diagram plus equilibrium/Archimedes translation; best-fit archetype is Translation Between Representations.

Both currently have an empty `prompt_json` object and require an explicit classification decision.

## Mapped inventory by archetype

| Subject | Mathematical Routines | Translation Between Representations | Experimental Design and Analysis | Qualitative/Quantitative Translation | Unclassified |
|---|---:|---:|---:|---:|---:|
| AP Physics 1 | 7 | 9 | 9 | 7 | 2 |
| AP Physics 2 | 8 | 8 | 11 | 7 | 0 |
| AP Physics C: Mechanics | 9 | 11 | 9 | 5 | 0 |
| AP Physics C: E&M | 9 | 8 | 9 | 8 | 0 |

Every cell above contains zero full-sized questions.

## Assessment of the correction prompt

### What the prompt gets right

- It correctly requires the current CED files to be treated as the source of truth.
- It correctly distinguishes a full AP-style FRQ from a short prompt with one or two criteria.
- It correctly rejects point inflation without substantive authoring.
- It correctly requires version forks for reviewed content, preservation of review history, small batches, and production reconciliation.
- It correctly pauses execution for an explicit product-scope decision.

### Recommended improvements

1. **Define the verified structural contract.** Add the four point totals and subpart allocations above. State whether exact subpart counts and point allocations are mandatory product templates or whether an item may vary while preserving total points, archetype skills, and comparable complexity.

2. **Normalize legacy tags before measuring taxonomy gaps.** The prompt should distinguish:
   - exact current display-name tags;
   - deterministic legacy tags that can be normalized;
   - truly unclassified content.

3. **Define the product-use distinction.** A 2–6 point item is not necessarily bad instructional content. It is structurally invalid as a full exam-representative FRQ, but can remain useful as a targeted drill if explicitly classified and excluded from full-exam selection.

4. **Specify how exam representativeness is stored and enforced.** Do not rely only on `frq_form`. Use an explicit, queryable classification such as `practice_format='targeted_drill'` versus `practice_format='full_exam_frq'`, plus a canonical archetype. The student-selection logic must honor it.

5. **Define the size of the replacement bank.** Option (b) needs an exact initial item count per subject and archetype. A recommended first production batch is 16 full-scale items: one item for each of the four archetypes in each of the four subjects. Review that vertical slice before scaling.

6. **Separate correction from publication.** New or materially rewritten content should enter the live production review queue and become student-visible only after human approval. Any owner override should be explicit and separately audited.

7. **Protect reviewed history when relabeling drills.** Because classification affects where an item is served, changes to reviewed versions should be made through a new version or a dedicated use-classification relation with its own audit trail.

8. **Add selection-layer verification.** Database reconciliation alone is insufficient. The correction should also prove that full-exam assembly cannot select targeted drills and that drill experiences can still select them intentionally.

9. **Add semantic QA gates.** Each full-scale FRQ should be checked for coherent shared scenario, dependency among subparts, archetype-specific skill coverage, realistic time demand, point-to-work alignment, answer completeness, diagram/data sufficiency, algebra-only versus calculus-based boundaries, and non-duplication.

## Recommended correction strategy

Use option (b):

1. Preserve the 136 current items and their review history.
2. Normalize their archetype metadata, resolve the two unclassified Physics 1 items, and classify all 136 as targeted drills.
3. Exclude targeted drills from full-exam simulation and any experience that claims to serve complete AP-style FRQs.
4. Author an initial bank of 16 new full-scale FRQs: one per current archetype per subject.
5. Require the current CED total points and, unless the product owner chooses otherwise, the verified current subpart template for each archetype.
6. Insert the new items into the live review pipeline in small, independently reconcilable batches.
7. Publish for student use only after required human review and verify the serving path against production.

This strategy repairs the misleading product classification quickly, retains useful instructional material, avoids rewriting 136 reviewed items, and creates a representative bank that can be quality-tested before expansion.

## Decision required before mutation

Phase 2 would materially alter content classification, serving eligibility, and the size of the full-scale authoring commitment. It should begin only after the product owner confirms:

1. option (b) and the proposed initial bank size, or a different scope;
2. whether exact current CED subpart patterns are mandatory;
3. whether publication must follow ordinary human review or use an explicit owner override.

## Follow-up: Physics C verbatim point-total evidence

The exact current CED PDFs were fetched again from Google Drive on 2026-07-25.
The following point-total lines appear verbatim in both the AP Physics C:
Mechanics file (`16Oh-XnX2d9nGFTovmVJelWlK_f_37w80`) and the AP Physics C:
Electricity and Magnetism file
(`1n5CKL7v5kyliZ2yN2VxDVHBHUASWIeqN`):

> Total for Question 1 10 points

> Total for Question 2 12 points

> Total for Question 3 10 points

> Total for Question 4 8 points

The E&M scoring-guideline header also states verbatim:

> Scoring Guidelines for Question 1: Mathematical Routines 10 points

The Mechanics and E&M scoring-guideline headers identify Question 4 as:

> Scoring Guidelines for Question 4: Qualitative/Quantitative Translation 8 points

These independent, current Physics C sources confirm the same 40-point
10/12/10/8 structure found in Physics 1 and Physics 2.

## Follow-up: actual serving-layer trace

Current student frontend:

- Lovable project: `d334fed9-5a97-4e76-906e-7c0ad7082212`
- Published URL: `https://exam-buddy-wireframe.lovable.app`
- Inspected commit: `9db07ba94ce6f3362a0d3b67f50d7235a1cffe57`

The current FRQ serving hook is `src/lib/use-published-frq.ts`. It selects all
rows satisfying:

- `content_item_versions.status = 'published'`;
- the active `exam_pack_version_id`;
- `content_items.item_type = 'frq'`; and
- `content_items.status = 'published'`.

It does not filter on `frq_form`, point total, archetype, or any
exam-representativeness field. The student route
`src/routes/_ux.session.frq.tsx` then uses `frq.items[0]`.

Therefore a database-only label would not change which FRQ the application
serves. The current production database has zero Physics FRQs for which both
the item and version are published, so no Physics student is presently being
served one of these 136 questions through this route. The defect is dormant
rather than currently exposed. It would become student-facing as soon as the
existing Physics content is published without a serving fix.

### Required enforcement design

The serving fix must be completed before any Physics FRQ publication:

1. Add a canonical, constrained use classification to the active
   `content_items` / `content_item_versions` model. Do not use
   `app.question_use_assignments`: it references the noncanonical
   `artifact_versions` model, currently has zero rows, and does not govern the
   student content path.
2. Use at least:
   - `targeted_drill`;
   - `full_exam_frq`.
3. Store a canonical Physics FRQ archetype separately from the use
   classification.
4. Replace the frontend's direct “all published FRQs” query with a
   server-owned candidate-selection RPC or Edge Function that requires the
   requested practice format and filters on it.
5. Make the session record carry the requested practice format.
6. In the deployed `attempt-response` Edge Function's `create_attempt`
   operation, load the session format and the selected content's format and
   reject mismatches. The current function validates published status, item
   type, and exam-pack identity, but not exam representativeness.
7. Update the UI routes:
   - “Short FRQ” or targeted topic practice requests `targeted_drill`;
   - “Long FRQ” or full-exam practice requests `full_exam_frq`;
   - recommendation mode must choose explicitly rather than accept either.
8. Add integration tests proving both directions fail closed:
   - a targeted drill cannot be returned or attempted in a full-exam session;
   - a full-exam FRQ cannot be returned accidentally in a short-drill session.
9. Add a production reconciliation that proves every published Physics FRQ has
   exactly one allowed classification and every full-exam candidate satisfies
   its archetype's required total and structural validation.

This makes exam representativeness a server-enforced serving contract rather
than optional frontend metadata.

## Phase 2 execution: approved Option B

David approved Option B on 2026-07-25, made the exact CED subpart templates
mandatory, and directed that all new questions use the ordinary human-review
pipeline. The work below was completed against Supabase project
`pcntajvbdfqhbeewmdry`.

### Source identifiers

The four exact current CEDs used for structural verification are the Drive
files listed above. Content scope and taxonomy were checked against the four
current CED Fact Packs:

| Subject | Current CED Fact Pack ID | Frozen `exam_pack_version_id` |
|---|---|---|
| `apphy1` | `1WTHwHrJujEuBzAXsL92zQdnHXlE-cvgsArE_FOVdR1g` | `29c719dc-701b-470f-9e49-fab981722d3f` |
| `apphy2` | `10jX6Pmtd6vxhg-iqKAPh56UCyjy5l4kLFZC2AOaUo84` | `f584ab0d-114a-4520-9649-42e3e9a2fd22` |
| `apphycm` | `1rc_z7A4CmhDx1Ya6zJswnKYm2wtOrLsJRK-7qBzDxG0` | `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9` |
| `apphycem` | `1AwMAtwpUj798kRROyz4O8q9w36YubauEeB7122mrJM0` | `841a88cc-773c-44e5-97fa-6504f8667689` |

Live maximum FRQ keys were frozen at `034` for every subject before
authoring. A fresh pre-insert query again returned `034` and zero rows in the
reserved `035`–`038` range for all four subjects.

### Classification and database enforcement

Migration `20260726035636_physics_frq_serving_contract.sql`:

- added constrained `practice_format` and canonical `frq_archetype` fields;
- classified all 136 existing Physics FRQs as `targeted_drill`;
- normalized all legacy archetype labels and explicitly mapped
  `apphy1-frq-017` and `apphy1-frq-018`;
- added a deferred publication validator that enforces the exact CED point
  vectors and per-part rubric sums for every `full_exam_frq`;
- prevents live reclassification of an item that has a published version;
- added the fail-closed `public.select_practice_frqs` RPC.

The deployed `session-event` function records the selected practice format.
The deployed `attempt-response` function rejects a content/session format
mismatch. Frontend PR
`david-bloom/exam-buddy-wireframe#1` replaced the unscoped FRQ query with the
RPC, made the route request an explicit format (defaulting existing short
practice to `targeted_drill`), carried that exact format into the learning
session, and prevented cross-format session reuse. Focused tests and a
production build passed. The PR was merged as
`5e7cf6dc723f8df77e396d3e4e1a58fa90d023ea`, and the production deployment
completed successfully.

Thus the classification is enforced at candidate selection, session creation,
and attempt creation. A drill cannot be attempted as a full-exam FRQ merely
because a client supplies its version ID.

### New full-scale bank

Exactly 16 original questions were added, one per subject/archetype:

- `apphy1-frq-035` through `apphy1-frq-038`
- `apphy2-frq-035` through `apphy2-frq-038`
- `apphycm-frq-035` through `apphycm-frq-038`
- `apphycem-frq-035` through `apphycem-frq-038`

Within each range, the archetype order is Mathematical Routines, Translation
Between Representations, Experimental Design and Analysis, and
Qualitative/Quantitative Translation. Their point vectors are, respectively,
`[7,3]`, `[3,4,3,2]`, `[2,2,4,2]`, and `[3,3,2]`.

Physics 1 and Physics 2 questions are algebra based. The Physics C questions
use calculus where it is instructionally appropriate. Every question has a
coherent shared scenario, explicit mandatory subparts, a complete original
answer, and one discrete one-point criterion per available point. No released
question or scoring-guideline content was adapted.

### Old/new unit distribution

The old figures below are a reproducible latest-version aggregation from the
first `unit-N-*` module in each legacy payload. The two payloads without a
module were mapped by actual content: `apphy1-frq-017` to Unit 6 and
`apphy1-frq-018` to Unit 8. New questions store an explicit current-CED
`unit` and `topic`.

| Subject | Unit | Old drills | Added full FRQs | New total |
|---|---:|---:|---:|---:|
| `apphy1` | 1 | 4 | 0 | 4 |
| `apphy1` | 2 | 6 | 1 | 7 |
| `apphy1` | 3 | 6 | 1 | 7 |
| `apphy1` | 4 | 4 | 0 | 4 |
| `apphy1` | 5 | 4 | 0 | 4 |
| `apphy1` | 6 | 3 | 0 | 3 |
| `apphy1` | 7 | 4 | 1 | 5 |
| `apphy1` | 8 | 3 | 1 | 4 |
| `apphy2` | 9 | 6 | 1 | 7 |
| `apphy2` | 10 | 6 | 0 | 6 |
| `apphy2` | 11 | 5 | 1 | 6 |
| `apphy2` | 12 | 4 | 1 | 5 |
| `apphy2` | 13 | 4 | 1 | 5 |
| `apphy2` | 14 | 4 | 0 | 4 |
| `apphy2` | 15 | 5 | 0 | 5 |
| `apphycm` | 1 | 4 | 0 | 4 |
| `apphycm` | 2 | 7 | 1 | 8 |
| `apphycm` | 3 | 5 | 1 | 6 |
| `apphycm` | 4 | 5 | 0 | 5 |
| `apphycm` | 5 | 4 | 1 | 5 |
| `apphycm` | 6 | 6 | 1 | 7 |
| `apphycm` | 7 | 3 | 0 | 3 |
| `apphycem` | 8 | 7 | 1 | 8 |
| `apphycem` | 9 | 6 | 0 | 6 |
| `apphycem` | 10 | 5 | 0 | 5 |
| `apphycem` | 11 | 7 | 1 | 8 |
| `apphycem` | 12 | 5 | 1 | 6 |
| `apphycem` | 13 | 4 | 1 | 5 |

The initial vertical slice deliberately prioritizes high-leverage coverage
while also spanning distinct units. Because every subject receives exactly one
question of every archetype, archetype structure—not artificial equalization
of every unit—is the controlling allocation rule for this first bank.

### Transaction and review-pipeline approach

The durable source is
`scripts/content-seed/physics-frq-full-scale-2026-07-25/`. It contains:

- the complete authored payload;
- deterministic IDs derived from content key and row purpose;
- generated subject-sized batch SQL;
- a manifest of keys, IDs, archetypes, units, points, and point vectors.

Each batch runs in one transaction across `app.content_items`,
`app.content_item_versions`, `app.frq_criteria`, and
`app.content_review_assignments`. It raises on a material key collision and
becomes a no-op when its exact deterministic item ID already exists. Inserts
were performed as two independently verified batches of eight.

Every new version has exactly one assignment to Muhammad Saood Iqbal
(`cee0cee4-fc59-4084-9a83-b24ccca940b9`) with:

- `review_stage='tutor_question'`
- `status='pending'`
- `review_kind='frq'`

Items and versions remain `assigned`, with
`review_status='tutor_review_pending'`. None of the new questions was
published or made student-visible before human review.

### Final live reconciliation

Fresh production queries returned:

| Subject | Total Physics FRQs | Targeted drills | Full-exam FRQs | New-key range |
|---|---:|---:|---:|---|
| `apphy1` | 38 | 34 | 4 | 035–038 |
| `apphy2` | 38 | 34 | 4 | 035–038 |
| `apphycm` | 38 | 34 | 4 | 035–038 |
| `apphycem` | 38 | 34 | 4 | 035–038 |

For every subject, the reconciliation returned:

- `new_items=4`
- `full_long=4`
- `archetypes=4`
- `correctly_queued=4`
- `hash_ok=4`
- `exactly_one_assignment=4`
- `complete_rubrics=4`

Across all subjects this proves exactly 16 new items, 160 one-point rubric
criteria, and 16 correct review assignments. The literal archetype query
returned exactly one row for each subject/archetype pair with the mandatory
point vector.

Exact duplicate stems: zero. A token-set Jaccard comparison of complete
question content (stem, stimulus, prompts, and rubric payload) against all
Physics FRQs produced a maximum of `0.524`; no semantic near-duplicate crossed
the prior content-bank rejection threshold. Boilerplate-only stem comparison
was intentionally not treated as semantic duplication because all full FRQs
share the same mandatory student directions.

The only caveat is intentional: the new full-scale questions are queued, not
published. The full-exam selector therefore returns no student candidates
until human review approves and publishes them. Once publication is attempted,
the deferred database validator requires the exact archetype structure before
the transaction can commit.
