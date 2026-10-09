# Cramapple Docs — Canonical Source-of-Truth Index

STATUS: CURRENT
DATE: 2026-09-27
CANONICAL REPOSITORY: `david-bloom/Cramapple`

**Purpose.** One hop from "what's the current answer on X?" to the doc that actually holds it —
and away from superseded docs. This complements `docs/README.md` (authority order) and
`PROJECT_SETUP.md` / `docs/team_charter/CRAMAPPLE_SESSION_START.md` (session bootstrap). When docs
conflict, `docs/README.md`'s authority order governs; this index just routes you to the right one.

> **Read this first for architecture/design:**
> [`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`](product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md)
> — the decided-vs-open one-pager. If a design/architecture doc disagrees with it, the one-pager wins
> (it cites the record for every decision).

---

## The STATUS-header convention

Every design/architecture doc should carry a `STATUS:` line near the top, one of:

- `STATUS: CURRENT` — this is the live answer.
- `STATUS: SUPERSEDED by <doc> (<date>)` — replaced; kept for history. Say what supersedes it.
- `STATUS: HISTORICAL` — a dated record of past work (a pilot log, a rederivation record); never current by design.

Partial supersession is allowed: mark the doc `CURRENT except where a CORRECTION note applies` and
put a dated `> CORRECTION` / `> BANNER` block above the stale section (see
`docs/new_design/VISUAL_IDENTITY.md` for the pattern). **Annotate; do not silently rewrite** a
decision that was on record.

---

## Canonical source of truth, by topic

