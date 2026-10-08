# Student Session Clarity — Minimal Execution Plan

**Status:** Approved — finalized after Fable's re-review; implementation authorized by David 2026-10-07 22:57 EDT
**Date:** 2026-10-07 (America/New_York)
**Product Owner:** David Bloom
**Prepared by:** Codex
**Documentation tier:** Micro; implementation tier: Standard
**Related work:** TASK-0048 / TASK-0052; DECISION-0100 and its amendment
**Branch:** `codex/new-user-experience-second-pass`
**PR:** #369
**Next owner:** Codex (conductor), Lovable (implementation)
**Next required action:** Execute the finalized frontend slice, verify source and Preview checks, and record the implementation result.

## 1. Outcome and scope decision

Make the smallest changes that let a student answer four questions: What am I studying? What am I doing here? What should I do next, and how much remains? What happens if I stop and return?

Cramapple helps students lock in lessons through targeted information and practice directed toward class tests and the AP exam. Learning from an answered question is recommended, never required. Direct practice, existing supplemental notes and help understanding a student's own question remain legitimate paths.

David's latest direction is to defer a larger rebuild and create no new educational content. This plan is a deliberately limited implementation slice of the [unified recommendation](STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md), not a replacement for it. Deferred recommendations remain deferred, not rejected. David instructed: 'Final PR comment Read and finalize the plan. Then execute it.' on 2026-10-07 22:57 EDT. This authorizes implementation of the finalized frontend slice. Production publication, migrations and account changes are not included.

**Keep the current responsive frame, pane order, typography, colors, content and serving/grading contracts.** The Claude Design HTML files are references for labels, orientation and progress, not build templates. Do not copy their fixed 1440×900 dimensions or unavailable controls into the app. Swapping outer panes and rebuilding the reference panel are deferred with the broader layout work.

## 2. Verified baseline and evidence boundary

Read canonical bootstrap, current architecture/design, index, collaboration rules and unified recommendation from GitHub main. Inspected these Lovable app files at **`b868486fc1af8a3ffef39e03ebaa5f0d68b7bbda`**:

- `src/screens/LiveOpenHandTeaching.jsx`, `OpenHandMcqScreen.jsx`, `OpenHandFrqScreen.jsx`
- `src/screens/LivePracticeMcq.jsx`, `LivePracticeFrq.jsx`, `PracticeMcqScreen.jsx`, `PracticeFrqScreen.jsx`
- `src/screens/parts/QuestionPlate.jsx`, `StudyNav.jsx`
- `src/lib/open-hand/teaching.ts`, `src/lib/live-practice-mcq/session.ts`, `src/lib/study-nav/guard.ts`

