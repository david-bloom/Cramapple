# Claude Execution Prompt — TASK-0016 Phase D Stage D2, Independent QA Review (Round 2+)

Repo: `Cramapple` (backend, this checkout) and `exam-buddy-wireframe` (frontend, at
`/Users/davidbloom/Documents/exam-buddy-wireframe` — check for a durable worktree at
`/Users/davidbloom/Documents/Cramapple.nosync/.worktrees/phase-d2-frontend` too; if neither
resolves the branch, use `git show`/`git diff` against the branch directly rather than requiring
a checkout).

## What this is

An **independent QA review** of a rework pass on TASK-0016 Phase D Stage D2 (the QR hand-drawn
capture MVP — the bridge that lets the unauthenticated, QR-paired phone leg submit a photo into
the existing `attach_capture`/`app.response_attachments` pipeline). This is Round 2+ of review:
Round 1 (2026-08-19) found 6 blocking defects and returned a **HOLD FOR REWORK** verdict. A
separate session has since attempted fixes. **Your job is to verify those fixes actually work,
and to independently re-review the whole surface for anything new** — not to trust the rework
session's own account of what it fixed.

You are a reviewer, not an implementer. **Do not write or fix any code.** Do not deploy anything,
push anything, or mutate any live database — this review is read/analysis only, same as Round 1.

## Read first, in this order

1. `docs/activity_log/DECISIONS_LOG.md` — `DECISION-0051` and `DECISION-0050` in full (search for
   those headers). These are the product mandate this feature implements: QR handoff is Engine
   4's sole capture path (no direct-upload fallback), System A's frontend reuses System B's
   `attach_capture`/`app.response_attachments` backend rather than recreating
   `capture_sessions`/`capture-research`, and capture failures split into generic-retake-copy
   (image-quality) vs. bug-logged (technical).
2. `docs/research/grading_phase_d_spatial_2026_07_27/QR_MVP_QA_REVIEW_2026_08_19.md` — **the
   full Round 1 findings.** This is your primary checklist. Read every one of the 6 blocking
   findings, the 8 serious-non-blocking findings, and the lower-severity list. For each, you need
   to determine: fixed / not fixed / partially fixed / made worse, with a concrete code citation,
   not a restatement of the rework session's claim.
