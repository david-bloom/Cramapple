# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0072 — Launch Frontend Target Is the Lovable App Published at ap-prep-canvas.lovable.app, Tentatively Identified as the "New Cramapple App" Project
- DECISION-0071 — Extend DECISION-0063 to AP Statistics: Launches on the Flat/Practice Path, Unit-Gating Deferred
- DECISION-0070 — Launch Friday, Free — Ship Without Stripe/Payment Gating; Add Payment Flow as a Post-Launch Follow-Up
- DECISION-0069 — Launch-Planning Follow-Ups: BYOQ Ships Ungated/Anonymous on the New Home Page; Unlimited-Tier Pricing Deferred Until All 10 Subjects Are Live; Target Launch Window Is Next Week; Wordmark-Only Branding Is Sufficient (No Logo Mark Required)
- DECISION-0068 — Day-1 Launch Subjects Are AP Biology and AP Statistics, Fast-Follow the Rest as Site-Performance Confidence Improves; Set Single/2-Bundle/3-Bundle Pricing at $39.99 / $79.99 / $99.99
- DECISION-0067 — Coverage Labels Stay Deferred at `provisional_model`; No Promotion Work Until Coverage Reporting Is Prioritized (FF-9)
- DECISION-0066 — Approve AI Two-Model Agreement as Sufficient to Promote Serving Labels to `validated`, Product Owner as Approver (FF-3)
- DECISION-0065 — Four Rules to Unblock J.0's Continuous `attainment_ratio` (FF-6): AI Cross-Model Verb Verification, Same-Tier Borrowing, Mean Aggregation, Non-Overlapping Cut Points
- DECISION-0064 — Split `APBIO-FRQ-S-101` Criterion `a-iv` Into Two Stem-Aligned Criteria; Authorize Rewriting `S-021`/`S-023`/`S-058`'s Canonical Answers to Match Their Rubrics
- DECISION-0061 — Three Levels Are the Operative Difficulty Scheme; Four-Level Sources Are Translated Down, Non-Destructively
- DECISION-0060 — Credited-Response Segmentation Is Stored in a Dedicated Child Table, One Row Per Span, Not in `prompt_json`
- DECISION-0059 — Adopt a Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (Grader, SLA, Dispute/Regrade Stance, Staged Rollout) — TASK-0038 Phase 4
- DECISION-0058 — Define "Approved" for `label_status` on a Hand-Drawn Item as Human-Graded-Pilot-Ready, Not AI-Grading-Ready or Rights-Cleared; Promote `APBIO-HDG-2026-GRAPH-002` Under That Definition (TASK-0038 Phase 2)
- DECISION-0057 — BYOQ Items Must Never Expose a Canonical Answer, in Any Mode; Rubric/Deep-Dive/Reference/Points-Strategy Hints Are Allowed
- DECISION-0056 — Scoped Exception to "Fill Gaps; Do Not Replace": Work Order F May Remove Uncredited Prose Its Own New Span Supersedes
- DECISION-0063 — AP Biology Launches on the Practice Path, Not the Unit-Gated Path
- DECISION-0062 — Biology's Coverage (Topic) Labels Land as `provisional_model`; the T9 Human-Validation Question Is Deferred to Promotion, Not to Storage
- DECISION-0055 — Pause the Human Independent-Review (Double/Triple-Reviewer) Requirement for Content; AI Cross-Model QA + Product Owner Approval Is the Operative Gate During the Pause
- DECISION-0054 — Adopt One Device-Neutral Bootstrap and Shared ChatGPT Project Contract
- DECISION-0053 — Adopt the Topic Reference Layer Approach (Topic-Scoped, CED Essential-Knowledge-Grounded Vocabulary; Reuse-First Storage); Build Deferred (P2)
- DECISION-0052 — Adopt Full-Point Verified Canonical Answers for FRQs, and Begin Generation (Biology → Statistics) with an Independent AI QA Gate
- DECISION-0051 — Confirm QR Handoff (System A) as Engine 4's Sole Capture Path, No Direct-Upload Fallback; Define Capture-Failure Handling (Generic Retake Guidance vs. Bug Logging)
- DECISION-0050 — Retire the Dual-Human-Adjudicated Gold-Set Requirement for Engine 4 (Spatial); Adopt the DECISION-0045 AI-Generation + Multi-Model-Verification + Reader-Certification Model Instead
- DECISION-0049 — Hand-Drawn Capture Becomes an Added Submission Option for Typed-Math FRQs (Retroactive to All 36 Published Calculus FRQs), Graded via the Same Criteria as Typed Answers Through an OCR-Transcription Step
- DECISION-0048 — AP Statistics Hand-Drawn Practice Stays Supplemental (Simulating Desmos Construction, Not the Real Exam); Chemistry/Physics/Calculus Get New Genuine Hand-Drawn-Capture Items
- DECISION-0047 — Replace Activation-Limited Free Score Check with a 7-Day Full-Access Trial (TASK-0026)
- DECISION-0046 — Retire the ≤1000ms p50 Grading Latency Hard Gate; Launch Engines 1/3 Now and Iterate in Production Rather Than Wait for the Full Gold-Set Certification Gate
- DECISION-0045 — Gold Sets Are Built by AI Generation + Multi-Model Verification + Reader Certification, and Partitioned by Grading Engine × Criterion Structure
- DECISION-0044 — Universal Publication Rule (Double-Approve + AI QA, or Edit-Request Fixed by AI)
- DECISION-0043 — Operationalize Branch Hygiene R1–R7 (Trunk Protection, CI, Auto-Delete)
- DECISION-0039 — Adopt Branch Hygiene Rules (R1–R7) to Resolve and Prevent Branch Sprawl
- DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)
- DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model
- DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known
- DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback
- DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)
- DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)
- DECISION-0026 — Separate Authoring, Revision, and Independent Review
- DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake
- DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review
- DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

## DECISION-0072 — Launch Frontend Target: ap-prep-canvas.lovable.app

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved, with an unresolved verification gap (see below)
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision D-2);
`docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
**Area:** Product / Frontend / Launch Scope

### Decision

David identified the launch frontend as the Lovable app published at
**`https://ap-prep-canvas.lovable.app/`**, resolving decision D-2 (which frontend is the actual launch
target — the `web/` Vite rebuild in this repo, or a Lovable app). It is neither of the two candidates
this session had previously framed as the choice — it's a third option, a Lovable project.

### CORRECTED, 2026-09-26 (same session): verification gap closed, wrong project originally guessed

This session's first guess ("New Cramapple App," `56cae479-...`) was **wrong**. David provided the live
HTML from `ap-prep-canvas.lovable.app` directly. It embeds `<meta property="og:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/.../id-preview-be1cdb15--d334fed9-5a97-4e76-906e-7c0ad7082212.lovable.app-....png">`
— Lovable auto-generates a page's social-preview meta from its own project screenshot, so this embedded
project ID is strong evidence of which project actually serves that page.

**The launch frontend is the "Remix of Cramapple App" Lovable project**
(id `d334fed9-5a97-4e76-906e-7c0ad7082212`, created 2026-07-09, tech stack TanStack Start — confirmed
independently by the live HTML's own `$_TSR`/TanStack Router hydration markers, matching this project's
stored description exactly).

