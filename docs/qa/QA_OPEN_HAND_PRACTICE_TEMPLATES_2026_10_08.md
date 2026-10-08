# QA — Open Hand and Practice templates (student ease of use, clarity, backend wiring)

**Date:** 2026-10-08
**Reviewer:** independent QA (Claude, read-only). No code was changed.
**Source of truth:** Lovable project `56cae479…` at `d5adcbc6` ("Updated own-attempt label at bounds", the latest connector commit, `is_published: true`); the backend repo at this commit; read-only SELECTs against Production `pcntajvbdfqhbeewmdry`. The live site could not be opened from this sandbox, so §6 lists what still needs eyes on a screen.
**Scope:** the four live question templates a student reaches from the hub — `/open-hand-mcq` (`LiveOpenHandTeaching` → `OpenHandMcqScreen`), `/practice-mcq` (`LivePracticeMcq` → `PracticeMcqScreen`), `/practice-frq` (`LivePracticeFrq` → `PracticeFrqScreen`) — plus the hub doors that lead into them (`HomeStudyActions`, `TopicHome`). Assessed for ease of use, clarity and helpfulness, then traced to the backend.
**Previous round:** `QA_OPEN_HAND_PRACTICE_RECHECK_2026_10_06.md`. Its N1 (rationale printed twice as "Fix:") is fixed: `OpenHandMcqScreen` no longer passes `explanation`/`note` to the option rows and the rationale lives once, in the Answer Key pane.

---

## 1. Verdict

**The templates are well built where they have content to stand on, and the backend contract behind them is sound. The problems a student will actually hit are almost all at the seam between the template and the data it is handed.** Two of them are serious enough to confuse most students in several subjects today:

1. **Practice FRQ is served with no topic in 8 of 10 subjects**, and Practice MCQ in AP Calculus AB Unit 1 is in the same state. On those items the plate titles itself **"Worked example"** (a Practice screen), offers no hint, no reference materials, no deep dive, and tells the student the question "isn't labelled with a topic yet".
2. **Practice is capped at the same 50 questions forever.** The selector orders deterministically and the client can only hide answered ones, so a student who works through the served 50 is told "No unanswered questions were found in this set" while up to 224 more exist for their unit.

Everything else is a copy, placement or policy issue that is cheap to fix. Nothing found leaks an answer key, scores a teaching item, or strands a student with no way forward.

---

## 2. What works (so it is not re-litigated)

- **Grading is server-only and honest.** `gradeLiveMcq` / `gradeLiveFrq` run `create_attempt → save_response → submit_response → evaluate-attempt`; only a `graded` verdict is shown, and anything else is a visible "Try again" with a visible "Skip this question". MCQ grading is rule-based (`resolveGradingRoute` → `mcq_rule`), so the verdict is instant and deterministic.
- **Answer explanations only after a verdict.** `fetchGradedMcqFeedback` is called after `graded.ok`; the RPC refuses unsubmitted or ungraded attempts. A correct pick can never be tagged "Distractor" (marks are untagged when the feedback RPC fails).
- **Open Hand never burns a scored item.** It reads only the teaching pool (`get_open_hand_teaching_item`), which is filtered out of every served list (`dropTeachingItems`, selector SQL, and the `trg_refuse_attempt_on_teaching_item` backstop).
- **Leaving is guarded, not blocked.** An unsubmitted pick or draft prompts a confirm; a grade in flight blocks with a one-line reason; nothing is silently lost without a warning.
- **Empty states are honest** — no `MISSING.` placeholders, no fabricated reference text, cross-unit jumps are announced, the end of the teaching pool offers Practice and the hub.
- **Set progress and the three-answer pause** give a visible rhythm ("Question 3 of 10 in this set", "3 answers submitted. Want to keep going?").
- **Phone layout** collapses the three panes to one column and stacks the Open Hand action row; text wraps with `overflow-wrap: anywhere`.

---

## 3. Findings, ranked

### Major

#### F1. Practice FRQ (and Calc AB Unit 1 MCQ) renders as a topic-less plate titled "Worked example"

