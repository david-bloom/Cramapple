# TASK-0016 Phase D Stage D2 — Independent QA Review, Round 3 (2026-08-20)

**Reviewed:** backend `c45b838` (branch `worktree-agent-ac9429c5f676cfd4f`, worktree
`.claude/worktrees/agent-ac9429c5f676cfd4f`) and frontend `b01d3b0` (branch
`phase-d2-qr-capture-rebuild`, `exam-buddy-wireframe`) — the Round-2 rework of all 15 findings
from `QR_MVP_QA_REVIEW_2026_08_19.md` (Round 1). Neither merged, pushed, or deployed.

**Method:** read the full reworked `capture-pairing/index.ts` (1,644 lines), the full migration
`20260819120000_capture_pairing.sql` (498 lines), the full new `index_test.ts` (1,049 lines) +
`_test_setup.ts`, the frontend diff, and the unchanged `_shared/capture-pairing.ts`/
`capture-quality-check.ts`. Re-ran all suites. Queried **live Production Postgres (read-only)**
to check the rework's claims against the real `audit_events` schema, the real
`reserve_model_usage`/`complete_model_usage` bodies, and the real `bind_response_attachment` body
— several claims depend on these and the test fake doesn't model them. Wrote one throwaway probe
test in the scratchpad only (no repo mutation) to drive the handler through a full 7-retake
cycle, which empirically confirmed finding N1.

## Bottom line: HOLD FOR FURTHER REWORK — close, not a redesign

All 6 blocking Round-1 findings are genuinely fixed and held up under adversarial re-testing. But
two fixes are only *conditionally* correct, and the F9 fix (double-submit guard) introduced a new
dead end of the same shape Round 1 exists to eliminate.

---

## 1. Disposition of every Round-1 finding

### Blocking (F1–F6): all FIXED

**F1 (blurry-photo retake dead end) — FIXED, with two conditional holes (N1, N2, N11).** Traced
end to end: `record_capture_upload` records the bound attachment/verdict under the same CAS as
consume but leaves `state='uploaded'`, which `evaluatePairingUsability` treats as live. `keepOpen`
selects record vs. consume based on the quality verdict. Phone-side retake mints a fresh upload
path and resubmits. Probe-confirmed working for attempts 1–4. The same-path idempotency
short-circuit cannot return another capability's data (guarded by folder-path identity) and
cannot mask a genuine retake (attempts counter always increments).

**F3 (budget leak) — FIXED, confirmed against live Prod SQL.** `complete_model_usage` fires
whenever a reservation was actually taken; traced every branch of `runCaptureQualityCheck` and
confirmed it never throws between reserve and complete. Verified against live Production that the
release call's parameters and matching key (`request_id`+`request_hash`) actually resolve the
reservation, not silently no-op.

**F4 (unbounded paid calls) — FIXED.** Quality call is strictly after the bind; every pre-bind
refusal returns before any spend (test-asserted and traced). Paid calls now bounded to ≤4 per
capability in practice.

**F5 (audit drops rows / fabricated incident_id) — FIXED.** `logAuditEvent` now uses the
generated audit-event id as `request_id` (moving the client key to metadata) and returns `null`
on insert failure; every caller now surfaces `null` correctly. Verified against live Production
schema that every field written exists and satisfies all NOT NULL constraints.

**F6 (dead SQL bookkeeping) — FIXED.** `claim_capture_pairing_upload` now returns the updated row
for terminal transitions instead of raising; `state='rejected'` is reachable (probe-confirmed).
Not covered by any test (see N8).

**F7 (cascade / erasure trap) — FIXED as scoped; stated rationale not achieved (N12).** The
`capture_pairing_events` guard fix is correct (cascade now works, direct deletes still blocked).
But verified on live Production that `response_attachments_guard_immutable` still unconditionally
blocks DELETE on the table one level up, so parent-attempt deletion still fails overall — the
rework doc's claim that this is now possible is not true. Pre-existing gap, not introduced here,
but the doc overstates the fix's effect.

### Serious/non-blocking (F8–F15)

- **F8 (desktop failure split) — PARTIALLY FIXED.** Real `failure_class` column + wire contract
  end to end for quality-check technical failures. But sign-upload and bind failures never
  persist `failure_class` to the token, so the desktop still can't distinguish those two technical
  failure sources from a generic state (N6).
- **F9 (double-submit guard) — FIXED, but traded for a new dead end.** The guard itself works;
  `committedRef`/`committing` are never cleared on failure, permanently locking every control if
  submit fails (N3).
