# TASK-0016 Phase D Stage D2 — Independent QA Review (2026-08-19)

**Reviewed:** backend `768b1bb` (branch `worktree-agent-ac9429c5f676cfd4f`, this repo) and frontend
`6dd89ff` (branch `phase-d2-qr-capture-rebuild`, `exam-buddy-wireframe`, durable in
`/Users/davidbloom/Documents/exam-buddy-wireframe`). Neither branch is merged, pushed, or
deployed. Method: 5 independent finder angles (security/trust boundary; migration SQL;
reuse-drift vs. `attach_capture`; frontend state machine + regressions; test/doc verification),
deduped, each surviving candidate independently re-verified against the actual code before being
reported — matching this repo's established review methodology
(`docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`'s QA section).

## Bottom line: HOLD FOR REWORK

Not merge-with-fixes. Two reasons: (1) the two primary user journeys are dead ends on first
click — a blurry photo (finding 1) and Cancel (finding 2) — and finding 1 is the specific
behavior `DECISION-0051` was written to guarantee; (2) finding 3 is a cross-tenant production
hazard — a capture feature that leaks the shared grading budget will make *grading* fail for
students who never used capture, worse than the feature not existing.

**The architecture itself is sound.** Trust boundary, CAS semantics, hash-only token, RLS
posture, reuse of `validateCaptureObject`/`bind_response_attachment`, and keeping
`attempt-response` authenticated-by-construction (rather than blurring it) all verified correct
under adversarial review. Defects are concentrated in lifecycle edges (state transitions, the
two-call budget protocol, frontend state exits) — fixable without a redesign.

**Deployment characterization verified independently, accurate:** neither commit is on any
remote branch; the migration is on neither Dev nor Production's applied-migration list;
Production has no `capture-pairing` function deployed. Test counts reproduce exactly (82 new / 0
failed; full `_shared` suite 260/260).

## Blocking findings (all CONFIRMED, independently re-verified)

1. **The mandated retake is a guaranteed dead end for every blurry photo.** `consume_capture_pairing`
   fires on every successful bind including quality-rejected ones, setting `state='consumed'`
   unconditionally. A student who fails the quality check and taps "Take a new photo" hits a 409
   `pairing_already_used` and a buttonless "This pairing link has already been used" screen.
   `PAIRING_MAX_REDEMPTION_ATTEMPTS = 5` (built specifically for this case) is unreachable dead
   code.
2. **"Cancel pairing" strands the desktop at "Loading…" permanently.** `reset()` is called with no
   `start()`; the auto-start effect can never re-fire (`autoStartedRef`, empty deps). Only escape
   is Close, which silently flags the question for review instead of capturing it.
3. **`reserve_model_usage` is never completed** — the capture-quality vision call reserves against
   the shared `OPENAI_DAILY_CAP_USD` budget but `complete_model_usage` is never called on this
   path (unlike `evaluate-attempt`, which releases in a `finally`). ~400 captures/day can leak the
   full cap, causing `evaluate-attempt` to falsely return "reached today's research limit" to
   students who never touched capture. Resets at UTC midnight — daily degradation, not permanent.
4. **Unbounded unmetered paid vision calls from one capability.** A trivially triggerable failure
   path (valid photo + bogus `replaces_attachment_id`) causes the model call to fire *before* the
   bind-side error, and the budget guard's replay fast-path (constant `request_id`/`request_hash`
   across retries) doesn't prevent repeat billing — one capability can drive unlimited paid model
   calls within its 15-minute TTL.
5. **The DECISION-0051 bug-logging mechanism silently drops rows and returns a fabricated
   `incident_id`.** `app.audit_events` has a `UNIQUE (request_id, reason_code)` constraint; 4 call
   sites share `reason_code: "technical_failure"` with a constant `request_id`, so a second
   technical failure in one submit flow 409s, the error is swallowed to `console.error`, and the
   function returns the (non-existent) `incident_id` anyway.
6. **Two SQL bookkeeping `UPDATE`s are always rolled back.** Both branches issue an `UPDATE` then
   `RAISE EXCEPTION` with no enclosing exception block, discarding the update. `state='rejected'`
   is dead — no code path ever writes it, so an exhausted-attempts row looks live forever.
