# App Launch Readiness Index — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Approval Type:** Hard Gate for the launch decision itself; Standing Approval to draft/maintain this index.

## Current execution directive — October 2, 2026

The free launch date is **Friday, October 2, 2026**. For execution, use
`LAUNCH_RUNBOOK_2026_10_02.md` first. It is the concise October 2 critical path; this index and the
five component plans retain the broader commercial-launch context and historical corrections.

## Purpose

Cramapple has no single answer to "is the app ready to go live." Readiness lives scattered across
per-subject content docs, a Stripe task, UX design specs, and MASTER_TODO backlog items. This doc is
the index: it names the five component launch plans that together define "ready," and it is Done —
meaning the app is launch-ready — only when all five are Done.

This is deliberately the single doc TASK-0023 itself predicted would need to exist ("a consolidated
pre-launch checklist... cross-referencing BIZ-001, GTM-001, and TASK-0012") but never built.

## CORRECTION #3, 2026-09-26 (`DECISION-0071`): October 2 launch is free, no payment gating

**David set a firm date and changed the launch's shape: Friday, October 2, 2026, free, no
Stripe/payment gating.** Payment flow (plan 2) is **removed from the October 2 launch-critical path** —
it becomes a post-launch follow-up. This is a bigger change than the "next week" window from
`DECISION-0070`: not a paid launch delayed slightly, but a free launch with payment added later.
October 2's actual critical path is plan 5 (Subject onboarding gate, Biology + Statistics only), plan 4
(Student hub), and plan 1 (Marketing home page — now a free-access page, not a purchase page, plus the
BYOQ scope from `DECISION-0070`). Plan 3 is post-launch for these two subjects because both launch on
their flat practice paths under `DECISION-0063`/`DECISION-0072`; labels and difficulty remain necessary
before unit-gated practice is enabled. See `DECISION-0071` for full consequences. The five-plan
structure and "Definition of launch-ready" below still describe full commercial launch-readiness —
October 2's actual bar is narrower; don't confuse the two.

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
| 1 | Marketing home page | `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` | **CORRECTED 2026-09-27: not `d334fed9` (see D-2 correction below).** Live-verified against the actual production project (`61dd6602`, "New Cramapple Marketing"): ~5 of 13 criteria done (domain cutover live, correct design system, Bio/Stats "Live now," signup bypasses checkout). Open: BYOQ not shipped (upload buttons have no `onClick`, contrary to `DECISION-0070`'s launch-critical scope); `/signup` shows all 10 subjects "Available" instead of gating to Bio/Stats; an unsupported "maximum AP exam score" claim is still live; no end-to-end fresh-visitor verification done. Est. 2-4 hrs remaining. See memory `project_launch_plan_six_section_audit_2026_09_26.md`. |
| 2 | Payment flow | `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` | **Deferred, not October 2-critical** (`DECISION-0071`) — post-launch follow-up. Mechanically done and Stripe-verified live; blocked entirely on David's decisions (D-6/D-9/D-10/D-11), not engineering. **Not fully isolated from the free launch**: free and paid entitlements write to the same `app.subject_entitlements` table the grading gate reads. |
| 3 | Content pipeline (question templates) | `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` | **Done 2026-09-27 (TASK-0042):** all 216 earlier promotions verified fresh; difficulty complete for all ten live packs; all 141 current multi-unit candidates received blind Claude third review; 27 exact matches promoted and 114 non-confirmations safely retained. All-subject census has zero mismatches. Per `DECISION-0082`, fixed quantity targets remain Biology-only; other subjects maximize safely usable published inventory. Authoring/review workbench remains separately human-review-gated and outside this plan. |
| 4 | Student hub | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` | Shell/nav/account close to launch-ready; main gap is verification (real sign-in, entitlement-grant confirmation), not missing build. **Risk downgraded 2026-09-27 after read-only investigation** (see plan doc §"EXECUTED, 2026-09-27... item A"): the "no real student ever graded" fact is confirmed but is a timing/engagement artifact, not a broken pipeline — grading works end-to-end (QA account graded via the free `trial_v1` path 2026-09-23; zero failed grading rows). Residual gap is a fresh submit-to-grade round trip through the current `56cae479` UI, which needs David's live sign-in. GAP-9 measured same day: 0 masterable cells in either subject, blocked entirely on label promotion (GAP-1), not missing content (155 FRQ + 347 MCQ published-but-unresolved). `DECISION-0074` (mastery rule) recorded; implementation not started, blocked on the hint-definition-boundary decision — see `docs/product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md`. |
| 5 | Subject onboarding gate | `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` | **CORRECTED 2026-09-27 (see `APPROVAL-0051`'s correction and `ACTIVITY_LOG.md`): AP Statistics MCQ gap is now fixed and merged to Production** via `codex/task-0044-statistics-mcq` (PR #227) — not `claude/task-0047-ap-statistics-mcq-serving`, which this doc previously credited but which never reached Production. AP Biology: Pass. AP Statistics: FRQ Pass, MCQ now fixed at the backend layer; live student-UI verification (`LAUNCH_RUNBOOK_2026_10_02.md` item 4) still outstanding. Gate-as-process confirmed genuinely thin/reusable; 7 of the other 8 AP subjects already pass 4 of 6 servability criteria, ~1 agent-day each remaining on labels/difficulty. TASK-0044/the fix still need a fresh independent QA pass before Done. **TASK-0046, 2026-09-28: all 8 non-Day-1 subjects (Chemistry, Calc AB, Calc BC, Precalculus, Physics 1, Physics 2, Physics C: E&M, Physics C: Mechanics) live-verified — Pass on criteria 1/2/4/5/6, Partial on criterion 3 (validated-label coverage, TASK-0042's already-closed pipeline state). Unit-gated RPC reachable and non-zero for all 8 today. See `SUBJECT_SERVABILITY_CRITERIA.md`'s dated TASK-0046 section for full evidence. Post-launch scope only — does not change the October 2 Day-1 bar (Biology/Statistics).** |

Each plan is independently assignable to a different AI agent. Read dependency notes inside each plan
before assuming full parallelism — see **Dependency map** below.

## Dependency map

- **Content pipeline (3)** blocks full commercial/unit-gated completion of **Subject onboarding gate
  (5)** because criteria 3 (validated labels) and 5 (difficulty) require that pipeline. It does not
  block the October 2 flat-path launch for Biology or Statistics under `DECISION-0063`/`DECISION-0072`.
- **Payment flow (2)** is gated on remaining decisions, not code: BIZ-001's pricing is partially decided
  (`DECISION-0069`) but access duration, refunds/discounts, parent-purchaser handling, and the
  unlimited tier remain open, owned by David Bloom. The Stripe mechanics are otherwise close to done.
  An agent can close every acceptance criterion in plan 2 except the ones that require those remaining
  BIZ-001 questions and the live-account bundle-price update.
- **Marketing home page (1)** and **Student hub (4)** are verification/fix passes against the same
  existing live Lovable app. Coordinate their checks, but neither waits for a new page build.
- Payment flow (2) should not advertise/sell a bundle containing a subject that hasn't passed the
  Subject onboarding gate (5) — BIZ-001 already states this as a policy requirement.
- **The old page-build sequencing question is resolved for October 2.** `DECISION-0073` verified that
  the launch frontend and home page already exist and use the current design system. D-1 therefore
  does not gate the launch verification/fix pass; payment remains post-launch.
- **Content pipeline (3) and Subject onboarding gate (5) share one table** (`SUBJECT_SERVABILITY_CRITERIA.md`'s
  "Applied so far") — plan 3 owns criteria 3/5 updates to it, plan 5 owns criteria 1/2/4/6, to avoid two
  agents overwriting the same row concurrently.

## David decision register

Every open decision surfaced across all five plans, in one place, so agents can cite `D-n` instead of
re-describing it. Plans link back here rather than each carrying a duplicate open-questions list.
Updated 2026-09-26 with David's responses (`DECISION-0070`) — resolved items kept for traceability,
struck through.

| ID | Decision | Status |
| --- | --- | --- |
| D-1 | Does the rebuild's app→marketing-reskin→Stripe→home-page-last sequence still hold, or should the five launch plans run in parallel? | **Resolved for October 2:** the live launch app and home page already exist (`DECISION-0073`), so the launch work is a verification/fix pass, not a sequenced rebuild. Payment remains post-launch. |
| D-2 | Which frontend is the actual launch target? | **CORRECTED AGAIN, 2026-09-27: `DECISION-0073`'s identification was wrong.** Live DNS/`curl` against `cramapple.com` and `app.cramapple.com` (2026-09-27) shows they actually resolve to a **different** Lovable project, `61dd6602` ("New Cramapple Marketing"), not `d334fed9` ("Remix of Cramapple App," `ap-prep-canvas.lovable.app`) as `DECISION-0073` concluded. Every prior audit of "the launch frontend" (`TASK-0040`, its QA handoff, this plan) evaluated the wrong project. Plan 1's row above reflects a fresh audit against the correct one. **Lesson recorded in memory `project_launch_plan_six_section_audit_2026_09_26.md`: re-confirm the live project via DNS before trusting any doc's citation, even one dated the same day.** |
| D-3 | Must the unit-gated practice path work for launch, or is the label-free FRQ path sufficient for Day 1? | **Resolved for both Day-1 subjects.** Biology: `DECISION-0063` (2026-09-24). Statistics: `DECISION-0072` (2026-09-26, extends the same policy). Both launch flat-path; unit-gating deferred for both. |
| D-4 | ~~AP Statistics' dual-published-exam-pack-version hazard~~ | **Resolved 2026-09-25**, before this index was drafted — pilot pack retired (`docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`). This index and plan 5 had it wrong as an open Day-1 hazard; corrected. |
| D-5 | ~~Unlimited-subject pricing tier at launch~~ | **Resolved (`DECISION-0070`): deferred until all 10 subjects are live.** Not priced or enabled at initial launch. |
| D-6 | Is the 2-subject bundle price ($79.99, effectively no discount vs. two singles at $79.98) intentional? | **Still open** — not addressed by `DECISION-0070`. |
| D-7 | ~~Target launch window~~ | **Resolved (`DECISION-0071`, confirmed 2026-09-26): Friday, October 2, 2026, free, no payment gating.** Payment flow deferred post-launch. |
| D-8 | ~~Logo/wordmark finalization~~ | **Resolved (`DECISION-0070`): not a blocker.** Type-only wordmark is sufficient; no illustrated mark required. |
| D-9 | Shared vs. per-customer Stripe promotion code for the "add another subject" incentive. | **Open.** Blocks plan 2's coupon-build criterion. |
| D-10 | Seed the remaining 6 subjects into `Cramapple-Development`, or scope dev testing to the 4 already seeded? | **Open.** |
| D-11 | BIZ-001 remainder: access duration, refund/discount policy, parent-purchaser handling. | **Open.** |
| D-12 | ~~Live bug: `attempt-response` isn't gated on entitlement~~ | The gating bug itself was fixed 2026-09-20 (`attempt-response` now calls `authorize_grading_access`). **But a bigger, related risk was confirmed 2026-09-27: no real student has ever had a graded attempt complete in Production.** All 78 `grading_results` rows trace only to David, one QA account, and the pilot account; the one confirmed real student's two Biology FRQ attempts from 2026-08-22 are still ungraded a month later, contrary to an earlier assumption that this would "resolve on next retry." This directly contradicts `LAUNCH_RUNBOOK_2026_10_02.md`'s stop condition on a real submit-to-grade round trip and is not resolved by the entitlement fix alone — needs investigation before Oct 2, not just a smoke test. **INVESTIGATED 2026-09-27 (read-only Production, see `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` §"EXECUTED, 2026-09-27... item A"): the grading pipeline is NOT broken.** `grading_results` has zero failed/error rows; the `trial_v1` free-entitlement → submit → grade path is proven by the launch-QA account (FRQ graded 3/4 on 2026-09-23, two minutes after its trial grant). The two real students' non-grading is a timing/engagement artifact — `bkmicahb` attempted a month before any entitlement existed and never returned (trial expires today); `obloom27` has zero entitlements and only a draft. The residual risk narrows to a single unblocked-by-code item: a fresh real submit-to-grade round trip through the current `56cae479` UI, which requires David's live sign-in (D-12 is no longer a "grading might be broken" risk). Separately, David added new scope here (not the same D-12): **BYOQ ships ungated and anonymous on the home page** (`DECISION-0070`) — still unbuilt as of 2026-09-27 (see plan 1's corrected row). |

**Updated by `DECISION-0071` and the 2026-09-26 launch-date confirmation:** D-6, D-9, D-10, and D-11
are post-launch payment work. D-1 and D-2 are resolved for October 2 because `DECISION-0073` confirms
the existing live frontend and home page. The end-to-end new-user entitlement/grading smoke remains
an October 2 verification requirement even though payment is deferred: free access still has to grant
the entitlement that Production grading enforces.

Items not yet needing your call (agents can proceed without you): everything else in each plan's
acceptance criteria.

## Definition of "app is launch-ready"

The app is ready to go live only when:

- All five component plans report **Done** per their own acceptance criteria, each meeting the bar in
  `docs/team_charter/DEFINITION_OF_DONE.md`.
- The day-one launch subjects — **AP Biology and AP Statistics** (`DECISION-0069`, 2026-09-26) — have
  passed all six criteria in `SUBJECT_SERVABILITY_CRITERIA.md` (tracked in plan 5). Remaining subjects
  fast-follow post-launch as confidence in site performance improves; no fixed date is set for them.
- BIZ-001 (pricing/access policy) has a recorded decision, not just a proposal — partially resolved by
  `DECISION-0069` (single/2-bundle/3-bundle pricing); access duration, refunds/discounts, and
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
day-one subjects are AP Biology and AP Statistics (`DECISION-0069`), and single/2-bundle/3-bundle
pricing is set at $39.99/$79.99/$99.99. Everything still open is tracked in the register, not here.
