# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Independent QA Review (Round 3)

Repo: `Cramapple` (backend, this checkout) and `exam-buddy-wireframe` (frontend, at
`/Users/davidbloom/Documents/exam-buddy-wireframe`). The frontend rework branch may be checked out
in a scratchpad worktree rather than the main checkout; if `git worktree list` in the frontend repo
doesn't show it, use `git show <commit>:<path>` / `git diff` against the branch directly rather than
requiring a checkout.

## What this is

An **independent QA review** of the **rework** of TASK-0016 Phase D Stage D2 (the QR hand-drawn
capture MVP — the bridge that lets the unauthenticated, QR-paired phone leg submit a photo into the
existing `attach_capture`/`app.response_attachments` pipeline).

Lineage: **Round 1** (2026-08-19, `QR_MVP_QA_REVIEW_2026_08_19.md`) reviewed `768b1bb`/`6dd89ff`
and returned HOLD FOR REWORK — 6 blocking findings, 8 serious-non-blocking, several lower-severity.
A **Round-2** session (2026-08-20) first established that no rework had actually been done, then
executed one: it claims **all 15 findings are fixed**, on reworked commits **`c45b838` (backend)**
and **`b01d3b0` (frontend)**, documented in `QR_MVP_REWORK_2026_08_20.md`.

**Your job is to verify those fixes actually work, and to independently re-review the whole surface
— especially the substantial NEW code the rework introduced — for anything the fixes broke or
newly exposed. Do not trust the rework session's own account** (`QR_MVP_REWORK_2026_08_20.md` is a
claim to verify, not evidence).

You are a reviewer, not an implementer. **Do not write or fix any code.** Do not deploy anything,
push anything, apply the migration, or mutate any live database — this review is read/analysis only.

## Read first, in this order

1. `docs/activity_log/DECISIONS_LOG.md` — `DECISION-0051` and `DECISION-0050` in full. These are
   the product mandate: QR handoff is Engine 4's sole capture path (no direct-upload fallback),
   System A's frontend reuses System B's `attach_capture`/`app.response_attachments` backend, and
   capture failures split into generic-retake-copy (image-quality) vs. bug-logged (technical).
2. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_2026_08_19.md` — **the full
   Round 1 findings**, all 15+. This is your primary checklist: for each, determine fixed / not
   fixed / partially fixed / regressed against the ACTUAL reworked code, with a concrete citation.
3. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_REWORK_2026_08_20.md` — the rework's own
   per-finding account. Read it to know what to check, then **verify each claim against code** —
   confirm the cited functions/columns/branches exist and do what's claimed, and that the fix
   doesn't just move the problem.
4. `docs/research/grading_phase_d_spatial_2026_07_27/{CURRENT_STATE.md,DECISIONS_AND_BLOCKERS.md}`
   item 8 — verify the pointer is accurate (the referenced commits exist and contain what's
   claimed), rather than assuming it's current.
5. The actual diffs, not the docs' description of them:
   - Backend: `git diff 768b1bb c45b838 -- supabase/functions/capture-pairing supabase/migrations`
     (the full reworked `capture-pairing/index.ts`, the migration
     `20260819120000_capture_pairing.sql`, and the new `capture-pairing/index_test.ts` +
     `_test_setup.ts`).
   - Frontend: `git diff 6dd89ff b01d3b0` in `exam-buddy-wireframe` (`CaptureItem.tsx`,
     `capture-phone.tsx`, `capture-schema.ts`, `capture-contract.test.ts`).
6. `docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`'s "QA Review" section — the
   methodology this program uses (multiple independent finder angles, deduped, each candidate
   independently re-verified before being reported CONFIRMED), and the 8 prior `attach_capture`
   findings the bridge reuses — confirm none were reintroduced by the rework.

## Review structure

### Part A — Verify all 15 Round-1 findings, one at a time

For each Round-1 finding (6 blocking, 8 serious-non-blocking, and the lower-severity list),
re-derive independently whether it is actually fixed in `c45b838`/`b01d3b0`. Report each as
**FIXED (confirmed)** / **NOT FIXED** / **PARTIALLY FIXED** / **REGRESSED**, with the exact
file/line and the specific scenario you traced. Trace the real state machine and SQL, not a comment
or the rework doc claiming it works. In particular:

- **F1 (retake dead end):** does a quality-rejected capture now leave the token in a state a genuine
  in-place retake can use? Trace `record_capture_upload` vs `consume_capture_pairing`, the
  `keepOpen` decision, and the same-path idempotency short-circuit. Can the short-circuit ever
  return another capability's data, or a stale result that masks a real change?
- **F3/F4 (budget):** is `complete_model_usage` reached on EVERY path where `reserve_model_usage`
  succeeded (assessed AND technical_failure, including error/early-return paths)? Can you still
  construct a paid-call path that isn't released or isn't bounded? Confirm the quality call is now
  strictly after the bind.
- **F5 (audit):** is the `request_id` now genuinely unique per event and un-collidable by the
  unauthenticated phone? Does any caller still surface a fabricated `incident_id` when the insert
  fails?
