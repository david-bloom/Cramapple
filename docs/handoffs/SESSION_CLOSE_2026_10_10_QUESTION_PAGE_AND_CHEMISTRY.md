# Session close — question page rebuild, Chemistry reference content, Lovable guardrails (2026-10-10)

**Owner:** David Bloom (Product Owner). **Agent:** Claude Code.
**Repos:** `david-bloom/Cramapple` (backend, content, records) and `david-bloom/ap-prep-blueprint` (the Lovable app, project `56cae479`).

The new `/question` page now matches the approved design and has passed two independent QA sweeps (Codex, then Lovable). It is merged to the app's `main`. It is **not yet published**: publishing waits on David's signed-in checks. AP Chemistry reference content is live in Production for all nine units.

## What shipped

| Area | Outcome | Where |
|---|---|---|
| AP Chemistry reference content | All 9 units in Production: 26/21/32/22/29/20/21/32/24 entries. Formula entries define their symbols, except Coulomb's law and the Ka·Kb pair | Cramapple PR #402 (merged); APPROVAL-0147–0151, DECISION-0112/0113 |
| Question-experience backend | `get_question_experience` read model, served-item recording, `get_practice_topic_availability` (nearest topic with questions), worked-example figure via `student-session-items` | Migrations `20261010040000`, `…120000`, `…160000`; Prod `student-session-items` v40, `byoq` v15; APPROVAL-0145 and amendments |
| Loading spinner | Named second exception to zero-motion | DECISION-0114 |
| `/question` page | Rebuilt to the Core Product canvas plus David's amendments; one shared top bar on `/question` and every BYOQ screen; hand-drawn (photo) responses wired in | app PR #1 (merged, `1715994`) |
| Guardrails | CI on every push to main and every PR; design-rule tests; Lovable project knowledge set | app PR #1; Lovable project `56cae479` knowledge |
| Repo cleanup | ~100 unreachable files removed (`2b8d053`), plus stale `supabase/` and `remotion/` (`4834b1b`); the `/cramapple` mock and pre-rewrite question screens retired | app `main`; app PR #3 (**open — merge it**) |
| Design templates | Canvas boards Rev-1/2/3 updated to every amendment (version 17); build handoff doc marked partly superseded; static copies in the app repo | "CramApple — Core Product" canvas; app `docs/design-reference/` |
| Blocked PRs | #398, #400, #403, #404 brought up to date with `main` (no conflicts, no duplicate record IDs) and merged by David | Cramapple |

## The `/question` rules (Product Owner, 2026-10-10)

These are the build reference. They live in the canvas note, in app `AGENTS.md`, in Lovable project knowledge, in `docs/QUESTION_PAGE_QA_SWEEP.md`, and in `src/lib/__tests__/question-design-rules.test.ts`.

**Panes and top bar**
- Left pane holds grade and score elements only. Right pane holds information only. The centre is the task.
- One top bar, `StudyNav` brand, shared with BYOQ. It has exactly three controls: Return to student hub | Change topic | Subject. The subject picker always shows the current subject.

**Topic bar**
- Unit › Topic breadcrumb, without the subject.
- The title, with the topic description under it.
- Progress bars with N/M beside them on top, the mode chip below.
- No mastery line, no exam countdown, no "Save and stop".

**Hints**
- Independent practice, before submission: the left pane, the right pane and the Deep Dive Notes link each sit behind their own **Hint** button. Opening one is recorded on the attempt (`assisted` plus an assistance event).
- Submitting reveals everything. Worked and learn states show everything.

**Reference pane**
- Sections: Skills, Vocabulary, Equations, Graphs, Memory hook. All open by default, each toggling on its own.
- Equations, Graphs and Memory hook render only when they have content.
- The footer link is **"Deep Dive Notes"**, with no reading time and no export links.

**Rubric, actions and type**
- Each FRQ criterion shows its points. A lost point is ↻, never ✕.
- Learning states end with "Show another" and "Try myself".
- Reading text is never below 16px. Secondary text uses `--ink-500` or darker. Touch targets are at least 44px. Panes carry blue, orange and green caps.

## How we got here: lessons that are now process

1. **Root cause of four failed Lovable rounds.** Lovable built a second, standalone `/question` page instead of changing the approved one. It also edited mock files the live page never loads. Reviews were diff-only, with no rendered check.
2. **The canvas is the design source.** I first rebuilt to the wrong reference (yesterday's components). The source is the Core Product canvas (Rev-1/2/3) plus the build handoff doc. Read them before any `/question` design work.
3. **Verification loop that worked.**
   - A local clone with a development-only harness (`/dev-qx-harness`: practice, review, worked, frq-practice and frq-review states, plus a preview subject picker).
   - Screenshots and measurements at 375, 1024 and 1440.
   - A written QA brief.
   - Independent Codex and Lovable sweeps.
4. **Guardrails against drift.**
   - CI runs tsc, the tests and the build on every push to main.
   - Design-rule tests are verified to fail on deliberate violations.
   - Dead look-alike files are removed.
   - Lovable project knowledge points every session at `AGENTS.md` and the boards.
   - "Done" is never accepted from a Lovable report without checking the real commit.

## Open items

- **Merge app PR #3.** PR #2 merged into PR #1's old branch, not `main`, so the cleanup plus an `h1` fallback still needs to land. Then delete `claude/question-page-qa-sweep`. Optionally turn on "automatically delete head branches".
- **Signed-in checks in the Lovable preview, then publish:**
  - the subject picker on `/question` and `/byoq`;
  - grading with and without a hint opened;
  - a photo answer on a photo-enabled subject;
  - switching subjects.
- **Send Lovable the stand-down prompt** after PR #3 merges. It tells Lovable to take no action on earlier chat work and use the template; the prompt is in this session's chat.
- **Minor follow-up (spawned as a task):** the active-subject published-packs query has no `queryFn`. It logs a console error in the harness; pre-existing.
- **Not built:**
  - canvas Rev-4, the session endpoint and return screen;
  - full student-answer text in FRQ review (the RPC returns highlights only);
  - raw LaTeX formula rendering.
- **Content:** the pilot question's rubric scores a point the question doesn't ask for (canvas note r2).
