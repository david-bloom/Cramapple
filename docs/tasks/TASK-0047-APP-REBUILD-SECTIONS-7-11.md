# TASK-0047 — App Rebuild: Execute §7–§11 (Content Gaps, Functional Gaps, Open Decisions)

**Task ID:** TASK-0047
**Title:** Execute `APP_REBUILD_MIGRATION_PLAN.md` §7 (content production), §8 (remaining content gaps),
§9 (functional gaps — Phase 1), §10 (what is not migrating), and §11 (open decisions)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review (all 5 workstreams code-complete, none deployed)
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

- [x] Workstream A: frame is responsive with vertical scroll; confirmed no `verify:panes`-equivalent
      check exists in this project (flagged, not invented); existing screens re-verified via screenshots
      at desktop and phone widths — no horizontal overflow, no collisions.
- [x] Workstream B: prose-embedded FRQ parts render correctly (5 tests against real sampled stem text);
      existing structured-`prompt_json.parts` items unaffected (parser only runs when `parts.length === 0`).
- [x] Workstream C: `SessionFrame.tsx`'s `ResultPanel`/`CriterionCard` restyled to `FeedbackCard`/`Plate`;
      all existing behavior (repair panel, confirm-transfer, uncertain/review/failed states, recheck
      dialog, celebration/streak) preserved; typecheck + full test suite pass; diff verified.
- [x] Workstream D: `ConfirmTransferBeat`'s trigger generalized to a per-subject registry (shape-level —
      does not yet fire outside Statistics, since no other subject has a cell/skill map; flagged, not
      guessed at); `LessonOpener` folded into `WorkedExample` (content moved verbatim); no regression to
      the Stats pilot's existing behavior.
- [x] Workstream E: dual-read adapter built and tested; investigation found the underlying gap was
      dormant (100% of the 203 items already had complete legacy data) — adapter is forward insurance,
      not an active fix; no existing content path broken (391/391 edge-function tests pass).

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

**Implementation Summary:**

- **Workstream A (responsive plate frame) — done in the Lovable project, not deployed.** Commit
  `44a0f59e`, verified via `get_diff` myself. `Plate.jsx`: fixed `width/height` + `overflow:hidden`
  replaced with `width:100%; max-width:var(--plate-width); min-width:320px; min-height:100vh`.
  `spacing.css`: `--plate-height` removed; added `--plate-min-width` and an 899px breakpoint collapsing
  the pane grid to one column (the old grid's fixed 352px/324px side columns would otherwise break at
  phone widths). `app.css`: rewrote the `#root` comment (no longer claims the plate "never scrolls"),
  added the single-column breakpoint plus a 520px breakpoint. One unplanned but correct follow-on:
  `Breadcrumb.jsx` needed a fix too — the agent's own phone-width screenshot check found its content
  colliding at narrow widths, so it added wrap-friendly class hooks. Confirmed via diff: the three
  excluded files (`GradeResultView.tsx`, `SessionFrame.tsx`, `FeedbackCard.jsx`) were untouched.
  Typecheck clean, 413/413 tests pass. Screenshots confirmed clean layout at both 1536px and 375px
  widths, zero horizontal overflow, no element collision.
  **Note:** this project has no `verify:panes` script — that script only exists in a separate local
  `web/` reference implementation, out of scope for this Lovable-project change. Flagged, not touched.

- **Workstream C (redo FeedbackCard on the real default path) — done in the Lovable project, not
  deployed.** Commit `f2475531`, verified via `get_diff` myself. In `SessionFrame.tsx`: removed the
  standalone leading "Plain verdict" div; moved its exact three-way Correct/Partially correct/Incorrect
  computation into `ResultPanel`; `ResultPanel`'s header replaced with `FeedbackCard` (verdict, earned/
  total gated on the existing `showTotal` condition, `marks` = the unchanged `CriterionCard` mapping).
  `CriterionCard` itself, the "Recommended next step" repair panel, celebration/confetti, Course Mode
  repair/confirm-transfer branches, uncertain/review/failed panels, and `RecheckDialog` wiring are all
  confirmed untouched. Typecheck clean, 413/413 tests pass.
  **Process note:** this `send_message` call timed out on my end waiting for a response, but the
  underlying request had actually succeeded — confirmed by finding the completed response in the
  project's message history. Lesson: a Lovable MCP timeout doesn't necessarily mean the request failed;
  check `list_messages`/`get_diff` before resending into a shared project thread.

