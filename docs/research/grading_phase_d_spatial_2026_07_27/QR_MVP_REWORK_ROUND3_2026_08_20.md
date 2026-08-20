# TASK-0016 Phase D Stage D2 — Rework Pass 3 (2026-08-20)

**Executed by:** Claude, per `prompts/CLAUDE_TASK0016_PHASE_D2_QR_CAPTURE_REWORK_ROUND3_2026_08_20.md`,
responding to `QR_MVP_QA_REVIEW_ROUND4_2026_08_20.md`.

**Result:** backend `worktree-agent-ac9429c5f676cfd4f` @ **`ad3cd5a`** (on `5ce92ec`), frontend
`phase-d2-qr-capture-rebuild` @ **`7d09188`** (on `668a2cd`). Both must-fix items (B1, S1) and all
five should-fix items (S2, S3, L1, L2, L5) addressed. **Nothing deferred this pass.** Nothing
merged, pushed, deployed, or applied.

**Evidence class:** Repository only for the code; **Live verified (read-only)** for the `EXPLAIN`
lock-order re-check and the deployment-discipline queries.

---

## B1 (blocking) — lock-order inversion against the deployed `submit_response`

**File:** `supabase/migrations/20260819120100_bind_response_attachment_writable_guard.sql`,
lines 27-56 (new header note) and the guard block at the top of the function body.

**Was:** one statement,
`select … from app.response_versions rv join app.attempts a … where rv.id = $1 for update`, which
locks `response_versions` first and `attempts` second. The deployed `app.submit_response`
(`20260731160000_schema_baseline.sql` lines 859 and 882) locks the opposite way — `attempts`, then
`response_versions`. Reachable deadlock on exactly the race the guard exists to close.

**Now:** three statements, in `submit_response`'s order:

1. an **unlocked** `select rv.attempt_id … where rv.id = $1` — used only to decide which `attempts`
   row to lock, and re-validated in step 3;
2. `select a.status … from app.attempts a where a.id = v_attempt_id for update`;
3. `select rv.is_submitted, rv.attempt_id … where rv.id = $1 for update`, followed by a check that
   `rv.attempt_id` still equals the attempt actually locked (the RLS policy
   `response_versions_owner_update_draft` does not pin that column, so a concurrent owner re-point
   is not structurally impossible; if it happens the guard refuses rather than deciding from a
   stale lock).

The writability decision (`v_is_submitted or v_attempt_status not in ('draft','failed')`) is then
made entirely from values read under their own row locks. `app.response_attachments` is still
locked after both, which is consistent with `submit_response` (which never touches that table).

### Verification — read-only `EXPLAIN` on Development, the way Round 4 found it

`EXPLAIN` plans a statement without executing it; no lock is taken and no row is written.