- **F6 (dead SQL):** does `claim_capture_pairing_upload` now COMMIT its expiry/attempts-exhausted
  transitions (return instead of raise), and does `create_capture_upload` correctly distinguish the
  returned terminal state from a live claim? Is `state='rejected'` now actually reachable?
- **F7 (cascade):** trace a parent delete (attempt/session/response-version) through the token →
  events cascade with the guard now `before update` only. Does it succeed, and are direct
  event deletes still impossible?
- **F8 (desktop split):** is there now a real, distinct `failure_class` signal on `pairing_status`
  end to end (token column → `publicPairingView` → frontend contract → `CaptureItem` phase), and
  does the phone leg still classify correctly? Same photo/moment: can phone and desktop still assign
  blame differently?
- Findings 2, 9–14: trace each (Cancel re-mint; the double-submit ref guard; HEIC screen; the
  atomic `append_capture_pairing_event`; the fail-closed supersede; the finalize-race accurate
  error + self-healing orphan; `describe_capture` issued→paired).

### Part B — Independent, open-ended re-review of the NEW code (fresh eyes)

The rework added real new surface. Review it as if it were a fresh feature — this is where a rework
most often introduces an adjacent defect:

1. **New SQL (`record_capture_upload`, `append_capture_pairing_event`, the changed
   `claim_capture_pairing_upload`, the `failure_class` column + check, the trigger change, grants):**
   re-read fresh for atomicity, CAS correctness, RLS, the `jsonb_set` sequence patch, `SECURITY
   DEFINER`/`search_path`, and any new dead value or missing constraint.
2. **The reordered submit flow (bind → quality → complete → derived → finalise):** any new ordering
   hazard? Orphaned storage objects or attachments on the finalize-miss path? Does the derived-copy
   step interact badly with the moved quality call? Is the TOCTOU fingerprint guard still correct
   around the new order?
3. **The keep-open (`uploaded`) lifecycle:** leaving capabilities live instead of consuming them —
   does `is_submitted` (via `assertAttemptStillWritable`) genuinely gate every post-commit write, or
   can an open capability mutate a response after the desktop has committed/graded it? Can the
   redemption budget be exceeded, or a capability be reused across attempts?
4. **`describe_capture` now mutates state (issued→paired), and it is UNAUTHENTICATED.** Is that
   transition safe (no attempt consumed, no cross-user effect, idempotent under reload/concurrency)?
   Does it open any new abuse (e.g. a scanner flipping many tokens to `paired`)?
5. **Security/trust boundary regression:** re-verify token replay, single-use-under-concurrency
   (the CAS still holds with the new record/consume split), cross-user access, service-role leakage,
   and rate limiting — the rework touched all of these adjacent code paths.
6. **Test quality (this is critical — the rework's own F15 fix is a large new test file with an
   in-memory fake):** does `capture-pairing/index_test.ts` actually exercise the real handler logic,
   or is the fake service/storage/RPC layer permissive enough to pass tests that the real Postgres
   would fail? Spot-check the fake RPCs against the migration SQL for fidelity (e.g. does the fake's
   consume/record/claim/reserve/complete match the real CAS/lock/idempotency semantics?). A green
   suite backed by an unfaithful fake is worse than no suite.
7. **Frontend state-machine coherence** after another round of edits: mint → render → poll →
   phone-connects → capture → retake → submit → cancel → expiry, plus the new `capture_problem` and
   `unsupported_file` screens. Any new gap between states, or a screen a real backend response can't
   actually produce?
8. **Doc accuracy:** does `QR_MVP_REWORK_2026_08_20.md` (and the updated `CURRENT_STATE.md` /
   `DECISIONS_AND_BLOCKERS.md` item 8) match the code? Any wrong claim, cited-but-absent function,
   or fix described that isn't actually present?

## Deployment/mutation discipline (confirm independently, don't trust the account)

Verify: neither `c45b838` nor `b01d3b0` is on any remote; migration `20260819120000_capture_pairing`
is applied to neither Development (`wmgjsdkphcyhngaffbqf`) nor Production (`pcntajvbdfqhbeewmdry`);
no `capture-pairing` edge function is deployed to either project. State how you verified this (exact
commands/checks), not just the conclusion.

## Output

Use the `ReportFindings` tool if available. Otherwise a structured findings list, most severe first,
each with file/line, a concrete failure scenario, and a verdict. Separately and explicitly state:

1. Disposition of each of Round 1's findings (fixed / not fixed / partial / regressed).
2. Any new findings from the open-ended re-review, with the same severity tiers Round 1 used
   (blocking / serious non-blocking / lower severity) — pay special attention to anything the rework
   introduced.
3. A bottom-line recommendation: **merge as-is**, **merge with minor fixes**, or **hold for further
   rework** — and if holding, exactly what the next pass must address.

If everything genuinely clears, say so plainly and specifically — which findings and which new code
paths you tried hardest to break and could not — and confirm the deployment discipline. A review
that finds nothing is only credible if it shows its work.
