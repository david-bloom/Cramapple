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
      **Migration-drift risk — reconciled 2026-07-09.** Pulled every applied migration's exact SQL from
      `supabase_migrations.schema_migrations` on both projects and wrote the 15 previously-untracked files,
      each verified byte-for-byte via `md5(array_to_string(statements, E'\n'))` against the live row before
      committing:
      - Production (`pcntajvbdfqhbeewmdry`), 8 files added: `202606270007_seed_short_frqs_s001_s010.sql`,
        `202606270008_seed_short_frqs_s011_s020.sql`, `202606300002_seed_long_frqs_l031_l034.sql`,
        `202606300003_seed_long_frqs_l035_l038.sql`, `202606300004_seed_long_frqs_l039_l042.sql`,
        `202607090001_curated_public_interface.sql`, `202607090002_curated_public_interface_revoke_anon.sql`,
        `202607090003_fix_content_item_versions_rls_recursion.sql`.
      - Development (`wmgjsdkphcyhngaffbqf`), 7 files added, dev-only (not yet applied to production):
        `202607070001_hdr_response_assets.sql`, `202607070002_calibration_sets.sql`,
        `202607070003_bootstrap_frq_schema.sql`, `202607070004_grading_experiments.sql`,
        `202607070005_chemistry_physics_schema_instantiation.sql`,
        `202607070006_student_memory_runtime_context.sql`, `202607071200_frq_synthetic_responses.sql`.
      Local `supabase/migrations/` now matches both live projects exactly. `supabase db push` /
      `db reset` are no longer blocked by drift, but see the two new findings logged in
      `docs/tasks/TASK-0012-PRODUCTION-PLUMBING-AND-CUTOVER.md` §"2026-07-09 migration-file reconciliation
      and new findings" (undocumented `DECISION-0035` reference on a production migration; dev/prod schema
      divergence) before treating this as fully closed.
- [ ] Confirm RLS is enabled on exposed tables and the service-role writes work.
- [ ] Confirm Storage buckets exist and the object policies are correct.
- [ ] Deploy or refresh the Edge Functions after secrets are in place.
- [ ] Verify Data API / table exposure settings for the application schema.

### 1.3a `admin-content` content-publishing defects (2026-07-09 code read)

Found reading `supabase/functions/admin-content/index.ts` directly. These are
the concrete items behind the "content-publishing defects" line in
TASK-0012's Known Cutover Blockers — not yet independently verified by QA
(see `prompts/CODEX_TASK0012_BACKEND_MIGRATION_QA_REVIEW.md`).

- [ ] **Client-asserted publish gates are trusted, not verified server-side.**
      `enforceGatePolicy` (~line 156) only checks that `source_gate`,
      `rights_gate`, and `release_gate` are the *string* `"passed"` — it never
      reads `validation_runs`, `review_decisions`, or `rights_records` to
      confirm a real validator produced that state. The function's own
      `TODO(task-0012-trusted-gates)` comment documents this gap. A caller
      with `publish` access can currently self-assert every gate.
- [ ] **Publish self-approval.** `changeArtifactState`'s publish path
      (~line 778) defaults `approved_by` to `[profileId]` — the same account
      calling publish can be recorded as the sole approver, with no check
      against an independent second reviewer per the UX-002 two-tutor review
      model.
- [ ] **Manifest hash is self-referential.** `manifest_sha256` (~line 759)
      defaults to a hash of the client-supplied manifest object itself rather
      than a server-derived hash of the actual published artifact/source/
      rights content, weakening it as an audit anchor.
- [ ] **`bulk_import` has no per-item idempotency or transaction boundary.**
      The `bulk_import` loop (~line 891) calls `createArtifactDraft` once per
      item under a single batch-level idempotency key. If item N fails,
      items 1..N-1 already committed `source_records`/`rights_records`/
      `artifact_versions` rows, no audit event is written for the batch, and
      a client retry with the same idempotency key re-runs items 1..N-1 —
      each generates a fresh `crypto.randomUUID()` artifact id when the
      caller doesn't supply one, so a retry produces duplicate rows rather
      than detecting them as already-imported.
- [x] Determine whether `content_author` (not just `admin`) can reach the
      publish path via `canPerformOperation` (~line 117).
      *Confirmed by reading the code: `content_author` is limited to
      `create_draft`/`update_draft`/`bulk_import`; `publish`/`retire`/
      `unpublish` fall through to `changeArtifactState` and require
      `role === "admin"`. The self-approval and gate-trust findings above are
      scoped to admin-role callers only, not content authors — lower severity
      than an author self-publishing, but still a real gap since "admin" is a
      single role with no second-admin cross-check.*

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
