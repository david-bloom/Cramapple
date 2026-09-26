# TASK-0047 — App Rebuild: Execute §7–§11 (Content Gaps, Functional Gaps, Open Decisions)

**Task ID:** TASK-0047
**Title:** Execute `APP_REBUILD_MIGRATION_PLAN.md` §7 (content production), §8 (remaining content gaps),
§9 (functional gaps — Phase 1), §10 (what is not migrating), and §11 (open decisions)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress
**Priority:** High — several items block Phase 1 of the app rebuild
**Created Date:** 2026-09-26
**Approved Date:** 2026-09-26 (David assigned this Task ID per this session's policy-decision pass)
**Branch:** Not yet created — assign per repo convention (`<agent>/task-0047-<slug>`) when an agent starts
a given workstream
**PR:** None yet

## Origin

Split out of `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "EXECUTED, 2026-09-26" section, where
David directed execution of `APP_REBUILD_MIGRATION_PLAN.md` §7–§11 and then answered the resulting policy
decisions in the same session (see that doc's "DECIDED, 2026-09-26" section for full context and
rationale on every decision below — this task record tracks execution, that doc is the decision log).

## Product Goal

Close the remaining content gaps and functional gaps the app rebuild plan identified, now that the
blocking policy decisions have David's answers. This is execution against already-made decisions, not
further audit or design work — see Out of Scope.

## Technical Scope

Primary source: `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §7–§11. Decision record:
`docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s "DECIDED, 2026-09-26" section — read it before
starting any workstream below; it has the exact wording of each decision and why.

### Workstream A — Responsive frame (Decision 1: go responsive)

The design system's fixed 1440×900, `overflow: hidden` plate frame (enforced by `npm run verify:panes`)
must become responsive with vertical scroll allowed, keeping a max content width for readability. This is
foundational — it unblocks hand-drawn capture's phone surface (§9.2), the 6 image-stimulus Biology FRQs
(§8.3), and multi-part FRQ layout (§8.4). Touches `Plate.jsx`/`PaneShell.jsx` and the CSS token/verification
script in the "New Cramapple App" Lovable project (`56cae479-f7c9-4988-b536-56538c38ee4e`).

### Workstream B — Multi-part FRQ prose parser (Decision 11: cheap stopgap, not full migration)

323 of 563 published FRQ carry parts as `(a)`/`(b)`/`(c)` prose inside the stem rather than structured
`prompt_json.parts`. Build a lightweight parser/heuristic to segment these at render time as a stopgap.
Do not migrate the underlying content — that's explicitly deferred ("we'll see what we need later").

### Workstream C — Redo FeedbackCard on the real default path (session-flow decision + FeedbackCard redo)

`SessionFrame.tsx` (mounted by bare `/session`, the real default path since `home-v2` defaults on) has its
own `ResultPanel`/`CriterionCard` graded-result rendering, separate from `GradeResultView.tsx` (which an
earlier session restyled with `FeedbackCard`/`Plate` — verified working, but on the legacy `?home=v1`
route only). Redo the same restyle against the actual `ResultPanel`/`CriterionCard` in `SessionFrame.tsx`,
preserving all existing behavior around it (Course Mode repair panel, confirm-transfer beat, uncertain/
review/failed states, recheck dialog, celebration/streak). Do not delete or touch
`/session/mcq`+`/session/frq`/`GradeResultView.tsx` yet — see Out of Scope.

### Workstream D — Course Mode component generalization (Decision 17)

- Generalize `ConfirmTransferBeat`'s trigger (`needsConfirmTransfer()` in `src/lib/course-mode/confirm-transfer.ts`)
  beyond the AP Statistics pilot's `courseModeCell` gate, so it can fire for any subject/flow, not just the
  Stats pilot's transfer machine.
- Fold `LessonOpener` into `WorkedExample` as the single teaching-step mechanism — `LessonOpener` today is
  hard-scoped to one subject/unit/topic (`src/lib/course-mode/lesson-openers.ts`) and should not be
  invested in further as a separate mechanism.
- `StreakBadge`: no change — already fully portable, keep as-is.

### Workstream E — Item-package dual-read adapter (Decision 23)

203 of 1,346 published items carry the newer item-package JSON shape (`content/item-packages/`); the rest
use the older per-row schema. Build a dual-read adapter in the serving path so both shapes are read
transparently — no mass migration, no forced format decision on new content.

## Out of Scope

- **Retiring `/session/mcq`+`/session/frq` and deleting `GradeResultView.tsx`.** The canonical-flow
  decision is made (bare `/session` wins), but actual route deletion is a follow-up cleanup step after
  Workstream C is verified working — don't remove the fallback while the redo is in flight.
- **Building the mastery-derivation rule** (Decision 20: "2 full-point answers, with hint; hints
  post-scoring never affect mastery"). This is genuinely foundational and unbuilt — needs its own scoping
  pass (starting with confirming `app.student_cell_state`'s actual current columns/semantics against this
  rule) before implementation, not squeezed into this task. Track as a distinct future task once scoped.
- **BYOQ implementation itself** (camera/phone capture only at launch, per Decision 18/19). That work
  belongs to Codex per earlier direction in `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` — this task only
  records the shape decision, it does not build BYOQ.
- Redesigning any already-decided section of the interaction design spec.

## Routes / Components / Systems Affected

Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e` ("New Cramapple App") — outside this repo's edit
surface, edited via Lovable's own agent/MCP tools. `Plate.jsx`, `PaneShell.jsx`, `SessionFrame.tsx`,
`GradeResultView.tsx` (read-only reference, not edited), `src/lib/course-mode/{confirm-transfer,
lesson-openers}.ts`, `WorkedExample.tsx`, FRQ-serving code (parser stopgap), and item-serving code
(dual-read adapter).

## Data / Security / Integration Impact

All work in this task targets the live Production app (`app.cramapple.com`) directly — this project's
`.env` points at Production, not a separate Dev frontend. Verify via typecheck + full test suite +
`get_diff` against the resulting commit before deploying, per this session's established pattern. Any
workstream touching real grading/session logic (C, D) should not be deployed without a final review pass,
given how central `SessionFrame.tsx` is to the live grading path.

## Acceptance Criteria

- [ ] Workstream A: frame is responsive with vertical scroll; `verify:panes`-equivalent check updated or
      retired to match; existing screens re-verified not to break at the new behavior.
- [ ] Workstream B: prose-embedded FRQ parts render correctly for a sample of the 323 affected items;
      existing structured-`prompt_json.parts` items unaffected.
- [ ] Workstream C: `SessionFrame.tsx`'s `ResultPanel`/`CriterionCard` restyled to `FeedbackCard`/`Plate`;
      all existing behavior (repair panel, confirm-transfer, uncertain/review/failed states, recheck
      dialog, celebration/streak) preserved; typecheck + full test suite pass; diff verified.
- [ ] Workstream D: `ConfirmTransferBeat` fires outside the Stats pilot; `LessonOpener` folded into
      `WorkedExample`; no regression to the Stats pilot's existing behavior.
- [ ] Workstream E: dual-read adapter serves both item-package and legacy-schema items correctly; no
      existing content path broken.

## QA Plan

- Manual QA: verify each workstream live where possible; Workstream C especially needs a real
  authenticated session check once test credentials are available (still blocked per
  `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`).
- Automated tests: full existing test suite (413 tests as of this session) must stay green; add
  workstream-specific tests where the existing suite doesn't cover the new logic (especially B and E).
- Regression areas: the Stats pilot's Course Mode flow (Workstream D touches its trigger logic directly),
  and every existing screen using `Plate`/`PaneShell` (Workstream A changes shared layout primitives).
- **QA independence:** QA on this task must run in a fresh, independent context, separate from the
  implementer, per repo convention.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standard; Hard Gate for any workstream's Production deploy, given the live grading
surface involved (especially C and D).
**Decision:** Approved to proceed 2026-09-26 — all five workstreams' underlying policy decisions were
made by David in the same session that created this task record.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent per workstream.)_

**Test Results:** _(To be filled by the implementation agent.)_

**Risks / Issues:** _(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence.