**The old, inverted statement (reproducing Round 4's finding):**

```
explain (verbose, costs off)
select (rv.is_submitted = false and a.status in ('draft','failed'))
from app.response_versions rv
join app.attempts a on a.id = rv.attempt_id
where rv.id = '…'::uuid
for update;

LockRows
  Output: (…), rv.ctid, a.ctid
  ->  Nested Loop
        ->  Index Scan using response_versions_pkey on app.response_versions rv
        ->  Seq Scan on app.attempts a
```

One `LockRows` over a Nested Loop whose **outer** side is `response_versions` — `rv.ctid` precedes
`a.ctid` in the lock node's output. `response_versions` is locked first. Inversion confirmed.

**The new statements:**

```
explain (verbose, costs off) select rv.attempt_id from app.response_versions rv where rv.id = '…'::uuid;
Index Scan using response_versions_pkey on app.response_versions rv     <- no LockRows at all

explain (verbose, costs off) select a.status from app.attempts a where a.id = '…'::uuid for update;
LockRows
  ->  Seq Scan on app.attempts a                                        <- attempts only

explain (verbose, costs off) select rv.is_submitted, rv.attempt_id from app.response_versions rv where rv.id = '…'::uuid for update;
LockRows
  ->  Index Scan using response_versions_pkey on app.response_versions rv  <- response_versions only
```

Each locking statement now has exactly one `LockRows` over exactly one relation, so the acquisition
order is fixed by statement order in the function body — `attempts`, then `response_versions` —
rather than by the planner's join order. The resolve step takes no lock.

**Parity with the deployed function, checked against live Production `prosrc`:**

```
select position('from app.attempts where id = p_attempt_id for update' in prosrc)          -> 726
       position('from app.response_versions where id = p_response_version_id for update' …) -> 1745
```

`attempts` first (offset 726), `response_versions` second (1745). The guard now matches. Both of
`submit_response`'s locking statements are the same single-relation shape as the two above, so no
join-order dependence remains on either side of the pair.

---

## S1 (serious) — the new error code was mapped in only one of the two callers

| File | Line | Change |
|---|---|---|
| `supabase/functions/attempt-response/index.ts` | `mapAttachCaptureError`, ~215-240 | `response_not_writable` → **409** `response_already_submitted`; `response_not_found` → **404** `response_not_found` |
| `supabase/functions/capture-pairing/index.ts` | `mapBindError`, ~510-522 | `response_not_found` → **404** `response_not_found` (it already had `response_not_writable`) |

`response_not_writable` previously fell to `attempt-response`'s 500 default, so applying the
migration on its own would have turned a legitimate "already submitted" refusal into a server error
on the already-deployed authenticated `attach_capture` path. `response_not_found` — also newly
raised by the guard — fell to a 500 in **both** callers; it is now a 404 in both, matching every
other response-not-found answer in `attempt-response`.

**Verification:** `deno check` on both files; a new handler test
(`S1: a response version that vanishes during the bind window maps to 404, not 500`) pins the
`capture-pairing` leg end-to-end through `handleCapturePairing`. **Coverage gap, stated plainly:**
`attempt-response/index.ts` has no test file at all — it calls `Deno.serve` at module scope and
exports no handler, so importing it in a test would start a server. Its mapping is verified by
reading and by `deno check`, not by a test. Making it testable is a refactor of a deployed function
and was left out of a pass scoped at "3 files."

---

## S2 — a legitimate refusal was being reported as our bug

`handleCommit`'s new (N3) failure path took a bare boolean, so **every** submit failure was
rethrown as the generic string `capture_submit_failed` and hit `classifyCaptureError`'s deliberate
technical default: "something went wrong on our side" plus a `reportLovableError` bug entry, for
refusals that are neither our fault nor a bug. That is the failure-cause conflation DECISION-0051
exists to prevent, reintroduced on a new path.

| File | Change |
|---|---|
| `src/lib/capture-schema.ts` | new `CaptureSubmitOutcome` type; `attempt_not_submittable` and `not_found` added to the blocked set; copy added for `attempt_not_submittable`, `not_found`/`attempt_not_found`/`response_not_found`, `response_attempt_mismatch` |
| `src/lib/attempt-response-client.ts` | `InvokeResult` failure branch now carries `code`, read out of the edge function's response body (`{ "error": … }`) via the same `error.context.json()` extraction `review.functions.ts` already uses |
| `src/hooks/use-session.ts` | `submitCapturedResponse` returns `CaptureSubmitOutcome` instead of `boolean` |
| `src/components/session/CaptureItem.tsx` | `onSubmitted` accepts the outcome shape; `handleCommit` rethrows the real code |

Worth recording: the blocked set was **missing the codes `attempt-response` actually returns**.
It had `attempt_not_editable` (a `capture-pairing` code) but not `attempt_not_submittable` or
`not_found`, so the exact refusals S2 is about would still have classified as technical even with
the code plumbed through. `idempotency_conflict` is deliberately left technical: with S3's cached
key the same key can only ever be replayed with the same payload, so a conflict really is a fault
on our side.

A bare `false` still means "failed, cause unknown" and correctly stays technical, as does the
`submit_failed` fallback used when a failure carries no code at all (network layer, non-JSON body).

---

## S3 — a retry after a lost submit wasn't idempotent

The key was minted **inside** `submitCapturedResponse`, so a retry after a lost response was a new
logical request. If the first submit had committed before the connection dropped, the retry either
double-submitted or came back `response_already_submitted` — an error screen for an answer that had
already gone through.

`src/lib/attempt-response-client.ts` now exports `makeCaptureSubmitKeyCache()`, a single-slot cache
keyed by (attempt, response version) with an explicit `clear()`. `use-session.ts` holds one in a
ref, uses `keyFor(slot)` for the submit, and clears it on confirmed success and whenever the
capture slot retires (`moveOn`). Extracted as a pure factory because this repo's frontend test setup
has **no renderer** (no `@testing-library/react`, no jsdom/happy-dom), so hook-level tests are not
possible here — the same limitation Round 4 recorded as L7. Four unit tests pin the rule: same slot
replays the same key; a different response version mints a new one; `clear()` forces a new one;
default keys are unique.

---

## L1, L2, L5

- **L1** — the two best-effort `capture_quality_state` annotation writes in
  `capture-pairing/index.ts` discarded their errors entirely. They stay best-effort (N2: the
  verdict, not the write, decides `keepOpen`) but now log
  `capture_pairing_quality_annotation_failed`. The existing N2 test exercises the new log line.
- **L2** — `capture_digest_mismatch` and `unsupported_media_type` are both in
  `RETRYABLE_CAPTURE_CODES` but had no `messageForBlockedCode` case, so they showed "start a new
  capture on your computer" on a screen whose own button retakes the photo. Both now have copy, and
  a new test asserts no retryable code's copy contains "on your computer" while every one mentions
  "photo".
- **L5** — `QR_MVP_IMPLEMENTATION.md`'s superseded notice said "seven callable"; the migration
  defines seven functions, **five callable** (`append_capture_pairing_event`,
  `claim_capture_pairing_upload`, `consume_capture_pairing`, `record_capture_upload`,
  `expire_capture_pairing_tokens`) and **two trigger functions**
  (`capture_pairing_tokens_guard_immutable_fields`, `capture_pairing_events_guard_append_only`),
  now named individually. `QR_MVP_REWORK_ROUND2_2026_08_20.md`'s "deno lint clean" claim is now
  scoped to changed files, with the 5 pre-existing `no-unused-vars` in `_shared/math-verifier.ts`
  named as unrelated.

## Explicitly out of scope this pass

Everything Round 3 deferred (N5, N9, N10, N12, N13, the F13 orphan gap) plus Round 4's L3, L4, L6,
L7 — per the prompt. Untouched.

One thing noticed but **not** changed: the `error` phase still offers "Take a new photo" even for a
refusal a new photo cannot fix (e.g. `response_already_submitted`). The copy is now correct, and
retaking would fail cleanly at the bind with the same 409, so this is cosmetic — closely related to
Round 4's L3, which was explicitly deferred. Flagging it rather than widening the diff.

## Test summary

- Backend: `deno test --allow-net --allow-env supabase/functions` — **297 pass, 0 fail**. The same
  command on the parent commit `5ce92ec` gives **295** (verified by stashing the diff), so the two
  new tests are additive with no regressions. Component counts: `_shared` **260** (unchanged),
  `capture-pairing` handler **30 → 32**. `deno check` clean on
  `capture-pairing/index.ts`, `capture-pairing/index_test.ts`, `attempt-response/index.ts`;
  `deno lint` clean on the changed files (5 pre-existing `no-unused-vars` in
  `_shared/math-verifier.ts` remain, unrelated).
- Frontend: `vitest run` — **239 pass / 0 fail, 24 files** (was 232). `tsc --noEmit` clean;
  `vite build` clean. The changed `src/lib/*` files are `eslint`/prettier-clean; the pre-existing
  prettier noncompliance in `use-session.ts`, `CaptureItem.tsx`, and the test file was left alone
  rather than reformatted, since prettier is not this repo's enforced gate and a reformat would
  bury the actual change.

## Deployment discipline

Maintained. No merge, no push, no PR, no Lovable publish, no edge-function deploy, no migration
applied, no live row or storage object written. The only live interaction was read-only: the
`EXPLAIN` plans above (which do not execute) and these verification queries, run on **both**
projects:

- `bind_response_attachment` `md5(prosrc)` = `d7848572d06d246340d0b4a94fd892d3` on Dev **and**
  Prod, identical to each other and unchanged; `position('response_not_writable' in prosrc)` = 0 on
  both, i.e. the new guard is not live anywhere.
- `select count(*) from supabase_migrations.schema_migrations where version in ('20260819120000','20260819120100')` = **0** on both projects.

## Next step

**Round 5 independent QA.** This pass is not self-certified as mergeable — three consecutive
independent reviews have held this feature, and that is the practice here, not a formality to skip
because a pass feels clean.
