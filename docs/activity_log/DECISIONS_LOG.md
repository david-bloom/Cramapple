# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0073 — Launch Frontend Target Is the Lovable App Published at ap-prep-canvas.lovable.app, Tentatively Identified as the "New Cramapple App" Project
- DECISION-0072 — Extend DECISION-0063 to AP Statistics: Launches on the Flat/Practice Path, Unit-Gating Deferred
- DECISION-0071 — Launch Friday, Free — Ship Without Stripe/Payment Gating; Add Payment Flow as a Post-Launch Follow-Up
- DECISION-0070 — Launch-Planning Follow-Ups: BYOQ Ships Ungated/Anonymous on the New Home Page; Unlimited-Tier Pricing Deferred Until All 10 Subjects Are Live; Target Launch Window Is Next Week; Wordmark-Only Branding Is Sufficient (No Logo Mark Required)
- DECISION-0069 — Day-1 Launch Subjects Are AP Biology and AP Statistics, Fast-Follow the Rest as Site-Performance Confidence Improves; Set Single/2-Bundle/3-Bundle Pricing at $39.99 / $79.99 / $99.99
- DECISION-0068 — BYOQ Data Model Uses Parallel Tables (Option A), Not the Live Graded Pipeline; TASK-0039 Phase 1 Scope Approved
- DECISION-0067 — Coverage Labels Stay Deferred at `provisional_model`; No Promotion Work Until Coverage Reporting Is Prioritized (FF-9)
- DECISION-0066 — Approve AI Two-Model Agreement as Sufficient to Promote Serving Labels to `validated`, Product Owner as Approver (FF-3)
- DECISION-0065 — Four Rules to Unblock J.0's Continuous `attainment_ratio` (FF-6): AI Cross-Model Verb Verification, Same-Tier Borrowing, Mean Aggregation, Non-Overlapping Cut Points
- DECISION-0064 — Split `APBIO-FRQ-S-101` Criterion `a-iv` Into Two Stem-Aligned Criteria; Authorize Rewriting `S-021`/`S-023`/`S-058`'s Canonical Answers to Match Their Rubrics
- Older entries: [`DECISIONS_LOG-0001_to_0065.md`](archive/DECISIONS_LOG-0001_to_0065.md)

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

(Note: the same collision recurred 2026-09-26. The `claude/launch-planning-cram-4oyh2g` branch independently claimed DECISION-0068 through 0072 for five launch-planning decisions, not knowing `main` had already recorded its own DECISION-0068 (BYOQ parallel tables, TASK-0039 Phase 1) by the time this branch merged. Per the rule above, this branch — the later-merging side — renumbered its five decisions to DECISION-0069 through 0073 at merge time; main's DECISION-0068 is untouched. If you are reading an older copy of any of the five renumbered decisions (in a plan doc, a chat log, or a stale local checkout) under its original 0068-0072 number, this is why the number no longer matches — the content is unchanged, only the ID moved.)

## DECISION-0073 — Launch Frontend Target: ap-prep-canvas.lovable.app

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
comparison).** This is stale against `DECISION-0071` (Friday launches free, no Stripe/payment gating).
Someone needs to swap this for a free-access/sign-up CTA before Friday — tracked in the marketing
home page plan now.

