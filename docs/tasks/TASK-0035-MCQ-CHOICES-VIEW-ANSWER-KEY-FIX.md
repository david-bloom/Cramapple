# TASK-0035 — `public.mcq_choices` View Blocks Pilot Serving (answer-key regression from PR #106)

**Task ID:** TASK-0035
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Hard-Gate (prod schema migration on a security-sensitive object)
**Status:** Done (applied to prod + verified) — pending David's Done ratification
**Priority:** Critical (last backend blocker for pilot serving)
**Created / Applied:** 2026-08-27
**PR:** #138
**Source:** David live error: "Could not load practice items: permission denied
for table mcq_choices".

## Root cause (reproduced as the `authenticated` role)

`public.mcq_choices` is a `security_invoker` view whose definition selected the
answer-key columns `mc.is_correct` / `mc.rationale`. PR #106 revoked column
SELECT on those from `authenticated` (correctly), but left them in the view
definition — so any `authenticated` read of the view required privileges on the
revoked columns → **"permission denied for table mcq_choices" (42501)** for the
whole read. This broke the pilot's direct published-MCQ serving read
(`use-published-mcq.ts`, `confirm-transfer-api.ts`). Latent until 2026-08-26
because prod had never served a pilot MCQ before tonight (Dev's serving proof
predated the security fix).

## Fix (migration `20260827010000`, applied to prod 2026-08-27)

`supabase/migrations/20260827010000_mcq_choices_public_view_drop_answer_key.sql`:
DROP + CREATE `public.mcq_choices` (security_invoker) **without** `is_correct` /
`rationale`; re-GRANT SELECT to `authenticated`, `service_role`. Applied via the
Supabase MCP with David's explicit go.

## Verification (post-apply, prod)

- View columns no longer include `is_correct`/`rationale` (`leaks_answer_key =
  false`) — completes PR #106's answer-key protection as defense-in-depth.
- As `authenticated`: reading `public.mcq_choices` for a real published pilot
  item returns **4 choices** through RLS (`mcq_choices_select_published`) — the
  permission error is gone and rows are visible.
- No DB dependents (pg_depend empty); reviewer path uses the definer RPC
  `get_review_mcq_choices`; grading uses `service_role`/app schema — all
  unaffected.

## Revert

Recreate the view with `mc.is_correct` and `mc.rationale` restored (prior
definition), same grants.

## Residual / next

- **No republish needed** for this fix (backend/DB). If a fresh `/session` load
  now shows "no items" rather than serving, the currently-live bundle predates
  the TASK-0033 serving-path fix and needs one clean Lovable publish of latest
  `main`; the permission error itself is resolved regardless.
- Fold the migration into the mcq_choices security record with PR #106 at
  closeout.
