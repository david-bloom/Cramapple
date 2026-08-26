# Course Mode Pilot QA Report — 2026-08-26 (interim: DB-side complete, browser half blocked)

STATUS: interim QA report | RUN BY: this session (David's instruction), per
`COURSE_MODE_PILOT_QA_PROMPT_FABLE.md` | TARGET: prod (`pcntajvbdfqhbeewmdry`,
cramapple.com).

**Execution constraint:** this session's environment network policy blocks
`cramapple.com`, `*.supabase.co`, and `lovable.app` from the container (proxy 403
CONNECT), so the **browser E2E half could not run here**. All DB/RPC-side checks ran
via the Supabase connector. Browser items below are marked BLOCKED and need either
David's hands or a network-open session. **Independence caveat:** this session also
commissioned tonight's frontend builds; the browser re-run should be a fresh context
(AGENT_OPERATING_MODEL QA rule).

## Headline

**Overall: NOT PASSED — the pilot behavior under test is currently unreachable on
prod.** Live testing (David, ~22:01 UTC) and root-cause analysis found the session
runner never serves the pilot MCQs (TASK-0033, fix in flight), and the bundle that was
live at test time still faked `content_key` (TASK-0032, fixed in the project, awaiting
republish) — so the confirm-transfer beat cannot trigger at all. No false-mastery
claim can occur in this state (nothing serves), but nothing under test runs either.
**Everything provable server-side PASSED.** Re-run scenarios A–D in a browser after
the TASK-0033 build + republish.

## Pass/fail table

| Item | Verdict | Evidence |
|---|---|---|
| Inv 1 — cursor/"Question k of N" pinned during transfer | CODE-VERIFIED · browser BLOCKED | Pure reducer + `progressLabel()` pinned index; vitest suite (Lovable sandbox green); SessionParamsBar bar reads the same pinned index (TASK-0030). |
| Inv 2 — advance exactly once after transfer | CODE-VERIFIED · browser BLOCKED | Same reducer/tests; double-advance workaround deleted in the confirm-transfer build. |
| Inv 3 — transfer miss → repair | CODE-VERIFIED · browser BLOCKED | `finishConfirmTransfer` miss path routes to repair (diff-verified). |
| Inv 4 — fail-closed no-match: honest close, no relabel | **server PASS** · client CODE-VERIFIED · browser BLOCKED | Selector returns nothing when no valid parallel exists; client `item:null` path closes honestly (code). |
| Inv 5 — help scoped to one item | CODE-VERIFIED · browser BLOCKED | Transfer item held separately from the queue item. |
| Inv 6 — confidence calibration-only | CODE-VERIFIED · browser BLOCKED | Confidence never enters grading calls. |
| Inv 7 — numeric-cell exclusion (1.7×3.B, 1.9×3.B) | **server PASS** | Selector matrix over ALL 11 pilot cells: numeric cells return **0 rows**; every other cell returns exactly **1 different, same-cell** item (topic-1.9's two cells correctly disambiguated). |
| Scenario A — correct transfer → independent | BLOCKED (env + TASK-0033) | Cannot serve pilot MCQs until fix + republish. |
| Scenario B — transfer miss → fragile | BLOCKED (env + TASK-0033) | Same. |
| Scenario C — fail-closed no-match | **server half PASS** | Numeric-cell selector calls return 0; client handling code-verified. |
| Scenario D — ordinary items advance normally | BLOCKED (env + TASK-0033) | Same. |
| Known issue: quick-start routes via `/session/setup` | **FIXED** | TASK-0029 build (`a6f0c6e`), in the republished bundle. |
| Known issue: `GET 400 /rest/v1/sessions?...goal...` | **CONFIRMED + ROOT-CAUSED** | `public.sessions` has NO `goal` column (columns verified); the client selects it → PostgREST 400. Frontend-side fix: drop `goal` from that select (or add the column). Not blocking. |

## New findings from this QA run (beyond the prompt's list)

1. **CRITICAL — TASK-0033, serving path:** quick-start/learn-first sessions call
   `student-session-items` without `mode:"unit_gated"` → v17 serves **FRQ-only**;
   and unit-gated **cannot** serve the pilot anyway (its gate needs validated
   serving taxonomy labels; the 203 pilot MCQs have 0 — their designed path is the
   direct published-MCQ read, PILOT_PLAN §6). David's 22:01 session got 8
   general-pack FRQs. `pilot_sessions_ever = 0` — no prod session has ever run on
   the pilot pack. Fix brief sent to Lovable; frontend-only.
2. **Profile pack reversion:** David's `profiles.active_exam_pack_version_id` had
   reverted to `548f06be` (general). **Restored to `7c5a2975`** during this run.
   Standing cause: the two published Statistics packs diverge (pilot-log
   next-step #3 — David's decision); a Home subject write can revert it again.
3. **TASK-0032 (found by Lovable, verified + fixed tonight):** the deployed bundle
   at test time faked `content_key` with the display title (kills skill rail +
   confirm-transfer) and format-MCQ practice ignored unit/topic. Fixed in the
   project; needs the next republish.
4. **Learn-first content availability:** Stats Unit 1 has **13 published
   `topic_explainers`** — the E3 opener has content once serving works. (The
   skill-grain orientations/worked examples remain DRAFT pending D8/SME — a
   content upgrade, not a blocker for the opener.)

## Prod state checks (all green)

- Pilot pack `7c5a2975`: 203 published items, all cell-tagged, 10 Unit-1 cells ×20
  (+3 legacy 5.3×3.B lsrl); `practice_format` NULL by design.
- Gates: `exam_pack_version_is_selectable` = true, `home_exam_pack_is_eligible` =
  true; manifest `allowed_unit_numbers = {1,5}`.
- Edge functions healthy: `student-session-items` v17 / `session-event` v36
  serving 200s from cramapple.com traffic.

## Throwaway QA student

**Not provisioned** — it exists to drive the browser flows, which cannot run from
this environment. Recommendation for the browser re-run: sign up a disposable
student through the app (real GoTrue path), then wire role/entitlement/
`active_exam_pack_version_id = 7c5a2975` by SQL (mirroring an existing student),
rather than SQL-inserting an auth user. Remove it after QA per the prompt.

## Next steps to a full PASS

1. TASK-0033 build lands (Lovable) → diff-verify → **republish** (David).
2. Browser re-run of scenarios A–D / invariants 1–6 on cramapple.com (fresh
   context or David), with screenshots + network capture per the prompt.
3. Cross-check cell-tier transitions (`student_cell_state`) after A/B.
4. David: decide the two-packs divergence (the standing cause of #2 above).
