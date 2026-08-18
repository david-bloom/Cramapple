# TASK-0025 — Hand-Drawn Capture Attachment Schema and Binding

**Task ID:** TASK-0025
**Title:** Bind Hand-Drawn Capture Images to Canonical Responses (Program B, Slice 1)
**Owner:** Claude (implementation), Technical Owner (review)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Implemented and Applied to Development and Production; Frontend Pilot Committed, Pushed, and Live; Independent QA Complete (Fail -- 8 findings), Fixed in Code, and Fix Migration + `attempt-response` Deployed and Verified on BOTH Development and Production (2026-08-17/18, explicit Product Owner go-ahead given in-session); Formal Approval Still Pending (independent QA review recorded findings and fixes, but a real authenticated admin click-through has still never been done)
**Priority:** Critical
**Created Date:** 2026-08-15
**Approved Date:** Pending

## Product Goal

TASK-0020's 2026-08-03 findings
(`docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md`, Program B)
found that a captured hand-drawn photo becomes a text placeholder string --
`app.response_versions` has no way to store an image, `learner-uploads` has
zero canonically bound captures, and nothing validates what a client claims
about an uploaded object. This task is the first approved slice of Program B
remediation: give a captured image a real, immutable, auditable binding to
the exact learner, attempt, response version, and content-item version it
belongs to, with server-side validation of the uploaded bytes.

## Technical Scope

- `app.response_attachments` table: one row per bound image, immutable
  except `capture_quality_state` / `is_current` / `reviewed_at`, retake
  lineage via `replaces_attachment_id`, at most one current `original` per
  response version.
- Storage-layer tightening on `learner-uploads`: once an object is bound to
  a `response_attachments` row, the owning learner can no longer update or
  delete it directly via the storage API.
- `attempt-response` edge function: new `attach_capture` operation that
  downloads the actual uploaded object, re-derives media type/dimensions/
  digest from the real bytes (never trusts client-declared values), and
  writes the binding with the service role.
- `_shared/capture-attachment.ts`: pure PNG/JPEG/WEBP signature and
  dimension parsing, digest computation, and retake-lineage planning
  (unit tested, 21 passing cases).
- `_shared/storage-paths.ts`: path-safety/ownership checks, extracted from
  `storage-sign-url` so both functions share one implementation.

## Extension: Real Submit-to-Graded-Response Pilot (2026-08-15, same session)

The Product Owner's actual goal was narrower and more concrete than "finish
Program A/B/C": get to the point where **a real student can submit a
hand-drawn answer and receive a real graded response**. Investigation found
that no live frontend route did this for *any* item -- `/session`
(`SessionFrame`/`use-session.ts`) is a mock pipeline writing to an unrelated
placeholder `attempts`/`sessions` table and calling a `grade-frq` function
that doesn't exist server-side; the QR capture flow (`CaptureItem.tsx`)
deletes the photo on submit. See the full investigation and approved plan in
this session's transcript (plan file `rustling-launching-waffle.md`).

Built as a deliberately narrow, honest vertical slice -- one real published
item, real image preservation, real human grading (automated grading of
hand-drawn images remains unqualified per TASK-0020 Program C), real visible
result:

- **`record_manual_grade` operation** (`attempt-response`, admin-only): takes
  a per-criterion decision array, writes `app.grading_results` in the exact
  shape `evaluate-attempt` would (sentinel `model_id: 'manual-review'`), and
  updates `app.attempts` to `graded` -- so the existing `public.grading_results`
  read path works unmodified. New shared module
  `supabase/functions/_shared/manual-grading.ts` (`scoreManualGrade`, 14 unit
  tests) fails closed on missing/duplicate/unknown criterion keys and
  status/points inconsistency.
