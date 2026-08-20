# TASK-0016 Phase D Stage D2 — QR Capture Rework (2026-08-20)

**What this is.** The rework pass that Round 1's independent QA
(`QR_MVP_QA_REVIEW_2026_08_19.md`, verdict HOLD FOR REWORK) called for. It fixes **all 15 of that
review's findings** — the 6 blocking, finding 7, and the serious/non-blocking 8–15.

**Provenance note, worth recording.** This session was launched to run a Round-2 *re-review* of a
rework a prior session was said to have done. Independent verification found no rework had happened:
both branches were byte-identical to the failed-QA commits (`768b1bb`/`6dd89ff`), each branch's
reflog showed a single commit, no dangling commits, nothing on any remote. Only after establishing
that — and re-deriving all 6 blocking findings against the actual current code — was the rework
itself executed, at the owner's direction.

**Reworked commits (neither merged, pushed, or deployed):**

- Backend `worktree-agent-ac9429c5f676cfd4f` @ `c45b838` (findings 1–8,15 in `2dcaf95`; 9–14 in
  `c45b838`), on top of the original `768b1bb`.
- Frontend `phase-d2-qr-capture-rebuild` @ `b01d3b0` (findings 2,8 in `7bab9aa`; 9,10 in
  `b01d3b0`), on top of the original `6dd89ff`, in `exam-buddy-wireframe`.

**Deployment/mutation discipline (unchanged from Round 1, re-verified):** neither rework commit is
on any remote; migration `20260819120000_capture_pairing` is applied to neither Development
(`wmgjsdkphcyhngaffbqf`) nor Production (`pcntajvbdfqhbeewmdry`) — both migration lists still end at
`20260818…response_attachments_fixes`; no `capture-pairing` edge function exists on either project.

---

## Blocking findings (1–6)

**1 — Blurry-photo retake dead end.** `consume_capture_pairing` fired on every successful bind,
including quality-rejected ones, so a retake against the same QR hit `already_used` and
`PAIRING_MAX_REDEMPTION_ATTEMPTS` was dead. **Fix:** submit now finalises via one of two RPCs — a
retake-eligible outcome (`retake_required`/`indeterminate`) calls the new
`app.record_capture_upload`, which records the bound attachment and verdict but leaves the
capability live in `uploaded`; only a clean/accepted capture calls `consume_capture_pairing`. A
same-path resubmit short-circuits idempotently (returns the recorded result, no re-bind, no paid
call). `index.ts` `submit_capture` finalise block; migration `record_capture_upload`.

**2 — Cancel strands the desktop.** "Cancel pairing" called `reset()` only; the auto-start effect
(empty deps) could never re-fire. **Fix:** `CaptureItem.handleCancel` = `reset()` + `start()`, wired
to the button. `CaptureItem.tsx`.

**3 — Shared grading-budget leak.** The capture-quality reservation against the shared
`OPENAI_DAILY_CAP_USD` was never released, so a day's failed captures could make `evaluate-attempt`
falsely reject unrelated students. **Fix:** `complete_model_usage` is now called on every path where
a reservation was actually taken (`qualityOutcome.kind !== "unavailable"`), best-effort so a
completion failure can't fail an upload that already bound. `index.ts` `submit_capture`.

**4 — Unmetered paid-call loop.** The paid vision call ran *before* the bind, so a trivially-failing
submit (bogus `replaces_attachment_id`) spent without binding, and the idempotent reservation let
repeats re-bill. **Fix:** the quality call moved to *after* a successful bind (a pre-bind failure now
spends nothing), plus the same-path idempotency short-circuit and the redemption budget together
bound paid calls to ≤ attempts per capability. `index.ts` `submit_capture`.

**5 — Bug-logging drops rows / fabricates `incident_id` / suppressible.** `logAuditEvent` reused the
client-supplied idempotency key as `request_id` against `UNIQUE(request_id, reason_code)`, so a
second same-`reason_code` event in one request collided and was swallowed while still returning a
fabricated id — and the unauthenticated phone could pin the key to suppress its own logs. **Fix:**
`logAuditEvent` uses a server-generated unique `request_id` (correlation id moved to
`metadata.correlation_id`) and returns `null` on insert failure; callers surface no id when null.
`index.ts`.

**6 — Dead SQL housekeeping updates.** `claim_capture_pairing_upload`'s expiry and
attempts-exhausted branches did `UPDATE … then RAISE`, rolling the update back; `state='rejected'`
was unreachable. **Fix:** those two transitions now COMMIT by `RETURN`ing the terminal row instead of
raising; the caller (`create_capture_upload`) branches on the returned `state` (`expired`/`rejected`)
to map the 409. Migration `claim_capture_pairing_upload`; `index.ts` `create_capture_upload`.

## Serious / non-blocking findings (7–15)