**What the student sees.** On `/practice-frq` the question pane title reads **"Worked example"**, the breadcrumb reads *"AP Calculus AB · Worked example"*, the plate caption says "… · Worked example · Practice", the Reference pane says *"This question isn't labelled with a topic yet, so we can't show topic notes or a hint for it."*, the Scoring pane's only gate ("How points are earned and lost") opens to *"No topic notes for this topic yet."*, and there is no deep dive. The student is writing a free response with no rubric, no notes and a title that says it is not practice.

**Why.** `LivePracticeFrq` and `LivePracticeMcq` both run the served item through `applyOpenHandContext` (`src/lib/open-hand/presentation.ts`). When the item has no `cell.topic_code`, `openHandDisplayTitle` falls back to the literal **"Worked example"**, and `realQuestionChromeLabels` treats that string as student-safe, so it propagates to the pane title, breadcrumb and caption. `usePracticeGuides` is disabled without a topic, so reference, deep dive and the topic hint are all null, and `practiceGuideEmptyMessage` prints the "isn't labelled" line.

**How often (Production, 2026-10-08).** The FRQ selector the screen uses (`frq_only` default path → `select_practice_frqs`) serves items with no primary topic resolution in:

| Subject | FRQs served (cap 50) | without a topic |
|---|---|---|
| AP Calculus AB | 50 | 50 |
| AP Calculus BC | 43 | 43 |
| AP Chemistry | 50 | 40 |
| AP Physics 1 | 50 | 50 |
| AP Physics 2 | 25 | 25 |
| AP Physics C: E&M | 45 | 45 |
| AP Physics C: Mechanics | 33 | 33 |
| AP Precalculus | 44 | 44 |
| AP Statistics | 49 | 0 |
| AP Biology | 50 | 0 |

MCQ (`select_unit_gated_practice_items`, `_item_type='mcq'`, cap 50): AP Calculus AB Unit 1 **46 of 50** served items have no topic, Unit 2 15 of 50, Unit 3 10 of 50; AP Precalculus Unit 2 1 of 50; every other subject/unit 0.

**Also broken by the same gap.** The hub's "Practice FRQs" link carries `?topic=`, but `biasItemsToTarget` matches on `taxonomy.topic`, so for these subjects the topic is ignored and the student gets the pack's FRQs in `published_at` order regardless of what they picked.

**Fix.** (a) In `applyOpenHandContext` / `realQuestionChromeLabels`, make the no-topic fallback mode-aware: "Practice question" in Practice, "Worked example" only in Open Hand. (b) Content: resolve topics for the FRQ packs and Calc AB Unit 1 MCQs (`content_item_topic_resolution` has no primary row for 420 of 572 published FRQ versions). (c) Until (b) lands, hide the "Practice FRQs" door for subjects whose FRQs carry no topic, or drop the `?topic=` from it so it does not promise alignment.

#### F2. Practice has a hard ceiling of 50 questions per unit position, and it is always the same 50

**What the student sees.** After answering the served questions, every visit to `/practice-mcq` opens on *"No unanswered questions were found in this set."* with only "Return to student hub" and "See a worked example". The copy says "this set", but there is no next set and no way to get more.