- **F10 (HEIC dead end) — PARTIALLY FIXED.** Client-side HEIC detection now routes to a retryable
  screen. Six other server-side validation refusals still hit the buttonless `blocked` screen
  (N4).
- **F11 (unlocked provenance sequence) — FIXED in SQL** (real row lock + max+1 + JSON patch), but
  **unverified by the test suite** — the fake still uses the pre-fix count-based logic (N8).
- **F12 (multi-slot supersede) — FIXED (fails closed)**, but the frontend has no way to supply the
  now-required `replaces_attachment_id` for a non-default slot, so that path is now a guaranteed
  hard failure rather than a mitigated one (N5). Latent — frontend hardcodes `"slot-1"`.
- **F13 (bind/consume race) — PARTIALLY FIXED.** Error reporting is genuinely fixed (accurate
  terminal reason + audit on a finalize-race). The orphan-attachment half is not fixed, only
  better explained — an attachment can still bind while `bound_attachment_id` stays null on the
  token. Currently latent since `evaluate-attempt` doesn't read `response_attachments` at all.
- **F14 (phone-connected detection) — FIXED.** Real, safe, idempotent state transition. One new
  side effect: the `FALLBACK_DIRECT` access-path value is now permanently unreachable (N9, cosmetic).
- **F15 (no request-handling tests) — FIXED, with real fidelity gaps.** 22 new handler tests are a
  genuine improvement (cross-user denial, storage-path guard, budget release all now tested) but
  the in-memory fake doesn't faithfully model everything it claims to cover (N8).

### Round-1 lower-severity list — mostly not fixed (acknowledged out of scope by the rework except the last)

`OPENAI_DAILY_CAP_USD` silent no-op (now also gates the F1 fix — see N11); `generation` field
reset; desktop thumbnail dying after 120s; the self-healing poll/retake race; dead
`hand-drawn-pilot.tsx` code on nonexistent fields; no retention/purge policy; doc-precision errors
(N14). The `human_review_pending`-with-nothing-to-resolve-it product-decision gap remains
unaddressed.

**Prior `attach_capture` QA findings: none reintroduced** — the reused surface
(`_shared/capture-attachment.ts`/`storage-paths.ts`) was untouched by the rework.

---

## 2. New findings from the open-ended re-review

### Serious, non-blocking

**N1 — Redemption-budget off-by-one: the 5th photo uploads, then gets refused.** Two guards check
the attempt limit at different points (before vs. after increment). Empirically confirmed via a
live 7-retake probe cycle: attempts 1-4 work, attempt 5 uploads successfully then the submit
returns `409 pairing_attempts_exhausted` — the bytes are already orphaned in storage.
`PAIRING_MAX_REDEMPTION_ATTEMPTS = 5` effectively means 4. Newly reachable because F1's fix makes
multiple attempts possible at all. One-line fix, but the two guards must agree.

**N2 — `keepOpen` is derived from persisted attachment state, not the verdict.** If the
`response_attachments.capture_quality_state` DB update fails, `keepOpen` silently reverts to
Round-1's F1 dead end (consumes the capability) while `failure_class` still says
`'image_quality'` — telling the student to retake over an already-consumed token.

**N3 — `handleCommit` permanently locks every control on submit failure (introduced by the F9
fix).** The synchronous double-submit guard works, but `committedRef`/`committing` are never
cleared and `onSubmitted` is fire-and-forget with no error channel back. Any submit failure —
network error, `attempt_not_editable`, a grading error — leaves the student on a disabled
"Submitting…" with no retake, no cancel, no error message. Same failure shape as Round-1 F2.

**N4 — F10's dead end survives for six other retryable server-side validation failures**
(`capture_too_large`, `capture_dimensions_invalid`, `capture_object_changed`, etc.) — all still
route to the buttonless `blocked` screen, whose own copy literally says "take a new photo" with
no way to do so.

**N6 — the DECISION-0051 desktop split covers only one of three technical-failure sources.**
`failure_class` is only ever persisted at finalise; sign-upload failures (502) and bind failures
(500) return the classification to the phone but never persist it, so the desktop can't render
the correct screen for those two paths.

**N7 — the "open capability can't corrupt a submitted response" safety claim isn't
database-enforced.** Verified against live Production: `bind_response_attachment` has no
`is_submitted` check at all — only lineage checks under a row lock. The guarantee rests entirely
on an edge-function-level check with a multi-second race window (download + validate + storage
checks + the quality call all sit between the check and the bind). Currently latent since Engine
4 is shadow-only and `evaluate-attempt` doesn't read `response_attachments`, but the code comment
claims a guarantee the schema doesn't actually provide.

