# Lovable — Wire Admin Portal To Supabase Source Of Truth

Wire the current Cramapple reviewer/admin portal shell to Production Supabase as
the source of truth. UX implementation is owned by Lovable; Codex/backend owns
the contracts and verification expectations below.

## Context

Production Supabase project: `pcntajvbdfqhbeewmdry`.

The reviewer task workflow has already migrated to the `content_review_*`
backend and review edge functions:

- queue read: `review-queue`
- decision write: `review-decision`
- assignment creation: `assign-for-review` via `createAssignmentsForVersion`

The current admin portal pages under `/reviewer/content`, `/reviewer/users`, and
`/reviewer/traffic` are stubs. Replace hardcoded arrays/placeholders with real
server functions, views, or explicit "not yet instrumented" empty states.

## Required Permission Model

- `reviewer`: sees only tasks assigned to them.
- `admin`: sees all review tasks and all admin categories.
- Canonical role source: `app.profiles.role`.
- Canonical all-pending queue scope: `app.profiles.review_queue_scope`.
- Do not use `has_role(...)`, `user_roles`, legacy `review_assignments`, or
  legacy `review_decisions`.

Fix `checkDashboardAdmin` / `useIsAdmin` so admin gating reads canonical profile
role data, not `has_role(...)`.

## Review Tasks

Keep the live reviewer task path on the migrated backend:

- `listReviewQueue` -> `review-queue`
- `getReviewTask` -> `review-queue` plus curated content data as needed
- `submitReviewDecision` -> `review-decision`

Reviewer view must show assigned tasks only. Admin view may show all pending
assignments only when the backend response indicates `review_queue_scope =
'all_pending'` / equivalent all-pending scope.

## Content Admin Page

Replace the current stub table with Supabase-backed data for:

- Subject
- Question type
- Question subtype, if the backend exposes it; otherwise show a clear empty or
  "not yet instrumented" state rather than fake subtype values
- Status
- Labels, if exposed; otherwise show clear missing-instrumentation state
- Grading speed: p50, p90, p99
- Cost to grade
- Grading quality

Existing partial sources that may be used:

- `public.dashboard_subjects_v1`
- `public.dashboard_pipeline_v1`
- any newer approved dashboard view added by backend

Do not hardcode example subjects, labels, costs, or quality numbers.

## Traffic Admin Page

Replace the current stub tables with a real analytics-backed source, or leave an
explicit non-fake empty state until the analytics source is chosen.

Required target surfaces:

- Traffic by source
- Traffic by page
- Funnel engagement

Acceptable implementation choices:

- Supabase event/session tables if they exist and are approved for admin use
- a backend-created analytics view/RPC
- a selected analytics provider integration such as GA4, PostHog, or Plausible

Do not ship hardcoded traffic rows.

## Users Admin Page

Replace hardcoded member rows with a real backend source or a clear empty state.
Only expose fields the backend intentionally publishes to admins. Do not read
private auth tables directly from the browser.

## Admin Assignment Creation

If assignment creation belongs in this portal, implement the UI from:

`prompts/LOVABLE_ADMIN_ASSIGNMENT_CREATION_UI_2026_07_10.md`

The submit path must call `createAssignmentsForVersion`, which invokes
`assign-for-review`. Do not write review tables directly from the browser.

## Verification

Before marking complete:

1. Confirm there are no hardcoded admin data arrays on `/reviewer/content`,
   `/reviewer/users`, or `/reviewer/traffic`.
2. Confirm admin gating does not call `has_role(...)`.
3. Confirm reviewer queue reads through `review-queue`.
4. Confirm review decisions write through `review-decision`.
5. Confirm reviewer and admin views differ by authenticated user's canonical
   role/scope.
6. Confirm any unavailable metric is shown as a non-fake missing-instrumentation
   state, not placeholder production-looking data.
