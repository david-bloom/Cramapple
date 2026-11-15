# APPROVAL-0205 — Subject access before study: apply migration and deploy two functions to Production (executed 2026-11-04)

- **Date:** 2026-11-04 (Production only).
- **Granted by:** David Bloom (Product Owner), in session: "Approve release", in answer to a choice between rolling back the app publication and releasing the backend half of `WORK-SUBJECT-ACCESS`.
- **Related:** `docs/tasks/WORK-SUBJECT-ACCESS.md`; backend PR #584; app PR #42 (`ap-prep-blueprint`). Tier: Hard-Gate (Production, access control).
- **Why (incident):** signed-in users on `app.cramapple.com` saw a spinner and no page. The published app bundle (`index-DlGoT4mz.js`) calls `get_study_subject_keys` and `has_study_pack_access`, which did not exist in Production (PostgREST `PGRST202`). The app half had been published before the backend half, contrary to the task's release order (migration, then functions, then app).

## Scope

- **Migration** `supabase/migrations/20261031143302_subject_access_before_study.sql` applied to Production (`pcntajvbdfqhbeewmdry`) with `apply_migration`; Production recorded it as `20261104125832 subject_access_before_study`. Content is the file as on `main` at the time (including the 2026-11-02 key-normalisation fix).
- **Functions deployed to Production from `main`:** `session-event` v53 to v54; `student-session-items` v45 to v46 (both `verify_jwt` true, unchanged).
- Project ref confirmed with `list_projects` before any write; CLI deploy used `--project-ref pcntajvbdfqhbeewmdry` and a pinned `--workdir` (the repo's `.temp` link is Development).

## Checks before the write

- Live definitions of `set_active_exam_pack_version` and `complete_onboarding` matched the migration's base (the migration only adds the access check); `app.normalize_student_subject_key` and `app.exam_pack_version_is_selectable` present; `get_question_experience` anchor present and not yet patched (the migration's own drift guard also enforces this).
- Deployed function source (downloaded with `--use-api`) matched `main` before the release except three behaviour-neutral refactors: `student-session-items` UUID helper, and an inlined `requireEnv` in `_shared/cors.ts` and `_shared/supabase.ts`. **Deploying from `main` shipped those refactors too** (unlike APPROVAL-0203, which deployed Production's own source plus only the approved change).
- Impact query: 29 profiles, 20 staff-role, 24 distinct users with a current entitlement. **One non-staff user active in the last 30 days has no current entitlement** and now gets an empty subject list (intended by the rule; not contacted).

## Verified

- Migration objects present: trigger `require_learning_session_subject_access`; `get_question_experience`, `set_active_exam_pack_version` and `complete_onboarding` patched; `anon` cannot execute the new browser functions, `authenticated` can; internal `app.*` helpers not executable by `authenticated`.
- `get_study_subject_keys()` run under simulated JWT subjects: an admin and an entitled student each get all 10 subjects; the one unentitled recent user gets `[]`.
- Both functions return 401 without an Authorization header.

## Not verified

- **No real signed-in browser session was exercised end to end** after the release (no credentials used). David should confirm sign-in renders.
- What the app shows for a user whose subject list is empty (the unentitled user above): not traced.
- Independent QA of `WORK-SUBJECT-ACCESS` remains pending; this record does not change its Done status.

## Rollback

- Functions: redeploy the previous bundles (v53 / v45; pre-release source matches `main` before commit `9fc373d0`, plus the three refactors noted above in reverse).
- Migration: do not remove the server access checks without explicit approval (per the task's rollback section). The migration creates no entitlement data and deletes no records. Alternative for the app only: revert the app publication.

## Remaining owner approvals

None for this release.
