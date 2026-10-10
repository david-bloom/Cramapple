# Lovable prompt — shared question-page shell (sent 2026-10-09)

Durable copy of the implementation prompt sent to the New Cramapple App (`56cae479-f7c9-4988-b536-56538c38ee4e`).
Derived from `REFERENCE_PACK_AND_QUESTION_PAGE_SESSION_CLOSE_2026_10_09.md` §2.2, corrected against the live
source at commit `e8c11dce42d25bd2991841f4c92e340a3e1e3a84` (routes, data shapes, BYOQ data path), with the
Product Owner's vocabulary-selection rule (2026-10-09: owner topic first, then reuse, RPC order, cap 3).

---

Implement this in Preview only. **Do not publish to Production.** No database, RPC, Edge Function, policy, or
scoring change.

## Goal

Give the live question pages one shared, compact shell — header strip, three panes (left guidance / center
question / right reference) — while each mode keeps its own learning and grading behaviour.

Pages in scope (confirm these against the code before editing; do not invent routes):

- Open Hand worked example: `/open-hand-mcq` (`src/routes/open-hand-mcq.tsx` → `LiveOpenHandMcq` →
  `src/screens/LiveOpenHandTeaching.jsx`). `/open-hand-frq` is retired (`RetiredRouteGate`); leave it retired.
- Graded Practice: `/practice-mcq` and `/practice-frq` (`LivePracticeMcq.jsx` / `LivePracticeFrq.jsx` →
  `PracticeMcqScreen.jsx` / `PracticeFrqScreen.jsx`).
- BYOQ practice: `/byoq/$itemId` (`ByoqPractice.jsx`). `/byoq-scaffold` is a retired redirect; leave it.

Out of scope: the Student Hub (`/home`) and its exam countdown, the Lesson Notes page
(`/learn/$subjectKey/$unitNumber/$topicCode`), `/session`, BYOQ intake/review screens other than what is needed
to trigger content loading below.

## 1. Header strip (shared: `StudyNav.jsx` + `QuestionPlate.jsx` Masthead/Breadcrumb)

1. Put **Return to student hub**, **Change topic**, and the **subject selector** (`SubjectSwitcher`) in the
   orange Cramapple bar. Keep their current hrefs and leave-guard behaviour.
2. Directly below the orange bar: breadcrumb (course → Unit → topic), topic title with a short subtitle, and
   the learning-mode label (current Masthead mode label).
