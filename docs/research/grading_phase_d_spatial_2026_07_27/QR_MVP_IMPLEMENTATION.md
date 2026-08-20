# TASK-0016 Phase D — Stage D2: QR Capture MVP Implementation

**Written:** 2026-08-19. **Executed by:** Claude, per
`prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md` "## Stage D2 — Implement and verify
the QR capture MVP", and per `DECISION-0051`/`APPROVAL-0046`.

**Evidence class: Repository only.** Nothing in this stage has been deployed to Development or
Production, no migration has been applied, and no live Dev/Prod row or storage object was created.
Every claim below is verifiable by `deno test` / `deno check` / `tsc --noEmit` / `vite build` and
code review. See `QR_MVP_TEST_RESULTS.md` for the actual command output.

---

## 1. What this stage was asked to do, and the one gap it had to close

`DECISION-0051` settled the capture-path question: QR handoff (System A) is Engine 4's sole capture
path, there is no direct-upload fallback, and System A's frontend gets rewired onto System B's
already-deployed `attach_capture` / `app.response_attachments` backend rather than recreating the
missing `capture_sessions` table and `capture-research` bucket.

That leaves exactly one real engineering gap, which the decision itself names:

> the phone leg is token-paired/unauthenticated, but `attach_capture` only accepts authenticated
> calls — a bridge between the two is the actual Stage D2 work item now.

Confirmed by reading the code: `attempt-response/index.ts` runs a single `requireProfile(req)` gate
above its operation switch and `attach_capture` validates ownership with
`ownsLearnerPath(user.id, storagePath)`. **And the gap is wider than `attach_capture` alone** —
`storage-sign-url`'s `sign_upload` also requires an authenticated caller and also enforces
`ownsLearnerPath(userId, path)`, so the phone cannot even obtain an upload URL without a bridge.

## 2. Design chosen, and why — option (a), as a separate function

Two shapes were considered.

**(a) A token-authenticated operation that resolves the binding server-side and reuses the exact
same validation + `bind_response_attachment` path.** Chosen.

**(b) Alternatives considered and rejected:**

- *Give the phone a real Supabase session* (anonymous sign-in, or a scoped custom JWT). Rejected:
  it converts a narrow, single-purpose, 15-minute capability into a general-purpose credential on
  an unauthenticated device, and it would make the phone leg's blast radius "whatever RLS allows
  that identity" rather than "one object path on one response version". It also fails the
  requirement that the capability "cannot access other records" — a session inherently can.
- *Have the phone POST image bytes to the app server, which then calls `attach_capture` with the
  student's stored JWT.* Rejected: it requires the app server to hold or re-mint user JWTs for
  users who are not the current requester, and it routes multi-megabyte photo bytes through the
  app server instead of straight into Storage.
- *Recreate `capture_sessions`/`capture-research`.* Explicitly ruled out by `DECISION-0051`.

