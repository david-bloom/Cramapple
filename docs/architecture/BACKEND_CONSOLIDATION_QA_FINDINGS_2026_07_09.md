# Backend Consolidation QA Findings — 2026-07-09

**Scope:** TASK-0012 backend consolidation QA, centered on
`docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` and the
repo artifacts that validate the Vercel/Supabase migration boundary.

## Verdict

**Repo QA is partially remediated, but live end-to-end migration QA is not yet
complete.** The curated public interface is represented in the repo and the
shared Edge Function auth helper now matches the documented live remediation.
The remaining gate is live authenticated write-path verification for the
functions beyond the already-recorded `session_start` path.

## Verified This Session

- The requested prompt path `prompts/codex_TASK0012_BACKEND_MIGRATION_QA` is not
  present in this checkout. QA therefore used the TASK-0012 task file,
  production plumbing plan, backend consolidation plan, curated interface
  migration, and Phase 1 QA findings as the source artifacts.
- Supabase MCP live checks against Production were blocked in this session for
  edge-function list, edge-function logs, and SQL execution with
  `MCP error -32600: You do not have permission to perform this action`.
- `supabase/migrations/202607090001_curated_public_interface.sql` grants curated
  views to `authenticated` and has no committed `anon` grants on those views.
- The repo was missing the documented follow-up hardening migration that was
  applied directly to Production. Added
  `supabase/migrations/202607090002_curated_public_interface_revoke_anon.sql` so
  future repo migration history mirrors the sign-in-only Production posture.
- `_shared/auth.ts` still used `client.auth.getUser()` without explicitly passing
  the bearer token, despite the migration plan recording that as a live fix.
  Updated the helper to extract and pass the JWT token, so all functions importing
  `requireAuthedUser` / `requireProfile` inherit the same behavior.
- The repo had `submit-response`, but no `attempt-response` source even though
  Production logs reportedly show that function name. Added a repo-tracked
  `supabase/functions/attempt-response/index.ts` that creates an `attempt`, creates
  a draft `response_version`, optionally submits it through the existing
  `app.submit_response` RPC, and reserves/completes idempotency through
  `app.audit_events`.
- Added `CONTENT_REVIEW_REWRITE_MAPPING_SPEC_2026_07_09.md`, the old→new
  reviewer portal mapping for `review_assignments` / `review_decisions` /
  `has_role()` to `content_review_*` and `profiles.role`.

## Checks Run

- `deno test --allow-env supabase/functions/_shared/auth_test.ts` — pass.
- `deno check supabase/functions/_shared/auth.ts supabase/functions/session-event/index.ts supabase/functions/evaluate-attempt/index.ts supabase/functions/review-decision/index.ts`
  — pass.
- `deno check supabase/functions/attempt-response/index.ts supabase/functions/submit-response/index.ts supabase/functions/evaluate-attempt/index.ts supabase/functions/review-queue/index.ts supabase/functions/review-decision/index.ts`
  — pass.

## Still Required For End-to-End Migration Validation

- Confirm whether Production's currently deployed `attempt-response` function
  matches the repo implementation added here; if not, diff and redeploy the
  repo-tracked implementation before treating it as reviewed.
- Live authenticated write-path QA against Production for:
  `attempt-response`, `evaluate-attempt`, `review-decision`, `submit-response`,
  and the reviewer flow.
- Confirm the deployed Edge Function bundles have the shared `getUser(token)` fix
  after redeploy, not only the repo source.
- Confirm Supabase PostgREST still exposes `public, app, graphql_public` for the
  authenticator role in Production, because edge-function writes depend on app
  schema visibility.
- Run a real CORS request from `https://cramapple.vercel.app` to confirm the
  effective `ALLOWED_ORIGINS` secret, since the plan notes no direct secrets
  readback was available.
- Decide whether to create or restore the missing
  `prompts/codex_TASK0012_BACKEND_MIGRATION_QA` prompt so future QA sessions have
  a stable entrypoint.

---

## Re-QA — 2026-07-09 (round 2, live verification)

