# Student Session Clarity — Minimal Execution Plan

**Status:** Proposed — ready for Fable's second opinion; implementation not started
**Date:** 2026-10-07 (America/New_York)
**Product Owner:** David Bloom
**Prepared by:** Codex
**Documentation tier:** Micro; proposed implementation tier: Standard, subject to conductor classification
**Related work:** TASK-0048 / TASK-0052; DECISION-0100 and its amendment
**Branch:** `codex/new-user-experience-second-pass`
**PR:** #369
**Next owner:** Fable, for independent review
**Next required action:** Review this bounded plan, return necessary corrections, then record the agreed implementation slice before dispatching it to Lovable.

## 1. Outcome and scope decision

Make the smallest changes that let a student answer four questions: What am I studying? What am I doing here? What should I do next, and how much remains? What happens if I stop and return?

Cramapple helps students lock in lessons through targeted information and practice directed toward class tests and the AP exam. Learning from an answered question is recommended, never required. Direct practice, existing supplemental notes and help understanding a student's own question remain legitimate paths.

David's latest direction is to defer a larger rebuild and create no new educational content. This plan is a deliberately limited implementation slice of the [unified recommendation](STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md), not a replacement for it. Deferred recommendations remain deferred, not rejected. No application edits, deployment, migrations or account changes are authorized by writing this proposed plan.

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

- Student-facing Open Hand label becomes **Learn from a question**. Keep internal identifiers, routes, API names and scoring exclusions unchanged.
- Practice label stays **Practice**. Avoid describing aided practice as independent after a student opens help.
- Display the delivered question's subject, unit when known, topic code and readable title. Existing taxonomy/guide fields only; no generated lesson synopsis. If a field is absent, omit it rather than borrowing another lesson's title.
- On Open Hand show the agreed interface sentence: **See how a test-style question is asked and scored.** Keep **Your work isn't scored here** clear. For MCQs explain answer/rationale rather than implying an FRQ rubric exists.
- Add one short reading cue using existing material: **Read the question, then compare the answer with its explanation.** This is interface guidance, not a new worked solution.
- At the existing hub start-action location, use Learn from a question and its subline, and expose **Practice on my own** alongside it when practice is available. No new hub structure, four-card redesign, lesson picker or notes shelf. Do not require an example visit first.

### B. Visible, truthful progress

**Practice:** use the queue owned by the current user and pack. In the existing navigation/header show **Question X of N in this set · R more after this**, where X = index + 1, N = current queue length and R = N − X. Keep X unchanged during submission and feedback; advance only on Next or Skip. Skipping advances position but does not count as a graded answer. If a question is removed after an access/exclusion error, recalculate accurately without a stale total. Hide the count during loading/error when the owned queue is unknown.

The scope label **in this set** is required: exhausting a fetched batch is not proof that the student exhausted the lesson or mastered it. Show actual question context when the batch crosses topics; do not imply the selected target describes every item.

**Open Hand:** use a small, finite browse set derived from the existing taxonomy order and available teaching-topic list. On entry, load the already-existing `get_open_hand_teaching_topics` list, intersect it with existing traversal candidates, include the current eligible example, and hold that ordered list in page-local state. Fetch individual examples through the existing teaching RPC only when needed. Show **Example X of N in this browse set · R more after this**. Do not create scored attempts or a learning session for this counter. Do not wrap to previously viewed examples on reaching the end.

This is the one bounded behavioral addition, needed to meet David's request that the experience not feel like a mystery. The set may cross topics: name the destination on the next action, e.g. **Next example: [existing topic title]**, before navigation. Do not claim N examples exist within the current lesson. Reset the local set on a new subject/topic entry; do not promise that it survives closing the page. If the availability list fails, keep the current example usable, omit the fabricated denominator, and offer practice or the hub plus retry; do not quietly return to unbounded browsing.

