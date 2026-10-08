# Student Hub — Independent Challenge QA

STATUS: EVIDENCE RECORD — findings H1–H15 stand; the recommendation sections are consolidated with Fable's assessment in `QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md`, which governs where the two differ (Sol's review of PR #381/#382, 2026-10-08)
DATE: 2026-10-08
AUTHOR: Codex
OWNER: David Bloom
SCOPE: New-student comprehension, route clarity, content delivery, state correctness, accessibility and rendering readiness of /home.
NEXT OWNER: Frontend/backend implementation conductor; independent QA after fixes.
NEXT ACTION: Review priorities and proposed experience, then implement in separately scoped work. Complete authenticated viewport and student validation before acceptance.

## Assessment

The hub has improved: four study doors are visible, the recommended question-learning route is optional, lesson notes open directly, clipboard success/failure is visible, and personalized accounts now use Stage B instead of the legacy mode bar. Those are useful changes.

It still does not meet the requested experience. A new student must understand a position form before seeing much explanation of how Cramapple helps. They cannot confidently start if they do not know their class position. Several promises exceed the delivered behavior, and state/data defects can make the displayed lesson, activity and recommendation status misleading.

The priority is a dependable lesson choice and truthful content delivery, followed by concise first-use guidance. More dashboard information alone will not solve this.

This is documentation QA, not an implementation, publish, merge recommendation, final Pass or task closure. All design changes below are proposals unless an existing decision already authorizes them.

## Checkpoint, method and limits

- App source inspected through Lovable project `56cae479-f7c9-4988-b536-56538c38ee4e`, commit `d5adcbc65f19877a0d95434c0899014fa95b5499`. Exact deployed frontend SHA is not proven.
- Canonical records read from Cramapple main `4913aa7291ad7e69af35dc267d2db172169a489c`: architecture/design one-pager, docs index, TASK-0048, first-session assessments, unified recommendation and minimal clarity plan. Later DECISION-0100 amendment/interim routing governs over the older TASK-0048 personalized-layout requirement.
- Inspected mounted HomeV2, Stage A/B, HomeWelcomeBanner, HomeStudyActions, active-subject, home.functions, home-snapshot, topic-content, notes overlay, entry resolver and relevant session/content adapters and CSS.
- Executed the actual pure `home-snapshot.ts` functions with Node TypeScript stripping for other-subject attempts, guided-only work and three attempts on one item. Results below are helper checks, not authenticated server/browser reproduction.
- Signed-out published /home redirects to the marketing login; preview requires Lovable login. No usable authenticated session was available. Signed-in screenshots, responsive rendering, keyboard walkthrough, console/network behavior and complete student journeys remain unverified.
- Deployed read-only content/delivery evidence established during the same session is recorded in PR #380's independent challenge report. No Production writes or student impersonation were used. Findings from that report are dependencies, not freshly observed signed-in hub failures.
- No new usability study was run. Comprehension findings are expert judgments with concrete source evidence; no invented student quotations, completion times or learning gains.

## Independent findings

P1 = fix before accepting the core new-student experience. P2 = material usability/correctness improvement. “Source-confirmed” means the described code behavior is present; it does not mean every condition has been reproduced on the deployed page.

### H1 — Current-subject stage uses other-subject evidence (P1, source-confirmed + executable helper check)

`loadStudentHome` fetches the latest 100 attempts by user, without active-pack filtering, then calls `summarizeEvidence(attempts, completedSessionCount)`. The 25 sessions used for completedSessionCount are also unscoped. Independence is scoped later, but stage selection and “Based on your N graded attempts” are not.

Actual helper result: three independent graded attempts, all on “other” pack → personalized, evidenceCount 3, canRecommend true. Filtering them to “current” first → new, evidenceCount 0. A new subject can therefore show returning/personalized copy and trend eligibility influenced by another subject. A busy second subject can also displace current-subject history from the capped query.

**Fix:** scope database attempt/session reads before limits; apply one explicit version policy to stage, counts, independence and trends. Do not infer that null pack IDs belong to the current subject without a documented legacy rule. Test switching to an untouched subject and back.

### H2 — Saved Stage A position clears while taxonomy is still loading (P1, source-confirmed)

