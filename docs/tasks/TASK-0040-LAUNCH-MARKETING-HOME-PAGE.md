# TASK-0040 — Launch: Marketing Home Page

**Task ID:** TASK-0040
**Title:** Marketing Home Page — October 2, 2026 Free-Launch Readiness (verify-and-fix pass)
**Owner:** Codex
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Blocked
**Priority:** High
**Created Date:** 2026-09-26
**Approved Date:** 2026-09-26 (read-only audit only; no Production change approved)
**Branch:** `codex/task-0040-home-page-audit`
**PR:** None yet

**Blocked Reason:** A new "Free for November" banner is live, but the page still contains paid CTAs and a $39.99 purchase section. The contradictory messaging continues to trigger the runbook stop condition that a live CTA requires or implies payment.

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
  is fixing this specific item himself directly in Lovable.** On 2026-09-26 he reported a planned
  "Free until November" banner; the live deployment later rendered "Free for November." An
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

- [ ] **Partially remediated, still blocked 2026-09-26:** a new "Free for November" banner is live in
      the price row, but it appears beside "$39.99 / one subject / no subscription" while the header
      still says "Get it · $39.99." The page therefore does not state the free-launch promise
      consistently or unambiguously.
- [ ] **Failed 2026-09-26:** primary CTAs still imply purchase: "Get it · $39.99," a "$39.99 / one
      subject / no subscription" price card, "Get AP Statistics," "Ask a parent to buy it," and
      "Bundles." These link to `/signup` or `/ask-parent`. Treat the $39.99 CTA as unresolved until
      David's fix is confirmed live.
- [x] AP Biology and AP Statistics are shown "Live now"; the other eight subjects are shown as coming
      soon.
- [ ] **Needs review:** delivered social metadata says "Maximum AP exam score in minimal time" without
      an evidence citation. No quantified improvement claim was found in the delivered home-page HTML,
      but GTM-001's evidence rules are still `Proposed`.
- [ ] **Partially verified:** BYOQ is present and the page says "Nothing saved · no account" and "One
      free question. Your photo isn't kept." Interactive anonymous behavior was not exercised because
      the supported browser could not start in this symlinked workspace. Treat the pending
      privacy/rights/academic-integrity review as unresolved.
- [ ] Not verified: anonymous BYOQ must not expose a canonical answer in the response or surrounding UI.
- [ ] Not verified: the live BYOQ copy must accurately state actual retention and privacy behavior. If
      the required language is materially false or absent, stop and report it for David's risk decision.
- [ ] Not verified: WCAG AA contrast against `docs/new_design/`'s tokens requires a rendered-page check
      with the supported browser.
- [ ] Partially reviewed from delivered HTML only: copy still needs rendered-page review against
      `docs/new_design/`'s voice guidance.
- [x] Evidence recorded: `https://ap-prep-canvas.lovable.app/`, HTTP 200 at 2026-09-26 15:38:29 UTC
      (11:38:29 America/New_York), deployment
      `psr2.5b02aa18-5f8b-48a4-b335-056cbae402d6.1791041908.d1_x-jKSXQtPm1Yiz9fzXhiCjB7-3jn35h3k3K41-Pg`,
      delivered assets `styles-DcabbJId.css`, `index-C34axR7A.css`, `index-D-MdByNs.css`,
      `index-D4j384PU.js`, and `index-yd3Y6Fxu.js`. HTML evidence was inspected directly; screenshot
      evidence remains unavailable because browser startup failed before navigation.
- [x] Recheck evidence: HTTP 200 at 2026-09-26 15:47:35 UTC (11:47:35 America/New_York), deployment
      `psr2.ca3ff895-7537-417a-8ab9-114518dc7d57.1791042456.BD1MZZqiUn51mL_W21qGywpl1jSpfenNA8_Q8_GahN8`,
      delivered assets `index-D8VnhNPE.js`, `index-DHyVGulG.js`, `index-B-RszSsD.css`, and
      `index-D-MdByNs.css`. The new deployment contains "Free for November" but still contains "Get it
      · $39.99," the $39.99 price, "Get AP Statistics," "Ask a parent to buy it," and "Bundles."
      Delivered HTML and JavaScript assets were checked directly.
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
**Decision:** David instructed Codex to execute TASK-0040 on 2026-09-26. That authorizes this read-only
audit and its evidence updates only. No Production Lovable edit, deployment, public-claim approval,
brand finalization, or risk acceptance has been approved. The live paid-CTA stop condition requires
David's direction before implementation proceeds.

David then approved continuing the read-only audit while Lovable added a banner. This did not authorize
Codex to edit Production or accept the remaining contradictory paid messaging.

## Implementation Notes

**Implementation Summary:** Codex performed the read-only audit against the live HTTPS response on
2026-09-26. No Production change was made. The audit stopped when the delivered page showed paid CTAs
and a $39.99 purchase section, as required by the October 2 runbook stop conditions. Codex then
rechecked the follow-up Lovable deployment and its delivered JavaScript assets. The banner was present,
but the paid CTAs remained; no Production change was made by Codex.

**Test Results:**
- PASS — the live URL returned HTTP 200 and the exact deployment/assets are recorded above.
- PARTIAL / BLOCKER — "Free for November" is live, but contradicts the surrounding paid messaging.
- FAIL / BLOCKER — paid CTAs and the $39.99 price card remain live.
- PASS — AP Biology and AP Statistics are marked "Live now"; the other eight subjects are presented as
  coming soon.
- PARTIAL — BYOQ is present with anonymous/no-retention copy, but its interaction, canonical-answer
  boundary, and actual retention behavior were not verified.
- NOT RUN — rendered WCAG contrast, interactive CTA destination behavior, and screenshots. The
  required browser runtime could not start because the workspace path contains a symlink; the audit
  did not substitute cached Lovable state.

**Risks / Issues:**

- Launch blocker: contradictory free/paid messaging still violates `DECISION-0071` and the October 2
  free-launch runbook.
- Public-claim review needed for "Maximum AP exam score in minimal time" in social metadata.
- BYOQ privacy/rights/academic-integrity review remains unresolved.
- The retention claim "Your photo isn't kept" and canonical-answer boundary require functional
  verification before launch.
- Visual accessibility and full copy review remain unverified until rendered-browser QA is available.

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
