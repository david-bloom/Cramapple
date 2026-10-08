# QA — Open Hand and Practice templates (student ease of use, clarity, backend wiring)

**Date:** 2026-10-08
**Reviewer:** independent QA (Claude, read-only). No code was changed.
**Designs under test:** the four question-experience boards in the *CramApple — Core Product* design canvas (`FZLJ4xPFWguSmcmMFrJNt2`, version saved 2026-10-07 ≈ 21:00 EDT): *1 · Learning from an answered question*, *2 · Practising, before submission*, *3 · Reviewing feedback after submission*, *Session endpoint and returning*, plus the canvas's own notes on them. These are the "new templates" for Open Hand and Practice.
**Build under test:** Lovable project `56cae479…` at `d5adcbc6` ("Updated own-attempt label at bounds", 2026-10-07 23:14 EDT, the latest connector commit as of this review; `is_published: true`, but Lovable does not say whether this head is the published one). It is the implementation of those designs under the approved minimal slice (`STUDENT_SESSION_CLARITY_MINIMAL_PLAN_2026_10_07.md`, which treats the boards as "references for labels, orientation and progress, not build templates"). Nothing newer was in Lovable at review time.
**Also read:** the backend repo at this commit; read-only SELECTs against Production `pcntajvbdfqhbeewmdry`; the five walkthrough screenshots under `docs/product/assets/first-session-walkthrough-2026-10-07/`. The live site could not be opened from this sandbox, so §6 lists what still needs eyes on a screen.
**Scope:** the four live question templates a student reaches from the hub — `/open-hand-mcq` (`LiveOpenHandTeaching` → `OpenHandMcqScreen`), `/practice-mcq` (`LivePracticeMcq` → `PracticeMcqScreen`), `/practice-frq` (`LivePracticeFrq` → `PracticeFrqScreen`) — plus the hub doors that lead into them (`HomeStudyActions`, `TopicHome`). Assessed for ease of use, clarity and helpfulness, then traced to the backend.
**Previous round:** `QA_OPEN_HAND_PRACTICE_RECHECK_2026_10_06.md`. Its N1 (rationale printed twice as "Fix:") is fixed: `OpenHandMcqScreen` no longer passes `explanation`/`note` to the option rows and the rationale lives once, in the Answer Key pane.

---

## 1. Verdict

**The templates are well built where they have content to stand on, and the backend contract behind them is sound. The problems a student will actually hit are almost all at the seam between the template and the data it is handed.** Two of them are serious enough to confuse most students in several subjects today:

1. **Practice FRQ is served with no topic in 8 of 10 subjects**, and Practice MCQ in AP Calculus AB Unit 1 is in the same state. On those items the plate titles itself **"Worked example"** (a Practice screen), offers no hint, no reference materials, no deep dive, and tells the student the question "isn't labelled with a topic yet".
2. **Practice is capped at the same 50 questions forever.** The selector orders deterministically and the client can only hide answered ones, so a student who works through the served 50 is told "No unanswered questions were found in this set" while up to 224 more exist for their unit.

**Added after the independent challenge review (`QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md`, same branch): §7 reconciles the two reports and corrects this one in four places, and F10 records a Production answer-key exposure found while verifying the challenge. F10 outranks everything else here.**

Measured against yesterday's boards, the build is a faithful minimal slice: the labels, progress and endpoint copy came across, and the things the plan deferred (pane swap, comparison tabs, revise, resume) are absent rather than half-built. The one design promise the build cannot keep is the learning state itself: the boards show a student learning from a scored **free-response** answer, and the only content Open Hand can serve is **multiple-choice** (§2b). Everything else is a copy, placement or policy issue that is cheap to fix. Nothing reachable from the hub leaks an answer key or scores a teaching item; one unlinked route still does (F9).

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

## 2b. Yesterday's designs against the build

The boards describe one question experience in three states plus an endpoint. The build ships a deliberate subset. Where the two differ, the student-facing consequence is what matters, so each row says what a student sees today.