- **Workstream B (multi-part FRQ prose parser) — done in the Lovable project, not deployed.** Commit
  `c52c3fd6`, verified via `get_diff` myself. New `src/lib/frq-prose-parts.ts`: `parseProseParts()`
  sampled real Production stems first (not guessed) and handles two real shapes — blank-line-separated
  `(a)/(b)/(c)` blocks and `Part A:/Part B:` blocks — requiring sequential, contiguous, correctly-ordered
  labels or returning `null` untouched. Deliberately does NOT split parts run together inline in one
  paragraph (rarer, riskier to split correctly) — conservative default preserved, confirmed by a test
  case. `use-session.ts`'s `servedItemToQuestion()` only invokes it when `item.item_type !== "mcq" &&
  item.parts.length === 0` — real structured `prompt_json.parts` always wins and MCQ is never touched.
  Strips matched part text from the returned stem so it doesn't render twice. 5 new tests (real sampled
  stem text), 418/418 total pass, typecheck clean.

- **Workstream D (Course Mode component generalization) — done in the Lovable project, not deployed.**
  Two commits (`8337b270`, `6b696008`), both verified via `get_diff` myself.
  - *ConfirmTransferBeat trigger*: correctly scoped conservative — new `pilot-subjects.ts` registry
    (`subjectHasCourseModeCells()`) replaces the hardcoded `subjectKey === STATS_PILOT_SUBJECT_KEY` check
    in `session.index.tsx`, byte-for-byte equivalent today (only Statistics registered). This is a
    shape-level generalization, not a behavioral one — it does NOT make the beat fire for any other
    subject yet, since no other subject has an equivalent cell/skill map. Correctly flagged rather than
    invented: building that map is separate content/backend work, not attempted here, matching the task
    record's explicit instruction not to guess at new infrastructure.
  - *LessonOpener → WorkedExample fold*: `LessonOpener.tsx` deleted; its exact JSX moved verbatim into
    `WorkedExample.tsx` as a new `lesson`-prop branch (confirmed via diff: content is unchanged, just
    relocated). `SessionFrame.tsx`'s touch is confined to exactly the import line and one render-branch
    swap — confirmed zero overlap with Workstream C's already-landed `FeedbackCard`/`ResultPanel` changes
    in the same file, sent as a deliberately separate, narrowly-scoped message per the file-conflict
    instructions. 418/418 tests pass both times, typecheck clean.

- **Workstream E (item-package dual-read adapter) — done, committed (`1a6e8404`), not deployed.**
  Investigation found the "203 of 1,346" gap is dormant, not active: every one of those 203 items
  already has complete legacy relational data, and `student-session-items` never read
  `item_package_payload` before this change. Built the dual-read adapter as forward insurance anyway,
  per David's decision — additive-only (`applyItemPackageFallback` is a no-op for any row with real
  legacy data), whitelist-only choice extraction (`choice_key`/`choice_text` only; `is_correct`/
  `correct`/`rationale`/`misconception` never leave the function — verified directly in the diff, not
  just the agent's claim). FRQ-criteria fallback deliberately NOT implemented — neither package shape
  has an equivalent to `frq_criteria.learner_facing_text` (reviewer-authored, pre-filtered), and
  deciding what's safe to derive there is a content-safety call, not an engineering stopgap. Flagged as
  a real open question if an FRQ-only-package item is ever published, not resolved by assumption.

**Test Results:**

- Workstream E: `deno test --allow-env --allow-read --allow-net supabase/functions/` — 391/391 pass.
  `deno check` clean on both touched files. `git diff --stat` confirmed exactly 4 files touched, no
  migration, no deploy.

**Risks / Issues:**

- Workstream A: none identified beyond the flagged `verify:panes` scope note above.
- Workstream B: none identified. Inline-run-together part labels are intentionally left unparsed — a
  real, small residual gap (unknown count, not measured), not a bug.
- Workstream C: none identified. Not yet checked live in a browser against a real student session (same
  blocker as everything else in this doc — no test credentials available this session).
- Workstream D: `ConfirmTransferBeat` generalization is shape-only — it does not yet fire for any subject
  besides Statistics, since no other subject has an authored cell/skill map to gate on. Building that map
  is separate future work, correctly not attempted here.
- Workstream E: none identified. The one deliberately-deferred item (FRQ-criteria fallback) is flagged
  above, not a risk in the shipped code — no published item needs it today.
- **None of the 5 workstreams have been deployed to Production.** Everything above is committed in the
  Lovable project's own history (or, for E, this repo) but not published — deploy is explicitly David's
  call for each, not bundled into this pass.
- **Follow-on, same session: `ConfirmTransferBeat` generalized beyond shape-only, per David's explicit
  "let's build it" direction.** Backend (this repo, commit `9fc0f75b`): `student-session-items` now
  resolves a `RenderCell` for any served item — fine-grained via `content_item_cells` (Statistics,
  unchanged) or coarse via `content_taxonomy_labels` (topic-only, any subject) when no cell tag exists.
  **A Fable-authored rationalization plan** (`docs/product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md`)
  investigated this before it shipped and found a real governance conflict: the coarse fallback as first
  built had no status filter, which would have made 112 unvalidated AP Biology topic labels
  student-visible on deploy, contrary to `DECISION-0067`. Fixed before committing —
  `.eq("label_status", "validated")` added, yielding zero rows today (honest, not a bug), plus a
  regression test that inspects the actual query filter rather than trusting the test mock. 401/401 tests
  pass. Frontend (Lovable, commit `9be19bbc`, verified via `get_diff`): `subjectHasCourseModeCells` is now
  dual-mode (static `true` for Statistics, per-item for everyone else); `resolveSessionSkill` routes
  Statistics through its unchanged hand-authored map and everyone else through the server-resolved cell.
  Zero touches to Statistics' existing code path, zero overlap with Workstreams B/C. Not deployed on
  either side.
- **Cross-cutting process risk, confirmed this session:** Lovable serializes all work on one project
  through a single shared conversation thread. Running multiple agents against the same `project_id`
  concurrently causes messages to queue/timeout on the caller's side even though the underlying request
  still completes — don't assume a timeout means failure; check `list_messages`/`get_diff` first. Full
  file-level conflict avoidance (as attempted here) does NOT prevent this queuing.

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence.