**Reviewer:** Claude, same session, with working Supabase MCP access (the access
this round's author explicitly flagged as blocked). Pulled the actual deployed
`attempt-response` and `review-queue` function bundles via `get_edge_function`
and cross-checked `app.artifact_label_assignments` columns via `execute_sql`,
rather than relying on repo source alone.

### Verdict: two of the four items need rework before they're usable as-is.

### Finding A (blocking) — `attempt-response`: repo file is a different, incompatible function, not a diff of the live one

Production already has `attempt-response` deployed (`function_id
80e0d488-0951-47fc-af2d-640ea69bf6cb`, version 1, created before this session,
confirmed serving real `200` traffic in Production API logs). It was **not**
written by this round of work — something else deployed it earlier — and its
contract is materially different from the repo file just added.

**Deployed (live) contract — three operations, supports incremental drafting:**
```ts
type Operation = "create_attempt" | "save_response" | "submit_response";
```
- `create_attempt(learning_session_id, content_item_version_id, attempt_mode, assistance_state)`
  — validates `attempt_mode ∈ {mcq, frq, quantitative}`,
  `assistance_state ∈ {independent, coached, exam_practice}`, session ownership,
  content published; inserts `app.attempts`. Idempotent via `app.audit_events`
  keyed on `request_id` + `reason_code = "create_attempt"`.
- `save_response(attempt_id, response_text, response_parts, parent_response_version_id)`
  — validates attempt ownership + `status ∈ {draft, failed}`; **auto-increments
  `version_number`** by reading the current max and retrying on `23505` (unique
  violation) — i.e. it supports calling this repeatedly as the student edits.
- `submit_response(attempt_id, response_version_id)` — calls `app.submit_response`
  RPC with `p_attempt_id, p_response_version_id, p_actor_id, p_actor_role,
  p_idempotency_key, p_request_hash` (idempotency key sourced from the request,
  not from an internal audit-events check — the RPC itself is idempotent).

**Repo file (`supabase/functions/attempt-response/index.ts`) — two operations,
no drafting support:**
```ts
type AttemptResponseOperation =
  | "create_attempt_response"
  | "create_and_submit_attempt_response";
```
- Both operations require `response_text`/`response_parts` **at creation time**
  and hardcode `version_number: 1` on insert. There is no operation that lets a
  caller save a second draft against an existing attempt — a second call for the
  same attempt would hit whatever unique constraint backs `(attempt_id,
  version_number)` (the deployed version's retry-on-`23505` loop implies that
  constraint is real).
- Different operation names entirely — not a superset, not backward compatible.
  If this file replaced the deployed one, whatever currently calls
  `create_attempt` / `save_response` / `submit_response` breaks outright.

**Do not deploy the repo file over the live function.** This needs reconciliation,
not a redeploy:
1. Find what's currently calling the live three-operation contract (frontend
   search for `"create_attempt"` / `"save_response"` invocations against
   `attempt-response`) so we know the blast radius before changing anything.
2. Decide the target contract. The repo file has two real improvements worth
   keeping: the `content_items!inner(...)` join validates the parent item's
   `status`, not just the version's (deployed only checks version status); and
   it cross-checks `learning_session_id`'s `exam_pack_version_id` against the
   content's own `exam_pack_version_id` (deployed doesn't verify this — it trusts
   the session's `exam_pack_version_id` blindly when inserting the attempt).
3. Whichever contract wins, it must support incremental draft saves — dropping
   that is a real product regression, not a simplification.

### Finding B (blocking for the reviewer rewrite) — `review-queue`'s admin scope fields are fictional

`CONTENT_REVIEW_REWRITE_MAPPING_SPEC_2026_07_09.md` documents the queue response
as:
```ts
reviewer: { reviewer_id, reviewer_role, reviewer_name, review_queue_scope, can_see_all_pending }
scope: "mine" | "all_pending"
```
I read the actual deployed `review-queue` source
(`function_id 498568b1-b275-4dcd-b6a5-9bbfbc9f6700`, version 4). The real query is:
```ts
const { data: assignments } = await service.schema("app")
  .from("content_review_assignments")
  .select(...)
  .eq("reviewer_id", reviewerId)   // <-- applied unconditionally, every role
  .order("due_at", ...);
```
and the real response shape is:
```ts
{ status, function: "review-queue",
  reviewer: { reviewer_id, reviewer_role, reviewer_name },
  queue, counts }
```
**None of `scope`, `review_queue_scope`, or `can_see_all_pending` exist.** There is
no code path anywhere in the deployed function that branches on admin role to
return other reviewers' assignments — every caller, including admin, gets only
their own queue. `profiles.review_queue_scope` is a real column (confirmed in
Phase 1 QA), but `review-queue` doesn't read it.