**No timer.** Question/example counts supply the requested boundary without unmeasured duration estimates. Existing cumulative questions-seen data is distinct; make this-set progress primary and avoid two competing counters in the same strip.

### C. Explicit next actions and bounded finishes

| State | Primary action | Other actions |
| --- | --- | --- |
| Open Hand, content available | **Try one myself** | **Next example: [topic]**; existing notes/BYOQ/hub access |
| Practice, before submission | **Submit answer** | Existing help and skip behavior |
| Practice, successful grading | **Next question** | Existing feedback/help access |
| Practice, grading error | **Try submitting again** | Existing guarded skip; preserve response |
| Last example in browse set | **Try one myself** | **Return to student hub**; no misleading Next |
| Last practice question graded/skipped | **Return to student hub** | Existing supported topic/example links; no automatic infinite continuation |

Keep the existing JSON-safe topic handoff. Practice must be a different eligible item; never submit the face-up example itself for a score. Until the aligned-item selector contract is implemented, avoid labels such as Try a similar question or Practice this exact lesson that promise more than current serving guarantees.

Replace batch-exhaustion copy with **You've reached the end of this practice set.** If all fetched items were filtered as answered, say **No unanswered questions were found in this set**, not You've answered every question for this lesson. Do not turn a transient load failure into a completion state.

Include the already-decided light pause after **three successfully graded attempts in the current visit**: **3 answers submitted. Want to keep going?** Continue is primary; the hub is secondary. Show it once per visit, keep current feedback visible, and do not interrupt an in-flight grade. Retries/idempotent responses count once; skipped questions and example views do not count. Do not claim recommendations are unlocked unless the real eligibility rule, including distinct-question requirements, is satisfied. This is a small inline pause, not a new summary screen or analytics project.

### D. Answer visibility and unavailable controls

- Open Hand stays face-up, with existing answer/rationales or supported rubric visible immediately; nothing the student does there is graded.
- Practice keeps answers, correctness and grading feedback unrevealed until successful submission. Preserve existing optional scoring-help/hint access and its assistance recording. The earlier suggestion to hide the rubric must not accidentally remove the already-governed optional rubric-preview aid or reveal it automatically.
- Hide unavailable comparison tabs, missing-equation sections and nonfunctional export actions **if present in the real app**. Do not implement controls merely because they appear in the HTML reference.
- Keep existing working Deep Dive, reference, copy and BYOQ entry points. No new Full credit/Common mistake/Vague answers, Google Docs/PDF export, equations or study tips.

### E. Stopping and returning without a persistence rebuild

Keep the existing hub link as the stop action, labelled **Return to student hub**. Do not introduce Save and stop or an End session label that implies a server session was closed when it was not.

For practice show concise factual copy near the response/action area: **Submitted answers are saved. Unsubmitted work isn't saved when you leave.** Preserve the existing discard confirmation and in-flight navigation block for hub, topic and subject changes. Open Hand does not need a fictitious saved-work message.

Where the hub currently promises Resume session without exact restoration, relabel it **Return to practice**. It may reopen practice using the existing stored subject/position, but must not promise the last item, draft or phase. Carry a topic only if that destination context is genuinely known; do not present class position as a saved practice checkpoint. This slice makes existing return behavior honest; exact lesson/phase/input/queue restoration remains deferred.

## 4. Implementation sequence and likely touchpoints

1. Confirm the current Lovable head, actual hub entry components, MCQ/FRQ route wiring, existing assistance-event path, and displayable taxonomy fields. Record reachable versus fixture-only screens.
2. Change shared question chrome and hub/action labels. Add truthful practice progress from each live container to the shared header/nav.
3. Add the finite page-local Open Hand browse list and explicit next-topic label, preserving existing availability and entitlement checks.
4. Update existing finish notices, three-attempt inline pause and stop/return wording. Hide unavailable controls only where they actually exist.
5. Validate in Preview, record evidence and deviations, then follow the existing release process. This proposed plan does not grant Production publication.

