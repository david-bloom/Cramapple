# TASK-0056 — Close Direct Reads of Answer Keys

**Status:** In Progress. Step 1 (reader inventory) is done, 2026-09-29. **Launch gating for October 2** (`DECISION-0089`).
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

`help_text`: **classified student-visible (step 1).** In Production, 254 published versions carry it, and it is generic coaching ("Correct the first invalid mathematical step, then recompute…"), not answer content. It keeps its grant.

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

#### Step 1 result: reader inventory (2026-09-29, read-only)

**Verdict: one reader breaks, and it is a reviewer screen, not a student one.** No student-facing or
anonymous path reads a column this task revokes.

| Reader | What it reads | Login it uses | Breaks on revoke? |
| --- | --- | --- | --- |
| Lovable app `56cae479`, `src/lib/review.functions.ts` (`getReviewTask`, fallback path for a submitted or closed assignment) | `content_item_versions`: `id, version_num, stem, stimulus, stimulus_image_path, explanation, item_type, frq_form, review_status, content_key` | User-scoped (`context.supabase`: publishable key plus the caller's token) | **Yes.** The whole select fails, not just the column. The error is ignored, so the reviewer sees an empty stem and stimulus. The same code is in `exam-buddy-wireframe` (`src/lib/review.functions.ts:215`). |
| Same file, FRQ criteria | `frq_criteria`: `criterion_key, learner_facing_text, points_possible` | User-scoped | No |
| Same file, `get_review_mcq_choices` RPC | `is_correct`, `rationale` | SECURITY DEFINER, gated on an assignment or admin | No |
| `src/lib/use-published-mcq.ts` (`PUBLISHED_MCQ_SELECT`; also used by `use-session.ts`, `live-practice-mcq/session.ts`) | `stem, stimulus, …, mcq_choices!inner(id,choice_key,choice_text)` | User-scoped | No |
| `src/lib/course-mode/confirm-transfer-api.ts` | `mcq_choices`: `id, choice_key, choice_text` | User-scoped | No |
| `src/lib/dashboard.functions.ts` (`loadContentInventory`) | `content_item_versions`: `content_item_id, version_num, review_status` | User-scoped (admin via RLS) | No |
| `src/routes/admin.grade-response.$attemptId.tsx` | `frq_criteria`: safe columns only | User-scoped | No |
| `src/lib/homework-help/graded-feedback.ts` (`fetchRevealedKey`) | `mcq_choices`: `choice_key, is_correct` | User-scoped | **Already failing** (`is_correct` was revoked earlier). Production logs show the 400. The error is swallowed, so the post-grade correct-answer reveal never shows. |
| Lovable marketing `61dd6602-6991-4561-b418-e988bb7c8a0b` | None of these tables | — | No |
| Edge functions in this repo (`evaluate-attempt`, `student-session-items`, `review-queue`, `admin-content`, `review-decision`) | Answer columns | Service role | No |
| DB functions reading these columns as the caller | `app.cm_d19_release_template`, `app.cm_d19_revoke_template_release` (`item_package_payload`) | SECURITY INVOKER, operator-run template release | No for the app. Operators run them as `postgres`/service role. (Side note: both are executable by `anon`/`authenticated`; they only work with table privileges those roles lack.) |
| `anon` | — | — | No: `anon` holds no column grants on these tables today. |

**Production traffic** (edge logs; windows read: 2026-09-22/23, 2026-09-27/28, and 2026-09-29 to 19:05 UTC;
two other windows failed to load). Every request that selected an answer column used the **service-role**
key: `evaluate-attempt`'s reads of `frq_criteria.evidence_requirements/minimum_fix/accepted_variants` and
`mcq_choices.is_correct/rationale`. Publishable-key requests selected only safe columns, plus the
already-failing `graded-feedback.ts` read above.

**Found in passing (pre-existing, not caused by this task):**
- The app calls `get_chosen_distractor_rationale` (`use-session.ts`) and `get_graded_choice_feedback`
  (`graded-feedback.ts`). **Neither function exists in Production or Development.** Both callers swallow
  the error, so post-grade distractor rationales and graded-choice feedback silently never appear. This
  belongs to TASK-0053's feedback surface, not here, but should be checked before launch.
- `evaluate-attempt` selects `explanation` (`index.ts:1389`) but never returns it. **No student sees the
  explanation anywhere today.** So under decision 2 (post-submission only), revoking loses nothing, and
  showing it after grading is new work, not a replacement.
- A code comment in the app's `dashboard.functions.ts` says Production has no
  `SUPABASE_SERVICE_ROLE_KEY` for the app's server functions. If so, every `supabaseAdmin` path there is
  already broken (`gradeAttemptFn`, `loadDashboardOverview`, the phone half of `capture.functions.ts`).
  Unverified; out of scope.

Audit coverage: 96 Lovable files read (85 app, 11 marketing; tests, generated types and static
marketing/auth routes skipped); `exam-buddy-wireframe` searched in full.

### 2. Confirm the replacement paths exist

- **Post-submission explanation.** *Step 1 finding:* `evaluate-attempt` does **not** return it today, and
  no student path shows it, so nothing needs replacing for the revoke. If the product wants it after
  grading, add it to the grading response (service role). That is optional new work, not a launch
  blocker.
- **FRQ rubric as a hint.** Confirm the hint flow serves rubric fields and records the event
  (`assistance_state` / `pre_submit_hint_count`). If it currently reads `frq_criteria` directly from the
  client, move that read server-side.
- **Reviewer portal. Required: this is the one reader that breaks.** Add
  `public.get_review_item_version(p_content_item_version_id uuid)`: SECURITY DEFINER, `search_path`
  pinned, execute to `authenticated` only. It is gated exactly like `get_review_mcq_choices` (an active
  review assignment for the caller, or `role='admin'` read from `app.profiles`) and returns the columns
  `getReviewTask` selects today, including `explanation`. Switch `review.functions.ts` to it in the
  Lovable app, and also in `exam-buddy-wireframe` if that portal is still in use. Ship the function and
  the app change **before** the revoke. The app change is a Lovable edit and needs its own go-ahead.
- **FRQ rubric as a hint.** *Step 1 finding:* no user-scoped reader selects the rubric columns, so the
  revoke breaks nothing. Pre-submission rubric display, if the product wants it, is new hint-flow work.

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

- [x] Step 1 inventory recorded in this file: every reader, its role, and its replacement (2026-09-29).
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

- Once the column grants are revoked, does any student-facing flow still need direct `SELECT` on
  `app.content_item_versions` at all? If none does, revoking table-level access and serving items only
  through edge functions is the simpler long-term shape. That would be a follow-up, not this task.
