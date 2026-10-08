# Open Hand + Practice QA — Execution Record

**Status:** Backend live in Development and Production; all three Lovable packages built and reviewed in Preview; publication is David's (not yet published at the time of writing)
**Date:** 2026-10-08 (America/New_York)
**Owner / Conductor:** Claude (Fable), session `https://claude.ai/code/session_015d4N8rrusbDxRNrUESSDvD`
**Branch / PR:** `claude/open-hand-templates-qa-ig7na7`, PR #380
**Approval:** `APPROVAL-0135` (Production database and edge-function changes)
**Governing findings:** `docs/qa/QA_OPEN_HAND_PRACTICE_TEMPLATES_2026_10_08.md` (F1–F10, minors m1–m4, §7 reconciliation) and `docs/qa/QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md` (A1–A9)
**Instruction:** David, 2026-10-08: "Execute the findings to make the user experience as easy and helpful as possible." Decisions taken in the same session: database changes go to Development **and** Production with no further check-in; Lovable work is built in Preview and David publishes; the student-facing name is "Worked example" everywhere (Open Hand stays an internal/route name); the practice selector is fixed server-side (F2).

## 1. What changed in the database (both environments)

Applied through the Supabase MCP (`execute_sql`) to Development `wmgjsdkphcyhngaffbqf` and Production `pcntajvbdfqhbeewmdry`, with ledger rows inserted into `supabase_migrations.schema_migrations` so `supabase db push` will not re-run them.