**7 — `ON DELETE CASCADE` unreachable / erasure trap.** The append-only guard fired on
`before update OR delete`, so a parent cascade (attempt/session/response-version → token → events)
was blocked, making those rows undeletable. **Fix:** the guard fires on `before update` only; direct
deletes stay impossible (no DELETE grant, plus an explicit `revoke delete, truncate`), while a
system-performed cascade — which runs as the table owner, not the caller — now succeeds. Migration.

**8 — DECISION-0051 split broken on the desktop.** `pairing_status` never carried `failure_class`, so
the desktop derived its screen from `capture_quality_state` alone and showed the same
`indeterminate` screen for "our checker broke" and "ambiguous photo." **Fix:** new `failure_class`
column on the token, set at finalise, surfaced through `publicPairingView`; the desktop keys on it
first and shows a distinct blameless `capture_problem` screen for technical failures. Also corrected
the disposition→class map so `HUMAN_REVIEW` is no longer mislabeled `image_quality`. Migration;
`index.ts`; `capture-schema.ts`; `CaptureItem.tsx`.

**9 — Inert double-submit guard.** `handleCommit` set `committing` true then false in one tick, so
the disabled state never rendered. **Fix:** a synchronous `committedRef` guards re-entry and
`committing` is left set (reset only on `reset()`), so a double-tap can't fire `onSubmitted` twice or
show a false "grading failed." `CaptureItem.tsx`.

**10 — HEIC hits a buttonless dead end.** An unusable file format fell through to the buttonless
"We can't use this link" screen. **Fix:** a new retryable `unsupported_file` phone screen names the
iPhone-HEIC cause and offers "Take a new photo." `capture-phone.tsx`.

**11 — Unlocked provenance `sequence`.** `sequence` was computed from an unlocked `count(*)` then
inserted against `UNIQUE(pairing_id, sequence)`, so concurrent appends collided and one was silently
dropped. **Fix:** new `app.append_capture_pairing_event` RPC does max+insert under a lock on the
parent token row and patches the real sequence into the stored JSON via `jsonb_set`. Migration;
`index.ts` `appendProvenanceEvent`.

**12 — Multi-slot supersede hazard (latent).** Auto-resolving the supersede target to "the response
version's current original" would span slots if a multi-slot-per-response-version model were ever
introduced. **Fix:** the auto-resolve now fails closed (`attach_capture_ambiguous_supersede_target`,
409) for any non-default submission slot without an explicit target. `index.ts`.

**13 — Bind/consume race strands a bound attachment.** A cancel racing a submit could leave a bound
current attachment the token never reported, with a retry hitting an unmapped 500. **Fix:** on a
finalise CAS miss the handler re-reads the token and returns the accurate terminal reason
(cancelled/expired/attempts-exhausted/already-used) plus a race audit; the bound original is
self-healing (superseded by the next capture, `is_submitted`-gated), so it is left in place rather
than force-unbound. `index.ts`.

**14 — "Phone connected" not surfaced.** State only reached `paired` at the first upload, so the
desktop showed "Waiting for your phone" throughout framing. **Fix:** `describe_capture` advances
`issued → paired` when the phone opens the page (idempotent, attempt-free); `PAIRING_ACCEPTED` is
emitted there instead of being double-emitted at upload. `index.ts`.

**15 — No request-handling tests.** All prior tests covered pure `_shared` helpers. **Fix:** new
`capture-pairing/index_test.ts` (with `_test_setup.ts`) drives the exported `handleCapturePairing`
through an in-memory service/storage fake whose RPCs mirror the migration — 22 tests covering
routing, auth, role gate, cross-user denial, storage-path guard, single-use-after-quality-failure,
budget release, no-paid-call-on-pre-bind-failure, audit non-suppression, `failure_class` surfacing,
the finalise race (F13), issued→paired (F14), fail-closed supersede (F12), and gap-free sequencing
(F11).

## Doc-precision corrections

Round 1 flagged wrong line counts and a budget-safety overclaim in `QR_MVP_IMPLEMENTATION.md`. Those
are superseded by this document, which is the authoritative rework record; the reworked file sizes
and the corrected budget behaviour (reserve **and** release, quality-after-bind) are described above
against the actual code.

## Test summary

- Backend: `deno test` — 260 `_shared` + 22 handler = **282 pass, 0 fail**; `deno check` +
  `deno lint` clean.
- Frontend: `vitest` — **230 pass**; `tsc --noEmit` + `vite build` clean.

## What this rework deliberately did NOT do

Merge, push, deploy, or apply the migration; run against a real phone/real Supabase; add
per-IP/per-device rate limiting beyond the existing per-user mint limit; or self-certify the result
as mergeable. The gate remains a **fresh independent QA of `c45b838`/`b01d3b0`** — see
`prompts/CLAUDE_TASK0016_PHASE_D2_QR_CAPTURE_INDEPENDENT_QA_ROUND3_2026_08_20.md`.
