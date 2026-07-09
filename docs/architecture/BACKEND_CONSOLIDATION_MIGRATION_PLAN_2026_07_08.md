# Backend Consolidation & Migration Plan — 2026-07-08

**Status:** Planning / handoff. No migration executed yet. No `.env`,
`config.toml`, OAuth, or Vercel settings changed yet.
**Owner:** David Bloom (Product Owner).
**Purpose:** Single self-contained entry point for a fresh context window to
execute the "host the app at Vercel `cramapple` on Supabase Production
`pcntajvbdfqhbeewmdry`" work. Read this first; it links the detailed artifacts.

---

## 1. TL;DR

The live Lovable app and the team's "production" backend are **two different
databases with two different schemas** that were built in parallel:

- **Live app** runs on **Lovable Cloud**, backed by Supabase project
  `tazjfzphsevtgervlyit` (Lovable-managed, NOT in the user's Supabase org),
  schema in **`public`** (~26 tables + `dashboard_*_v1` views).
- **"Production"** (`pcntajvbdfqhbeewmdry`, the user's own project) holds the
  repo's real system: **~60 tables in an `app` schema** + the repo's 8 edge
  functions + 5 auth users. All published content and the grading pipeline live
  here.

This fork explains the recurring "published content doesn't appear in the app."
**Decision (2026-07-08): Option A** — adapt the app to the repo `app` schema
(not rebuild the app's `public` schema in prod). Plus a Vercel repointing and an
env/OAuth switch. This is a real reconciliation project, **not** a config flip or
a small gap migration.

---

## 2. Reference data (verified 2026-07-08 via Vercel + Supabase MCP)

### Supabase (org `oowamxfnuviaginluati`)
| Project | Ref | Role | Schema |
|---|---|---|---|
| **Cramapple - Production** | `pcntajvbdfqhbeewmdry` | **TARGET** | `app.*` (~60 tables) + 5 legacy `public` tables; 5 auth users; 8 edge functions |
| Cramapple - Development | `wmgjsdkphcyhngaffbqf` | dev; **repo CLI is linked here** (`supabase/.temp/linked-project.json`) | — |
| (Lovable Cloud managed) | `tazjfzphsevtgervlyit` | the LIVE app's current backend; NOT in user's org | `public.*` (~26 tables + dashboard views) |
| (old/deleted) | `cugmpcpdeqkaqmyyqujx` | ACTIVITY_LOG only | — |

- Production URL: `https://pcntajvbdfqhbeewmdry.supabase.co`
- Production publishable/anon key (safe, client-side): `sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT`
- Production edge functions already deployed (repo-sourced): `session-event`,
  `storage-sign-url`, `admin-content`, `evaluate-attempt`, `grade-frq`,
  `assign-for-review`, `review-queue`, `review-decision`.
- Production storage buckets: `content-assets`, `learner-uploads`,
  `validation-artifacts`. (App expects `capture-research` — absent.)

### Vercel (team `bloom-llc` = `team_YetZ2yQaKEofqcsgkWZqu6g6`)
| Project | ID | State |
|---|---|---|
| **cramapple** | `prj_o6OPEaC541tFdI3VDjfhnLG9TlGG` | Framework **Vite**, builds repo **root**; currently connected to the wrong repo (`Cramapple`) → every build fails `ENOENT package.json`. This is the intended production host. |
| cramapple-dev | `prj_Vgjlo4aQKKtDnjw4iMzsT1znT7SQ` | Framework null/Other; domain `cramapple-gateway-check.vercel.app` → the gateway-check deploy, NOT the product site |
| pass-to | `prj_oWw4Pa0MFDluX2fEHqypwSkkJjrc` | unrelated |

### GitHub
- `david-bloom/Cramapple` (public, repoId 1256520538) = **this** repo: docs, ops,
  Supabase edge functions, scripts. **No frontend / no root `package.json`.**
- `david-bloom/cramapple-beta` (private, repoId 1276318936) = the **Lovable Vite
  frontend** (commits by `lovable-dev[bot]`). Last good `cramapple` production
  deploy came from here: `dpl_4L3Fux…` @ `1a5756c`.

---

## 3. Findings (why this is needed)

1. **Schema fork (the core issue).** App queries `public.*` (26 tables it expects);
   Production has `app.*` (~60 tables) + only 5 vestigial `public` tables. ~14
   app-expected tables exist nowhere in Production; the shared-concept ones are in
   `app`, not `public`. A direct env switch breaks the app. Full object+column
   mapping: **`APP_SCHEMA_RECONCILIATION_2026_07_08.md`**.
2. **The `app` schema is RPC/view-designed.** It ships SECURITY DEFINER RPCs
   (`submit_response`, `apply_student_memory_event`,
   `compose_learning_runtime_context`, `reserve/complete_model_usage`), non-`id`
   PKs (`profiles.user_id`, `assignment_id`, `review_decision_id`), and roles on
   `profiles.role` (no `user_roles` table). The app must adopt this interface,
   not do flat CRUD.
3. **Vercel `cramapple` is pointed at the wrong repo.** It builds `Cramapple`
   (docs) instead of `cramapple-beta` (the app), and with Framework=Vite from repo
   root → `ENOENT package.json`. `cramapple-dev` builds the same repo READY only
   because it points at a subdir (gateway-check). Confirmed via build log on
   `dpl_H4Mp…`.
4. **Prod/Dev + CLI linkage.** The repo's Supabase CLI is linked to **Development**
   (`wmgjsdkphcyhngaffbqf`), so `supabase db push` / `functions deploy` target Dev
   unless relinked (`supabase link --project-ref pcntajvbdfqhbeewmdry`).
5. **Lovable Cloud constraints** (from Lovable's own plan): Lovable tooling stays
   bound to `tazjfzphsevtgervlyit`; Google OAuth uses Lovable's broker
   (`@lovable.dev/cloud-auth-js`, `src/integrations/lovable/index.ts`) and won't
   work off Cloud; `.env` is auto-generated and Lovable Cloud may rewrite it;
   **disabling Lovable Cloud is not fully reversible** — leave it enabled as
   rollback until fully verified.

---

## 4. Migration options (the landscape)

### Backend schema strategy
- **Option A — adapt app to repo `app` schema. ✅ CHOSEN.** The `app` schema is the
  authoritative system (content, grading engines incl. TASK-0016 Phase A, edge
  functions). App repoints to it.
  - **A1** — expose the whole `app` schema to PostgREST. Simple; large security
    surface (ops/finance/audit tables on the public API). ❌ not recommended.
  - **A2 — curated `public` interface (views + RPCs) over the app subset the
    student/reviewer app needs. ✅ RECOMMENDED.** Keeps ops tables private, reuses
    the schema's RPC design, minimizes frontend churn.
- **Option B — rebuild the app's `public` schema inside Production.** Faster but
  co-locates the fork (two data models in prod); doesn't truly consolidate.
  ❌ rejected.

### Hosting/deploy (independent of schema choice, still required)
- Point the Vercel **`cramapple`** project at the **`cramapple-beta`** repo, set
  Framework/Root for that Vite app, and add Production env vars there. (Env vars
  do NOT migrate between Vercel projects.)

---

## 5. The plan (Option A / A2), phased

**Phase 0 — Decisions (David + Learning Quality). BLOCKS the rest.**
- Resolve the **2 review-workflow disambiguations**: the app's single review flow
  maps to either `app.content_review_*` (content-version review) or `app.review_*`
  (artifact review) — pick which the reviewer UI targets.
- Resolve the **7 gap tables** (add to `app` vs drop the app feature):
  `anonymous_sessions` (anon practice on prod?), `capture_sessions` (hand-drawn
  capture / TASK-0011), `config`, `idempotency_keys` (likely drop — use
  `grading_results.request_id/hash`), `predictions` (likely drop — embedded in
  `grading_results`), `review_blind_groups`, and the 6 `dashboard_*_v1` views
  (rebuild over `app`).
- Decide **auth users**: 5 exist in Production; the app's real users live on the
  Lovable-Cloud project and will NOT carry over — migrate (`pg_dump` of
  `auth.users` + data) or start fresh.

**Phase 1 — Backend curated interface (Codex).**
- Build `public` views (reads) + confirm/extend RPCs (writes) over the app subset;
  grant `select`/`execute` to `authenticated` (and `anon` only where anon practice
  is intended); do NOT expose ops tables. Rebuild the 6 `dashboard_*_v1` views over
  `app`. Apply to Production via Supabase CLI/dashboard (user has elevated access;
  Codex/Lovable do not).

**Phase 2 — Frontend repoint (Lovable).** Per the mapping doc: repoint queries to
the curated views/RPCs (`supabase.rpc(...)`); regenerate `types.ts`
(`supabase gen types typescript --project-id pcntajvbdfqhbeewmdry`); fix non-`id`
PK filters; map `user_roles`→`profiles.role`; swap Google OAuth from the Lovable
broker to native Supabase provider (own Google Cloud OAuth client + redirect URI
`https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/callback`); update
`.env`/`config.toml` to Production; add `SUPABASE_SERVICE_ROLE_KEY` (from
Supabase → Settings → API) as a secret.

**Phase 3 — Hosting cutover (David + Vercel).** Point the `cramapple` Vercel
project at `cramapple-beta`, set Framework/Root, set Production env vars
(`VITE_SUPABASE_URL` + publishable key above, server keys as needed).

**Phase 4 — Verify, then optionally disable Lovable Cloud.** Test sign-in,
dashboard, attempt→grade end-to-end; watch Production api logs for `/rest/v1/`
traffic. Keep Lovable Cloud enabled ≥1 week as rollback; only disable
(Connectors → Lovable Cloud → Disable) after the cutover is verified.

---

## 6. Cutover order & rollback

Order: **Phase 0 (decisions) → 1 (backend interface) → 2 (frontend) → 3 (hosting)
→ 4 (verify)**. Do the schema/backend work BEFORE any env switch.

Rollback (cheap while Lovable Cloud stays enabled): git-revert the
`.env`/`config.toml`/`beta.auth.tsx` changes and redeploy → app back on
`tazjfzphsevtgervlyit` with data intact (untouched). Rollback becomes hard once
Lovable Cloud is disabled — hence Phase 4 ordering.

---

## 7. Phase 0 decisions — RESOLVED 2026-07-09 (DECISION-0035)

All Phase 0 decisions are made; Phase 1 (Codex backend) and Phase 2 (Lovable
frontend) are unblocked. See `docs/activity_log/DECISIONS_LOG.md#DECISION-0035`.

1. Review-workflow → **`content_review_*`** (content-version review).
2. Gap tables → **add** `app.config`; **drop** `anonymous_sessions`,
   `capture_sessions` (re-add with TASK-0011 capture path), `idempotency_keys`
   (use `grading_results.request_id/request_hash`), `predictions` (in
   `grading_results`); **adapt** to the `blind_group_id` column (no
   `review_blind_groups` table); **rebuild** the 6 `dashboard_*_v1` as `public`
   views over `app`.
3. Auth users → **start fresh** in Production (Lovable-Cloud users do not carry
   over).
4. Anonymous practice on prod → **No**; require sign-in. Curated views grant
   `authenticated` only (no `anon`).
5. App AI keys → **move to `OPENAI_API_KEY`** (already set), off the Lovable AI
   Gateway. Distinct from the grading runners' Vercel AI Gateway (unchanged).

---

## 8. Related artifacts (created this session)

- **`APP_SCHEMA_RECONCILIATION_2026_07_08.md`** (this folder) — the object+column
  mapping table, A1/A2 detail, structural gotchas. The execution reference for
  Phases 1–2.
- Memory: `project_supabase_prod_dev.md` (Prod/Dev/Lovable-Cloud refs + the fork),
  `project_vercel_frontend_repo.md` (Vercel projects + repo mapping),
  `project_model_call_architecture.md` (Vercel AI Gateway — separate from Lovable's).
- Grading context (shared surface): `TASK-0016` + `evaluate-attempt` — Production's
  `evaluate-attempt` is the repo's (Phase A landed in commit `8f79ebe`; F1/F2
  remediation still open, see `CODEX_TASK0016_PHASE_A_QA_FINDINGS_2026_07_08.md`).

## 9. Fresh-context quick-start

1. Read this doc + `APP_SCHEMA_RECONCILIATION_2026_07_08.md`.
2. Re-establish state (read-only) via Supabase MCP on `pcntajvbdfqhbeewmdry`:
   list schemas/tables (`app` vs `public`), `list_edge_functions`, columns for the
   target tables. Vercel MCP: `get_project` / `list_deployments` /
   `get_deployment_build_logs` for team `team_YetZ2yQaKEofqcsgkWZqu6g6`.
3. Start with **Phase 0 decisions** — nothing downstream should proceed until the
   review-workflow, gap-table, and auth decisions are made.
4. Do NOT change `.env`, `config.toml`, OAuth, or Vercel settings until the backend
   interface (Phase 1) exists and Phase 0 is decided.
