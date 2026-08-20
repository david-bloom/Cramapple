# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Independent QA Review (Round 5)

Repo: `Cramapple` (backend, branch `worktree-agent-ac9429c5f676cfd4f`, worktree
`.claude/worktrees/agent-ac9429c5f676cfd4f`) and `exam-buddy-wireframe` (frontend, branch
`phase-d2-qr-capture-rebuild`). If a branch isn't checked out, use `git show`/`git diff` against
the commit rather than requiring a checkout.

## What this is

An **independent QA review** of **rework pass 3** of TASK-0016 Phase D Stage D2 (QR hand-drawn
capture MVP). Lineage: Round 1 QA (6 blocking + 8 serious) → rework 1 (all 15 fixed) → Round 3 QA
(4 must + 5 should) → rework 2 (all 9 addressed) → **Round 4 QA found one real blocker (B1, a
lock-order deadlock in the shared `bind_response_attachment` function) + one serious gap (S1, an
unmapped error code) + smaller items (S2, S3, L1, L2, L5)** → **rework pass 3 (this)**, which
claims to fix all seven.

**Reviewed commits:** backend `ad3cd5a` (on `5ce92ec`), frontend `7d09188` (on `668a2cd`).
**Do not trust the rework session's own account** — `QR_MVP_REWORK_ROUND3_2026_08_20.md` is a
claim to verify against code and, where it asserts things about live Production/Development,
against fresh read-only queries of your own.

You are a reviewer, not an implementer. **Do not write or fix code. Do not merge, push, deploy,
apply either migration, or mutate any database** beyond read-only verification queries.
Do not use the Monitor tool or any background-wait pattern on your own work — use synchronous
Bash with explicit timeouts.

## Read first

1. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_ROUND4_2026_08_20.md` — the
   findings this pass responds to (B1, S1, S2, S3, L1, L2, L5). Your primary checklist.
2. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_REWORK_ROUND3_2026_08_20.md` — the
   rework's own account, including its own `EXPLAIN` evidence for B1. Verify the evidence yourself
   — rerun the same `EXPLAIN` queries independently rather than trusting the pasted plans.
3. `DECISIONS_AND_BLOCKERS.md` item 8 and `CURRENT_STATE.md` — confirm the commit pointers are
   accurate.
4. The diffs, not the prose:
   - Backend: `git diff 5ce92ec ad3cd5a` — the rewritten lock-acquisition sequence in
     `20260819120100_bind_response_attachment_writable_guard.sql`, the new `mapAttachCaptureError`
     cases in `attempt-response/index.ts`, `mapBindError`'s `response_not_found` addition in
     `capture-pairing/index.ts`, and the new/changed tests.
   - Frontend: `git diff 668a2cd 7d09188` — `capture-schema.ts` (`CaptureSubmitOutcome`, the
     expanded blocked-code set, new copy), `attempt-response-client.ts` (`InvokeResult` carrying
     `code`, `makeCaptureSubmitKeyCache`), `use-session.ts` (outcome plumbing + key-cache usage),
     `CaptureItem.tsx` (rethrow of the real code).
5. `docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`'s QA section — the methodology
   convention (independent finder angles, deduped, each candidate re-verified).

## Part A — Verify each claimed fix

For B1, S1, S2, S3, L1, L2, L5: FIXED / NOT FIXED / PARTIAL / REGRESSED, with a concrete citation
and the scenario you traced.