| Design promise (Rev 1–4, 2026-10-07) | In the build at `d5adcbc6` | What a student sees today |
|---|---|---|
| **Mode is a bordered chip: LEARN FROM A QUESTION / INDEPENDENT PRACTICE**, beside the topic title. | Masthead chip reads **OPEN HAND** / **PRACTICE**; breadcrumb status reads "Worked example" / "Practice"; the hub door reads "Learn from a question". | The chip the design relies on for "what am I doing here?" uses the one word the design retired. See F6. |
| **Breadcrumb: Subject › Unit N · Unit title › Topic N.N**, then a Passion One topic title and a one-line description. | Breadcrumb: Subject · Unit N · "N.N · Title"; pane title "N.N · Title". Unit title and description are not shown. | Fine when the item has a topic. When it has none the pane title is "Worked example" even in Practice. See F1. |
| **Session progress "Question 2 of 5 · 3 remaining" with a five-segment bar**, persistent at the top of every state. | "Question X of N in this set" as plain text in the study nav; no bar; Open Hand shows "R more examples in Unit U". | Progress exists but is text-only and lives in the nav strip above the masthead, not beside the question. Readable; easy to miss on a phone. |
| **"Save and stop"** in the header. | "Return to student hub" link in the nav; in Practice a line reads "Submitted answers are saved. Unsubmitted work isn't saved when you leave." | Matches the plan (no save promise that is not kept). The design's "Save and stop" label was correctly not copied. |
| **Reference pane on the LEFT, unboxed, quiet**: numbered Skills, collapsible Vocabulary / Study tips / Key equations ("Not yet"), Deep Dive card with Copy · Google Docs · PDF · Share link. | Reference pane on the RIGHT, boxed, green cap; Topic / Skills / Vocabulary / On the exam / Common point loss; Deep Dive opens an overlay with Copy only. In Practice the whole pane sits behind a costed gate. | Pane swap deferred by the plan. Google Docs / PDF / Share link do not exist, which the plan also says to omit. The design's "Study tips" and "Key equations" have no data source. |
| **Learning state (Rev 1): an FRQ with a worked answer, highlighted spans mapped to rubric criteria ("Earned by …"), comparison tabs This one / Full credit / Common mistake / Vague, a "ONE POINT AWAY" coaching block, "Reading this is optional".** | Live Open Hand serves the **MCQ teaching pool only** (`get_open_hand_teaching_item`; all 186 active teaching items are MCQs). The MCQ screen shows every option tagged Correct/Distractor with its rationale, no comparison tabs, no coaching block. `OpenHandFrqScreen` (face-up rubric, credited-response spans, points you can take back) exists but has no teaching content behind it. | The designed "learn from a question" is an FRQ experience; what ships is an MCQ one. A student who expects to see how a free-response answer is scored does not get that anywhere reachable from the hub. The hub note "Recommended: see how a test-style question is asked and scored" is the design's "Reading this is optional" line, correctly placed. |
| **Practice state (Rev 2): rubric criteria names visible on the right before submission ("What each point needs is shown once you submit"); textarea placeholder restates the task; comparison tabs disabled with a lock "After you submit".** | FRQ: no criteria names before submission (no student-safe source yet); the Scoring pane shows only the points-brief gate. MCQ: left pane is "Hints". Textarea placeholder is the generic "Write your answer", not the task restated. No comparison tabs. | The design's main pre-submit orientation (how many points, named for what) is missing on FRQ. See m6. |
| **Feedback state (Rev 3): highlighted spans in the student's own answer, criterion rows with "Earned by …" quotes, "ONE POINT AWAY", attempts ledger "1 of 3 · 2 of 3 · just now", "Revise your answer", "One point is still available".** | FRQ: criterion rows (✓ / ↻) with the grader's explanation or minimum fix, a Feedback card with the student's answer and coaching. No span highlighting, no ledger, no revise (plan: one submission). MCQ: Answer Key rows + feedback card. | Reasonable subset. The ↻ convention replaces the design's ✗, per the design-system rule. No "Revise your answer" is correct for the current scoring policy, and the design's button should not reappear without that policy changing. |
| **Endpoint (Rev 4): "That's the session." · 5 of 5 · "Done for now" / "Practise 5 more"; return state "You stopped at question 3 of 5 … Resume question 3 / Start a new session".** | "You've reached the end of this practice set." · "Next set" / "Return to student hub" / "See a worked example". No return state: a returning student gets a rebuilt queue starting at "Question 1 of N". | Endpoint is honest and matches the plan. The return promise in the design is not built and the plan defers it; nothing in the build claims otherwise. |
| **One box, not four; warm-grey page ground; only the task and rubric on white.** | Three boxed panes on the desk ground, each with a coloured cap. | Layout rebuild deferred by the plan. |
| **No commerce on any board.** | None on the question routes. | Matches. |