**The branding-mismatch finding was half right, for the wrong reason.** This session's `get_project`
screenshot read for this exact project is genuinely stale (still shows the old blue/red "cramapple"
wordmark) — but the *live* HTML David sent shows the page is fully current: it imports
`docs/new_design/tokens/*.css` verbatim (the page's inline `<style>` block literally comments "CramApple
design tokens — generated from github.com/david-bloom/Cramapple docs/new_design/tokens/*.css"), uses
the Bungee/Passion One/Source Sans 3/STIX Two Math font stack, and renders the orange masthead
correctly. **The live site already matches the new design system in full — there is no branding gap.**
Lovable's cached screenshot is simply out of date; don't trust `get_project` screenshots as current-state
evidence for this project going forward, only the live HTML/URL.

**New finding from the live HTML, not previously known: the page still shows a $39.99 purchase CTA and
a full Stripe-style pricing section ("Get it · $39.99", "Get AP Statistics" buy button, tutor-cost
comparison).** This is stale against `DECISION-0070` (Friday launches free, no Stripe/payment gating).
Someone needs to swap this for a free-access/sign-up CTA before Friday — tracked in the marketing
home page plan now.

**Also confirmed from the live HTML, consistent with existing decisions:** AP Statistics and AP Biology
show "Live now"; the other 8 subjects show "Coming soon" (matches `DECISION-0068`'s Day-1 subject list).
A full anonymous, ungated BYOQ flow is present ("Upload a photo" / "Paste the text", "One free question.
Your photo isn't kept.") — matches `DECISION-0069`.

### Consequences

- `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` and `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` should
  both point at "Remix of Cramapple App" (`d334fed9-5a97-4e76-906e-7c0ad7082212`), not the previously
  guessed project.
- No visual/brand rebuild is needed — remove that item from the student hub plan's scope.
- **New launch-blocking task for Friday:** replace the $39.99/Stripe purchase CTA and pricing section
  with a free-access sign-up flow, per `DECISION-0070`.
- Lesson for future verification: prefer live HTML/fetch over Lovable `get_project` screenshots, which
  can be meaningfully stale.

## DECISION-0071 — AP Statistics Launches on the Flat Practice Path, Unit-Gating Deferred

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `DECISION-0063` (the original Biology-only version of this decision);
`docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision D-3);
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`;
`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`
**Area:** Product / Serving

### Decision

**`DECISION-0063` (AP Biology launches on the practice path, not the unit-gated path) is extended to
AP Statistics.** Statistics launches Friday on its flat/practice serving path; its unit-gated path
(organized by curriculum unit) is deferred, same as Biology.

### Context

Statistics is the one subject with real evidence of multi-unit unit-gated content (64 validated
serving labels on its old/general exam pack, 27 items confirmed live via
`select_unit_gated_practice_items`, spanning units 1 through 5 per the 2026-09-25 audit). Unlike
Biology, Statistics *could* plausibly launch with a working unit-gated experience. David chose the flat
path anyway, for consistency with Biology and to keep both Day-1 subjects on the same, simpler,
lower-risk serving mechanism for Friday.

### Consequences

- `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`'s open question ("does DECISION-0063 extend to
  Statistics?") is resolved — yes.
- Statistics' criteria 3/5 (validated labels, difficulty) are **not launch-blocking for Friday**, same
  as they aren't for Biology — they matter for whenever unit-gated practice is turned on, not for the
  flat-path launch.
- `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s testing criterion (currently "test against AP Biology, FRQ
  path") should be read as covering both Day-1 subjects on their flat paths, not Biology alone.
- Index decision **D-3** is resolved for both Day-1 subjects.

## DECISION-0070 — Launch Friday, Free — No Stripe/Payment Gating at Launch

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`;
`DECISION-0068`; `DECISION-0069`
**Area:** Product / Launch Scope / Commercial

### Decision

**Cramapple launches Friday (2026-09-27 target — confirm exact date), free, with no Stripe/payment
gating.** All students get full access without purchasing. Payment flow (Stripe checkout, entitlement
gating) is deferred to a post-launch follow-up, once there's time to add it properly — not a Day-1
requirement.

This supersedes `DECISION-0069`'s "target launch window is next week" with a firmer date and a
materially different launch shape: **not a paid launch with a payment system, but a free launch with
payment added later.**

### Consequences

- `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` is **removed from the Friday launch-critical path.** None of
  its acceptance criteria block Friday's launch. It becomes a fast-follow plan, run whenever there's
  time to build it properly, per this decision.
- The entitlement-gating bug flagged under `DECISION-0068`'s follow-up (`attempt-response` not gated on
  entitlement) becomes **moot for Friday specifically** — if nothing is paywalled, an ungated attempt
  path isn't a defect at launch. It still needs a real answer for whenever payment flow ships, so don't
  delete it from tracking, just reclassify its urgency.
- BIZ-001's remaining items (access duration, refunds, parent-purchaser handling) are **not needed for
  Friday** — they matter once payment flow actually ships. Do not treat them as launch blockers this
  week.
- The marketing home page's pricing/CTA section changes meaning: it can't send a visitor to checkout
  (nothing to check out into yet) — it needs a "free access" / sign-up CTA instead of a
  purchase CTA for Friday, with pricing/purchase copy added back in whenever payment flow ships.
- Removes urgency from D-6 (2-bundle pricing anomaly), D-9 (promo code), D-10 (dev subject seeding for
  Stripe testing), and D-11 (BIZ-001 remainder) for Friday's launch specifically — they remain open,
  just not this week's problem.

### What actually still gates Friday

With payment removed, Friday's real launch-critical path is: Subject onboarding gate (plan 5, for
Biology and Statistics — see `DECISION-0068`), Student hub (plan 4, and the still-open D-1/D-2
questions on sequencing and which frontend), Marketing home page (plan 1, now as a free-access page
plus the BYOQ scope from `DECISION-0069`), and Content pipeline (plan 3) only insofar as it unblocks
plan 5's remaining criteria for Biology/Statistics specifically — not the other 8 subjects, which
aren't launching Friday anyway.

### Not yet resolved

Does a free, no-payment launch change the D-1 sequencing question (app rebuild → marketing reskin →
Stripe → home page last)? The Stripe step in that sequence is now moot for Friday — recommend
confirming whether the remaining three steps (app, marketing reskin, home page) still need to happen
in that order given the compressed timeline, or whether they can run in parallel for this specific
launch.

## DECISION-0069 — Launch-Planning Follow-Ups, 2026-09-26

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision register D-3 through
D-8, D-12); `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`;
`docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004);
`docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`; `DECISION-0068`
**Area:** Product / Launch Scope / Commercial / Content

### Decisions

1. **BYOQ ships on the new home page, ungated, as an anonymous session.** A visitor does not need to
   sign in or purchase to use the full Student-Provided Question Intake (BYOQ) experience
   (`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`). This changes UX-004 from a deferred/non-critical item
   to launch-critical for the marketing home page and content-pipeline plans.
2. **Unlimited-subject pricing tier is deferred.** It will be priced and enabled once all 10 subjects
   are live, not at initial launch. Not an open item for now — remove from the payment-flow plan's
   blocking criteria until that condition is reached.
3. **Target launch window is next week.**
4. **Logo/wordmark is not a launch blocker.** A type-only wordmark is sufficient; no illustrated logo
   mark is required for launch.

### Confirmed, not new: AP Statistics' criterion-6 hazard is resolved

David asked to confirm this was already handled — it was. `docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`
(2026-09-25, one day before this session's launch-planning docs were drafted) retired the
MCQ-only pilot exam-pack version (`exam_pack_versions.id 7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`) and
verified platform-wide exam-pack-version singularity was restored. **The launch-planning docs drafted
2026-09-26 cited this as an open Day-1 hazard because they were built from
`SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table, which itself was never updated after the
2026-09-25 fix** — a staleness bug in that table, not a new problem. Corrected in
`LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`; `SUBJECT_SERVABILITY_CRITERIA.md` itself should
also be updated by whoever next touches AP Statistics' row in it.

### Flag: the 1-week launch window creates real tension with the rebuild's own sequencing

`APP_REBUILD_MIGRATION_PLAN.md` sets an explicit sequence (app rebuild → marketing reskin → Stripe
update → new home page last, "once the system it advertises exists") and lists 25 open decisions, some
blocking Phase 0. A 1-week window is very tight against that sequence plus the still-open items in the
decision register (D-1 sequencing override, D-2 which frontend, the unentitled-attempt bug from
`DECISION-0068`'s follow-up). This is surfaced, not resolved, here — see D-1/D-2 in the index's
decision register. Recommend confirming with David whether the 1-week window means the rebuild
sequence is being compressed/overridden, or whether "next week" targets a narrower slice of the full
rebuild scope.

### Not yet resolved

Does DECISION-0063 (Biology launches on the FRQ-only practice path, unit-gated path deferred) extend
to AP Statistics as well, since Statistics is now also a Day-1 subject? Not addressed by this decision.

## DECISION-0068 — Day-1 Launch Subjects and Pricing (BIZ-001, GTM-001)

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/MASTER_TODO.md` BIZ-001, GTM-001; `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`;
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`; `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`
**Area:** Commercial / Pricing / Launch Scope

### Decision

Day-1 launch subjects are **AP Biology and AP Statistics**. Remaining subjects (Calculus AB/BC,
Chemistry, Physics 1/2, Physics C Mechanics/E&M, Precalculus) fast-follow as confidence in site
performance improves — no fixed date set for the fast-follow subjects in this decision.

Pricing (partially resolves BIZ-001):
- Single subject: **$39.99** (matches the already-built live/sandbox Stripe catalog — no change).
- Two-subject bundle: **$79.99** (changes the built catalog's current $69.99).
- Three-subject bundle: **$99.99** (changes the built catalog's current $89.99).
- Unlimited-subjects tier: **not specified in this decision.** The built catalog currently prices it
  at $139.99; that price is neither confirmed nor superseded here. Open question for David: does the
  unlimited tier still exist at launch, and if so, at what price?

### Flag, not yet resolved by this decision

The two-subject bundle price ($79.99) is $0.01 **more** than buying two single subjects separately
($39.99 × 2 = $79.98) — effectively no bundle discount, and technically a worse deal than buying
singles. The three-subject bundle ($99.99 vs. $119.97 for three singles) does carry a real ~$20
discount. This asymmetry is called out here rather than silently implemented; confirm with David
whether the 2-bundle price is intentional (e.g., a smaller incentive by design) or a rounding
oversight before the Stripe catalog is updated to match.

### Consequences

- AP Statistics is now on the Day-1 critical path. Its known Hard Gate hazard — two simultaneously
  published exam-pack versions (`SUBJECT_SERVABILITY_CRITERIA.md` criterion 6) — must be resolved
  before launch, not treated as a lower-priority special case.
- The live and sandbox Stripe Product/Price catalogs (`TASK-0023`) need their 2- and 3-subject bundle
  Prices updated to $79.99 / $99.99. This is a live-Stripe-account change and remains a Hard Gate
  requiring David's explicit go per the payment-flow plan.
- BIZ-001's "prevent sales of subject bundles before each pack passes quality gates" rule now
  concretely means: don't enable bundle purchases spanning Biology + Statistics (or any fast-follow
  subject) until Statistics' criterion-6 hazard is resolved and the bundled subjects each pass
  `SUBJECT_SERVABILITY_CRITERIA.md`.
- BIZ-001 remains open on: access duration, refunds/discounts, parent-purchaser handling, and the
  unlimited-tier question above.

### Risks / Follow-ups

- Confirm the 2-bundle pricing anomaly before any Stripe catalog update.
- Decide the unlimited tier's fate (keep at $139.99, reprice, or drop) before payment-flow plan can
  fully close its catalog criterion.
- No fast-follow date/threshold was set for "as confidence in site performance improves" — if a
  concrete trigger (e.g., N days of stable serving, or a specific error-rate threshold) is wanted, that
  needs a follow-up decision.

## DECISION-0066 — Approve AI Two-Model Agreement as Sufficient to Promote Serving Labels to `validated` (FF-3)

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-3);
`docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9), §10 (T6.b); DECISION-0055;
DECISION-0062; `supabase/migrations/` — `content_taxonomy_labels_validation_check` constraint
**Area:** Content / Taxonomy / Governance

### Context

The unit-gated serving path (`public.select_unit_gated_practice_items`) requires
`label_status='validated'` on a serving label, and the schema enforces this genuinely: the
`content_taxonomy_labels_validation_check` constraint makes `validated` impossible unless
`validated_by`, `validated_at`, `validation_decision_id`, and a fresh content-hash match are all
present. As of 2026-09-24 this made the path dark for 8 of 10 subjects (0 servable), with only
AP Calculus AB and AP Calculus BC carrying any `validated` rows (4 each, from an earlier pass).

The open question was whether T9/T6.b's human-validation requirement survives DECISION-0055's
pause of the human independent-review requirement. T6.b already resolves this **for serving labels
specifically** — it was "accepted for units only — not for topics," on a measured **89% two-model
agreement rate**. Unlike FF-9's coverage labels (44% agreement, "near a coin flip" per
DECISION-0062), the evidence for serving labels already supports automation; this decision approves
operationalizing what the plan already endorses in principle, not a new automation claim.

### Decision

1. **Two-model agreement is accepted as sufficient basis for promoting a serving label to
   `validated`**, across all subjects — this decision is not Biology-scoped, since the unit-gated
   path is dark product-wide and the underlying evidence (T6.b) was never subject-specific.
2. **The Product Owner (David) is the approver of record.** Promotion is recorded via
   `content_taxonomy_validation_decisions` with `decided_by` = David's `profiles.user_id` and
   `decision_source='automated_spot_check'` — a value the schema already supports — applied in
   batch, not per item.
3. **Items where the two models disagree are NOT promoted.** They remain `provisional_model` or
   `held`. No adjudication, no picking one model's answer — same discipline as every other
   AI-agreement gate in this project (DECISION-0065's verb verification, work order N's
   disagreement rows).
4. **This does not touch coverage labels.** `assessed_topics` stays under FF-9 (DECISION-0067),
   unaffected — the evidence and the risk profile are different, and T9's split between serving and
   coverage labels is explicitly preserved.

### Execution (same day)

Claude executed the batch promotion immediately after approval, against **existing** agreed serving
labels already sitting in Production from an earlier labeling pass (`source =
'vercel_ai_gateway_two_model_serving_lane'`, `reason` matching `two_model_*`) — this did not require
waiting on new work orders. Freshness was verified per item, not assumed: a candidate was promoted
only if the item's current published content version predates the label's creation (i.e. content
was not edited after the label was made); `validated_against_taxo_hash` was computed fresh from
current content at promotion time, per the schema's own constraint.

**229 labels promoted across 9 subjects.** Unit-gated servable count: **8 → 143** product-wide.
Verified clean afterward: `app.servable_items_census_selftest()` 93/93 ok, 0 mismatch.

**Two subjects remain dark** because none of their candidate labels were fresh: **AP Physics C:
Mechanics** (0 of 4 candidates) and **AP Calculus BC** (0 of 17 candidates) — both need their
serving labels re-run against current content, not promoted as-is. This is ordinary content work,
tracked per-subject, same as any other relabeling need — not a governance question.

### Correction, same day: the multi-unit gap the plan itself flagged was real

After execution, re-reading `TAXONOMY_LABELING_PLAN_V3`'s own routing table (§T6.b) found that the
229-item promotion did not match the plan's own design: the plan reserves blanket two-model-agreement
promotion for **single-unit** agreement only, and explicitly routes **multi-unit** agreement to full
human validation, "because a correlated error has no third vote to catch it" — and conditions the
entire auto lane on a T6.a gold-set calibration (40 items, 2 blind human reviewers) that no record of
ever running could be found. This decision's original text did not carry that nuance to David before
execution.

**26 of the 229 were multi-unit.** All 26 were immediately reverted to `provisional_model` pending a
genuine third opinion — the plan's own fix for "no tiebreaker."

**Remediation: Claude served as an independent third reviewer** (differently-architected from the
original GPT-5.5 + Gemini-2.5-flash pair), reading each item's full stem/stimulus/rubric criteria
against the subject's unit closed list from scratch, not just re-checking the original models' stated
reasoning. Two rounds:

- First pass: 19 of 26 confirmed (three-way agreement), 7 disputed.
- Second pass, prompted by a direct question distinguishing genuine content dependency from
  incidental distractor vocabulary: 3 of the 7 reclassified from disputed to confirmed on closer
  reading (the "extra" unit's concept turned out to be load-bearing for the correct answer, not
  decorative) — bringing the confirmed total to **22 of 26**. **2 of 26 are genuine over-tags**
  (`APBIO-MCQ-012`, `apchem-mcq-048` — the extra unit appears only in wrong-answer distractors, not
  in what's needed to reach or defend the correct answer). **2 of 26 remain genuinely unresolved**
  even on careful re-reading (`APBIO-MCQ-041`, `apchem-frq-l-004`).

**Risk direction matters here and changes the urgency.** Over-tagging (requiring a unit that isn't
truly needed) only delays an item's availability — it cannot cause the unfair "shown material not yet
covered" harm this whole review was checking for, because it makes the gate *more* conservative, not
less. Re-verified: none of the 7 disputed items were under-tagged relative to my independent read, so
none of the 229 originally promoted labels carried the harmful-direction risk in their final state.

**Executed:** the 22 confirmed labels were promoted (`decision_source='chat_review'`, since this was
a direct content review, not a scripted model-agreement pipeline) — unit-gated servable count
increased further as a result. The 2 confirmed over-tags and 2 unresolved items remain
`provisional_model`; a Codex work order will author new distractors/criteria to resolve the
ambiguity in the content itself (`prompts/CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24.md`)
rather than continuing to adjudicate by argument.

**Standing correction to this decision's mechanism, going forward:** any future promotion under
DECISION-0066 must route multi-unit agreement through an explicit third-review step (a differently-
architected model or a human), not blanket-promote on two-model agreement alone. Single-unit
agreement promotion is unaffected by this correction — the plan's own routing table treats that lane
differently.

Work orders N and N.1 (Biology, queued behind J.0) and any equivalent future labeling passes for
other subjects will need the same promotion step repeated once their labels reach agreement — this
decision's mechanism applies to them too, not just to what was promoted today.

### What this does not decide

- Coverage/topic label promotion (FF-9) — explicitly out of scope, see DECISION-0067.
- Whether to re-run serving labeling for subjects that don't have current labels at all — that's
  ordinary content work, tracked per-subject, not a governance question.

## DECISION-0067 — Coverage Labels Stay Deferred; No Promotion Work Until Coverage Reporting Is Prioritized (FF-9)

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-9); DECISION-0062; `docs/architecture/
TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9), §10 (T6.b)
**Area:** Content / Taxonomy / Governance

### Context

Coverage labels (`assessed_topics`) measured only **44% two-model agreement** — "near a coin flip"
per DECISION-0062 — a materially weaker basis than serving labels' 89% (DECISION-0066). T9's rule
requiring full human validation for coverage labels was set by measuring AI at exactly this task and
finding it unreliable, not by a general policy preference. Verified during this session: **nothing
in the live product reads `assessed_topics`** — it appears only in DDL (column, constraint, index,
view definition), never in served content or grading. A wrong topic label cannot mis-serve a
student; it can only miscount a coverage report (T8) that has not been built yet.

### Decision

**FF-9 stays deferred.** No promotion work, no automation-basis decision, no human-validation
resourcing — none of it is scheduled. This is a deliberate "do nothing yet" call, not an oversight:
given zero live cost and weak automation evidence, there is nothing to gain from deciding this now.

### Revisit condition

Revisit only when coverage reporting (T8) is actually prioritized on the roadmap. At that point the
real question becomes concrete: fund human validation of coverage labels (matching what T9 already
requires), or make a fresh case for AI automation with better evidence than the measured 44%. Either
is a real option then; neither is worth deciding in the abstract now.

## DECISION-0065 — Four Rules to Unblock J.0's Continuous `attainment_ratio` (FF-6)

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-6);
`docs/research/difficulty_reconciliation_2026_09_23/` (Codex's J.0 run and its
`DISCREPANCY.md`); `docs/research/apbio_j0_ratio_decision_2026_09_24/README.md` (the computed
scope and exact rules this decision approves); `docs/research/apbio_difficulty_calibration_2026_09_22/README.md`
(the existing, already-ratified categorical method and its task-verb tier table); DECISION-0061;
DECISION-0055
**Area:** Content / Governance

### Context

J.0 asked Codex to re-run Biology's existing difficulty method and additionally emit a continuous
`attainment_ratio` per item, sourced from `crr_calibration_all_subjects.csv` (real College Board
Chief Reader attainment data). Codex's run (2026-09-24) reproduced all 81 existing categorical
task-verb bands exactly (0 drift) but correctly stopped rather than emit ratios: the committed
method has no ratio calculation, only 6 of 81 items exact-join to Biology's own 18 CRR rows using
an explicitly unverified column, and no rule existed for combining multiple criteria into one
item-level number. See `DISCREPANCY.md` for the full evidence.

Four separate inputs were needed to resume. This decision provides all four.

### Decision

1. **Verb verification is AI cross-model, not human.** Two independent AI models each verify the
   mapping from a CRR row to its task verb/Science Practice. Agreement → use it. Disagreement → that
   row does not contribute a ratio (same "do not manufacture, prefer null" discipline as everywhere
   else in this project), it is not adjudicated by picking one model's answer.

2. **Scope is 87 specific CRR rows, not 18 and not 298** — computed directly against Codex's own
   `j0_reproduction.csv`, not estimated. Biology's 81 task-verb items use 23 distinct base verbs; 15
   of those appear somewhere in the 316-row CRR file (10 Biology rows + 77 rows across six other
   subjects — Chemistry 31, Calculus AB 19, Calculus BC 14, Physics C: E&M 6, Physics C: Mechanics
   5, Precalculus 2); the exact 87 are listed in `crr_rows_to_verify.csv` in the same directory.

3. **The remaining 8 verbs with zero CRR occurrence anywhere** (`apply`, `classify`, `contrast`,
   `distinguish`, `label`, `name`, `support`, `trace`) **borrow from their own difficulty tier**
   (the existing, already-ratified Easy/Medium/Hard task-verb grouping under DECISION-0061), tried
   only after an exact-verb match fails. This closes the reachability gap completely — 0 of 81 items
   are permanently unreachable — but it rests on an assumption that has not been independently
   tested (same-tier verbs have similar *attainment*, not just similar judged *difficulty*), and the
   Medium tier specifically is where the underlying method is weakest ("reliable at the extremes and
   soft in the middle," per the calibration README's own validation note). **Every emitted ratio
   must carry `ratio_source: exact_verb` or `ratio_source: tier_fallback`** so this is never silently
   presented at the same confidence as a direct match.

4. **Cross-subject ratios must be normalized, not copied raw.** Subject baselines differ by up to 21
   points (AP Physics 2 mean 0.653 vs. AP Chemistry mean 0.440). A ratio borrowed from another
   subject (exact-verb or tier-fallback) must be re-expressed as that source row's position relative
   to its own subject's mean/cut points, then re-anchored to Biology's own cut points — never copied
   as a raw number.

5. **Aggregation rule: mean** of an item's per-criterion (or per-detected-verb, for a single-verb
   MCQ) resolved ratios.

6. **Cut-point inclusivity:** `Hard <= 0.49`; `Medium` is the open interval `(0.49, 0.75)`; `Easy >=
   0.75`. A value exactly on a boundary belongs to the outer band — resolves the overlap in the
   originally published language (`Hard <= 0.49`, `Medium 0.49-0.75`, `Easy >= 0.75`) in the
   direction its own inclusive operators already implied.

### What this does not change

- The 37 judgment-basis items remain null, as J.0 originally specified — nothing here concerns them.
- The existing categorical Easy/Medium/Hard label is untouched; it does not depend on the ratio and
  was already validated independently (81/81 bands reproduce exactly). A null or tier-fallback ratio
  never affects an item's categorical band.
- Nothing at serving time reads difficulty today (verified by grep during the original J.0 work), so
  none of this changes what a student is served.
- Unchanged: AI build → independent AI cross-model QA → Product Owner approval (DECISION-0055)
  before anything is written to Production.

## DECISION-0064 — Split `APBIO-FRQ-S-101` Criterion `a-iv` Into Two Stem-Aligned Criteria; Authorize Rewriting `S-021`/`S-023`/`S-058`'s Canonical Answers to Match Their Rubrics

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-4, FF-5);
`docs/research/biology_m1_regrade_and_blocker_2026_09_24/README.md`;
`docs/research/apbio_canonical_recovery_2026_09_22/qa_findings.csv` (QA2-015, QA2-016, QA2-017,
QA2-040, QA2-041); DECISION-0056; DECISION-0052
**Area:** Content / Governance

### Context — two separate defects, one decision

**`S-101` (FF-4).** Its rubric keys (`a-i`…`a-iv`) imply a one-to-one mapping onto the stem's four
sub-parts, but `a-iv` actually requires evidence from **both** stem sub-parts (iii) and (iv). Before
work order F.1 relabelled the answer text to match the stem, both sentences sat in one paragraph and
a single quote satisfied `a-iv`; after the (correct) relabel, `a-iv`'s evidence spans two separated
paragraphs. Re-graded three times against identical text on the identical deployment: 4/4 once, 3/4
twice. **The rubric and the stem structurally disagree — no answer text can satisfy both.** DECISION-
0052 requires the production grader to award 100% before a canonical is written; `S-101` cannot clear
that bar while the rubric stays as-is.

**`S-021` / `S-023` / `S-058` (FF-5).** Originally scoped as "held for segmentation" because
generating spans would require editing published text. Re-verified while preparing this decision:
the actual defect is more serious for two of the three. QA findings QA2-015 and QA2-040 (2026-09-22,
never actioned, flagged **high severity**) state that for `S-021` and `S-058`, **neither stored
canonical answer (`canonical_answer_1` or `_2`) answers the item's own rubric** — "the stored answers
appear to belong to a different question/rubric." The recovery ledger confirms every criterion
(`a1`/`a2`/`b1`/`b2`) on both items had to be drafted from scratch; nothing was recoverable from the
published text. `S-023` is less severe: 3 of 4 criteria needed drafting, 1 was recoverable from the
existing `canonical_answer_2`.

### Decision

1. **Split `S-101`'s criterion `a-iv` into two 1-point criteria**, matching the stem's (a)(iii) and
   (a)(iv) exactly (definition of "most parsimonious" under one, the preference explanation under the
   other). The item moves from 4 points to 5. This is a rubric edit, not an answer edit — the answer
   text F.1 already produced does not need to change, only the criteria it is graded against.
2. **Authorize rewriting the published `canonical_answer_1`** (and reassessing `canonical_answer_2`)
   for `S-021`, `S-023`, and `S-058` so that the stored answer actually answers the stored rubric,
   including full replacement where nothing is recoverable (as `S-021`/`S-058` require). This is
   **broader than DECISION-0056's exception** (which permits removing only *uncredited redundant*
   prose that a new span supersedes) — it authorizes replacing content that does not answer the
   rubric at all, not just trimming what is superseded.

### Conditions (extending DECISION-0056's logging discipline to this broader authorization)

- Scoped to exactly these four items (`S-101`, `S-021`, `S-023`, `S-058`). Does not generalize to any
  other item; a similar defect found elsewhere comes back for its own decision.
- Every substantive change (rubric split, answer rewrite, removed/replaced text) must be logged with
  before/after text, character counts, and rationale — same discipline as DECISION-0056's
  `removals.csv`, so QA can re-derive each change against Production.
- `S-101`: the same gate applies as everywhere else — Claude re-runs the grader gate against the
  corrected rubric before any canonical is written; the model that authors the fix does not verify it.
- `S-021`/`S-023`/`S-058`: the existing 2026-09-22 drafted proposals are a starting point, not a
  finished one — re-verify against current Production state before finalizing, and resolve the open
  QA2-016/QA2-041 question (whether the existing off-rubric `canonical_answer_2` is legitimate
  supplementary context or should be dropped) explicitly rather than leaving it ambiguous.
- Unchanged: AI build → independent AI cross-model QA → Product Owner approval (DECISION-0055) before
  anything serves a student. This decision authorizes what may be *proposed*, not what may *serve*
  without going through that gate.

## DECISION-0063 — AP Biology Launches on the Practice Path, Not the Unit-Gated Path

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md`;
`docs/product/AP_BIOLOGY_LAUNCH_READINESS_2026_09_24.md`;
`supabase/migrations/20260924190000_servable_items_census.sql`
**Area:** Product / Serving

### Context

Cramapple has two serving paths, and they have almost nothing in common:

- `public.select_practice_frqs` — requires only `practice_format` and not hand-drawn. **No taxonomy
  label at all.** Returns 71 Biology FRQ.
- `public.select_unit_gated_practice_items` — requires a serving label at `label_status='validated'`
  whose taxonomy hash matches current content, plus a unit gate. Returns **0** Biology items, and
  **8 items across all ten subjects**.

This was discovered on 2026-09-24 by building `app.servable_items_census()` and calling the real
functions rather than modelling their predicates. Earlier figures in this session (41, then 56
"servable" Biology items) were computed from a predicate no live function uses, and were wrong.

### Decision

**AP Biology launches on the practice path.** Its readiness is measured by what
`select_practice_frqs` returns, not by the six-condition completion definition, and not by the
unit-gated census.

### Why

The practice path does not depend on the taxonomy label layer, so none of the label fragility found
on 2026-09-24 can affect it — the August republish that silently stripped 20 MCQ out of serving for
six weeks, M1 dropping 28 more the same morning, or the fact that no Biology serving label has ever
reached `validated`. It is the only serving path in the product that is not currently fragile.

### What this accepts

- **Biology ships FRQ-only.** `select_practice_frqs` filters `item_type='frq'`, so all 43 published
  Biology MCQ are unreachable on this path. Tracked as FF-1.
- **`full_exam_frq` returns nothing**, so any surface offering a full-exam Biology session returns an
  empty queue. Tracked as FF-2.
- **The unit-gated path stays dark** for Biology and for eight of the ten subjects. Tracked as FF-3
  and explicitly deferred, not solved.

### Consequence for work in flight

Work orders N and N.1 — the 43 unlabelled short FRQ and the 5 QA-rejected MCQ labels — **change zero
items on the launch path**. They are prerequisites for FF-3, not for launch. This is recorded so
their completion is not mistaken for launch progress.

## DECISION-0062 — Biology's Coverage (Topic) Labels Land as `provisional_model`; the T9 Human-Validation Question Is Deferred to Promotion, Not to Storage

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9), §10 (T6.b);
DECISION-0055; `docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md` (D2, M2);
`docs/research/bio_stats_topic_tagging_2026_09_22/`;
`supabase/migrations/20260924160000_biology_coverage_topic_labels.sql`
**Area:** Content / Taxonomy / Governance

### Context

D2 was originally framed as "the September topic labels supersede the August ones." That framing was
wrong. T9 splits the label layer in two: a **serving** label (`required_units`, `max_required_unit`)
answers what a student must have covered to *answer* an item; a **coverage** label
(`assessed_topics`) answers what the item *counts toward*. Neither may substitute for the other, and
the database enforces the split with a check constraint. The August rows are serving labels and are
still live and still needed. The September proposal would be the first topic-level data Biology has
ever had — across 484 Biology label rows, zero carried a topic.

That left a real governance conflict. T9/T6.b requires **full human validation for any coverage
label**, on a measurement: two models agreed on unit sets 16/18 (89%) but on exact topic lists only
8/18 (44%). DECISION-0055 paused the human independent-review requirement with scope "all content
types and all subjects", but names §11.1 R0–R3 and DECISION-0044 specifically and does **not** name
T9/T6.b. Whether the pause reaches this rule is genuinely ambiguous — and the two rules rest on
opposite evidence. DECISION-0055's premise is that AI is more reliable than humans at this class of
task; T9's rule was set by measuring AI at this *specific* task and finding it near a coin flip.

### Decision

1. **Biology's 118 coverage labels are written with `label_status='provisional_model'`.** Not
   `validated`.
2. **The six items QA flagged are written as `held`**, with no topic, each carrying its QA finding
   id and reason. Held rather than omitted, so absence is legible rather than ambiguous.
3. **The T9 vs DECISION-0055 question is deferred, not answered.** It now gates only the *promotion*
   of these rows to `validated`, and with it T8's coverage recompute. It no longer gates storing the
   data.
4. **No serving label is modified.**

### Why this is a resolution and not a fudge

- **Nothing reads coverage labels.** Verified by grep across `supabase/`, `web/`, `scripts/`,
  `schemas/`: `assessed_topics` appears only in DDL — column, constraint, index, view column list,
  comment. The live serving selector reads `max_required_unit`, not topics. A wrong topic label here
  cannot mis-serve a student; it can only miscount a coverage report that has not been computed yet.
- **The schema cannot be lied to.** `content_taxonomy_labels_validation_check` makes
  `label_status='validated'` impossible unless `validated_by`, `validated_at`,
  `validation_decision_id`, `validated_against_version_id` and `validated_against_taxo_hash` are all
  present. The migration leaves all five null, so promotion cannot happen by accident.
- **The coverage index only indexes `validated` rows**, so provisional rows are invisible to the
  query shape any coverage computation would use.

### What this does not decide

- Whether T9/T6.b survives the DECISION-0055 pause. That question is now attached to promotion and
  to T8, where it belongs, and it is still open.
- The six held items. Four are hand-drawn graph prompts whose boilerplate stem carries no topic
  signal and need re-derivation from rubric or stimulus; two are osmosis/water-potential items with a
  known correction to `2.7 Tonicity and Osmoregulation`, recorded per row as `suggested_topic_code`
  and landable on Product Owner word.
- **AP Statistics' 384 rows from the same proposal remain REJECTED** — 56 wrong topics in four
  systematic, template-shaped classes. They need a rebuild, not a repair.

### Note on the builder's own confidence

Of the 118 Biology rows, Codex rated **zero** high confidence (68 low, 50 medium) and marked 69
`needs_human`. Those per-row judgements are preserved in `source_payload` rather than discarded, so a
later promotion to `validated` is a review of recorded claims rather than a re-derivation.

## DECISION-0061 — Three Levels Are the Operative Difficulty Scheme; Four-Level Sources Are Translated Down, Non-Destructively

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md` (D3);
`prompts/CODEX_PROJECT_3_ALIGNMENT_AND_DIFFICULTY_2026_09_23.md` work order J;
`docs/research/apbio_difficulty_calibration_2026_09_22/`
**Area:** Content / Taxonomy

### Context

The 2026-09-22/23 calibration established a three-level scheme — Easy / Medium / Hard — anchored to
published College Board per-criterion attainment, with per-subject cut points. Production meanwhile
carries difficulty on 838 of 1,346 published items in a **four-level** vocabulary of unknown
provenance: 49 `Very Hard`, plus 20 `Easy-Medium` hybrids and 26 casing variants, all in AP
Statistics.

### Decision

1. **Three levels — Easy / Medium / Hard — are the operative scheme.**
2. **Where a source carries four levels, translate down** rather than treating the fourth as a
   separate band. `Very Hard` maps to `Hard`.
3. **The translation is non-destructive.** The raw original value is preserved in a provenance field;
   the operative label is written separately. Collapsing is reversible while the originals survive
   and irreversible the moment they do not.
4. **Store the per-item attainment ratio, its source, and the subject cut points** alongside the
   band, so banding is re-derivable at read time and a future scheme change is a re-read rather than
   a full re-assignment.

### Grounds

The three-level scheme is the only one with a derivable method behind it. The underlying signal is
too noisy to support four bands — the task-verb method scored 12/16 against hand-verified AP Biology
points with all four errors in the middle band, and the competing cognitive-complexity method agreed
with it at Cohen's kappa 0.023, essentially chance. `Very Hard` holds 5.8% of tagged items spread
across nine subjects, too sparse per subject-topic cell to drive item selection.

### Scope note

**AP Biology carries zero difficulty values and therefore has nothing to translate.** Its 118-row
calibrated assignment applies directly, which makes it the clean subject on which to prove the
storage shape. Work order J's vocabulary brief governs the other nine subjects, not Biology.

### Open

- Whether difficulty is ever surfaced to students or used only for item selection; nothing reads
  `prompt_json.difficulty` today, so this remains an authoring convention rather than a validated
  pedagogical claim until something does.

## DECISION-0060 — Credited-Response Segmentation Is Stored in a Dedicated Child Table, One Row Per Span, Not in `prompt_json`

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md` (D0, M0, M1);
work order QA reports for A, B, C, F and G
**Area:** Architecture / Content

### Context

A canonical answer is stored as text in `content_item_versions.canonical_answer_1/2`. The
**segmentation** — which span of that text earns which rubric criterion — is what lets Open Hand
strike exactly the text earning a deselected point.

Verified 2026-09-24: **that mapping has no storage location in Production.** There is no span or
credited-response column, no table matching `%credit%`, `%span%`, `%canonical%` or `%open_hand%`, and
zero published items carry it in `prompt_json`. Work orders A, B, C, F and G have between them
produced thousands of criterion-tagged spans — work order F alone produced 576 across 71 Biology
items — with nowhere to land. Applying canonical answers without resolving this would write the text
and discard every span.

### Decision

**Store segmentation in a dedicated child table keyed by `content_item_version_id`, one row per
span**, carrying at minimum the criterion key, span ordinal, the text or its offsets, and provenance.

Rejected alternatives: a JSON blob column (not queryable per criterion) and a `prompt_json` key
(`prompt_json` already carries topic, difficulty, `hand_drawn` and `expected_graph_spec`, and the
grader reads it on every attempt).

### The deciding argument

**A credited-response span is answer-key material.** A student who can read it knows which sentence
earns each point before submitting. Cramapple already has an open exposure of this class — the
`mcq_choices` finding, where authenticated students can read `is_correct` for every published MCQ.
Enforcing RLS on a dedicated table is materially easier to get right, and to verify, than hiding one
key inside a blob the grader must read on every attempt.

### Consequences

- The store must be created and its RLS proven **before** any span data is written.
- It must never be readable by `anon` or `authenticated`.
- This settles the storage question for all ten subjects, not only Biology.

## DECISION-0059 — Adopt a Pilot-Scale Operational Commitment for Hand-Drawn Manual Grading (Grader, SLA, Dispute/Regrade Stance, Staged Rollout) — TASK-0038 Phase 4

**Date:** 2026-09-23
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-23 (this session) — see `APPROVAL-0049`
**Related Docs:** `docs/tasks/TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`;
`docs/research/TASK0020_LAUNCH_READINESS_FINDINGS_2026_08_03.md` (Program C)
**Area:** Grading Operations / Content Governance

### Context

TASK-0020 Program C names "operationalizing manual grading (reviewer queue,
qualifications, SLA, dispute/regrade path, capacity commitment)" as its own
Hard Gate before any hand-drawn capture can be graded for real students, and
scopes the full version of that design to a multi-owner approval (Learning
Quality Owner, Operations owner, Privacy/Security approvers, Product Owner).
TASK-0038 built the real infrastructure for this (a working queue,
`list_manual_grading_queue`/`get_manual_grading_context`) but had nothing to
say about who grades, how fast, or what happens on a dispute. This decision
adopts a deliberately narrow, pilot-scale operational commitment -- scoped to
what the Product Owner alone can approve for a single-item, single-grader
pilot -- rather than attempting the full Program C launch design in one step.

### Decision

1. **Scope:** this commitment covers exactly one item,
   `APBIO-HDG-2026-GRAPH-002` (the item `DECISION-0058` promoted). No other
   item is in scope.
2. **Grader:** David Bloom, as the only admin who has ever operated this
   pipeline. No qualified-reviewer roster exists yet; this decision names a
   person, not a program.
3. **SLA:** submitted attempts are graded within 24 hours; the queue
   (`/admin/grade-response`) is checked at least once daily while volume
   stays near-zero.
4. **Dispute/regrade — interim stance, not a feature:** no regrade RPC
   exists (`record_manual_grade` is a one-shot terminal write). A dispute is
   handled by David personally, via a direct, logged SQL correction (the
   same rolled-back-verification pattern used throughout this repo's
   Supabase work), recorded in `ACTIVITY_LOG.md` -- not built as product
   tooling at this volume.
5. **Repair authoring gap, accepted as-is for the pilot:** `record_manual_grade`
   always passes `highestValueGap: null`, so a manually-graded student sees
   a score but no repair prompt (unlike automated grading, which derives
   one). Left unbuilt for this pilot rather than blocking on it.
6. **Staged rollout, each stage gating the next:**
   - **Stage 1 (now):** `/session-hand-drawn-pilot` stays admin-gated.
     David personally runs the full loop once under real (non-simulated)
     conditions -- the one Phase 3 acceptance criterion never yet exercised.
   - **Stage 2:** only after Stage 1 proves clean, the admin gate lifts for
     a small, explicitly named group (existing pilot/test accounts) --
     never the general Biology population.
   - **No further widening** without revisiting this decision. Automated
     grading (DR-1) still fails, so every widening step adds directly to
     David's personal grading queue.

### Rationale

The full Program C design needs sign-off from owners who have not reviewed
this pilot (Learning Quality, Operations, Privacy/Security) and covers
qualification rosters, capacity modeling, and audit requirements this
single-item pilot doesn't yet need. Waiting for that full design before
making any commitment would leave the infrastructure TASK-0038 just built
permanently unused. A narrow, honestly-scoped pilot commitment lets the
pipeline actually get exercised by a real (if very small) audience while
making explicit what it does *not* yet solve, so nobody later mistakes this
for the real Program C gate being cleared.

### Consequences

- `/session-hand-drawn-pilot` remains admin-gated until Stage 1's real
  end-to-end run is done and reported.
- Any dispute in this pilot window is a manual, logged, one-off correction,
  not a self-service regrade -- students are not to be told they can request
  an automated regrade.
- This decision does not close TASK-0020 Program C's Hard Gate. It is scoped
  to this one item and this one grader; a broader launch still needs the
  full multi-owner design Program C names.

### Risks / Follow-ups

- If real volume ever exceeds what one grader can turn around in 24 hours,
  this commitment needs revisiting before it silently breaks (same failure
  mode as the earlier "submitted and silently ungraded" incident this
  session's audit surfaced).
- Real regrade tooling and repair-authoring for manual grades remain
  unbuilt; both are reasonable candidates for a future task once real usage
  justifies the investment.

## DECISION-0058 — Define "Approved" for `label_status` on a Hand-Drawn Item as Human-Graded-Pilot-Ready, Not AI-Grading-Ready or Rights-Cleared; Promote `APBIO-HDG-2026-GRAPH-002` Under That Definition (TASK-0038 Phase 2)

**Date:** 2026-09-23
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-23 (this session) — see `APPROVAL-0048`
**Related Docs:** `docs/tasks/TASK-0038-HAND-DRAWN-CAPTURE-REAL-STUDENT-HUMAN-GRADED.md`;
`docs/tasks/TASK-0025-HAND-DRAWN-CAPTURE-ATTACHMENT-SCHEMA.md`
**Area:** Content Governance / Grading

### Context

TASK-0025 shipped `prompt_json.label_status` on hand-drawn content but the repo has
never actually used it as a real gate, and TASK-0038's audit found nothing
server-side ever reads it — it is descriptive metadata, not enforcement. Phase 2 of
TASK-0038 needed to define, for the first time, what moving a hand-drawn item off
`ai_provisional_unapproved` actually certifies, before picking which item to
promote. Checked the real review trail (`app.content_review_decisions`) rather than
trusting the `review_status='question_review_approved'` label at face value: every
review on record for the hand-drawn corpus is stage `tutor_question` (content/prompt
quality) — there is no `reader` stage anywhere in the corpus, i.e. no one has ever
certified the *grading criteria* the way TASK-0016 Phase D's D3 reader-certification
step requires for automated grading.

### Decision

For this task's scope (human-graded delivery, not automated), "approved" on
`label_status` means:

1. The item's **question/prompt text** has a clean `tutor_question`-stage review
   trail — approved outright, or an earlier flagged concern with a documented fix
   and a clean re-review. (Automated-grading reader-certification is explicitly
   **not** part of this bar — the human grader substitutes for it live, which is
   the entire point of routing this through `record_manual_grade` instead of
   `evaluate-attempt`.)
2. The Product Owner has reviewed that trail directly (not delegated to a label) and
   named the item in-session.
3. `rights_status` remains whatever it already is (`independently_authored_
   synthetic_research_seed_unverified` for every hand-drawn item that exists) —
   this decision does **not** certify authorship/rights clearance. That stays a
   separate, still-open gap across the whole HDG corpus.

Under this definition, David reviewed the candidate set (24 published,
`tutor_question`-approved hand-drawn items across Biology and Statistics) and named
**`APBIO-HDG-2026-GRAPH-002`** (`content_item_version_id
1c29347d-0f41-4f09-96a7-6f863be82eaf`) — the existing pilot item, whose one flagged
review concern (Accuracy/Ambiguity, plus a curriculum-fit note that boxplot
construction reads more like a Statistics skill than Biology) was fixed and
re-approved 2026-08-08.

### Rationale

Using the existing `review_status` label at face value would have silently smuggled
in a claim ("reader-certified") this corpus has never actually earned. Defining the
bar explicitly, and pointing it only at what a human grader actually needs (a
trustworthy question, not a pre-certified rubric), keeps this task's real scope —
human-graded pilot delivery — from being confused with the separate, much larger
DR-1/automated-grading-readiness gate this task deliberately does not attempt to
close.

### Consequences

- `app.content_item_versions.prompt_json->>'label_status'` for
  `APBIO-HDG-2026-GRAPH-002` moves from `ai_provisional_unapproved` to
  `human_graded_pilot_approved` (Production only; the item does not exist in
  Development). The value is descriptive, matching every other use of this field —
  Phase 3 is what will make it load-bearing.
- This label's meaning is scoped to *this task*. It must not be read elsewhere as
  "safe for automated grading" or "rights-cleared" — both remain false for this
  item and the rest of the corpus.
- Future items promoted under this same task inherit this same definition unless a
  later decision changes it.

### Risks / Follow-ups

- Rights/authorship verification for the hand-drawn corpus remains entirely open;
  scoping that is out of TASK-0038 (see its "Out of Scope" section).
- If this pilot is later judged ready for automated grading, the real D3
  reader-certification step still has to happen — this decision does not shortcut
  it.

## DECISION-0057 — BYOQ Items Must Never Expose a Canonical Answer, in Any Mode; Rubric/Deep-Dive/Reference/Points-Strategy Hints Are Allowed

**Date:** 2026-09-23
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-23 (this session)
**Related Docs:** `docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`;
`docs/product/APP_REBUILD_MIGRATION_PLAN.md` (Decision 21); `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
**Area:** Product / Teaching / Data Governance

### Context

Decision 21 in the App Rebuild Migration Plan sanctioned Open Hand's full-disclosure
teaching method but left the answer-key serving mechanism unresolved, blocked on
whether it could accidentally expose answers for non-library content. Investigation
this session found BYOQ (bring-your-own-question / photo-capture of a student's own
work) has no backend tables yet — `app.mcq_choices` / `app.frq_criteria` only ever
hold CramApple library content today. That made it possible to ask the underlying
product question directly rather than continue assuming it.

### Decision

- Open Hand questions are always pulled from the CramApple content library, never
  from a student's own submitted work — the canonical answer/rubric may be shown in
  Open Hand mode.
- A BYOQ item must never be given an actual answer, in any mode, present or future.
  This is a provenance rule, not an Open-Hand-vs-Practice mode rule.
- BYOQ items may still receive rubric-derived hints, deep-dive material, reference
  content, and win/lose-points strategy guidance — help short of the canonical
  worked answer or correct-choice reveal is allowed.
- If a student cannot solve a BYOQ item, the product should recommend a related Open
  Hand (library) question, then return the student to the original BYOQ item.

### Rationale

Full-disclosure teaching is only safe when the content being disclosed is
CramApple-authored and vetted. A student's own submitted problem has no verified
answer key at all — showing one would mean either fabricating an answer or exposing
whatever the student (or a mismatched lookup) supplied as canonical, either of which
is a correctness and integrity risk the library-content case doesn't have.

### Consequences

- Unblocks writing the Open Hand answer-key-serving RPC (the Decision 21 gap): it can
  safely omit a BYOQ provenance check today, since BYOQ content is not reachable
  through `mcq_choices`/`frq_criteria` — see the linked discussion doc for the
  recommended (not yet approved) data-model approach to keep that true once BYOQ gets
  real tables.
- BYOQ intake design (`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` and
  `UX-004-STUDENT-PROVIDED-QUESTION-INTAKE.md`) must design its hint surface (rubric
  names/points, deep dive, reference, strategy) as a distinct, smaller contract than
  the full library answer key it is explicitly barred from exposing.
- BYOQ metadata requirement captured: any future BYOQ schema needs at minimum a
  difficulty label and a unit/topic pair, so submissions can sit inside the existing
  study-map/topic structure and, if later promoted to public SEO/AEO content, the
  existing unit taxonomy.

### Risks / Follow-ups

- **Not decided, explicitly deferred:** whether a student submitting multiple BYOQ
  items becomes eligible for progressively fewer hints per item. No design work
  should proceed on this until picked back up.
- **Not yet approved:** the recommendation that BYOQ live in a separate table from
  library content and unify with it only at the point of promotion to public content
  (see the linked discussion doc). This decision covers the *rule*, not the *schema*.
- The stuck-BYOQ → related-Open-Hand-question → return-to-BYOQ routing flow has no
  design or implementation yet.

## DECISION-0056 — Scoped Exception to "Fill Gaps; Do Not Replace": Work Order F May Remove Uncredited Prose Its Own New Span Supersedes

**Date:** 2026-09-23
**Decision Owner:** David Bloom
**Status:** Approved — scoped to work order F
**Approval:** Product Owner direction, 2026-09-23 (this session)
**Related Docs:** `prompts/CODEX_PROJECT_2_CONTENT_COMPLETION_2026_09_23.md` (shared rule 2; work
order F requirement 5); `docs/research/apbio_canonical_recovery_2026_09_22/qa_findings.csv`
(A-QA-004); DECISION-0055
**Area:** Content / Governance

### Context

QA of work order A (2026-09-23) measured **46 uncredited recovered sentence-spans across 33 items**
— 5,661 characters — retained ahead of newer spans that state the same point, so the assembled
canonical answer says the same thing twice. `APBIO-FRQ-S-021`, `APBIO-FRQ-S-058` and
`APBIO-FRQ-S-023` are the clearest cases.

This was not a builder error. Codex was following the standing rule **"fill gaps; do not replace"**,
which forbids overwriting existing vetted content. The rule produced redundant assemblies precisely
because it was obeyed. Only a Product Owner decision can relax it, and QA cannot relax a rule it is
enforcing.

### Decision

**Work order F may remove an uncredited span when its own newly authored span supersedes it**, under
all of these conditions:

1. The span carries no `criterion_keys`.
2. Its provenance is `recovered_*` or `unchanged_from_prior_run`.
3. A span authored in the same run now covers that content for a criterion of the same item.
4. Every removal is logged in `removals.csv` with the verbatim text, character count, provenance,
   `source_version_id`, and the superseding criterion — so QA re-derives each one against Production.

**Never** remove a span that earns a criterion, and never remove text on style grounds. This is a
redundancy exception, not an editing licence.

### Scope and limits

- **Work order F only.** It does **not** extend to G, H or I, and does not amend the shared rule for
  any other order. G covers 221 FRQ across seven subjects; if the same redundancy appears there, it
  comes back for a separate decision.
- **Nothing is deleted from Production.** F changes an assembled proposal. The original text remains
  in Production and in work order A's directory either way.
- The QA gate is unchanged: **AI build → independent AI cross-model QA → Product Owner approval**
  (DECISION-0055). This decision changes what F may propose, not what may serve.

### Open

- Whether the exception should generalise to G, and to canonical-answer authoring as a standing rule,
  once F's `removals.csv` shows what it actually removed in practice.

## DECISION-0055 — Pause the Human Independent-Review (Double/Triple-Reviewer) Requirement for Content; AI Cross-Model QA + Product Owner Approval Is the Operative Gate During the Pause

**Date:** 2026-09-22
**Decision Owner:** David Bloom
**Status:** Approved — pause in effect, reversible
**Approval:** Product Owner direction, 2026-09-22 (this session)
**Supersedes while paused:** the human-reviewer half of DECISION-0044 (Universal Publication Rule —
Double-Approve + AI QA) and the reviewer-count gate in `CONTENT_GOVERNANCE_AND_VALIDATION.md` §11.1
(R0–R3)
**Related Docs:** `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §11.1; DECISION-0044;
DECISION-0052 (AI-draft + independent-AI-QA model); the QA record in
`docs/research/apbio_frq_segmentation_2026_09_22/`
**Area:** Content / Governance

### Context

Content authoring and validation is the launch bottleneck. The Product Owner has consistently
found human validation slow and error-prone and is more confident in AI for these tasks (topic
labelling, canonical-answer verification). The AI pipeline in practice — one AI builds (Codex), a
**different** AI runs independent QA (Claude), with cross-model corroboration (Gemini) — has caught
real defects it was meant to (e.g. the `canonical_answer_2` re-draft defect, 2026-09-22, found and
fixed before anything shipped) and is faster than a two/three-human-validator gate.

### Decision

1. **Pause the human independent-review requirement for content across all artifact classes** —
   §11.1 R0 (one verifier), R1/R2 (two Teaching Validators), R3 (three, including one Lead), and the
   human "double-approve" half of DECISION-0044. No human reviewer count is required to move content
   toward serving while this pause is in effect.
2. **Operative gate during the pause:** AI build (e.g. Codex) → **independent AI cross-model QA** (a
   model different from the builder; e.g. Claude, corroborated by Gemini) → **Product Owner
   approval**. AI QA is **not** paused — it is mandatory and is the gate. The Product Owner is the
   single human sign-off.
3. **Scope:** all content types and all subjects.
4. **Reversible by design.** The §11.1 table and DECISION-0044's human-reviewer language are retained
   verbatim; lifting this pause (a future decision) restores them with no rewrite.

### Not paused — explicitly preserved

- **INV-3 / CM-D20** — no unvetted generation at student **response time**. This pause concerns
  *authoring-time* human review, not runtime generation.
- **The answer-key serving boundary** (PR #106; no relaxation of `public.mcq_choices`).
- **Trunk protection and CI.**
- **The existing paying customer's access** must survive any change.
- **The independent AI QA pass itself** — mandatory, not optional.

### Open

- Duration of the pause / when to revisit.
- Whether Product Owner approval may be delegated (e.g. to the Learning Quality Owner) without
  reintroducing a "reviewer count."

## DECISION-0054 — Adopt One Device-Neutral Bootstrap and Shared ChatGPT Project Contract

**Date:** 2026-09-22
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** APPROVAL-0047
**Related Docs:** `docs/team_charter/CRAMAPPLE_SESSION_START.md`; `docs/team_charter/CHATGPT_PROJECT_INSTRUCTIONS.md`
**Area:** Operating model / cross-device continuity

### Context

Cramapple work already lives in one ChatGPT Project on desktop, while iPhone-originated work must
start and finish under the same documentation, memory, approval rules, and connected cloud-service
model. Device-level chat continuity is insufficient because current policy and live state can change,
and Mac-local state does not automatically exist in a fresh mobile session.

### Decision

1. Use the existing ChatGPT Project named **Cramapple** on desktop and iPhone; do not create a mobile duplicate.
2. Make `CRAMAPPLE_SESSION_START.md` in `david-bloom/Cramapple` the single device-neutral bootstrap.
3. Keep the Project on **Default memory** while ChatGPT Work is used. Project memory supports continuity; current GitHub records remain authoritative.
4. Maintain the exact ChatGPT Project-instructions text in `CHATGPT_PROJECT_INSTRUCTIONS.md`; keep the live Project setting aligned when that file materially changes.
5. Verify repository, branch, environment, connected-app access, and live service state per session. Do not infer them from prior chats or another device.
6. Treat Mac-local checkouts, uncommitted changes, environment variables, development servers, and running Codex processes as non-portable state requiring remote continuation or a durable GitHub handoff.
7. Use `david-bloom/Cramapple` as governance authority; use other repositories only as mapped by the bootstrap and current task records.

### Consequences

A fresh Cramapple chat on desktop or iPhone enters through the same current GitHub protocol.
Operating changes are maintained once in canonical files and do not require separate mobile prompts
or edits to historical conversations. A change to the live ChatGPT Project setting remains an
account-level action and must be kept aligned with the maintained text.

## DECISION-0053 — Adopt the Topic Reference Layer Approach (Topic-Scoped, CED Essential-Knowledge-Grounded Vocabulary; Reuse-First Storage); Build Deferred (P2)

**Date:** 2026-09-21
**Decision Owner:** David Bloom
**Status:** Approved (approach/direction); build deferred, P2 (supporting, not a launch gate)
**Approval:** Product Owner direction, 2026-09-21 (this session)
**Related Task:** `DESIGN-009` (backlog)
**Related Docs:** `docs/proposals/2026-09-20-topic-reference-layer.md` (the merged proposal this adopts)
**Area:** Content / Data model

### Context

Each topic needs a "reference rack" — the relevant equations, diagrams/graphs, and
vocabulary a student should have at hand, surfaced per topic and curated rather than
a dump of every term in a unit. Schema exploration found much of the backbone already
built and reusable (`app.taxonomy_units/topics/skills/cells`; the
`app.topic_point_briefs`/`app.topic_explainers` pattern; `app.content_asset_metadata`
plus the Visual Stimulus system). The gaps: no vocabulary store, no equation store,
and visuals are keyed to a `content_item_version_id` (item-scoped), not to a topic.

### Decision

1. **Reference content is topic-scoped, not topic×skill.** The CED prints Essential
   Knowledge per topic, so the authoritative source is topic-grained; this matches
   how `topic_point_briefs`/`topic_explainers` are already keyed.
2. **Vocabulary is sourced from the CED fact packs' Essential Knowledge statements,
   grounded — never generated from model memory.** The terms named in a topic's EK are
   the curated set (~5–12 per topic), each with a CED-grounded one-line definition.
3. **Reuse-first storage.** Add vocabulary/equations as a small table mirroring
   `topic_point_briefs` (keyed `subject_key` + `topic_code`) or as `artifact_versions`
   types; generalize the asset link so an asset can attach to a taxonomy node, not only
   an item. No parallel subsystem.
4. **CED fact packs are verified against the most recent official College Board CED
   documents**, so the reference layer inherits that currency.

### Consequences / Follow-ups

- Opens `DESIGN-009` in the backlog; build is deferred (P2, supporting).
- Generation of the vocabulary/equations from a grounded prompt is a planned build
  step, not started here; its need and shape are documented in the proposal.

## DECISION-0052 — Adopt Full-Point Verified Canonical Answers for FRQs, and Begin Generation (Biology → Statistics) with an Independent AI QA Gate

**Date:** 2026-09-21
**Decision Owner:** David Bloom
**Status:** Approved (approach + start of generation); several parameters still open (below)
**Approval:** Product Owner direction, 2026-09-21 (this session)
**Related Task:** `DESIGN-008`, `NOW-016` (backlog); depends on `TASK-0010` (grader calibration)
**Related Docs:** `docs/proposals/2026-09-20-student-facing-canonical-answers.md` (the merged
proposal this adopts); `prompts/CODEX_CANONICAL_ANSWER_GENERATION_2026_09_21.md` (the generation
orchestration prompt); FRQ canonical-answer coverage audit (Production, 2026-09-21, recorded in
`NOW-016`)
**Area:** Content / Grading

### Context

Canonical answers already exist across the stack (`content_item_versions.canonical_answer_1/2`,
`mcq_choices.is_correct`, `frq_criteria`, the review lifecycle, the `evaluate-attempt` grader),
but today's FRQ canonical is a restatement of the rubric, not a verified full-credit response,
and nothing proves it earns full marks (the `APSTATS-SFRQ-008` stale-canonical bug zeroed every
correct response until an audit caught it). A 2026-09-21 Production sample put FRQ canonical
coverage at ~91% for Biology, ~33% for Statistics, and 22–37% across the Physics family — a
launch-readiness gap, and a student-facing gap since a subject needs a full-credit model answer
for every open-response item.

### Decision

1. **Adopt the rule:** an answer is not canonical until it is written as a student would write it
   AND the production grader awards it 100% against its own rubric.
2. **Generate by drafting with one AI, verifying with an independent one.** Codex drafts full-point
   answers from each FRQ's rubric (it is the drafter only, writes to reviewable staging files, not
   the database); a separate, independent, non-OpenAI model runs the QA/verification pass.
3. **Start with Biology, then Statistics, with a STOP-for-QA gate between them** — Biology drafts
   are QA-verified before Statistics generation begins.
4. **Authored canonical ≠ certified gold set** (holds DECISION-0045's line), and a full-point answer
   is an answer key — never exposed to a student before they submit.
5. **Coverage of the verified canonical set becomes a launch gate** for a subject's FRQ bank.

### Open (decided later, not by this entry)

- Whether full-point verification runs against the **current** grader now (as content QA) or is
  treated as one gate with `TASK-0010` grader calibration / `NOW-013`.
- Whether one verified canonical suffices per item or a second full-credit path is captured
  (`canonical_answer_2`), and whether the student sees one or several.
- Whether long FRQs need dual-pass verification (`DESIGN-001`'s dual-pass question).

### Consequences / Follow-ups

- Opens `DESIGN-008` and `NOW-016`; creates `prompts/CODEX_CANONICAL_ANSWER_GENERATION_2026_09_21.md`.
- Generation targets FRQs that lack a canonical today; existing canonicals are routed to the QA
  pass, never overwritten by the drafter.
- Rubric-defect findings surfaced during drafting/QA (criteria no correct answer can satisfy) go to
  the Curricular Owner, not papered over.

## DECISION-0051 — Confirm QR Handoff (System A) as Engine 4's Sole Capture Path, No Direct-Upload Fallback; Define Capture-Failure Handling (Generic Retake Guidance vs. Bug Logging)

**Date:** 2026-08-19
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase D, TASK-0025
**Related Docs:** `docs/research/HAND_DRAWN_CAPTURE_PATH_RECONCILIATION_2026_08_19.md` (the
options this resolves), `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md`
items 1-2 (the blockers this closes)
**Area:** Product / Grading Engineering

### Context

TASK-0016's decision #10 (`APPROVAL-0033`, 2026-07-08) already named QR handoff as Engine 4's MVP
capture method, direct upload post-MVP. TASK-0025 (2026-08-15) built and deployed a same-device
direct-upload pilot (`SameDeviceCapture.tsx`) without amending that decision — a real deviation
from the approved plan, flagged during Stage D0 execution
(`docs/research/grading_phase_d_spatial_2026_07_27/`). The two systems otherwise split
capabilities: System A (QR/`CaptureItem.tsx`) has the only working cross-device UX and capture-
quality check but is currently non-functional against live Production (its backing table/bucket
don't exist) and, even working, deleted the photo instead of saving it; System B has the only
working image-preservation backend (`attach_capture`/`app.response_attachments`) but no QR/
quality-check UX and is admin-gated/unlinked.

### Decision

1. **QR handoff (System A) is confirmed as Engine 4's sole capture path.** This reaffirms
   TASK-0016 decision #10 rather than reversing it. Reasoning given: QR is a familiar interaction
   pattern; using a laptop's own camera for this task is awkward compared to a phone.
2. **No direct-upload fallback.** System B's same-device upload does not become a general,
   non-pilot capture option. Its frontend (`SameDeviceCapture.tsx`, the `/hand-drawn-pilot` route)
   stays pilot-scoped/superseded, not promoted — consistent with option (a) in the reconciliation
   note. Its backend (`attach_capture`/`app.response_attachments`) is real, working,
   already-deployed infrastructure and should be reused as System A's storage/validation layer
   rather than recreating the broken `capture_sessions`/`capture-research` system from scratch.
3. **Capture-failure handling, split by cause:**
   - **Image-quality failure** (blur, glare, cutoff, poor framing — the domain of a capture-quality
     check): show the student a **graceful, generic** suggestion for improving the photo. Not a
     itemized/diagnostic defect callout as a hard requirement — generic retake guidance is the
     baseline; more specific messaging (e.g. naming the exact defect) is a UX refinement, not a
     requirement of this decision.
   - **Technical failure** (API error, missing infrastructure, timeout, upload failure, any
     failure that isn't about the photo itself): **log a bug** — this must be captured as an
     error/telemetry event for engineering triage, not silently retried or shown to the student as
     if it were their fault.

### Consequences / Follow-ups

- Resolves `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md` items 1
  and 2 (System A vs. B, and the missing `capture_sessions`/`capture-research` DB objects) —
  updated in place.
- Concrete engineering implication: Stage D2 (QR capture MVP) resumes by rewiring System A's
  frontend to call `attach_capture` (which today only accepts authenticated calls — the phone
  leg's token-pairing model needs a bridge into that authenticated path) rather than recreating
  `capture_sessions`/`capture-research`.
- Error-handling split (image-quality vs. technical failure) is new design guidance not previously
  specified anywhere in the Phase D prompt or `HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md` —
  should be folded into those documents' capture-failure sections when Stage D2 engineering
  actually implements this.
- Does not resolve the still-open `capture_quality_state`/`capture_retake_reason` frontend/backend
  contract mismatch (`project_idea1_capture_quality_check_status`) — that's a separate, smaller
  fix needed regardless of which capture system wins.
- See `APPROVAL-0046` for the corresponding approval entry.

## DECISION-0050 — Retire the Dual-Human-Adjudicated Gold-Set Requirement for Engine 4 (Spatial); Adopt the DECISION-0045 AI-Generation + Multi-Model-Verification + Reader-Certification Model Instead

**Date:** 2026-08-19
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase D, TASK-0011
**Related Docs:** `DECISION-0045` (the model this decision extends to Engine 4),
`docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2 (the requirement being retired
for Engine 4 specifically), `prompts/CLAUDE_TASK0016_PHASE_D_SPATIAL_ENGINE_2026_07_27.md`
(Stage D3, whose "dual-human-adjudicated" language is superseded by this decision),
`docs/research/grading_phase_d_spatial_2026_07_27/` (Stage D0, executed same day, which
surfaced this as the largest blocker to Engine 4 progress)
**Area:** Grading / Governance

### Context

TASK-0011/TASK-0016 Phase D's Stage D3 requires ≥300 dual-human-adjudicated responses (≥40 per
archetype, per governance §12.2) before any Engine 4 gold-backed accuracy claim. `DECISION-0045`
(2026-08-03) already replaced all-human gold authoring program-wide with an AI-generation +
multi-model-verification + reader-certification model — but explicitly deferred applying it to
Engine 4 ("Set C — spatial/`human_shadow` — deferred until Engine 4 leaves shadow"), leaving
Phase D's older dual-human-adjudicated language as the operative Engine 4-specific standard.
Stage D0 (executed 2026-08-19, same session) found this is currently Engine 4's single largest
blocker: no corpus in the repo meets it, and the one human-pilot attempt aimed at building
one (Orly Bloom, 2026-06-13) stalled on data-reproducibility defects and was never resumed.

### Decision

1. The dual-human-adjudicated gold-set requirement is **retired as a hard gate specifically for
   Engine 4** — not merely deferred again.
2. **`DECISION-0045`'s Set C deferral is lifted.** Engine 4 gold-set construction follows the
   same protocol as every other engine: answers/labels generated or graded by AI, checked by two
   independent non-OpenAI model families, with reader effort spent certifying the pipeline (cold
   verification of rubric-element presence on an audit sample, a pre-registered false-accept-rate
   gate) rather than dual-blind adjudicating every response. `DECISION-0045`'s independence
   constraints (no OpenAI model may write or verify; three non-OpenAI families required since the
   writer consumes one) apply identically here — this is the same standard already load-bearing
   for Engines 1/3, not a weaker one invented for Engine 4.
3. **This does not waive real-photo corpus-readiness requirements.** The existing photo corpus
   still needs the fixes its own 2026-08-03 readiness audit found (consent/provenance manifest,
   deduplication, metadata stripping) before it's an eligible input — this decision changes what
   "gold" means for the labels attached to that corpus, not the corpus-collection bar itself.
4. **The existing 200-photo real-Biology corpus's single-pass-AI gold does not automatically
   become certified gold under this decision.** It still needs an actual `DECISION-0045`-protocol
   pass — two independent non-OpenAI model families checking it, plus a reader-certified
   false-accept-rate sample — before it counts as launch-qualifying evidence. This decision
   changes the target standard going forward; it does not retroactively certify work already
   done under the old, unmet standard.
5. Applies to both AP Biology (development evidence under Phase D) and AP Statistics (the actual
   TASK-0016 launch subject).

### Rationale

Requiring literal dual-human adjudication for Engine 4 while every other engine moved to the
DECISION-0045 model in 2026-08-03 left Engine 4 held to a standard nothing else in the program
meets either — and one whose only concrete attempt to satisfy it (the Orly pilot) failed for
reasons unrelated to whether dual-human adjudication itself is the right bar (data errors, a
rights-claim overstatement), not for lack of trying. Un-deferring Set C removes a blocker that
was never really a deliberate Engine-4-specific safety decision, just an unresolved carry-over
from before DECISION-0045 existed.

### Consequences / Follow-ups

- `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`, `docs/tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`,
  and the Phase D execution prompt's Stage D3 language should be read as amended by this decision
  going forward — a future session should not refuse to proceed by citing their literal
  "dual-human-adjudicated" wording.
- `docs/research/grading_phase_d_spatial_2026_07_27/DECISIONS_AND_BLOCKERS.md` items 3 and 6 are
  updated in place to reflect this decision.
- Someone still needs to actually run the DECISION-0045 protocol against Engine 4's corpus — this
  decision removes the blocker, it does not itself certify any existing corpus as gold.
- See `APPROVAL-0045` for the corresponding approval entry.

## DECISION-0049 — Hand-Drawn Capture Becomes an Added Submission Option for Typed-Math FRQs, Retroactive to All 36 Published Calculus FRQs

**Date:** 2026-08-18
**Decision Owner:** David Bloom
**Status:** Approved (product direction); grading capability not yet built
**Related Docs:** `DECISION-0048` (above/below), `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md`
(same-day, uncommitted-as-of-this-decision OCR probe finding),
`docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` (Engine 3's existing
"real human-handwriting transcription gating run" requirement)
**Area:** Content / Product / Grading Engineering

### Context

Same-day follow-up to `DECISION-0048`. Working through Calculus's typed-math
response modality surfaced that there is no equation editor
("structured equation editor is post-MVP" per `TASK-0016-GRADING-ENGINE-
ROLLOUT.md`) — `typed-text`/`typed-math` today means raw keyboard entry of
math notation (e.g. `a(t) = v′(t) = 3t²−10t+4`), with no confirmed frontend
guidance on notation and no dedicated math-notation-normalization layer on
the production grading path Calculus actually uses (`discrete_text` →
`llm_discrete_text`, not the not-yet-live `structured_formula`/`symbolic_ecf`
path). The Owner's read: keyboard math entry is too complicated for student
practice.

### Decision

1. **Hand-drawn capture becomes an added submission option, not a
   replacement,** for FRQs currently requiring typed equation/derivation
   work. Students write on paper and submit via photo capture, same
   mechanism as the existing hand-drawn graph items.
2. **Applies retroactively to all 36 already-published Calculus FRQs**
   (`apcalcab-*`, `apcalcbc-*`), not just new content — the same keyboard-
   complexity problem applies equally to existing items; there's no
   principled reason to treat them differently.
3. **Grading target: reuse the existing typed-answer criteria**, not build a
   separate rubric. The Owner's framing — "we will grade and offer repair
   just like FRQs with typed answers" — means the intended architecture is
   capture → OCR-transcribe the handwriting to text → run the *same*
   `criterion_definitions`/`required_evidence` grading each item already has
   for its typed-math form, not a new spatial/graph-shape-style rubric.
4. **UI enhancement to make hand-drawn submission more obvious** is a
   separate, Lovable-frontend-side task, not addressed here.

### Why this is more buildable than it first looked

A same-day (uncommitted at the time of this decision) OCR probe using
macOS's built-in Vision framework was tested against real handwritten
Calculus/Chemistry equation samples (`docs/hand drawn samples/Calc AB HDR/`,
`Chem HDR/`) and found "strong core-content transcription with one specific,
recurring weakness (exponent/superscript notation inconsistently
preserved)" — flagged in `GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` as
"a better-fitting problem for OCR than graphs are (pure symbolic
recognition, no point-detection needed)." This is real, positive signal for
exactly the architecture in point 3 above — but it is explicitly a probe,
not a qualified pilot: "needs its own gold data and benchmark; not a
continuation of Engine 4's graph work, don't conflate the two scopes."

### What is NOT true yet — read before assuming this is close to shipping

- **No real student has ever been graded by any engine in Production**
  (0 `attempts`, 0 `attempt_responses`, per the same handoff doc) — this is
  true of the existing typed-math grading path too, not just hand-drawn.
  "Grade just like typed FRQs" is a reasonable target; it is not yet a
  proven, live baseline to match.
- The OCR-for-equations finding is a probe result on a small out-of-scope
  sample, not a benchmarked, gold-verified capability.
- Per the standing policy (`ACTIVITY_LOG.md`, 2026-08-14; also see
  [[feedback_no_human_grading_in_production]]), there is no human-graded
  fallback if this isn't ready — these items stay ungradable for real
  students, not "gradable by a person," until it's built and qualified.
- No schema/migration work to add a hand-drawn submission option to the 36
  existing item packages has been done — this decision records the product
  direction; the retroactive content/schema change is separate follow-up
  work.

**Next Owner:** David Bloom.
**Next Required Action:** Scope the OCR-transcription-to-existing-criteria
pilot as its own tracked effort (natural home: Engine 3's outstanding "real
human-handwriting transcription gating run" requirement in
`TASK-0016-GRADING-ENGINE-ROLLOUT.md`) with its own gold data and benchmark;
separately, scope the schema/migration work to add a hand-drawn submission
option to the 36 existing Calculus FRQ items; separately, brief the Lovable
frontend work for the UI prominence change.

### Follow-up, same day: submission path already universal, no schema change needed there

Owner direction refined the rollout shape: every question should carry the
image-capture/submission option by default (not curated per item), with a
per-item **suppression** override added later once specific items are known
non-viable for hand-drawn capture — explicitly to avoid having to label
every FRQ up front. Checked the actual backend before assuming this needed
schema work:

- `attempt-response/index.ts`'s `attach_capture` operation has **zero
  gating on item type, rubric type, or `response_modalities`** — it only
  checks attempt ownership/status, response-version match, storage-path
  validity, and capture-object validation. It already accepts a photo
  capture for any attempt on any item today.
- No migration, function, or content record anywhere currently gates or
  allowlists capture eligibility per item. Every published item's
  `response_modalities` has only ever contained `typed-text`, `typed-math`,
  or `choice` — nothing capture-related has ever been set on any item, and
  nothing reads such a value to decide whether to allow a capture.

**Conclusion:** the default-everywhere posture requires no backend or
schema change — it's already true at the database level. The only place it
could still be missing is the Lovable frontend not rendering the capture
option on every FRQ, which is outside this repo/session's visibility. The
**suppression** mechanism the Owner described for later is genuinely new —
nothing today can suppress capture on a specific item — and is deferred,
correctly, as a small follow-up (e.g. a `capture_suppressed`-style flag on
`content_item_versions` or in `prompt_json`) rather than something needed
now.

**Engine 4/OCR-at-scale testing is being run on a separate thread** — this
decision and its content-authoring follow-ups stay out of that work's way;
nothing here duplicates it.

**Next Owner:** David Bloom.
**Next Required Action (revised):** confirm the Lovable frontend renders the
capture option unconditionally across FRQs (no repository access to verify
this session); build the per-item suppression flag when the first
known-non-viable item is identified, not before.

## DECISION-0048 — AP Statistics Hand-Drawn Practice Stays Supplemental; Chemistry/Physics/Calculus Get New Genuine Hand-Drawn-Capture Items

**Date:** 2026-08-18
**Decision Owner:** David Bloom
**Status:** Approved
**Related Docs:** `docs/research/HAND_DRAWN_RESPONSE_MIX_AUDIT_2026_08_18.md`, `scripts/content-seed/hand_drawn_expansion_chem_physics_calc_2026_08_18/`
**Area:** Content / Learning Quality

### Context

The same-day mix audit found AP Statistics' published hand-drawn item share
(57% of FRQs) far exceeds its real-exam exposure (the real exam is fully
digital with a built-in Desmos grapher, zero hand-drawn graphing), while
Chemistry (2.4%), Physics (~11% by a looser count, effectively 0% by genuine
capture-item count), and Calculus (0%) sit well under CED-documented weight
on graph/diagram-construction skills (Chemistry Practice 3, 8-16% FRQ weight;
Physics Translation-Between-Representations archetype, ~25% of FRQs, plus
every Physics FRQ being handwritten on the real exam; Calculus Practice 2,
10-20% FRQ weight).

### Decision

1. **AP Statistics' hand-drawn volume is not a defect and is not being
   reduced.** The Owner's framing: Cramapple's hand-drawn capture pipeline is
   being used deliberately as a stand-in for the real exam's digital Desmos
   graph-construction skill, since Cramapple has no Desmos-equivalent tool.
   The existing `supplemental_hand_drawn` tagging (documented in
   `AP_STATISTICS_2027_CED_FACT_PACK.md` §7) already captures this correctly
   — no change needed there.
2. **Chemistry, Physics, and Calculus need more hand-drawn-component
   questions.** Six new items authored this session (two per subject,
   `scripts/content-seed/hand_drawn_expansion_chem_physics_calc_2026_08_18/`)
   as a first, targeted batch — draft/unreviewed, not applied to any
   database (no live Supabase access this session).

### Scope note surfaced during authoring

The mix audit's Physics/Chemistry "hand-drawn" counts had conflated two
different things: genuine photograph-and-grade capture items
(`HDG-2026-*`, `expected_graph_spec`/vision-graded, the AP Biology/Statistics
pattern) versus older typed-text "describe or sketch the construct" items
(`apchem-sfrq-032`, several Physics `no_constructs` items) that accept a
typed derivation instead of a photo. Only Biology and Statistics had any
genuine capture items before this decision — this batch is the first
genuine hand-drawn capture content in Chemistry, Physics, or Calculus, not
an expansion of an existing capture pool in those subjects.

### Still open

Authoring ahead of the grading fix is accepted as fine; making these items
reachable by real students is not, per two combined findings: (1) the
same-day finding that the production-candidate grading method fails all four
DR-1 accuracy thresholds on real photos
(`HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`), and (2) the firm,
standing policy that real student grading is always automated end-to-end —
there is no human-graded interim path. Humans are in the loop only for
engine development and calibration (audit, gold labeling, QA), never in the
live path, at any production authority stage (`ACTIVITY_LOG.md`, 2026-08-14).
`rubric_type: spatial` routing to `evaluator_strategy: human_shadow` in
`grading-router.ts` is a development/calibration shadow path despite its
name, not a way of serving real students. These six items therefore stay
fully unreachable by any student-facing selector until Engine 4 (automated
spatial grading) passes its accuracy bar — there is no safer intermediate
state to route them to instead.

**Next Owner:** David Bloom.
**Next Required Action:** Route the six draft items through Learning
Quality/subject-matter review, then apply via a proper migration once
approved; decide `practice_format`/taxonomy tagging, keeping them excluded
from any student-facing selector until Engine 4's automated spatial grading
is qualified.

## DECISION-0047 — Replace Activation-Limited Free Score Check with a 7-Day Full-Access Trial (TASK-0026)

**Date:** 2026-08-15
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0026 (supersedes TASK-0024)
**Area:** Product / Growth

### Context

The Free Score Check strategy doc
(`docs/strategy/CRAMAPPLE_FREE_SCORE_CHECK_IMPLEMENTATION_2026.md`,
2026-07-20) designed an activation-limited public offer (one FRQ, one
guided repair, one report, then paywall) around a student with roughly ten
days before an exam -- deliberately usage-limited rather than time-limited
("the offer does not expire after a number of days"). TASK-0024's
implementation of that offer never reached production
(`growth.free_score_check.v1.enabled` stayed `false` throughout its
build). By mid-August, with the school year just starting, that urgency
premise no longer held: there is no cramming scarcity to gate against, so
an activation-limited offer mostly added friction against a purchase
decision that has not become urgent yet.

### Decision

1. Replace the activation-limited Free Score Check with a 7-day,
   full-catalog (all 10 launch subjects), no-usage-cap trial, implemented
   as a new `access_tier='trial'` row on the existing
   `app.subject_entitlements` table / `app.authorize_grading_access` gate
   rather than a bespoke one-FRQ state machine.
2. Retire the FSC-specific machinery it replaces (`app.free_score_checks`
   table, `start_free_score_check` / `record_free_score_grade` RPCs, the
   `free-score-check` Edge Function and frontend routes) rather than run
   both models in parallel. Code preserved on
   `archive/free-score-check-2026-08-15` (both the Cramapple and
   exam-buddy-wireframe repos) for a future revival closer to exam season,
   not deleted outright.
3. Post-trial-expiry access is grace/read-only by design, not a new build:
   `attempts` / `response_versions` / `grading_results` SELECT policies are
   owner-scoped only (no entitlement check), so past work stays visible
   while new attempt creation is blocked by the existing entitlement-gated
   INSERT policy -- confirmed via production read-only verification before
   relying on it.
4. Lifecycle email (Loops) triggers off this event and its `ends_at`
   property, so trial-length changes do not require server-side timing
   logic to change in lockstep.

### Rationale

The report's original design already flagged the "unlimited trial could
satisfy the whole urgent use case before payment" risk as the reason to
avoid a time-only trial -- that risk is genuinely lower right now (low
urgency, early season) than it will be in spring, which is exactly why the
trade is being made now rather than as a permanent design. Reusing
`subject_entitlements` / `authorize_grading_access` unchanged (rather than
building new gating logic) meant the entire cutover required zero changes
to the actual grading-access gate -- verified directly against a real
production attempt from an existing `beta` account both before and after
the retirement migration.

### Consequences / Follow-ups

- `GRADING_ENTITLEMENTS_ENABLED` flipped to `true` in Production as part of
  this change -- see `APPROVAL-0044` for the corresponding approval and its
  relationship to `APPROVAL-0043`'s prior note on this flag.
- `docs/tasks/TASK-0024-FREE-SCORE-CHECK-LAUNCH-READINESS.md`, its
  cutover-evidence doc, and the FSC strategy doc are marked superseded, not
  deleted.
- The `returned_day_2` / `returned_day_7` PostHog cohort events (distinct
  from Loops' own journey timing) remain unimplemented, blocked on a
  `pg_net` enablement decision -- tracked in TASK-0026, not blocking trial
  launch.
- Full implementation detail, evidence, and open items in
  `docs/tasks/TASK-0026-SEVEN-DAY-TRIAL-AND-ENGAGEMENT-PROGRAM.md`.

## DECISION-0046 — Retire the ≤1000ms p50 Grading Latency Hard Gate; Launch Engines 1/3 Now and Iterate in Production Rather Than Wait for the Full Gold-Set Certification Gate

**Date:** 2026-08-14
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016
**Area:** Product / Architecture

### Context

TASK-0016's original launch bar (owner-approved 2026-07-08, `APPROVAL-0033`)
set two hard numeric gates before any grading engine could go authoritative:
end-to-end latency ≤1000ms p50, and a 300+ dual-adjudicated gold-set
accuracy certification (per `CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2).
Neither has been met, and by 2026-08-13 there was direct measured evidence
that the latency target specifically is not reachable with the current
architecture and model: non-model request overhead alone measures ~691ms
p50 (auth/DB/render, before any model call), and Arm A — the
per-criterion-parallel architecture expected to bring a 4-criterion FRQ from
~16s to ~4s — measured 22–31s medians on the actual production model
(`gpt-4.1-mini`) once tested on it directly (the original ~4s figure was
validated only on `gemini-2.5-flash`, a substitute model, per the handoff
doc's own "trap 1").

A second-opinion review (codex,
`prompts/SECOND_OPINION_ENGINE1_ENGINE3_GO_LIVE_PLAN_2026_08_13.md`)
identified this and four other structural problems with continuing to plan
around the original launch bar, and the owner reviewed that critique
directly in this session.

### Decision

1. **The ≤1000ms p50 hard gate is retired**, not merely deferred. Replaced
   with a two-SLA framing: time-to-acknowledgement (student sees a progress
   state immediately) and time-to-complete-feedback (full graded result
   rendered). Quality > Speed > Cost (owner decision, 2026-07-29) remains the
   governing priority order — this does not reopen that ordering, it
   accepts that the specific numeric latency target under that ordering was
   wrong given the actual model/architecture combination in use.
2. **Engine 1 and Engine 3 go live now** (Engine 1 authoritative once its
   evidence-grounding P0 fix ships; Engine 3 shadow-only, per its own
   structural ceiling — see TASK-0016's 2026-08-13 addendum) rather than
   waiting for the full 300+ dual-adjudicated gold-set certification. That
   certification continues in parallel as a dependency for later authority
   stages (per the addendum's five-stage production model), not as a
   pacing item blocking initial launch.
3. Recorded here, rather than only inside `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md`'s
   addendum, because item 1 reverses a numeric target from an original Hard
   Gate approval (`APPROVAL-0033`) — a durable, independently-findable
   decision record, not only a task-file edit. See `APPROVAL-0043` for the
   corresponding approval entry.

### Rationale

Continuing to plan around a latency target the system's own measurements
show is unreachable wastes engineering effort chasing a number rather than
the thing that number was a proxy for (a good student experience). The
two-SLA framing keeps the actual product concern (does the student know
something is happening; do they get their grade in a reasonable time)
without pretending a number invalidated by direct measurement is still the
bar. Waiting for full gold-set certification before any real-world signal
exists is also self-defeating on the current evidence: the two most
consequential accuracy findings this program has had (the `SFRQ-008` keyed
value defect, the evidence-grounding false-abstention pattern) were both
found through targeted live testing, not through gold-set volume — more
volume was not what moved either number.

### Consequences / Follow-ups

- `docs/tasks/TASK-0016-GRADING-ENGINE-ROLLOUT.md` amended in place
  (2026-08-13 addendum) with acceptance criteria struck/annotated
  accordingly.
- Non-model latency overhead (~691ms p50) becomes a Stage C/D-adjacent
  optimization workstream, not a launch blocker.
- The formal gold-set gate's cadence and what specifically unblocks each
  later authority stage is tracked in the addendum's five-stage model, not
  restated here.

## DECISION-0045 — Gold Sets Are Built by AI Generation + Multi-Model Verification + Reader Certification, and Partitioned by Grading Engine × Criterion Structure

**Date:** 2026-08-03
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0016 Phase C (cross-subject grading calibration)

**Problem.** The all-human gold-set authoring model
(`GOLD_SET_AUTHORING_GUIDE.md` v1.0) required ~330 answers at 12 min to write
plus 5 min to verify — roughly **94 hours of reader time**, against the roster
that is already the binding constraint on content review. It would not have been
completed, and an unbuilt gold set measures nothing.

**Decision, part 1 — production model.** Gold-set answers are **generated by AI**
and checked by **two independent non-OpenAI model families** before a reader sees
them. Reader effort moves off production and onto **certifying the pipeline**:

- Readers verify answers **cold** (no script, no verifier output, no grader
  output, no route indication), marking rubric elements present/absent — never
  points, never a score.
- Readers confirm **element decompositions** for multi-point criteria — the one
  step whose error would be invisible, since a bad breakdown corrupts all eight
  answers for an item identically.
- The automated path is certified by measuring its false-accept rate against a
  reader-verified sample, under a **pre-registered gate**: upper 95% bound ≤5%
  certifies; 5–15% requires diagnosis and re-pilot; >15% rejects the automated
  path and reverts to full reader verification.

Reader cost thereby **decouples from corpus size** — the audit sample is sized by
the required confidence bound (~100 answers per set), not by how many answers
exist.

**Decision, part 2 — independence constraint.** The grader under test is OpenAI
(`gpt-4.1-mini`, `gpt-5.5`). Therefore: no OpenAI model may write or verify
gold-set answers; no verifier may share a model family with the writer of the
answer it verifies; verifiers are blind to the script, the grader output, and
each other; and the writer never verifies its own output. A writer sharing a
family with the grader writes in the grader's idiom and destroys the A2 probe
(full credit in unconventional phrasing) — the probe that caught the grader
awarding full marks to only 7 of 10 complete answers. A verifier sharing a family
with the grader encodes the grader's own misreading as ground truth, and the set
then reports the grader as accurate regardless of its behaviour. **Three
non-OpenAI families are required**, since the writer consumes one and the
remaining two must reach unanimity.

**Decision, part 3 — set partition.** A gold set is a regression suite for a
**code path × rubric shape**, not for a subject. There is no per-subject gold
set, no "all physics" or "all calculus" set, and no science-vs-math split —
subject is a *stratum inside* a set, sized to catch subject-specific breakage.
Verified against Production `pcntajvbdfqhbeewmdry` on 2026-08-03, this yields
**two active sets, not seven**:

| Set | Engine / evaluator | Criterion structure | Population |
|---|---|---|---|
| **A** | 1 — `llm_discrete_text` | multi-point | Biology 36 items / 158 criteria; Chemistry 5 / 30 |
| **B** | 1 — `llm_discrete_text` | single-point independent | Physics ×4 35 / 113; Statistics 15 / 60; Precalculus 11 / 66 |
| **C** | 4 — `spatial` / `human_shadow` | single-point | Statistics 33 / 132 — deferred until Engine 4 leaves shadow |
| — | 3 — formula/ECF/symbolic | — | **zero published items**; no set until content routes there |

Every automated FRQ path in the published bank is Engine 1; Calculus AB/BC
(3 items) folds into Set A.

**Implementation.** Protocol: `docs/research/GOLD_SET_GENERATION_PROTOCOL.md`.
Reader guide rewritten to v2.0 (`docs/research/GOLD_SET_AUTHORING_GUIDE.md`) —
readers no longer author. Pilot pre-registration:
`docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md` (Set B; Jill on
Statistics, Saood on Physics; 14 items / 52 criteria / 112 answers; readers
verify 100% in the pilot because a false-accept rate cannot be estimated from a
sample of itself).

**Notes and limits.** The Set B pilot does **not** exercise element
decomposition (Set B has no multi-point criteria), so **Set A requires its own
certification pass** — a Set B pass does not license generating Biology
unsupervised. Every item available for the pilot is
`practice_format='targeted_drill'`; no `full_exam_frq` content exists in any
subject, so certification covers short drill items only. The pre-existing
standing rule is unchanged and load-bearing here: **the grader is never tuned on
a gold set** — cheap generation makes that more tempting, not less.

## DECISION-0044 — Universal Publication Rule (Double-Approve + AI QA, or Edit-Request Fixed by AI)

**Date:** 2026-08-02
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (publication governance; interacts with TASK-0017)

**Decision.** A question's latest active version is published when either:

- **Rule A:** it holds approvals from **two or more distinct, real, actively
  qualified tutors**, no conflicting tutor decision, **and** an AI QA approval
  recorded as an admin-profile decision on that same version; or
- **Rule B:** a tutor filed **approve_with_edits** anywhere in the item's
  review history **and the fix was applied by AI** (admin-authored successor
  version), the fix version carries no tutor non-approval, and an AI QA
  approval is recorded on the fix version.

This is a **universal, standing rule**, generalizing the one-off 2026-07-30
release (`20260730_publish_double_tutor_ai_qa_approved.sql`). Both rules keep
that release's structural gates (4 distinct MCQ choices with exactly one key
matching `canonical_answer_1`; FRQ criteria present with positive total
points; stimulus assets present; no competing published version). Items
failing a gate are skipped and reported, never silently published.

**Implementation.**
`scripts/content-seed/publication/20260802_decision_0044_universal_publish_rule.sql`
(sections 2–5 are the standing re-runnable rule; section 1 seeds the
2026-08-02 AI QA decisions). AI QA is represented in-database as an
admin-profile `approve` decision with `approval_basis` of
`two_qualified_tutor_approvals_plus_ai_qa` (Rule A) or
`approve_with_edits_fixed_by_ai_plus_ai_qa` (Rule B), always citing
`DECISION-0044` in the payload.

**Notes.** Rule B intentionally does not require a human re-read of the AI
fix; a tutor non-approval on the fix version blocks it. Disapprovals block
Rule A as conflicting decisions. The rule does not resurrect items whose only
decisions are disapprovals.

## DECISION-0043 — Operationalize Branch Hygiene R1–R7 (Trunk Protection, CI, Auto-Delete)

**Date:** 2026-08-01
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance)
**Area:** Operations

### Context

Rules R1–R7 were approved on 2026-07-26 (PR #54, squash `e535f06`). Sprawl recurred
within a week: 15 local branches, `main` unchanged since 2026-07-27, one branch 93
commits ahead.

**Audit of what was actually missing (2026-08-01).** Contrary to the working
assumption that "steps 5–9 are pending," verification against the live repository
found most of the mechanical enforcement already in place:

| Step | State before this decision |
| --- | --- |
| 4 — governance/docs adoption | **Missing.** The only genuine gap. |
| 5 — trunk protection | Already on: force-push blocked, deletions blocked, conversation resolution required, `enforce_admins: false` preserving human break-glass. |
| 6 — CI | Already on: `.github/workflows/minimal-ci.yml`, job `test`, passing. |
| 7 — required checks | Already on: `test` is a required context with `strict: true`. |
| 8 — auto-delete + auto-merge | Already on: `delete_branch_on_merge: true`, `allow_auto_merge: true`. |
| 9 — merge queue | Correctly not configured (conditional). |

This reframes the root cause. **Sprawl is not caused by a mechanical block** — no
gate is misconfigured, and CI passes. Work is not reaching `main` because nobody is
opening the PRs, which is a behavioural gap that R1–R3 address and that step 4 —
encoding the rules where agents and humans actually read them — was the missing
half of.

The cost is concrete, not theoretical. The AP Statistics CED fact pack —
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the sanctioned authoring input
gating G0A and therefore the entire approved Statistics rebuild — sat only on the
93-commit branch. It was invisible from `main` and was independently re-derived
more than once by sessions that could not see it.

The cost is concrete, not theoretical. The AP Statistics CED fact pack —
`docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, the sanctioned authoring input
gating G0A and therefore the entire approved Statistics rebuild — sat only on the
93-commit branch. It was invisible from `main` and was independently re-derived
more than once by sessions that could not see it.

### Decision

Encode R1–R7 canonically in `docs/team_charter/AI_COLLABORATION_RULES.md`, and
enable the mechanical enforcement the rules assume:

1. **Canonical rules** live in `AI_COLLABORATION_RULES.md`; the proposal is demoted to evidence, not authority. No other document restates them.
2. **PR policy amended:** promotion to `main` is *always* by PR. The previous "Standing Approval work can merge directly" allowance is withdrawn — it is incompatible with the trunk protection already in force.
3. **Confirm and retain** the existing repository settings (steps 5–8) as the adopted configuration, now that they are documented rather than tacit.
4. **No merge queue** unless concurrent merges demonstrably cause stale-base problems.
5. **No custom privileged merge automation** — R5(c) stands unchanged.
6. **CI scope stays deliberately narrow.** `minimal-ci.yml` is retained as-is.

### Rationale

The recurrence proves the rules were never the missing piece and — per the audit
above — neither was enforcement tooling. What was missing is that the rules lived
in a proposal document nobody reads at session start, while the charter that agents
*do* read still said Standing Approval work could merge directly to `main`. The
charter actively contradicted the adopted policy.

CI is left alone on purpose. Proposal §5 specifies "one fast, deterministic,
secret-free workflow (not every checker blocking)," and `minimal-ci.yml` already
satisfies that. Broadening a *required* check is how required checks become flaky
and then get bypassed — the exact failure this decision exists to prevent. A
broader non-required workflow is available later if wanted: the full
`supabase/functions/_shared` suite is 83 tests in ~1s and every edge function
currently typechecks clean, both verified 2026-08-01.

### Consequences

- All work reaches trunk by PR. The charter no longer offers a direct-merge path,
  so the documented policy and the enforced configuration now agree.
- Merged remote branches disappear automatically; local cleanup stays manual and
  gated by the R7 three-check preflight.
- Unique unmerged work must be archive-tagged before deletion, not simply dropped.
- `enforce_admins` remains `false`. This is deliberate — it is the human-only
  break-glass R1–R7 requires. It also means an admin *can* still push directly to
  `main`, so trunk protection is a guardrail against accident, not a hard
  guarantee against a determined bypass.
- The one-time cleanup of the existing 15 branches (proposal §4) is **not** covered
  by this decision and remains outstanding; it must run from a clean checkout of
  `origin/main`, not from a dirty working branch.
- Because no gate was broken, expect no immediate mechanical change in merge
  throughput. If sprawl persists after this, the next lever is R3 enforcement
  (small, frequent PRs), not more tooling.

## Decision Format

```markdown
## DECISION-0000 — Decision Title

**Date:** YYYY-MM-DD
**Decision Owner:** David Bloom
**Status:** Proposed / Approved / Superseded
**Related Task:** TASK-0000 / N/A
**Area:** Product / Architecture / Security / Design / Operations / Integration

### Context

### Decision

### Rationale

### Consequences

### Risks / Follow-ups
```

## DECISION-0001 — Use GitHub as Cramapple's Durable Source of Truth

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

Cramapple planning has begun in chat and in speculative blueprint documents. Durable project state needs a consistent home and operating workflow.

### Decision

Use the AI Project Operating Kit and store canonical documents, tasks, approvals, decisions, and activity records in `david-bloom/Cramapple`.

### Rationale

This prevents chat-only decisions, establishes approval boundaries, and allows human and AI collaborators to reorient from the same records.

### Consequences

GitHub documents override unrecorded chat memory. Earlier `Blueprint_*` files remain speculative inputs unless promoted through an approved decision.

### Risks / Follow-ups

The operating workflow may need simplification after practical use.

## DECISION-0002 — Product and Strategy Authority

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0001
**Area:** Operations

### Context

The project needs explicit authority for product decisions and a role for strategic planning.

### Decision

David Bloom is Product Owner and final approver. Add Strategy Advisor to work with David and the co-founders on plans and business decisions.

### Rationale

The team benefits from strong strategic challenge and planning support while preserving one clear final product authority.

### Consequences

The Strategy Advisor may recommend, draft, analyze, and challenge. The role may not independently approve product scope, execution, risk, Done decisions, or launch.

### Risks / Follow-ups

The named person or agent filling the Strategy Advisor role may vary and should be recorded when assigned.

## DECISION-0003 — Allow Qualified Estimated AP Score Guidance

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0002
**Area:** Product

### Context

The initial vision prohibited official AP score prediction but left the role of estimated scoring unresolved. Students need understandable guidance about their likely current range and what improvement could move them forward.

### Decision

Cramapple may provide estimated AP score ranges or readiness estimates when supported by sufficient evidence. Estimates must be clearly identified as non-official, express uncertainty, disclose important evidence gaps, and connect the estimate to concrete next actions.

### Rationale

Qualified estimates can make criterion-level feedback more useful and motivating while preserving a clear distinction between Cramapple guidance and official College Board scoring.

### Consequences

The grading and recommendation systems will need evidence thresholds, confidence rules, calibration datasets, versioned estimation logic, and monitoring for systematic error. A single response must not be presented as a definitive overall AP score.

### Risks / Follow-ups

- Define the minimum evidence required before displaying an estimate.
- Establish expert review and calibration standards before launch.
- Determine how estimated ranges should be updated as new performance evidence arrives.
- Validate customer-facing language with students, parents, tutors, and legal review.

## DECISION-0004 — High-Level Architecture Boundaries

**Date:** 2026-06-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0003
**Area:** Architecture

### Context

Cramapple needs a durable architecture before detailed teaching, grading, data, and implementation designs. Earlier root-level blueprints move too quickly into preliminary schemas and provider-specific model routing.

### Decision

Adopt a high-level architecture organized around managed presentation and application services, Supabase as the proposed durable system of record, replaceable task-specific AI providers, versioned canonical content, durable learner evidence, separate teaching and grading responsibilities, first-class validator operations, and event-based marketing interoperability.

### Rationale

This establishes stable ownership and trust boundaries before committing to detailed schemas or vendors. It supports grading and teaching quality, low-code maintainability, cross-session learning, and additional AP exams.

### Consequences

- Detailed teaching and grading designs will be separate canonical documents.
- Student attempts remain durable while mastery, recommendations, and progress are derived and rebuildable.
- Validators require scoped entitlements and version-specific approval workflows.
- Marketing integrations receive approved events rather than sensitive learning content.
- User-provided questions remain isolated from canonical content.
- Parent progress is a future paid entitlement with separate relationship, consent, billing, and visibility checks.

### Risks / Follow-ups

- Detailed data, security, teaching, grading, and integration designs remain open.
- Managed-service boundaries must be tested against latency, cost, privacy, and seasonal load.
- Legal review is required for minors, uploads, official materials, and parent access.

## DECISION-0005 — Version Official Exam Facts Separately from Product Models

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Architecture

### Context

Section weights, point distributions, task types, and curriculum ranges directly influence what Cramapple recommends. Scattering those facts through prompts or prose would make updates, review, and audit unreliable.

### Decision

Create a versioned Exam Specification Registry for official exam facts. Store Cramapple-derived weights, formulas, and predictions as separate records with explicit assumptions and model versions.

### Rationale

This prevents official facts from being confused with product inference and allows each school year's exam pack to be reviewed, activated, superseded, and audited.

### Consequences

- Every recommendation can identify the exam facts and derived model that influenced it.
- Source scope must be precise; for example, AP Biology unit ranges apply to the multiple-choice section.
- Exam changes can trigger impact analysis and revalidation.

### Risks / Follow-ups

- Source licensing and authorized-material rules require legal review.
- The physical schema and update workflow remain to be designed.

## DECISION-0006 — Adopt an Exam-Horizon Retrieval Pedagogy

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0004
**Area:** Product

### Context

Cramapple's initial use case is approximately ten days before an AP exam. A year-long curriculum model does not fit this constraint, while passive cramming offers weak evidence of independent retrieval and transfer.

### Decision

Use attempt-first diagnosis, minimal targeted teaching, immediate transfer, delayed retrieval, deliberate interleaving, confidence calibration, and exam-value-aware recommendations as the teaching-system foundation.

### Rationale

The approach directs limited study time toward demonstrated gaps that appear teachable and valuable while preserving return visits before exam day.

### Consequences

- Weakness, improvability, and exam value are separate recommendation inputs.
- Explanations do not count as mastery without retrieval.
- FRQs are taught by task and criterion; CER is used where the scoring opportunity calls for argumentation.
- Student-facing recommendations explain their reasoning.

### Risks / Follow-ups

- AP Biology tutors must review the pedagogy before implementation or launch.
- Cramapple-specific intervals and effect claims require product validation.
- A detailed grading and calibration design remains open.

## DECISION-0007 — Use Evidence-Weighted Escalation Within One Learning Model

**Date:** 2026-06-10
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

A deterministic three-miss trigger, universal Sideways-first sequence, and generic learner-preference memory would create false precision and could waste limited study time.

### Decision

Use one per-assessable-target-and-facet learning-state model. Weight failure evidence by independence, variation, delay, and support; use discriminating probes to select Sideways, Apart, or Down; confirm intervention success through independent and delayed performance; offer Move On; and calculate Park return from exam horizon, frustration, and expected exam utility.

Anonymous student responses and outcome traces may be used to improve Cramapple's grading, teaching, content, evaluation, model configurations, and routing. Public publication remains separately gated and includes a signed-in-user proper-name sweep.

### Rationale

The model creates a rational, auditable policy without claiming certainty about hidden cognitive causes. Subsequent independent performance tests whether the selected intervention was useful.

### Consequences

- Learner state must preserve support level, route, immediate transfer, delayed retention, Move On, and Park evidence.
- The content graph needs prerequisite, component, representation, and transfer relationships.
- Validators need compact evidence packages for uncertain and repeated-failure cases.
- Demonstrated intervention effectiveness is specific to skill and task type.
- Legal terms and notices must describe anonymous improvement use.

### Risks / Follow-ups

- Entry weights, thresholds, and Park constants require pilot calibration.
- Counsel must finalize age, consent, retention, deletion, and jurisdictional requirements.
- Grading thresholds remain owned by the future grading design.

## DECISION-0008 — Define Skill Evidence, Learner Override, and Publishing Ownership

**Date:** 2026-06-11
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0004
**Area:** Product

### Context

The unified model required clearer boundaries for what counts as the same skill, how Frame affects evidence, who chooses interventions, when success becomes independent, and whether public question pages belong to learning or marketing.

### Decision

Use an assessable skill target composed of canonical operation, required knowledge or concept cluster, and substantive success criterion, with representation and support recorded as facets. Use Frame for both diagnosis and teaching, but classify evidence according to what the Frame reveals. Recommend interventions with visible alternatives and learner override. Treat per-target time and stronger success thresholds as research items. Assign public student-question publishing primarily to marketing/content while requiring pedagogical and grading release gates.

### Rationale

This avoids counters that are either too broad or question-specific, preserves the evidentiary meaning of assistance, and implements the principle that Cramapple guides without dictating. It also keeps private learning evidence separate from acquisition publishing while protecting educational quality.

### Consequences

- Learner evidence stores target identity, representation, support, Frame type, recommendation, and override.
- A supported attempt cannot become independent merely through relabeling; a fresh unsupported transfer attempt is required.
- The product may recommend Move On but does not enforce an unvalidated pedagogical time cap.
- Marketing owns public packaging and distribution; validators own teaching and grading quality approval.

### Risks / Follow-ups

- AP Biology tutors must validate target-equivalence examples.
- Product research must establish stable-improvement thresholds and time budgets by task type and exam horizon.
- Analytics must distinguish recommendation acceptance, override, and outcome without penalizing learner agency.

## DECISION-0009 — Adopt Content Governance and Validation Operating Policy

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0005
**Area:** Architecture / Operations

### Context

The approved architecture requires immutable versioned content, source and
rights provenance, separate teaching and grading validators, independent release
gates, atomic exam-pack publication, monitoring, revalidation, retirement,
rollback, and audit. Exact operating rules and thresholds were still open.

### Decision

Adopt `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` as the controlling
operating procedure for content and rubric governance after Learning Quality
Owner, counsel, and Product Owner review.

### Rationale

The policy makes release authority, reviewer independence, qualifications,
schemas, acceptance criteria, numeric quality thresholds, refresh schedules,
and revalidation scope explicit and auditable.

### Consequences

- Content and rubric releases use immutable versions and complete manifests.
- Teaching and grading have independent reviewer and evidence gates.
- Source and rights status can block use independently of educational quality.
- Model, prompt, rubric, source, and policy changes receive defined
  revalidation scope.
- Implementation requires separate approved technical, security, and data work.

### Risks / Follow-ups

- Numeric thresholds require expert review and pilot evidence before adoption.
- Counsel must review official-material, license, retention, and public-use
  boundaries.
- Validator staffing and cost must be tested against launch coverage.
- Physical schemas and workbench implementation remain separate tasks.

## DECISION-0010 — Use Paid Tutors for Original Question Authoring

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

Cramapple needs a scalable original question bank. A proposed model would have
used historical College Board questions as seed material for a proprietary
question-making skill. That approach creates rights risk, derivative-content
risk, and weak accountability for question quality.

### Decision

Pay qualified tutors and subject experts to independently author original
questions and complete question packages from Cramapple coverage briefs.

Official historical questions and scoring materials are not seeds, adaptation
targets, few-shot examples, or generative-model inputs. Authorized humans may
review public official materials for abstract alignment where legally permitted,
but commissioned artifacts must be independently expressed.

Paid tutors create or sell Cramapple the base AP Biology packages. AI does not
draft base questions from official or third-party material. Controlled
versioning of Cramapple-owned or fully licensed packages is governed by
`DECISION-0011`.

### Rationale

Paid human authorship creates clear accountability, supports contractual
ownership and originality attestations, and separates exam familiarity from
copying or automated derivation. It also allows question quality to be improved
through structured author feedback without making official material part of the
production pipeline.

### Consequences

- Content coverage is commissioned from a coverage matrix rather than generated
  as a fixed number of derivatives per historical question.
- Tutor authors deliver complete question packages, not question text alone.
- Authors may revise but cannot approve their own work.
- Validation remains independent and includes scientific, teaching, grading,
  originality, provenance, and rights gates.
- Contracts must address compensation, confidentiality, originality, source
  disclosure, restricted materials, revisions, and IP assignment or license.

### Risks / Follow-ups

- Human authoring cost and throughput may constrain coverage.
- Tutor quality and writing skill will vary and require qualification.
- Independent similarity review is still required.
- Counsel must approve author agreements and official-material review guidance.

## DECISION-0011 — Define the Proprietary Question Bank and AI Versioning Model

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001
**Area:** Product / Operations

### Context

The paid-tutor model required decisions about bank coverage, MCQ and FRQ scope,
AI use, AP Reader eligibility, IP release, diagnostic lifecycle, and production
monitoring.

### Decision

- Use a human abstraction firewall. Official question text and scoring material
  do not enter the authoring or AI-versioning workflow.
- Include both MCQs and FRQs.
- Target at least ten approved questions for each subject-and-subtopic pair.
- Build the proprietary base set from Cramapple-authored and purchased question
  packages.
- Permit AI to create candidate variants only from proprietary packages for
  which Cramapple holds explicit adaptation, derivative-work, and model-input
  rights.
- Require a complete rubric and teaching package for every base question and
  every AI variant.
- Define an AP Reader Validator as someone who served as an AP Biology Reader
  in at least one of 2024, 2025, or 2026 and also meets the applicable Cramapple
  validator qualification.
- Use a simple counsel-approved release for authors, sellers, and AP Reader
  reviewers.
- Allow diagnostic questions to graduate to teaching use or be retired through
  a governed lifecycle decision.

### Rationale

This creates a coverage-driven proprietary bank while preserving human
accountability, contractual rights, exam authenticity, and independent
validation. AI expands owned content rather than deriving content from official
questions.

### Consequences

- AI variants are new immutable artifacts and do not inherit base approval.
- Superficial reskins do not count toward coverage targets.
- Question performance is monitored by version and intended use.
- Performance evidence opens review but does not automatically change item
  status until sample and decision thresholds are approved.
- AP Reader status does not authorize disclosure or use of secure material.

### Open Gates

- Minimum student sample and evidence thresholds for changing or retiring an
  item.
- Independent holdout set and passing thresholds for AI-versioning changes.
- Permitted sources and rights rules for graphs, datasets, experimental
  contexts, passages, and images.
- Final counsel-approved release language.

### Supersession Note

The quantity language in this decision is superseded by `DECISION-0014`, which
uses all 60 official topics and sets separate MCQ, short-FRQ, and long-FRQ
planning targets.

## DECISION-0012 — Require Local Documents to Be Synchronized to GitHub

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations

### Context

GitHub is Cramapple's durable source of truth, but project documents can still
be created or revised locally before they are pushed.

### Decision

Every project document retained in the local Cramapple workspace must also be
committed and pushed to `david-bloom/Cramapple`. A local-only document is not a
durable project record.

Temporary renders, caches, editor files, and operating-system metadata are not
project documents and should remain untracked.

### Rationale

This prevents source-of-truth drift, preserves work across machines and agents,
and ensures project decisions can be reconstructed from GitHub.

### Consequences

- Agents include all retained project documents in the relevant commit.
- Synchronization is complete only after the commit is pushed and the remote
  branch is verified.
- Any document that cannot be pushed must be reported explicitly.
- `.DS_Store` and comparable machine-local files are excluded.

### Risks / Follow-ups

- Sensitive information must not be placed in project documents merely to
  satisfy synchronization; secrets and protected data require approved secure
  storage.

## DECISION-0013 — Make Markdown the Default Project Document Medium

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A
**Area:** Operations / Documentation

### Context

Cramapple has accumulated Markdown, Word, RTF, spreadsheet, and other document
formats. Maintaining ordinary project documents in multiple editable formats
creates synchronization work and ambiguity about which copy governs.

### Decision

Markdown (`.md`) in GitHub is the default and canonical medium for project
documents.

Google Docs is the preferred secondary format when live collaboration,
comments, suggestion mode, or a cloud backup copy is useful. Accepted changes
must be incorporated into the canonical Markdown file.

Word (`.docx`) should be avoided unless a specific external recipient,
submission, printing, or layout-fidelity requirement makes it necessary. A Word
document must be derived from a canonical source and must not become an
independent competing source.

### Rationale

Markdown is easy to review, compare, version, search, and maintain in GitHub.
Google Docs supports human collaboration without replacing the source of truth.
Limiting Word documents reduces duplicate maintenance and format drift.

### Consequences

- Agents create ordinary durable project documents as Markdown by default.
- Google Docs are collaboration or backup copies, not authoritative records.
- Accepted Google Docs edits return to Markdown and GitHub.
- Existing Word snapshots may remain, but they are not refreshed by default.
- New or updated Word deliverables require a specific format need.
- Artifact-native formats such as spreadsheets, images, presentations, and
  executable source files remain appropriate when Markdown cannot represent the
  artifact itself.

### Risks / Follow-ups

- A Google Docs backup process and link registry may be defined later if needed.
- External stakeholders may occasionally require Word, PDF, or another format.

## DECISION-0014 — Adopt Corrected AP Biology Coverage and Diagnostic Direction

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0005 / CONTENT-001A
**Area:** Product / Content Operations / Architecture

### Context

Claude proposed a useful coverage model but calculated the bank using 48
topics. The current official AP Biology Course and Exam Description contains 60
topics, and the proposed table was internally inconsistent. The review also
identified unresolved definitions for inventory counting, pre-confirmation
diagnostic use, automated lifecycle changes, and physical database timing.

### Decision

- Use all 60 official public AP Biology topics as Cramapple's coverage taxonomy.
- Target at least ten approved MCQs and five approved short-FRQ prompts for each
  topic.
- Target four long-FRQ stimulus packages per unit, with two independently
  deliverable prompts per package.
- Count one MCQ or one independently delivered and answered FRQ prompt as one
  inventory item.
- Treat 964 items as the corrected full planning target: 600 MCQs, 300
  short-FRQ prompts, and 64 long-FRQ prompts.
- Work to meet or exceed the target; any launch shortfall requires a visible
  coverage-gap report, Learning Quality review, and Product Owner decision.
- Permit independently expert-curated diagnostic candidates to be used with
  students before empirical confirmation.
- Require statistical item signals to open human review. They do not
  automatically demote, retire, revise, or publish an item.
- Defer physical Supabase or Postgres design until the logical governance model
  and application architecture are approved.

### Rationale

The official taxonomy gives Cramapple a stable public alignment layer. Separate
targets for MCQs and FRQs support focused practice without confusing inventory
count with package workload. Human review preserves governance authority when
early item statistics are noisy or assignment is adaptive. Deferring physical
DDL prevents a premature schema from weakening immutable content, independent
approval, audit, and atomic-release requirements.

### Consequences

- `CONTENT_QUANTITY_AND_DISTRIBUTION.md` is the controlling planning matrix.
- The prior ten-total-questions quantity in `DECISION-0011` is superseded.
- The initial Claude patch and its 784-item calculation must not be applied.
- Diagnostic candidates may serve learners before statistical confirmation,
  while remaining clearly classified as expert-curated candidates.
- A later physical-schema task must implement the approved logical contracts
  rather than replacing them with mutable rows or direct approval booleans.

### Open Gates

- Learning Quality review of topic-level feasibility and content variety.
- Beta-launch coverage threshold and prioritization if 964 items are incomplete.
- Minimum sample sizes and statistical methods for item-performance review.
- AI-variant holdout policy and permitted source/asset rules.

## DECISION-0015 — Adopt a Governed Four-Lane Visual Architecture

**Date:** 2026-06-12
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0006
**Area:** Architecture / Product / Accessibility / Content Operations

### Context

The initial visual proposal recommended structured product-rendered data
visuals, prose fallback for diagrams, and deferral of image generation. Review
found that this direction reduces rendering risk but does not fully preserve
visual-assessment validity, accessibility equivalence, diagram coverage,
versioning, rights, or learner-created graphing.

### Proposed Decision

- Use deterministic structured rendering for semantic tables and common
  quantitative charts.
- Use governed human-authored assets or constrained domain renderers for
  diagrams, trees, models, and experimental setups.
- Require an accessible companion or separately validated equivalent for every
  visual.
- Do not silently replace a visual-dependent task with prose.
- Defer free-form generative scientific images from production.
- Treat learner-created graphing as a separate assessment capability.
- Define vendor-neutral logical artifacts before physical database design or
  renderer selection.

### Rationale

Visual interpretation and graph construction are assessed operations, not
presentation details. The architecture must give learners access without
revealing the answer or changing the skill being measured. Immutable visual,
dataset, accessibility, and renderer dependencies also preserve audit and
revalidation integrity.

### Consequences

- The 964-item content plan requires a representation audit.
- Common charts and phylogenetic trees become the first proposed prototypes.
- Semantic HTML is preferred for tables.
- Renderer upgrades require corpus-wide regression testing.
- Missing or unsupported visual equivalents fail closed.

### Risks / Follow-ups

- Product Owner direction is required on the five decisions in `TASK-0006`.
- Learning Quality, accessibility, and counsel reviews remain required.
- Graph construction may need a larger minimum viewport than chart viewing.
- Renderer and physical-schema decisions remain deferred.

## DECISION-0016 — Reject the Official-Derived Candidate and Use Abstract Failure Cards

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations / Rights / Quality

### Context

A proposed MCQ identified an official question as its source and changed the
organism, setting, and values. The same review found consequential quality
failures in other candidate questions.

### Decision

- Reject the official-derived item completely.
- Do not store it in the Cramapple repository, prompt library, exemplar pool,
  model inputs, evaluation sets, or production content.
- Preserve useful lessons from flawed candidates only as abstract failure cards
  and independently authored synthetic regression cases.
- Do not retain the original wording, distinctive scenario, organisms, values,
  answer choices, or source locator in an anti-example corpus.

### Rationale

Numerical and organism substitutions remain adaptation and violate the approved
human abstraction firewall. Abstract failure cards preserve quality lessons
without creating rights, contamination, or prompt-anchoring risk.

### Consequences

- The reviewed ZIP patches are not applied.
- Initial failure cards cover missing data, duplicate distractor logic,
  underdetermined predictions, omitted causal links, unsourced specificity,
  pseudoreplication, undefined thresholds, and exam-format mismatch.
- Future contaminated artifacts require documented scope review and exclusion.

### Risks / Follow-ups

- Counsel must define retention and deletion rules for contaminated working
  material outside the canonical repository.

## DECISION-0017 — Test Alternative Authoring Models Without Changing Production Policy

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Product / Content Operations / Experimentation

### Context

The reviewed proposal implicitly replaced paid tutor authorship with
AI-generated base questions seeded by exemplars. The potential quality, speed,
cost, and scaling differences are worth measuring, but an implicit replacement
would bypass approved governance.

### Decision

- Keep paid qualified tutors as the production base-package authors.
- Run a controlled validation-only experiment comparing tutor-first, AI-first
  with paid tutor revision, and AI-first with independent validation.
- Give all arms the same blank governed briefs, approved factual sources,
  package contracts, and independent gates.
- Prohibit official questions, adaptation descriptions, contaminated content,
  and evaluation holdouts from every arm.
- Do not count experimental items toward production coverage or publish them
  without a later Product Owner decision.

### Rationale

A blinded comparison can test the business model without allowing cost or speed
to override originality, scientific accuracy, educational quality, grading
reliability, accessibility, or accountability.

### Consequences

- `CONTENT_AUTHORING_MODEL_EXPERIMENT.md` controls the pilot design.
- Experiment execution still requires Learning Quality, counsel, participant,
  data-capture, and budget gates.
- Pilot success authorizes analysis, not production use.

### Risks / Follow-ups

- Validator labor can hide the true cost of weak AI drafts.
- Small pilot samples cannot establish broad equivalence.
- Long FRQs require a later replicated phase.

## DECISION-0018 — Use Versioned Prompt Build Manifests

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Proposed
**Related Task:** TASK-0007
**Area:** Architecture / Content Operations

### Context

The reviewed multi-subject proposal correctly separated shared, subject, and
question-type concerns but proposed loosely concatenating Markdown files and
premature physical database changes.

### Proposed Decision

Use immutable prompt build manifests that resolve universal governance, exam
pack, taxonomy schemes, task archetype, coverage brief, permitted sources or
base packages, output contract, failure-card suite, and model configuration.
Keep Markdown as the human-reviewable source while a deterministic compiler
records the ordered components and final prompt hash.

### Rationale

This preserves reviewability while making prompt assembly reproducible,
testable, provider-independent, and compatible with multiple parallel
taxonomies and future subjects.

### Consequences

- Multi-subject support remains logical rather than physical.
- External pipeline services, not model self-critique, own authoritative
  verification.
- Physical Supabase design remains deferred.

### Risks / Follow-ups

- The compiler and manifest schema require a later approved implementation
  task.

## DECISION-0019 — Create a Clean Proprietary Replacement Exemplar

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0008
**Area:** Content Operations / Rights

### Context

The rejected official-derived candidate left the authoring workflow without its
intended first MCQ exemplar.

### Decision

Create a replacement from a blank governed brief through a paid qualified tutor
who has not received the rejected candidate or its source description. The new
package must pass the complete originality, rights, scientific, teaching,
grading, accessibility, and exemplar-admission gates.

### Consequences

- The rejected candidate is not repaired or used as inspiration.
- Approval as production content does not automatically approve use as a model
  exemplar.
- `TASK-0008` owns the replacement workflow.

## DECISION-0020 — Reconcile Schemas Before Physical Database Design

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0009
**Area:** Architecture / Data Governance

### Context

The reviewed Supabase proposals contain useful entities but use mutable content
rows, approval booleans, direct state updates, and cascade deletion that
conflict with approved governance.

### Decision

Create a conceptual reconciliation model mapping useful schema concepts to
immutable artifact versions, append-only reviews and lifecycle events,
rebuildable projections, reusable stimulus packages, and atomic release
manifests. Do not create or approve physical DDL until reconciliation passes.

Text-only visual storage is not accepted as the permanent approach. Authoring
may proceed against logical stimulus-package Markdown and JSON contracts while
physical design remains deferred.

### Consequences

- The archive schemas are inputs to analysis, not canonical schemas.
- `TASK-0009` precedes physical Supabase design.
- Structured visual work does not need to wait for DDL.

## DECISION-0021 — Develop MCQ and FRQ Authoring Simultaneously

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0007
**Area:** Content Operations

### Context

The reviewed proposal deferred FRQ implementation until MCQ authoring reached
coverage. That sequence would delay discovery of grading, visual, and graphing
risks.

### Decision

Run coordinated MCQ and FRQ authoring workstreams simultaneously. Share
governance and infrastructure, but preserve separate package contracts and
independent gates.

All currently reviewed FRQs remain unapproved candidates. Tutors and AP Reader
Validators may edit them into new immutable versions or drop them.

### Consequences

- Neither question form blocks initial architecture work on the other.
- Candidate FRQs are not exemplars, calibration evidence, or production
  content.
- The first vertical slice includes MCQ, short FRQ, and long FRQ packages.

## DECISION-0022 — Research Paper-First Handwritten Graph Capture

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for Research
**Related Task:** TASK-0011
**Area:** Product / Assessment / Accessibility

### Context

A general digital graph editor would be complex and may be less authentic than
paper graph construction.

### Decision

Prefer paper-first graphing and research a QR-linked secure phone camera flow.
The system may assist with image quality and feature extraction, but uncertain
graphs require retake or human review.

### Consequences

- Digital drawing is not the default graph-construction plan.
- Production use requires upload-security, privacy, accessibility, usability,
  and held-out grading validation.
- `TASK-0011` is a research placeholder, not implementation approval.

## DECISION-0023 — Resolve Official Exam Dates from the Exam Specification

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** UX-001
**Area:** Product / Architecture

### Context

The first-run UX asked students to enter the date of a standardized AP exam
whose official schedule is already known to Cramapple.

### Decision

Resolve and display the official date from the active versioned exam
specification. Ask the learner to confirm registration status instead of
entering the date.

### Rationale

The exam authority, not the learner, defines the official date. Treating it as
system data removes avoidable input burden and prevents conflicting dates while
still capturing the learner-specific fact that affects reminders and planning.

### Consequences

- Learner setup stores registration status, not a user-entered official date.
- The UX supports registered, not registered yet, and unsure states.
- Missing official-date data is a system-data problem and must not be shifted
  to the learner.
- Registration itself remains outside Cramapple and occurs through a school or
  AP coordinator.

## DECISION-0024 — Use Staged Tutor and AP Reader Candidate Review

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-002
**Area:** Product / Content Operations

### Context

Cramapple needs a simple reviewer workflow for deciding whether original
question candidates and MCQ answer options should advance, be revised, or be
excluded.

### Decision

Use two independent tutor scores of 1 Yes, 2 Maybe, or 3 No. Sum the locked
tutor scores: aggregate 2 advances to AP Reader review, aggregate 3 reserves a
new version for modification and reassessment, and aggregate 4-6 excludes the
current version.

Use AP Reader scores of 1 Approve, 2 Edit and recycle to two tutors, and
3 Exclude. Apply the same staged review independently to each of the four MCQ
answer options after the question passes question review.

### Rationale

The model is easy to teach, preserves two independent tutor judgments, creates
a clear expert escalation, and prevents edits from inheriting approval.

### Consequences

- Any excluded answer excludes the current four-option MCQ package.
- All four answers must pass before answer review is complete.
- Edits create new immutable versions and reset the affected review.
- Every question receives two tutor difficulty labels; a question reaching AP
  Reader review receives the third label.
- Exact agreement confirms difficulty; disagreement creates a discussion item.
- This workflow decides candidate disposition and does not replace downstream
  content-governance or release gates.

## DECISION-0025 — Use a Verified Five-Stage Outside-Question Intake

**Date:** 2026-06-13
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-004
**Area:** Product / Learning / Trust

### Context

Students may bring incomplete, photographed, copyrighted, personally
identifying, off-subject, or actively assessed questions. A single text box
does not provide enough context or trust handling.

### Decision

Use five stages: add the question, confirm capture, confirm match, choose help,
and review before beginning. Support typed/pasted, photo/screenshot, and
document concepts. Use one clarification round for missing context or relevance
and disclose confidence before teaching or grading.

### Rationale

The staged flow preserves the student's real intent while preventing extraction
errors, missing context, and uncertain classification from silently becoming
confident teaching or scoring.

### Consequences

- Check My Work requires the learner's attempted answer.
- Low-confidence matches avoid authoritative scoring.
- External questions remain isolated from canonical content.
- Anonymous improvement and public publication remain separate.
- A conservative active-assessment prototype limits solution and answer-check
  behavior, but final enforcement awaits the approved academic-integrity
  policy.
- Photo and document implementation remains blocked on upload security,
  privacy, rights, retention, and provider decisions.

## DECISION-0026 — Separate Authoring, Revision, and Independent Review

**Date:** 2026-06-15
**Decision Owner:** David Bloom
**Status:** Approved for UX Design
**Related Task:** UX-003
**Area:** Product / Content Operations / Rights

### Context

UX-002 can reserve or recycle a question or answer version, but it previously
had no designed interface where an author could receive the task, revise the
complete package, preserve provenance, and return a successor version for
reassessment.

### Decision

Use UX-003 as a content authoring and revision workbench. It owns assigned-work
acknowledgement, complete MCQ and FRQ package editing, document import,
reviewer-comment response, immutable version comparison, provenance and rights
capture, preflight, and resubmission.

Keep UX-002 as the independent scoring and disposition surface. Qualified users
may switch between modes, but cannot review work they authored, revised, or
collaborated on.

Renumber the student-provided question intake to UX-004.

### Rationale

This gives recycled review outcomes an operational destination while preserving
reviewer independence, immutable history, complete-package integrity, and
rights controls.

### Consequences

- Tutor aggregate 3, AP Reader score 2, and revision outcomes create UX-003
  tasks.
- Resubmission creates a new immutable version and returns it to the required
  reassessment queue.
- Autosaves remain drafts and are not version history.
- Reviewer comments remain immutable; authors attach responses and changes.
- Provenance and rights checks can block submission without implying counsel
  approval.
- UX-004 now identifies student-provided question intake.

## DECISION-0027 — Adopt Charter Simplification and Tiering (Pilot: Cramapple Only)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

The AI Project Operating Kit, in production use on Cramapple and PassTo, had accumulated real friction: heavy approval ceremony routed entirely through the Product Owner, duplicated guidance across charter docs (most visibly the sync handshake, repeated near-verbatim in five files), self-reported "synced"/"done" claims with nothing checking them, and unrotated logs already running to 1,000+ lines. Two independent reviews (`docs/proposals/2026-06-14-team-charter-improvements.md` and `docs/proposals/2026-06-23-kit-simplification-memo.md`) converged on largely the same diagnosis but had six unreconciled points of conflict between them.

### Decision

Adopt, into Cramapple's `docs/team_charter/` only (the public `ai-project-operating-kit` repo is explicitly out of scope for this decision):

- The full content of `docs/proposals/2026-06-23-kit-simplification-memo.md`.
- Proposals 1, 2 (recording structure/SLA substrate, not its deferred automation), 3, 4, 5 (reconciled), 7, 8 (reconciled), and 9 of `docs/proposals/2026-06-14-team-charter-improvements.md`.
- Not adopted: Proposal 6 and Proposal 10 of the 06-14 proposal — out of scope, not depended on by the simplification memo.

Conflict resolutions (see `APPROVAL-0022` for full detail): the 6-state status taxonomy wins over keeping `QA Passed`/`QA Blocked` distinct, with Proposal 5's actual safety property (only the Main Conductor closes a task) preserved as a role rule; `APPROVALS_LOG.md` stays a separate file rather than merging into `DECISIONS_LOG.md`, since Proposal 2's structure is the substrate the new Standing-tier SLA depends on.

### Rationale

Both proposals identified the same root cause from different angles: high-stakes process machinery was being applied uniformly regardless of actual risk. The fix is conditional rigor, not less rigor — ambiguous-but-reversible work gets a clarifying question instead of an automatic hard gate; domain-specific decisions go to a named delegate instead of always to the Product Owner; small reversible work skips ceremony it doesn't need; sync claims get a real check instead of a narrated one; and the two governance docs that disagreed on six points needed to be reconciled before either was implementable, not adopted independently.

### Consequences

- Seven `docs/team_charter/` documents changed; `SKILLS_GUIDE.md` renamed to `TOOL_AND_INTEGRATION_GUIDE.md`; two new files added (`CHANGELOG.md`, `scripts/verify-sync.sh`); both new-session prompts updated; `docs/tasks/TASK_TEMPLATE.md` gained a `Tier` field; all three activity logs gained an index block and a stated (not yet executed) rotation rule.
- Existing tasks and log entries are **not** retroactively rewritten onto the new status vocabulary or tiering scheme — old entries read under the rules in force when they were written.
- The public `ai-project-operating-kit` repository is untouched. Upstreaming is a separate future decision, contingent on this pilot working in practice.

### Risks / Follow-ups

- Two leading indicators should be watched for a few weeks: hard-gate escalations per week, and QA round-trips per task. No tooling collects these automatically yet — this is currently a manual read of `APPROVALS_LOG.md` and `DECISIONS_LOG.md`.
- `DECISIONS_LOG.md` is already roughly double its newly-stated rotation threshold (~600 lines); the first archive pass is overdue and not done as part of this decision.
- Proposal 2's batch-approval expiration automation, Proposal 6, and Proposal 10 (Cross-Agent Notes) remain candidates for separate future decisions.
- This decision does not authorize pushing any of this work to `github.com/david-bloom/ai-project-operating-kit`.

## DECISION-0028 — Auto-Trigger QA and Model Routing (Codex Proposal Folded In)

**Date:** 2026-06-23
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (governance/process)
**Area:** Operations

### Context

`docs/proposals/2026-06-23-agent-routing-and-qa-proposal-for-claude.md` (Codex) observed that the charter adopted under DECISION-0027, while reducing approval ceremony, still left QA-triggering and model selection as things someone had to remember to ask for, rather than automatic workflow steps — a residual source of avoidable waiting.

### Decision

Fold into `AGENT_OPERATING_MODEL.md`:

- The Main Conductor auto-triggers QA for any `Standard`/`Hard-Gate` tier task reaching `Ready for Review`; `Micro` tier QA remains optional at the conductor's judgment.
- The Main Conductor auto-applies the Model and Effort Policy per agent call rather than asking the Product Owner to pick a model each time.
- Explicit good-use/bad-use guidance for spawning additional agents, and three new Anti-Patterns reflecting the above.

The proposal's guardrail requiring the orchestrator to record which model was used and why on every call was narrowed to: record only on deviation from the default tier.

### Rationale

Auto-triggering QA and model selection removes waiting without removing any approval boundary — QA was already Lane 1 standing-approved, this just makes it fire automatically instead of on request, and model choice was never itself a hard-gated decision. Recording every routine model choice would have reintroduced exactly the ceremony DECISION-0027 was trying to remove; recording only deviations keeps the audit trail useful instead of noisy.

### Consequences

- `AGENT_OPERATING_MODEL.md` gains explicit auto-trigger language in the Main Conductor and QA Agent sections, a narrowed recording requirement in Model and Effort Policy, agent-spawning good-use/bad-use guidance in the Default Pattern section, and three new Anti-Patterns.
- No change to any Hard Gate, Standing Approval Lane, or Delegated Domain Approval boundary from DECISION-0027 — this decision is additive process automation, not a new approval grant.

### Risks / Follow-ups

- If auto-triggered QA produces a backlog of QA work outpacing available QA-agent capacity, revisit whether `Standard` tier should auto-trigger QA at the same rate as `Hard-Gate` tier, or whether `Standard` should batch.
- Same success metrics as DECISION-0027 (hard-gate escalations/week, QA round-trips/task) apply; no new metric introduced for this decision specifically.

## DECISION-0029 — ALLOWED_ORIGINS Required in All Environments; No Wildcard CORS Fallback

**Date:** 2026-06-21
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Security

### Context

PR #14 introduced an `ALLOWED_ORIGINS` env-driven allow-list in
`supabase/functions/_shared/cors.ts`. The first cut kept a wildcard
fallback (`Access-Control-Allow-Origin: *`) when the env was unset, on
the rationale that dev / local convenience was worth the production risk
of a missed deployment checklist item.

QA flagged the wildcard fallback as a real production footgun. With no
code-level guard, a production deploy without `ALLOWED_ORIGINS` would
silently send `*` and weaken defense-in-depth against CSRF-style abuse
from rogue origins.

### Decision

`ALLOWED_ORIGINS` is required in every environment (production, beta,
preview, local dev). The Edge Function `_shared/cors.ts` module fails
fast at load time if the env is unset or parses to an empty list. There
is no wildcard fallback path in the code.

Local-dev convention:

```
ALLOWED_ORIGINS=http://localhost:5173,http://localhost:3000,https://cramapple-beta.lovable.app
```

### Rationale

- Production wildcard CORS is a real risk; the dev cost of setting one
  env var is trivial.
- Eliminating the conditional removes a class of operational error
  (forget the checklist item, ship wildcard to prod).
- Non-browser callers (curl, server-to-server, CI) don't need CORS
  headers and are unaffected by the strict policy.

### Consequences

- All Cramapple deploys (Supabase Edge Functions in production and dev,
  any future preview environment, local Supabase) must set
  `ALLOWED_ORIGINS` before functions can start. The function will throw
  `Missing required environment variable: ALLOWED_ORIGINS` at module
  load otherwise.
- The `corsHeaders` legacy export with `Access-Control-Allow-Origin: *`
  has been removed; nothing in the repo imported it.
- The deployment checklist gains one mandatory env var per environment.

### Risks / Follow-ups

- First-time local-dev setup must include the env. Document in any
  developer-onboarding instructions (no such doc exists yet — when one
  lands, the env example above belongs in it).
- Future preview / staging environments need their origins added.
- This decision does not address Decision 2 (failed/rejected grading
  and the daily budget cap), which remains pending owner direction.

## DECISION-0030 — Failed/Rejected Grading Burns the Daily Budget Cap When Cost Is Known

**Date:** 2026-06-22
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0012
**Area:** Cost control

### Context

`app.complete_model_usage` (introduced in `202606210004_daily_budget_row_lock.sql`)
burned `actual_cost_usd` against `OPENAI_DAILY_CAP_USD` only when a
grading call completed successfully. Any `failed` or `rejected`
outcome burned `0`, regardless of whether the provider call had
already incurred a real, known cost (e.g. OpenAI returned a billable
response but Cramapple's own downstream validation then rejected it).
This under-counted real spend against the daily cap.

### Decision

`app.complete_model_usage` now burns cost as follows:

- `completed` — burns `actual_cost_usd` (unchanged).
- `failed` / `rejected` with a non-null `actual_cost_usd` — burns
  `actual_cost_usd`.
- `failed` / `rejected` with a null `actual_cost_usd` — burns `0`
  (caller has no cost data to report; the provider call may never have
  happened).

Implemented in
`202606210010_complete_model_usage_burn_known_cost_on_failure.sql`.
Reservation-release behavior (`reserved_cost_usd` reduction on the
`app.daily_budgets` row) is unchanged.

### Rationale

- `OPENAI_DAILY_CAP_USD` should track real provider spend, not just
  spend on calls that happened to finish cleanly. A failed call that
  still cost money is still money spent.
- Burning `0` only when the cost is genuinely unknown avoids inventing
  a cost figure for calls that never reached the provider.

### Consequences

- Grading calls that fail after the provider responds (with usage
  data) now reduce remaining daily budget headroom.
- `supabase/functions/evaluate-attempt/index.ts` is unaffected by this
  migration — it already passes whatever `actual_cost_usd` it computed
  (defaulting to `0` if the provider call never returned usage), so no
  Edge Function change was required.

### Risks / Follow-ups

- Failed rows that complete with a null `actual_cost_usd` are not
  reconciled against provider billing by this migration. That
  reconciliation should happen during production monitoring — compare
  `app.model_usage_ledger` against the OpenAI usage dashboard/API — not
  be guessed at here.
- No real Postgres instance was available to apply this migration
  (Docker/Colima/Podman unavailable in this environment); verification
  was `deno check` / `deno fmt --check` (no Edge Function files
  changed) plus manual schema cross-reference against
  `202606210004_daily_budget_row_lock.sql` and
  `202606210008_reserve_model_usage_race_fix.sql`.

## DECISION-0031 — Launch AP Statistics as Subject 2, Reusing the Tutor-Authored Content Model

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Product / Architecture / Operations

### Context

Cramapple's architecture was designed for multiple subjects
(`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6, `app.subjects` schema
normalization) but only AP Biology is built and live. David requested an
assessment of which AP subject — among AP Statistics, AP Calculus AB, and AP
English Literature (Orly's subjects this year) and AP World History (Micah's)
— is the closest technical match to AP Biology, then asked for a launch plan.

### Decision

1. AP Statistics is Subject 2. It ranked closest to AP Biology on
   grading-architecture reuse: criterion/rubric-scored FRQs with quantitative
   thresholds (same scoring shape as Biology's FRQ criterion contracts), and
   it needs a verification technique (deterministic calculation checks)
   already named but unbuilt in §7, rather than a wholly new grading
   paradigm (e.g. holistic essay scoring, which AP English Literature would
   require).
2. Content sourcing reuses the existing tutor-authored-base-package model
   (TASK-0007/0008) under Orly — no new authoring arm.
3. The pilot content batch follows AP Statistics' 9-unit structure with
   per-unit MCQ/FRQ counts David provided (71 MCQs / 33 FRQs total across
   units 1–9; investigative-task form and count still TBD — see
   `TASK-0013-AP-STATISTICS-LAUNCH.md` Approval State for the full table).
4. Existing reviewers can be cross-credentialed across subjects, including
   AP Statistics — no new tutor pool required for the review/calibration
   pipeline.
5. Rights/licensing posture is unchanged from AP Biology: no official
   CollegeBoard material as model input or exemplar. This was already
   settled policy and is restated here for the record, not reopened.

Full phased delegation plan (Codex / Lovable / Orly / David) recorded in
`docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`.

### Rationale

Maximize reuse of the grading/verification investment already made for AP
Biology, and avoid opening a new content-ownership or tutor-credentialing
relationship at the same time as a new subject.

### Consequences

- Phase 1 (de-hardcoding `grade-frq`/`evaluate-attempt` away from literal "AP
  Biology" strings, wiring the prompt-build manifest to `subject_id`) is
  cleared for Codex to execute — it was the one piece blocking any second
  subject regardless of which one was chosen.
- The investigative-task archetype is not yet defined and blocks Phase 4
  content authoring for that item type specifically; it does not block the
  MCQ/FRQ portions of the pilot batch.
- No target date is set for the pilot batch yet — pending Orly's bandwidth
  confirmation alongside ongoing AP Biology work.

## DECISION-0032 — Authorize TASK-0013 Phase 2 Database Migration (AP Statistics Schema)

**Date:** 2026-06-30
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** TASK-0013
**Area:** Architecture / Operations

### Context

`TASK-0013`'s overall Hard-Gate approval (`DECISION-0031`) covered subject
selection, content-sourcing model, and pilot batch composition — it did not
cover the Phase 2 database migration itself. `STANDING_APPROVAL_LANES.md`
Lane 3 lists database migrations as their own Hard Gate, separate from
"implementation not already covered by an approved task," so Phase 2's
migration (`prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`)
was drafted but explicitly marked do-not-execute pending a separate
sign-off.

### Decision

David authorized the Phase 2 migration to proceed, in the same exchange
where Phase 3 (PR #24) was confirmed merged. Scope: one additive,
idempotent migration inserting an `app.subjects` row for AP Statistics, an
`app.exam_packs`/`exam_pack_versions` pair (version `status: 'draft'`, not
`'published'`), and `app.content_labels` rows for the 9 AP Statistics units
— exactly as scoped in the Phase 2 prompt. No other migration is authorized
by this decision.

### Rationale

Phase 1 (subject-driven grading) and Phase 3 (calculation verifier) are
both complete and merged with passing independent QA. The schema work is
additive-only and was deliberately scoped (draft status, no publish) to
stay inert until content actually exists, so the blast radius of proceeding
now is low.

### Consequences

- `prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`'s
  do-not-execute condition is satisfied; Codex is cleared to execute it.
- Phase 4 (content authoring) unblocks once Phase 2 lands.
- This decision does not authorize publishing the exam pack, content
  labels, or any content — that remains a separate decision per the
  prompt's explicit scope boundary.

## DECISION-0035 — Resolve Phase 0 of the Backend Consolidation Migration (Schema Reconciliation, Option A/A2)

**Date:** 2026-07-09
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (Backend Consolidation & Migration Plan, 2026-07-08)
**Area:** Architecture / Integration

### Context

The live Lovable app (Supabase project `tazjfzphsevtgervlyit`, `public.*`, ~26
tables) and Production (`pcntajvbdfqhbeewmdry`, `app.*`, ~60 tables, RPC/view
design) are two independently-built, diverged schemas — the root cause of
"published content doesn't appear in the app." The plan
(`docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`, with the
mapping in `APP_SCHEMA_RECONCILIATION_2026_07_08.md`) already chose **Option A /
A2**: adapt the app to the `app` schema via a curated `public` interface (views
for reads + `supabase.rpc(...)` for writes), not a table-for-table env flip.
Phase 0 (decisions only) blocked all downstream work and was reserved for the
Product Owner. This entry resolves it.

### Decision

1. **Review workflow →** the reviewer UI targets **`content_review_*`**
   (content-version review: `app.content_review_assignments` /
   `content_review_decisions`), not the artifact-review `review_*` tables.
2. **Auth users →** **start fresh** in Production; the Lovable-Cloud users on
   `tazjfzphsevtgervlyit` do NOT carry over (treated as pre-beta/test accounts).
3. **Anonymous practice →** **No** — require sign-in on prod. Drop
   `anonymous_sessions`; curated views grant only `authenticated` (no `anon`).
4. **App AI keys →** move the app's own AI features to **`OPENAI_API_KEY`**
   (already set), off the Lovable AI Gateway. (Distinct from the grading runners'
   Vercel AI Gateway, which is unchanged.)
5. **Gap tables →** `config`: **add a small `app.config`** KV table (exposed via a
   curated read view). Drop `anonymous_sessions`, `capture_sessions` (re-add when
   the TASK-0011 capture path lands), `idempotency_keys` (use
   `grading_results.request_id/request_hash`), and `predictions` (embedded in
   `grading_results`). Adapt the app to the **`blind_group_id` column** instead of
   a `review_blind_groups` table. **Rebuild the 6 `dashboard_*_v1` views** as
   `public` views over `app`.

### Rationale

Each choice minimizes surface and churn for an Aug-2026 beta: `content_review_*`
matches a pre-launch content-vetting reviewer UI; fresh auth avoids a `pg_dump`
migration of throwaway accounts; sign-in-only shrinks the public API surface;
`OPENAI_API_KEY` decouples the app's AI from Lovable now that the key exists; the
gap-table dispositions follow the schema's existing design (idempotency and
predictions already live in `grading_results`; blind grouping is already a
column).

### Consequences

- **Unblocks Phase 1** (Codex: build the curated `public` interface — views +
  RPC confirmation over `app`, incl. `app.config` and rebuilt `dashboard_*_v1`)
  and **Phase 2** (Lovable: repoint to the curated interface, native Supabase
  Google OAuth, `.env`/`config.toml` → Production).
- Docs `BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md` §7 and
  `APP_SCHEMA_RECONCILIATION_2026_07_08.md` gap table updated to "resolved."
- Phase 1 build spec captured in
  `prompts/CODEX_BACKEND_CONSOLIDATION_PHASE1_CURATED_INTERFACE.md`.

### Risks / Follow-ups

- "Start fresh" auth assumes the current Lovable-Cloud users are not real
  beta users with data to preserve — reconfirm before disabling Lovable Cloud.
- `content_review_*` pick should be validated against the actual reviewer UI
  routes during Phase 2; if the UI also grades artifacts, revisit (the "both"
  option was declined).
- Migration docs and this decision originate on branch
  `claude/backend-consolidation-migration` (off `main`). `main` is at
  DECISION-0032; branches for DECISION-0033/0034 are outstanding. If numbering
  collides on merge, renumber whichever merges second and update the index.

## DECISION-0039 — Adopt Branch Hygiene Rules (R1–R7) to Resolve and Prevent Branch Sprawl

**Date:** 2026-07-26
**Decision Owner:** David Bloom
**Status:** Approved
**Related Task:** N/A (operating-model / charter change)
**Area:** Operations

### Context

Recurring branch sprawl (20 local / 21 remote branches, 9 worktrees, per-session
branch names, unmerged divergence, orphaned uncommitted work) caused real work loss.
Reconciled across Claude v1 → Codex second opinion → PR #54 review rounds 1–2.

### Decision

Adopt R1–R7: (R1) branch = one reviewable slice named
`<agent>/<task-or-work-id>-<slug>`, continue-don't-fork; (R2) continuation via the
canonical task record's `Branch`/`PR` fields, machine-local paths ephemeral; (R3)
integrate small slices via small PRs, no standing integration branches; (R4) durable
session close (commit-and-push checkpoint; explicit dirty-state handoff if
interrupted); (R5) readiness (human) separated from execution (GitHub-native
auto-merge/merge-queue), custom privileged agent contingent not default; (R6)
delete-on-merge of the remote head, local cleanup client-side, archive-tag only
unique unmerged work; (R7) removal preflight = no uncommitted changes + no unique
commits + no unpushed refs. Trunk protection: no normal direct commits to `main`;
force-push/deletion blocked; human-only break-glass.

### Rationale

Per-session branching + slow integration + no cleanup was the root cause; branch =
slice + task-record continuation is the highest-leverage fix. GitHub-native
automation is preferred over a custom privileged agent for lower privilege/risk.
See APPROVAL-0027 and the source proposal (merged PR #54).

### Consequences

- Charter + session prompts now require branch-per-slice, task-record continuation,
  durable session close, and delete-on-merge; agents follow R1–R7 going forward.
- `main` is the single integrated-truth trunk; active work stays on scoped branches
  until reviewable.

### Risks / Follow-ups

- Operational enforcement (main branch protection, required CI checks, native
  auto-merge) is not yet in place — sequenced separately in the proposal (steps 5–9).
- One-time cleanup of the existing 20 branches / 9 worktrees is a separate phased
  pass (step 10), from a clean checkout, after recovery PRs #50–#52 finish.
- Numbering: DECISION-0039 / APPROVAL-0027 were allocated above open-PR claims
  (#38/#39/#43 claim 0026/0036, #39 up to 0038); recheck open PRs immediately before
  merge and renumber the later-merging branch on any collision.