**N8 — test-fake fidelity gaps.** The fake is honest about several important things (real
budget/ledger arithmetic, real uniqueness constraints on audit events and provenance sequences,
real bind lineage errors) but: `append_capture_pairing_event`'s fake still uses the *pre-fix*
unlocked-count sequence logic, so F11's actual fix (row-locked max+1) is unverified by the suite;
no test exercises the F6 caller branches (`expired`/`rejected` returns) or the same-path
idempotency short-circuit; the fake has no unique indexes on `capture_pairing_tokens`; the fake
`bind_response_attachment` has no `is_submitted` guard (same gap as N7) and no storage-path
uniqueness; `storage.list` returns a constant eTag so the TOCTOU fingerprint guard can never trip
in tests. Net a real improvement over Round 1's zero request-handling coverage, but two of the
specifically-claimed fixes (F6, F11) aren't actually pinned by it.

**N11 — the F1 fix silently doesn't exist if the quality-check budget is unset or exhausted.**
`CAPTURE_QUALITY_DAILY_CAP_USD` defaults to 0 when `OPENAI_DAILY_CAP_USD` is unset, making the
quality check unconditionally "unavailable," which makes `keepOpen` always false — every capture
reverts to consume-on-first-submit with no signal. Round 1 already flagged this config landmine;
it's now load-bearing for a blocking-finding fix, not just a degraded feature.

### Lower severity

- **N5** — F12's fail-closed leaves multi-slot retakes unrecoverable (latent, frontend hardcodes
  `"slot-1"`); the `"slot-1"` string is duplicated with no shared constant.
- **N9** — `FALLBACK_DIRECT` access-path value is now permanently unreachable (cosmetic, an
  artifact of the F14 fix).
- **N10** — attempts-exhausted returns two different error codes depending on which call flips
  the state vs. which comes after (same copy either way — cosmetic, but will confuse log analysis).
- **N12** — F7's erasure trap is not actually cleared one level up (`response_attachments`'
  immutability guard still blocks all parent deletes) — pre-existing, but both the migration
  comment and the rework doc assert it's closed.
- **N13** — the idempotency short-circuit trusts storage-path identity, not the object's digest;
  if a signed-upload token were ever replayable, a second PUT of different bytes to the same path
  could return a stale verdict with no detection.
- **N14** — `QR_MVP_IMPLEMENTATION.md` was never touched by either rework commit and still has
  stale line counts (e.g. claims 1,100 lines for a now-1,644-line file) and a "three functions"
  claim (now five) — the second review in a row handed stale claims from this doc.

### Verified NOT broken — things actively tried and could not break

Token replay and single-use-under-concurrency (the CAS survives the new record/consume split);
cross-user access (re-checked at both claim and submit); service-role leakage; wrong-slot/
cross-capability submission (folder-path check); the immutability trigger; RLS (both new tables,
zero policies, service-role-only grants, pinned `search_path`); the `describe_capture` state
mutation (CAS-guarded, needs a valid 256-bit handle, no cross-user effect); the derived-copy
step's interaction with the moved quality call; the TOCTOU fingerprint guard under the new
ordering.

---

## 3. Deployment/mutation discipline — verified clean

`gh api` confirms neither `c45b838` nor `b01d3b0` exists on either GitHub remote (HTTP 422, no
commit found). Live read-only Supabase queries confirm the migration is applied to neither Dev
(`wmgjsdkphcyhngaffbqf`) nor Production (`pcntajvbdfqhbeewmdry`) — zero matching tables/functions
in `information_schema`/`pg_proc` on either project — and no `capture-pairing` edge function is
deployed to either (Dev 14 functions, Prod 15, neither list includes it). Test counts reproduce
exactly: backend 260 `_shared` + 22 handler = 282/282 pass, `deno check`/`lint` clean; frontend
230/230 vitest pass. No repository state was mutated by this review (one incidental
`routeTree.gen.ts` regeneration from running `vitest` was reverted via `git checkout --`).

---

## 4. Recommendation

**Hold for further rework — one more short pass, not a redesign.**

**Must fix before merge:** N1, N2, N3, N4.
**Should fix or explicitly accept and record:** N11, N6, N7, N8, N14.
**Acceptable to defer with a recorded note:** N5, N9, N10, N12, N13, the F13 orphan-attachment
gap (latent while `evaluate-attempt` ignores `response_attachments`), and the Round-1
lower-severity list — but the `human_review_pending`-with-nothing-to-resolve-it product question
should be settled before any real student can reach this flow, since nothing in this rework
changed it.
