# TASK-0024 - Free Score Check Launch Readiness

**Task ID:** TASK-0024
**Title:** AP Biology Free Score Check launch readiness
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Repository implementation in progress; production launch blocked
**Priority:** P0
**Created Date:** 2026-08-13

> **Superseded 2026-08-15 by TASK-0026 (7-Day Full-Access Trial).** The
> activation-limited Free Score Check offer described here was never enabled
> in production (0 rows in `app.free_score_checks` at retirement) and has been
> replaced by a time-boxed full-catalog trial, given the early-school-year
> timing this offer was designed around no longer applies. The `free_score_checks`
> table/RPCs and the `free-score-check` Edge Function have been dropped/removed;
> see TASK-0026 for the current design. This document is retained for history.

## Purpose

Launch the activation-limited AP Biology Free Score Check only after the
backend, frontend, content-visibility, analytics, and rollback gates prove the
offer is safe to expose to students and paid traffic.

The offer must remain fail-closed until the exact configured content item,
rubric, Edge Function, and database gates are live and verified.

## Current Production Evidence

Read-only production checks on 2026-08-13 showed:

- `free-score-check` Edge Function is not deployed.
- `growth.free_score_check.v1` exists but is `enabled=false` with null
  `content_item_version_id` and `rubric_version_id`.
- Live `app.start_free_score_check` does not yet include the
  `content_visual_requirements` / `content_not_student_visible` /
  `stimulus_image_path` visual gate.
- Strict typed `APBIO-FRQ-*` eligible candidate count is `0`.
- Published typed `APBIO-FRQ-*` rows blocked only by missing visual
  classification count is `64`.
- Metadata-only worklist triage shows the best first review pool is the 12
  published short typed APBIO-FRQ rows with two criteria, followed by 39 short
  rows with four criteria, 1 short row with five criteria, and 12 long rows
  with four criteria.
- Refreshed preflight on 2026-08-13 still reports
  `start_rpc_has_visual_gate = fail`, `config_is_fail_closed_or_complete =
  pass`, `purchase_completed_source_is_stripe_only = pass`, and
  `growth_outbox_has_no_private_launch_property_keys = pass`.

Do not export production stems, stimuli, or rubric text through the connector
for candidate review. The connector rejected that as sensitive content. Use the
authorized admin/content-review surface for the human visual review, then record
only the reviewed `content_item_version_id` through the guarded template.

This is safe because the offer is disabled, but it is not launch-ready.

## Repository Artifacts

- `docs/strategy/CRAMAPPLE_FREE_SCORE_CHECK_IMPLEMENTATION_2026.md` - product
  contract, event taxonomy, launch gates, and production cutover sequence.
- `docs/tasks/TASK-0024-FREE-SCORE-CHECK-CUTOVER-EVIDENCE.md` - production
  evidence template for recording local verification, read-only baselines,
  approved production changes, post-enable smoke, rollback readiness, and final
  launch decision without secrets or private content.
- `scripts/audit-free-score-check-launch-gates.mjs` - local static launch-gate
  audit spanning backend, frontend, SQL templates, and runbook references.
- `scripts/verify-free-score-check-local.mjs` - one-command local FSC
  verification runner for the static audit, Edge Function deploy package,
  backend Deno checks, focused Deno tests, frontend FSC tests, and frontend
  typecheck.
- `scripts/verify-free-score-check-deploy-package.mjs` - verifies the Edge
  Function dependency closure and can emit a deterministic connector payload
  with `--deploy-payload`.
- `scripts/free-score-check-production-preflight.sql` - read-only production
  preflight for config, visual gate, content visibility, Stripe event authority,
  and private event-property keys.
- `scripts/free-score-check-production-readiness-snapshot.sql` - read-only,
  metadata-only blocker summary that consolidates config, visual gate, candidate
  count, visual-classification count, event authority, event privacy, and the
  Edge Function inventory reminder.