Stage A initializes local unit/topic from the saved snapshot. Its effect clears the selection if the unit is absent from `units`, including the initial empty array before the asynchronous taxonomy response. Its topic effect similarly clears against initially empty topics. A zero-evidence returning student with saved position can see saved orientation alongside blank editing controls.

Stage B guards the empty-unit case, but both stages initialize local controls only at mount, without explicit synchronization to a changed saved snapshot/subject. Stage B also lacks a corresponding validity check for a retained topic.

**Fix:** distinguish loading from successfully loaded invalid taxonomy. Synchronize controls on subject/confirmed-position changes while preserving intentional drafts. Test cold load, refetch, subject switch with overlapping unit numbers and invalid stored topic.

### H3 — Choosing a visible lesson does not change the lesson opened (P1, source-confirmed)

The selects change local draft state; every study action reads the saved `snapshot.coursePosition`. Before saving, a student can choose a new lesson and open the old one without a clear “unsaved” cue. The save mutation invalidates the snapshot query without awaiting completion; during refetch the old snapshot remains actionable.

Stage A's unit-only payload omits topicCode, while the server deliberately preserves the stored topic when omitted. Changing the unit and confirming without a topic can retain a topic from the former unit. Stage B sends explicit null and avoids that particular omission.

**Fix:** one consistent selection contract. Either persist the chosen lesson before enabling its doors, or make “Apply lesson” explicit and display the active saved lesson beside the doors. Disable/sequence actions through save/refetch. Clear old topic on unit change and validate unit-topic membership server-side.

### H4 — “Not sure” students still have no useful study start (P1, source-confirmed)

Most doors require a saved unit. “Pick the unit and topic your teacher is on. Everything else follows from it” supplies no alternative for a new student, an independent learner or someone who recognizes a lesson name but not a unit number. Bring a question works, but is a different goal.

**Fix:** recognizable lesson titles with Browse lessons and “Not sure? Try a starting lesson.” Choose only an available lesson and distinguish that study choice from confirming the teacher's position. Do not revive the cut diagnostic or invent a class-position estimate. This completes the existing unified recommendation rather than creating an assessment requirement.

### H5 — The page explains uncertainty more than learning (P2, expert assessment grounded in source)

Stage A leads with setup, “nothing to recommend honestly” and “the whole page starts working.” The value sentence exists inside HomeStudyActions, after the setup copy. “What happens next” explains an evidence threshold rather than what a student will do or learn.

**Fix:** put purpose directly under the greeting, then explain the process in one compact paragraph. Make starting useful immediately. Keep evidence caveats near the specific metric they qualify; remove repeated negative framing. The 2-minute setup label is unmeasured and should be removed or validated.

### H6 — Recommendation thresholds promise capability that is not delivered (P1, source-confirmed)

Stage B says Cramapple gets more specific after three graded attempts, omitting the two-distinct-item requirement. The actual eligibility also excludes coached attempts and retries. Actual helper check: three attempts on one item → building_signal, canRecommend false. Guided-only graded work → new with evidenceCount zero.

Even when canRecommend is true, `buildStarterTarget` remains first_session and the hero explicitly says recommendations are not yet based on performance. Crossing an evidence threshold is not shipping a recommendation engine.

**Fix:** remove “gets more specific after 3” until specific recommendations exist. Show “Your lesson is based on what you chose” now. When personalization ships, describe qualifying evidence truthfully. Do not tell students that a guided learning visit was “no work yet.” Separate activity from evidence eligibility.

### H7 — Evidence/curriculum mapping cannot support all its labels (P2, source-confirmed)

The server maps every attempt to `unitId: null` and `isRetry: false`, despite importing unit point-capture and retry-sensitive computations. Unit pointCapture cannot resolve from these mapped rows; retry exclusion is not actually established. This is separate from the cross-subject defect.

Stage A says “Cells fill in as you answer questions,” but its topic cells are permanently empty decorative elements and the current Stage B board renders unit cards, not filled topic cells.

**Fix:** map versioned item taxonomy and genuine attempt lineage before showing unit evidence. Otherwise remove unsupported progress promises and display a plain lesson browser. Keep coached work visible as activity without labelling it independent mastery.

### H8 — Route availability is not end-to-end readiness (P1, source-confirmed dependencies)

HomeStudyActions shows Practice FRQs when a published query is ready. PR #380's independent checks found that seven subjects' FRQ rows are dropped by the live adapter. Learn's non-plate fallback always navigates to open-hand-mcq instead of respecting the resolver's fallback route. Topic bias does not guarantee an aligned item after the server cap; MCQ practice can omit required stimulus text.