The app is Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`. Project publication status alone does not establish the exact published head. This plan is source-informed, not a signed-in usability certification. Recheck head and route wiring before implementation; do not overwrite intervening work.

Important facts that constrain the solution:

| Current behavior | Consequence for this slice |
| --- | --- |
| Live Open Hand teaching serves one never-scored MCQ per topic; Next can move across topics and units. It does not create a learning session. | Do not pretend it is a five-question lesson session or invent learning-session persistence. |
| Practice fetches a limited set, filters answered items, then biases toward a target. Queue position is local; totals can differ from the fetch limit. | Count the actual displayed queue, not ten, the entire bank, or a fictional five. Do not claim every item is lesson-aligned. |
| MCQ and FRQ practice use a one-submission presentation; neither reviewed screen exposes a supported revise-and-rescore action. | Keep Next question after feedback. Do not add the mockup's Revise your answer button or change scoring policy. |
| Leave guards already block in-flight operations and confirm discarding unsent input. | Reuse those guards; do not add draft-saving infrastructure. |
| The unified record reports assistance events published and verified at 18:18 UTC on October 7, with real pre-submit hint counts. | Preserve this newer implementation. Earlier assessment statements that assistance events were missing are historical. |
| Shared Open Hand FRQ presentation exists, but this inspection does not prove a live FRQ teaching bank/route. | Apply shared wording where appropriate; verify route reachability. Do not create a FRQ teaching pool or new routes. |

## 3. Changes to implement

### A. Orientation and minimal entry clarity

Reuse the existing masthead/breadcrumb; do not add a new banner region.

- The hub door is **Learn from a question**. Preserve **Open Hand** in the question masthead, as DECISION-0100 §6 explicitly requires; show the learning-purpose sentence beneath it. Keep internal identifiers, routes, API names and scoring exclusions unchanged.
- Practice label stays **Practice**. Avoid describing aided practice as independent after a student opens help.
- Display the delivered question's subject, unit when known, topic code and readable title. Existing taxonomy/guide fields only; no generated lesson synopsis. If a field is absent, omit it rather than borrowing another lesson's title.
- On Open Hand show the agreed interface sentence: **See how a test-style question is asked and scored.** Keep **Your work isn't scored here** clear. For MCQs explain answer/rationale rather than implying an FRQ rubric exists.
- Add one short reading cue using existing material: **Read the question, then compare the answer with its explanation.** This is interface guidance, not a new worked solution.
- Add the hub purpose sentence: **Prepare for tests and the AP exam, one lesson at a time.** At the existing start-action location expose four compact, equally accessible actions: **Learn from a question** (recommended, with its reason), **Practice on my own**, **Read lesson notes**, and **Bring a question**. No four-card redesign or new lesson picker. Reword Stage B's practice-only hero lede to describe learning or practice, matching the destination. Never require an example visit first. Before Stage A has a saved position, Bring a question stays active; the other three actions stay visible with 'Set your position first' rather than disappearing.
- Promote the existing BYOQ entry, with **Understand your homework question without being given the answer.** Reuse its existing route and behavior.
- The notes action opens the existing selected-topic Deep Dive using the existing content reader/overlay and functioning copy control; do not route through a required example or reveal a scored question key. Verify the current hub's content fields and reuse the existing topic-content query if needed. If no notes exist, state that accurately and retain the other choices. Saved-notes storage and new export formats are explicitly deferred. This is partial delivery of DECISION-0100's notes promise, not a declaration that save/export is complete. Show **Copied** or **Couldn't copy** inline for clipboard results. With a saved unit but no topic, label the notes action **Pick a topic to read its notes** and focus the topic picker; never silently choose the unit's first topic.

### B. Visible, truthful progress

**Practice:** request up to **50** items through the current capped selector, then apply existing answered-item filtering and target bias. Display the resulting owned queue in sets of **up to 10**. This prevents the current deterministic first-ten fetch from becoming a dead end after all ten are answered. Verify the live helper/edge path actually forwards the larger limit; if a lower cap exists there, report it rather than claiming this solves the wall. Apply the same rule to reachable FRQ practice after checking its selector/helper path.

Show **Question X of N in this set**, where N is the actual current slice length, not 50 or the whole bank. Keep X unchanged through submission and feedback. Advance on Next or Skip; a skip is not a graded answer. Recalculate accurately after access/exclusion removal. At a set endpoint offer **Next set** as primary when eligible fetched items remain, and the hub as the alternative. At the last fetched set, show a truthful endpoint. No automatic next set, no claim of lesson mastery or entire-bank exhaustion. Server-side answered-item exclusion and pagination beyond the selector cap remain deferred; after all 50 are answered this frontend fix cannot discover items beyond the cap.

**Open Hand:** show **R more examples in Unit U**, using later topics in the current unit intersected with the available teaching-topic list. Reuse the existing `teachingTopicsKey` / `staleTime: Infinity` cache shared with `usePracticeEntry`; read through the existing fetch helper on cache miss, never add a new RPC or prefetch every answer key. Do not create a subject-wide total, a browse queue, scored attempts, or a learning session.

Name the destination before navigation: **Next example: [existing topic title]**. At the last example in a unit show **Last example in this unit** and make any cross-unit action explicit: **Explore Unit U: [topic]**. Crossing is an optional action, not hidden inside Next; preserve the existing selector and end state. Do not imply this count is a saved session or required assignment. If taxonomy/availability is unknown, omit the count and preserve honest retry/practice/hub choices.

**No timer.** Question/example counts supply the requested boundary without unmeasured duration estimates. Existing cumulative questions-seen data is distinct; make this-set progress primary and avoid two competing counters in the same strip.

### C. Explicit next actions and bounded finishes

| State | Primary action | Other actions |
| --- | --- | --- |
| Open Hand, content available | **Try one on your own** | **Next example: [topic]**; existing notes/BYOQ/hub access |
| Practice, before submission | **Submit answer** | Existing help and skip behavior |
| Practice, successful grading | **Next question** | Existing feedback/help access |
| Practice, grading error | **Try submitting again** | Existing guarded skip; preserve response |
| Last example in current unit | **Try one myself** | **Return to student hub**; no misleading Next |
| Last practice question in a set | **Next set** if eligible fetched items remain; otherwise **Return to student hub** | Existing supported topic/example links; no automatic continuation |

Open Hand's unit boundary does not remove the existing optional, explicitly labelled cross-unit exploration. Keep the existing JSON-safe topic handoff. Practice must be a different eligible item; never submit the face-up example itself for a score. Until the aligned-item selector contract is implemented, avoid labels such as Try a similar question or Practice this exact lesson that promise more than current serving guarantees.

Replace batch-exhaustion copy with **You've reached the end of this practice set.** If all fetched items were filtered as answered, say **No unanswered questions were found in this set**, not You've answered every question for this lesson. Do not turn a transient load failure into a completion state.

Include the already-decided light pause after **three successfully graded attempts in the current visit**: **3 answers submitted. Want to keep going?** Continue is primary; the hub is secondary. Show it once per component mount (reload resets it), keep current feedback visible, and do not interrupt an in-flight grade. Retries/idempotent responses count once; skipped questions and example views do not count. Omit the unified recommendation's 'enough to start recommending' line entirely in this slice: recommendation eligibility excludes coached/retry attempts and requires at least two distinct items. The pause is a stopping invitation, not an eligibility announcement. This is a small inline pause, not a new summary screen or analytics project.

### D. Answer visibility and unavailable controls

- Open Hand stays face-up, with existing answer/rationales or supported rubric visible immediately; nothing the student does there is graded.
- Practice keeps answers, correctness and grading feedback unrevealed until successful submission. On the **first practice question of a visit** (index 0 of the first set after the practice screen mounts), existing aids open on the first click without the confirmation step. In this slice, 'session' in the DECISION-0100 amendment means the student's visit, not the stored learning-session row. Opening an aid remains optional, uses the same assistance receipt/event path, and still records guided/coached work. Every later question in the visit, including the first question of each later set, keeps the existing gate. A reload starts a new visit; that is accepted because the gate is a consent step, not a scoring boundary, and the attempt is recorded as guided either way. No session-ID or attempt-history read is added for this. Preserve optional scoring-help access and assistance recording. The earlier suggestion to hide the rubric must not accidentally remove the already-governed optional rubric-preview aid or reveal it automatically.
- Hide unavailable comparison tabs, missing-equation sections and nonfunctional export actions **if present in the real app**. Do not implement controls merely because they appear in the HTML reference.
- Keep existing working Deep Dive, reference, copy and BYOQ entry points. No new Full credit/Common mistake/Vague answers, Google Docs/PDF export, equations or study tips.

### E. Stopping and returning without a persistence rebuild

Keep the existing hub link as the stop action, labelled **Return to student hub**. Do not introduce Save and stop or an End session label that implies a server session was closed when it was not.

For practice show concise factual copy near the response/action area: **Submitted answers are saved. Unsubmitted work isn't saved when you leave.** Preserve the existing discard confirmation and in-flight navigation block for hub, topic and subject changes. Open Hand does not need a fictitious saved-work message.

Remove the redundant format-only **Resume session** hub button. Practice on my own is the direct return action; its existing session-start helper may reuse a session under the current rules. Do not relabel the topic-less resume URL as a meaningful continuation. Preserve topic context on the ordinary hub entry where known. Exact lesson/phase/input/queue restoration remains deferred; returning may rebuild the queue and unsubmitted input is not recovered. Preserve FRQ reachability with a quiet **Practice FRQs** link under Practice on my own for subjects with published FRQ practice, carrying the same topic context. Reuse existing availability information/query; no new backend contract. Retire the obsolete `src/lib/__tests__/home-resume-secondary.test.ts` assertion in the same change and verify the replacement FRQ entry.

## 4. Implementation sequence and likely touchpoints

1. Confirm the current Lovable head, actual hub entry components, MCQ/FRQ route wiring, existing assistance-event path, and displayable taxonomy fields. Record reachable versus fixture-only screens.
2. Change shared question chrome and hub/action labels. Add truthful practice progress from each live container to the shared header/nav.
3. Add the unit-scoped Open Hand remaining count and explicit next-topic/cross-unit labels, preserving the selector, existing cache, availability and entitlement checks. Increase the practice fetch to the supported cap and slice it into sets.
4. Deliver first-question ungated aids through the existing event path; update finish notices, three-attempt inline pause and stop/return wording. Hide unavailable controls only where they actually exist.
5. Validate in Preview, record evidence and deviations, then follow the existing release process. This proposed plan does not grant Production publication.

Likely files: the baseline files above, plus actual hub entry components (`HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `use-practice-entry.ts`) and live FRQ session helpers if needed for queue ownership. Verify those current files before editing. Use a small progress prop/helper shared by reachable screens; do not refactor the full plate system. Prefer a frontend-only change with no new dependency, migration, RPC, local-storage schema, content mutation or grading contract.

