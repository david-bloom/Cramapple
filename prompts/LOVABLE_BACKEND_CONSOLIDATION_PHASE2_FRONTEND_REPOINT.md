# Lovable Brief — Backend Consolidation Phase 2: Frontend Repoint to Production (`app` schema via curated `public`)

> **STATUS: Phase 1 is APPLIED to Production (2026-07-09) — this brief is now
> live.** The curated `public` interface exists and is verified on
> `pcntajvbdfqhbeewmdry` (migrations `curated_public_interface` +
> `curated_public_interface_revoke_anon`; QA record:
> `docs/architecture/PHASE1_CURATED_INTERFACE_QA_FINDINGS_2026_07_09.md`, Re-QA
> round 2 = PASS + apply record).
>
> **Remaining gate before you execute:** the two Product-Owner **console**
> prerequisites in §B that are not yet done — **§B2 native Google OAuth** and
> **§B3 secrets** (`SUPABASE_SERVICE_ROLE_KEY`, `OPENAI_API_KEY`). Do NOT change
> `.env`, `config.toml`, OAuth, or Supabase queries until David confirms those two
> are complete. Everything else is ready.

## A. Context (one paragraph — read the full plan before executing)

The live app currently runs on **Lovable Cloud** (`tazjfzphsevtgervlyit`, `public.*`).
The real system lives in **Production `pcntajvbdfqhbeewmdry`** as an **`app` schema**
(RPC/view-designed), now fronted by a **curated `public` interface** (views for
reads, RPCs for writes) built in Phase 1. Phase 2 repoints this frontend at that
interface. This is a **repoint to a curated contract**, NOT a table-for-table env
flip. Authoritative references (in the `Cramapple` docs repo):
`docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`,
`docs/architecture/APP_SCHEMA_RECONCILIATION_2026_07_08.md`,
`docs/activity_log/DECISIONS_LOG.md#DECISION-0035`, and the Phase 1 delta report.

## B. Product-Owner prerequisites (David — do these BEFORE Lovable executes)

1. **Phase 1 applied to Production — ✅ DONE (2026-07-09).** Curated interface live
   and verified on `pcntajvbdfqhbeewmdry`; delta reconciled (all view columns
   confirmed against the live schema; the 6 `dashboard_*_v1` are intentionally
   `security_definer` + staff-role-gated — accepted, see the QA doc).
2. **Google OAuth (native Supabase, replacing the Lovable broker):** create a
   Google Cloud OAuth 2.0 client; set the authorized redirect URI to
   `https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/callback`; enter the client
   id/secret in **Supabase → Authentication → Providers → Google** on
   `pcntajvbdfqhbeewmdry`.
3. **Secrets on Production:** confirm `SUPABASE_SERVICE_ROLE_KEY` (Supabase →
   Settings → API) is available to the edge functions; confirm `OPENAI_API_KEY`
   is set (DECISION-0035 moves the app's own AI here).
4. Hand Lovable the Production **publishable/anon key**
   `sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT` and URL
   `https://pcntajvbdfqhbeewmdry.supabase.co`.

## C. What Lovable changes (code)

### C1. Point the client at Production
- `VITE_SUPABASE_URL=https://pcntajvbdfqhbeewmdry.supabase.co`
- `VITE_SUPABASE_PUBLISHABLE_KEY=sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT`
- Update `.env` / `config.toml` / the Supabase client init accordingly. Note:
  Lovable Cloud auto-generates `.env` and may rewrite it — verify the values stick
  after a rebuild. **Keep Lovable Cloud enabled** (rollback; see §F).

### C2. Regenerate types
`supabase gen types typescript --project-id pcntajvbdfqhbeewmdry` → replace the
generated `types.ts`. Types now reflect the curated `public` views/RPCs, not the
old Lovable-Cloud tables.

### C3. Repoint reads — swap old table names for the curated views

Read ONLY from the curated `public` views below (the ones your reviewer/tutor
briefs already reference: `LOVABLE_UX002_REVIEW_PORTAL.md`,
`LOVABLE_TUTOR_READER_SUPABASE_EXECUTION.md`). Rename map (old → curated):

| App currently queries | Repoint to (curated `public`) | Notes |
|---|---|---|
| `mcq_items` | `mcq_choices` | `choice_key, choice_text, is_correct, rationale` |
| `rubrics` / `rubric_versions` | `frq_criteria` | `criterion_key, learner_facing_text, points_possible, accepted_variants` |
| `attempt_feedback` | `attempt_criterion_results` | per-criterion rows: `status, points_awarded, evidence_quote, decision_explanation, minimum_fix` |
| `attempt_revisions` | `response_versions` | `response_parts, version_number, is_submitted, parent_response_version_id` |
| `sessions` | `learning_sessions` | `entry_path, session_mode, available_minutes, status` |
| `user_roles` / `has_role()` | `profiles.role` (+ `review_queue_scope`) | use `current_user_role()` if Phase 1 provided it |
| `review_assignments` | `content_review_assignments` | PK `content_review_assignment_id` |
| `review_decisions` | `content_review_decisions` | PK `content_review_decision_id`; `tutor_score, concern_codes, canonical_decision, reader_decision` |
| `topics` | `subjects` (+ `content_labels`) | `subject_key, display_name` |
| `exam_specs` | `exam_packs` / `exam_pack_versions` | |
| `prompts` / `prompt_versions` | `prompt_versions` | admin/reviewer surface only |
| `content_items`, `content_item_versions`, `attempts`, `grading_results`, `profiles`, `config` | same-named curated views | column names/shapes changed — see mapping doc; `grading_results` is jsonb-heavy |
| dashboards | `dashboard_overview_v1`, `dashboard_subjects_v1`, `dashboard_pipeline_v1`, `dashboard_engagement_v1`, `dashboard_quality_v1`, `dashboard_attention_v1` | pinned names |

### C4. Repoint writes — RPCs only, no direct table writes
- Attempt submit / grading trigger → `supabase.rpc('submit_response', …)` (via the
  edge-function wrapper, not a raw table insert).
- Student memory → `supabase.rpc('apply_student_memory_event', …)`.
- Runtime context → `supabase.rpc('compose_learning_runtime_context', …)`.
- Reviewer decision write → **the `review-decision` edge function** (NOT a Postgres
  RPC; there is none). Call `supabase.functions.invoke('review-decision', { body })`
  (POST; supabase-js attaches the user JWT). Always send
  `content_review_assignment_id`; the rest of the body depends on the assignment's
  `review_stage`: `tutor_question` → `tutor_score` (1|2|3) + `difficulty_label`
  (Easy|Moderately easy|Medium|Hard|Very hard); `tutor_answer` → `answer_approval`
  (approved|rejected); `tutor_frq_canonical` → `canonical_decision`
  (approved|rejected|edited); `reader_question` → `reader_decision` (agree|disagree);
  optional `note`/`concern_codes[]`/`diagnostic_flag`/`topic_selections{}` where
  applicable. It inserts the decision, flips the assignment to `submitted`, and
  advances the workflow server-side. Do NOT `insert`/`update` `content_review_*`
  directly — reads come back from the curated views. (Sibling functions:
  `review-queue`, `assign-for-review`.)
- **Edge functions require `ALLOWED_ORIGINS`** (no wildcard, per DECISION-0029): set
  it as an Edge Function secret to include the app's origin (Lovable preview now,
  Vercel domain at Phase 3) or every function call fails CORS.