**Fix:** eligibility must mean renderable, answerable content for this subject/lesson/format, not a raw published row. Respect resolver results. Preserve stimuli. When selected-lesson content is unavailable, offer a named available alternative and ask the student to choose; never silently imply it is the selected lesson.

See `QA_OPEN_HAND_PRACTICE_CHALLENGE_2026_10_08.md` in PR #380 for detailed content evidence and serving acceptance. This new PR does not duplicate that report or imply those fixes have landed.

### H9 — Supporting shelves have information but no usable next step (P2, source-confirmed)

Stage A explainer cards and Stage B Deep dives are static articles containing just the first available guide field. Worth revisiting is also a static list with no action. Queue titles are resolved from saved-unit guides only; other units fall back to “Topic x.y.” Two sections repeat “Next best action.”

**Fix:** make available guide cards open full notes for the named lesson; label excerpts as previews. Make revisit rows actionable and resolve titles from canonical taxonomy across units. One “Suggested next” area is enough; no recommendation label on an inert list.

### H10 — Queue failure is presented as “Nothing due” (P2, source-confirmed)

`loadStartQueue` returns null for RPC errors, malformed/unresolvable rows and genuinely empty results. Stage B renders “Nothing due right now” for all of them.

**Fix:** preserve empty, unavailable and error states. A failed optional section must not take down the hub, but should say “Review suggestions couldn't load” with Retry while other study routes remain usable.

### H11 — Notes overlay lacks modal keyboard/accessibility behavior (P1, source-confirmed)

The standalone fixed overlay has no dialog role, accessible dialog name, aria-modal, focus entry/trap/return or background inertness. Escape support exists. Keyboard focus can remain behind the visible overlay. Copy status changes button text but has no explicit live status. “Copy deep dive” also conflicts with the hub's “Lesson notes.”

**Fix:** use the established accessible dialog primitive, preserve scroll and focus, announce copy success/failure, and call the action “Copy notes.” Test long notes, narrow screens, zoom, Escape and clipboard denial. Copy must remain an export, never be described as saved in-app.

### H12 — Loading/error recovery is incomplete (P2, source-confirmed)

The whole hub has an explicit error and Try again button, which is good. Taxonomy and notes subsections report errors but offer no direct retry. Learn resets opening in finally but has no error display/catch for a rejected resolution/navigation path. FRQ pending/error can silently remove its door instead of explaining availability.

**Fix:** section-specific recovery, a visible Learn failure message, and stable honest route states. Preserve chosen lesson on failure. Do not make students reload or guess whether a missing door is loading, unavailable or broken.

### H13 — Subject setup and welcome states can confuse or stall (P2, source-confirmed risks)

A sole available subject is auto-selected only once; if that save fails, the UI shows an error but no subject button/retry. Multiple-subject buttons remain visually enabled during persistence although a ref silently ignores further clicks. The requested-subject welcome can say “Pick a unit” while the page still asks “Which subject first?” It is dismissible, but supplies no process explanation.

**Fix:** show saving state, enable explicit retry after failed auto-selection, and derive onboarding instructions from the actual current step. Treat the welcome as reassurance, not a competing instruction.

### H14 — Activity measures still need careful wording (P2, source-confirmed limitation)

The old 607-minute issue from the unified review has been mitigated: minutes now run from session start to last graded attempt, capped at 60 minutes per session. That is an improvement, not a measurement of active study time; idle gaps can still count. A “questions” count is graded attempt rows rather than necessarily distinct questions. The latest 100-row cap can truncate busy-week activity.

**Fix:** use accurate labels/aggregation and an explicit time-estimate rule. Do not repeat the older wall-clock defect as unchanged. Assistance correctness remains an independent validation dependency from PR #380; a percentage alone is not proof that aid events were recorded.

### H15 — Rendering readiness is incomplete (acceptance blocker, not a claimed visual failure)

CSS contains desktop/mobile breakpoints, constrained grids and wrapping action labels. This is positive source evidence, not proof that the full integrated hub renders correctly. New button stacks change layout density; long names and the full-screen notes header need actual checking.