## 5. Acceptance and QA

| Check | Expected result |
| --- | --- |
| New student enters from hub | Recognizes Learn from a question versus direct Practice; example is optional. |
| Open Hand entry | Topic/title and activity clear; authored answer visible; no graded attempt created. |
| Example traversal | Accurate count of later available examples in current unit; next topic named; unit boundary explicit; no subject-wide assignment implied. |
| Practice sets / returning after first ten | Fetch cap forwarded; answered first ten excluded; later available items reachable through sets of up to ten; N reflects current set; Next set only when more fetched items remain. |
| Skip / excluded item / retry | Position/count stays accurate; skip is not submission; retries do not inflate graded count. |
| Third successful grade | Once per mount; Continue primary; no recommendation claim; retry deduplicated and skipped/example items excluded. |
| First-question aids | First question of the visit opens an aid on one click and records its real event; question 2 onward and first questions of later sets show the existing gate. Reload is a new visit. |
| Practice before/after submit, MCQ and reachable FRQ | Key unrevealed before submit; optional aids behave as governed; real assistance events preserved; feedback remains readable after submit. |
| Example → practice with numeric-looking topic such as 1.10 | Topic string survives; scored item is not the exposed example; no stronger alignment claim than the selector supports. |
| Stop with unsent response / grading in flight | Existing discard confirmation / in-flight block remains; no silent loss or false save promise. |
| Return from hub or browser reload | Label and copy match actual restoration; no claim that local queue, example position or draft was recovered. |
| Empty batch / missing guide / availability failure | Specific honest state; no fabricated total, bank-exhaustion or mastery claim; usable hub/practice/retry exit. |
| Desktop and narrow phone width | Breadcrumb, activity, count and action readable without horizontal overflow; existing responsive behavior retained. |