Likely files: the baseline files above, plus actual hub entry components (`HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `use-practice-entry.ts`) and live FRQ session helpers if needed for queue ownership. Verify those current files before editing. Use a small progress prop/helper shared by reachable screens; do not refactor the full plate system. Prefer a frontend-only change with no new dependency, migration, RPC, local-storage schema, content mutation or grading contract.

## 5. Acceptance and QA

| Check | Expected result |
| --- | --- |
| New student enters from hub | Recognizes Learn from a question versus direct Practice; example is optional. |
| Open Hand entry | Topic/title and activity clear; authored answer visible; no graded attempt created. |
| Example traversal | Accurate finite count; next topic named before crossing; no loop; final example has a clear endpoint. |
| Practice queue of 1, 3 or fewer-than-fetch-limit items | N reflects filtered queue; current position survives submit/feedback; last item says no more after this. |
| Skip / excluded item / retry | Position/count stays accurate; skip is not submission; retries do not inflate graded count. |
| Third successful grade | One optional inline pause; Continue primary; no recommendation claim based on count alone. |
| Practice before/after submit, MCQ and reachable FRQ | Key unrevealed before submit; optional aids behave as governed; real assistance events preserved; feedback remains readable after submit. |
| Example → practice with numeric-looking topic such as 1.10 | Topic string survives; scored item is not the exposed example; no stronger alignment claim than the selector supports. |
| Stop with unsent response / grading in flight | Existing discard confirmation / in-flight block remains; no silent loss or false save promise. |
| Return from hub or browser reload | Label and copy match actual restoration; no claim that local queue, example position or draft was recovered. |
| Empty batch / missing guide / availability failure | Specific honest state; no fabricated total, bank-exhaustion or mastery claim; usable hub/practice/retry exit. |
| Desktop and narrow phone width | Breadcrumb, activity, count and action readable without horizontal overflow; existing responsive behavior retained. |

Run existing project typecheck, build and relevant tests. Add focused tests for progress under skip/removal, finite browse traversal, third-grade deduplication and preserved topic handoff; avoid tests that only assert changed prose. Use controlled Preview accounts and record source versus observed behavior separately.

For comprehension, give a student the neutral task of using a recently covered lesson for a few minutes. Before they act, ask what activity they expect; later ask how much remains, what happens if they leave, and where they would return. Record misunderstanding and hesitation; do not claim measured learning gains from this small usability check.

## 6. Explicitly deferred

Pane swap/rebuild; full four-door hub redesign; new content or answer exemplars; content repair; lesson-aligned selector/backend work; new live FRQ Open Hand content; revise-and-rescore; exact/cross-device resume; draft saving; session-close/idle lifecycle; new recap screens; saved-notes shelf and new exports; timer estimates; new mastery/analytics rules; BYOQ redesign. Preserve existing functional entry points and boundaries.

The regression mockup still asks for association/slope while its rubric awards influence, and uses a numeric slope without sufficient displayed givens. Record those as design-fixture/content issues; do not manufacture replacements or treat the mockup as production content.

## 7. Fable review request

Review for the smallest effective scope, not the ideal future product. Return **blocking corrections**, **optional improvements**, and **defer** separately.

1. Is the finite local Open Hand browse list the smallest honest way to satisfy the requested remaining-count boundary, given today's cross-topic traversal? Can it be smaller without misleading the student?
2. Does practice progress clearly distinguish current position, successful submissions, skips, and remaining fetched items?
3. Are the light three-attempt pause and truthful Return to practice label consistent with DECISION-0100 without pulling in persistence or recommendation work?
4. Does the plan preserve face-up learning, optional practice assistance, scoring exclusions and the newly working assistance events?
5. Are any proposed changes unnecessary for removing student confusion, or missing a real source dependency?

No implementation agent has been dispatched. Fable's second opinion is the next action; application execution follows the agreed reviewed slice.