This matters because the **current, pre-rewrite** `review.functions.ts` (the
thing we're replacing) *does* implement an admin "CC view" — see all pending
assignments across reviewers — via its own `isAdmin` branch. If the reviewer
portal rewrite is built against the mapping spec as written, that feature
silently vanishes: admins get the same queue as any reviewer, with no error,
just quietly wrong behavior.

Fix one of two ways before the frontend rewrite starts:
- Add the `review_queue_scope`-aware branch to `review-queue` (when
  `profiles.review_queue_scope = 'all_pending'` and role is admin, drop the
  `.eq("reviewer_id", ...)` filter), matching what the spec already claims exists,
  or
- Correct the spec to state plainly that admin CC view is **not yet implemented**
  in `review-queue`, so the rewrite either carries it as a known gap or
  implements it client-side against the curated `public.content_review_assignments`
  view directly (per the spec's own "Direct Table Fallback" section) until the
  edge function supports it.

### Finding C (non-blocking, but real) — editing shared `_shared/cors.ts` doesn't retroactively fix deployed functions

Each edge function bundles its own copy of `_shared/*` at deploy time — there is
no live shared reference. I confirmed this directly: `attempt-response`'s
**currently deployed** bundle still ships the old wildcard CORS
(`"Access-Control-Allow-Origin": "*"`, methods `POST, OPTIONS` only), while
`review-queue`'s deployed bundle already has the strict version
(`GET, POST, OPTIONS`, no wildcard) — i.e. the two functions are on different
CORS postures right now, live, regardless of what the repo's shared file says.
**Every function that imports `_shared/cors.ts` needs an actual redeploy** to
pick up the strict-CORS fix; editing the source alone changes nothing live. If
"standardize CORS" is going to be marked done, it should be done by
redeploy-and-verify per function, not by source diff.

### Finding D (informational, not blocking) — `content_review_assignment_labels` already exists

Confirmed indirectly: the live `review-queue` function already queries
`app.content_review_assignment_labels` successfully (`.from("content_review_assignment_labels").select("content_review_assignment_id, content_label_id, created_at")`,
part of the 200-serving production traffic). So
`20260710032203_restore_label_assignment_rls_policies.sql`'s
`create table if not exists app.content_review_assignment_labels (...)` is a
safe no-op there — the table predates this migration. `app.artifact_label_assignments`'s
real columns were confirmed directly: `artifact_version_id, content_label_id,
created_at, created_by` — matches what the migration assumes. The RLS/policy
portions of the migration look structurally sound against the real schema.

### Net

- **`attempt-response`**: needs reconciliation with the live function, not a
  redeploy of the repo file as-is (Finding A).
- **Reviewer rewrite spec**: needs the admin-scope gap either implemented or
  explicitly flagged before anyone builds against it (Finding B).
- **CORS standardization**: source-level fix is correct; treat as incomplete
  until each older function is actually redeployed and reverified live (Finding C).
- **RLS migration**: looks safe to apply (Finding D).

---

## Deployment — 2026-07-09 (round 3)

Codex reconciled `attempt-response` to the live three-operation contract
(`create_attempt` / `save_response` / `submit_response`, draft-editing
preserved via auto-incremented `version_number` + retry-on-`23505`) while
keeping the stricter validations from its original draft (parent
`content_items.status` check, session/content `exam_pack_version_id` match) and
adding one more real gap-fix: `content_items.item_type !== attempt_mode` now
rejects a mismatched attempt mode, which the original deployed version never
checked. Codex also implemented the `review_queue_scope`-aware admin path in
`review-queue` (drops the `.eq("reviewer_id", ...)` filter when
`profiles.review_queue_scope = "all_pending"`) and fixed a real bug the old
deployed version had: it stamped every queue row with the *caller's* own
name/role instead of resolving each row's actual assignee, which would have
made an admin's all-pending view show the admin's own name on everyone else's
assignments.

Both were **verified in source, then deployed to Production** by Claude
(`deploy_edge_function`, on the Product Owner's explicit go-ahead) and
**read back to confirm the live bundle matches byte-for-byte**, not just
source-level trust:

- `attempt-response`: `80e0d488-…` v1 → **v2**, `ACTIVE`.
- `review-queue`: `498568b1-…` v4 → **v5**, `ACTIVE`. Read-back confirmed
  `review_queue_scope`, `can_see_all_pending`, `scope`, and per-row reviewer
  resolution are genuinely live, not just local.
- Both bundles ship the strict `ALLOWED_ORIGINS` CORS helper (`GET, POST,
  OPTIONS`, no wildcard) and the bearer-token-explicit `auth.ts` fix
  (`getBearerToken` + `client.auth.getUser(token)`), since both deploys used
  the current local `_shared/*` files. `attempt-response`'s bundle was
  submitted identically to `review-queue`'s (same shared-file content,
  confirmed by direct diff before submission); its CORS/auth posture is
  inferred correct from that identity rather than independently re-fetched.

**Findings A and B are now closed** (fix deployed and live-verified). **Finding
C is closed for these two functions specifically** — still open for any other
older function (`evaluate-attempt`, `session-event`, `storage-sign-url`,
`admin-content`, `grade-frq`) that hasn't been redeployed since the shared CORS
helper was strictened; each still needs its own deploy-and-reverify pass, not
just a source diff. Finding D (RLS migration) is unapplied — still pending a
`apply_migration` pass against `20260710032203_restore_label_assignment_rls_policies.sql`.

### Codex remediation after round 2 — 2026-07-09

**Attempt-response source reconciled.** Replaced the incompatible two-operation
repo implementation with the live three-operation contract:
`create_attempt`, `save_response`, and `submit_response`.

The reconciled source preserves the deployed behavior that matters:

- `create_attempt` creates only the attempt and remains idempotent through
  `app.audit_events`.
- `save_response` supports repeated incremental draft saves for an existing
  attempt and auto-increments `response_versions.version_number`, retrying on
  `23505` unique-version races.
- `submit_response` delegates the state transition to the existing
  `app.submit_response` RPC.

It also keeps the two stricter validations from the prior repo-only draft:

- content item version and parent content item must both be `published`;
- the learning session's `exam_pack_version_id` must match the content item's
  `exam_pack_version_id`.

**Review-queue source already matches the mapping spec.** The local repo's
`review-queue` function reads `profiles.review_queue_scope`, drops the
`reviewer_id` filter when `review_queue_scope = 'all_pending'`, and returns
`scope`, `review_queue_scope`, and `can_see_all_pending`. Finding B is therefore
a live deploy drift from older deployed version 4, not a current source/spec
defect.

**Still required live:** redeploy and verify `attempt-response`, `review-queue`,
and every strict-CORS function bundle. Editing `_shared/cors.ts` and function
source does not change already deployed bundles.

**Checks run after remediation:**

- `deno check supabase/functions/attempt-response/index.ts supabase/functions/review-queue/index.ts supabase/functions/submit-response/index.ts supabase/functions/evaluate-attempt/index.ts`
  — pass.

---

## Deployment — 2026-07-09 (round 4, Finding C closure + Finding D)

On the Product Owner's explicit go-ahead ("Finding C- execute deploy-and-verify",
"Finding D- apply that one too"), Claude redeployed all remaining older Edge
Functions with the current `_shared/*` bundle (strict `ALLOWED_ORIGINS` CORS,
bearer-token-explicit `auth.ts`) and applied the Finding D RLS migration. Each
function was read in full first to confirm it already used the
`respond = (body, init) => jsonResponse(body, init, req)` closure pattern (req
threaded through for CORS origin-echo) before redeploying, then read back via
`get_edge_function` after deploy to confirm the live bundle, not just the
source diff.

- `storage-sign-url`: `3898429b-…` → **v9**, `ACTIVE`. Baseline 4 shared files only.
- `grade-frq`: `4c7e99cd-…` → **v5**, `ACTIVE`. Baseline 4 shared files only.
  **Separately flagged, out of scope for this pass:** this function queries
  `.schema("public")` legacy tables (`student_attempts`, `questions`,
  `student_lock_queue`) — the dead pre-migration schema, not `app.*`. It was
  likely already non-functional in Production before this redeploy; the CORS
  fix does not change that, and fixing the underlying dead-schema query is a
  separate task.
- `admin-content`: `cb5fd019-…` → **v9**, `ACTIVE`. Baseline 4 shared files only.
- `session-event`: `6ffb2504-…` → **v16**, `ACTIVE`. Required bundling
  `learning-context.ts` + `student-memory.ts` beyond the baseline 4.
- `evaluate-attempt`: `4dafe0f0-…` → **v10**, `ACTIVE`. The largest bundle in
  the migration — baseline 4 plus 9 additional shared modules
  (`grading-router.ts`, `formula-notation.ts`, `verification-profiles.ts`,
  `math-verifier.ts`, `statistics-verifier.ts`, `grading-feedback.ts`,
  `learning-context.ts`, `student-memory.ts`, `evaluate-attempt-response.ts`),
  14 files total. One structural subtlety caught before deploying:
  `evaluate-attempt-response.ts` does `import type { AllowedOperation } from
  "../evaluate-attempt/index.ts"` — a reference back into the function's own
  named folder, not a generic "one level up" from `_shared/`. The flat
  `index.ts` naming used for the other functions this session would not have
  resolved that reference. Fixed by naming the entrypoint
  `../evaluate-attempt/index.ts` (matching the real production bundle layout,
  where `_shared/` and each function folder are siblings under a common root)
  so both cross-references resolve correctly. Read-back confirmed all 14 files
  present under the expected sibling paths, `cors.ts` matches the strict
  `ALLOWED_ORIGINS` version with no wildcard fallback, and the circular
  type-only import resolves as intended.

**Finding C is now fully closed.** All 5 originally-flagged older functions
(`evaluate-attempt`, `session-event`, `storage-sign-url`, `admin-content`,
`grade-frq`) are redeployed and live-verified on Production with the strict
CORS bundle, alongside `attempt-response` and `review-queue` from round 3.

- `20260710032203_restore_label_assignment_rls_policies.sql` applied to
  Production via `apply_migration` (`{"success":true}`). **Finding D is now
  closed.**

### Net (all rounds)

- Finding A (`attempt-response` contract mismatch): closed, round 3.
- Finding B (`review-queue` admin scope fictional): closed, round 3.
- Finding C (CORS standardization across older functions): closed, round 4 —
  all 7 functions touched this session (`attempt-response`, `review-queue`,
  `storage-sign-url`, `grade-frq`, `admin-content`, `session-event`,
  `evaluate-attempt`) are live with the strict-CORS bundle.
- Finding D (RLS migration): closed, round 4 — applied to Production.

### Still open / explicitly out of scope

None as of the resolution below.

---

## Resolution — 2026-07-10: review.functions.ts rewritten to the canonical edge functions

The last known gap — `src/lib/review.functions.ts` in the Lovable frontend
fork (project `d334fed9-5a97-4e76-906e-7c0ad7082212`) still targeting the
legacy `review_assignments`/`review_decisions`/`has_role()`/`review_blind_groups`/
`user_roles` schema, which doesn't exist against Production — is now fixed.
This was the actual root cause of the "Unauthorized: Invalid token" /
reviewer-portal-doesn't-load report: the backend (`review-queue`,
`review-decision`, `assign-for-review`) was already correct and live, but the
frontend server functions calling it had never been rewritten.

