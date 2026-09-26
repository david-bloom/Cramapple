# App Launch Readiness Index — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Approval Type:** Hard Gate for the launch decision itself; Standing Approval to draft/maintain this index.

## Purpose

Cramapple has no single answer to "is the app ready to go live." Readiness lives scattered across
per-subject content docs, a Stripe task, UX design specs, and MASTER_TODO backlog items. This doc is
the index: it names the five component launch plans that together define "ready," and it is Done —
meaning the app is launch-ready — only when all five are Done.

This is deliberately the single doc TASK-0023 itself predicted would need to exist ("a consolidated
pre-launch checklist... cross-referencing BIZ-001, GTM-001, and TASK-0012") but never built.

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**A second review found these plans were built without reading `docs/product/APP_REBUILD_MIGRATION_PLAN.md`
(2026-09-22, David-approved) — a newer, more current plan for the app rebuild that this index and
plans 1/4 directly conflict with.** Confirmed conflicts: the design system plan 1 cited is retired
(§11 of the rebuild plan); the rebuild plan sets an explicit sequence (app → marketing reskin → Stripe
→ new home page last) that this index's "run in parallel" framing contradicts; and plan 2's payment
"current state" was six weeks stale — a real customer had already paid via live Stripe before this
index was written. All three plans have been corrected in place (see each plan's own CORRECTION
block). This index adds a **David decision register** below to surface what actually needs your call
before agents execute further, rather than embedding unverified assumptions in the plans themselves.

## The five component plans

| # | Component | Plan | Current status |
| --- | --- | --- | --- |
| 1 | Marketing home page | `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` | Not started |
| 2 | Payment flow | `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` | In progress (TASK-0023 mostly built, blocked) |
| 3 | Content pipeline (question templates) | `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` | In progress, pipeline gap |
| 4 | Student hub | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` | Not started (audit) |
| 5 | Subject onboarding gate | `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` | Day-1 = Biology + Statistics; both passing criterion 6 (Statistics' hazard resolved 2026-09-25); both open on labels/difficulty |

Each plan is independently assignable to a different AI agent. Read dependency notes inside each plan
before assuming full parallelism — see **Dependency map** below.

## Dependency map

- **Content pipeline (3)** blocks **Subject onboarding gate (5)**: criteria 3 (validated labels) and
  5 (difficulty) in the servability checklist require the two-model-agreement pipeline that plan 3
  builds. An agent can start plan 5 immediately on the criteria that don't depend on the pipeline
  (canonical answers, exam-pack-version hygiene), but cannot close a subject's remaining two criteria
  until plan 3 ships.
- **Payment flow (2)** is gated on remaining decisions, not code: BIZ-001's pricing is partially decided
  (`DECISION-0068`) but access duration, refunds/discounts, parent-purchaser handling, and the
  unlimited tier remain open, owned by David Bloom. The Stripe mechanics are otherwise close to done.
  An agent can close every acceptance criterion in plan 2 except the ones that require those remaining
  BIZ-001 questions and the live-account bundle-price update.
- **Marketing home page (1)** and **Student hub (4)** have no hard dependency on the other three and
  can run fully in parallel with everything else.
- Payment flow (2) should not advertise/sell a bundle containing a subject that hasn't passed the
  Subject onboarding gate (5) — BIZ-001 already states this as a policy requirement.
- **Marketing home page (1) is gated on Student hub (4) reaching Phase 4 of the rebuild plan**, per
  David's recorded sequence (app → marketing reskin → Stripe → new home page last) — this reverses the
  original "runs fully in parallel" framing for plan 1 specifically. Plan 4 (audit) and the underlying
  rebuild execution are not the same thing; the gate is on rebuild Phase 4, not on plan 4's audit
  finishing. See decision **D-1** below.
- **Content pipeline (3) and Subject onboarding gate (5) share one table** (`SUBJECT_SERVABILITY_CRITERIA.md`'s
  "Applied so far") — plan 3 owns criteria 3/5 updates to it, plan 5 owns criteria 1/2/4/6, to avoid two
  agents overwriting the same row concurrently.

## David decision register

Every open decision surfaced across all five plans, in one place, so agents can cite `D-n` instead of
re-describing it. Plans link back here rather than each carrying a duplicate open-questions list.
Updated 2026-09-26 with David's responses (`DECISION-0069`) — resolved items kept for traceability,
struck through.

| ID | Decision | Status |
| --- | --- | --- |
| D-1 | Does the rebuild's app→marketing-reskin→Stripe→home-page-last sequence still hold, or should the five launch plans run in parallel? | **Open, now urgent** — see the sequencing-vs-1-week-window tension flagged below. |
| D-2 | Which frontend is the actual launch target — the `web/` Vite rebuild or the live Lovable app (`exam-buddy-wireframe`)? | **Open.** Plan 4 cannot proceed without this. |
| D-3 | Must the unit-gated practice path work for launch, or is the label-free FRQ path sufficient for Day 1? | **Already decided for Biology** (`DECISION-0063`, 2026-09-24: FRQ path only, unit-gated deferred as FF-3). **Open for AP Statistics** — does the same policy extend to it now that it's also Day-1? |
| D-4 | ~~AP Statistics' dual-published-exam-pack-version hazard~~ | **Resolved 2026-09-25**, before this index was drafted — pilot pack retired (`docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`). This index and plan 5 had it wrong as an open Day-1 hazard; corrected. |
| D-5 | ~~Unlimited-subject pricing tier at launch~~ | **Resolved (`DECISION-0069`): deferred until all 10 subjects are live.** Not priced or enabled at initial launch. |
| D-6 | Is the 2-subject bundle price ($79.99, effectively no discount vs. two singles at $79.98) intentional? | **Still open** — not addressed by `DECISION-0069`. |
| D-7 | ~~Target launch window~~ | **Resolved (`DECISION-0069`): next week.** See sequencing tension below. |
| D-8 | ~~Logo/wordmark finalization~~ | **Resolved (`DECISION-0069`): not a blocker.** Type-only wordmark is sufficient; no illustrated mark required. |
| D-9 | Shared vs. per-customer Stripe promotion code for the "add another subject" incentive. | **Open.** Blocks plan 2's coupon-build criterion. |
| D-10 | Seed the remaining 6 subjects into `Cramapple-Development`, or scope dev testing to the 4 already seeded? | **Open.** |
| D-11 | BIZ-001 remainder: access duration, refund/discount policy, parent-purchaser handling. | **Open.** |
| D-12 | ~~Live bug: `attempt-response` isn't gated on entitlement~~ | Still a live bug to verify/fix — status not yet reported back. Separately, David added new scope here (not the same D-12): **BYOQ ships ungated and anonymous on the home page** (`DECISION-0069`) — now launch-critical for plan 1, and raises privacy/rights/academic-integrity review needs flagged in that plan. |

**New, from `DECISION-0069`:** the 1-week target launch window (D-7) creates real tension with D-1's
rebuild sequencing and the still-open items above (D-1, D-2, D-6, D-9, D-10, D-11, the D-3 Statistics
question, and the entitlement bug). Recommend confirming with David whether "next week" means the
rebuild sequence is being compressed/overridden, or targets a narrower slice of scope than the full
five-plan definition of launch-ready above.

Items not yet needing your call (agents can proceed without you): everything else in each plan's
acceptance criteria.

## Definition of "app is launch-ready"

The app is ready to go live only when:

- All five component plans report **Done** per their own acceptance criteria, each meeting the bar in
  `docs/team_charter/DEFINITION_OF_DONE.md`.
- The day-one launch subjects — **AP Biology and AP Statistics** (`DECISION-0068`, 2026-09-26) — have
  passed all six criteria in `SUBJECT_SERVABILITY_CRITERIA.md` (tracked in plan 5). Remaining subjects
  fast-follow post-launch as confidence in site performance improves; no fixed date is set for them.
- BIZ-001 (pricing/access policy) has a recorded decision, not just a proposal — partially resolved by
  `DECISION-0068` (single/2-bundle/3-bundle pricing); access duration, refunds/discounts, and
  parent-purchaser handling remain open.
- This index itself has been updated to show all five rows as Done, with links to each plan's closing
  evidence (QA report, migration, or activity-log entry).

## How to use this as an AI agent

1. Read this index first to see which of the five is assigned to you and what it depends on.
2. Open your assigned plan. Do not start on a criterion flagged as blocked by another plan — check
   this index's dependency map first.
3. When you close a criterion, update your plan's status table with a citation (migration file, PR,
   or activity-log entry) — not just a checked box. Method note in every existing readiness doc in
   this repo: verify against live systems, don't infer from reading code or plans.
4. When your plan's own acceptance criteria are all met, update the status column in this index and
   say so explicitly in your handoff. Only the Main Conductor sets a task's status to `Done` per
   `AGENT_OPERATING_MODEL.md` — an implementation agent reports Ready for Review, it does not
   self-declare Done.
5. Do not touch BIZ-001's remaining open questions (access duration, refunds, parent-purchaser
   handling), the 2-bundle pricing anomaly (D-6), or any production Stripe/webhook configuration —
   those are Hard Gates for David. The AP Statistics exam-pack hazard is resolved — no action needed.

## Open questions for David

Superseded by the **David decision register** above (D-1 through D-12) — resolved as of 2026-09-26:
day-one subjects are AP Biology and AP Statistics (`DECISION-0068`), and single/2-bundle/3-bundle
pricing is set at $39.99/$79.99/$99.99. Everything still open is tracked in the register, not here.
