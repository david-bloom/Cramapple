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

**Phase 1 — Backend curated interface (Codex). ✅ APPLIED to Production 2026-07-09.**
- Build `public` views (reads) + confirm/extend RPCs (writes) over the app subset;
  grant `select`/`execute` to `authenticated` (and `anon` only where anon practice
  is intended); do NOT expose ops tables. Rebuild the 6 `dashboard_*_v1` views over
  `app`. Apply to Production via Supabase CLI/dashboard (user has elevated access;
  Codex/Lovable do not).
- **Status:** `202607090001_curated_public_interface.sql` + a follow-up
  `curated_public_interface_revoke_anon` migration (applied directly, not yet
  committed to the repo — see follow-up below) are both live on Production
  (`pcntajvbdfqhbeewmdry`, migration versions `20260709123347` /
  `20260709123606`). Verified 2026-07-09 via Supabase MCP against live
  Production: all 19 entity views + 6 dashboard views + `app.config` exist; the 5
  RPC signatures match; `authenticated` holds grants on every curated
  view/table and `anon` holds none; sample reads return data (e.g.
  `public.content_items` = 330 rows). The 6 dashboard views are intentionally
  `SECURITY DEFINER` (flagged as advisor ERRORs — expected, each has an
  in-view `auth.uid()` role-gate per the QA doc's design note, not a new gap).
  **Follow-up needed:** commit a matching `curated_public_interface_revoke_anon`
  migration file to the repo so `supabase/migrations` matches Production's
  migration history (currently drifted — that migration exists remotely only).

**Phase 2 — Frontend repoint (Lovable). ✅ Reads + auth done; writes deferred.**
- **Status (reported 2026-07-09, not yet independently re-verified this
  session):** Lovable pivoted off Cloud entirely into a **new, non-Cloud fork**
  — `exam-buddy-wireframe` (preview
  `https://preview--exam-buddy-wireframe.lovable.app`) — rather than repointing
  the old Cloud-bound project in place.
  - Reads verified end-to-end with real evidence: `/rest/v1/subjects` returns
    200 with real Production data, via a **typed-client workaround** — the
    generated `types.ts` is **permanently locked** on this fork (accepted
    standing pattern, not a blocker to unwind).
  - Native Google OAuth fully works: required fixing 3 call sites (Lovable's
    `@lovable.dev/cloud-auth-js` broker → native
    `supabase.auth.signInWithOAuth`) plus a Supabase Auth **Site URL** fix (was
    defaulting to `localhost:3000`).
  - **Deferred, not done — carry into Phase 3+:**
    - Writes (`session-event`, `evaluate-attempt`, `review-decision`) are
      spec'd but **never HAR-verified**. Treat as unproven until checked.
    - Phase 2c cleanup outstanding: delete the now-dead
      `@lovable.dev/cloud-auth-js` / `src/integrations/lovable/` code; drop
      anon/capture flows.
    - Minor `ap-statistics` vs `ap_statistics` naming mismatch in one hook.
    - The student attempt-submit backend edge function is still missing
      (separate Phase 1 follow-up, not a Phase 2 item).

**Phase 3 — Hosting cutover (David + Vercel). ✅ DONE 2026-07-09.**
- `exam-buddy-wireframe`'s Lovable project connected to a new GitHub repo,
  `david-bloom/exam-buddy-wireframe` (private; `package.json`/`vite.config.ts`
  at repo root — Root Directory left blank/default).
- `cramapple` Vercel project (`prj_o6OPEaC541tFdI3VDjfhnLG9TlGG`) Git-repointed
  from the wrong `Cramapple` docs repo to `david-bloom/exam-buddy-wireframe`
  (David, via dashboard — no MCP tool exists to change a project's Git link,
  root directory, or env vars). Production env vars set:
  `VITE_SUPABASE_URL=https://pcntajvbdfqhbeewmdry.supabase.co`,
  `VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT`
  (matches the repo's committed `.env` exactly — was already Production-correct).
- First deploy from a stale "Redeploy" reused the old broken build source
  (still `Cramapple`@`894c27b`, same `ENOENT` error) — required an explicit
  **Create Deployment** with commit ref `main` to force a fresh pull from the
  new repo. Resulting deploy `dpl_FZUJbAH8HnkStbL4TVeHDs9uwaa9`: `READY`,
  `target: production`, built from `exam-buddy-wireframe@e79f1d7` (main),
  aliased to `cramapple.vercel.app` + `cramapple-bloom-llc.vercel.app`.
  Verified: `curl https://cramapple.vercel.app` → 200.
- `ALLOWED_ORIGINS` edge-function secret and Supabase Auth → URL Configuration
  → Redirect URLs both updated (additively — Lovable preview origin kept) to
  include `https://cramapple.vercel.app` + `https://cramapple-bloom-llc.vercel.app`.
  Supabase Auth **Site URL** switched from the Lovable preview origin to
  `https://cramapple.vercel.app` (David's call — Vercel is now the real
  production host).
- **Not yet done via MCP (no read access to edge-fn secrets or a
  secrets-write tool):** independent confirmation of the exact `ALLOWED_ORIGINS`
  value now live. Trust David's report; spot-check via a real CORS'd request
  from the Vercel origin if issues appear.

**Phase 4 — Verify, then optionally disable Lovable Cloud. IN PROGRESS
2026-07-09.** Test sign-in, dashboard, attempt→grade end-to-end; watch
Production api logs for `/rest/v1/` traffic. Keep Lovable Cloud enabled ≥1
week as rollback; only disable (Connectors → Lovable Cloud → Disable) after
the cutover is verified.
- ✅ Sign-in (native Google OAuth) verified live on `cramapple.vercel.app`.
- ✅ Subject list reads verified live, real Production data.
- Found + fixed (same session): the student MCQ practice flow was a fully
  faked client-side prototype (instant fabricated grading feedback, zero
  backend calls, question content mismatched to subject). Lovable rewired it
  to real reads (`content_item_versions`/`mcq_choices`) + an honest disabled-
  grading state (commit `c7f72e2`).
- Found + fixed (same session): that fix then surfaced a **real, pre-existing
  Postgres RLS bug** — `app.content_item_versions_select_published` and
  `app.content_items`'s reviewer policy referenced each other, causing
  "infinite recursion detected in policy" for any real authenticated read
  (service-role reads used in earlier QA never hit it). Fixed via migration
  `fix_content_item_versions_rls_recursion` (SECURITY DEFINER helper breaks
  the cycle). This bug predates Phase 1/2/3 — it was just never exercised by
  a live authenticated query until this session.
- **`session_start` write path fully verified live 2026-07-09** — a real
  `app.learning_sessions` row was created via the actual "Start session"
  button on `cramapple.vercel.app`. Getting there required fixing 3 stacked,
  pre-existing backend/frontend bugs (none introduced by this migration,
  just never previously exercised by a real authenticated caller):
  (1) `_shared/auth.ts` called `getUser()` with no token argument — fixed to
  `getUser(token)`; (2) **`app` schema was never exposed to PostgREST**
  (`pgrst.db_schemas` only had `public, graphql_public`) — fixed via
  `ALTER ROLE authenticator SET pgrst.db_schemas = 'public, app, graphql_public'`
  + `NOTIFY pgrst, 'reload schema'`; this had been silently blocking ALL
  edge-function writes to `app.*`, not just this one; (3) frontend
  `entry_path` values didn't match the DB CHECK constraint — fixed in
  `_ux.setup.index.tsx` (commit `0417c6a7`).
- **Open follow-up:** the `getUser(token)` fix was only applied to
  `session-event` — `evaluate-attempt` and `review-decision` bundle their own
  copies of `_shared/auth.ts` and almost certainly have the identical bug,
  untested. Reviewer/tutor flow not re-checked against live Production.
  Grading/submit remains honestly disabled (separate, pre-existing gap — no
  edge function creates/submits a `response_version` yet). Full blow-by-blow:
  `project_supabase_prod_dev.md`.

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

**Full history / canonical branch:** `codex/backend-consolidation-reconciled`
is now the authoritative reconciliation branch for this migration. It starts
from `claude/backend-consolidation-migration` (Phase 0 decisions, Phase 1 spec +
application, Phase 2 briefs) and cherry-picks the 2026-07-10 closure commits
from `claude/ap-statistics-mcq-short-frq-prompts` (`e321a9c`, `fa35f85`).

## 9. Fresh-context quick-start

1. Read this doc + `APP_SCHEMA_RECONCILIATION_2026_07_08.md`.
2. Re-establish state (read-only) via Supabase MCP on `pcntajvbdfqhbeewmdry`:
   list schemas/tables (`app` vs `public`), `list_edge_functions`, columns for the
   target tables. Vercel MCP: `get_project` / `list_deployments` /
   `get_deployment_build_logs` for team `team_YetZ2yQaKEofqcsgkWZqu6g6`.
3. Start with **Phase 0 decisions** — nothing downstream should proceed until the
   review-workflow, gap-table, and auth decisions are made.
4. For Phase 3: first confirm which GitHub repo the `exam-buddy-wireframe`
   Lovable project syncs to (Lovable project settings → GitHub connection, or
   ask the user) — do not assume `cramapple-beta` still holds.
4. Do NOT change `.env`, `config.toml`, OAuth, or Vercel settings until the backend
   interface (Phase 1) exists and Phase 0 is decided.

---

## 10. Remaining Work — 2026-07-10

Status as of this update: Phases 0–3 are functionally complete and live on
Production (`pcntajvbdfqhbeewmdry`). All four QA findings from
`BACKEND_CONSOLIDATION_QA_FINDINGS_2026_07_09.md` (contract mismatch, fictional
admin-scope fields, CORS standardization, RLS restoration) are closed, and the
reviewer-portal frontend gap (`review.functions.ts` targeting a legacy schema)
is closed. What's left:

### 10.1 Branch fragmentation — resolved in repo, pending PR merge

Resolved 2026-07-10 on `codex/backend-consolidation-reconciled`. Verification
showed the full branch-to-branch diff was polluted by unrelated AP Statistics /
grading-engine work on `claude/ap-statistics-mcq-short-frq-prompts`, so only the
two backend-consolidation closure commits were moved:

- `e321a9c` → cherry-picked as `de85c6b`: adds the QA findings closure doc and
  removes the retired `supabase/functions/grade-frq/index.ts` source.
- `fa35f85` → cherry-picked onto the reconciled branch with this plan document
  resolved as the canonical, status-rich version.

`main` still does not reflect the migration until the reconciliation PR merges.
Do not merge directly; David remains Final Approver.

### 10.2 Live verification not yet run

- **Reviewer portal end-to-end browser test.** The `review.functions.ts`
  rewrite (Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212`, commit
  `36d0a86`) was verified by diff review + typecheck only. No one has actually
  logged in as a reviewer/admin against Production and walked queue-load →
  open-assignment → submit-decision → appears-in-submissions. This is the
  step that would confirm the original "Unauthorized: Invalid token" /
  portal-doesn't-load report is actually resolved, not just structurally
  plausible.
- **`assign-for-review`'s stricter contract** (exactly 2 tutor reviewers,
  `tutor_question` stage only) is enforced in the rewritten
  `createAssignmentsForVersion` (`reviewerIds.length(2)`, non-`tutor_question`
  rejected before the edge-function call). Codex checked the Lovable project
  2026-07-10: the reviewer routes call queue/read/decision paths, the ops
  dashboard routes are read-only, and the older embedded UX-002 script is
  localStorage-only. No live admin assignment-creation UI caller was found in
  this project, so there is no current UI path that sends 1–8 reviewers; the
  remaining gap is product wiring/live exercise of an admin creation surface.

### 10.3 Cleanup, no urgency

- `grade-frq` is still deployed on Production (`4c7e99cd-…`, v5) even though
  the repo source was removed 2026-07-10 — no `delete_edge_function` tool was
  available via MCP. Delete via Supabase dashboard or
  `supabase functions delete grade-frq --project-ref pcntajvbdfqhbeewmdry`
  whenever convenient; it only ever 404s (backing tables are empty), so
  there's no live-traffic risk.
- `supabase/migrations/202607080004_promote_dbloom01_to_admin.sql` exists
  untracked in the working tree but does **not** appear in Production's
  applied migration list (`list_migrations` checked 2026-07-10). Either it was
  superseded by an ad hoc `execute_sql` grant (the commit log shows "Grant CC
  queue to David's reviewer profile" / "Backfill admin review queue scope" as
  separate already-landed work) or it's a stale draft. Codex checked 2026-07-10:
  this file is **not redundant** with `202607080003_backfill_review_queue_scope`.
  The tracked migration grants `review_queue_scope = 'all_pending'` while
  deliberately keeping David at the ordinary reviewer role level; the untracked
  file additionally sets `role = 'admin'`. Treat it as a still-unapplied
  privilege-escalation decision, not a safe cleanup file. Do not apply it blind.

### 10.4 Explicitly out of scope for this migration (tracked elsewhere)

- `grade-frq`'s underlying grading-engine gaps (deterministic layer not wired,
  no adjudicated gold set) — tracked in
  `docs/research/grading_engine_rollout_plan_2026_07_08.md` and
  `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`, unrelated to backend
  consolidation.
- The AP Biology publish-gap (all 242 content_items `draft`) — a separate
  URGENT track per memory, not touched by this migration.
