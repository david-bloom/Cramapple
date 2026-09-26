# TASK-0040 — Launch: Marketing Home Page

**Task ID:** TASK-0040
**Title:** Marketing Home Page — October 2, 2026 Free-Launch Readiness (verify-and-fix pass)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** High
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0040-<slug>`) when an agent starts execution
**PR:** None yet

## Codex QA note (2026-09-26, pre-execution review)

Codex reviewed this task record before any work started and returned **Fail — revision required**.
Findings folded into this revision: date corrected to October 2, 2026; reconciled with
`docs/product/LAUNCH_RUNBOOK_2026_10_02.md` (§1 public entry and §5 BYOQ/safety boundary); tier
raised to Hard-Gate because the CTA fix and BYOQ review clearance are unresolved dependencies, not
completed criteria; audit split from any implementation that would touch the live Production Lovable
app. This is still a pre-execution draft — no implementation agent has been assigned.

## Product Goal

The public, pre-login marketing home page says what Cramapple is, who it's for, and gets a visitor to
free access for the October 2, 2026 launch — without contradicting product scope, an undecided brand
element, or an unsupported claim.

## Technical Scope

Primary sources: `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §§1 and 5 (the concise October 2 critical-path
checklist — use this first) and `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` (fuller
evidence and rationale). Read both, including all CORRECTION blocks, before starting.

**Split into two sub-scopes — do not treat this as one undifferentiated task:**

**A. Audit (read-only, no Production write, Standard-tier evidence gathering):**
- The deliverable already exists and is live at `https://ap-prep-canvas.lovable.app/` (the "Remix of
  Cramapple App" Lovable project, `d334fed9-5a97-4e76-906e-7c0ad7082212`). This is a verify-and-fix
  pass against a live page, not a build-from-spec task.
- Re-read the live page directly — not a cached Lovable `get_project` screenshot, which has been wrong
  before on this exact project.
- Record URL, timestamp, screenshots or HTML evidence, and the Lovable commit/version checked.

**B. Implementation (any change to the live Lovable app — Hard Gate, requires David's explicit go
before deploying):**
- The $39.99/Stripe purchase CTA is stale against the free-launch decision (`DECISION-0071`). **David
  is fixing this specific item himself directly in Lovable** (a "Free this week!" banner) — an
  implementation agent must not independently rework the CTA or pricing section. Check current status
  with David before touching anything in this area; if he has already shipped the fix, this becomes an
  audit item (confirm it's live), not implementation work.
- Any other Lovable change this task's audit surfaces as necessary is itself a Production frontend
  change and requires the same explicit approval before it ships — do not bundle an unapproved fix
  into what should be an audit report.

## Out of Scope

- Pricing decisions (BIZ-001) — reflect pricing, don't set it.
- Campaign/paid-acquisition content (GTM-001's campaign landing pages).
- Backend/checkout implementation (see TASK-0041, post-launch).
- The $39.99 CTA fix itself — David is handling this directly unless he explicitly hands it off.

## Routes / Components / Systems Affected

- Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` (`ap-prep-canvas.lovable.app`) — outside this
  repo's edit surface; this **is** the live Production frontend for launch, so any edit is a Production
  change subject to the Hard Gate above.

## Data / Security / Integration Impact

BYOQ's anonymous/ungated delivery raises privacy, rights, and academic-integrity questions still
pending review per `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004) — per the runbook, record any
unresolved issue for David's risk decision; do not silently accept it or treat the review as complete
because the feature functions.

## Acceptance Criteria

Mirrors `docs/product/LAUNCH_RUNBOOK_2026_10_02.md` §§1 and 5 and
`LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`; those documents govern if this list drifts.

- [ ] Confirm the live page clearly states that access is free for this launch.
- [ ] Confirm every primary CTA routes to free access/sign-up and does not require or imply checkout.
      **Treat the $39.99 CTA as an unresolved dependency, not a completed criterion, until David's fix
      is confirmed live** — do not mark this Done from the plan's intent alone.
- [ ] Confirm AP Biology and AP Statistics are shown "Live now"; other subjects are not advertised as
      live.
- [ ] Confirm no unsupported performance claim is present (no "X% improvement" without a cited
      evidence source; GTM-001's evidence rules are still `Proposed`).
- [ ] Confirm BYOQ is present, ungated, and anonymous on the live page. **Treat the pending
      privacy/rights/academic-integrity review as an unresolved dependency, not a completed criterion**
      — record it as an open risk if it hasn't actually happened, rather than passing this item because
      the feature works.
- [ ] Confirm anonymous BYOQ does not expose a canonical answer in the response or surrounding UI.
- [ ] Confirm the live BYOQ copy accurately states the actual retention and privacy behavior. If the
      required language is materially false or absent, stop and report it for David's risk decision.
- [ ] WCAG AA contrast verified against `docs/new_design/`'s tokens with a real check, not a visual
      read.
- [ ] Copy reviewed against `docs/new_design/`'s voice guidance (no clinical/robotic, no hype, no
      warm-fuzzy-teacher tone).
- [ ] Record URL, timestamp, HTML/screenshot evidence, and Lovable commit/version checked.
- [ ] David has signed off on the final page (Hard Gate: public claims + brand identity finalization,
      per `STANDING_APPROVAL_LANES.md`).

## QA Plan

- Manual QA: load the live page, verify each criterion against actual rendered HTML/CSS, not the design
  doc or a cached screenshot.
- Automated tests: none specific to this task; rely on Lovable's own build/preview.
- Regression areas: BYOQ anonymous flow, canonical-answer exposure, retention/privacy copy, CTA
  destination links.
- Failure cases: any unsupported performance claim ships; any CTA implies checkout/purchase; BYOQ's
  pending domain reviews are treated as closed without evidence they happened; BYOQ exposes a
  canonical answer; required privacy/retention language is materially false or absent.
- Security/data/integration checks: confirm BYOQ's pending domain reviews before treating the feature
  as fully cleared.
- **QA independence:** QA on this task must run in a fresh context, separate from whichever agent
  performed the audit/implementation (`AGENT_OPERATING_MODEL.md` — QA in the same thread as the
  implementation is QA in name only). QA returns a proposed verdict only; it does not close this task.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (public performance claims, brand identity finalization, and any change to
the live Production Lovable app, per `STANDING_APPROVAL_LANES.md`)
**Decision:** Pending — Codex reviewed this task record 2026-09-26 (Fail, revision required); this
revision folds in that feedback. Still awaiting Codex's re-review before being finalized; execution has
not started.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent — what was actually done, with
citations to the live evidence checked.)_

**Test Results:** _(To be filled by the implementation agent — live-page checks performed, with
timestamps/version evidence.)_

**Risks / Issues:** _(To be filled by the implementation agent — any unresolved dependency found, e.g.
the CTA fix or BYOQ review status, named explicitly rather than assumed resolved.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context per
`AGENT_OPERATING_MODEL.md`.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence (`AI_COLLABORATION_RULES.md`). David's sign-off (above) is
required before `Done` regardless of QA verdict.