**Required:** authenticated desktop and 320/390/768px screenshots, 200% zoom, long subject/topic titles, loading/error states and keyboard/screen-reader walkthrough. Verify no overflow, clipped controls, overlapping overlays, console errors or failed necessary requests. No visual Pass is given here.

## Comparison with Fable/Claude

Compared against the original first-session UX assessment and its owner-governed unified recommendation, not an assumed new Fable hub walkthrough. Both older assessments used a different source checkpoint; resolved items are credited.

| Topic | Judgment | Challenge / best next solution |
| --- | --- | --- |
| Four clear doors; question-learning recommended and optional | Agree | Keep the model. Add one short explanation per door and truthful availability. |
| Purpose before setup; reduce evidence-heavy wording | Agree | Purpose line exists now but is buried. Move it and explain what to do with feedback. |
| Numbered compulsory-looking process strip | Agree with its withdrawal | Describe the learning process in prose; do not number/gate the student's choices. |
| Unsure fallback and recognizable lesson names | Agree; still incomplete | Browse actual available lessons; do not equate a sample lesson with teacher position. |
| Notes access and copy confirmation | Same problem, partially resolved | Direct notes and visible clipboard result now exist. Fix modal behavior and make shelf previews useful; durable saved-notes work is optional and separate. |
| Three-attempt pause | Agree as a stopping invitation | Disagree with “enough to start recommending / every extra answer makes it sharper” while personalization is unbuilt and qualifying evidence differs. Celebrate actual work and feedback. |
| First-question help without guilt | Agree | State the assistance consequence plainly and validate recording before trusting hub evidence. |
| Return continuity | Agree with truthful limits | Exact restoration requires separate behavior. Temporary first-use help does not require a persistent tutorial or mandatory resume feature. |
| Decorative exam arc, duplicate recommendation headings, raw topic fallbacks | Same remaining problems | Plain countdown; one suggested-next area; taxonomy titles and actionable review rows. |
| Pulse minutes | Older failure partly addressed | Current capped estimate still needs accurate wording and idle-gap validation. |
| Overall acceptance | No basis for “all fixed” | H1–H3 and data/content contracts require fixes; authenticated rendering and comprehension tests remain open. |

## Proposed student experience

A compact first-use panel under the subject greeting, dismissible after use and reopenable from “How Cramapple works.” Returning visits can keep just the purpose/route descriptions. This need not become a persistent tutorial across sessions.

Suggested copy:

> **Get ready for class tests and the AP exam.**
> Choose a lesson. Cramapple helps you understand how questions work, practise your own answers, and use feedback to improve.
>
> **What did you cover in class most recently?**
> Choose a lesson · Browse lessons · Not sure? Try a starting lesson.
>
> New to this lesson? Start with **Learn from a question**. Read the reasoning, then try a question yourself when you're ready. You can also go straight to practice, read notes, or bring your own question.

| Door | Student-facing explanation | Required delivered behavior |
| --- | --- | --- |
| Learn from a question | See an answered question and understand why the answer works. Recommended if this lesson is new to you. | Correct selected lesson, complete stimulus and reasoning; optional own-attempt handoff. |
| Practice on my own | Answer questions, check feedback, and work on what you missed. | Renderable selected-lesson content or explicit chosen alternative; useful feedback and a pause. |
| Read lesson notes | Review the key ideas. Copy the notes to keep them. | Full selected-lesson notes; accessible overlay and honest copy state. |
| Bring a question | Get help understanding your own question. Cramapple guides you without giving you the answer. | Real intake flow; validate this boundary through hints, rationales and exports. |

Practice format labels should be plain: “Multiple-choice questions” and, where deliverable, “Written-response questions (FRQs).” Explain an acronym before using it as a primary choice.

Use one active lesson heading above the doors: “Studying: [lesson title] · Change.” Teacher position can be separate secondary context if product needs it. An optional study choice must not silently overwrite the student's confirmed class position.

After practice, a useful finish names the lesson, actual questions/attempts, feedback and next choice. Suggested line: “Review the explanation for anything you missed. Try another question when you're ready.” No automatic claim of mastery, guaranteed exam success or newly available personalization. Viewing an example or reading notes is a valid visit; it should not result in “no work yet” scolding.

## Recommended implementation order