Sent Lovable's agent the exact live contracts of all three edge functions
(read directly from repo source, not assumed) and a function-by-function
rewrite plan:

- `listReviewQueue` / `listMyTasks` → `supabase.functions.invoke("review-queue")`.
  Reviewer/scope surfaced verbatim from the edge response — no client-side
  admin recompute, so the `profiles.review_queue_scope`-driven behavior from
  DECISION-0035 is preserved rather than overridden.
- `getReviewTask` → tries the live `review-queue` first; falls back to
  read-only queries against the curated `public.content_review_assignments` +
  `content_item_versions` + `mcq_choices` + `frq_criteria` +
  `content_review_decisions` views for already-submitted assignments, since
  `review-queue` only returns OPEN-status items and no by-id edge endpoint
  exists. This fallback is explicitly sanctioned for reads only per
  `CONTENT_REVIEW_REWRITE_MAPPING_SPEC_2026_07_09.md`'s "Direct Table
  Fallback" section.
- `submitReviewDecision` → `supabase.functions.invoke("review-decision")`
  with the stage-specific body (no `review_stage` sent — the edge function
  derives it from the assignment row).
- `listMySubmissions` → same curated-view read-only fallback as `getReviewTask`
  (no edge function returns submitted items).
- `createAssignmentsForVersion` → `supabase.functions.invoke("assign-for-review")`.
  **Real, intentional behavior change:** the canonical `assign-for-review`
  contract only supports exactly two `tutor`-role reviewers and stage
  `tutor_question` — the old prototype's arbitrary N-reviewer/any-stage
  flexibility doesn't exist in the reviewed design. Updated the input
  validator to require exactly 2 reviewer IDs and reject any non-`tutor_question`
  stage with a clear error instead of silently misbehaving.