| Migration file | What it does | Findings |
| --- | --- | --- |
| `supabase/migrations/20260930190000_task0056b_revoke_prompt_json.sql` (existing, never applied) | Revokes `prompt_json` column reads on `app.content_item_versions` from `authenticated`/`anon`; revokes execute on `select_practice_frqs`, `select_unit_gated_practice_items`, `select_hand_drawn_pilot_items` from `authenticated`. **Deviation recorded in the ledger note:** the public view `content_item_versions` was recreated with `NULL::jsonb AS prompt_json` instead of dropping the column, so existing readers keep working and the security-invoker view no longer needs a privilege the role lost. | F10 (answer-key exposure), A2 |
| `supabase/migrations/20261008113000_student_practice_queue_selector.sql` (new) | `public.select_student_practice_items(...)`: service-role-only selector that keeps the unit gate, excludes items the student already submitted (any version) and items revealed in Open Hand, puts the requested topic first, and pages by offset. `public.count_practice_frqs_available(_exam_pack_version_id)`: authenticated count of FRQs that will actually render in Practice (replaces the browser's read of FRQ rows). `get_open_hand_item` revoked from `authenticated` (the burn RPC behind the unlinked `/open-hand-frq`). | F2, F9, A2, A3 |

Verified after apply, as the `authenticated` role: `prompt_json` reads back as null through the view, the revoked RPCs raise permission errors, and page 2 of the new selector returns items in Production for the AP Statistics test student.

## 2. What changed in the edge functions

`supabase/functions/student-session-items/index.ts`, deployed to Development (v28, byte-verified) and Production (v34):
- `mode: "unit_gated"` now calls `select_student_practice_items` with the student's user id, optional `topic` and `offset`; page size 50; the response carries `has_more`, `offset` and `topic`.
- Authored FRQ part prompts are delivered for every subject (previously only Calc AB, Statistics and Biology), so `parts_source: "prompt"` is no longer a three-subject exception.

## 3. What changed in the student app (Lovable `56cae479…`, Preview only)

Package 1 — delivery and safety (connector commit `26673f376358389c90a5d2484d79fcf92e149454`, agent-reported `a86076a4`):
- Shared `QuestionBody` part renders stimulus text and images (alt + disclosure for the long description) above the stem on Open Hand MCQ, Practice MCQ and Practice FRQ (A1: 24 of the first 50 AP Statistics Unit 1 MCQs have a stimulus the build dropped).
- Mode-aware fallback title: a topic-less Practice item is "Practice question", never "Worked example" (F1a).
- Hub FRQ availability now comes from `count_practice_frqs_available`; the browser no longer calls any revoked selector or reads `prompt_json` (F10 follow-through, A2). `open-hand/client.ts` still contains the `get_open_hand_item` call but nothing reachable renders it; candidate for deletion.
- Practice FRQ fetches through `mode: "unit_gated"`, `item_type: "frq"` (A3). The 2026-09-24 zero-item workaround comment is gone.
- Paging: topic forwarded on every fetch; "Next set" at the end of the fetched queue loads the next page with `offset` = items shown but not submitted; an empty page shows "You've answered everything available for your unit right now." (F2).
- `/open-hand-frq` added to `RETIRED_STUDENT_PATHS`; the route no longer renders the live Open Hand FRQ screen (F9).
- Empty scoring aids render as a passive status line, never as a gate, so opening nothing cannot mark an attempt coached (A5).
- "No hints for this one. Answer on your own; every option is explained after you submit." replaces the dead-end hint line on topic-labelled items.
- Reported by the agent after the final edits: 78 test files / 718 passed / 0 failed; `npx tsgo --noEmit` exit 0 (separate TypeScript run); `npm run build` exit 0.

Package 2 — attempt integrity (connector commit `8a97bdca8638951af6bf14a335e4472f6979b086`, agent-reported `4de634db`):
- Resumable grading chain (`src/lib/grading-chain.ts`): a per-question record keyed by learning session + item keeps the attempt id, response version and last stage reached; "Try again" resumes at the stage that failed on the same attempt, a changed answer saves a new response version on that attempt, and a submitted answer is graded as submitted (the screen is told which answer was graded). No second `create_attempt` for the same item (F7).
- Frozen while grading: answer rows and FRQ fields are locked, every aid gate is inert and records nothing, Submit/Skip/Next are disabled and the button reads "Grading…" at a stable width (A6).
- Per-user browser storage (`src/lib/storage-user.ts`): plate and hint state, practice session id, runtime session id and parked sessions are stored as `<base>:<userId>`; signed-out writes nothing; another user's keys are dropped when a different student signs in; the old unscoped key is moved only if it names the signed-in student, otherwise deleted (one-time loss of local progress from before this change; server-side attempts unaffected) (F8).
- Partial FRQ submission: Submit works with at least one part filled; blank parts go as empty strings behind one inline "Part (b) is blank. Submit anyway?" line; after grading a blank part reads "Not attempted · 0 of N points" and a missed criterion "Missed · see what earns this point". No "next attempt" / "another attempt" copy remains in `src` (A4). Deviation: no per-part sample answer exists for Practice FRQs, so only the rubric is shown for a blank part.
- Reported after the final edits: 79 test files / 732 passed / 0 failed (one existing test timed out on the first full run, passed alone and on the rerun); `npx tsgo --noEmit` exit 0 after one type fix; `npm run build` exit 0.

Package 3 — flow and comprehension (connector commit `5fe0ced7d69cb74caf3531aaa419c6e077e2883e`, agent-reported `ed532130`):
- "Worked example" is the student-facing name everywhere (F6): header chip, plate caption, question-header mode, Answer Key eyebrow ("Face-up" gone), "Every point is shown.", "Nothing is scored in a worked example", route titles/descriptions for `/open-hand-mcq`, `/open-hand-frq` and `/cramapple`, the old `HomeScreen` copy and the worked-example kicker. "Open Hand" survives only in routes, file names, identifiers and one stylesheet comment.
- Hub door (F3): when the unit has no topic with a worked example the "Learn from a question" door stays visible but inert with "No worked example for Unit N yet. Start with Practice MCQs, or pick another unit." and a link to Practice; "Checking…" while loading. The door counts topics with an example from the existing per-topic list (no per-unit count exists server-side). A wrong subject key the new door read was caught by an existing test and fixed in code.
- Cross-unit strip (F4): a `role="status"` line above the question plate, "You've finished Unit N's examples. This one is from Unit M · title.", for that question only; the old sentence in the button row is gone.
- First-question disclosure (F5): "Open any of these freely on this question. Using one is recorded as guided help." shown only in the ungated first-question state.
- Continue advances in one tap (m1); phone pane order question → answer/hints → reference via CSS order (m2); "Selected" instead of "Your answer" in worked examples (m3); the Answer Key pane carries only the correct answer and its rationale, each distractor's explanation on its own option row, so no text appears twice (m4; this replaces the earlier "explanations once, in the left pane" rule).
- Visited set (A7): topics already shown this visit are skipped in the browser (the teaching RPC has no exclusion list); the pool ends with the existing end-of-pool notice. A follow-up message aligned the "Next example: …" label with the same pick so it never names a topic that is then skipped.
- Set-end tally (A8): "Answered N · Skipped M in this set".
- Accessibility (A9): Deep Dive overlay is a real dialog (role, aria-modal, labelled title, focus in/return, Escape); FRQ textareas have visible labels and points described; MCQ radiogroups have arrow-key navigation with roving tabindex. The leave guard stays the browser's native confirm, which already blocks and handles focus. Status strips render once per question; not checked with a screen reader.
- Reported after the final edits: 80 test files / 745 passed / 0 failed; `npx tsgo --noEmit` exit 0 after two test-file type fixes; `npm run build` exit 0. Tests exercise handlers directly (no simulated browser); phone order is asserted on the stylesheet rule.

## 4. Not done, and why

- **F1(b)** topic resolution for FRQ packs and Calc AB Unit 1 MCQs is content-pipeline work (`content_item_topic_resolution` rows), not a template change. The fallback title now hides the symptom; the data gap remains.
- **§2b** (FRQ teaching pool so the Rev boards' learning state can be built as designed) is a content decision, not executed.
- No signed-in browser walkthrough was run from this sandbox. §6 of the QA report still needs eyes on a screen after David publishes.

## 5. Validation evidence and what still needs eyes on a screen

| Evidence | Result / boundary |
| --- | --- |
| Backend, as `authenticated` in both environments | `prompt_json` null through the view; revoked RPCs raise permission errors; selector page 2 returns items (Production, AP Statistics test student). |
| `student-session-items` Development | v28, byte-identical to the committed source. Production v34 deployed from the same source. |
| Lovable package 1 | 78 files / 718 passed; tsgo 0; build 0 (agent report). |
| Lovable package 2 | 79 files / 732 passed; tsgo 0; build 0 (agent report). |
| Lovable package 3 | 80 files / 745 passed; tsgo 0; build 0 (agent report). |
| Independent diff review (this session) | Package 1 paging and `QuestionBody`; package 2 `grading-chain.ts` and `storage-user.ts`; package 3 Answer Key / option rows and `teaching.ts` read in full. No signed-in browser run from this sandbox. |

**On-screen QA after David publishes** (adds to §6 of the QA report):
- [ ] Sign in, answer two Practice MCQs, reload: progress and the set resume for the same student (per-user storage timing cannot be proven from the diff).
- [ ] Sign in as a second student on the same browser: no trace of the first student's session.
- [ ] AP Statistics Practice MCQ: a question with a stimulus shows the stimulus text and any image above the stem.
- [ ] Calc AB Practice FRQ: pane title never reads "Worked example"; FRQ door on the hub appears only when the count is positive.
- [ ] Answer every served question in a small pool (Physics 1 Unit 1): "Next set" loads a second page; the end state reads "You've answered everything available for your unit right now."
- [ ] Throttle the network, submit, watch the inputs lock and the button read "Grading…"; force a failure and confirm "Try again" does not create a second attempt (check `app.attempts` for the item).
- [ ] FRQ with one blank part: the inline "Submit anyway?" line, then "Not attempted · 0 of N points".
- [ ] Phone (390px): worked example and Practice show the question first; the cross-unit strip is visible above the plate.
- [ ] Keyboard only: arrow keys move through MCQ options; Deep Dive opens as a dialog and Escape closes it.
- [ ] No "Open Hand" or "Face-up" visible anywhere a student can reach.
