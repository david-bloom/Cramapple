# TASK-0043 — Launch: Student Hub (New-Student Critical Path)

**Task ID:** TASK-0043
**Title:** Student Hub — October 2, 2026 New-Student Signup, Entitlement, and Submit-to-Grade Smoke
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** High — this is the core October 2 launch smoke test
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0043-<slug>`) when an agent starts execution
**PR:** None yet

## Codex QA note (2026-09-26, pre-execution review)

Codex reviewed this task record before any work started and returned **Fail — revision required**.
Findings folded into this revision: date corrected to October 2, 2026; **narrowed to the
launch-critical new-student journey only** (signup, free entitlement grant for both Day-1 subjects,
real submit-to-grade) per `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §2–4 — the full student-hub
specification audit (§3–§14 of the interaction design spec / rebuild plan §12) is moved to
**TASK-0045**, a separate post-launch task; **this task now owns the entitlement-gating issue for the
free/new-student path** (TASK-0041 owns only the paid-Stripe-side path — see that task's corrected
scope, resolving the prior overlapping-ownership finding); audit split from any fix that would touch
Production code. This is still a pre-execution draft — no implementation agent has been assigned.

## Product Goal

A brand-new student, with no prior account, can sign up through the real public flow, receive active
free entitlements for both Day-1 subjects (AP Biology, AP Statistics), and complete a real
submit-to-grade round trip in each — without hitting the entitlement-gating error found 2026-09-20.
**This is the core smoke test the October 2 launch decision depends on.**

## Technical Scope

Primary source: `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §2 ("Brand-new-student access smoke"), §3
("AP Biology flat-path smoke"), and §4 ("AP Statistics flat-path smoke") — this is the authoritative,
current scope for this task. `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` remains useful
background evidence (frontend identification, confirmation that grading is real production
infrastructure) but its full spec-audit scope is **not** this task's scope — see TASK-0045.

Confirmed facts already established (do not re-derive):

- Launch frontend is the "Remix of Cramapple App" Lovable project (`d334fed9-5a97-4e76-906e-7c0ad7082212`,
  `https://ap-prep-canvas.lovable.app/`) — `DECISION-0073`.
- **Practice/grading is verified real production infrastructure, not a demo** — `use-grade-practice.ts`
  calls the actual `session-event`/`attempt-response`/`evaluate-attempt` edge functions. Only the
  home-page hero's `FrqDemo.tsx` is a scripted demo (expected, marketing-only).
- The entitlement-gating bug (unentitled students hitting a generic "Couldn't score that" error) was
  found against this real grading path 2026-09-20. **For October 2, verify this specifically on the
  free/trial signup entitlement path** — do not assume "free" bypasses the Production entitlement
  check; the runbook explicitly warns against that assumption.

**Split into two sub-scopes:**

**A. Audit/smoke test (read-only against a test account, Standard-tier evidence gathering):**
- Create a clearly labeled launch-QA student through the real public signup route.
- Confirm the signup/free-trial path creates active Biology and Statistics entitlements.
- Confirm the student reaches both practice routes without an admin/manual entitlement grant.
- Run a real practice session in each Day-1 subject: receive a real published question, submit, receive
  a real server-side grade and criterion-level feedback; confirm retry/repair and completion don't
  strand the student.
- Record entitlement source, start/end window, subjects covered, and test-account cleanup plan.

**B. Fix (only if the smoke test fails — any change to Production grading/entitlement code is a Hard
Gate requiring David's explicit approval before deploying):**
- If the entitlement-gating bug reproduces on the free/new-student path, fix or escalate it. This
  touches the real grading path in Production — do not deploy a fix without the same explicit approval
  any other Production code change requires.

## Out of Scope

The full student-hub specification audit (§3 Information architecture through §14 Decisions Required,
progress/home, accessibility, Course Mode cross-check) — moved to **TASK-0045**, post-launch. Redesigning
any already-decided section of the interaction design spec — raise a proposal to David instead.

## Routes / Components / Systems Affected

- Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` — outside this repo's edit surface, but **is**
  the live Production frontend for launch.
- `src/lib/use-grade-practice.ts`, `SessionFrame.tsx`, `GradeResultView.tsx` (in the Lovable project).
- `session-event`, `attempt-response`, `evaluate-attempt` edge functions (this repo) — **live Production
  services**; any code fix here is a Production change.
- Free/trial signup and entitlement-grant path (wherever that lives — confirm live, don't assume).

## Data / Security / Integration Impact

The entitlement-gating gap is a student-facing defect on the entitlement/access boundary. Any fix
touches the real grading path in Production — test against a real logged-in session in a
non-production environment first where possible, but the actual October 2 smoke test must run against
Production per the runbook's stop-condition language.

## Acceptance Criteria

Mirrors `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §2–4; that document governs if this list drifts.

- [x] Frontend confirmed: `ap-prep-canvas.lovable.app` (`DECISION-0073`).
- [ ] A clearly labeled launch-QA student is created through the real public signup route.
- [ ] The signup/free-trial path creates active Biology and Statistics entitlements — confirmed by
      querying the entitlement table directly, not by reading the signup code and assuming it works.
- [ ] The student reaches both practice routes without an admin/manual entitlement grant.
- [ ] AP Biology: a real practice session is started, a real published question is received, submitted,
      and graded server-side with criterion-level feedback; retry/repair and completion don't strand the
      student.
- [ ] AP Statistics: same, for both the intended MCQ/FRQ experience; confirm the selected exam-pack
      version has the content the UI requests (do not rely on the retired unit-gated or pilot-pack
      path).
- [ ] Entitlement source, start/end window, subjects covered, and test-account cleanup plan recorded.
- [ ] The entitlement-gating bug's current status on this specific (free/new-student) path is confirmed
      live and either fixed (Hard Gate, David's approval before deploy) or explicitly escalated as a
      launch blocker — not left ambiguous.
- [ ] Any of the runbook's stop conditions hit during this task are reported, not worked around: a new
      student cannot obtain the entitlement needed for grading; Biology or Statistics cannot complete a
      real submit-to-grade round trip; the live app differs materially from the version reviewed;
      completing the next step requires an unapproved Production mutation.

## QA Plan

- Manual QA: real signup, real logged-in session, both Day-1 subjects, flat/practice path only, against
  Production (per the runbook).
- Automated tests: none specific beyond what already exists for the grading edge functions.
- Regression areas: entitlement gating, repair/retry flow.
- Failure cases: unentitled student reaching scoring; a stop condition hit and worked around instead of
  reported.
- Security/data/integration checks: query the entitlement table directly after signup; don't infer from
  code reading.
- **QA independence:** QA on this task must run in a fresh, independent context — not a continuation of
  the agent that ran the smoke test (`AGENT_OPERATING_MODEL.md`). QA returns a proposed verdict only.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate — this task's smoke test runs against Production, and any entitlement/
grading code fix is a Production change requiring David's explicit approval before deploy.
**Decision:** Pending — Codex reviewed this task record 2026-09-26 (Fail, revision required); this
revision folds in that feedback, including narrowing scope and resolving entitlement-issue ownership
with TASK-0041. Still awaiting Codex's re-review before being finalized; execution has not started.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent.)_

**Test Results:** _(To be filled by the implementation agent — signup evidence, entitlement query
results, both subjects' submit-to-grade evidence.)_

**Risks / Issues:** _(To be filled by the implementation agent — e.g. entitlement bug reproduction
status, any stop condition hit.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence. David records the final go/no-go launch decision separately
per the runbook — a QA Pass on this task is not launch approval.
