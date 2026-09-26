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

**Blocked Reason:** The checkout blocker is cleared, but the deployed subject picker now redirects to
`https://app.cramapple.com/home?subject=<selected-subject>` and `app.cramapple.com` does not resolve in
DNS. The picker also marks all ten subjects `Available`, conflicting with the October 2 Biology +
Statistics launch scope.

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
- David clarified on 2026-09-26 that the $39.99 list price is intentionally visible so students
  understand the normal price, while the "Free for November" banner communicates that students who
  sign up now should not pay it. Treat that presentation as owner-approved. The audit must still verify
  the linked signup path actually charges zero and does not require checkout; owner intent is not
  deployment evidence. An implementation agent must not independently rework the CTA, pricing section,
  or signup flow without explicit approval.
- Any other Lovable change this task's audit surfaces as necessary is itself a Production frontend
  change and requires the same explicit approval before it ships — do not bundle an unapproved fix
  into what should be an audit report.
**Owner-approved launch flow (2026-09-26):**

1. Student clicks `Get Started`.
2. Student lands on `/signup` and picks a subject.
3. Student goes directly to the student hub.

No checkout or payment step belongs in this October 2 flow.


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

- [x] **Owner-approved presentation:** "Free for November" is live beside the normal $39.99 list price.
      David confirmed this is the intended way to show the waived current price.
- [x] **Flow step 1:** the live header CTA now says `Get Started` and links to `/signup`.
- [x] **Flow step 2:** `/signup` now says "Choose your subject" and renders the subject picker.
- [ ] **Flow step 3 blocked:** the active subject-picker handler routes directly to
      `https://app.cramapple.com/home?subject=<selected-subject>`, but that hostname returned no DNS
      records and `curl` failed with `Could not resolve host` on 2026-09-26. The old checkout code
      remains in the bundle for legacy states, but it is no longer the active first-click handler.
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
- [x] Latest recheck: HTTP 200 at 2026-09-26 15:53:55 UTC (11:53:55 America/New_York), deployment
      `psr2.a50725d9-53c2-4fce-b306-ecdfc3446f79.1791042834.tghII7hEsXfI48QgRVr36yy98_QmiaCvpleua3BBRC8`,
      delivered assets `index-B04bdM1t.js`, `index-CmkzbPkJ.js`, `index-CLnVlhs5.css`,
      `index-D-MdByNs.css`, and `styles-DcabbJId.css`. "Ask a parent to buy it" and "Bundles" are gone,
      but "Get it · $39.99," the $39.99 price card, and "Get AP Statistics" remain actionable.
- [ ] David has signed off on the final page (Hard Gate: public claims + brand identity finalization,
      per `STANDING_APPROVAL_LANES.md`).

- [x] Signup-path evidence: HTTP 200 at 2026-09-26 15:56:31 UTC (11:56:31 America/New_York), deployment
      `psr2.a50725d9-53c2-4fce-b306-ecdfc3446f79.1791042990.YVsbcpdZBoZLUbR9ZDiefJhkXExiQeXNWFUnsyRVw4o`.
      Delivered `/signup` HTML says "Which AP subject are you buying?"; deployed bundles contain
      "One-time purchase," "Continue to secure payment," `/checkout/start`, and the live checkout
      client. No November zero-charge bypass was found in the delivered signup/checkout assets.