- **B1 (highest priority — re-derive independently, don't just re-read the pasted `EXPLAIN`
  output):** run your own `EXPLAIN (verbose, costs off)` against Development for (a) the new
  3-statement lock sequence in `bind_response_attachment` and (b) the deployed `submit_response`,
  and confirm the acquisition order now genuinely matches (`attempts` before
  `response_versions` on both). Also reason about the new **unlocked pre-resolve + re-check**
  step the rework added (`select rv.attempt_id` before locking, then re-validating it after both
  locks are held) — is the re-check actually sufficient to catch every case where a concurrent
  write could have moved `attempt_id` between the unlocked read and the locks landing? Consider
  whether the three separate statements (vs. the original single joined one) introduce their own
  new race (e.g. the attempt or response-version row disappearing/changing between statement 1's
  read and statement 2's lock).
- **S1:** confirm `mapAttachCaptureError` now returns 409/404 for `response_not_writable`/
  `response_not_found`, and that `capture-pairing`'s own `mapBindError` covers `response_not_found`
  too. The rework doc admits a real gap — `attempt-response/index.ts` has no test coverage for this
  mapping (it calls `Deno.serve` at module scope, exports no handler). Assess whether that gap is
  acceptable as stated, or whether there's a lower-cost way to verify it than the rework dismissed
  (e.g. extracting just the mapping function for a unit test, without touching the deployed
  server-bootstrap code).
- **S2:** trace a real refusal (e.g. `attempt_not_submittable`) end-to-end from the edge function's
  JSON error body through `InvokeResult`, into `CaptureSubmitOutcome`, into `handleCommit`'s catch,
  into `classifyCaptureError` — does it actually land on non-technical copy now? Check the rework's
  own claim that the blocked set was previously missing codes `attempt-response` actually returns —
  is the set now complete, or are there still gaps (any error code the backend can return that
  isn't in `RETRYABLE_CAPTURE_CODES` or the blocked set)?
- **S3:** confirm the key cache is genuinely keyed per (attempt, response version), is cleared on
  confirmed success and slot retirement, and — importantly — is NOT cleared in a way that would
  let a stale key leak into a different logical request (e.g. does clearing happen too early, so a
  fresh submit after a fast retire could collide with an in-flight retry of the old one?).
- **L1, L2, L5:** quick verification each — log line present and reachable, copy present for both
  previously-uncovered codes, doc corrections accurate.

## Part B — Independent, open-ended re-review of the new/changed surface

1. **The rewritten `bind_response_attachment` guard is still the highest-blast-radius surface in
   this whole feature** — it's a shared, already-deployed function. Re-derive its full correctness
   fresh: does the three-statement sequence still correctly implement the original writability
   predicate (`is_submitted = false and status in ('draft','failed')`)? Any new deadlock potential
   between the *new* statements themselves under concurrent binds (e.g. two simultaneous captures
   for the same attempt)? Confirm `create or replace` compatibility again (signature/grants/
   security definer/search_path) against fresh live Production/Dev queries — don't assume Round 4's
   check still holds without re-verifying, since the function body changed again this pass.
2. **Error-code completeness, both directions.** Enumerate every error code either
   `capture-pairing` or `attempt-response` can actually return on the capture path, and check each
   is classified (retryable/blocked/technical) somewhere on the frontend with no silent fallthrough
   gap — this is exactly the class of bug S2 was about, so check it wasn't just patched at the two
   named codes while missing a third.
3. **The frontend outcome-type refactor** (`CaptureSubmitOutcome` threading through 4 files) —
   check for a codepath where the old `boolean` assumption might linger (e.g. a truthy/falsy check
   on the outcome object itself instead of `.ok`), which would silently misclassify every outcome.
4. **Regression check** — spot-check that Round 4's "verified correct" items (single-use CAS,
   cross-user denial, RLS, the `describe→paired` transition, and everything Round 3's rework
   didn't touch) still hold after this pass touched the same function again.
5. **Test quality** — do the new tests for B1/S1/S2/S3 actually exercise the fixed behavior, or
   are they shaped to pass regardless (tautological, or testing the wrong layer)?

## Deployment/mutation discipline (verify independently)

Confirm: neither `ad3cd5a` nor `7d09188` is on any remote; migrations `20260819120000` AND
`20260819120100` are applied to neither Dev (`wmgjsdkphcyhngaffbqf`) nor Prod
(`pcntajvbdfqhbeewmdry`); no `capture-pairing` edge function deployed to either; and —
since this pass touched the shared function's SQL again — that live `bind_response_attachment` is
still unchanged on both projects (fresh `md5(prosrc)` check, don't reuse Round 4's cached value).

## Output

Use `ReportFindings` if available; else a structured list, most severe first, each with file/line,
a concrete failure scenario, and a verdict. Then explicitly:
1. Disposition of B1, S1, S2, S3, L1, L2, L5.
2. Any new findings, tiered (blocking / serious / lower).
3. Bottom line: **merge as-is**, **merge with minor fixes**, or **hold for further rework** — and
   if it clears, show your work (what you tried hardest to break and could not), the same
   discipline every prior round used. This feature has now been through 4 rounds of rework and
   would be entering its 5th independent review — a clean verdict here should be earned, not
   assumed just because the trend has been improving.
