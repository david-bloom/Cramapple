# TASK-0026 — 7-Day Full-Access Trial and Lifecycle Engagement Program

**Task ID:** TASK-0026
**Title:** Replace activation-limited Free Score Check with a 7-day full-access trial, plus tracking and a Loops lifecycle-engagement program to convert trialers
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Backend and frontend both live in Production; PostHog keys set but live delivery not yet confirmed; Loops integration and decision-log entry not started
**Priority:** P0
**Created Date:** 2026-08-15
**Approved Date:** 2026-08-15

**Supersedes TASK-0024 (Free Score Check Launch Readiness).** That task's
activation-limited offer was designed around a student with ~10 days before
an exam; it never launched (`growth.free_score_check.v1.enabled` was `false`
throughout its build) and has been replaced with a time-boxed trial that
fits the early-school-year window instead. See
`docs/tasks/TASK-0024-FREE-SCORE-CHECK-LAUNCH-READINESS.md` (marked
superseded, not deleted) for the retired design, and
`archive/free-score-check-2026-08-15` (both the Cramapple and
exam-buddy-wireframe repos) for the preserved code, should the
activation-limited model be revived closer to exam season.

## Product Goal

Give a new student full access to every launch subject for 7 days with no
usage cap, instrument the funnel end to end (PostHog + Supabase), and build
a lifecycle-email program (Loops) that converts trialers before their trial
expires — without gating the trial behind a scarcity mechanic that doesn't
fit the current point in the school year.

## Technical Scope

**Entitlement (done, live in Production):**
- `app.subject_entitlements.access_tier` extended with `'trial'`
  (`supabase/migrations/20260815120000_trial_entitlement.sql`).