- `scripts/free-score-check-candidate-selection.sql` - read-only selector for
  already eligible typed AP Biology FRQ candidates.
- `scripts/free-score-check-candidate-triage-summary.sql` - read-only,
  metadata-only summary of missing visual-classification buckets without
  returning prompt, answer, or rubric text.
- `scripts/free-score-check-visual-classification-worklist.sql` - read-only
  worklist for AP Biology FRQs needing visual classification review.
- `scripts/free-score-check-mark-no-visual-candidate.template.sql` - guarded
  template to record one reviewed `no_not_needed` candidate without enabling
  the offer.
- `scripts/free-score-check-enable-config.template.sql` - guarded template to
  enable the config only after the visual gate and selected candidate pass.
- `scripts/free-score-check-disable-config.template.sql` - fail-closed rollback
  template that preserves selected IDs but sets `enabled=false`.
- `scripts/free-score-check-post-enable-smoke.sql` - read-only post-enable smoke
  query for recent offer completion and privacy-safe server events.
- `supabase/migrations/20260813174828_free_score_check_visual_gate.sql` -
  local migration replacing `app.start_free_score_check` with the no-required-
  visual gate for the current frontend.
- `supabase/tests/free_score_check_growth_funnel.integration.sql` - rollback
  SQL integration test for one initial grade, one repair grade, cross-user
  protection, and direct-RPC outbox behavior.

## Remaining Launch Gates

- Apply `20260813174828_free_score_check_visual_gate.sql` to production.
- Fill `docs/tasks/TASK-0024-FREE-SCORE-CHECK-CUTOVER-EVIDENCE.md` during any
  approved cutover, using IDs, statuses, counts, timestamps, and pass/fail
  outputs only.
- Deploy the `free-score-check` Edge Function with JWT verification enabled and
  capture direct Edge Function inventory evidence that slug `free-score-check`
  is `ACTIVE` with `verify_jwt=true`.
- Run `scripts/free-score-check-production-preflight.sql` and require the visual
  gate, Stripe event authority, and private-key checks to pass.
- Run `scripts/free-score-check-production-readiness-snapshot.sql` and resolve
  every `fail`/`needs_review` row; verify the Edge Function inventory reminder
  through the Supabase function list.
- Review at least one published typed `APBIO-FRQ-*` from
  `scripts/free-score-check-visual-classification-worklist.sql`; start with the
  short two-criterion rows because they are the smallest current free-check
  candidate pool.
- Record one reviewed `no_not_needed` candidate with
  `scripts/free-score-check-mark-no-visual-candidate.template.sql`.
- Run `scripts/free-score-check-candidate-selection.sql` and require at least
  one row.
- If the selector returns zero rows, run
  `scripts/free-score-check-candidate-triage-summary.sql` before the row-level
  worklist to confirm the current lowest-risk review bucket.
- Enable `growth.free_score_check.v1` with
  `scripts/free-score-check-enable-config.template.sql`.
- Re-run `scripts/free-score-check-production-preflight.sql` and require
  `configured_content_is_student_visible = pass`.
- Re-run `scripts/free-score-check-production-readiness-snapshot.sql` and
  require candidate/config/content gates to be `pass` or `pass_ready`.
- Complete a mobile magic-link/OTP smoke test from landing page through report.
- Run `scripts/free-score-check-post-enable-smoke.sql` and require recent
  completion, server funnel events, and private-property gates to pass.
- If any post-enable step fails, run
  `scripts/free-score-check-disable-config.template.sql` before further traffic.
- Run the Docker-backed local SQL integration test when local Supabase is
  available; current local execution remains blocked by Docker/local Supabase.

## Verification Snapshot

Latest local checks passed:

- `node scripts/verify-free-score-check-local.mjs`
- `node scripts/audit-free-score-check-launch-gates.mjs`
- `node scripts/verify-free-score-check-deploy-package.mjs`
- `deno check supabase/functions/free-score-check/index.ts`
- `npx vitest run src/lib/__tests__/free-score-check.test.ts`

