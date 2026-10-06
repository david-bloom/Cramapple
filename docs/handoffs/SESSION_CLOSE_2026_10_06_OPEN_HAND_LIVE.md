# Session Close — 2026-10-06 (Open Hand live: teaching pool, 91 teaching items, plate loop for all subjects)

**Session:** Claude Code (cloud), branch `claude/ux-evaluation-session-flp1xj`.
**Task records:** `TASK-0064` (teaching pool), `TASK-0065` (teaching item generation).
**Next owner:** David Bloom.
**Single best next action:** **publish the Lovable "plate loop for every subject / no diagnostic" build**
(edit `edt-660b7fa5`, commit `07e7051a`). Then sign in once: a Biology or Chemistry "Start" button should open
a worked example or Practice, and `/session/setup` should land on Home.

## 1. What was asked
David wanted Open Hand (worked example, then Practice) to be the student experience **today**, with no student
entering the diagnostic or session flow. Along the way:
- approve the attempt-response 409 change;
- run the outside checkers on the 91 Units 1–3 teaching questions;
- have Fable walk through the build;
- turn the database backstop back on.

## 2. What changed

| Area | Change | Record |
|---|---|---|
| `student-session-items` | Deployed by David via CLI with `dropTeachingItems`: Production v33, Development v21. Byte-identical to the repo. | TASK-0064 |
| `attempt-response` | `create_attempt` maps the teaching-item trigger refusal to **409 `open_hand_item_not_scorable`**. Two tests; 9/9 pass. Merged in #340. **Not yet deployed.** | APPROVAL-0124 |
| RLS | `content_item_versions_select_published` hides active teaching items from student reads. This closes the two legacy client reads (`/session` MCQ format, `/session/mcq`). Applied in Development and Production. | APPROVAL-0124, migration `20261006140000` |
| Trigger | `trg_refuse_attempt_on_teaching_item` **re-enabled in Production**. Verified by a rolled-back refused insert. | APPROVAL-0124 |
| QA | Fable re-check: `docs/qa/QA_OPEN_HAND_PRACTICE_RECHECK_2026_10_06.md`. The 3 previous blockers are fixed. New: N1 (rationale printed twice), N2 (latent `/session/mcq`), N3 (Bio Unit 1 thin). An addendum corrects Fable's `/session/setup` claim. | |
| Lovable (published by David) | N1 fix and "Revisit this one." copy (`6b142577`); per-subject plate loop flag, Statistics on (`aae52094`). | |
| Lovable (**built, NOT yet published**) | Plate loop on for every subject. Every diagnostic and session entry is retired. Resume goes to `/practice-mcq` or `/practice-frq`. Old routes redirect signed-in students to `/home`. The Statistics skill rail (`/session?intent=learn&skill=`) is kept. 603 tests pass. | edit `edt-660b7fa5` |
| Teaching items | **91 live in Production:** Bio 21, Stats 29, Chem 21, Calc AB 20, covering every Units 1–3 gap topic. Two outside checkers ran, plus a hand check; 4 rationale fixes; 15 blocked items rewritten (`fix15/`). Hash/content checks 91/91. Open Hand serves them; students cannot read them directly; scoring never serves them. | APPROVAL-0125 |

PRs merged this session: #340, #347, #349, #350. No PR is open from this session.

## 3. Product Owner decisions this session
- Approved the 409 change. For the trigger re-enable, chose **"fix it in the database first"** (the RLS change).
- Checkers: Gemini 3.8 Flash and DeepSeek V4 Pro (DeepSeek 5 is not on the gateway).
- Plate loop: Statistics first, then **every subject**, and **no student enters the diagnostic flow at all**.
- Teaching items: load 76 immediately, Claude fixes the remaining 15, then loads them as a second batch. Review status
  is set directly (checker provenance, no human-review rows).

## 4. State of every moving part

| Item | State |
|---|---|
| Plate loop, all subjects / diagnostic removal (Lovable) | **Built and diff reviewed; publish pending (David)** |
| `attempt-response` 409 | Merged; **deploy pending (David, CLI)**. Low urgency: every serving path is filtered, so the trigger is only a backstop. |
| Teaching items (91) | Live in Production. Development has Bio and Stats only (it has no published Chem or Calc AB pack). |
| Trigger, RLS, `student-session-items` | Live in Production and Development |
| Signed-in walkthrough of the live app | **Not done by a human.** Lovable, Fable and Claude verified from code, tests and data only. |

## 5. Pending decisions
- Statistics skill rail: it stays on `/session` (course-mode learn flow). Moving it into Practice too is David's call.

## 6. Open risks / blockers
- **Biology Unit 1 Practice is thin:** 4 items, all on topic 1.7. With every Unit 1 topic now having a worked example,
  "Try one on your own" from any Bio Unit 1 topic lands in those 4 protein items and then shows "finished for this unit".
  Thin also: Chemistry Unit 1 (19 items / 4 of 8 topics) and Physics C Mechanics Unit 1 (14 items / 2 of 5).
- Resume opens Practice at the start, not at the student's last topic. The session row does not carry the topic.
- Scoring-exclusion checks for Stats and Calc AB were sampled (the selector caps at 50 rows). The items carry no serving
  labels, so they cannot be selected.
- `AP_BIOLOGY_CED_FACT_PACK.md` 3.3 omits energy coupling, so DeepSeek keeps flagging that topic as out of scope.
- Development lacks `app.taxonomy_relevant_hash`, so `select_unit_gated_practice_items` errors there.

## 7. Next actions, in order
1. David: publish the Lovable all-subjects build, then do the two-check signed-in test above.
2. David: `supabase functions deploy attempt-response --project-ref wmgjsdkphcyhngaffbqf --use-api --workdir "$PWD"`, then the same with `pcntajvbdfqhbeewmdry`.
3. Content: author Biology Unit 1 practice MCQs across 1.1–1.6. This is the biggest gap in the plate loop.
4. TASK-0065 Units 4+, using the same pipeline (`CHECK_RESULTS.md`, `scripts/content-seed/task0065_load/`).
