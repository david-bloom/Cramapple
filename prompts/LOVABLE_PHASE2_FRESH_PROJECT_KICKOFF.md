# Lovable Kickoff — Fresh Non-Cloud Project on Production Supabase (Phase 2 repoint)

**Why a fresh project:** the existing `cramapple-beta` project is on Lovable Cloud,
which locks `.env`, `src/integrations/supabase/*`, and `types.ts` (the migration
system rejected edits). Cloud can't be detached from that project, so we fork out.
The old project stays **untouched as rollback** — do not modify or delete it.

## 0. CRITICAL — how to create the fork
- Remix/fork the current `cramapple-beta` codebase into a **new project**.
- **Do NOT enable Lovable Cloud on the new project.** Lovable's default new-project
  stack is Cloud; that would re-lock `types.ts`/`.env` and put us right back here.
- Connect the **native Supabase integration to Production `pcntajvbdfqhbeewmdry`
  from the start** (not Cloud, not Dev).
- If the platform won't let you create a project without Cloud, STOP and report —
  do not proceed on Cloud.

## 1. Client config
- `VITE_SUPABASE_URL = https://pcntajvbdfqhbeewmdry.supabase.co`
- `VITE_SUPABASE_ANON_KEY = sb_publishable_TlRLW6EOot2pzI4QYtuP7A_XcktZHFT` (Supabase
  publishable/anon client key — safe in the browser)
- **Never** put `SUPABASE_SERVICE_ROLE_KEY` in a `VITE_` var or the client bundle.
  Server logic is the Supabase edge functions (service role auto-injected there).

## 2. types.ts
Use the provided regenerated `src/integrations/supabase/types.ts` (generated against
`pcntajvbdfqhbeewmdry`). Two things about it:
- **`Functions` is empty** — there are no callable RPCs in the typed client. Writes
  do NOT go through `supabase.rpc(...)`. (See §4.)
- **Ignore the 5 legacy `Tables`** (`exam_specs`, `questions`, `sessions`,
  `student_attempts`, `student_lock_queue`) — vestigial junk. **Read only from the
  `Views`.** Note the trap: the `sessions` *table* is dead; the real session is the
  `learning_sessions` *view*.

## 3. Reads — curated `public` views only (rename map, old → new)
| App used to query | Now query (view) |
|---|---|
| `mcq_items` | `mcq_choices` |
| `rubrics` / `rubric_versions` | `frq_criteria` |
| `attempt_feedback` | `attempt_criterion_results` |
| `attempt_revisions` | `response_versions` |
| `sessions` | `learning_sessions` |
| `user_roles` / `has_role()` | `profiles.role` (+ `review_queue_scope`) |
| `review_assignments` | `content_review_assignments` |
| `review_decisions` | `content_review_decisions` |
| `topics` | `subjects` (+ `content_labels`) |
| `exam_specs` | `exam_packs` / `exam_pack_versions` |
| dashboards | `dashboard_overview_v1`, `dashboard_subjects_v1`, `dashboard_pipeline_v1`, `dashboard_engagement_v1`, `dashboard_quality_v1`, `dashboard_attention_v1` |
Same-named curated views (columns changed): `content_items`, `content_item_versions`,
`attempts`, `grading_results`, `profiles`, `config`.

## 4. Writes — edge functions only (`supabase.functions.invoke`, POST, JWT auto-attached)
There is NO `supabase.rpc()` write path (RPCs are private to the `app` schema).

- **Session lifecycle → `session-event`**: `operation` ∈ `session_start` (needs
  `exam_pack_version_id`, `entry_path`, `session_mode`, `available_minutes`,
  `idempotency_key`), `session_save`, `session_end`, `session_resume`.
- **Grade an attempt → `evaluate-attempt`**: `operation` ∈ `grade_initial_attempt` |
  `select_repair` | `grade_revision` | `grade_transfer_attempt`; body needs
  `idempotency_key`, `attempt_id`, `response_version_id`, `content_item_version_id`,
  `rubric_version_id`.
- **Reviewer decision → `review-decision`**: always `content_review_assignment_id`;
  then by the assignment's `review_stage`: `tutor_question` → `tutor_score` (1|2|3) +
  `difficulty_label` (Easy|Moderately easy|Medium|Hard|Very hard); `tutor_answer` →
  `answer_approval` (approved|rejected); `tutor_frq_canonical` → `canonical_decision`
  (approved|rejected|edited); `reader_question` → `reader_decision` (agree|disagree).
  Read the updated queue back from `content_review_assignments` / `content_review_decisions`.

**⚠️ Student submit is NOT yet wired on the backend.** `evaluate-attempt` requires an
attempt + a **submitted** `response_version` to already exist, but no edge function
creates/submits them yet. **Build the reviewer portal fully. For the student
attempt→submit path, wire the UI + `session-event` + the `evaluate-attempt` call, but
leave the actual "create attempt / save response / submit" step as a clearly-marked
disabled TODO — do NOT fake it with a direct table write.** The backend endpoint is a
separate follow-up.

## 5. Structural fixes
- **Non-`id` PKs:** `profiles.user_id`, `content_review_assignments.content_review_assignment_id`,
  `content_review_decisions.content_review_decision_id` (never `.id`).
- **Roles** from `profiles.role`; remove `user_roles`/`has_role()`.
- `content_review_*` is the only review workflow; remove any `review_*` artifact paths.

## 6. Auth
- **Native Supabase Google** provider is already configured on Production (redirect
  `https://pcntajvbdfqhbeewmdry.supabase.co/auth/v1/callback`). Remove the Lovable
  OAuth broker (`@lovable.dev/cloud-auth-js`, `src/integrations/lovable/*`).
- **Start fresh** — no user migration. **Require sign-in everywhere** — remove
  anonymous-practice flows (backend grants `authenticated` only; anon reads fail by
  design).

## 7. Other
- **Drop the capture UI** (hand-drawn photo upload) — `capture-research` bucket is
  out of scope; don't point at a missing bucket.
- **App AI → `OPENAI_API_KEY`** (off the Lovable AI Gateway). The app's AI runs
  server-side in edge functions; the key is a Supabase edge-function secret, not a
  client var.

## 8. Backend config is on SUPABASE, not Lovable
These are Supabase edge-function secrets (already being set by the owner) — Lovable
does not manage them: `OPENAI_API_KEY`, `OPENAI_MODEL`, `OPENAI_MAX_OUTPUT_TOKENS`,
`OPENAI_INPUT_PRICE_PER_1M`, `OPENAI_OUTPUT_PRICE_PER_1M`, `OPENAI_DAILY_CAP_USD`,
`EVALUATE_ATTEMPT_PROMPT_VERSION`, `ALLOWED_ORIGINS` (must include this app's origin).

## 9. Acceptance
- New project is **not** on Lovable Cloud; `types.ts` is editable and matches Production.
- Google sign-in works (native provider).
- Reviewer portal reads the live `content_review_*` queue and writes a decision via
  `review-decision`; dashboards render from the `dashboard_*_v1` views.
- No console errors referencing `user_roles`, `.eq('id', …)` on `user_id` views, or
  the 5 legacy tables.
- Student submit step is a visible disabled-TODO (not a broken/faked write).

## 10. Rollback
The old `cramapple-beta` + Cloud project stays live and untouched. Nothing here is
irreversible; cut over (Vercel → this new repo) only after verification.