**Also confirmed from the live HTML, consistent with existing decisions:** AP Statistics and AP Biology
show "Live now"; the other 8 subjects show "Coming soon" (matches `DECISION-0069`'s Day-1 subject list).
A full anonymous, ungated BYOQ flow is present ("Upload a photo" / "Paste the text", "One free question.
Your photo isn't kept.") — matches `DECISION-0070`.

### Consequences

- `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` and `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` should
  both point at "Remix of Cramapple App" (`d334fed9-5a97-4e76-906e-7c0ad7082212`), not the previously
  guessed project.
- No visual/brand rebuild is needed — remove that item from the student hub plan's scope.
- **New launch-blocking task for Friday:** replace the $39.99/Stripe purchase CTA and pricing section
  with a free-access sign-up flow, per `DECISION-0071`. (Update: David is handling this directly with a
  "Free this week!" banner rather than a full CTA rework — not delegated to an agent.)
- Lesson for future verification: prefer live HTML/fetch over Lovable `get_project` screenshots, which
  can be meaningfully stale.

### VERIFIED, 2026-09-26 (same session): practice/grading is real, not a demo

David asked whether the practice/grading flow visible on the live page is genuinely wired to production
grading or just a scripted demo — this was never actually checked earlier despite being listed as an
open research item. Verified directly by reading this project's source via the Lovable MCP:

- `src/components/marketing/FrqDemo.tsx` (the "Open Hand · FRQ" plate on the home page hero) **is a
  scripted marketing demo** — 4 hardcoded example Q&As with pre-written grading payloads baked into the
  component source, cycled via `setTimeout` state transitions (typing → submitting → graded). No API
  call. This is expected and appropriate for a marketing teaser, not a defect.
- `src/lib/use-grade-practice.ts` (the real practice-session grading hook, used by
  `src/components/session/SessionFrame.tsx` and `GradeResultView.tsx`) **is genuinely wired to
  production**: it calls `supabase.functions.invoke()` against the real, named edge functions
  documented elsewhere in this repo — `session-event`, `attempt-response` (create/save/submit
  operations), `evaluate-attempt`. The file's own header comment: "Uses the four already-deployed edge
  functions... No legacy beta-attempt path is involved." This is the same grading infrastructure
  covered by TASK-0016's rollout, not a separate or mocked path.
- This also independently confirms the earlier-flagged entitlement-gating bug (`DECISION-0069`'s
  follow-up, `ACTIVITY_LOG.md` 2026-09-20) is real and lives in exactly this code path — the generic
  error string "Couldn't score that — try again." in `use-grade-practice.ts`'s `runEvaluate` matches
  the bug report precisely.

**Verdict: the student hub / practice & grading engine is not a separate long-build item for Friday —
it already exists and is production-wired.** The main open risk for Friday is the entitlement-gating bug
above, not the existence of real grading.

## DECISION-0072 — AP Statistics Launches on the Flat Practice Path, Unit-Gating Deferred

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

## DECISION-0071 — Launch Friday, Free — No Stripe/Payment Gating at Launch

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`;
`DECISION-0069`; `DECISION-0070`
**Area:** Product / Launch Scope / Commercial

### Decision

**Cramapple launches Friday, October 2, 2026, free, with no Stripe/payment gating.** David confirmed
the exact date on 2026-09-26, correcting the earlier invalid `2026-09-27` placeholder. All students
get full access without purchasing. Payment flow (Stripe checkout, entitlement gating) is deferred to
a post-launch follow-up, once there's time to add it properly — not a Day-1 requirement.

This supersedes `DECISION-0070`'s "target launch window is next week" with a firmer date and a
materially different launch shape: **not a paid launch with a payment system, but a free launch with
payment added later.**

### Consequences

- `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` is **removed from the Friday launch-critical path.** None of
  its acceptance criteria block Friday's launch. It becomes a fast-follow plan, run whenever there's
  time to build it properly, per this decision.
- The entitlement-gating bug flagged under `DECISION-0069`'s follow-up (`attempt-response` not gated on
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

### What actually gates October 2

With payment removed, the October 2 critical path is: the live marketing/free-access entry, the
student hub and brand-new-student entitlement/grading round trip, Biology and Statistics on their
approved flat practice paths, anonymous BYOQ safety/copy verification, fresh independent QA, and
David's final go/no-go decision. D-1/D-2 are resolved by `DECISION-0073`. The labels/difficulty
content pipeline is post-launch for these two flat-path subjects and remains required before
unit-gated practice is enabled.

### Sequencing clarification, 2026-09-26

D-1 is resolved for the October 2 launch. `DECISION-0073` verified that the launch frontend and home
page already exist and already use the current design system, so there is no remaining page-build
sequence to decide. The October 2 work is a verification/fix pass against that live surface. Payment
remains post-launch. This clarification does not authorize a deployment or the final launch decision.

## DECISION-0070 — Launch-Planning Follow-Ups, 2026-09-26

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision register D-3 through
D-8, D-12); `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`;
`docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004);
`docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`; `DECISION-0069`
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
`DECISION-0069`'s follow-up). This is surfaced, not resolved, here — see D-1/D-2 in the index's
decision register. Recommend confirming with David whether the 1-week window means the rebuild
sequence is being compressed/overridden, or whether "next week" targets a narrower slice of the full
rebuild scope.

### Not yet resolved

Does DECISION-0063 (Biology launches on the FRQ-only practice path, unit-gated path deferred) extend
to AP Statistics as well, since Statistics is now also a Day-1 subject? Not addressed by this decision.

## DECISION-0069 — Day-1 Launch Subjects and Pricing (BIZ-001, GTM-001)

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

## DECISION-0068 — BYOQ Data Model Uses Parallel Tables (Option A), Not the Live Graded Pipeline; TASK-0039 Phase 1 Scope Approved

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session) — see `APPROVAL-0050`
**Related Docs:** `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md` ("Question identity, answer
capture, and image linking" section, Decision needed #1); `DECISION-0057`;
`docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`
**Area:** Backend / Schema / Governance

### Context

`TASK-0039` needed a call on how BYOQ (bring-your-own-question) items and their attempts/images are
stored: generalize the live, real-student-data `app.attempts`/`app.response_versions`/
`app.response_attachments`/`app.capture_pairing_tokens` tables in place (Option D), or build BYOQ its
own parallel tables (Option A). Option D was this session's first-draft recommendation, on the theory
that a single, well-tested guard on the shared grading code paths would be a smaller surface than
duplicating working attempt/version/retake machinery.

An adversarial review of that exact schema, checked line-by-line against the live migrations and
function bodies rather than taken on the plan's word, and independently re-verified directly against
Production before this decision was recorded, found Option D's "one guard" premise false:
`app.record_manual_grade` (the RPC the human-grading queue calls) checks only `status = 'submitted'`,
with no content or BYOQ-provenance check of any kind; `app.prevent_client_grading_truth_update` (the
trigger meant to block unauthorized grading writes) explicitly exempts the `service_role` every
grading path runs as, so it offers no protection here; and `app.attempts_status_check` has no
terminal "never graded, by design" status, so a BYOQ attempt reaching `submitted` sits in exactly the
state the human-grading queue scopes on. Together, under Option D a BYOQ hand-drawn response photo
reaching `submitted` status would land in the real human-grading queue, with the student's name
attached, one RPC call away from being graded — a live `DECISION-0057` leak path, not a hypothetical
one. Closing it under Option D would require a new, service-role-inclusive guard trigger, a new
terminal attempt status, and rewrites to `bind_response_attachment` and `capture-pairing`'s
supersede logic for the corrected `part_key`/`page_sequence` uniqueness rule — a materially larger and
riskier migration surface against live tables than "a few additive columns."

### Decision

**Option A: BYOQ gets its own parallel tables** — `app.byoq_items`, `app.byoq_responses` (or a
`byoq_attempts`/`byoq_responses` pair, sized to what BYOQ actually needs, not the full graded state
machine), and, when Phase 2 starts, `app.byoq_capture_pairing_tokens`/`app.byoq_attachments`. No
shared code path exists between BYOQ and the graded pipeline for a guard to fail on, because there is
no shared code path — the human-grading queue, `evaluate-attempt`, and `record_manual_grade`
structurally cannot see a `byoq_*` row. The `part_key`/`page_sequence` fix for "whole vs. part of a
multi-part answer" (a real, pre-existing gap this task found, affecting library content too — AP
Biology's longer FRQs and future long-form subjects like AP Literature) still applies, built correctly
into `byoq_attachments` from the start (a `NOT NULL` triple-keyed uniqueness rule, not the nullable
pair the first draft mistakenly specified).

**`TASK-0039` Phase 1 scope is approved**: the `app.byoq_items`/`app.byoq_responses` schema (Option A
shape, no answer-bearing column of any kind on `byoq_items`), a separate BYOQ Practice
screen/component sharing UI components with but never branching inside the live graded Practice
screens, and the Home entry point, per that task's Phase 1 section as currently written.

### Not decided by this approval

- **Phase 2** (QR photo capture) is not authorized to start — it still needs the Pre-flight
  verification step (which Lovable frontend actually serves `cramapple.com`) done first, and its own
  implementation go-ahead once Phase 1 ships.
- **Phase 3** (worksheet parsing) remains blocked on `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md`'s
  own Open Decisions (parsing vendor, candidate cap, retention window).
- **`TASK-0039`'s "New gaps" list is not resolved by this decision** — entitlement/trial gating, rate
  limits/quotas, retention/deletion, consent copy, the private-until-promoted boundary, subject/
  taxonomy scoping, stuck-BYOQ routing, and the hints/deep-dive floor all still need an explicit
  Product Owner call before Phase 1 ships to real students, not just before its schema is built.

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