**Where the operation lives: a new `capture-pairing` edge function, not a new `attempt-response`
operation.** This is a deliberate departure from the prompt's parenthetical example
(`attach_capture_by_pairing_token` as an `attempt-response` operation), and the reason is
structural. `attempt-response` authenticates *above* its operation switch, so every operation it
will ever contain is authenticated by construction. Adding an intentionally-unauthenticated
operation there means moving the auth check below the switch — and from that point on, every future
operation added to the most security-sensitive function in the codebase is
unauthenticated-by-default unless its author remembers to opt in. TASK-0025's QA review already
found one dead admin-on-behalf-of-student branch in that file caused by exactly this kind of
blurred boundary (finding #7).

So the split is: `attempt-response` stays "authenticated callers only", and `capture-pairing` owns
the token-authenticated leg.

**Crucially, this is reuse, not a parallel implementation.** `capture-pairing` imports and calls:

| Reused artifact | What it gives the bridge |
|---|---|
| `_shared/capture-attachment.ts` `validateCaptureObject` | MIME/signature/decode, size and dimension bounds, and re-derivation of media type / digest / dimensions from real bytes (never client-declared values) |
| `_shared/capture-attachment.ts` `planAttachmentInsert` | Retake-lineage fast-fail, same rules, same error codes |
| `_shared/storage-paths.ts` `isSafeStoragePath` / `ownsLearnerPath` | The same path-safety and owner-namespace rules `storage-sign-url` and `attach_capture` use |
| `app.bind_response_attachment` RPC | The same atomic, row-locked supersede-then-insert write, so the retake race and ordering bug fixed in `20260818011720` are fixed here too, by construction |
| `app.reserve_model_usage` RPC | The same daily-USD-cap reservation `evaluate-attempt` uses, now also gating the capture-quality model call |
| `app.audit_events` | The same durable audit convention used by `attempt-response`, `storage-sign-url`, `admin-content`, `session-event` |
| `learner-uploads` bucket + its RLS policies | One storage system, not two. Objects land in the owner's namespace under the same policies as the same-device path. |

There is no second byte-validation path, no second attachment table, no second bucket, and no
second storage-TOCTOU guard.

### 2.1 Transport: how the phone reaches an edge function without a JWT

The phone does **not** call the edge function directly. It calls this app's own server
(TanStack `createServerFn`), which calls `capture-pairing` server-to-server with the service-role
key. That has three consequences worth stating plainly:

1. **No service-role credential reaches any client.** It stays in the app server process, exactly
   as `supabaseAdmin` already does for other server functions.
2. **The platform's `verify_jwt` gate is satisfied without weakening it.** No
   `--no-verify-jwt` deploy flag is needed, and no Supabase key has to be shipped to an
   unauthenticated page. (This matters here because the project uses `SUPABASE_PUBLISHABLE_KEY`
   naming; new-style publishable keys are not JWTs, so an anon-key-in-the-browser call from the
   phone page could not be relied on to pass that gate.)
3. **The service role grants the phone nothing extra.** The token-leg operations never consult
   `requireProfile`, so authorization is the capability and only the capability. And if a future
   edit accidentally routed an authenticated operation through the service-role transport, it would
   fail closed: `requireProfile` calls `auth.getUser()` on the presented key, which does not resolve
   a user for a service key.

## 3. What was built

### Backend (this repo)

| File | Status | Purpose |
|---|---|---|
| `supabase/functions/_shared/capture-pairing.ts` | New, 460 lines | Pure capability logic: CSPRNG handle generation, SHA-256-only persistence, usability evaluation (expiry / single-use / cancellation / attempt budget), purpose-binding checks, mint rate limiting, owner-scoped storage-path builders, generic retake copy, and a `pairing_submission_provenance_event.v1` record builder. No client, no fetch — every security decision is unit testable. |
| `supabase/functions/_shared/capture-pairing_test.ts` | New, 35 tests | One test per Stage D2 security line (see §5). |
| `supabase/functions/_shared/capture-quality-check.ts` | New (reintroduction of reverted `52efaef`, changed — see §4), 480 lines | The vision check plus its pure disposition rollup, mirroring `capture_quality_result.v1` exactly. Returns a discriminated union so an image-quality verdict is distinguishable from a broken checker. |
| `supabase/functions/_shared/capture-quality-check_test.ts` | New, 28 tests | Replaces and extends the 6-test suite reverted with `d0b6fef`. |
| `supabase/functions/_shared/image-metadata.ts` | New, 400 lines | Container-level EXIF/XMP/comment stripping for JPEG (APPn/COM), PNG (`eXIf`/`tEXt`/`zTXt`/`iTXt`/`tIME`) and WEBP (`EXIF`/`XMP `, with RIFF size correction). Copies compressed image data through byte-for-byte; never mutates the input. |
| `supabase/functions/_shared/image-metadata_test.ts` | New, 19 tests | Byte-level fixtures per container, including truncated/over-long-length cases. |
| `supabase/functions/capture-pairing/index.ts` | New, 1,100 lines | The bridge. Six operations (§3.1). |
| `supabase/migrations/20260819120000_capture_pairing.sql` | New, **NOT APPLIED** | `app.capture_pairing_tokens`, `app.capture_pairing_events` (append-only), and three functions: `claim_capture_pairing_upload` (atomic claim), `consume_capture_pairing` (single-use CAS), `expire_capture_pairing_tokens` (sweep). |

`attempt-response/index.ts` is **unchanged**. Deliberately: it is deployed, QA'd, and the only
existing writer of `response_attachments`. Nothing about this stage required editing it, and
editing a deployed function to add a feature that lives elsewhere would be gratuitous risk.

#### 3.1 Operation surface

Authenticated (the student's own primary device, real Supabase JWT via `requireProfile`):

- `mint_pairing` — Stage D2 steps 1–2. Validates attempt ownership and editability and that the
  response version is unsubmitted, applies the mint rate limit, cancels any live capability for the
  same slot (so re-minting a QR code invalidates the previous one), inserts the row, returns the
  capability **once**.
- `pairing_status` — step 7. Owner-scoped by `.eq("user_id", user.id)`. Persists lapsed expiry
  truthfully on read, and returns a 120-second signed read URL for the bound original so the desktop
  can render a thumbnail without any client ever being granted read access to
  `app.response_attachments`.
- `cancel_pairing` — step 10's cancellation path.

Token-authenticated (the phone, capability only):

- `describe_capture` — steps 3–4. Returns the slot, expiry, remaining attempts and static capture
  guidance. Contains no PII. Does **not** consume an attempt, so a phone that reloads mid-flow is
  not punished for it.
- `create_capture_upload` — step 5's upload half. Atomically claims one attempt, then returns a
  Storage signed-upload URL for a **server-constructed** path. There is no path parameter for a
  caller to point elsewhere.
- `submit_capture` — steps 5–8. Requires explicit confirmation, re-verifies the live attempt and
  response version, downloads and validates the bytes, runs the capture-quality check, binds the
  immutable original, produces and binds a separate metadata-stripped derivative, records the
  quality disposition, and consumes the capability by compare-and-set.

### Frontend (`exam-buddy-wireframe`, branch `phase-d2-qr-capture-rebuild`, commit `6dd89ff`)

Branched from `origin/main` (`e8b65e9`) in a fresh worktree — the shared
`.worktrees/task0019-frontend` checkout was 16+ commits stale and was left untouched.

| File | Change |
|---|---|
| `src/lib/capture-schema.ts` | Rewritten. `capture_sessions` row shape → `capture-pairing` response contracts, plus the `failure_class` discriminator and `classifyCaptureError` (which defaults unknown codes to `technical`, never `image_quality`). |
| `src/lib/capture.functions.ts` | Rewritten. 11 direct `capture_sessions` call sites → 6 typed edge-function calls. Two legs, two credentials (user JWT for the primary device, service role server-to-server for the phone), neither reaching the browser. The `storage.remove()` that deleted the photo is gone. |
| `src/components/session/CaptureItem.tsx` | Rewired. Same QR + typed-URL-fallback + polling UX; now yields a real attachment id and applies the DECISION-0051 failure split. QR `<img>` is now `alt=""`/`aria-hidden` with the link as real text beside it. |
| `src/routes/capture-phone.tsx` | Rewired. Adds an explicit review-then-submit step (upload ≠ submit), separate screens for image-quality vs technical vs blocked failures, `referrer: no-referrer`, and HEIC rejected up front with readable copy. |
| `src/hooks/use-session.ts` | Adds `prepareCaptureSlot` and `submitCapturedResponse`. |
| `src/components/session/SessionFrame.tsx` | Threads the new props; corrects one piece of copy that would otherwise have been false (§6). |
| `src/routes/capture-demo.tsx` | Retired to a notice page (§6). |
| `src/lib/__tests__/capture-contract.test.ts` | New, 16 tests. |

## 4. The Layer A revert investigation

**The revert reason is not recorded anywhere findable, and this document does not guess at it.**

`52efaef` ("Add capture-quality check for hand-drawn photo uploads (idea 1, Layer A)", 2026-08-18
09:55:41) was reverted by `d0b6fef` **two minutes and forty-five seconds later** (09:58:26). The
revert commit message is the default `git revert` text and gives no reason.
`docs/activity_log/ACTIVITY_LOG.md` (line 138) states outright that the revert "appeared on
`origin/main` outside this session — reason not recorded here", and its own "Next Required Action"
(line 141) is *"decide and record why Layer A was reverted"*. So the reason is genuinely unknown,
not merely undocumented in one place.

What the *code* shows, on review, are four real defects. Any of them could have been the trigger;
all four are fixed in this reintroduction either way, and each fix is pinned by a test:

1. **Uncapped model spend on a student-triggered path.** `evaluate-attempt`, the only other model
   caller in this codebase, reserves against `OPENAI_DAILY_CAP_USD` via
   `app.reserve_model_usage` before every call. Layer A had no equivalent, so every capture upload
   was an unmetered spend channel. **Fixed:** `runCaptureQualityCheck` now takes a required
   `reserveCost` callback, and a refused *or throwing* reservation returns
   `{ kind: "unavailable", failure: "cost_cap_reached" }` **without calling the model at all**.
2. **Specific defect callouts, which `DECISION-0051` then contradicted.** Layer A returned
   sentences like "Glare or a shadow is covering part of the page". `DECISION-0051` — logged the
   day *after* the revert — made generic guidance the baseline and demoted defect-naming to an
   optional refinement. **Fixed:** `buildRetakeGuidance()` returns generic copy by default; the
   specific strings are retained but only reachable via an explicit `specific: true` opt-in that
   nothing currently uses.
3. **Technical failures indistinguishable from ambiguous photos.** Layer A collapsed network
   errors, HTTP errors, timeouts, unparseable output and a missing label into the same
   `HUMAN_REVIEW` / `'indeterminate'` result as a genuinely ambiguous image. That makes the exact
   split `DECISION-0051` requires unimplementable. **Fixed:** a three-way discriminated union
   (`assessed` / `unavailable` / `technical_failure`), with `timeout` reported distinctly from
   `network_error`.
4. **Unbounded blocking call in the upload path.** A 15s default with no clamp on the env override.
   **Fixed:** `clampCaptureQualityTimeout` enforces a 3s floor / 20s ceiling and treats
   unset/0/negative/NaN as the ceiling rather than 0 (which would have aborted every call
   instantly).

Two further possibilities I can see but **cannot** confirm, and am flagging rather than asserting:
the activity log notes the original was pushed directly to `main` bypassing branch protection and
that this was "worth confirming is intentional"; and the same session's separate finding said to
leave the spatial grading path alone. Either could have prompted a same-day back-out on process
grounds rather than code grounds. There is no evidence either way.

**Unresolved side effect, still unresolved:** the Lovable frontend was updated in that session to
read `capture_quality_state`/`capture_retake_reason` and was never rolled back, so production
carries a frontend expecting fields the backend does not send. This stage's frontend work replaces
those call sites, but **that fix only reaches production on a Lovable publish**, which is outside
this stage's boundary. Until then the drift persists exactly as recorded in
`project_idea1_capture_quality_check_status`.

## 5. Error tracking / bug logging — what exists

`DECISION-0051` requires technical failures be "captured as an error/telemetry event for
engineering triage". I searched for an existing convention before building anything.

**Backend: there is no general error-tracking mechanism in this repo.** No Sentry, no Rollbar, no
`app.error_events` table, no error-tracking client anywhere under `supabase/functions/`. What
exists is:

- `app.audit_events` — durable, hash-chained (`event_sha256`), already used by `attempt-response`,
  `storage-sign-url`, `admin-content` and `session-event`. **This is what the bridge uses.**
  Technical failures are written with `reason_code: "technical_failure"`, an `action` naming the
  stage, and the failing detail; the audit row's id is returned to the client as `incident_id`, so
  a student-visible "we've logged this" has a real reference behind it.
- `app.growth_event_outbox` → PostHog (`_shared/growth-events.ts`) — an acquisition-funnel pipeline
  with a closed event-name allowlist and an explicit "no answers, no grades, no PII" property
  filter. **Deliberately not used:** pushing engineering errors through it would violate that
  contract and pollute funnel analytics.
- `_shared/grading-telemetry.ts` — observational columns specific to `grading_results` rows, not a
  general error sink.

**Stated plainly: `app.audit_events` is a durable log, not an alerting system.** Nothing pages
anyone, and nothing aggregates these rows into a dashboard. Standing up real error tracking is a
genuine gap this stage did not close and did not invent a substitute for.

**Frontend: a mechanism does exist.** `src/lib/lovable-error-reporting.ts`'s `reportLovableError`
forwards to Lovable's `window.__lovableEvents.captureException`. Both capture surfaces now call it
for `technical` failures only — never for `image_quality` or `blocked`, which are normal outcomes —
and pass no image bytes, no capability, and no student content.

## 6. Known gaps and things stated rather than hidden

1. **Optional-photo-alongside-typed-FRQ is not closed.** A capture must bind to a response version
   *before* submission, but `save_response` always inserts a *new* version and there is no
   operation to set text on an existing draft. So on that flow the photo lands on its own version
   and the typed answer is graded on a different one. The image is preserved, private and
   auditable — it is simply not joined to the graded version. Closing it needs a new
   `attempt-response` operation (Stage D3+). The UI copy was corrected from "will submit with your
   typed answer" (which would have been false) to "Photo saved for this question."
2. **The desktop leg cannot distinguish a technical failure from a genuinely ambiguous photo.**
   `capture_quality_state` has only four legal values, and both cases land on `'indeterminate'`.
   The **phone** — where the student actually is — gets the correct three-way split from
   `submit_capture`'s `failure_class`. The desktop therefore shows deliberately blameless copy for
   `'indeterminate'` ("your photo is saved, but our automatic check didn't finish"). Fixing this
   properly needs a fifth column value or a separate failure-class column.
3. **`/capture-demo` retired to a notice, not deleted.** It was a research page built on the
   missing table and could not function. Deleting the route outright is a reasonable cleanup but is
   a product decision, so the URL was kept with an honest notice instead.
4. **No per-IP rate limiting on the unauthenticated leg.** Minting is rate-limited per
   authenticated user, and the expensive phone operations are bounded by the per-capability attempt
   budget. But `describe_capture` on a valid capability has no limiter beyond needing an unguessable
   43-character handle. Edge-function-level IP limiting does not exist in this codebase; adding it
   is infrastructure work, not a code change here.
5. **`expire_capture_pairing_tokens` has no scheduler.** The function exists and is tested by
   inspection, but nothing calls it on a cron (`pg_cron` is not set up for this). Expiry is still
   *enforced* on every read and claim, so nothing behaves as if a lapsed capability were live —
   the sweep is a hygiene job, not a correctness dependency.
6. **Storage cleanup of abandoned uploads is not implemented.** An object uploaded but never
   submitted stays in `learner-uploads` unbound. Deliberately not deleted by the bridge: a delete
   there could race a concurrent bind, and a *bound* original is immutable evidence. This needs a
   bucket retention policy, which is project configuration.

## 7. Environment variables this introduces

All optional; all degrade to "quality check not run, attachment still binds with `'pending'`".

| Variable | Default | Notes |
|---|---|---|
| `OPENAI_API_KEY` | — | Already required by `evaluate-attempt`. Absent ⇒ `unavailable/not_configured`. |
| `OPENAI_DAILY_CAP_USD` | — | Already required by `evaluate-attempt`. **Absent or ≤ 0 ⇒ the check does not run.** Fail-closed on spend by design. |
| `CAPTURE_QUALITY_MODEL` | `gpt-4o-mini` | |
| `CAPTURE_QUALITY_TIMEOUT_MS` | `12000` | Clamped to 3000–20000. |
| `CAPTURE_QUALITY_RESERVED_COST_USD` | `0.01` | Fixed conservative reservation; one image, 512-token ceiling, nothing to estimate. |
