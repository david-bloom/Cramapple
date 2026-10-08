# Open Hand + Practice QA — Execution Record

**Status:** Backend live in Development and Production; Lovable packages built in Preview, publication pending (David publishes)
**Date:** 2026-10-08 (America/New_York)
**Owner / Conductor:** Claude (Fable), session `https://claude.ai/code/session_015d4N8rrusbDxRNrUESSDvD`
**Branch / PR:** `claude/open-hand-templates-qa-ig7na7`, PR #380
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

Package 2 — attempt integrity (F7 resume-from-failed-stage, A6 inputs frozen while grading, F8 per-user storage keys, A4 partial FRQ submission and truthful missed-point copy): PENDING — see §5.

Package 3 — flow and comprehension (F3, F4, F5, F6 "Worked example" everywhere, A7, A8, A9, m1–m4): PENDING — see §5.

## 4. Not done, and why

- **F1(b)** topic resolution for FRQ packs and Calc AB Unit 1 MCQs is content-pipeline work (`content_item_topic_resolution` rows), not a template change. The fallback title now hides the symptom; the data gap remains.
- **§2b** (FRQ teaching pool so the Rev boards' learning state can be built as designed) is a content decision, not executed.
- No signed-in browser walkthrough was run from this sandbox. §6 of the QA report still needs eyes on a screen after David publishes.

## 5. Validation evidence and open items

Filled in as each package lands. See the PR #380 description for the running summary.