**Why.** `select_unit_gated_practice_items` ends with `order by label.max_required_unit desc, civ.published_at nulls last, ci.content_key limit least(_limit, 50)`. The order is deterministic and the function caps at 50 regardless of the `_limit` the client sends, so the same 50 rows come back on every call. Answered exclusion is client-side only (`buildPracticeQueue` drops ids from `localStorage` ∪ the student's own `attempts`); nothing on the server skips answered items or pages past the first 50.

**How big the gap is (MCQ, Production).**

| Subject · unit | served | eligible for that position |
|---|---|---|
| AP Calculus AB · 3 | 50 | 274 |
| AP Calculus BC · 3 | 50 | 267 |
| AP Precalculus · 3 | 50 | 183 |
| AP Statistics · 3 | 50 | 180 |
| AP Chemistry · 3 | 50 | 130 |
| AP Biology · 3 | 50 | 129 |
| AP Physics 1 · 3 | 50 | 109 |

(Units 1 and 2 show the same pattern at smaller totals; subjects with ≤50 eligible are unaffected.) A student who does one 10-question set a day hits the wall in a week.

**Second-order effect.** Because the order is "highest required unit first", the 50 are drawn from the current unit before earlier ones, so a Unit 3 student whose class is revisiting a Unit 1 topic may be served no Unit 1 items at all, and `biasItemsToTarget` has nothing to pull forward.

**Fix.** Either (a) pass the student's answered `content_item_version_id`s (or a `_exclude` list / `_offset`) into the selector and exclude or page server-side, or (b) at minimum randomise within the cap with the session id as the seed (the Biology and combined selectors already take `_selection_seed`), so repeated visits reach different items. Change "this set" copy to say what is actually true when the wall is hit.

### Medium

#### F3. "Learn from a question" always goes to Open Hand, even when the decision helper says Practice

`HomeStudyActions.learn` awaits `entry.resolve(...)` and then does `if (destination.kind === "plate") navigate(destination.to) else navigate("/open-hand-mcq", …)`. The helper's `kind: "practice"` result (topic has no worked example) is sent to Open Hand anyway. `TopicHome.startPractice` honours the decision; `HomeStageANew` (the new-student hub) does not. A new student whose topic has no teaching item lands on the **"A worked example for this topic is coming soon."** placeholder as their first screen, with "Next example" (which jumps to a different topic) as the primary action.

Where it bites today (topics with a worked example / topics in the first three units): AP Physics 1 **10/19** (Unit 1: 1 of 5), AP Physics 2 **4/21**, AP Physics C: E&M **4/13**, AP Physics C: Mechanics **4/20** (Unit 2: 0 of 10), AP Precalculus **14/44**, AP Calculus BC 24/32. Biology, Calc AB, Chemistry and Statistics are fully covered for Units 1–3. **Beyond Unit 3 there are almost none** (Biology 1 of 38, Statistics 3 of 15, every other subject 0), so any student past Unit 3 always lands on the placeholder, and "Next example" wraps *backwards* to Unit 1 with a one-line note.

**Fix.** Make the `else` branch navigate to `destination.to`, or if the product decision is "Learn from a question always means Open Hand", change the placeholder's primary action to "Try one on your own" and make the note explain why.

#### F4. The cross-unit / no-example note is the smallest text on the plate

When Open Hand jumps topics it writes `view.note` ("No worked example for 1.2 · … yet — here's 2.7 · …", or "That was the last worked example after … — moving on to Unit 4: …"). `OpenHandMcqScreen` passes it to `ActionRow` as `note`, which renders at `--type-count-size` in `--text-quiet` at the far right of the button row, below the choices. On a phone it is below four stacked buttons. The student's first question ("why am I on a different topic than I picked?") is answered in the least visible place on the page.

**Fix.** Render the note as a `role="status"` strip above the question (the same treatment `LivePracticeMcq` uses for the not-scorable notice).

#### F5. Opening an aid on the first question of a visit silently marks the attempt "coached"

By design (`firstQuestion` → `directOpen`), aids on the first question open without the "Sure you need a hint?" step. That step is also the only place the cost is stated ("…and is listed on your feedback"). So on question 1 the student taps "Show me" or "Show me the reference materials", gets the content, and the attempt is recorded as `assistance_state: coached` with `independent_diagnostic_evidence: false` — with no warning before the click. The receipt afterwards ("Hint used · Reference materials") is the first signal. The README rule is "a hint is never free and never silent"; this makes it free *and* silent for one question per visit.

**Fix.** Keep the direct open but show the cost line inline on the idle gate when `directOpen` is true ("Opens right away · listed on your feedback"), or keep the two-step on aids that change `assistance_state` and only direct-open the deep dive.

#### F6. Four names for one thing

The same screen is called **"Open Hand"** (masthead chip, route, caption), **"Worked example"** (breadcrumb status, hub button, Practice's "See a worked example"), **"Learn from a question"** (hub door) and **"Face-up"** (Answer Key eyebrow). "Open Hand" and "Face-up" are poker idioms a 16-year-old will not decode. Practice is consistently "Practice". Pick "Worked example" everywhere a student reads it and keep "Open Hand" internal.

#### F7. Retrying a failed grade creates a second attempt

`gradeLiveMcq` / `gradeLiveFrq` mint a fresh idempotency key for `create_attempt` on every call, and "Try submitting again" calls the whole chain again. If the first chain got as far as `submit_response` and only `evaluate-attempt` refused (`uncertain`, `budget_capped`, timeout — the FRQ path is an LLM call), the first attempt stays `submitted` and a second attempt is created for the same item in the same session. Production shows 4 (user, item) pairs with 9 extra attempts in the last 30 days (small, but usage is small). Side effect: `fetchAnsweredItemIds` treats `submitted` as answered, so an item whose grade never came back is excluded from the next visit anyway.

**Fix.** Cache the attempt/response-version ids per item for the life of the screen and retry from `evaluate-attempt` (the `makeCaptureSubmitKeyCache` pattern already exists in `attempt-response-client.ts`).

#### F8. Browser-local state is not scoped to the signed-in user

`cramapple.session.v1` (attempts, hint states) and `cramapple.ux001.session-id.v1` are keyed by nothing. On a shared device (school laptop, sibling) student B inherits student A's local attempts — items A answered are dropped from B's queue (`localAnsweredIds`), and hints A opened on an item B is later served count as "used" for B, marking B's attempt coached. The learning-session id is safe (the server refuses a resume by another user), but the plate state is not. Scope the key by `userId` as `seen-counter.ts` already does.

### Minor

- **m1. Two taps to continue after the pause.** At the third graded answer the "Next question" button is hidden and replaced by "Continue"; tapping it brings "Next question" back. Make "Continue" advance directly.
- **m2. Open Hand on a phone shows the Answer Key above the question.** Pane DOM order is Answer Key → Question → Reference and the 899px rule collapses to one column, so the student scrolls past every rationale before reading the stem. Either reorder for the one-column case (`order:` on the question pane) or accept it as the Open Hand teaching stance and say so.
- **m3. "Your answer" on a face-up key.** Picking an option in Open Hand labels it "Your answer" in both panes even though nothing is answered or recorded. "Selected" or no label.
- **m4. The option text appears twice in Open Hand** (centre list and left Answer Key). On a phone that is eight blocks of the same four choices. The left pane could show key + rationale only.
- **m5. FRQ rubric row labels are derived from criterion keys** (`criterion_2_context` → "Criterion 2 context"). Readable, but authored `learner_facing_text` exists in `frq_criteria` and the grader result could carry it.
- **m6. The FRQ "How this is scored" pane is nearly empty before submission.** With no student-safe criteria source the rubric gate is hidden and only the points brief remains, so the student writes blind to the number of criteria and their point split. The part headers do show points per part, which helps; a one-line "Scored on N criteria, M points" from the parts would help more.
- **m7. "Hints" pane that says there are no hints.** On an item whose topic brief has no `answerMove` the pre-submit left pane reads "One point. One submission…" then "No hints for this question yet." (Briefs with an answer move cover every topic in Units 1–3 of every subject in Production, so this only shows on topic-less items — see F1.)
- **m8. Six MCQ stems and one FRQ stem carry LaTeX/markdown markers** (`\frac`, `$…$`, `**`) that `Stem.jsx` prints verbatim. Low count; worth a lint in the pipeline.
- **m9. Mode-switch session churn.** MCQ Practice runs a session with no `practice_format`, FRQ Practice needs `targeted_drill`; switching between them archives one session and starts another each time (`startOrResumeSession`). Harmless to the student, noisy in `learning_sessions`.

---

## 4. Backend wiring (what each screen calls, and the gate on each call)

| Screen action | Client | Backend | Gate / note |
|---|---|---|---|
| Open Hand: load item | `fetchTeachingItem` → RPC `get_open_hand_teaching_item(subject, topic)` | plpgsql, `security definer` | `auth.uid()` required; active entitlement or staff role; teaching pool only (`released_at is null`, published); returns `null` when the topic has none. Still aliases `minimum_fix` to `rationale` (harmless now that the screen ignores it). |
| Open Hand: "Next example" | `fetchTeachingTopics` → RPC `get_open_hand_teaching_topics(subject)` (cached per subject) → `pickNextTeachingTopic` → item RPC | same gates | Candidate order: rest of unit → later units → earlier units; never loops. |
| Open Hand: saved position | `fetchSavedCoursePosition` → `public.student_course_positions` view | `security_invoker`, RLS own-row | Only when no `?topic=`. |
| Reference / deep dive / hint text (both modes) | `fetchTopicGuides` → RPC `get_topic_point_guides(subject, unit, topic)`; fallback view `topic_point_briefs` | authenticated | Needs a topic on the item — see F1. |
| Practice: session | `startOrResumeSession` → edge `session-event` `session_resume` / `session_end` / `session_start` | owner-checked | MCQ sends no `practice_format`; FRQ sends `targeted_drill`. Stored id in `localStorage`. |
| Practice MCQ: items | `fetchPracticeMcqItems` → edge `student-session-items` `{mode:'unit_gated', item_type:'mcq', limit:50}` | owns session; `student_course_positions.unit_id` (default 1) → `select_unit_gated_practice_items` | Edge function drops teaching items, marks `open_hand_excluded`, strips `is_correct`/`rationale`/`prompt_json`; function caps at 50 — see F2. |
| Practice FRQ: items | `fetchPracticeFrqItems` → same function, default `frq_only` mode, `item_type:'frq'` | session must have a `practice_format` | Routes to `select_biology_practice_items` / `select_ordinary_combined_practice_items` / `select_practice_frqs` by exam code; authored part prompts only for Calc AB, Statistics, Biology (`EXAM_CODES_WITH_AUTHORED_PARTS`). |
| Practice: answered exclusion | `fetchAnsweredItemIds` → `public.attempts` view (`status in submitted, graded`) | `security_invoker`, RLS own rows | Client-side only — see F2. |
| Practice: submit | `create_attempt` → `save_response` → `submit_response` (edge `attempt-response`) → `grade_initial_attempt` (edge `evaluate-attempt`) | session active + owned; item published; `item_type = attempt_mode`; pack match; `practice_format` match; trigger refuses teaching items (409 `open_hand_item_not_scorable`) | MCQ → `mcq_rule` (deterministic). FRQ → `rubric_version_id = content_item_version_id`, LLM. New attempt per retry — see F7. |
| Practice: aid receipts | `recordAssistanceEvents` → insert into `public.attempt_assistance_events` | RLS: attempt must be the caller's | Fail-soft. Production has 2 rows in 30 days, consistent with pilot-level traffic. |
| Practice MCQ: explanations | `fetchGradedMcqFeedback` → RPC `get_graded_mcq_feedback(attempt_id)` | owner, MCQ, `submitted_at` set, a `grading_results` row | Called only after a `graded` verdict. |
| Hub doors | `usePracticeEntry` → teaching-topics RPC + taxonomy → `decidePracticeEntry` | — | `HomeStudyActions` ignores the `practice` decision — see F3. |

RLS spot-check (Production): `public.attempts`, `attempt_assistance_events`, `student_course_positions` are `security_invoker` views over RLS-enabled tables with owner-scoped policies (`attempts` update limited to `draft`/`failed`). The broad `INSERT/UPDATE/DELETE` grants on the views are inert under those policies.

---

## 5. Suggested order of work

1. **F1(a)** — mode-aware fallback title (one function, same day). Then **F1(b)** topic resolution for FRQ packs and Calc AB Unit 1 MCQs (content pipeline).
2. **F2** — server-side answered exclusion or seeded randomisation in `select_unit_gated_practice_items`, plus truthful end-of-queue copy.
3. **F3** — one-line fix in `HomeStudyActions.learn`; decide the placeholder's primary action.
4. **F4, F5, F6** — copy and placement; no backend change.
5. **F7, F8** — client robustness; small, contained.

---

## 6. Needs eyes on a screen (not verifiable from this sandbox)

- [ ] `/practice-frq` in AP Calculus AB: confirm the pane title and breadcrumb read "Worked example" and the Reference pane shows the "isn't labelled" line (F1).
- [ ] `/practice-mcq` as a Calc AB Unit 1 student: same, on most questions (F1).
- [ ] Answer the full served set in a small pool (AP Physics 1 Unit 1 has 15 MCQs): confirm the "No unanswered questions…" wall and that no "Next set" appears (F2).
- [ ] New-student hub (`HomeStageANew`) as an AP Physics C: Mechanics student at Unit 2: "Learn from a question" lands on the "coming soon" placeholder (F3).
- [ ] Open Hand "Next example" across a unit boundary on a 390px phone: find the note (F4).
- [ ] First question of a visit: tap "Show me the reference materials" — no cost shown before it opens; receipt appears after (F5).
- [ ] 390px: Practice MCQ action row ("Submit answer" + "Skip for now" + note) not clipped; Open Hand pane order (m2).

---

### Appendix — evidence (all read-only, Production, 2026-10-08)

```sql
-- F1: FRQs served without a primary topic, per subject
select p.subject_key, count(*), count(*) filter (where not exists (
  select 1 from app.content_item_topic_resolution r
  where r.content_item_version_id = x.content_item_version_id and r.is_primary))
from packs p, public.select_practice_frqs(p.epv_id, 'targeted_drill', 50) x group by 1;

-- F1/F2: MCQs served vs eligible per subject and first three allowed units
-- (served via public.select_unit_gated_practice_items(epv, unit, null, 'mcq', 50);
--  eligible = published MCQs with a validated serving label at max_required_unit <= unit, not teaching)

-- F2: selector definition
select pg_get_functiondef('public.select_unit_gated_practice_items(uuid,integer,text,text,integer)'::regprocedure);
-- ... order by label.max_required_unit desc, civ.published_at nulls last, ci.content_key
-- limit greatest(1, least(coalesce(_limit, 20), 50));

-- F3: teaching-topic coverage per unit (taxonomy_topics × open_hand_teaching_items, subject keys normalised)

-- F7: duplicate attempts, last 30 days
select count(*), sum(n-1) from (select user_id, content_item_version_id, count(*) n
  from app.attempts where created_at > now() - interval '30 days' group by 1,2 having count(*) > 1) d;
-- 4 groups, 9 extra attempts

-- Traffic context, last 14 days: mcq graded 11 (2 users), mcq draft 3, frq draft 4.
```

Lovable files read at `d5adcbc6`: `src/screens/{LiveOpenHandMcq,LiveOpenHandTeaching,OpenHandMcqScreen,LivePracticeMcq,PracticeMcqScreen,LivePracticeFrq,PracticeFrqScreen}.jsx`, `src/screens/parts/{AnswerKeyRows,StudyNav,QuestionPlate,ReferencePane,DeepDiveGate,ScoringHelp,Stem}.jsx`, `src/components/{choice/RadioOptionRow,hint/HintGate,feedback/FeedbackCard,rubric/RubricCriterionRow,pane/PaneShell,pane/Plate,navigation/Breadcrumb,actions/ActionRow,question/QuestionHeader,overlay/DeepDiveOverlay}.jsx`, `src/components/home/{HomeStudyActions,HomeStageANew,TopicHome}.tsx`, `src/session/{SessionProvider.jsx,hint-state.ts}`, `src/lib/open-hand/{teaching,presentation,unit-progress,loop,practice-guides}.ts`, `src/lib/live-practice-mcq/{session,grade,feedback,adapt,bias,answered,assistance-events}.ts`, `src/lib/live-practice-frq/{session,adapt,grade}.ts`, `src/lib/study-nav/{practice-visit,guard,question-href,seen-counter}.ts`, `src/lib/{practice-entry,use-practice-entry,feature-flags,topic-content,attempt-response-client,runtime-context-client,student-session-storage}.ts`, `src/lib/session/resume-guard.ts`, `src/routes/{open-hand-mcq,practice-mcq,practice-frq}.tsx`, `src/styles.css` (plate rules). Repo: `supabase/functions/{student-session-items,attempt-response,evaluate-attempt,session-event}/index.ts`, `_shared/grading-router.ts`, migrations `20261006004005`, `20261006081339`, `20260930190000`.