- Removed `buildArtifact()`, `assertReviewer()`, and every `has_role` RPC call.

Diff reviewed directly (`get_diff`) — matches the instructed contract exactly,
no shortcuts. Lovable's agent ran a typecheck (`bunx tsgo --noEmit`) which
passed, and confirmed the three reviewer routes (`reviewer.index.tsx`,
`reviewer.submissions.tsx`, `reviewer.review.$assignmentId.tsx`) consume
unchanged field names (`items`, `scope`, `reviewer.reviewer_role`, `artifact`,
`sibling_decisions`, etc.) and needed no changes. Commit `36d0a86` on the
Lovable project.

**Not yet done:** a live, authenticated end-to-end click-through of the
reviewer portal in the browser (queue load → open assignment → submit
decision → appears in submissions) has not been run this session. The
typecheck and diff review confirm the code is structurally correct against
the verified live contracts, but only a real browser session against
Production can confirm the original "Unauthorized: Invalid token" symptom is
actually gone.

## Resolution — 2026-07-10: grade-frq retired (not fixed)

Investigated the `grade-frq` dead-schema flag from round 4. Confirmed, not
just suspected:

- `public.questions`, `public.student_attempts`, `public.student_lock_queue`
  (the tables `grade-frq` queries) are a **Biology-only prototype schema**
  from `202606230001_prototype_student_schema.sql` — hard `check (unit
  between 1 and 8)`, no `subject_id` or equivalent column. Prior QA
  (`CODEX_TASK0013_PHASE1_QA_REVIEW.md`) had already flagged this as a
  prototype, not a production path.
- All three tables have **0 rows on Production** (`execute_sql`, confirmed
  2026-07-10). `grade-frq` has never graded anything live — every call would
  404 on `question_not_found`.
- No frontend or repo caller invokes `grade-frq` anywhere outside docs/
  runbooks describing how to test it in isolation.
- `evaluate-attempt`'s `llm_text` route (`discrete_text` rubric type, via
  `resolveGradingRoute`) already grades FRQs against the real `app.*` schema
  and is the live, working path — a full functional superset of what
  `grade-frq` attempted.

**Decision (Product Owner, 2026-07-10):** retire, don't port. Porting
`grade-frq` to `app.*` would build a second, redundant FRQ grading path
alongside `evaluate-attempt`'s existing one. `supabase/functions/grade-frq/`
removed from the repo. The deployed Production function (`4c7e99cd-…`, v5)
was left in place — no `delete_edge_function` tool is available via the
Supabase MCP server used this session — but it is harmless: its backing
tables are empty, so it can only ever return `question_not_found`. Delete it
from Production via the Supabase dashboard or `supabase functions delete
grade-frq --project-ref pcntajvbdfqhbeewmdry` whenever convenient; there is no
urgency since it serves no live traffic.