- `app.start_trial(p_user_id, p_first_touch, p_last_touch,
  p_marketing_email_opt_in, p_privacy_notice_version)` — grants one
  `access_tier='trial'` row per active subject, `starts_at=now()`,
  `ends_at=now()+7 days`, idempotent per user (a second call returns the
  existing trial's state rather than granting a new one).
- `supabase/functions/start-trial/index.ts` — thin Edge Function wrapper;
  fires `trial_started` on first grant only.
- Reuses `app.authorize_grading_access` unchanged for the actual gate: any
  `subject_entitlements` row with `status='active'` and an open
  `[starts_at, ends_at)` window already returns `'entitled'`. No new grading
  gate logic was needed.
- `GRADING_ENTITLEMENTS_ENABLED=true` in Production (previously unset/false;
  see Data/Security/Integration Impact below).

**FSC retirement (done, live in Production):**
- `supabase/migrations/20260815140000_retire_free_score_check.sql` — drops
  `app.free_score_checks`, `app.start_free_score_check`,
  `app.record_free_score_grade`; simplifies `authorize_grading_access` to a
  pure entitlement check (the FSC one-FRQ-cap fallback branch is gone).
  Deletes the `growth.free_score_check.v1` config row.
- `supabase/functions/free-score-check/index.ts` removed.
- `scripts/free-score-check-*` launch-gate scripts and the SQL integration
  test removed (were never committed to git — confirmed against
  `origin/main` — so nothing of value was lost beyond needing to be rebuilt
  from this doc's history if the offer returns).

**Growth events (partially done):**
- `trial_started` fires from `start-trial` (done).
- `first_response_graded` fires from `evaluate-attempt/index.ts` on a
  user's first `graded`/`uncertain` result (done) — the FSC path's
  `first_response_graded`/`repair_completed` call sites are gone with the
  FSC Edge Function; the normal grading path previously had zero growth-event
  call sites, so this is new.
- `repair_completed` intentionally dropped — no bespoke repair-cycle state
  machine exists outside the retired FSC flow.
- `returned_day_2` / `returned_day_7` — **not started.** Needs a scheduled
  job querying trial `subject_entitlements` rows at day-2/day-7 boundaries
  with no subsequent activity. `pg_cron` is enabled on the project; `pg_net`
  is not, and nothing today reads `growth_event_outbox` except the inline
  synchronous PostHog relay inside `recordGrowthEvent()` — so a pure-SQL cron
  job cannot reach PostHog without either enabling `pg_net` or having cron
  call an Edge Function. Scoped as follow-up, not blocking trial launch.

**Frontend (merged to main, deployed):**
- `exam-buddy-wireframe`, live on `main`: `src/lib/trial.ts`,
  `src/routes/trial.tsx` (OTP landing page), `src/routes/trial.verify.tsx`
  (magic-link callback → grants trial → routes into `/setup`, the normal
  practice flow — not a bespoke one-FRQ UI).
- Dead `/free-score-check/*` routes and lib code removed from `main`
  (`08f20f9`).
- Global PostHog init added to the root layout (`239cacc`) — `initPostHog()`
  previously had no caller on any normal page route (its last caller was the
  now-deleted FSC landing page, and that call was itself silently no-op'd by
  `shouldDisableOnRoute`), so real traffic never loaded the SDK regardless of
  key configuration. Fixed as part of getting PostHog delivery actually
  working end to end, discovered while debugging "Waiting for events" during
  PostHog project setup.
- `codex/task0026-trial-start` rebased onto the FSC-removal + PostHog-init
  commits and merged to `main` (`a079cf1`, fast-forward push); the feature
  branch was deleted after merge.
- `VITE_POSTHOG_KEY` (Vercel) and `POSTHOG_PROJECT_API_KEY` (Supabase
  secret) both set to the same PostHog Project API Key (`phc_...`). Backend
  delivery not yet confirmed live — no growth event has fired since the
  secret was set; the two stale `growth_event_outbox` rows predate the key
  entirely (`delivery_attempts: 0`). `/trial` going live on `main` is the
  next real opportunity to confirm delivery end to end.

**Lifecycle engagement (not started — Loops, entirely greenfield):**
- No email-provider integration exists anywhere in the codebase today
  (confirmed via repo-wide search) beyond Supabase Auth's built-in
  magic-link/OTP email.
- Planned: a Loops account + API key (handled like other gitignored keys —
  never pasted into committed files), a shared client module
  (e.g. `supabase/functions/_shared/loops-client.ts`), and trigger points:
  `trial_started` → welcome journey; day-2/no-activity → nudge (blocked on
  the `returned_day_2` gap above); day-5/6 → urgency reminder (can be
  Loops-scheduled off the `trial_started` timestamp + known `ends_at`,
  without needing a new server-side event); `purchase_completed` → onboarding;
  trial expiry without purchase → win-back prompt.
- Contact sync should pull `marketing_email_opt_in` from
  `app.acquisition_profiles` (already captured by `start_trial`) — only sync
  contacts who opted in.

## Out of Scope

- Reviving the activation-limited Free Score Check design (archived, not
  deleted — see `archive/free-score-check-2026-08-15` in both repos).
- The `returned_day_2`/`returned_day_7` scheduled job and any `pg_net`
  enablement decision it requires — tracked as a known gap above, not a
  blocker for trial launch.
- Paid-channel marketing spend and creative (Reddit/Meta/TikTok sequencing)
  — covered by `docs/strategy/CRAMAPPLE_MARKETING_STACK_REPORT_2026.md`,
  unaffected by this task beyond the offer it's promoting.
- Post-expiry UX beyond what already falls out of existing RLS: confirmed in
  Phase 0 verification that `attempts`/`response_versions`/`grading_results`
  SELECT policies are owner-scoped only (no entitlement check), so an
  expired trial naturally becomes read-only — past work stays visible, new
  attempt creation is blocked by `attempts_entitled_owner_insert`. No new
  code was needed for this; flagging it here as a design decision, not an
  implementation gap.

## Routes / Components / Systems Affected

- `app.subject_entitlements`, `app.authorize_grading_access` (Supabase,
  `app` schema).
- `supabase/functions/start-trial`, `supabase/functions/evaluate-attempt`.
- `supabase/functions/_shared/growth-events.ts` (consumer, not modified —
  new call sites only).
- `exam-buddy-wireframe`: `/trial`, `/trial/verify` (new); `/free-score-check/*`
  (to be removed); `/setup` (existing, now also the trial's landing point
  post-grant).

## Data / Security / Integration Impact

- **`GRADING_ENTITLEMENTS_ENABLED` flip:** this flag was deliberately left
  `false` in Production per `APPROVAL-0043`'s notes (2026-08-14), specifically
  because no grant path existed for a new, unprovisioned student to become
  entitled — 71 active rows existed but all across 8 known internal/family/test
  accounts. `app.start_trial` is that missing path. Flipped to `true` on
  2026-08-15 after: (a) deploying the migration + Edge Function first, (b)
  confirming via direct RPC smoke test against a real production attempt from
  an existing `beta` account that `authorize_grading_access` still returns
  `'entitled'` (no regression), and (c) confirming via direct RPC test that a
  freshly granted trial row also returns `'entitled'`. The module-level
  `GRADING_ENTITLEMENTS_ENABLED` const in `evaluate-attempt/index.ts` is only
  read at Deno isolate cold start, not per-request — the running function
  picks up the new secret value on its next natural isolate recycle, not
  immediately. A forced redeploy was deliberately avoided because the file
  had an unrelated uncommitted diff (Engine 3 shadow-capture work) that must
  not ship as a side effect of this change.
- **Privacy:** no new PII surfaces. Growth events continue to use the
  existing `ALLOWED_PROPERTY_KEYS` allowlist in `growth-events.ts`; no
  grades, answers, or school data reach PostHog.
- **Production evidence (2026-08-15, read-only preflight):** 10/10 launch
  subjects active; `subject_entitlements` at 251 active `beta` rows (26
  users) + 1 active `paid` row before this change; `growth.free_score_check.v1`
  was `enabled=false`; `free-score-check` Edge Function was not deployed.
  Post-change: FSC table/RPCs confirmed dropped, `start_trial` confirmed
  idempotent and granting all active subjects (tested against both Dev and
  Production with cleanup after each test).

## Acceptance Criteria

- [x] `app.start_trial` grants one `trial` entitlement row per active
      subject, `ends_at = now() + 7 days`, idempotently.
- [x] `authorize_grading_access` treats a trial row identically to
      paid/beta — verified against a real production attempt.
- [x] FSC entitlement machinery (table, RPCs, Edge Function, config row)
      removed from Production and Dev.
- [x] `GRADING_ENTITLEMENTS_ENABLED=true` in Production, with regression
      confirmed for existing entitled accounts.
- [x] `trial_started` and `first_response_graded` growth events wired.
- [x] Frontend trial-start flow built, merged to `main`, and deployed
      (`a079cf1`).
- [x] Dead `/free-score-check/*` routes removed from `main` (also fixed a
      latent bug found in passing: `posthog.ts`'s `shouldDisableOnRoute`
      disabled PostHog entirely on `/free-score-check`, so that funnel's own
      `landing_view`/`demo_started` captures were silently no-ops the whole
      time it was live — confirmed `/trial` is not added to that list).
- [x] Global PostHog init added to the root layout, so real page traffic
      actually loads the SDK (previously only two narrow funnel-specific
      call sites existed, both now gone/rarely hit).
- [x] `VITE_POSTHOG_KEY` / `POSTHOG_PROJECT_API_KEY` both set to the
      PostHog Project API Key.
- [ ] Live delivery confirmed end to end (no growth event has fired since
      the key was set — next real trial-start or grading event should
      confirm `growth_event_outbox.delivered_at` populates).
- [ ] `returned_day_2`/`returned_day_7` scheduled job (blocked on a `pg_net`
      decision).
- [ ] Loops account, client module, and the five lifecycle trigger points.
- [ ] `DECISION-00XX` logged for the FSC→trial pivot; `APPROVALS_LOG.md`
      note that `app.start_trial` resolves the gap `APPROVAL-0043` flagged.

## QA Plan

- **Manual QA:** end-to-end click-through of `/trial` → OTP email →
  `/trial/verify` → `/setup`, once the frontend branch is merged and
  deployed. Confirm a second trial-start attempt (already-entitled user) is
  a no-op, not a second grant.
- **Automated tests:** `supabase/functions/_shared/trial-contract_test.ts`
  (Deno, passing); frontend `tsc --noEmit` clean on the trial-start branch.
- **Regression areas:** existing `beta`/`paid` entitled accounts must
  continue grading without interruption — confirmed via direct
  `authorize_grading_access` RPC smoke test pre- and post-retirement
  migration.
- **Failure cases:** a user with an expired trial and no purchase should be
  blocked from new attempt creation (`attempts_entitled_owner_insert` RLS)
  but should still be able to view past work (owner-scoped SELECT policies,
  unaffected by entitlement expiry).
- **Security/data/integration checks:** `start_trial`/`authorize_grading_access`
  remain `security definer`, execute granted only to `service_role`; no new
  RLS policies were needed (existing entitlement-window predicate is reused
  as-is).

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved (product-owner direction across this session: replace
FSC with a 7-day trial, all 10 subjects, grace/read-only post-expiry, Loops
as lifecycle vendor)

## Implementation Notes

- Backend commit: `9ca9047` on `claude/gold-set-answer-assignments-o3ibgi`
  (Cramapple repo), pushed.
- Frontend: `08f20f9` (dead FSC route removal), `239cacc` (global PostHog
  init), `a079cf1` (trial-start flow, rebased and merged) — all on
  `main` (exam-buddy-wireframe repo), pushed directly since that branch
  deploys. The `codex/task0026-trial-start` feature branch was deleted
  after merge.
- FSC archive: `archive/free-score-check-2026-08-15` on both repos, pushed.
- All production database changes were verified against Dev first, then
  applied to Production with immediate smoke tests; no migration was applied
  to Production without a prior Dev dry run in this task.

## QA Review

**QA Verdict:** Pending — awaiting frontend merge/deploy and end-to-end
click-through.

## Done Decision

**Decision:** Pending
**Date:** TBD