Known unrelated dirty work exists in the repository, including Stripe and
gold-set files. Do not conflate those changes with this task's FSC launch
gates.

## 2026-08-13 Claude Handoff Status

This task is **not launch-ready** and should be treated as paused in a dirty,
partially edited local state.

Production remains safe/fail-closed based on the last read-only checks:

- `growth.free_score_check.v1` was disabled.
- The `free-score-check` Edge Function was not deployed.
- No production database writes, Edge Function deploys, commits, pushes, or
  paid-traffic launch actions were performed in the interrupted session.

Local repository state:

- A working FSC backend, SQL gate, frontend funnel, launch-verification scripts,
  and documentation scaffolding exist locally.
- The latest previously passing verifier was
  `node scripts/verify-free-score-check-local.mjs`, but that pass is now stale
  because the session was interrupted after additional edits began.
- Treat the current workspace as unverified until the FSC verifier is run again.

Partial, unverified edits were started after the product-owner clarification
that the free score check should be **subject agnostic**, allowing any supported
subject rather than being AP Biology-only. Review these files first:

- `supabase/migrations/20260813174828_free_score_check_visual_gate.sql`
  - Began changing `app.start_free_score_check` to accept optional
    `p_subject_key`.
  - Began supporting per-subject config via
    `growth.free_score_check.v1.subjects[subject_key]`.
  - Began validating the requested subject against the configured content's
    actual active `app.subjects` row.
  - Began returning `subject_key` and `subject_name` from the RPC.
- `supabase/functions/free-score-check/index.ts`
  - Began passing `subject_key` into the RPC on `start`.
  - Began loading subject metadata for analytics/report output instead of using
    hardcoded Biology values.
  - Began replacing hardcoded report subject/copy/filename with subject-derived
    values.
- `.worktrees/task0019-frontend/src/lib/free-score-check.ts`
  - Began requiring `subject_key` in `startFreeCheck`.
  - Began treating `subject_required` as a temporary offer-unavailable code.
  - Began deriving report print filename and upgrade CTA subject from
    `report.subject_key`.

Known Biology-specific assumptions still need a deliberate pass:

- Candidate/readiness SQL currently filters AP Biology rows, for example
  `s.subject_key = 'biology'` and `ci.content_key like 'APBIO-FRQ-%'`.
- Guarded templates currently assume an AP Biology candidate/config.
- The frontend landing page currently treats only `ap-biology` as supported.
- Frontend tests currently assert AP Biology defaults for report filename and
  purchase CTA.
- The SQL integration test fixture currently asks for one published AP Biology
  FRQ.
- Strategy/task copy still describes an AP Biology Free Score Check.

Recommended next session order:

1. Decide the product contract for subject-agnostic launch:
   - Either one configured FSC subject at a time, or a per-subject config map.
   - The interrupted edits started toward the per-subject config map.
2. Inspect and complete or revert the three partial files listed above.
3. Broaden SQL candidate/readiness/template checks from APBIO-only to active,
   supported, published typed FRQ content that has at least one FRQ criterion,
   no `stimulus_image_path`, and `image_needed = 'no_not_needed'`.
4. Update frontend subject support so the selected supported subject is sent as
   `subject_key` when starting the offer.
5. Update tests/audit expectations to enforce subject-agnostic behavior and to
   prevent hardcoded Biology analytics/report regressions.
6. Run `node scripts/verify-free-score-check-local.mjs`.
7. Only after local verification passes, re-run the read-only production
   preflight/readiness scripts. Do not deploy or enable production without
   explicit product-owner approval.

Do not export production stems, stimuli, answers, or rubric text through the
connector while finding candidates. Use an authorized admin/content-review
surface for human visual review, then record only the reviewed IDs and
metadata-safe pass/fail evidence.