7. **`ON DELETE CASCADE` is unreachable** — an unconditional `BEFORE UPDATE OR DELETE` guard
   trigger blocks the cascade delete it's supposed to allow. Confirmed caller today: a dev QA
   script; will matter for any future account-deletion/GDPR path.

## Serious, non-blocking

8. **DECISION-0051's failure split is broken on the desktop leg** — `pairing_status` never
   surfaces `failure_class`; the desktop derives its screen from `capture_quality_state` alone,
   which conflates "ambiguous photo" and "our checker broke" into the same `indeterminate` value.
   Same photo, same moment, phone and desktop can assign blame differently.
9. **Double-submit guard is inert** — `committing` state never becomes observable before
   `onSubmitted` fires; a double-tap can report "grading failed" on an answer that actually
   submitted successfully.
10. **HEIC photos (iOS camera default in some configs) hit a buttonless "We can't use this link"
    screen** with incorrect copy for what's a file-format problem.
11. **Provenance event `sequence` uses an unlocked `COUNT(*)`** against a UNIQUE constraint —
    concurrent writes can silently drop an audit event and permanently skew the count low for
    that pairing.
12. **Auto-resolved `supersedes` can silently retake/hide a different slot's page** if multi-slot
    capture is ever used (latent today, since the frontend mints one slot per attempt).
13. **Bind and consume are separate writes** — a cancel racing a phone submit can leave a bound,
    current attachment that `pairing_status` never reports and that can't be corrected via a
    retry (unique-constraint collision, unrecognized by the error mapper → 500).
14. **"Phone connected" detection was silently dropped** in the rewrite — the desktop shows
    "Waiting for your phone" for the entire time the student is framing the photo, not just
    during actual pairing.
15. **The 1420-line security-critical endpoint has zero tests of its actual request-handling
    logic** — all 82 new tests exercise pure helpers. Cross-user denial and single-use-under-
    concurrency are asserted "by construction," not tested.

Additional item, not a defect but flagged for a product decision: a successful capture submission
currently lands the student in `human_review_pending` with no grading triggered at all (Engine 4
is shadow-only, consistent with scope) — but per this program's standing "no human grading in
production" finding, nothing will ever resolve that state for a real student. Needs explicit
product copy/decision before any real student reaches this screen.

## Lower severity

Config landmine where the quality check silently no-ops if `OPENAI_DAILY_CAP_USD` is unset (vs.
`evaluate-attempt`'s loud failure on the same class of misconfiguration); `generation` field
resets in a way that breaks the frozen contract's intended semantics; desktop thumbnail dies
after 120s with no refresh; a self-healing poll/retake race; dead code in `hand-drawn-pilot.tsx`
gating on backend fields that don't exist (the same `capture_retake_reason`/`capture_quality_state`
drift already tracked in memory as the Layer A frontend/backend mismatch); several doc-precision
errors in the implementer's own deliverables (wrong line counts, a cited function that doesn't
exist, a docstring claiming the opposite check order from what the code does); no retention/purge
policy on either new table.

## Verified correct (reviewer actively tried to break these)

No service-role credential reaches the browser; `verify_jwt: true` is genuinely compatible with
the unauthenticated leg (the phone talks to the app server, which proxies with the service role);
single-use is a real compare-and-set under a row lock, not check-then-act; token design is sound
(256-bit CSPRNG, hash-only persistence); RLS is correct on both new tables (zero policies, zero
grants, owner-scoped only); cross-user access is genuinely prevented and more strictly checked
than the original `attach_capture`; byte validation is the literal same code, not a reimplementation;
7 of 8 defects from `attach_capture`'s prior QA history confirmed NOT reintroduced; System B's
pilot flow (`SameDeviceCapture`/`hand-drawn-pilot`) is untouched by this branch; frontend/backend
contract matches field-for-field; `routeTree.gen.ts`'s diff is pure codegen, no hand edits.

## Suggested gate before re-review

Fix findings 1–6. Add real request-handling tests for `capture-pairing/index.ts` covering
single-use-after-quality-failure, cross-user denial, and the storage-path guard (finding 15).
Resolve finding 8 with a real `failure_class` field on `pairing_status`'s wire contract, not a
fifth enum value on `capture_quality_state`. Correct the doc-precision errors so the next
reviewer isn't working from claims that don't hold.
