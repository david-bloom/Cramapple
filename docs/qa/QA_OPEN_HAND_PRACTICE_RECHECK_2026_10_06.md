# QA re-check — Open Hand, Practice, Home (after the 2026-10-06 fix round)

**Date:** 2026-10-06 (later the same day as `QA_STUDENT_HUB_OPEN_HAND_PRACTICE_2026_10_06.md`)
**Reviewer:** independent QA (Fable), read-only. Source of truth: Lovable project `56cae479…` at `aec926ad` ("Applied plate-loop followup", 08:40 UTC, `is_published: true`), the backend repo at `/home/user/Cramapple`, deployed edge-function source pulled from Supabase, and read-only SELECTs against Production `pcntajvbdfqhbeewmdry`. The live site still cannot be opened from this sandbox; section 5 lists what needs eyes on a screen.
**Scope:** every finding from the previous QA that was marked Blocker/Major, plus a fresh pass over `/home`, `/open-hand-mcq`, `/practice-mcq` and every path that serves a scored item.

---

## 1. Verdict

**The three previous blockers are fixed in the published build and in Production data. One new Major (duplicated rationale on every Open Hand option), one latent Major (a legacy page still reads published MCQs with no teaching filter), and a content-coverage Major for Biology Unit 1 remain.**

- **Re-enable `trg_refuse_attempt_on_teaching_item` in Production: GO, now.** No path a student can reach from Home can serve a teaching item any more (edge function v33 filters every mode; the four SQL selectors filter; Practice no longer reads content tables; the one remaining unfiltered page cannot serve a teaching item with today's data). If the trigger ever does fire, every screen now has a visible way forward even before `attempt-response` is redeployed.
- **Turn the plate loop ON: not yet.** Fix the duplicated "Fix:" line first (one-line change), then ON for AP Statistics. Biology should wait for Unit 1 content: a Unit 1 Biology student gets four questions, all on topic 1.7, all variants of one item.

---

## 2. Previous blockers and majors, re-checked

### B1 — Teaching item served to Practice, then dead-end on submit → **FIXED (serving) / MITIGATED (dead-end)**

Every path that serves a scored item, checked one by one:

| Path | Reachable today (flag OFF)? | Reachable flag ON? | Filters active teaching items? | Evidence |
|---|---|---|---|---|
| `student-session-items` `unit_gated` (Practice MCQ, `/session` default for non-pilot) | yes | yes | **yes**, twice | Production v33 (`updated_at` 2026-10-06 08:31 UTC, sha `563deb41…`; Development v21 same sha). Deployed source contains `dropTeachingItems` ×3, `annotateOpenHandExclusions` ×6. Repo `supabase/functions/student-session-items/index.ts:807` calls `dropTeachingItems` on `delivered.items` after every ordinary mode, before the response; `_shared/student-item-delivery.ts:701-725` fails closed on a lookup error. The SQL selector also filters (`select_unit_gated_practice_items` def contains `and not app.content_item_is_teaching(ci.id)`). |
| `cell_scoped` (`/session`, AP Statistics pilot) | yes | yes | **yes** | Same common tail (`index.ts:807`). This mode reads `app.content_items` directly (no selector), so the edge-function filter is the only one — now deployed. |
| `frq_only` default → `select_biology_practice_items` / `select_ordinary_combined_practice_items` / `select_practice_frqs` | yes | yes | **yes** | First two reference `content_item_is_teaching` (pg_proc search); FRQ selector does not need to (all 95 teaching items are MCQs). Plus the common tail. |
| `hand_drawn_pilot` → `select_hand_drawn_pilot_items` | yes (pilot page) | yes | yes via common tail | Selector itself is unpatched, but `index.ts:807` runs after it. |
| `confirm_transfer` branch (`index.ts:~507-580`) | yes (Statistics pilot) | yes | **yes (SQL only)** | This branch returns before line 807 and bypasses `dropTeachingItems`; it is covered because `app.select_confirm_transfer_item` references `content_item_is_teaching`. Worth a comment in the code so nobody removes the SQL clause thinking the function covers it. |
| Practice MCQ client (`src/lib/live-practice-mcq/session.ts`) | — | yes | **no direct read any more** | File header: "Items come ONLY from the server selector… There is no client-side content-table fallback." `fetchPracticeMcqItems` → `student-session-items unit_gated`. Test `plate-loop-qa.test.ts` "A1" asserts no `use-published-mcq` / `content_item_versions` / `mcq_choices` in `LivePracticeMcq.jsx` or `session.ts`. `scorableOnly()` also drops `open_hand_excluded` items (`LivePracticeMcq.jsx`). |
| `use-session.ts` `published_mcq` path (`buildPublishedMcqQuery`, unfiltered) | **effectively unreachable** | same | no | Only taken when `contract.selectedFormat === "mcq"` (`serving-path.ts`). `src/routes/session.index.tsx` `contractFromSearch` never sets `selectedFormat`; the only other source is `location.state.contract`, which nothing in the app navigates with (TASK-0033 §root cause confirms Home doors carry no format). Dead code in practice, but still a loaded gun — see N2. |
| `/session/mcq` (`src/routes/_ux.session.mcq.tsx`, `usePublishedMcqs`) | **yes, by URL** (linked from the legacy `/setup` and `/topic` prototype pages; `noindex`) | same | **no** | Reads every published MCQ in the pack ordered by `published_at` and shows `items[0]` only. Verified in Production that the first-published MCQ of all 10 packs is **not** a teaching item (`APBIO-MCQ-017`, `APSTATS-MCQ-004`, …). So it cannot serve a teaching item today, but nothing stops a future designation from making it so. See N2. |

Production data: 95 active teaching items (released_at null) across 10 subjects: Biology 2 (`APBIO-MCQ-016` 2.7, `APBIO-MCQ-032` 4.3), Statistics 14, Calc BC 24, Precalc 14, Calc AB 12, Physics 1 10, Chem 7, Physics 2/C-EM/C-Mech 4 each. `select_unit_gated_practice_items` for Biology unit 2 (25 rows) and Statistics unit 1 (50 rows) returns **0** teaching items. `app.attempts` contains **0** attempts ever on a teaching item.

**What the student sees if a teaching item is somehow served and the trigger is ON:**

- *Before `attempt-response` is redeployed* (Production v35, 2026-09-29, contains `attempt_create_failed` ×1 and `open_hand_item_not_scorable` ×0): `create_attempt` returns **500 `attempt_create_failed`**. Practice: `gradeLiveMcq` → `notScorableOr("attempt_create_failed", …)` is not the not-scorable code, so `PracticeMcqScreen` shows "We couldn't grade that one. Try again." **and now a visible "Skip this question" button** next to "Try again" (`PracticeMcqScreen.jsx`, `gradeError && <ActionButton variant="quiet" onClick={onSkip || onNext}>Skip this question`). Not stuck. `/session` (`use-session.ts`): the pre-warm `ensureAttempt` fails silently, Submit → `grading_failed`; the student can still "Move on" (the SessionFrame failed-state UI was not re-read this round — eyes needed). `/session/mcq`: "Couldn't create your attempt — try again." with "Move on and return later" available. Not stuck.
- *After redeploy* (repo `supabase/functions/attempt-response/index.ts:535-541` maps the trigger message to **409 `{error:"open_hand_item_not_scorable"}`**): Practice shows the banner "You've seen the worked answer for this one, so it won't be scored." and auto-drops the item (`LivePracticeMcq.jsx handleSubmit` → `isNotScorable` → `setNotice` + `dropCurrent`). `/session/mcq` maps any 409 to its `content_unavailable` phase. Fine.

### B2 — Practice never reveals the correct answer → **FIXED**

- `public.get_graded_mcq_feedback(uuid)` exists in Production (owner-only, MCQ-only, requires `submitted_at` and a `grading_results` row; grants: `authenticated`, `service_role`; `anon` revoked).
- `LivePracticeMcq.jsx handleSubmit`: `fetchGradedMcqFeedback(graded.attemptId)` is called only after `graded.ok` (test "feedback is requested only after a graded verdict" checks source order). `toRecordedAttempt` (`grade.ts`) builds one mark per choice from the feedback with `is_correct` and `rationale`; without feedback it builds a single untagged mark (`is_correct: null`) so a correct answer can never be labelled "Distractor".
- `PracticeMcqScreen.jsx`: `shown` is `attempt.marks` after submit; verdict tag only when `mark.is_correct !== null`; rationale on every row; the false caption "explained in the Answer Key" is gone; the Scoring pane says "Every option is marked and explained in the question pane." or, when the RPC fails, the question pane says "We couldn't load the answer explanations for this one." once.
- `normalizeGradedFeedback` rejects a payload that does not have exactly one credited choice.

### B3 — Unit 1 Biology student lands on an empty Open Hand → **FIXED**

- Home no longer sends that student to Open Hand. `decidePracticeEntry` (`practice-entry.ts`) routes to `/practice-mcq` unless the topic is in `get_open_hand_teaching_topics` (Production: Biology → `{2.7, 4.3}`; Statistics → 14 codes). `usePracticeEntry` (`use-practice-entry.ts`) is used by `HomeStageANew`, `HomeStageBBuilding` and `TopicHome` (test asserts) with the raw `subjects.subject_key`; the button label is "See a worked example →" only when the click will go to Open Hand.
- If a student does reach the placeholder (e.g. `/open-hand-mcq?topic=1.2` from Practice's "See a worked example"), it now has **"Next worked example"** (`LiveOpenHandTeaching.jsx`), and `teachingCandidates` probes later topics in the unit, then all later units, then earlier units — never loops. The jump is announced: "No worked example for 1.2 · … yet — here's 2.7 · …". End state: "You've seen every worked example for AP Biology after 4.3 · …" with "Start practice".
- Practice for a Unit 1 Biology student does load: session_start without `practice_format` is accepted (`session-event/index.ts:235-256` only validates when present); `select_unit_gated_practice_items(bio, 1, null, 'mcq')` returns **4** rows; `create_attempt`'s `practice_format_mismatch` guard cannot fire because all 2,048 published MCQs have `practice_format = null`. But see N3 for what those 4 rows are.

### M1 — Open Hand hides rationales, prints "Credited." → **FIXED, with a new defect (N1)**

`OpenHandMcqScreen.jsx`: `explanation={c.rationale || undefined}` on every row on load; the Answer Key pane prints `A · Correct` / `B · Distractor` plus the choice text (no "Credited.", no "No fix line in this package."); no `points=` on the header; no read counter (`RadioOptionRow` still supports `readCount` but nothing passes it). Test "D Open Hand shows everything" bans the strings. **However** the same row also gets `note={c.minimum_fix}` and the RPC aliases `minimum_fix` to the rationale — see N1.

### M2 — "NOT IN THIS PACKAGE" developer placeholders in Practice → **FIXED**

Test "F" bans `MISSING.`, `<Missing`, "No fix in the package", "not in the package" in the four live screens. `PracticeMcqScreen` renders the Scoring pane from `scoringNote`/hints/deepDive/habits only when present; `ReferencePane` gets `emptyMessage={OPEN_HAND_GUIDE_EMPTY}` ("Topic notes for this question are coming soon."), and `usePracticeGuides` supplies the same reference/deep dive Open Hand has. (`ReferencePane.jsx` still falls back to `MISSING.reference` when no `emptyMessage` is passed — other callers only.)

### M5 — "Try one on your own" does not stay on topic → **FIXED as far as content allows**

Items now carry the server-resolved `cell` (`adapt.ts` reads `cell.topic_code/topic_title/unit_number`; all 4 Biology U1, 25 U2 and 50 Statistics U1 rows have a primary `content_item_topic_resolution` with a title). `biasItemsToTarget` matches on that topic. For Biology 2.7 the student gets 2.x items first. For a Unit 1 student the bias is inert because no served item is on their topic (N3).

### M6 — "Start practice" opens a not-scored worked example → **FIXED**

Label and destination come from one decision (`decidePracticeEntry`); the label reads "See a worked example →" exactly when the destination is Open Hand.

### Not re-checked this round (outside the fix round's scope, presumed still open)

M3 (subject picker / `complete_onboarding` ignore entitlements), M4 (Home evidence counts `attempts.status`, not `grading_results`; cross-subject evidence), and the previous minors m2–m7. None of them blocks the trigger decision; M3/M4 still matter before any wide launch.

---

## 3. New findings, ranked

### Major

#### N1. Every Open Hand option shows its rationale twice — the second copy labelled "Fix:"

`public.get_open_hand_teaching_item` builds each choice as `'rationale', mc.rationale, 'minimum_fix', mc.rationale` (Production `pg_get_functiondef`). `teaching.ts toTeachingMcq` keeps both (`minimum_fix: str(c["minimum_fix"])`). `OpenHandMcqScreen.jsx` passes `explanation={c.rationale}` **and** `note={c.minimum_fix}`. `RadioOptionRow.jsx` renders the explanation, then `<strong>Fix:</strong> {note}` under it. Result on every one of the four rows: the rationale, then "**Fix:** <same rationale>". The distractor rationales say why a choice tempts; printing them again as a "fix" is wrong twice over (duplicate, and mislabelled). The test only bans the literal strings, so it passes.

**Fix (either):** drop `note={c.minimum_fix || undefined}` in `OpenHandMcqScreen.jsx`, or stop aliasing in the RPC (`'minimum_fix', null`) and in `toTeachingMcq`. Add an assertion that a row never renders the same text twice.

#### N2. One unfiltered client-side read of published MCQs survives, reachable by URL

`src/routes/_ux.session.mcq.tsx` (`/session/mcq`, linked from the legacy `/setup` and `/topic` prototype pages, `noindex`) calls `usePublishedMcqs` → `buildPublishedMcqQuery` (every published MCQ in the pack, no teaching filter) and serves `items[0]`, then grades it through `use-grade-practice.ts` (`create_attempt` pre-warm → save → submit → evaluate). The `/session` `published_mcq` branch in `use-session.ts` is the same read, gated on a `selectedFormat` nothing sets. Today neither can serve a teaching item (verified: the first-published MCQ of every pack is not teaching), so this is latent, not live. But the TASK-0064 invariant is only true by accident of `published_at` order, and the next designation batch could pick an early item.

**Fix:** delete `/session/mcq` (and `/setup`, `/topic`) or point it at `student-session-items`; delete the `published_mcq` branch and `buildPublishedMcqQuery`'s production consumers (keep the regression test only if something still uses it). Until then, add `app.content_item_is_teaching` as a filter to the `public.content_item_versions` view or add a guard in the designation script that refuses to designate the first-published MCQ of a pack.

#### N3. Biology Unit 1 Practice is four variants of one item, all on topic 1.7

`select_unit_gated_practice_items(biology, 1, null, 'mcq', 50)` → `APBIO-MCQ-008`, `APBIO-MCQ-SV-008-v1/v2/v3`, all resolved to **1.7 Proteins** (stems are different but all "amino-acid substitution → protein structure"). A student who set Unit 1 · 1.2 presses "Start practice →", gets four protein questions, then "You've finished the questions ready for this unit." Nothing says the questions are off-topic, and after four submits they are done with Unit 1 for good. (Unit 2: 25 items / 15 families; Unit 3: 25; Unit 4: 31; Unit 8: 50. Statistics U1: 50 items / 33 families, 2 near-duplicate stems.) This is content, not code — but it is exactly the fall-term entry case the previous QA flagged.

**Fix:** author/label Unit 1 Biology MCQs before switching the plate loop on for Biology; until then, say on the empty/finished states which topics the served questions covered.

### Minor

- **N4. Practice action buttons may not stack on phones.** The 899px rules (`styles.css:208-224`) stack `.ca-open-hand-actions` only; `PracticeMcqScreen`'s `ActionRow` has no class, so "Submit answer" / "Skip this question" / "Skip for now" depend on `ActionRow`'s own flex-wrap. The plate itself does shrink (`.ca-open-hand, .ca-practice { min-width: 0 !important }` beats the inline `minWidth: var(--plate-min-width)`). Eyes needed at 390px.
- **N5. Home label can lag the click for a moment.** `usePracticeEntry.label()` returns the fallback while the topics query is loading; `resolve()` awaits the query. A fast click on "Start practice →" can land on Open Hand. Cosmetic.
- **N6. `/onboard` step 3 navigates to `/session/setup`**, a route that has no file (`navigate({ to: "/session/setup" as never })`). Outside this round's scope; worth a look since the comment in `session.index.tsx` says the setup page was retired.
- **N7. Confirm-transfer branch relies on SQL alone** for the teaching filter (see table). Add a comment or route it through `dropTeachingItems` too.
- **N8. `ReferencePane` still falls back to `MISSING.reference`** for any caller that omits `emptyMessage`. Practice and Open Hand pass it; nothing else should render it, but the developer string is one missed prop away.

---

## 4. Go / no-go

### Re-enable `trg_refuse_attempt_on_teaching_item` in Production

**GO — now, before `attempt-response` is redeployed.** Reasons: (1) every Home-reachable serving path filters active teaching items (v33 edge function common tail; four SQL selectors; Practice no longer reads content tables); (2) the one unfiltered legacy page cannot serve a teaching item with today's data; (3) if the trigger fires anyway, Practice shows "Try again" + a visible "Skip this question", `/session/mcq` has "Move on and return later", `/session` reaches `grading_failed` with its normal move-on controls — no dead end; (4) 0 refused attempts have ever occurred, so there is no backlog of stuck students. The trigger is the backstop the containment removed; with serving fixed it only ever costs a 500 on a path that should not exist.

**After `attempt-response` is deployed: still GO**, and better — the 500 becomes a 409 that Practice turns into the explanatory banner and an auto-skip. Verify the deployed version contains `open_hand_item_not_scorable` (v35 has zero occurrences) and re-run `plate-loop-qa.test.ts` "C".

Conditions to keep it enabled: don't designate the first-published MCQ of any pack until N2 is fixed; don't remove the `content_item_is_teaching` clause from `select_confirm_transfer_item`.

### Turn the plate loop ON (`VITE_PLATE_LOOP=on`)

**Not yet.** Fix N1 first (one line; every Open Hand row is affected). Then:
- **AP Statistics: GO** — 14 teaching topics, Unit 1 Practice has 50 filtered items with cells, Home routes correctly, phone width needs one look (N4).
- **AP Biology: NO-GO** — 2 teaching topics and a Unit 1 practice pool of one item family (N3). Students whose class is in Unit 1 (most of them in October) get a worked example only if they are on 2.7/4.3 and four protein questions otherwise.
- Other subjects: untested in this round beyond serving data (all packs have a `home_release_manifest`; teaching coverage 4–24 topics). Do not enable without the same per-subject check of unit-gated MCQ counts for units 1–2.

---

## 5. Needs eyes on a screen (cannot be verified from this sandbox)

- [ ] Open Hand (Statistics 1.6 or Biology 2.7): confirm each option shows its rationale **twice** with the second prefixed "Fix:" (N1) — screenshot for the fix ticket.
- [ ] Practice after a **wrong** answer: all four rows tagged Correct/Distractor with rationales, the credited row visible, no "Distractor" on a correct pick.
- [ ] Practice after the feedback RPC fails (e.g. disable network after submit): verdict shown, picked row says "· Your answer", one "We couldn't load the answer explanations" line.
- [ ] 390px phone: `/practice-mcq` action row ("Submit answer" + "Skip for now"; and with a grade error, "Try again" + "Skip this question") — not clipped (N4). `/open-hand-mcq` three panes stack, buttons full-width.
- [ ] Biology student at Unit 1 · 1.2: Home button reads "Start practice →", lands on Practice with a 1.7 protein question, "finished" state after four.
- [ ] Biology student at 2.7: Home button reads "See a worked example →"; Open Hand loads; "Next question" jumps to Unit 4 · 4.3 with the cross-unit note; then the end state.
- [ ] `/session` with a forced `grading_failed` (what the student sees and whether "Move on" is offered) — the SessionFrame failure UI was not re-read this round.
- [ ] `/onboard` → step 3 "Start →" (N6).

---

### Appendix — evidence (all read-only)

```sql
-- trigger state
select tgname, tgenabled from pg_trigger where tgrelid='app.attempts'::regclass and not tgisinternal;
-- trg_refuse_attempt_on_teaching_item = 'D'

-- which functions filter teaching items
select n.nspname, p.proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace
where p.prosrc like '%content_item_is_teaching%';
-- app.select_biology_practice_items, app.select_confirm_transfer_item,
-- app.select_ordinary_combined_practice_items, public.select_unit_gated_practice_items

-- unit-gated MCQ counts with a null practice format (what Practice now sends)
select count(*) from public.select_unit_gated_practice_items('2d88ba5e-…',1,null,'mcq',50); -- 4 (all APBIO-MCQ-008 family, topic 1.7)
--   bio u2 25, u3 25, u4 31, u8 50; stats u1 50 (0 teaching), u2 50
--   with 'targeted_drill': 0 for both (unchanged; Practice no longer sends it)

-- first-published MCQ per pack is not a teaching item (the /session/mcq page serves items[0])
-- APBIO-MCQ-017, APSTATS-MCQ-004, apchem-mcq-032, … all teaching=false

-- attempts on teaching items, ever
select count(*) from app.attempts a join app.content_item_versions civ on civ.id=a.content_item_version_id
where app.content_item_is_teaching(civ.content_item_id); -- 0

-- RPC grants
-- get_graded_mcq_feedback, get_open_hand_teaching_topics, get_open_hand_teaching_item: authenticated + service_role, anon revoked
```

Deployed functions (Supabase `list_edge_functions`): Production `student-session-items` v33 (2026-10-06 08:31 UTC) / Development v21, identical sha `563deb41…`; Production `attempt-response` v35 (2026-09-29) — `open_hand_item_not_scorable` ×0, `attempt_create_failed` ×1.

Lovable files read at `aec926ad`: `src/lib/{feature-flags,practice-entry,use-practice-entry}.ts`, `src/lib/open-hand/{teaching,loop,adapt-mcq,presentation,client}.ts`, `src/lib/live-practice-mcq/{session,grade,feedback,adapt,bias}.ts`, `src/lib/use-published-mcq.ts`, `src/lib/course-mode/serving-path.ts`, `src/hooks/use-session.ts`, `src/lib/use-grade-practice.ts`, `src/screens/{LiveOpenHandMcq,LiveOpenHandTeaching,OpenHandMcqScreen,LivePracticeMcq,PracticeMcqScreen}.jsx`, `src/screens/parts/{QuestionPlate,ReferencePane}.jsx`, `src/components/choice/RadioOptionRow.jsx`, `src/components/question/QuestionHeader.jsx`, `src/components/pane/Plate.jsx`, `src/components/home/{HomeStageANew,HomeStageBBuilding,TopicHome}.tsx`, `src/routes/{open-hand-mcq,practice-mcq,session.index,_ux.session.mcq,_ux.setup.index,_ux.topic,onboard}.tsx`, `src/lib/__tests__/{plate-loop-qa.test.ts,plate-loop-followup.test.tsx,serving-path.test.ts}`, `src/styles.css` (plate-width rules only).

---

## Addendum (Claude session, 2026-10-06): correction to the trigger GO

This QA says `/onboard` navigates to a nonexistent `/session/setup`. That route **does exist** in the
published build (`src/routes/session.setup.tsx`). Its "Practice a question type → MCQ" choice puts
`selectedFormat: "mcq"` in the session contract. `resolveServingPath`
(`src/lib/course-mode/serving-path.ts`) then returns `"published_mcq"` for every subject except AP
Statistics, and that path is the unfiltered client read `buildPublishedMcqQuery` in
`src/hooks/use-session.ts`. It serves scored items with no teaching-item exclusion. An independent
code audit in the same session found the same.

**Consequence:** with the trigger ON, a Biology student on that path can be served a designated
teaching item. They then get a "Try again" loop, though Skip still works. The GO to re-enable the
trigger is therefore conditional on closing that path (and N2, `/session/mcq`). The candidate fix is
an RLS change: `content_item_versions_select_published` gains
`and not app.content_item_is_teaching(content_item_id)`. That closes both client reads at once.
