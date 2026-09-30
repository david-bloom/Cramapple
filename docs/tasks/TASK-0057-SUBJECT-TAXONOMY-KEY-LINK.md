# TASK-0057 — One Real Link Between Subjects and Their Taxonomy

**Status:** Not Started. **Post-launch** (not October 2 gating).
**Tier:** Hard-Gate (schema migration on both environments)
**Owner:** TBD
**Product Owner:** David Bloom
**Date opened:** 2026-09-30
**Supersedes:** PR #268 (closed unmerged; its migration `20260929190000` was never applied anywhere)
**Area:** Schema / taxonomy / serving correctness

## The problem

Two tables name the same subject in two spellings, and nothing in the database links them:

- `app.subjects.subject_key`: hyphenated (`ap-statistics`), and Biology is just `biology`.
- `app.taxonomy_source_versions.subject_key`: underscored (`ap_statistics`, `ap_biology`).

Every subject-to-taxonomy join converts one spelling into the other. The obvious conversion,
`replace(subject_key, '_', '-')`, maps nine of ten subjects and **silently drops Biology**. A missed
match returns zero rows, which serving reports as "this subject has no content". This is the
silent-absence failure mode (runbook Trap 4). `app.normalize_student_subject_key()` gets it right, but
only when people remember to use it.

## Why PR #268 was closed

#268 added a `subject_id` foreign key, backfilled through the normalizer, with a check that raises on
any unmapped row. That direction is right, but it was only step 1: nothing was moved onto the new
column, so every join kept converting strings and the trap stayed live. This task ships all three
steps together.

## The fix (three steps, one change)

1. **Add the link.** `app.taxonomy_source_versions.subject_id uuid references app.subjects(id)`,
   backfilled through `app.normalize_student_subject_key()`. The migration **raises** if any row fails
   to map, then sets the column `not null`. Reuse #268's migration and QA script as the starting point
   (branch `claude/taxonomy-subject-id-link`, file
   `supabase/migrations/20260929190000_taxonomy_source_versions_subject_id.sql`, and
   `scripts/qa/taxonomy_subject_link_qa.sql`), under a new version.
2. **Move every subject-to-taxonomy join onto `subject_id`.** No code path converts spellings
   afterwards.
3. **Guard it.** A CI check (alongside `answer-key-exposure-guard` in
   `.github/workflows/servable-items-check.yml`) that fails if any `taxonomy_source_versions` row has no
   `subject_id`, or any active subject has no taxonomy version. Plus a source check that fails on a new
   hand-written `replace(... subject_key ...)` outside the normalizer.

## Step 2 inventory (initial sizing, Production, read-only, 2026-09-30)

Live database functions that touch this path:

| Function | Uses normalizer | Hand conversion | Reads `taxonomy_source_versions` |
| --- | --- | --- | --- |
| `app.normalize_student_subject_key(text)` | (is it) | yes (by design) | no |
| `public.get_student_taxonomy(text)` | yes | **yes** | yes |
| `public.get_student_progress_dashboard(text)` | yes | no | yes |
| `public.get_topic_point_guides(text, integer, text)` | yes | no | no |
| `public.get_home_start_queue(uuid, integer)` | **no** | no | yes (**check how it matches subjects**) |
| `app.seed_taxonomy_units(...)`, `app.seed_taxonomy_topics(...)` | no | no | yes (seed-time; take `subject_id` as input) |
| `app.taxonomy_scope_selftest()` | no | no | yes |

The repo has about 12 hand conversions, almost all in historical seed migrations that have already run.
Those are not live code and need no change.

**Still to inventory:** edge functions (`supabase/functions/**`, especially
`_shared/student-item-delivery.ts` and `student-session-items`), the Lovable app `56cae479`
(`src/lib/taxonomy/*`, `topic-content.ts`, `active-subject.ts`), and `topic_explainers` /
`topic_point_briefs`, which key the taxonomy as plain text (TASK-0054).

## Not doing

Renaming one side so both tables share one spelling. That removes the problem at the root, but it
touches every table, function, URL and stored key that uses a subject key. Revisit only if step 2
turns up far more readers than the inventory above suggests.

## Rollout

Dev apply, verify, approval, Production apply, **then** merge (runbook Trap 7). Commit each migration
under the version each environment records (Trap 1). Step 2's function changes ship in the same
migration set as step 1, so no window exists where the column is present but unused.

## Verification

- [ ] Every `taxonomy_source_versions` row has a non-null `subject_id` on both environments; Biology maps.
- [ ] No live function, edge function or app code converts subject-key spellings (source search plus
      a `pg_proc` scan).
- [ ] `get_student_taxonomy`, `get_student_progress_dashboard`, `get_topic_point_guides` and
      `get_home_start_queue` return the same rows before and after, for all ten subjects.
- [ ] The CI guard fails on a deliberately unmapped test row (on Dev, rolled back) and passes clean.
- [ ] Fresh independent QA.