- [ ] Latest flow-contract recheck: homepage and `/signup` both returned HTTP 200 at 2026-09-26
      17:25:50 UTC (13:25:50 America/New_York), deployment
      `psr2.2b954098-f2fe-4b6c-a684-fc0bec10116b.1791048349.50j0W8gtc_TWX-r9UfGMY5pK4paVDgpP9GsuFZwDlLE`.
      The deployed `signup-CKHFmLGW.js` active picker handler is
      `window.location.href = appUrl('/home?subject=' + selectedSubject)`, and deployed
      `app-url-D_SGYqYA.js` resolves that destination to `https://app.cramapple.com`. Direct requests
      for Biology, Statistics, and Chemistry destinations all failed because `app.cramapple.com`
      has no DNS answer; `dig +short app.cramapple.com` also returned no record. Evidence SHA-256:
      homepage HTML `52798c6fcaa1d73e7b07cfef4a9d57fec40395c6a83e1be2c3dc0e9c83fb18ce`,
      signup HTML `733f8ebb39521a1fb8c7e11d31c6714953df0ef8f831b1456974338a5561a379`,
      signup bundle `49a16bfc10735f197dd56d06eb11c8821dc7f5d2343f8d54fa9bf1b9f84b7407`.
- [ ] Scope mismatch found in the same deployment: the homepage correctly labels Biology and
      Statistics `Live now` and the others `Coming soon`, but `/signup` forces every catalog result
      and fallback subject to `available: true`, presenting all ten subjects as `Available`.

## QA Plan

- [x] Flow-contract recheck: HTTP 200 at 2026-09-26 16:01:40 UTC (12:01:40 America/New_York), deployment
      `psr2.b7a2e463-1cc8-4482-aaf9-2457dae5e10c.1791043299.5RDKqpkU6Ks1lzNU2zsji4rEKlTFBc5f0YhBjY41yZI`.
      `Get Started` now links to `/signup`. Latest signup asset `signup-C4iqLflC.js` still imports
      checkout code and contains `/checkout/start`, "One-time purchase," and "secure payment"; no
      direct student-hub route was found in the deployed subject-selection flow.
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
brand finalization, or risk acceptance was initially approved. David then approved continuing the
read-only audit while Lovable added a banner. He subsequently clarified that retaining the normal list
price beside "Free for November" is intentional and accepted, and stated that the task is complete.
That owner decision clears the price-presentation question. The later deployment also clears the
active checkout-route conflict, but does not clear the dead `app.cramapple.com` student-hub destination
or the all-ten-subject availability mismatch found in the latest live evidence.

## Implementation Notes

**Implementation Summary:** Codex performed the read-only audit against the live HTTPS response on
2026-09-26. No Production change was made. Follow-up checks confirmed the free-until-November banner,
David's accepted list-price presentation, and the revised subject picker. The active picker no longer
enters checkout: it redirects the selected subject to the configured student-app base URL. That base
URL is `https://app.cramapple.com`, which currently has no DNS answer, so the approved journey still
cannot reach the student hub. The task remains blocked rather than being closed on copy/bundle
evidence alone.

**Test Results:**
- PASS — the live URL returned HTTP 200 and the exact deployment/assets are recorded above.
- PASS — owner-approved price presentation: "Free for November" is live beside the normal list price.
- PASS — flow step 1: `Get Started` routes to `/signup`.
- PASS — flow step 2: `/signup` presents direct subject selection without making checkout the active
  first-click path.
- FAIL / BLOCKER — flow step 3: the direct student-hub destination is `app.cramapple.com`, which does
  not resolve.
- FAIL / SCOPE MISMATCH — `/signup` presents all ten subjects as available while only Biology and
  Statistics are in the October 2 launch scope.
- PASS — AP Biology and AP Statistics are marked "Live now"; the other eight subjects are presented as
  coming soon.
- PARTIAL — BYOQ is present with anonymous/no-retention copy, but its interaction, canonical-answer
  boundary, and actual retention behavior were not verified.
- NOT RUN — rendered WCAG contrast, interactive CTA destination behavior, and screenshots. The
  required browser runtime could not start because the workspace path contains a symlink; the audit
  did not substitute cached Lovable state.

**Risks / Issues:**

- Launch blocker: the direct student-hub hostname `app.cramapple.com` has no DNS answer.
- Launch-scope mismatch: the signup picker presents all ten subjects as available instead of limiting
  launch access to Biology and Statistics.
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