1. **Reliability:** H1–H3, H7–H8. Scope data correctly, make active lesson consistent, clear invalid topic state and honor end-to-end content readiness.
2. **First-use clarity:** H4–H6, H9, H13. Purpose first, recognizable lesson chooser, unsure route, four differentiated doors, useful preview/revisit actions.
3. **Accessible recovery:** H10–H12, H14. Honest optional-data states, retry paths, accessible notes and accurate activity labels.
4. **Independent acceptance:** H15 plus the journeys below. Keep implementation review separate from learning/comprehension validation.

These can be reviewable slices; the new PR contains findings only. No schema change, saved-notes store, estimator or redesign is silently authorized by this document.

## Acceptance and defect checks

| Scenario | Expected result |
| --- | --- |
| No subject; one/multiple subjects; subject save fails | Clear current step, visible save/retry, no contradictory instruction. |
| Zero attempts, no position, uncertain student | Can explain value and begin an available lesson without guessing class position. |
| Zero attempts, saved position, cold taxonomy load | Saved controls survive loading; orientation and active lesson agree. |
| Change lesson, save pending, save failure, refetch | No old lesson opens under a new displayed choice; recoverable state. |
| Unit change with no topic; subject switch | No stale topic, no other-subject counts or activity claims. |
| Guided-only, retries, three attempts on one item | Activity acknowledged; evidence eligibility and stage accurate; no false personalization. |
| Every door, every supported subject, sparse/empty lesson | Correct content, format, stimuli and honest alternative; no blank or unanswerable route. |
| Queue/notes/taxonomy load fails | Section-specific unavailable/error state and usable retry; rest of hub works. |
| Notes open/copy/close with keyboard, zoom and long content | Focus managed and restored, background inactive, readable content and announced result. |
| Mobile/desktop/loading and error screenshots | No horizontal overflow, clipped action, overlap or missing required content. |
| Practice pause and hub return | Factual recap and clear optional next step; no unsupported recommendation promise. |
| Help dismissed then reopened | Guidance stays available without crowding routine visits. |

Use neutral tasks with genuinely new students: “You just covered [lesson]. Use this to get ready for a class test”; “You don't know your unit number”; “You want notes”; “You have your own question.” Observe before prompting. Then ask: “What will Cramapple help you do?”, “How are these choices different?”, “What would you do after getting an answer wrong?” Record hesitation, wrong destinations and facilitator help. Observed students should find a useful route unaided and explain its outcome; small samples inform iteration, not universal success claims.

## Source map and handoff

App anchors at the inspected Lovable SHA:
- `src/components/home/HomeV2.tsx`: subject setup, authenticated load/error, mounted stage routing.
- `HomeStageANew.tsx`: draft validity effects, Stage A payload, purpose placement, threshold/curriculum copy and static explainers.
- `HomeStageBBuilding.tsx`: draft controls, stageBCopy, static queue, saved-unit guide title lookup.
- `HomeStudyActions.tsx`: snapshot-based route searches, resolver fallback, FRQ readiness, notes state.
- `HomeWelcomeBanner.tsx`: requested-subject messaging.
- `src/lib/home.functions.ts`: user-wide capped queries, evidence mapping, queue fail-soft state and position upsert.
- `src/lib/home-snapshot.ts`: qualifying evidence, distinct-item thresholds, unit capture, minutes and stage computation.
- `src/components/overlay/DeepDiveOverlay.jsx`, `src/styles.css`: modal behavior and responsive source rules.
- Entry/session/adaptation evidence: PR #380 independent challenge report.

Canonical comparisons:
- [Fable/Claude assessment](../product/NEW_STUDENT_FIRST_SESSION_UX_ASSESSMENT_2026_10_07.md)
- [Unified recommendation](../product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md)
- [Minimal clarity plan](../product/STUDENT_SESSION_CLARITY_MINIMAL_PLAN_2026_10_07.md)
- [Earlier second pass](NEW_USER_FIRST_SEVEN_MINUTES_SECOND_PASS_2026_10_07.md)
- [TASK-0048](../tasks/TASK-0048-HOME-REDESIGN-STAGE-A-B.md)

**Approval state:** authorized QA/documentation proposal only. **Unresolved verification:** authenticated UI/rendering, real comprehension, full route execution, assistance attribution and new fixes. **Next owner/action:** implementation conductor to resolve P1 contracts and propose scoped fixes; QA to rerun the matrix against a named newer checkpoint; David to review product changes and acceptance evidence.