**Where the design itself needs attention before it becomes a build template** (the canvas notes already flag most of these; recorded here so they are not lost):

- The session model ("Question 2 of 5") has no data behind it; the build's "set of up to 10 from a capped fetch of 50" is what exists. See F2.
- The three comparison answers (Full credit / Common mistake / Vague) and "Key equations" have no content for any item; the boards render them disabled. Do not build the tabs until at least one subject has the content.
- The regression example's question asks two things while its rubric scores three ("Explain influence"). The boards use it in every state; a student reading it would be taught to lose a point. Swap the fixture before the boards are used in any student-facing test.
- The boards are 1440×900 desktop only; the build is responsive and is what phones get. The plan's "narrow phone width" check still needs a screen.

---

## 3. Findings, ranked

### Major

#### F1. Practice FRQ (and Calc AB Unit 1 MCQ) renders as a topic-less plate titled "Worked example"

**What the student sees.** On `/practice-frq` the question pane title reads **"Worked example"**, the breadcrumb reads *"AP Calculus AB · Worked example"*, the plate caption says "… · Worked example · Practice", the Reference pane says *"This question isn't labelled with a topic yet, so we can't show topic notes or a hint for it."*, the Scoring pane's only gate ("How points are earned and lost") opens to *"No topic notes for this topic yet."*, and there is no deep dive. The student is writing a free response with no rubric, no notes and a title that says it is not practice.

**Why.** `LivePracticeFrq` and `LivePracticeMcq` both run the served item through `applyOpenHandContext` (`src/lib/open-hand/presentation.ts`). When the item has no `cell.topic_code`, `openHandDisplayTitle` falls back to the literal **"Worked example"**, and `realQuestionChromeLabels` treats that string as student-safe, so it propagates to the pane title, breadcrumb and caption. `usePracticeGuides` is disabled without a topic, so reference, deep dive and the topic hint are all null, and `practiceGuideEmptyMessage` prints the "isn't labelled" line.

