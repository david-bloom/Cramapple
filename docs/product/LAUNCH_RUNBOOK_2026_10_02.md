# Cramapple Free-Launch Runbook — October 2, 2026

**Status:** Draft execution surface
**Owner / final launch approver:** David Bloom
**Tier:** Hard-Gate
**Launch target:** Friday, October 2, 2026
**Launch frontend (CORRECTED 2026-09-27, per `D-2` in `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`):**
the live launch surface is **`https://cramapple.com`** (marketing → Lovable project "New Cramapple
Marketing," `61dd6602`) and **`https://app.cramapple.com`** (student app → Lovable project "New Cramapple
App," `56cae479`). The previously listed `https://ap-prep-canvas.lovable.app/` ("Remix of Cramapple App,"
`d334fed9`) is **NOT** the production frontend — a live DNS/`curl` check on 2026-09-27 confirmed the
domains resolve to `61dd6602`/`56cae479`. Re-confirm via DNS before trusting any doc's project citation.
**SUPERSEDED launch shape (2026-10-01, `DECISION-0094`):** Phase 1 is a $1-coupon pilot for ~10 friends (Orly emails the
code); Phase 2 is a public launch at 50% off through October. The free-via-100%-coupon text below is no longer current;
see `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`.
**Launch shape (AMENDED 2026-09-30, `DECISION-0091`):** Free to the student, via `/checkout` with a 100%-off
coupon. `/signup` is retired (`DECISION-0090`). Stripe live-mode setup and the live coupon remain Hard Gates.
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
- [ ] Confirm every primary CTA routes to `/checkout`, and the coupon brings the total to $0 without the
      student paying or entering a card (`DECISION-0091`).
- [ ] Confirm AP Biology and AP Statistics are “Live now”; other subjects are not advertised as live.
- [ ] Confirm no unsupported performance claim is present.
- [ ] Record URL, timestamp, screenshots or HTML evidence, and the Lovable commit/version checked.

### 2. Brand-new-student access smoke

- [ ] Create a clearly labeled launch-QA student through the real public route (`/checkout`).
- [ ] Confirm a $0 coupon checkout creates active Biology and Statistics entitlements (needs PR #284). Do not
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

**Backend fix merged to Production 2026-09-27 (PR #227, branch `codex/task-0044-statistics-mcq`):**
TASK-0044 found that AP Statistics MCQ practice was content-ready but unservable at the RPC layer (no
combined FRQ+MCQ selector existed for any subject but Biology). A new
`app.select_ordinary_combined_practice_items` RPC plus a `student-session-items` routing change
accepting either `mcq` (the real Home session format) or `targeted_drill` closes that gap — independently
verified byte-for-byte identical to what was already running live in Production before the merge, and
confirmed returning a real 7 FRQ + 13 MCQ mix with Biology's own path unaffected. (A separate, earlier
attempt at this fix, `claude/task-0047-ap-statistics-mcq-serving`, used a narrower `targeted_drill`-only
routing and was never applied to Production; that branch has been deleted.) **This smoke test can now
proceed** — it should no longer hit the previously-diagnosed MCQ gap, but still verify the live student
UI experience directly rather than assume the backend fix alone is sufficient.

**Content-servability pre-check (TASK-0044, 2026-09-26, read-only against Production): FRQ Pass; MCQ
originally found Blocked at the backend-RPC layer, now fixed per the correction above.** FRQ content
and live serving both confirmed. MCQ content is fully ready (101/101 with a correct answer); the
backend gap that made it unservable is closed as of PR #227. **This smoke test should still verify the
MCQ experience directly against the live student UI** rather than assume the backend fix alone is
sufficient — if it doesn't work, that is exactly item 2's "receive both the intended MCQ/FRQ
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

## Explicitly post-launch (enablement, not implementation)

- Turning on Stripe checkout / payment gating for students — October 2 itself stays free, no live CTA
  requires or implies payment (see Stop conditions). **Note (`DECISION-0083`, 2026-09-28): TASK-0041
  implementation (checkout UI, webhook, bundles, promotions, refunds, paid entitlement reconciliation)
  is now under active development ahead of October 2 — only enabling it for real payment on the live
  launch surface stays post-launch, and remains Hard-Gated on explicit Product Owner approval.**
- Unit-gated practice and the remaining labels/difficulty pipeline for Biology and Statistics.
- The other eight AP subjects.
- BIZ-001’s remaining commercial-policy questions.

## Stop conditions

Stop and report rather than work around any of these:

- a new student cannot obtain the entitlement needed for grading;
- a live CTA requires a student to pay or enter a card, or the coupon does not bring checkout to $0
  (`DECISION-0091`);
- Biology or Statistics cannot complete a real submit-to-grade round trip;
- the live page or app differs materially from the version that was reviewed;
- completing the next step requires an unapproved Production mutation; or
- required privacy/rights language is materially false or absent.

## Evidence handoff

Use `docs/team_charter/HANDOFF_PACKET_TEMPLATE.md`. Include the exact branch/PR, Lovable version,
Production services checked, test account disposition, screenshots/logs, failures, and all
uncommitted or unpushed state. Implementation reports `Ready for Review`; only the Main Conductor can
set work Done, and only David can authorize launch.
