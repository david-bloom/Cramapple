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
| 5 | Subject onboarding gate | `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` | 1 of 10 subjects passing (AP Biology) |

Each plan is independently assignable to a different AI agent. Read dependency notes inside each plan
before assuming full parallelism — see **Dependency map** below.

## Dependency map

- **Content pipeline (3)** blocks **Subject onboarding gate (5)**: criteria 3 (validated labels) and
  5 (difficulty) in the servability checklist require the two-model-agreement pipeline that plan 3
  builds. An agent can start plan 5 immediately on the criteria that don't depend on the pipeline
  (canonical answers, exam-pack-version hygiene), but cannot close a subject's remaining two criteria
  until plan 3 ships.
- **Payment flow (2)** is gated on a decision, not code: BIZ-001 (pricing/access policy) is `Proposed`,
  owned by David Bloom. The Stripe mechanics are otherwise close to done. An agent can close every
  acceptance criterion in plan 2 except the ones that require BIZ-001 to be decided.
- **Marketing home page (1)** and **Student hub (4)** have no hard dependency on the other three and
  can run fully in parallel with everything else.
- Payment flow (2) should not advertise/sell a bundle containing a subject that hasn't passed the
  Subject onboarding gate (5) — BIZ-001 already states this as a policy requirement.

## Definition of "app is launch-ready"

The app is ready to go live only when:

- All five component plans report **Done** per their own acceptance criteria, each meeting the bar in
  `docs/team_charter/DEFINITION_OF_DONE.md`.
- At least the subjects intended for day-one launch have passed all six criteria in
  `SUBJECT_SERVABILITY_CRITERIA.md` (tracked in plan 5) — "launch with multiple subjects" means this
  index should name which subjects are in the day-one set once that's decided (currently undecided;
  flag to David).
- BIZ-001 (pricing/access policy) has a recorded decision, not just a proposal.
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
5. Do not touch BIZ-001's pricing/policy questions, the subject-count/day-one-launch-list decision, or
   any production Stripe/webhook configuration — those are Hard Gates for David.

## Open questions for David (blocking this index, not any one plan)

- Which subjects are in the day-one launch set? ("Launching with multiple subjects" — which ones?)
- Is the August 2026 date in MASTER_TODO's GTM-001 item superseded by a new target window?
- BIZ-001 pricing/access policy — still `Proposed`. Payment flow plan cannot fully close without it.