- **Frontend (repo `exam-buddy-wireframe`, all uncommitted)**: a new,
  unlinked route `/hand-drawn-pilot` drives the real pipeline end to end
  (`session-event` → `attempt-response` create_attempt/save_response/
  attach_capture/submit_response → poll `public.grading_results`) against
  the real pilot item `APBIO-HDG-2026-GRAPH-002`
  (`content_item_version_id 1c29347d-0f41-4f09-96a7-6f863be82eaf`, 4
  one-point criteria). New component `SameDeviceCapture.tsx` is a plain
  `<input type=file capture=environment>` control with preview/retake -- no
  QR, no separate table. A new admin-only page
  `/admin/grade-response/$attemptId` lets a human view the preserved photo
  (via `storage-sign-url` `sign_download`) and submit criterion-level
  decisions through `record_manual_grade`. Both student and admin routes are
  gated to `role = 'admin'` client-side (server-side enforcement is real via
  the operation's own role check; client gating exists because the pilot
  item's `prompt_json` still carries `label_status:
  "ai_provisional_unapproved"` -- it must not be reachable by real paying
  students yet).

**Verified:** backend deployed and byte-verified identical on Development
and Production (SHA-256-matched); a full rolled-back SQL simulation of the
entire chain (attempt → response_version with a `capture_only` marker →
`response_attachments` insert → real `submit_response` RPC →
`record_manual_grade`'s exact write shape) passed against Production using
the real `APBIO-HDG-2026-GRAPH-002` item and its real 4 criteria, including
owner-visible reads and cross-user RLS isolation. Frontend: `tsc --noEmit`
clean on the new files; both new routes render correctly under the real
dev server and correctly redirect unauthenticated visitors to `/login` (no
real admin credentials were available in this session to click through the
authenticated happy path -- that remains unverified).

**Not done:** frontend changes are uncommitted in `exam-buddy-wireframe`
(not this repo) and not deployed to Vercel. No independent QA. No real
end-to-end click-through by an authenticated admin.

## Extension 2: QR-Materiality Scoping + Fixing `/session` For Real (2026-08-15)

**QR-materiality scoping** (not implemented, scoping only): written up at
`docs/research/QR_MATERIALITY_DEVICE_MATRIX_SCOPE_2026_08_15.md`. Found zero
existing device/camera analytics in the frontend to answer it from, so it
needs new instrumentation (two-round method proposed: UA-based device-class
proxy, then a small consented follow-up only if desktop share is
non-trivial), with a proposed ~10% decision threshold for Product Owner
sign-off.

**Fixing `/session` for real:** found `public.select_unit_gated_practice_items`
(migration `20260804190000_unit_gated_serving_selector.sql`) already exists,
is real, MCQ+FRQ capable, and unit-gated -- but has **zero callers** and,
critically, **returns zero rows anywhere in Production** because it requires
`label_status = 'validated'` taxonomy labels and none exist yet (2,401
serving labels, 0 validated -- validation requires a real reviewer per a DB
constraint, not something to fabricate). Also found Dev is missing the
entire taxonomy-label-layer migration. Given this, per Product Owner
direction, real `/session` content now uses the older, proven
`select_practice_frqs` (FRQ-only, no unit-gating) instead -- confirmed
returning real rows on Production. `select_unit_gated_practice_items`
support was still built into `student-session-items` (new `mode: "unit_gated"`,
plus MCQ choice-serving support added to the shared render-item pipeline)
so switching over later, once labels are validated, is a config change, not
new engineering.

**Backend changes** (`Cramapple.nosync`, deployed to Dev and Production,
byte-identical, SHA-256-verified):
- `_shared/student-item-delivery.ts`: `RenderItem` gained `item_type` and
  `choices` (choice_key/choice_text only -- never is_correct/rationale);
  `SelectedRow` gained optional `item_type`. 2 new unit tests plus the
  existing answer-leakage allow-list test updated; all 23 tests in this
  file (192 total in `_shared`) pass.
- `student-session-items/index.ts`: new `mode: "unit_gated"` branch (looks
  up `app.student_course_positions`, defaults unit 1 when unset, calls the
  real RPC); default `mode: "frq_only"` behavior is byte-for-byte unchanged
  for existing callers (`_ux/session/frq`).
- `student-session-items` was deployed to Dev for the first time (only
  existed on Production before, TASK-0021-era drift).

**Frontend changes** (`exam-buddy-wireframe`, uncommitted at time of
writing): `src/hooks/use-session.ts` rewritten -- real `session-event`
(`session_start`/`session_end`), real `attempt-response`
(`create_attempt`/`save_response`/`submit_response`), real
`student-session-items` (frq_only) for content, real `evaluate-attempt`
(`grade_initial_attempt`) for grading, replacing the placeholder
`attempts`/`sessions`-table pipeline and the dead `GRADER_FUNCTION_VERIFIED`/
`grade-frq` stub entirely. `rubric_version_id` is passed as
`content_item_version_id` itself (no separate rubric-versioning table
exists; `frq_criteria` is keyed directly by content_item_version_id, and
`evaluate-attempt` never validates this field against a table -- it only
records it, same pattern `free-score-check` uses with a pinned config
value). New shared `src/lib/attempt-response-client.ts` (promoted out of
the hand-drawn-pilot's client helpers, which now just re-export it).
`SessionFrame.tsx` gained a `contentUnavailableReason` render path (honest
messaging instead of an infinite "Loading question…" spinner) for two real
cases: MCQ practice isn't backed by a real selector yet, and outright
fetch/selection failures.

**Known real limitations of this slice** (not silently dropped):
- MCQ practice in `/session` shows an honest "not available yet" notice and
  falls back to FRQ -- `select_practice_frqs` is FRQ-only.
- No unit-gating / no topic-level targeting -- `select_practice_frqs` has
  neither; "Pick a topic" in `session.setup.tsx` doesn't actually narrow
  content yet.
- No repeat-avoidance across sessions -- items are fetched in a batch
  (`limit: 8`) and stepped through within one session, but nothing
  prevents the same batch recurring session to session.
- `rubric_version_id` conflation with `content_item_version_id` should be
  revisited once/if a real rubric-versioning concept is added.
- **Not click-through verified** -- no authenticated admin/student
  credentials were available in this session. Verified instead via: `deno
  test`/`check`/`fmt` (192 passing), `tsc --noEmit` clean on all changed
  frontend files, real SQL confirmation that `select_practice_frqs` returns
  real rows on Production for a real exam pack, and a dev-server render
  check confirming no new console errors and correct unauthenticated
  redirect behavior.

## Out of Scope (explicitly deferred, not silently dropped)

- **QR-materiality device matrix.** No supported-device evidence exists yet;
  this task does not decide whether QR remains mandatory for the general
  (non-pilot) capture experience.
- **Automated capture-quality checks** (blur/glare/cutoff detection).
  `capture_quality_state` defaults to `'pending'` and this task adds no way
  to move it to `'acceptable'` other than a direct service-role update --
  the actual quality-check mechanism (automated or learner-attested) is a
  separate product/UX decision.
- **`submit_response` gating on an accepted attachment.** Requiring an
  `ACCEPTABLE` current original before a construction item can be submitted
  needs a content-classification flag that does not exist in the schema yet
  (TASK-0020 identified the 37 construction items by manual review, not a
  DB column). Submission is not currently blocked by a missing/rejected
  capture.
- **Fixing the placeholder `/session` pipeline itself** (real content
  delivery, real attempts for every item, not just the one pilot item). The
  pilot route deliberately bypasses `/session` rather than repairing it.
- **Operationalizing manual grading** (reviewer queue, qualifications, SLA,
  dispute/regrade path, capacity commitment) -- TASK-0020 Program C names
  this as a separate Hard Gate before any real launch; the admin grading
  page here is explicitly a single-purpose pilot tool, not that queue.
- Program C automation (photo-corpus remediation, DR-1/DR-2 qualification)
  -- unrelated to this binding/pilot layer.

## Data / Security / Integration Impact

- New table `app.response_attachments` with RLS: owner select only, no
  client insert/update/delete policy (writes go through the edge function's
  service-role validation path).
- Storage RLS change on `storage.objects` for `learner-uploads`: narrows an
  existing unconditional owner update/delete policy to exclude objects that
  are already bound to a response attachment.
- Edge function re-derives media type, pixel dimensions, byte size, and
  SHA-256 from the downloaded object bytes; a client-declared media type or
  digest that doesn't match the real bytes is rejected (422), not logged and
  trusted.

## Acceptance Criteria

- [x] Schema exists with the immutability trigger, one-current-original
      constraint, and owner-only RLS select.
- [x] `attach_capture` operation validates real object bytes and rejects
      mismatched/oversized/undersized/unrecognized uploads.
- [x] Retake lineage is enforced against replay/stale client state
      (`planAttachmentInsert`, 8 unit cases).
- [x] Unit tests pass for the new shared modules (21 cases) and the full
      existing `_shared` suite still passes (176 cases, no regressions).
- [x] `supabase/tests/response_attachments.integration.sql` has been run
      against a real Development database (via the Supabase MCP
      `apply_migration`/`execute_sql` tools, 2026-08-15). All 7 checks
      passed: one-current-original constraint, the immutable-fields
      trigger blocking a `storage_path` mutation, `capture_quality_state`
      remaining a legal mutation, owner-scoped RLS select, a direct
      client insert being denied, and cross-user isolation. The
      transaction rolled back, so no fixture data persists in Development.
- [x] Migration applied to Development (project `wmgjsdkphcyhngaffbqf`,
      2026-08-15) and Production (project `pcntajvbdfqhbeewmdry`,
      2026-08-15, explicit Product Owner go-ahead given in-session).
- [x] `attempt-response`/`storage-sign-url` deployed to Development and
      Production, verified byte-identical (matching SHA-256) in both.
- [x] `record_manual_grade` operation built, unit tested (14 cases), and
      verified via a full rolled-back SQL simulation of the real pilot
      item's grading chain on Production.
- [x] Frontend pilot (`/hand-drawn-pilot`, `/admin/grade-response/$id`)
      built in `exam-buddy-wireframe`, type-checks clean, renders and
      auth-guards correctly under a real dev server.
- [x] Frontend changes committed/pushed and deployed. **Update 2026-08-17:**
      the pilot was committed in `exam-buddy-wireframe` at `ee80362` ("Add
      hand-drawn-answer pilot: real submit-to-graded-response path"), is an
      ancestor of the current `main`/`origin/main` (`a8cbd14`), and is live
      in production — `https://cramapple.com/hand-drawn-pilot` correctly
      redirects an unauthenticated visitor to `/login` (verified this
      session), confirming the route is deployed and its client-side
      admin-gate is active.
- [x] Independent QA review of this task's findings and code, per this
      repo's standing practice for Hard-Gate tasks. **Completed 2026-08-17**
      (8-angle automated review, each candidate independently verified) —
      **Verdict: Fail, fixes required before this can be called done.** See
      QA Review section below; 8 confirmed findings, including two that
      break the pilot outright (every retake fails; the manual/automated
      grading paths can silently clobber each other) and a storage TOCTOU
      race that defeats the server-side byte validation this task exists to
      provide.
- [ ] Real end-to-end click-through by an authenticated admin (no
      credentials available in this session).
- [ ] Product Owner decision on sequencing the remaining Program B slices
      (QR-materiality matrix, capture-quality mechanism, fixing the
      placeholder `/session` pipeline for real content) before this can be
      called "Program B done" or "launch ready" in any broader sense.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (privacy/security-relevant schema and storage
policy change; Program B remains a critical launch blocker per TASK-0020).
**Decision:** Pending

## Implementation Notes

- Files: `supabase/migrations/20260814220000_response_attachments.sql`,
  `supabase/functions/_shared/capture-attachment.ts` (+ `_test.ts`),
  `supabase/functions/_shared/storage-paths.ts` (+ `_test.ts`),
  `supabase/functions/attempt-response/index.ts` (`attach_capture`
  operation), `supabase/functions/storage-sign-url/index.ts` (refactored to
  reuse `storage-paths.ts`), `supabase/tests/response_attachments.integration.sql`.
- Dimension parsing covers PNG (IHDR) and JPEG (SOF0-3/5-7/9-11/13-15)
  fully; WEBP is only accepted via the VP8X container (lossy/lossless-only
  WEBP is rejected as unidentified rather than guessed at) -- acceptable
  because real phone captures are essentially always JPEG.
- The immutability trigger (`response_attachments_guard_immutable_fields`)
  applies to `service_role` too, not just `authenticated` -- it's a
  real trigger, not an RLS policy, so it's a backstop against a future
  application bug mutating a bound image in place rather than inserting a
  retake row.

## QA Review

**QA Verdict:** **Fail** (2026-08-17). Independent 8-angle code review
(line-by-line, removed-behavior, cross-file, reuse, simplification,
efficiency, altitude, conventions), each candidate independently verified
by a second pass. 8 findings, all CONFIRMED:

1. **`attach_capture` retake path breaks every retake** — the new current
   row is inserted with `is_current=true` *before* the prior current row is
   flipped to `false`, colliding with the non-deferrable
   `response_attachments_one_current_original` unique index. Every real
   retake (not just a race) hits `unique_violation` → 500. Fix: supersede
   the old row before (or atomically with) inserting the new one.
2. **Storage TOCTOU race** — the object's bytes are downloaded and hashed
   several DB round-trips before the `response_attachments` row exists; the
   owner-can't-mutate-a-bound-object RLS policy only takes effect once that
   row exists, so the owner can swap or delete the object in between via
   ordinary Storage API calls, and the immutability trigger then locks in a
   digest/media-type that no longer matches reality. Fix: re-verify (or
   lock) the object immediately before the insert, or make the
   download+validate+insert sequence atomic with respect to the object.
3. **`record_manual_grade` / `evaluate-attempt` race** — neither path
   checks or locks against the other; whichever finishes last silently
   overwrites `attempts`, with no unique constraint on `grading_results` by
   `attempt_id` to catch it. Fix: add a status precondition on the final
   `attempts` update in both paths, or serialize via a lock/advisory lock.
4. **`record_manual_grade` skips `recordGrowthEvent`/`persistGradingMemory`**
   — every automated grade fires these; manual grades silently don't,
   diverging growth-event and mastery-tracking state for any attempt graded
   through the pilot.
5. **PNG dimension parsing has no upper bound** — a ~1KB crafted PNG can
   declare a width/height up to 4294967295, larger than the `integer`
   `pixel_width`/`pixel_height` columns, causing an unhandled insert-time
   crash (500) instead of a clean 422 rejection.
6. **`response_attachments`'s "never deleted" invariant is comment-only** —
   the immutability trigger is `BEFORE UPDATE` only; `service_role` has
   `DELETE` granted and parent-row deletes cascade. Deviates from this
   codebase's own precedent (`content_review_decisions` guards `BEFORE
   DELETE OR UPDATE`).
7. **Admin attach-on-behalf-of-student is dead code** — the early
   `ownsLearnerPath` check runs before the attempt is even fetched and
   always compares against the *caller's* id, so the later admin-bypass
   branch can never be reached with any real storage path. Not currently
   exploitable, but a latent trap if upload-signing ever grows an admin
   exception.
8. **`CriterionStatus` type duplicated with no shared source** (lower
   severity, continues a pre-existing pattern already duplicated in
   `evaluate-attempt.ts`/`grading-contract.ts`) — `manual-grading.ts`
   redefines the same 5-value status union independently; a future enum
   change could silently desync it from `grading-feedback.ts`.

Full review methodology: 8 parallel finder angles against the diff, deduped,
each surviving candidate independently re-verified against the live code by
a second agent before inclusion — all 8 reported CONFIRMED.

### Fixes applied (2026-08-17, same day)

All 8 findings fixed in code, type-checked (`deno check`, all changed files
clean) and unit-tested (35 new/existing `_shared` tests touching this code
pass; full `_shared` suite 195/195 pass, no regressions). Not yet deployed
-- see Deployment status below.

- **#1 (retake breaks) + #3 (manual/auto-grade race):** new migration
  `supabase/migrations/20260817120000_response_attachments_fixes.sql` adds
  two atomic Postgres functions, called via RPC instead of the prior
  separate insert/update calls:
  - `app.bind_response_attachment` -- supersedes the prior current original
    (if any) and inserts the new row in one transaction, under a `for
    update` row lock (also closes a second, previously-unflagged race:
    two concurrent retakes for the same response_version).
  - `app.record_manual_grade` -- claims the attempt (`attempts.status`:
    `submitted` -> `graded`, conditioned on it still being `submitted`) and
    inserts the `grading_results` row in one transaction, so this can't
    silently race `evaluate-attempt`.
  `supabase/functions/attempt-response/index.ts`'s `attach_capture` and
  `record_manual_grade` operations now call these RPCs; `planAttachmentInsert`
  (capture-attachment.ts) is retained only as a cheap early-exit fast path,
  no longer relied on for correctness.
- **#2 (storage TOCTOU):** `attach_capture` now snapshots a lightweight
  storage-object fingerprint (via `storage.list()`, updated_at + eTag/size)
  immediately after reading the object, and re-checks it immediately before
  the bind RPC call; a mismatch (or missing object) fails closed with 409
  `capture_object_changed` instead of silently binding a stale digest. This
  narrows, but does not perfectly close, the window -- documented in code as
  a real residual (Supabase Storage has no object-level lock to close it
  entirely).
- **#4 (missing side effects):** `persistGradingMemory` was extracted from
  `evaluate-attempt/index.ts` into a new shared module
  `supabase/functions/_shared/grading-memory.ts` (pure move, no logic
  change; `evaluate-attempt` now imports it) so `record_manual_grade` can
  call the identical `recordGrowthEvent`/`persistGradingMemory` path
  automated grading uses. The first-graded-response check is computed
  *before* the atomic grade RPC runs (mirroring `evaluate-attempt`'s own
  "before this update commits" ordering), attributed to the attempt's
  owning student rather than the admin caller.
- **#5 (PNG dimension overflow):** `capture-attachment.ts` adds
  `MAX_DECLARED_DIMENSION_PX` (40,000px) and rejects any declared
  width/height past it with `capture_dimensions_invalid` (422), before it
  can ever reach the `integer` DB columns. Two new unit tests.
- **#6 (DELETE unguarded):** the same new migration extends
  `response_attachments_guard_immutable_fields` to fire `BEFORE DELETE OR
  UPDATE` (unconditionally rejecting DELETE) and revokes the `DELETE` grant
  from `service_role`, matching `content_review_decisions`' existing
  pattern. Cascade deletes from `response_versions`/`attempts` are now also
  blocked (verified no code path in this repo currently deletes either
  table).
- **#7 (dead admin-bypass code):** removed the unreachable
  `&& profile.role !== "admin"` clause from `attach_capture`'s
  attempt-ownership check (two call sites in `attempt-response/index.ts`
  share this pattern; only the `attach_capture` one was touched -- the
  other, in `save_response`, is a real, reachable admin path and was left
  alone).
- **#8 (duplicated status type):** `grading-feedback.ts` now exports
  `CRITERION_STATUS_VALUES` as the single runtime+type source;
  `manual-grading.ts` derives `CriterionStatus` and its validation `Set`
  from it instead of redefining the 5-value union independently.

### Deployment status (2026-08-17)

**Not yet applied to Development or Production.** `supabase db push`
**Update 2026-08-17/18 — resolved and deployed.** The Supabase MCP
authenticated successfully later in the same session (the earlier
"requires interactive OAuth" block was a stale session-start check, not a
durable limitation). Root-caused and fixed the migration-history drift
before deploying:

- **~85 pre-2026-07-31 entries**: an intentional squash (commit `b6559a2`,
  "squash migration history to a verified schema baseline") consolidated
  all early migrations into `schema_baseline.sql`; Development's bookkeeping
  table still remembered the pre-squash individual versions. Resolved with
  `supabase migration repair --status reverted <those versions>` --
  metadata-only, no schema touched.
- **5 more recent entries** (`response_attachments`, `trial_entitlement`,
  `retire_free_score_check`, `purchase_refunded_event`,
  `widen_learning_sessions_entry_path`, spanning 2026-08-15 to 2026-08-17):
  real schema changes applied to Development via `execute_sql`/direct MCP
  calls in past sessions with no migration file ever committed. Queried
  Postgres's own `supabase_migrations.schema_migrations.statements` column
  for the exact applied SQL and reconstructed each as a proper local
  migration file (`20260815175854_trial_entitlement.sql`,
  `20260815181856_retire_free_score_check.sql`,
  `20260817000817_purchase_refunded_event.sql`,
  `20260817015348_widen_learning_sessions_entry_path.sql`). The
  `response_attachments` one turned out to be byte-identical to this
  task's own `20260814220000_response_attachments.sql` -- a version-stamp
  mismatch, not new content -- so that file was renamed
  (`20260815130526_response_attachments.sql`) rather than rewritten.
  **A further, larger drift category (~45 migrations, July 31 -- Aug 15)
  was found but deliberately NOT resolved** -- sample verification showed
  it's a mix of already-applied-but-unrecorded and genuinely-never-applied
  migrations, indistinguishable without per-migration checking; left as a
  separate follow-up, out of this task's scope.
- This task's own fix migration was then applied directly via
  `apply_migration` (Postgres assigned it version `20260818011720`; local
  file renamed to match:
  `supabase/migrations/20260818011720_response_attachments_fixes.sql`).
- `attempt-response` redeployed to Development (version 8) with the fixed
  code (calls the new `bind_response_attachment`/`record_manual_grade`
  RPCs, the storage-freshness check, the dimension bound, the dropped
  dead-code branch). Smoke-tested live: an authenticated-but-unauthorized
  request correctly returns the function's own `{"error":"unauthorized"}`
  (confirms the function and all its shared-module imports load and
  execute cleanly, not just that the deploy call returned success).
- **Both DB-layer fixes independently verified against live Development**
  with real, fully rolled-back SQL (no fixture data persists), mirroring
  this task's own established integration-test pattern:
  - `bind_response_attachment`: first-original insert succeeds; a retake
    naming the real current original succeeds (**the exact call sequence
    that previously threw `unique_violation`**); exactly one current
    original remains afterward and it's the retake; a stale/replayed
    retake target is still correctly rejected; `DELETE` is now blocked.
  - `record_manual_grade`: a first grade on a genuinely `submitted`
    attempt succeeds and claims it; a second call for the same attempt
    (simulating a race with `evaluate-attempt` or a duplicate manual
    grade) is cleanly rejected with `attempt_not_gradable`; the first
    grade's score is confirmed NOT clobbered by the rejected second call.
- **Not yet done:** `evaluate-attempt` redeploy (picks up the
  `persistGradingMemory` extraction only -- pure refactor, no behavior
  change, so not urgent) and Production deployment of both the migration
  and `attempt-response` (Development-only so far, consistent with this
  task's practice of Development-first verification before a Production
  go-ahead).

### Production deployment (2026-08-18) -- fix is live; pipeline still admin-pilot-only

**2026-08-18, explicit Product Owner go-ahead ("Let's get this into
production") given in-session:**

- `20260818011720_response_attachments_fixes.sql` applied to Production
  (`pcntajvbdfqhbeewmdry`) via `apply_migration`. Re-ran the exact same two
  rolled-back SQL verification suites used on Development, this time
  directly against Production, both passing clean (no fixture data
  persists): `bind_response_attachment` (first-original insert, a retake
  correctly succeeding -- the exact sequence that previously threw
  `unique_violation` -- exactly one current original afterward, a stale
  retake target still rejected, `DELETE` now blocked) and
  `record_manual_grade` (first grade claims the attempt, a racing second
  call is cleanly rejected with `attempt_not_gradable`, the first grade's
  score is not clobbered).
- `attempt-response` redeployed to Production (version 23). Confirmed
  content-identical to the Development deploy: `get_edge_function` on both
  projects returned identical `files[].content` for every file (only the
  function-id/path/timestamp metadata line differed -- the `ezbr_sha256`
  field is evidently not a pure content hash across projects, e.g. it
  incorporates the project-specific entrypoint path, so a differing hash
  between environments should not on its own be read as differing source;
  a real file-content diff is the reliable check). Smoke-tested live: an
  authenticated-but-unauthorized request against the real Production
  endpoint returns the function's own `{"error":"unauthorized"}`,
  confirming the function and all its shared-module imports load and
  execute cleanly.
- Confirmed post-deploy: `app.bind_response_attachment` and
  `app.record_manual_grade` both exist in Production; `DELETE` is
  confirmed revoked from `service_role` on `app.response_attachments`.

**Still true, unchanged by this deploy -- no real student can reach this
pipeline regardless of the fix.** The pilot's one content item
(`APBIO-HDG-2026-GRAPH-002`) still carries
`prompt_json.label_status = 'ai_provisional_unapproved'` in Production,
and the frontend routes (`/hand-drawn-pilot`,
`/admin/grade-response/$attemptId`) remain admin-gated and unlinked, as
designed for this pilot slice. `app.response_attachments` and
`app.grading_results` with `model_id = 'manual-review'` both still show
**0 rows ever** in Production (checked immediately before this deploy) --
this pipeline has never actually been used there, by anyone, real or
test.

**Net: the fixed backend is now live in Production, but this remains an
admin-only pilot, not a real student-facing capability.** What's left to
call this genuinely done: (1) a real end-to-end authenticated admin
click-through (still never done, per this task's own open acceptance
criteria), (2) a Product Owner decision to move the pilot item off
`ai_provisional_unapproved` and build a real (non-pilot, non-admin-only)
delivery path -- explicitly out of this task's scope per "Out of Scope"
above.

## Done Decision

**Decision:** Pending
**Date:** Pending