3. Replace the progress sentence ("Question N of M in this set" / "N more examples in Unit X") with plain
   **`N/M`** text only, e.g. `2/5`. When the page has no N/M (e.g. Open Hand's "N more examples"), show nothing
   rather than inventing a total.
4. These must not appear in the strip on any of these pages: an exam countdown ("exam in N days"), a mastery
   summary ("N of M mastered"), a segmented progress bar, or a "Save and stop" button. I believe none are on
   these pages today; if you find any, remove them from the strip and tell me where they were. Do not touch
   the Student Hub's countdown.
5. Do not change session or attempt persistence.

## 2. Left pane — answer and scoring guidance (mode-aware)

- **Open Hand MCQ:** answer choices and their rationales, as the worked example reveals them today.
- **Practice MCQ/FRQ:** keyed off the existing `submitted` flag
  (`Boolean(attempt && attempt.mode === 'practice')`). Before submission: no correctness, answer key,
  earned/lost points, or canonical response. After submission: the existing authorized feedback
  (answer/rubric feedback and common point-loss guidance). Do not change `gradeLiveMcq`,
  `fetchGradedMcqFeedback`, `recordAttempt`, or the FRQ submit/photo path.
- **BYOQ:** ungraded, topic-aligned guidance only ("How points are earned", "What this kind of question asks
  for", common pitfalls) from the existing BYOQ guide content (`reference.guides` from `byoq.getItem`, via
  `mapBrief`/`mapExplainer`/`toByoqScaffold`). Never show "correct", "incorrect", "earned", "lost", a score,
  an answer-key reveal, or a rubric that claims to be for the student's pasted question.

## 3. Center pane — the active question

Stimulus/visual, question, student or worked response, and the existing primary actions. Open Hand stays an
unscored worked example; Practice stays the scored attempt; BYOQ shows the student's question read-only.

## 4. Right pane — compact reference

Collapsible sections with real `<button>` toggles and `aria-expanded`, in this order. **Omit any section that
has nothing to show** — no empty headings, counts, placeholders, or developer copy.

1. **Skills** — the existing skills list (`mapOpenHandGuides`: `whatStudentsNeedToUnderstand` + `answerMove`).
2. **Vocabulary** — at most 3 entries, chosen by the rule below.
3. **Equations & visuals** — `formula` and `diagram` entries chosen by the same rule (cap 3). Formula bodies
   are LaTeX; keep today's rendering (raw LaTeX in the existing `LookUp` style). Do **not** add a math library
   in this task.
4. **Memory hook** — at most 1, chosen by the rule below, shown with its `caution` when present.
5. **Full Lesson Note** — one link to `/learn/$subjectKey/$unitNumber/$topicCode` for the current topic.

`list_sequence` and `convention` entries are not shown on the question page (they stay in Lesson Notes).

### Selection rule (deterministic — implement as one small pure function with unit tests)

Input: the current topic's `reference: ReferenceEntry[]` and `memoryHooks: MemoryHook[]` from
`fetchTopicGuides(subjectKey, unitNumber, topicCode)` (`src/lib/topic-content.ts`), already filtered to
`published`, in RPC order. For a kind group (vocabulary; or formula+diagram):

1. entries with `ownerTopicCode === topicCode`, in RPC order; then
2. entries with `ownerTopicCode !== topicCode` and `topicCodes.includes(topicCode)`, in RPC order;
3. take the first 3. Never pad from other topics, the unit roll-up, or the explainer text.

Memory hook: the first hook (RPC order) whose `ownerTopicCode === topicCode`; otherwise the first whose linked
entry (`referenceEntryId`) is in this topic's `reference`; otherwise none.

Practice already fetches a whole-unit reference (topic `null`) in `usePracticeGuides`; the question-page right
pane must use the **topic** call, not the unit roll-up.

### Wiring gap to fix

`LiveOpenHandTeaching.jsx` calls `mapOpenHandGuides(brief, explainer)` without the reference or hooks arrays,
so Open Hand never shows reference content. Pass the topic's `reference` and `memoryHooks` through the shared
right pane so Open Hand, Practice, and BYOQ all use the same component and selection function.

### Practice gating

`ReferencePane` receives `gated={!submitted}` today. Keep whatever it currently gates before submission. Report
exactly what is gated before and after your change. Vocabulary, equations, and hooks are not answer truth, but
do not loosen any existing gate without telling me.

## 5. BYOQ unit/topic confirmation → content

Before the item has a confirmed subject + unit + topic (`item.topic` after `byoq.updateItem(..., {confirm:true})`):

- do not guess a topic or auto-pick the first topic of a unit;
- do not fill the left or right pane with unrelated material;
- show one focused message: "Confirm the unit and topic to load lesson support."

As soon as all three are confirmed, stay on the BYOQ page and:

- keep the existing left-pane guide content from `byoq.getItem`;
- call `fetchTopicGuides(subjectKey, unitNumber, topicCode)` with the confirmed values (normalize the subject
  key the way `fetchTopicGuides` callers already do) and feed its `reference`/`memoryHooks` to the shared right
  pane and selection function;
- show a loading state while fetching. On failure — including the RPC's `not_authenticated` error for a
  signed-out visitor — show a truthful, recoverable "Lesson support isn't available right now" state. Never
  fabricate content.

BYOQ must stay outside grading. `src/lib/__tests__/byoq-no-grading.test.ts` must keep passing; do not import
`use-grade-practice`, `attempt-response-client`, `live-practice-*`, or `evaluate-attempt`, and do not expose
`is_correct` or a canonical answer.

## 6. Responsive and accessible

- Desktop: left guidance / center question (widest) / right reference.
- Narrow: center question first, then left guidance, then right reference.
- Orange-bar controls wrap cleanly: no overlap, no horizontal scroll at 375px.
- Visible focus, semantic headings, labelled toggles; never color alone for correct/incorrect or
  earned/missed.

## 7. Tests and report

Keep existing tests green. Add:

- unit tests for the selection function (owner-first ordering, reuse second, cap 3, no padding, hook rule,
  empty input);
- a test that the header strip shows only `N/M` and none of the four removed elements;
- a BYOQ test: before confirmation → the confirmation message and no reference content; after confirmation →
  `fetchTopicGuides` called with the confirmed subject/unit/topic and the right pane populated; failure →
  the unavailable state.

When done, report: the components and routes you changed; the exact BYOQ call path; what `gated` hides
before and after; the tests you ran and their results; the commit hash; and the Preview URL. Confirm that
Production was **not** published.