Run existing project typecheck, build and relevant tests. Add focused tests for set slicing and returning beyond the first ten, progress under skip/removal, unit remaining-count calculation, first-question-of-visit aid behavior, third-grade deduplication and preserved topic handoff; avoid tests that only assert changed prose. Use controlled Preview accounts and record source versus observed behavior separately.

For comprehension, give a student the neutral task of using a recently covered lesson for a few minutes. Before they act, ask what activity they expect; later ask how much remains, what happens if they leave, and where they would return. Record misunderstanding and hesitation; do not claim measured learning gains from this small usability check.

## 6. Explicitly deferred

Pane swap/rebuild; full four-door hub redesign; new content or answer exemplars; content repair; lesson-aligned selector/backend work; new live FRQ Open Hand content; revise-and-rescore; exact/cross-device resume; draft saving; session-close/idle lifecycle; new recap screens; saved-notes shelf and new exports (explicit partial delivery of DECISION-0100, not silently omitted); server-side answered-item exclusion/pagination beyond 50; timer estimates; new mastery/analytics rules; BYOQ redesign. Preserve existing functional entry points and boundaries.

The regression mockup still asks for association/slope while its rubric awards influence, and uses a numeric slope without sufficient displayed givens. Record those as design-fixture/content issues; do not manufacture replacements or treat the mockup as production content.

## 7. Fable review disposition — 2026-10-07

Review: [PR #369 comment](https://github.com/david-bloom/Cramapple/pull/369#issuecomment-6051091678). Final re-review: [Fable comment](https://github.com/david-bloom/Cramapple/pull/369#issuecomment-6051227020), checking revision `85fe9f62`. Edits 1–3 and optional edit 4 incorporated; shorter purpose sentence selected. David's subsequent explicit instruction to finalize and execute authorizes the finalized slice.

| Finding | Disposition |
| --- | --- |
| Missing hub purpose/four routes/first-question ungated aids | Include compact existing-content entries and purpose; restore already-decided aid behavior. Explicitly defer saved-notes store and new exports. |
| Deterministic first-ten wall | Fetch supported cap and expose filtered results in sets of ten. Acknowledge remaining cap limitation. |
| Subject-wide example boundary | Replace with unit remaining-count using existing cache; preserve selector; label unit crossing explicitly. |
| Redundant topic-less Resume | Remove; use ordinary contextual practice entry. |
| Recommendation claim and visit ambiguity | Omit claim entirely; pause once per mount. First-question aid policy is visit scoped as clarified by final review. |
| Open Hand masthead conflict | Preserve masthead per DECISION-0100; use Learn from a question for the door and explanatory copy. |
| Optional copy/cache suggestions | Shorten practice count, retain Try one on your own, correct hero lede, explicitly reuse cached teaching topics. |

**Final disposition:** Accepted under David's instruction to finalize and execute after the final review: first-question = visit; compact four doors; cap-50 practice fetch in sets of ten; unit-only Open Hand count; Resume removed with quiet contextual FRQ entry retained; masthead Open Hand preserved; shorter purpose sentence selected. Partial notes save/export delivery is explicitly deferred against DECISION-0100. Implementation proceeds in Preview; Production publication is separate.
