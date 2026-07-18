# Calculus Three-Subject Tutor Seed — Production Evidence

**Executed:** 2026-07-17
**Target:** Supabase main production database `pcntajvbdfqhbeewmdry`
**Scope:** AP Calculus AB, AP Calculus BC, and AP Precalculus draft content only

## Authorization and boundaries

David Bloom directed creation of the three question sets for future Tutor review and previously identified the Supabase branch as source of truth. The Cramapple project has no preview database branches, so the linked main production database was positively identified before mutation.

The load:

- created no published content;
- created no Tutor identity;
- created no review assignment;
- changed no existing Biology or Statistics content;
- deployed no Edge Function or persistent schema object;
- used only production-native content, label, choice, and rubric tables.

## Authored inventory

| Course | MCQ | FRQ | Total | FRQ rubric criteria |
|---|---:|---:|---:|---:|
| AP Calculus AB | 20 | 16 | 36 | 48 |
| AP Calculus BC | 20 | 16 | 36 | 48 |
| AP Precalculus | 20 | 16 | 36 | 96 |
| **Total** | **60** | **48** | **108** | **192** |

The MCQ rows contain 240 answer choices in total. Every item is tagged with its unit, difficulty, and the workflow label `tutor-review-seed-2026-07-17`.

## Pre-application verification

1. All 108 JSON packages validated against `item-package.schema.json`.
2. All three subject packages validated against `subject-package.schema.json`.
3. The subject-harness compiler accepted all three plans with zero advisories.
4. Content hashes, content-key uniqueness, unit coverage, difficulty coverage, answer-key alignment, rubric evidence, and prompt near-duplicates were checked.
5. A production-native SQL loader was generated from the validated packages.
6. The complete loader succeeded in a production transaction ending in `ROLLBACK` before the identical committed transaction was run.
7. The calculus regression tests plus existing subject-harness tests passed: 22 passed, 0 failed.

## Post-application production verification

| Exam code | Total | MCQ | FRQ | Draft item + version | Non-null review status | Assignments |
|---|---:|---:|---:|---:|---:|---:|
| `ap_calculus_ab` | 36 | 20 | 16 | 36 | 0 | 0 |
| `ap_calculus_bc` | 36 | 20 | 16 | 36 | 0 | 0 |
| `ap_precalculus` | 36 | 20 | 16 | 36 | 0 | 0 |

Additional integrity results for every course:

- bad/missing stems: 0;
- bad/missing prompt payloads: 0;
- incorrect evaluator routing: 0;
- MCQs without exactly four choices and one correct choice: 0;
- FRQs with incorrect criterion or point counts: 0;
- items missing the required labels: 0.

## Deferred action

When a qualified calculus Tutor is hired, create review assignments from the workflow-labeled draft items. Assignment is intentionally deferred because `app.content_review_assignments.reviewer_id` is non-nullable and Production does not contain the unclaimed-pool harness present on the development branch.