### C5. Structural fixes (these WILL break silently if missed)
- **Non-`id` PKs:** replace `.eq('id', …)` with the real PK column —
  `profiles.user_id`, `content_review_assignments.content_review_assignment_id`,
  `content_review_decisions.content_review_decision_id`.
- **Roles:** remove all `user_roles` / `has_role()` reads; source role from
  `profiles.role`. `content_review_*` is the canonical (and only) review workflow —
  remove any `review_*` artifact-review paths.
- **Renamed columns** on repointed tables (e.g. `attempts.learning_session_id`,
  `attempts.attempt_mode`, `attempts.result_state/result_summary`) — follow the
  mapping doc column-for-column.

### C6. Auth — start fresh, native provider
- **Start fresh** (DECISION-0035): no user migration; existing Lovable-Cloud users
  do not carry over.
- Swap Google OAuth from the Lovable broker (`@lovable.dev/cloud-auth-js`,
  `src/integrations/lovable/index.ts`) to the **native Supabase** Google provider
  configured in §B2. Remove the broker path.
- **Require sign-in everywhere** — anonymous practice is dropped (DECISION-0035).
  Remove anonymous-session flows; the curated views grant `authenticated` only, so
  anon reads will fail by design. Gate all data behind an authenticated session.

### C7. App AI features → `OPENAI_API_KEY`
Move the app's own AI calls off the Lovable AI Gateway (`LOVABLE_API_KEY`) to
`OPENAI_API_KEY` (DECISION-0035). This is the **app's** AI only; it is **distinct
from the grading runners' Vercel AI Gateway**, which is unchanged — do not touch
grading-runner config.

## D. Storage (verify, don't assume)
Production buckets: `content-assets`, `learner-uploads`, `validation-artifacts`.
The app previously expected `capture-research` — that path is tied to
`capture_sessions`, which DECISION-0035 dropped for now. Remove/disable the
capture-upload UI rather than pointing it at a missing bucket.

## E. Acceptance / verification (before declaring Phase 2 done)
- Sign-in works via native Google (not the Lovable broker).
- Reviewer portal reads the live `content_review_*` queue and writes a decision via
  the RPC; the dashboards render from the 6 `dashboard_*_v1` views.
- A student attempt round-trips: `submit_response` → grading → results render from
  `attempt_criterion_results` / `grading_results`.
- Production API logs (`/rest/v1/`, `/rpc/`) show this app's traffic hitting
  `pcntajvbdfqhbeewmdry`.
- No console/query errors from `user_roles`, `.eq('id', …)` on `user_id` tables,
  or reads against dropped tables.

## F. Rollback & out of scope
- **Keep Lovable Cloud ENABLED** as rollback until Phase 4 verification. Rollback =
  git-revert the `.env`/`config.toml`/auth changes and redeploy → app back on
  `tazjfzphsevtgervlyit`, data intact. Do **not** disable Lovable Cloud (Phase 4,
  not fully reversible).
- **Out of scope here:** the Vercel repo/env repoint (Phase 3 — David + Vercel),
  disabling Lovable Cloud (Phase 4), and any change to the grading runners or the
  `app` schema itself. If a needed curated view/RPC is missing, report it back for
  a Phase 1 follow-up — do not fall back to direct `app.*` access.
