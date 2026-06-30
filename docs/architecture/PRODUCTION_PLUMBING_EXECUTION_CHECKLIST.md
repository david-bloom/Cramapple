# Cramapple Production Plumbing Execution Checklist

**Status:** Draft execution checklist
**Date:** 2026-06-20
**Project:** `pcntajvbdfqhbeewmdry`
**Purpose:** Split the production-plumbing work into actions for the Product
Owner / platform owner and actions Codex can execute in-repo.

## 1. What You Need To Do

These steps require Vercel, Supabase, DNS, or other external dashboard access.

### 1.1 Confirm the runtime boundary

- [ ] Confirm that Lovable remains the front-end host only, with no privileged
  backend work in the target state.
- [ ] Decide the migration path off Lovable Cloud for grading, session
  mutation, and any other authoritative backend work before production cutover.
- [ ] If any live beta grading or session mutation is still happening inside
  Lovable-hosted `_serverFn` infrastructure, re-point it to the repo-owned
  Supabase Edge Function / Vercel boundary before production work continues.
- [ ] Confirm whether beta and production currently share the same Supabase
  project or other provider resources.
- [ ] Decide whether beta/prod separation will be achieved by a separate
  project, separate env vars, or a formally documented exception.

### 1.2 Vercel setup

- [ ] Confirm `cramapple-dev` (`prj_Vgjlo4aQKKtDnjw4iMzsT1znT7SQ`) is the
  non-production Vercel project and `cramapple` (`prj_o6OPEaC541tFdI3VDjfhnLG9TlGG`)
  is the production Vercel project.
- [ ] Confirm the production Vercel project exists and is linked to the repo.
- [ ] Set production environment variables in Vercel:
  - [ ] `SUPABASE_URL`
  - [ ] `SUPABASE_ANON_KEY`
  - [ ] `SUPABASE_SERVICE_ROLE_KEY`
  - [ ] `OPENAI_API_KEY` or Vercel AI Gateway config, if applicable
  - [ ] `SENTRY_DSN` or equivalent, if applicable
- [ ] Confirm preview and production env vars are separated.
- [ ] Configure the production domain / DNS routing.
- [ ] Confirm the deployment target for app routes and any server functions.

### 1.3 Supabase setup

- [ ] Confirm `Cramapple-Development` (`https://wmgjsdkphcyhngaffbqf.supabase.co`) is the non-production Supabase project and `Cramapple-Production` (`https://pcntajvbdfqhbeewmdry.supabase.co`) is the production Supabase project.
- [ ] Confirm the production Supabase project is the intended one.
- [ ] Confirm the beta runtime is not still depending on Lovable Cloud for
  authoritative backend work before any production migration.
- [ ] Confirm the dev beta route exposes a real Supabase Auth session when you
  sign in, or document that it does not.
- [ ] If the beta route cannot surface a usable session, approve a dev-only
  diagnostics helper that shows session state in non-production only.
- [ ] Set the production secret values in Supabase Edge Function secrets or the
  deployment environment as appropriate.
- [x] Confirm the database migrations are applied in order.
      *Confirmed 2026-06-27: all 25 local migration files applied to `pcntajvbdfqhbeewmdry`; 2 additional
      seed-data migrations applied via MCP (no local file counterparts — see migration-drift risk below).*
      **Content inventory as of 2026-06-27:** 30 long FRQs (L-001–L-030), 100 MCQs,
      20 short FRQs (S-001–S-020, frq_form='short', status='draft', 2 criteria each).
      `canonical_answer_1` / `canonical_answer_2` columns exist on `content_item_versions` but are all NULL.
      **Migration-drift risk:** remote has 28 applied migrations; local `supabase/migrations/` has 25 files.
      Three remote migrations lack local files: one pre-existing gap + `seed_short_frqs_s001_s010` +
      `seed_short_frqs_s011_s020`. Do NOT run `supabase db reset` or `supabase db push` until local files
      for the two seed migrations are created and committed.
- [ ] Confirm RLS is enabled on exposed tables and the service-role writes work.
- [ ] Confirm Storage buckets exist and the object policies are correct.
- [ ] Deploy or refresh the Edge Functions after secrets are in place.
- [ ] Verify Data API / table exposure settings for the application schema.

### 1.4 Monitoring and support

- [ ] Choose the production monitoring / error-reporting provider if still open.
- [ ] Create or confirm the support/contact path.
- [ ] Decide who receives production incident alerts.
- [ ] Confirm logging retention expectations and access scopes.

### 1.5 Cutover decision

- [ ] Confirm UX-001 account flow is stable enough for production.
- [ ] Confirm UX-006 assessment flow is stable enough for production.
- [ ] Confirm content publishing is fixed, gated, and verified.
- [ ] Confirm rollback has been rehearsed.
- [ ] Approve or reject the production cutover window.

## 2. What I Can Do

These are repo-side tasks I can execute without dashboard access.

### 2.1 Docs and planning

- [x] Maintain the production-plumbing plan and task docs.
- [x] Convert feedback into a concrete execution checklist.
- [x] Keep the checklist aligned with the code and migrations.

### 2.2 Code and schema

- [x] Patch Supabase migrations, RLS policies, and grants.
- [x] Patch Edge Functions and shared runtime helpers.
- [x] Add verification-oriented checks and smoke-test guidance.
- [x] Document known cutover blockers and runtime-boundary gaps.
- [x] Keep Lovable scoped to frontend-only behavior in the docs and task flow.

### 2.3 Verification support

- [x] Review logs, SQL, and function code for mismatches.
- [x] Draft smoke-test steps and verification queries.
- [x] Compare live behavior against the intended architecture.

## 3. Recommended Order

1. You confirm the beta/prod runtime boundary and Supabase project split.
2. You set the production Vercel and Supabase secrets.
3. I verify the code and migration path against those settings.
4. You run the first smoke tests in preview/beta.
5. I patch any repo-side mismatches the smoke tests reveal.
6. You approve production cutover only after the blockers are closed.

## 4. Token Recovery for Grade-FRQ Verification

This is the immediate recovery path for the dev-project verification blocker.
The only owner action in this sequence should be whatever step is required to
create or approve a real Supabase Auth session.

1. Open the development beta route for `Cramapple-Development`.
2. Verify you are not on the Lovable root shell.
3. Sign in through the route that is meant to create a real Supabase session.
4. Confirm the browser now has a Supabase access token for
   `wmgjsdkphcyhngaffbqf`.
5. If no usable session appears, decide whether to approve a dev-only session
   diagnostics surface.
6. Once a fresh token exists, send it as `Authorization: Bearer <token>` to
   `grade-frq`.
7. Run the A-E synthetic cases immediately after capture.
