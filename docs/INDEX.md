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
| Launch execution (Oct 2) | `product/LAUNCH_RUNBOOK_2026_10_02.md`, `product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` | Runbook = short surface; index = full reasoning. |
| Numbered decisions / approvals / activity | `activity_log/DECISIONS_LOG.md`, `APPROVALS_LOG.md`, `ACTIVITY_LOG.md` | Highest decision as of 2026-09-27: `DECISION-0074`. |
| Governance / roles / workflow | `team_charter/` (`AI_COLLABORATION_RULES.md`, `TASK_WORKFLOW.md`, `AGENT_OPERATING_MODEL.md`, `DEFINITION_OF_DONE.md`) | — |
| Session bootstrap | `team_charter/CRAMAPPLE_SESSION_START.md` | Device-neutral entry point (governed: APPROVAL-0047 / DECISION-0054). |
| Content taxonomy / labeling | `product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md`, `architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` | Rationalization shipped 2026-09-27 (PR #208). |
| Content authoring & QA (from scratch) | `research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` | v0.5 adopted; §2.1 pre-run prompts (pick two checkers, variants?), §3.2 model menu, Phase 5b variants. |
| **Seeded item generation (existing questions as seeds)** | `research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` | Draft v0.1, `DECISION-0093`. Seed classes A-D, clean-room rule for third-party seeds, S0a seed audit, two-checker policy. Rights boundary stays in `research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`. |
| Reviewer / admin portal | `product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`, `exam-buddy-wireframe` reviewer routes | **Still live — NOT legacy** (rebuild §10). |
| **Open Hand (face-up answer key) + scoring exclusion** | `product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`, `tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md` (backend), `tasks/TASK-0052-OPEN-HAND-FRONTEND-WIRING.md` (Lovable) | Built twice independently; resolved to one gated path by `DECISION-0086`. The RPC — not the edge function — is the security boundary. No student-facing exposure until TASK-0052 ships. |
| Skill dimension (topic × skill grid, all 10 subjects) | `product/SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md`, `product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md`, `tasks/TASK-0050-SKILL-DIMENSION-ROLLOUT.md` | `DECISION-0085`. Mastery ceiling is `floor(published_MCQ / 2)` and grid-independent — schema parity, not a mastery unlock. |
| **MCQ feedback (distractor-specific)** | `tasks/TASK-0053-DISTRACTOR-SPECIFIC-MCQ-FEEDBACK.md` | **Launch gating.** Replaces the one fixed placeholder string shown for every wrong MCQ. All 2,349 published distractors already carry authored rationales, so coverage is 100% at deploy — **not** blocked on TASK-0050; the orienting cue degrades independently (topic on 406 of 783 items, **skill on 304 — Statistics only**; `skill_code` is intentionally nullable — topic-only tagging, migration `20260927004500`). |
| Reference content model (explainers / point briefs) | `tasks/TASK-0054-REFERENCE-CONTENT-MODEL.md` | Both tables key the taxonomy as **plain text** with no FK and **no skill reference**; authored as markdown, not from a structured table. Zero orphans today, so the FK is safe to add; one content gap (Physics C: E&M, 17 of 31 topics). Not launch gating. |
| **START HERE if picking up open work** | `handoffs/RESOLUTION_RUNBOOK_2026_09_29.md` | Ordered, executable plan for everything open as of 2026-09-29: exact commands, preconditions, verification, rollback, seven traps that have already cost time, and eight decisions waiting on the Product Owner. Merge PR #272 first. |
| **Answer-key direct-read exposure (launch gating)** | `tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md` | `DECISION-0089`. Signed-in users can read keys straight from `content_item_versions` and the public views, bypassing the Open Hand RPC. Blocks TASK-0051's Production gate. Found by `qa/TASK-0051_INDEPENDENT_QA_2026_09_29.md` F1. |
| Subject ↔ taxonomy key link (post-launch) | `tasks/TASK-0057-SUBJECT-TAXONOMY-KEY-LINK.md` | Subjects and taxonomy name subjects in two spellings with no link; the naive conversion silently drops Biology. Add a `subject_id` FK, move every join onto it, guard in CI. Supersedes closed PR #268. |
| Seeded question generation: session record + open items | `handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md` | `DECISION-0093`. Extensive record of the 2026-09-30 to 10-02 session: AP Biology pilot, CED scope work, the three Production repairs (`APPROVAL-0066/0067/0068`), mistakes, process notes, open items with owners, and the handoff packet. Variant-run status by subject is in protocol section 10. |
| Grading notes from the seeded-question session | `handoffs/GRADING_NOTES_FROM_SEEDED_QUESTION_SESSION_2026_10_01.md` | Kept separate from the generation record. Where the answer key lives, key and rationale results, label-freshness and serving, difficulty/attempt checks on the replaced seeds, and open grading items G1-G5. No grading code was changed. |
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
