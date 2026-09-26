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

## The five component plans

| # | Component | Plan | Current status |
| --- | --- | --- | --- |
| 1 | Marketing home page | `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` | Not started |
| 2 | Payment flow | `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` | In progress (TASK-0023 mostly built, blocked) |
| 3 | Content pipeline (question templates) | `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` | In progress, pipeline gap |
| 4 | Student hub | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` | Not started (audit) |
| 5 | Subject onboarding gate | `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` | Day-1 = Biology + Statistics; Biology passing (FRQ path only), Statistics blocked on a Hard Gate |

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
   handling, unlimited-tier pricing), the AP Statistics exam-pack-version hazard, or any production
   Stripe/webhook configuration — those are Hard Gates for David.

## Open questions for David (blocking this index, not any one plan)

- ~~Which subjects are in the day-one launch set?~~ **Resolved 2026-09-26:** AP Biology and AP
  Statistics, per `DECISION-0068`. Remaining subjects fast-follow as site-performance confidence
  improves — no fixed trigger/date set; worth a follow-up decision if you want one.
- Is the August 2026 date in MASTER_TODO's GTM-001 item superseded by a new target window?
- BIZ-001 pricing/access policy — partially resolved (`DECISION-0068`: $39.99 / $79.99 / $99.99 for
  single / 2-bundle / 3-bundle). Still open: does the unlimited tier still exist at launch, and at what
  price (built catalog has it at $139.99)? Also flagged: the 2-bundle price ($79.99) is $0.01 *more*
  than two singles bought separately ($79.98) — effectively no bundle discount. Confirm this is
  intentional before the Stripe catalog is updated. Access duration, refunds/discounts, and
  parent-purchaser handling also remain open in BIZ-001.
