# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Independent QA Review (Round 4)

Repo: `Cramapple` (backend, this checkout; branch `worktree-agent-ac9429c5f676cfd4f`, worktree
`.claude/worktrees/agent-ac9429c5f676cfd4f`) and `exam-buddy-wireframe` (frontend, branch
`phase-d2-qr-capture-rebuild`). If a branch isn't checked out, use `git show`/`git diff` against the
commit rather than requiring a checkout.

## What this is

An **independent QA review** of **rework pass 2** of TASK-0016 Phase D Stage D2 (the QR hand-drawn
capture MVP). Lineage: Round 1 QA (6 blocking + 8 serious) → rework pass 1 (fixed all 15) → Round 3
QA (all 15 confirmed fixed, but found 4 must-fix + 5 recommended, "close not a redesign") → **rework
pass 2 (this)**, which claims to fix N1–N4 (must) and N6, N7, N8, N11, N14 (recommended).

**Reviewed commits:** backend `5ce92ec`, frontend `668a2cd`. **Do not trust the rework session's
own account** — `QR_MVP_REWORK_ROUND2_2026_08_20.md` is a claim to verify against code and (where
it asserts things about live Production) against read-only Production queries.

You are a reviewer, not an implementer. **Do not write or fix code. Do not merge, push, deploy,
apply either migration, or mutate any database** beyond read-only verification queries. (Do not use
the Monitor tool or any background-wait pattern on your own work — use synchronous Bash with
explicit timeouts.)

## Read first

1. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_ROUND3_2026_08_20.md` — the
   Round-3 findings (N1–N14) this pass responds to. Your primary checklist.
2. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_REWORK_ROUND2_2026_08_20.md` — the rework
   pass-2 account. Verify each claim against code.
3. `DECISIONS_AND_BLOCKERS.md` item 8 and `CURRENT_STATE.md` — the running disposition; confirm the
   commit pointers are accurate.
4. The diffs, not the prose about them:
   - Backend: `git diff c45b838 5ce92ec` (the `_shared/capture-pairing.ts` `>`/`>=` change and its
     test; the `index.ts` verdict/keepOpen/N6/N11 changes; the NEW migration
     `20260819120100_bind_response_attachment_writable_guard.sql`; the `index_test.ts` fake +
     new tests; the `QR_MVP_IMPLEMENTATION.md` banner).
   - Frontend: `git diff b01d3b0 668a2cd` (`CaptureItem.tsx`, `SessionFrame.tsx`, `capture-schema.ts`,
     `capture-phone.tsx`, `capture-contract.test.ts`).

## Part A — Verify each Round-3 finding this pass claims to fix

For N1, N2, N3, N4, N6, N7, N8, N11, N14: FIXED / NOT FIXED / PARTIAL / REGRESSED, with a concrete
citation and the scenario you traced. Specifically:

- **N1:** does the submit gate now agree with the claim gate across the whole 1..max range? Re-derive
  the boundary (the max-th photo must upload AND submit; the (max+1)th must be refused at claim,
  before any upload). Confirm no new path lets `redemption_attempts` exceed `max`.
- **N2:** is `keepOpen` now independent of the annotation write succeeding? Trace the `unavailable`
  path too — does it still correctly consume (no verdict → no retake)? Does a failed annotation
  leave the token's authoritative `capture_quality_state` correct?
- **N3:** does a submit failure actually reach `handleCommit`'s catch? Verify `submitCapturedResponse`
  resolves `false` (not throws-and-swallows) on a non-ok submit and that `SessionFrame` now returns
  that promise. Is there any success path where the guard is wrongly cleared (re-enabling a
  double-submit)?
- **N4:** confirm the retryable set routes to a screen with a working retake button, and that
  dead-capability codes (expired/used/cancelled/attempts-exhausted/response-submitted) correctly
  stay non-retryable. Any code miscategorised either way?
- **N6:** does the desktop now render a technical screen for sign-upload/bind failures (no bound
  attachment)? Is the "use this photo" button correctly suppressed when there's no attachment? Does
  `failure_class` get cleared on a subsequent successful retake so it doesn't stick?
- **N7 (highest-risk change — a SHARED, deployed function):** re-read the new
  `20260819120100` migration against `20260818011720`'s body — is it verbatim except the guard?
  Confirm against **live Production** (read-only) that today's `bind_response_attachment` still has
  no such check (so this is a real change, correctly scoped) and that grants are exactly
  `service_role`. Then reason about the OTHER caller — the authenticated `attach_capture` path in
  `attempt-response`: does adding this guard break any legitimate attach_capture flow, or is it a
  safe strengthening? Check the lock ordering (response_versions/attempts then response_attachments)
  for deadlock risk, and that `response_not_writable` maps cleanly for both callers.
- **N8:** does the fake now actually pin the claimed fixes — is `append`'s sequence max+1 (with a
  gap test that would fail under count+1), and are the F6 branches / idempotency / N7 guard genuinely
  exercised? Are there remaining fidelity gaps that let a real regression pass green?
- **N11:** is the misconfiguration now visible without being noisy or leaking PII? Is the recorded
  "accept-as-is when unavailable" reasoning actually sound?
- **N14:** do the doc's corrected numbers match the code now?

## Part B — Independent re-review of the new/changed surface

1. **The `bind_response_attachment` change is the biggest blast radius in this pass** — it changes a
   function the whole `attach_capture` path depends on. Give it a full independent pass: correctness
   of the writability predicate, the `for update` lock, error propagation to both callers, and
   whether any existing test or flow binds to a legitimately non-draft attempt.
2. **The `>`/`>=` budget change** — walk the full claim→upload→submit sequence for attempts 1..6 and
   confirm no orphaned-bytes case and no over-budget case remains.
3. **The verdict-derived keepOpen refactor** — confirm the ACCEPT/RETAKE/HUMAN_REVIEW/technical/
   unavailable matrix still maps to the right {consume|record, failure_class, screen} on both legs.
4. **N3's async commit** — any new double-invocation, lost-error, or stuck-spinner path.
5. **Regression check:** re-verify a sample of what Round 3 confirmed NOT broken (single-use CAS,
   cross-user denial, TOCTOU guard, RLS, the describe→paired transition) still holds after this pass.
6. **The deferred items (N5, N9, N10, N12, N13, F13 orphan):** confirm they're genuinely still just
   latent/cosmetic and this pass didn't make any of them load-bearing.

## Deployment/mutation discipline (verify independently)

Confirm: neither `5ce92ec` nor `668a2cd` is on any remote; migrations `20260819120000` AND
`20260819120100` are applied to neither Dev (`wmgjsdkphcyhngaffbqf`) nor Prod
(`pcntajvbdfqhbeewmdry`); no `capture-pairing` edge function deployed; and — because N7 touched a
shared function — that live `bind_response_attachment` is UNCHANGED on both projects. State how you
verified each.

## Output

Use `ReportFindings` if available; else a structured list, most severe first, each with file/line, a
concrete failure scenario, and a verdict. Then explicitly:
1. Disposition of N1–N4, N6, N7, N8, N11, N14.
2. Any new findings, tiered (blocking / serious / lower).
3. Bottom line: **merge as-is**, **merge with minor fixes**, or **hold for further rework** — and if
   holding, exactly what's left. If it clears, show your work: which fixes and which new-code paths
   (especially the shared-function change) you tried hardest to break and could not.
