# Cramapple Free-Launch Runbook — October 2, 2026

**Status:** Draft execution surface
**Owner / final launch approver:** David Bloom
**Tier:** Hard-Gate
**Launch target:** Friday, October 2, 2026
**Launch frontend:** `https://ap-prep-canvas.lovable.app/` — Lovable project “Remix of Cramapple App”
(`d334fed9-5a97-4e76-906e-7c0ad7082212`)
**Launch shape:** Free; no Stripe checkout or payment gating
**Day-1 subjects:** AP Biology and AP Statistics, both on flat practice paths

## Purpose

This is the concise execution surface for the October 2 launch. It resolves the layered corrections
in the broader readiness plans into one ordered checklist. The underlying plans remain authoritative
for detailed evidence and post-launch commercial work.

## Authority and role split

- David makes the final go/no-go decision and approves any Production change.
- Main Conductor owns source-of-truth updates, approval boundaries, coordination, and the final
  integrated recommendation.
- Claude or another Implementation/Live-State Agent may execute one explicitly assigned workstream
  within approved scope and report evidence; it does not declare launch readiness.
- A fresh independent QA context reviews the completed evidence. It must not be the implementation
  thread.
- Production deployment, configuration, secrets, migrations, and the launch itself remain Hard Gates.

## October 2 critical path

### 1. Public entry and free-access promise

- [ ] Re-read the live page, not a cached Lovable screenshot.
- [ ] Confirm the page clearly states that access is free for this launch.
- [ ] Confirm every primary CTA routes to free access/sign-up and does not require checkout.
- [ ] Confirm AP Biology and AP Statistics are “Live now”; other subjects are not advertised as live.
- [ ] Confirm no unsupported performance claim is present.
- [ ] Record URL, timestamp, screenshots or HTML evidence, and the Lovable commit/version checked.

### 2. Brand-new-student access smoke

- [ ] Create a clearly labeled launch-QA student through the real public signup route.
- [ ] Confirm the signup/free-trial path creates active Biology and Statistics entitlements. Do not
      assume “free” bypasses the Production grading entitlement check.
- [ ] Confirm the student reaches both practice routes without an admin/manual entitlement grant.
- [ ] Record the entitlement source, start/end window, subjects covered, and test-account cleanup plan.

### 3. AP Biology flat-path smoke

**Content-servability pre-check done (TASK-0044, 2026-09-26, read-only against Production): Pass.**
Criteria 1/2/4/6 confirmed live for both FRQ and MCQ; both item types confirmed actually reachable via
live RPC calls (`select_practice_frqs`, `select_biology_practice_items`). See
`SUBJECT_SERVABILITY_CRITERIA.md`'s TASK-0044 note for full evidence. This smoke test should not hit a
content-side failure for Biology.

- [ ] Start a real AP Biology practice session through the live student UI.
- [ ] Receive a real published question from the flat practice path.
- [ ] Submit and receive a real server-side grade and criterion-level feedback.
- [ ] Confirm retry/repair and session completion do not strand the student.

### 4. AP Statistics flat-path smoke

**Content-servability pre-check done (TASK-0044, 2026-09-26, read-only against Production): FRQ Pass;
MCQ Blocked at the backend-RPC layer.** FRQ content and live serving both confirmed. MCQ content is
fully ready (101/101 with a correct answer) but **no backend RPC can serve it on the flat path** —
`select_biology_practice_items` (the only combined FRQ+MCQ selector) is Biology-only by design, and
`student-session-items` calls only `select_practice_frqs` (FRQ-only) for every other subject in ordinary
mode. **This smoke test is where that gap surfaces or doesn't** — if the live app cannot actually show
an AP Statistics MCQ to this test student, that is exactly item 2's "receive both the intended MCQ/FRQ
experience" failing, and it is a stop condition, not something to work around. See
`SUBJECT_SERVABILITY_CRITERIA.md`'s TASK-0044 note and TASK-0044's Risks/Issues for full evidence.

- [ ] Start a real AP Statistics practice session through the live student UI.
- [ ] Receive both the intended MCQ/FRQ experience required by the launch surface — **verify the MCQ
      side specifically; do not assume it works because FRQ and content are both confirmed ready.**
- [ ] Submit and receive a real server-side grade and criterion-level feedback.
- [ ] Confirm the selected exam-pack version has the content the UI requests; do not rely on the
      retired unit-gated or pilot-pack path.

### 5. BYOQ and safety boundary

- [ ] Confirm anonymous BYOQ works as currently approved and does not expose a canonical answer.
- [ ] Confirm the live copy accurately states retention/privacy behavior.
- [ ] Record any unresolved privacy, rights, academic-integrity, rate-limit, or retention issue for
      David’s risk decision; do not silently accept it.

### 6. Independent QA and launch decision

- [ ] Fresh-context QA reviews the live evidence and returns Pass/Fail, blockers, residual risks, and
      the exact environments/versions checked.
- [ ] Main Conductor reconciles the QA result into this runbook and the launch-readiness index.
- [ ] David records the final go/no-go decision. A QA Pass is not launch approval.

## Explicitly post-launch

- Stripe checkout, webhook, bundles, promotions, refunds, and paid entitlement reconciliation.
- Unit-gated practice and the remaining labels/difficulty pipeline for Biology and Statistics.
- The other eight AP subjects.
- BIZ-001’s remaining commercial-policy questions.

## Stop conditions

Stop and report rather than work around any of these:

- a new student cannot obtain the entitlement needed for grading;
- a live CTA still requires or implies payment;
- Biology or Statistics cannot complete a real submit-to-grade round trip;
- the live page or app differs materially from the version that was reviewed;
- completing the next step requires an unapproved Production mutation; or
- required privacy/rights language is materially false or absent.

## Evidence handoff

Use `docs/team_charter/HANDOFF_PACKET_TEMPLATE.md`. Include the exact branch/PR, Lovable version,
Production services checked, test account disposition, screenshots/logs, failures, and all
uncommitted or unpushed state. Implementation reports `Ready for Review`; only the Main Conductor can
set work Done, and only David can authorize launch.
