# TASK-0056 — Close Direct Reads of Answer Keys

**Status:** Not Started. **Launch gating for October 2** (`DECISION-0089`).
**Tier:** Hard-Gate (Production grant changes and a data-exposure fix)
**Owner:** TBD (single agent, single branch)
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Decision:** `DECISION-0089`
**Approval:** none yet. Step 1 is read-only and needs none. Step 3 needs an approval for Development and a separate approval for Production.
**Found by:** `docs/qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md`, finding F1 (PR #277)
**Blocks:** `TASK-0051`'s Production gate
**Area:** Security / answer-key exposure / scoring integrity

## Outcome

No student or anonymous caller can read an answer key except through an intended path. Those paths are
`public.get_open_hand_item`, which records a scoring exclusion, and the grading response, which runs with
service-role access after submission. A check that runs on both environments proves it and keeps it true.

## The finding

Any signed-in user can read MCQ and FRQ answer keys directly through PostgREST. Nothing checks
entitlement and nothing records an exclusion, which also defeats the Open Hand scoring exclusion
(`DECISION-0086`).

- `authenticated` holds column-level `SELECT` on `app.content_item_versions.canonical_answer_1`,
  `canonical_answer_2`, `explanation` and `item_package_payload`.
- RLS policy `content_item_versions_select_published` returns every published version.
- The `app` schema is exposed through PostgREST. Verified on Dev: `PGRST106 … exposed: public, graphql_public, app`.
- `public.content_item_versions` (a `security_invoker` view in the always-exposed `public` schema) re-exposes
  `canonical_answer_1/2` and `explanation`.
- `public.frq_criteria` exposes `evidence_requirements`, `accepted_variants` and `minimum_fix` for every
  published item.

Production has the same grants and policies (read-only SQL, 2026-09-29), with this data behind them:

| Field (published versions) | Production |
| --- | ---: |
| `canonical_answer_1` not null | 928 (380 MCQ letter keys, 548 FRQ model answers) |
| `explanation` non-empty | 391 |
| `item_package_payload.mcq_form.options[].correct` present | 203 |
| `frq_criteria` rows | 2,896 |

**These are already safe:** `mcq_choices.is_correct` / `.rationale` and `canonical_answer_spans` return
`42501` to students. Every edge function reads answer columns through the service-role client, so the fix
does not touch them. Production has had zero student attempts, so there is no sign the leak has been used.

## Decisions this implements (`DECISION-0089`, 2026-09-29)

1. **Launch gating.** This ships before October 2.
2. **`explanation` is post-submission only.** It is delivered with the grade, never readable before
   submission.
3. **The FRQ rubric is a recorded hint.** `evidence_requirements`, `accepted_variants` and `minimum_fix`
   are not directly readable. Where the product shows the rubric before submission, it comes through
   the hint flow so the use is recorded (`DECISION-0080`).

## Field classification

| Field | Class | Intended path |
| --- | --- | --- |
| `content_item_versions.canonical_answer_1/2` | Never student-readable | Open Hand RPC (with exclusion); grading (service role) |
| `content_item_versions.item_package_payload` | Never student-readable. It carries `mcq_form.options[].correct` and `worked_solution` | None. The served shape comes from `student-session-items` |
| `content_item_versions.explanation` | Post-submission only | The grading response |
| `frq_criteria.evidence_requirements / accepted_variants / minimum_fix` | Recorded hint | The hint flow (records use) and the Open Hand RPC |
| `frq_criteria.learner_facing_text / points_possible / criterion_key` | Student-visible | Unchanged (served as parts) |
| `mcq_choices.is_correct / rationale` | Never student-readable | Unchanged (already revoked) |
| `canonical_answer_spans.*` | Never student-readable | Unchanged (already revoked) |

`help_text` is also column-granted. Classify it in step 1 before deciding whether it stays.

## Plan

### 1. Find every legitimate reader (read-only, no approval needed)

Before any grant changes, find every caller of these columns that runs as `authenticated` or `anon`:

- Lovable app `56cae479-f7c9-4988-b536-56538c38ee4e`: search for `content_item_versions`, `frq_criteria`,
  `mcq_choices`, `canonical_answer`, `explanation`, `item_package_payload`, `.schema("app")`.
- Lovable marketing `61dd6602` (anonymous BYOQ, `DECISION-0077`): same search. Note that `anon` holds
  `SELECT` on `public.content_item_versions` in Production, so check its underlying column grants too.
- `david-bloom/exam-buddy-wireframe` reviewer portal: it may read these through the reviewer RLS policies
  (`civ_select_assigned_reviewer`, `frq_criteria_select_assigned_reviewer`).
- Production API logs for the last several days: which of these columns real traffic requests.

For each reader, record the file, the column, the role, and what replaces it. If every reader is covered
by step 3's replacements, proceed. If not, add the missing route to step 3 before revoking.

### 2. Confirm the replacement paths exist

- **Post-submission explanation.** Confirm the grading response (`evaluate-attempt`) already returns
  `explanation`, or add it there, since it runs as service role. The app reads it from the grade and not
  from the table.
- **FRQ rubric as a hint.** Confirm the hint flow serves rubric fields and records the event
  (`assistance_state` / `pre_submit_hint_count`). If it currently reads `frq_criteria` directly from the
  client, move that read server-side.
- **Reviewer portal.** If it reads these columns directly, route it through `SECURITY DEFINER` functions
  gated on an active review assignment or `role='admin'`, read from `app.profiles`. The precedent is
  `public.get_review_mcq_choices`.

### 3. The migration (Development first, then Production, one approval each)

In one migration:

```sql
revoke select (canonical_answer_1, canonical_answer_2, explanation, item_package_payload)
  on app.content_item_versions from authenticated, anon;
revoke select (evidence_requirements, accepted_variants, minimum_fix)
  on app.frq_criteria from authenticated, anon;
-- Recreate public.content_item_versions and public.frq_criteria with an explicit, safe column list
-- (drop the revoked columns), keeping security_invoker = true.
```

Also any reviewer-path `SECURITY DEFINER` functions from step 2, each with `search_path` pinned and
execute granted to `authenticated` only.

Follow runbook Trap 1: commit the file under the version each environment actually records.
Follow runbook Trap 7: apply to Dev, verify, get approval, apply to Production, then merge.

**Rollback:** re-grant the same columns and restore the previous view definitions (keep them in the
migration's header comment).

### 4. The guard (so this cannot come back quietly)

A SQL check, runnable on both environments, that fails if any "never" or "recorded hint" field in the
classification table is selectable by `authenticated` or `anon`. It checks column privileges on base
tables and every view in an exposed schema that projects those columns. Add it to `minimal-ci.yml`
where the schema is available, and add it as a required item on `TASK-0051`'s Verification list,
replacing that task's narrower `mcq_choices`-only item.

### 5. Verify and roll out

- On Dev, re-run the access matrix from the QA report (SQL-level: `role` + `request.jwt.claims`,
  rolled back). Every "never" field must return `42501` to a student, and the Open Hand RPC must still
  work.
- On Dev, click through the app as a student (practice MCQ, practice FRQ with the rubric hint, grade
  view with the explanation) and through the reviewer portal as a reviewer. Nothing breaks, and the
  explanation appears only after submission.
- Then Production, on David's explicit approval, via the CLI or a direct apply. Production deploys are
  refused by the auto-mode classifier by design (runbook Trap 6).
- Watch Production logs for 24 hours for new `42501` / `permission denied` errors from app traffic.
- Run the database advisors and explain anything new.

### 6. Unblock TASK-0051

Fold in the other two QA findings and re-run QA:

- `evaluate-attempt`: replace `.maybeSingle()` on `open_hand_scoring_exclusions` with `.limit(1)`, so a
  student with exclusion rows for two versions of one item gets `409`, not a permanent `500`. Add a unit
  test with two rows.
- Delete the stale `open-hand-item` v9 from Development (not in the repo; the superseded batch path).
  `DECISION-0086`'s recommendation already covers this.

## Verification

- [ ] Step 1 inventory recorded in this file: every reader, its role, and its replacement.
- [ ] `explanation` reaches students only through the grading response, after submission.
- [ ] FRQ rubric fields reach students only through the hint flow, and use is recorded.
- [ ] Reviewer portal still works for an assigned reviewer and for an admin, and refuses an unassigned
      reviewer.
- [ ] Guard query passes on Development: no "never" or "recorded hint" field is selectable by
      `authenticated` or `anon` through `app` or `public`.
- [ ] Guard query passes on Production after the apply.
- [ ] `public.get_open_hand_item` still returns the full key and records the exclusion (entitled
      student), and still refuses the unentitled student.
- [ ] Student and reviewer click-through on Development is clean.
- [ ] 24 hours of Production logs show no new permission errors from app traffic.
- [ ] Advisors run; anything new explained.
- [ ] Migration file committed under the recorded version on both environments.
- [ ] Fresh independent QA in a new context.
- [ ] Production apply on David's explicit approval.

## Open questions

- `help_text`: classify it in step 1 (a hint aid, or safe to show).
- Once the column grants are revoked, does any student-facing flow still need direct `SELECT` on
  `app.content_item_versions` at all? If none does, revoking table-level access and serving items only
  through edge functions is the simpler long-term shape. That would be a follow-up, not this task.
