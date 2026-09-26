# TASK-0040 — Launch: Marketing Home Page

**Task ID:** TASK-0040
**Title:** Marketing Home Page — Friday Free-Launch Readiness (verify-and-fix pass)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0040-<slug>`) when an agent starts execution
**PR:** None yet

## Product Goal

The public, pre-login marketing home page says what Cramapple is, who it's for, and gets a visitor to
free access for Friday's launch — without contradicting product scope, an undecided brand element, or
an unsupported claim.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` — read in full before
starting, including all three CORRECTION blocks. Key facts already established there (do not re-derive):

- The deliverable already exists and is live at `https://ap-prep-canvas.lovable.app/` (the "Remix of
  Cramapple App" Lovable project, `d334fed9-5a97-4e76-906e-7c0ad7082212`). **This is a verify-and-fix
  pass against a live page, not a build-from-spec task.**
- Design system, wordmark, and BYOQ's presence on the page are already confirmed correct in the live
  HTML (`DECISION-0070`, `DECISION-0073`) — re-verify rather than re-build.
- The $39.99/Stripe purchase CTA is stale against the free-launch decision (`DECISION-0071`). **David is
  fixing this specific item himself directly in Lovable** (a "Free this week!" banner) — do not
  independently rework the CTA or pricing section; check current status with David before touching it.
- Requires Lovable access to the named project to ship any change.

## Out of Scope

- Pricing decisions (BIZ-001) — reflect pricing, don't set it.
- Campaign/paid-acquisition content (GTM-001's campaign landing pages).
- Backend/checkout implementation (see TASK-0041).
- The $39.99 CTA fix itself — David is handling this directly.

## Routes / Components / Systems Affected

- Lovable project `d334fed9-5a97-4e76-906e-7c0ad7082212` (`ap-prep-canvas.lovable.app`) — outside this
  repo's edit surface; verify and edit via Lovable.

## Data / Security / Integration Impact

None expected in this repo. BYOQ's anonymous/ungated delivery raises privacy, rights, and
academic-integrity questions still pending review per `STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
(UX-004) — flag rather than resolve silently; see plan's "Still open" section.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` — this list mirrors it;
that doc governs if they drift.)

- [x] Rebuild-sequencing gate — moot, page already exists (`DECISION-0073`).
- [x] Logo/wordmark — not a blocker (`DECISION-0070`), already correct on the live page.
- [x] $39.99/Stripe CTA — David is handling directly; agent does not touch this item.
- [ ] Page structure and copy verified against the live HTML (spot-check for drift, not a rebuild).
- [x] BYOQ confirmed present and ungated/anonymous on the live page — still verify the pending
      privacy/rights/academic-integrity review has actually happened.
- [ ] Every claim on the page is a verifiable product fact or explicitly flagged pending GTM-001's
      evidence rules — no unsupported performance claims ship.
- [ ] WCAG AA contrast verified against `docs/new_design/`'s tokens (real check, not a visual read).
- [ ] Copy reviewed against `docs/new_design/`'s voice guidance (no clinical/robotic, no hype, no
      warm-fuzzy-teacher tone).
- [ ] CTA path leads to free access/sign-up for Friday, with no checkout/purchase implication.
- [ ] David has signed off on the final page (Hard Gate: public claims + brand identity finalization).

## QA Plan

- Manual QA: load the live page, verify each criterion against actual rendered HTML/CSS, not the design
  doc.
- Automated tests: none specific to this task; rely on Lovable's own build/preview.
- Regression areas: BYOQ anonymous flow, CTA destination links.
- Failure cases: any unsupported performance claim; any CTA that implies checkout/purchase.
- Security/data/integration checks: confirm BYOQ's pending domain reviews before treating the feature
  as fully cleared.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (public performance claims and brand identity finalization, per
`STANDING_APPROVAL_LANES.md`)
**Decision:** Pending — this task record itself is a draft awaiting Codex's review before being
finalized; execution has not started.

## Implementation Notes

_(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