**Correction (see §7, challenge A2).** The table below counts rows the FRQ *selector* returns. The FRQ adapter (`live-practice-frq/adapt.ts`) then rejects every row whose `parts_source` is not `prompt`, and the deployed edge function only authors prompt parts for Calculus AB, Statistics and Biology. So in the seven other subjects these rows never reach the plate: the student sees "No practice questions were found in this set." instead of a topic-less plate. The "Worked example" title is real today for **Calculus AB FRQs** (all four authored-prompt rows in the challenge's seeded probe lacked a topic) and for **Calculus AB Unit 1 MCQs**; for the seven subjects the defect is an empty route, which is A2.

**Selector rows without a topic (Production, 2026-10-08; not delivered-queue counts):**

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

#### F9. `/open-hand-frq` is a live route that reveals, and burns, scored FRQs

`src/routes/open-hand-frq.tsx` → `LiveOpenHandFrq` → `LiveOpenHand` fetches the student's **scored** FRQ queue (`fetchPracticeFrqItems`, the same selector Practice uses), shows a consent screen ("Seeing the worked answer means this question won't count toward your score"), then calls `get_open_hand_item`, which writes an `open_hand_scoring_exclusions` row and returns the full key. This is the pre-TASK-0064 design; the Oct 6 decision moved Open Hand to the never-scored teaching pool, and the MCQ route was switched to it, but the FRQ sibling was not. It is not linked from the hub and is not in `RETIRED_STUDENT_PATHS`, so it is reachable by URL, browser history, and (it carries ordinary `og:` meta with no `noindex`) potentially by search. `get_open_hand_item` is still executable by `authenticated` in Production. Nobody has used it: `open_hand_scoring_exclusions` has 0 rows. Scale, corrected per the challenge: the route fetches 10 FRQs at a time through the same adapter as Practice, so only subjects with authored prompt parts (Calculus AB, Statistics, Biology) can be burned this way, ten per load. Smaller than first stated, still permanent per student.

**Fix.** Add `/open-hand-frq` to `RETIRED_STUDENT_PATHS` (redirect to `/home`) until there is an FRQ teaching pool, or point it at a teaching-pool RPC. Revoke `authenticated` execute on `get_open_hand_item` if no reachable screen needs it.

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

#### F10. BLOCKER — Production never received the answer-key revoke; a signed-in student can read keys through the selector RPC

Found while verifying the challenge review's A2 (which relies on `select_practice_frqs` being callable from the browser). Migration `20260930190000_task0056b_revoke_prompt_json.sql` is the one that closes TASK-0056 for Production: it revokes the `prompt_json` column from `authenticated`, and revokes `execute` on `select_practice_frqs`, `select_unit_gated_practice_items` and `select_hand_drawn_pilot_items` from `anon` and `authenticated`. Its header says to record it as version `20260930190000` on every environment.

**Production state, 2026-10-08 (read-only):**

- `supabase_migrations.schema_migrations` has `20260930120000`, `120100`, `120200` and everything from `20261002` on. **`20260930190000` is absent.**
- `has_column_privilege('authenticated', 'app.content_item_versions', 'prompt_json', 'select')` → **true**.
- `has_function_privilege('authenticated', …)` → **true** for `select_practice_frqs` and `select_unit_gated_practice_items`. The latter is `SECURITY DEFINER` and returns `prompt_json`.
- What `prompt_json` carries on served items (`select_unit_gated_practice_items(pack, highest allowed unit, null, null, 50)`): Calculus BC 12 of 50 with `canonical_answers` and 8 with `mcq_choices` carrying `is_correct`; Precalculus 10 and 6; Calculus AB 6 and 3; Statistics 12 with `criteria` / `deterministic_criteria` / `expected_graph_spec`. Chemistry, Physics and Biology served rows carry no answer fields.

The RPC's own guard only limits a student to their active pack, so a Calc BC student can call it from the browser console with their own session and read the key for up to 12 of their next 50 items. The Oct 6 QA re-check and the launch-readiness records treat TASK-0056 as closed in Production; that assumption was wrong. The Lovable client also depends on this grant today: `usePublishedFrqs` (the hub's "Practice FRQs" door) calls `select_practice_frqs` directly and reads `prompt_json.parts`, so applying the revoke as written will hide that door until the hook moves to `student-session-items`.

**Fix.** Apply `20260930190000` to Production (it is idempotent), after re-pointing `usePublishedFrqs` at the edge function or accepting that the FRQ door disappears until it is. Then re-run the TASK-0056 QA brief. This is a Product Owner call because it is a Production change; nothing here was changed.

---

## 7. Reconciliation with the independent challenge review

`QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md` (Codex/Sol, pushed to this branch 2026-10-08 07:25 EDT) reviewed this report at `c173ca02`. Every one of its nine added findings was re-checked against the same Lovable head and Production; all nine hold. Where it corrects this report, the correction is now in the body above (F1, F9, §2b, §4) and summarised here.

| Challenge finding | Verified? | Effect on this report |
|---|---|---|
| **A1** Practice MCQ never renders `question.stimuli` | Yes. `PracticeMcqScreen` renders `Stem` and choices only; `OpenHandMcqScreen` does render stimuli. Production first-unit MCQ selectors: Statistics 24 of 50 served items carry a text stimulus, Precalculus 10, Calc AB 3, Calc BC 3, Biology 1; none carry an image. | **New P0, missed here.** A Statistics Unit 1 student gets about half of their questions without the data needed to answer. Goes above F1 in the repair order. |
| **A2** FRQ rows are rejected unless `parts_source === "prompt"`; only Calc AB, Stats, Bio get authored parts | Yes (`adapt.ts`, `student-item-delivery.ts` line 635, `EXAM_CODES_WITH_AUTHORED_PARTS`). | **Corrects F1.** Seven subjects get an empty FRQ route, not a topic-less plate. The topic-less "Worked example" plate is real for Calc AB FRQ and Calc AB Unit 1 MCQ. |
| **A3** FRQ fetch bypasses the unit position | Yes (`fetchPracticeFrqItems` omits `unit_gated` by design; the default selectors have no unit constraint). | Added to the list; a Unit 1 student can be served a later-unit FRQ. |
| **A4** FRQ requires every part filled; feedback promises a next attempt that does not exist | Yes (`answered = parts.every(...)`; "↻ … still available next attempt" copy; `buildPracticeQueue` drops submitted items). | Added. |
| **A5** Opening the empty "How points are earned and lost" gate marks the FRQ attempt coached | Yes (`ScoringHelp` always renders `POINTS_HINT`; `PracticeFrqScreen` tracks it). MCQ is not affected (it only renders gates that have content). | Added; sharper than F5. |
| **A6** Answer and aids stay editable while a grade is in flight | Yes (only the Submit button reads `grading`). | Added; fold into F7's retry work. |
| **A7** Example traversal cycles | Yes; `teachingCandidates` has no visited set, so 1.1 → 2.1 → 1.1 … with two available topics. | **Corrects §4** ("never loops" was a single-step claim stated as a traversal one). |
| **A8** Set endpoint cannot tell skipped from answered | Yes. | Added as a copy/scope item; the plan deferred a recap screen. |
| **A9** Accessibility: overlay without dialog semantics, unlabeled FRQ fields, no arrow navigation on radios | Yes from source; not reproduced with assistive technology. | Added to §6. |

