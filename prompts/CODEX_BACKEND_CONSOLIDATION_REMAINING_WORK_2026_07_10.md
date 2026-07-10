# Codex — Backend Consolidation: Current Follow-Up (post PR #32)

Source: `docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`
§10 plus the 2026-07-10 Codex/Lovable follow-up work.

## Current State

- PR #32 was merged to `main` at merge commit
  `9bedada3fc7c028f2892791417f29a129995c5e9`.
- The reconciliation branch was `codex/backend-consolidation-reconciled`; do not
  repeat the branch-fragmentation work unless a new divergence appears.
- Production review functions were redeployed 2026-07-10:
  - `assign-for-review` v5
  - `review-queue` v6
  - `review-decision` v6
- David's Production profile is already full admin:
  `dbloom01@gmail.com`, `role = 'admin'`,
  `review_queue_scope = 'all_pending'`.
- `grade-frq` remains deployed in Production and is intentionally out of this
  migration path unless David explicitly authorizes deletion.

## R1 — Verify The General Admin Portal Uses Supabase As Source Of Truth

Lovable has shifted the reviewer portal into a general admin portal. Review the
current Lovable project and confirm every admin/reviewer surface is backed by
Production Supabase (`pcntajvbdfqhbeewmdry`) rather than local placeholder data,
hardcoded arrays, or the old Lovable Cloud schema.

2026-07-10 status: the current Lovable admin portal is a UI shell for the new
admin categories. The reviewer task path is backed by the new review edge
functions, but the `/reviewer/content`, `/reviewer/users`, and
`/reviewer/traffic` admin pages are stubbed with hardcoded arrays and explicit
data-source-pending notices. Treat those pages as not yet Supabase-backed.

UX implementation is owned by Lovable. Use
`prompts/LOVABLE_ADMIN_PORTAL_SUPABASE_WIRING_2026_07_10.md` for the Lovable
rewrite session.

Check these surfaces:

- Review tasks
- Subject metrics
- Questions by type and subtype
- Status
- Labels
- Grading speed: p50, p90, p99
- Cost to grade
- Grading quality
- Traffic by source
- Traffic by page
- Funnel engagement

For each surface, report:

- frontend file(s)
- function/query used
- source table/view/edge function
- whether it is Production Supabase-backed, partially backed, placeholder, or
  missing
- what permission type can see it

## R2 — Verify Reviewer/Admin Permissions

Confirm the intended permission split:

- `reviewer`: sees tasks assigned to them only.
- `admin`: sees all tasks and all categories.

Expected backend contract:

- roles come from `app.profiles.role`, surfaced through server code or edge
  function responses.
- all-pending queue visibility comes from
  `app.profiles.review_queue_scope = 'all_pending'`.
- reviewer queue reads use `review-queue`.
- reviewer decision writes use `review-decision`.
- admin assignment creation uses `assign-for-review` via
  `createAssignmentsForVersion`.

Do not use:

- `has_role(...)`
- `user_roles`
- legacy `review_assignments` / `review_decisions`
- localStorage-only reviewer task data for the live portal

## R3 — Admin Assignment Creation UI

If the general admin portal now includes assignment creation, verify it:

- calls `createAssignmentsForVersion`
- accepts exactly two distinct tutor reviewer IDs
- creates only `tutor_question` assignments
- requires `reviewKind` (`mcq` or `frq`)
- does not expose arbitrary stage or N-reviewer assignment

If it is still missing, use
`prompts/LOVABLE_ADMIN_ASSIGNMENT_CREATION_UI_2026_07_10.md` as the implementation
prompt for a Lovable session with `projects:write` scope. UX is owned by
Lovable; do not implement a local frontend fork unless David explicitly changes
ownership.

## R4 — Live Authenticated QA

Run live authenticated Production QA only if a real authenticated browser session
or credentials are available. Do not fake this with an unauthenticated browser.

Minimum reviewer/admin path:

1. Sign in as reviewer; verify only assigned tasks show.
2. Sign in as admin; verify all tasks and all admin categories show.
3. Open a review task.
4. Submit a valid decision.
5. Verify the submitted decision appears in submissions/history and the backend
   records the immutable `content_review_decisions` row.
6. If assignment creation is present, create a two-reviewer assignment and verify
   both assignments appear in `review-queue`.

## R5 — Migration File Hygiene

`supabase/migrations/202607080004_promote_dbloom01_to_admin.sql` should be kept
and committed as a historical/admin-bootstrap migration. It is intentionally
idempotent: a conditional `UPDATE`, not an `INSERT`, guarded by the presence of
the target auth user. Since Production already has David as admin, applying it
there should be a no-op; in Dev or a future fresh environment, it documents the
intended bootstrap step once the account exists.

Do not delete it and do not rewrite it into a cleverer assertion migration unless
David explicitly changes direction.

## Out Of Scope

- Deleting `grade-frq` from Production.
- Reworking student grading/attempt-submit.
- Changing the review-function contracts to make the UI easier.