3. `docs/activity_log/ACTIVITY_LOG.md` — search for "TASK-0016 Phase D Stages D0/D1 Executed" for
   the full session-closeout context this rework followed from, and search for whatever entry the
   rework session itself should have added (if none exists, note that as a process gap — this
   program's convention is to log what was done, not just do it).
4. `docs/research/grading_phase_d_spatial_2026_07_27/{CURRENT_STATE.md,DECISIONS_AND_BLOCKERS.md}`
   item 8 for the current pointer to whichever branches/commits hold the rework — **verify this
   pointer is accurate** (confirm the referenced commits actually exist and contain what the docs
   claim) rather than assuming it's been kept current.
5. `docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`'s "QA Review" section — the
   methodology this program uses for this kind of review (multiple independent finder angles,
   deduped, each candidate independently re-verified before being reported CONFIRMED), and the 8
   prior findings on the code this feature reuses (`attach_capture`) — confirm none have been
   reintroduced by the rework.
6. The current implementation itself: whatever `capture-pairing` edge function, migration, and
   frontend capture components exist on the rework branch(es) — read the actual current diff
   against `main`/`origin main`, not Round 1's snapshot of the code (it has changed).

## Review structure

### Part A — Verify the 6 blocking findings, one at a time

For each of Round 1's 6 blocking findings, re-derive independently whether it's actually fixed:

1. **Blurry-photo retake dead end.** Trace the actual state machine: does a quality-rejected
   capture leave the pairing token in a state that a genuine retake attempt can still use? Test
   your understanding against the actual SQL/state-transition code, not a comment claiming it
   works.
2. **Cancel strands the desktop.** Does the cancel handler actually re-enable a fresh pairing
   attempt (real `start()` call or equivalent), not just clear local state?
3. **Shared grading-budget leak.** Does every path that reserves against `OPENAI_DAILY_CAP_USD`
   (or whatever the current mechanism is) have a corresponding release on every exit path,
   including error paths — not just the happy path? Look for a `finally`-equivalent or explicit
   handling on each early return.
4. **Unmetered retry loop.** Can you still construct a failure path where a paid model call fires
   without being counted toward a bounded budget? Try the same kind of trivial-trigger reasoning
   Round 1 used (a malformed-but-plausible request that fails validation *after* the model call).
5. **Bug-logging mechanism drops rows / fabricates incident IDs.** Does the current logging call
   still risk a unique-constraint collision under realistic concurrent-failure conditions? If the
   constraint or the call pattern changed, verify the new shape actually prevents the collision
   rather than just moving it.
6. **Dead SQL housekeeping updates.** Read the current migration/function SQL directly — does the
   update-then-possibly-raise sequence now correctly commit the update (proper exception handling,
   or reordered so the update isn't discarded), and does something now actually reach any
   previously-dead state value?

For each, report: **FIXED (confirmed)** / **NOT FIXED** / **PARTIALLY FIXED** / **REGRESSED
(worse than Round 1)**, with the exact file/line and the specific scenario you traced.

### Part B — Independent, open-ended re-review (fresh eyes, not just the checklist)

Rework often fixes the named problem while introducing an adjacent one, or reveals a problem that
was previously masked. Run genuinely independent finder passes (same angles Round 1 used, applied
to the current code, not assumed unchanged):

1. **Security/trust boundary** — token replay, single-use-under-concurrency (verify the actual
   locking/CAS semantics, don't trust a comment), cross-user access, service-role leakage,
   rate limiting.
2. **Reuse-vs-drift from `attach_capture`** — does the bridge still genuinely reuse
   `validateCaptureObject`/`bind_response_attachment`/the storage TOCTOU guard, or has the rework
   introduced a parallel, subtly different validation path?
3. **DECISION-0051's failure-classification split** — is there now a real, distinct signal
   (not an overloaded 4-value enum) that lets both the phone and the desktop leg correctly
   distinguish "your photo has a problem" from "we have a problem," end to end?
4. **Regression check** — anything Round 1 explicitly verified as correct (see that review's
   "Verified correct" section) that the rework might have inadvertently broken while touching
   adjacent code. Spot-check a sample rather than assuming stability.
5. **Test quality** — new/changed tests: do they cover the actual security-critical request-
   handling paths this time (Round 1's finding 15 was that the original 82 tests only covered
   pure helpers, not the endpoint's real request logic), or is coverage still concentrated on
   easy-to-test helpers?
6. **Migration correctness** — re-read the current migration SQL fresh for atomicity, RLS,
   indexing, and any new defect introduced by the fix itself.
7. **Frontend state machine coherence** — after another round of edits, does the QR-pairing UX
   (mint → render → poll → phone-connects → capture → retake → submit → cancel → expiry) still
   form one coherent state machine, or has patching individual bugs left new gaps between states?
8. **Doc accuracy** — Round 1 found several claims in the implementation docs that didn't match
   the code (wrong line counts, a cited function that doesn't exist, a docstring describing the
   opposite check order). Spot-check whether the docs were corrected along with the code, or if
   stale claims persist into this round.

## Deployment/mutation discipline (same as Round 1)

Confirm independently, don't just trust the rework session's account: neither branch is on any
remote; the migration is not applied to Development or Production; no new edge function is
deployed to either project. State how you verified this (exact commands/checks), not just the
conclusion.

## Output

Use the `ReportFindings` tool if available. Otherwise: a structured findings list, most severe
first, each with file/line, a concrete failure scenario, and a verdict. Separately and explicitly
state:

1. Disposition of each of Round 1's 6 blocking findings (fixed/not fixed/partial/regressed).
2. Any new findings from the open-ended re-review, with the same severity tiers Round 1 used
   (blocking / serious non-blocking / lower severity).
3. A bottom-line recommendation: **merge as-is**, **merge with minor fixes**, or **hold for
   further rework** — and if holding, exactly what the next rework pass needs to address, the
   same way Round 1 left a clear gate for this round.

If everything genuinely clears, say so plainly and specifically (which findings you tried hardest
to still break and could not) — a review that finds nothing is only credible if it shows its
work, the same discipline Round 1's "verified correct" section used.