| Topic | Canonical doc | Notes |
| --- | --- | --- |
| **Current architecture & design (decided vs. open)** | `product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` | Start here. |
| App rebuild plan / gap analysis | `product/APP_REBUILD_MIGRATION_PLAN.md` | Authoritative architecture; §11 decision statuses annotated in place (mostly resolved 2026-09-26). |
| Decisions closed 2026-09-26 | `product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` ("DECIDED, 2026-09-26") | The decision log for the rebuild policy calls. |
| Execution of rebuild §7–§11 | `tasks/TASK-0047-APP-REBUILD-SECTIONS-7-11.md` | Frontend commits live in Lovable `56cae479`, not this repo. |
| **Design system (canonical)** | `new_design/` (`README.md`, `VISUAL_IDENTITY.md`, `TOKENS.md`) | Orange/light/Bungee, square, zero-motion. Fixed-plate rule SUPERSEDED (responsive). |
| Session modes / consolidation | `product/COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` | One mode "Learn." Course Mode is retired as a *mode*. |
| Mastery rule | `activity_log/DECISIONS_LOG.md` → `DECISION-0074` | 2 MCQ + 1 FRQ, no pre-submission hint; unbuilt. |
| Student interaction schema | `product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md` | Plan only; hard-gated on hint-use definition. |
| **BYOQ attachment extraction + confirmation (PROPOSED)** | `product/BYOQ_ATTACHMENT_EXTRACTION_AND_CONFIRMATION_PLAN_2026_10_08.md` | Review-first Hard-Gate plan: infer subject/unit/topic, question text/type and MCQ choices from photos or worksheets; student confirms before a BYOQ item is created. No implementation authorization. |
| Launch execution (Oct 2) | `product/LAUNCH_RUNBOOK_2026_10_02.md`, `product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` | Runbook = short surface; index = full reasoning. |
| Numbered decisions / approvals / activity | `activity_log/DECISIONS_LOG.md`, `APPROVALS_LOG.md`, `ACTIVITY_LOG.md` | Highest decision as of 2026-09-27: `DECISION-0074`. |
| Governance / roles / workflow | `team_charter/` (`AI_COLLABORATION_RULES.md`, `TASK_WORKFLOW.md`, `AGENT_OPERATING_MODEL.md`, `DEFINITION_OF_DONE.md`) | — |
| Session bootstrap | `team_charter/CRAMAPPLE_SESSION_START.md` | Device-neutral entry point (governed: APPROVAL-0047 / DECISION-0054). |
| Content taxonomy / labeling | `product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md`, `architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` | Rationalization shipped 2026-09-27 (PR #208). |
| Content authoring & QA (from scratch) | `research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` | **v0.6** (`DECISION-0099`): §0 generate-and-select is the default for new MCQs (required for Open Hand teaching items): no hand edits, four non-author checker families + reject-only veto, planted-defect controls, escalation triage against the CED PDF. §2.1 pre-run prompts, §3.2 model menu, Phase 5b variants still apply. |
| **Seeded item generation (existing questions as seeds)** | `research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` | Draft v0.1, `DECISION-0093`. Seed classes A-D, clean-room rule for third-party seeds, S0a seed audit, two-checker policy. Rights boundary stays in `research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`. |
| Reviewer / admin portal | `product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`, `exam-buddy-wireframe` reviewer routes | **Still live — NOT legacy** (rebuild §10). |
| **Open Hand (face-up answer key) + scoring exclusion** | `product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`, `tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md` (backend), `tasks/TASK-0052-OPEN-HAND-FRONTEND-WIRING.md` (Lovable) | Built twice independently; resolved to one gated path by `DECISION-0086`. The RPC — not the edge function — is the security boundary. No student-facing exposure until TASK-0052 ships. |
| **Stripe production cutover, payments & checkout** | `product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`, `tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`, `tasks/TASK-0058-POST-PILOT-CHECKOUT-AND-SIGN-IN.md` (after the pilot) | `DECISION-0094`: $1 pilot, then 50% off. Gate A–D evidence and the live secrets findings are in the checklist. Production approvals `APPROVAL-0069/0070/0071`. |
| **Checkout user testing (live)** | `tasks/TASK-0060-USER-TESTING-CHECKOUT.md`, `handoffs/SESSION_CLOSE_2026_10_04_CHECKOUT_USER_TESTING.md` | Evidence log and Lovable fix prompts for wallets, return page and first sign-in after purchase (opened 2026-10-04). Related: `TASK-0058`. |
| **Checkout joint QA and morning action list (2026-10-06)** | `qa/CHECKOUT_FLOW_QA_2026_10_06.md`, `qa/CHECKOUT_IMPLEMENTATION_VERIFICATION_2026_10_06.md`, `handoffs/MORNING_CHECKOUT_AND_EMAIL_ACTIONS_2026_10_06.md` | Astra source review + Sol desktop/mobile browser QA; implementation checkpoints, bugs and shortest-flow friction, evidence boundaries, prioritized fixes and Loops/design checklist. Not full payment/inbox certification. |
| **Student Home and MCQ QA (2026-10-06)** | `qa/STUDENT_HOME_AND_MCQ_QA_2026_10_06.md` | Entitled subject switching, unit/topic position, Next Best Action priority, hints and MCQ feedback layout. Preview checkpoints and remaining verification/backend/content gaps; not production release approval. |
| **Transactional email consolidation (Loops)** | `product/LOOPS_TRANSACTIONAL_EMAIL_MIGRATION_2026_10_06.md`, `qa/LOOPS_DEVELOPMENT_ROLLOUT_2026_10_06.md` | Owner-authorized implementation; Development deployment and controlled delivery evidence. Auth activation, scheduling and Production checkout gates remain. |
| **Supplied transactional email designs and import readiness** | `email/transactional/README.md`, `email/transactional/manifest.json` | Ten preserved HTML designs and published Loops IDs, adapted HTML/MJML, required variables and backend gaps. No Production cutover; test inboxes remain private. |
| Skill dimension (topic × skill grid, all 10 subjects) | `product/SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md`, `product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md`, `tasks/TASK-0050-SKILL-DIMENSION-ROLLOUT.md` | `DECISION-0085`. Mastery ceiling is `floor(published_MCQ / 2)` and grid-independent — schema parity, not a mastery unlock. |
| **MCQ feedback (distractor-specific)** | `tasks/TASK-0053-DISTRACTOR-SPECIFIC-MCQ-FEEDBACK.md` | **Launch gating.** Replaces the one fixed placeholder string shown for every wrong MCQ. All 2,349 published distractors already carry authored rationales, so coverage is 100% at deploy — **not** blocked on TASK-0050; the orienting cue degrades independently (topic on 406 of 783 items, **skill on 304 — Statistics only**; `skill_code` is intentionally nullable — topic-only tagging, migration `20260927004500`). |
| **CED-vocabulary quality check, all subjects (parked)** | `tasks/TASK-0059-CED-VOCABULARY-QUALITY-CHECK-ALL-SUBJECTS.md` | `DECISION-0095` was applied to AP Biology only. This task scans the other subjects' published banks (including the Units 1-3 run) and retires confirmed breaks. **Not started; parked by the Product Owner 2026-10-03.** |
| Reference content model (explainers / point briefs) | `tasks/TASK-0054-REFERENCE-CONTENT-MODEL.md` | Both tables key the taxonomy as **plain text** with no FK and **no skill reference**; authored as markdown, not from a structured table. Zero orphans today, so the FK is safe to add; one content gap (Physics C: E&M, 17 of 31 topics). Not launch gating. |
| Memory hooks (mnemonics / acronyms / phrases / diagram parts) | `product/MEMORY_HOOKS_PROPOSAL_2026_10_08.md`, `tasks/TASK-0066-MEMORY-HOOKS.md` | **APPROVED** 2026-10-08 (`DECISION-0104`, `APPROVAL-0136`), D1–D7 as recommended plus diagram parts. Topic-owned grain, CED point-bearing inclusion rule, Option B table, songs out of v1, pilot = Stats Unit 1 + Chem Unit 4 (≤ 8 hooks). Not started; not launch gating. |
| **START HERE if picking up open work** | `handoffs/RESOLUTION_RUNBOOK_2026_09_29.md` | Ordered, executable plan for everything open as of 2026-09-29: exact commands, preconditions, verification, rollback, seven traps that have already cost time, and eight decisions waiting on the Product Owner. Merge PR #272 first. |
| **Answer-key direct-read exposure (launch gating)** | `tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` | `DECISION-0089`. Signed-in users can read keys straight from `content_item_versions` and the public views, bypassing the Open Hand RPC. Blocks TASK-0051's Production gate. Found by `qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md` F1. |
| Subject ↔ taxonomy key link (post-launch) | `tasks/TASK-0057-SUBJECT-TAXONOMY-KEY-LINK.md` | Subjects and taxonomy name subjects in two spellings with no link; the naive conversion silently drops Biology. Add a `subject_id` FK, move every join onto it, guard in CI. Supersedes closed PR #268. |
| Seeded question generation: session record + open items | `handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` | `DECISION-0093`. Extensive record of the 2026-09-30 to 10-02 session: AP Biology pilot, CED scope work, the three Production repairs (`APPROVAL-0066/0067/0068`), mistakes, process notes, open items with owners, and the handoff packet. Variant-run status by subject is in protocol section 10. |
| **Units 1-3 content pipeline: runbook, lessons, state of every subject (START HERE for content work)** | `handoffs/UNITS_1_3_PIPELINE_RUNBOOK_AND_SESSION_CLOSE_2026_10_04.md` | Close of the 2026-10-03/04 run (`APPROVAL-0072` to `0115`, `0118`). Every AP subject has been through seed audit, repairs, variants, publish, topic and skill cells for its first three units (Physics 2 = registry units 9-11, Physics C E&M = 8-10). Step-by-step recipe, voting rules, database traps (publish path, stale-label trigger, rehearsal pattern), mistakes made, decisions taken, and the open list (held items, Units 4+, FRQs, `TASK-0059`). |
| **Orly pooled practice sets → clean-room MCQs (2026-10-06)** | `handoffs/SESSION_CLOSE_2026_10_06_ORLY_POOLED_CLEANROOM.md` | `DECISION-0098` (class-D student-pooled sets seed only through the clean-room path) and `APPROVAL-0126` (27 items published: 21 AP Chemistry Units 1/3, 6 AP Calc AB 2.1; 3 density items held). Where every artifact lives, the open items (Chemistry Units 4/9 and Calc 5.1 gaps), and traps hit. |
| Grading notes from the seeded-question session | `handoffs/GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md` | Kept separate from the generation record. Where the answer key lives, key and rationale results, label-freshness and serving, difficulty/attempt checks on the replaced seeds, and open grading items G1-G5. No grading code was changed. |
| **Minimal student session clarity — approved execution slice** | `product/STUDENT_SESSION_CLARITY_MINIMAL_PLAN_2026_10_07.md` | Finalized after Fable review and owner-authorized execution; existing content/layout retained. Preview implementation and verification are in the execution record below; broader rebuild deferred. |
| **Student session clarity — implementation / verification** | `handoffs/STUDENT_SESSION_CLARITY_EXECUTION_2026_10_07.md` | Lovable `d5adcbc6`: compact entry routes, set progress, unit example counts, visit-first aids and truthful stopping. Tests/typecheck/build and independent source checks recorded; signed-in delivery and publication pending. |
| **Open Hand + Practice templates QA and independent challenge (2026-10-08)** | `qa/QA_OPEN_HAND_PRACTICE_TEMPLATES_2026_10_08.md`, `qa/QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md` | Fable review of Rev 1–4 against Lovable `d5adcbc6`, plus Codex independent source/deployed-contract review. Challenge adds omitted MCQ stimulus, FRQ adapter/readiness rejection, ungated FRQ units, partial-answer and assistance/attempt issues; qualifies raw-selector counts and recommends a different repair order. §7 of the Fable report reconciles the two and adds **F10 (blocker): migration `20260930190000` was never applied to Production, so a signed-in student can read `prompt_json` answer keys through `select_unit_gated_practice_items`.** Signed-in desktop/mobile certification remains pending. **Executed 2026-10-08:** see `handoffs/OPEN_HAND_PRACTICE_QA_EXECUTION_2026_10_08.md` (`APPROVAL-0135`; backend live in both environments, Lovable packages in Preview awaiting publish). |
| **Student hub slice 1 — execution record (2026-10-08)** | `handoffs/STUDENT_HUB_SLICE1_EXECUTION_2026_10_08.md` | Lovable `a509b7d7` (Preview only): evidence scoped to the active subject, unit-only saves clear the topic, save on change with a latest-wins gate in both stages, four-state Learn door that honours the resolver, one unit-only rule across the doors (DECISION-0103). 755 tests, typecheck and build pass; published to production 2026-10-08 on the owner's instruction; signed-in QA pending (slice 2). |
| **Student hub QA: consolidated plan (2026-10-08) — START HERE for hub work** | `qa/QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md` | One plan from Sol's challenge QA (`qa/QA_STUDENT_HUB_CHALLENGE_2026_10_08.md`, H1–H15, Lovable `d5adcbc6`) and Fable's independent assessment (`qa/QA_STUDENT_HUB_FABLE_REVISED_PROPOSAL_2026_10_08.md`, N1–N8 with Production counts, Lovable `8a97bdca`), re-checked at `926ac3fb`. Five P1s (cross-subject evidence, stale-topic save and draft/saved split, recommended door opening "coming soon", unit-only positions, purpose buried under the form), four slices in Sol's order (reliability → signed-in visual QA → first-use copy/layout → shelves), five Product Owner decisions, merged acceptance rows. Proposals only; no app change. |
| **Student hub first-use: second pass after October 7 fixes** | `qa/NEW_USER_FIRST_SEVEN_MINUTES_SECOND_PASS_2026_10_07.md` | Independent source checkpoint at Lovable `04e35dbc`: fixes vs remaining unified UX work, four-question verdict, targeting and notes-access risks. Timed fresh-student/mobile/return validation remains pending. The unified recommendation still governs. |
| **Student hub + first session: UNIFIED recommendation (new student primary, returning secondary)** | `product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md` | Reconciles the Claude assessment and Sol's parallel assessment (PR #365) under `DECISION-0100`: four doors (learn from a question · practice · notes · bring a question), lesson question before position form, a finish for every route, continue-primary rule for returners, merged behavior requirements B1–B9, Sol's student validation protocol, five open PO decisions. **Start here for hub/first-session work.** |
| **New-student first-session UX assessment (hub → worked example → practice → return)** | `product/NEW_STUDENT_FIRST_SESSION_UX_ASSESSMENT_2026_10_07.md` | Read-only assessment, 2026-10-07: four-question verdict, real pilot-account behaviour from Production, P0/P1 recommendations (R1–R15), §8 board-by-board changes to the Student Hub design canvas (K1–K24), open Product Owner questions; §0b records `DECISION-0100` (worked example recommended, never required; four equal entry points). Companion to `TASK-0048`; overlaps open PR #365. |
| Migration ledger vs Production | `tasks/TASK-0055-MIGRATION-LEDGER-RECONCILIATION.md` | **At least 72 migrations since 2026-09-01 exist only in Production** (185 applied vs 113 files). The schema cannot be rebuilt from source, and `db push` is unsafe to run casually. `apply_migration` writes no local file — commit one under the *recorded* version every time. |

---

## Superseded / historical — do NOT treat as current

These are retained for history. They carry banners pointing here or to the one-pager. Do not quote
them as the current answer.

| Doc(s) | Superseded on | By |
| --- | --- | --- |
| `product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` (v1), `..._BRIEF_v2.md` (v2) | 2026-09-22 | `new_design/` |
| `product/DESIGN_SYSTEM_CUTOVER_PLAN.md` (palette/"Project-Crux" red, fixed frame) | 2026-09-27 | `new_design/` + one-pager (D3/D4/D5) |
| The fixed 1440×900 no-scroll plate rule (in `new_design/VISUAL_IDENTITY.md` / `README.md`) | 2026-09-26 | Responsive decision (one-pager D3) — banners applied in place |
| `product/USE_MODES_STRATEGIC_RECONCILIATION.md` | 2026-09-27 | `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` + single-mode decision |
| `teaching/COURSE_MODE_*` tree (~55 pilot specs, rederivation records, work orders, pilot logs) | 2026-09-27 | **HISTORICAL pilot record.** Course Mode is retired as a *mode*; its mechanics survive only as components (one-pager D1/D11). The three active specs carry vocabulary banners; the dated rederivation/work-order/log files are historical by their nature — treat the whole tree as pilot history, not current design. |

**Legacy-doc handling (DECISION-0075, 2026-09-27): annotate-in-place, no move (Option A).** Superseded
docs stay where they are, carry supersession banners, and are listed above. No `docs/legacy/` tree is
created — the banners + this index route agents past legacy in one hop. See
`docs/proposals/LEGACY_DOCS_ARCHIVE_PROPOSAL_2026_09_27.md` for the Options B/C if this is ever revisited.