**Where this report changes its position.**

- **F5.** The first-question direct open is an approved decision, not a policy breach; the ask narrows to disclosure ("recorded as guided") plus A5.
- **F6.** The masthead "Open Hand" is preserved by the approved plan; a global rename is the Product Owner's decision. The comprehension point stands.
- **F3.** The challenge's preferred remedy (say the example is unavailable and offer the other doors, rather than silently routing to scored Practice) is better than the one-line fix proposed above. Either is a one-screen change.
- **F2.** Seeded randomisation is a mitigation, not a fix; the challenge's server-side filter on the student's answered state before `LIMIT`, with a stable cursor, is the right target.
- **F7.** The 9 extra attempts in 30 days are not proven to be retries; the diagnosis stands, the inference is withdrawn.
- **m6 / §2b.** The FRQ textarea does have a placeholder ("Write your answer"); the gap is orientation, not absence.

**Where this report holds.** F1's code defect and the Calc AB cases; F2; F4; F8 (the challenge raises its priority, agreed); F9 as a reachable obsolete route; the design-versus-build table in §2b, which the challenge did not independently check.

**Repair order, revised.** F10 first (Production change, owner's call). Then the challenge's package 1 (A1, A2, F1 fallback, A5), package 2 (F7, F8, A6, A4), package 3 (F2, F3, A3, topic resolution), package 4 (F4, F5, F6, A7–A9, minors), package 5 (F9 containment, FRQ teaching decision, exact return). The challenge's 13 acceptance cases are the test plan for that order.

## 4. Backend wiring (what each screen calls, and the gate on each call)

| Screen action | Client | Backend | Gate / note |
|---|---|---|---|
| Open Hand: load item | `fetchTeachingItem` → RPC `get_open_hand_teaching_item(subject, topic)` | plpgsql, `security definer` | `auth.uid()` required; active entitlement or staff role; teaching pool only (`released_at is null`, published); returns `null` when the topic has none. Still aliases `minimum_fix` to `rationale` (harmless now that the screen ignores it). |
| Open Hand: "Next example" | `fetchTeachingTopics` → RPC `get_open_hand_teaching_topics(subject)` (cached per subject) → `pickNextTeachingTopic` → item RPC | same gates | Candidate order: rest of unit → later units → earlier units. A single step never revisits the start, but repeated steps cycle (1.1 → 2.1 → 1.1 …); see §7, A7. |
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
3. **F9** — retire `/open-hand-frq` (one entry in `RETIRED_STUDENT_PATHS`) and revoke the burn RPC from `authenticated`.
4. **F3** — one-line fix in `HomeStudyActions.learn`; decide the placeholder's primary action.
5. **F4, F5, F6** — copy and placement; no backend change.
6. **F7, F8** — client robustness; small, contained.
7. Before the Rev boards become build templates: an FRQ teaching pool (or the boards redrawn around an MCQ), a session contract, and a fixture whose rubric matches its question (§2b).

---

## 6. Needs eyes on a screen (not verifiable from this sandbox)

- [ ] `/practice-frq` in AP Calculus AB: confirm the pane title and breadcrumb read "Worked example" and the Reference pane shows the "isn't labelled" line (F1).
- [ ] `/practice-mcq` as a Calc AB Unit 1 student: same, on most questions (F1).
- [ ] Answer the full served set in a small pool (AP Physics 1 Unit 1 has 15 MCQs): confirm the "No unanswered questions…" wall and that no "Next set" appears (F2).
- [ ] New-student hub (`HomeStageANew`) as an AP Physics C: Mechanics student at Unit 2: "Learn from a question" lands on the "coming soon" placeholder (F3).
- [ ] Open Hand "Next example" across a unit boundary on a 390px phone: find the note (F4).
- [ ] First question of a visit: tap "Show me the reference materials" — no cost shown before it opens; receipt appears after (F5).
- [ ] Signed in as a test student, open `/open-hand-frq` directly: confirm the consent screen appears and that "Show me" would write an exclusion row (F9). Use a throwaway account; the exclusion is permanent for that student.
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

-- F10: TASK-0056b revoke never applied to Production
select version from supabase_migrations.schema_migrations where version = '20260930190000'; -- 0 rows
select has_column_privilege('authenticated','app.content_item_versions','prompt_json','select'); -- true
select has_function_privilege('authenticated','public.select_unit_gated_practice_items(uuid,integer,text,text,integer)','execute'); -- true
-- served rows (highest allowed unit, any type, 50) whose prompt_json carries canonical_answers / mcq_choices.is_correct:
--   calc BC 12 / 8, precalc 10 / 6, calc AB 6 / 3; statistics 12 with criteria or expected_graph_spec

-- A1: served first-unit MCQs with a text stimulus the Practice screen never renders
--   statistics 24/50, precalculus 10/50, calc AB 3/50, calc BC 3/50, biology 1/50; images 0

-- F9: burn RPC still callable; never used
-- get_open_hand_item: execute granted to authenticated; app.open_hand_scoring_exclusions: 0 rows

-- F7: duplicate attempts, last 30 days
select count(*), sum(n-1) from (select user_id, content_item_version_id, count(*) n
  from app.attempts where created_at > now() - interval '30 days' group by 1,2 having count(*) > 1) d;
-- 4 groups, 9 extra attempts

-- Traffic context, last 14 days: mcq graded 11 (2 users), mcq draft 3, frq draft 4.
```

Lovable files read at `d5adcbc6`: `src/screens/{LiveOpenHandMcq,LiveOpenHandTeaching,OpenHandMcqScreen,LivePracticeMcq,PracticeMcqScreen,LivePracticeFrq,PracticeFrqScreen}.jsx`, `src/screens/parts/{AnswerKeyRows,StudyNav,QuestionPlate,ReferencePane,DeepDiveGate,ScoringHelp,Stem}.jsx`, `src/components/{choice/RadioOptionRow,hint/HintGate,feedback/FeedbackCard,rubric/RubricCriterionRow,pane/PaneShell,pane/Plate,navigation/Breadcrumb,actions/ActionRow,question/QuestionHeader,overlay/DeepDiveOverlay}.jsx`, `src/components/home/{HomeStudyActions,HomeStageANew,TopicHome}.tsx`, `src/session/{SessionProvider.jsx,hint-state.ts}`, `src/lib/open-hand/{teaching,presentation,unit-progress,loop,practice-guides}.ts`, `src/lib/live-practice-mcq/{session,grade,feedback,adapt,bias,answered,assistance-events}.ts`, `src/lib/live-practice-frq/{session,adapt,grade}.ts`, `src/lib/study-nav/{practice-visit,guard,question-href,seen-counter}.ts`, `src/lib/{practice-entry,use-practice-entry,feature-flags,topic-content,attempt-response-client,runtime-context-client,student-session-storage}.ts`, `src/lib/session/resume-guard.ts`, `src/routes/{open-hand-mcq,open-hand-frq,practice-mcq,practice-frq}.tsx`, `src/screens/{LiveOpenHand,LiveOpenHandFrq,OpenHandFrqScreen}.jsx`, `src/lib/open-hand/client.ts`, `src/lib/retired-routes.ts`, `src/styles.css` (plate rules). Repo: `supabase/functions/{student-session-items,attempt-response,evaluate-attempt,session-event}/index.ts`, `_shared/grading-router.ts`, migrations `20261006004005`, `20261006081339`, `20260930190000`.
