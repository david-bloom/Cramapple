# New-User Experience: First 5–7 Minutes

**Status:** Evidence record. Its recommendations are consolidated with the parallel Claude assessment in `docs/product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md`, which governs where the two differ (`DECISION-0100` and its 2026-10-07 amendment). Source review, owner-supplied action-trace analysis and alternate-design revision brief complete; timed, implemented-flow and fresh-student validation pending
**Date:** 2026-10-07
**Owner:** Codex / Main Conductor
**Product Owner:** David Bloom
**Tier:** Standard assessment under Lane 1 standing approval
**Branch:** codex/new-user-experience-assessment
**Related:** TASK-0048, TASK-0052, TASK-0060; DECISION-0087, DECISION-0097

## Purpose and owner framing

David's assessment brief: Cramapple helps students lock in each lesson through targeted information and targeted practice. Assess from first landing on Student Home through the next 5–7 minutes, including stopping and returning.

**Owner clarification, 2026-10-07:** the learning is directed toward how a lesson will be questioned on class tests and the AP exam, rather than general subject knowledge. A worked question teaches the reasoning through a concrete question in the form students will encounter. It is an important learning option, not a prerequisite. Students may go directly to independent practice, export Deep Dives as supplemental class notes, or upload their own homework question for help understanding it without Cramapple answering it for them.

This clarification governs the recommendations below. The earlier proposed lesson cycle is a suggested route for students who choose it. Direct practice, notes use and homework understanding are valid goals, not incomplete or failed versions of that route. The brief states intended product behavior; availability and exact behavior of each implementation still require verification.

This records the owner's brief and proposed assessment criteria. It does not amend the product vision or assert that every competitor fits a reference/test dichotomy. No competitive research was performed.

## Preliminary finding

The reviewed implementation contains the right ingredients, but does not consistently explain test-directed lesson learning or help a student choose an appropriate way to use it. Home leads with class-position setup and collecting evidence; the worked-question screen's primary CTA advances to another worked example, while independent practice is secondary. Students must infer why learning through a question is useful and how to move between examples, practice, notes and homework help. The goal is clear choice and continuity, not compulsory completion of one sequence.

The owner-supplied action trace supports this concern: it records another worked question before independent practice, several Home choices, and repeated use of information/help. It shows that the core path is reachable, but does not establish that students understand it. This remains an expert assessment with recorded actions, not a timed first-use student usability test.

## Evidence boundaries

- Canonical bootstrap, workflow, standing approval lanes, architecture/design entry point and index were read from GitHub in this session.
- TASK-0048 records Stage A/B as published on 2026-10-05; signed-in visual QA remains owed.
- Lovable project 56cae479-f7c9-4988-b536-56538c38ee4e was read at exact source commit **64352ecbf26da46b26a235d142fefddf1043d82f**, the latest head returned 2026-10-07. Some changes at this head are documented as preview-only. Publication of this exact head was not verified.
- Direct browser navigation in this session redirected to sign-in. The assessor did not obtain a signed-in visual walkthrough; cloud-browser access was unavailable.
- David supplied a Chrome Recorder JavaScript action export on 2026-10-07. It contains 38 recorded steps at a desktop viewport of 1210 × 1279, including navigation and accessibility-label selectors. It was read as data, not executed or replayed. Authentication fields were excluded from this report; the raw export was not committed.
- The export has no video frames, screenshots, elapsed-time measurements or grading results. A click is evidence of a recorded action, not proof of the rendered outcome, user confusion or task success. Its captured build and account evidence stage were not verified against the reviewed source head.
- No timed student session, grading, lesson completion, departure/re-entry, implemented mobile screen inspection or learning-outcome test was performed. The alternate artifact's desktop/mobile hub artboards were inspected separately; this is design evidence, not implemented-flow validation.
- The assessor created or reset no student account and performed no grading/history/course-position write, production configuration, publication or migration. The supplied trace includes the owner's unit selection and two answer submissions; their resulting stored state was not inspected.
- Existing QA reports are historical evidence with their stated limitations; they are not new tests in this session.

## The journey to assess

The time bands below are proposed observation windows, not measured timings or a promise that every lesson fits seven minutes.

| Window | Student's question | Success criterion | Source assessment |
| --- | --- | --- | --- |
| First 30 seconds | What is this for, and where do I start? | Student understands the test/exam purpose, recognizes learning from a question as an option, and chooses a route that fits their goal | Partial: class-position action is explicit; differentiated method and optional routes are not explained in the reviewed welcome or Stage A hero |
| 30–90 seconds | Which lesson should I work on? | Choose a relevant topic; recover if they do not know their official unit/topic | Partial: taxonomy selects exist, but no visible “not sure” path in Stage A |
| 1–3 minutes | What should I notice in this worked question? | Identify the key reasoning move and a likely mistake without guessing which pane to read | Partial: correct answer/rationales and reference are present; no explicit reading sequence or student task in this live teaching path |
| 3–5 minutes | Can I now do this myself? | Clear primary CTA to an unseen question requiring the same lesson/reasoning | Weak: independent practice is secondary; topic is passed, but the practice client only reorders a server-selected batch |
| 5–7 minutes | What did I learn and what next? | Feedback names the useful lesson; clear continue/repair/stop choice with an honest small-session recap | Partial: scored feedback exists; reviewed MCQ path advances with “Next question” and finishes on batch exhaustion rather than a defined small learning cycle |
| Stop and return | Where was I and how do I continue? | Resume the exact lesson and phase with expectations about saved work | Unverified/partial: practice session IDs and Home Resume exist; live teaching traversal has no learning session and stores its current topic in component state |

## Owner-supplied recorded journey

This is an action trace, not a visual recording. It does not establish a five-to-seven-minute duration. The captured Home controls include Points, Ask for help and Homework helper, which occur in the reviewed TopicHome implementation. Treat it as evidence about a Home path, not confirmed coverage of the new-student Stage A branch.

| Part of journey | Recorded actions | What this supports / what remains unknown |
| --- | --- | --- |
| Home exploration | Select Unit 1; click Points and Ask for help; explicitly navigate to Home; click Homework helper; explicitly navigate to login | Several alternative entry points are used before the worked example. No hesitation duration is known. Explicit navigate steps do not prove that Ask for help or Homework helper caused a redirect or failed. |
| Worked question | See a worked example; click a distractor labelled DISTRACTOR; Next question | Another worked example is chosen before independent practice. No evidence shows whether the reasoning was read or understood. |
| Targeted information | Show me the deep dive; Copy deep dive twice; Back to the question | Deep Dive and copying are discoverable and used. Repeated Copy clicks do not establish a broken copy action. |
| Independent handoff | Try one on your own; asserted destination `/practice-mcq?from=open-hand` | Practice navigation is captured, but this URL has no topic parameter. The actual served item's alignment was not captured. |
| Assisted practice | Give me a hint → Yes, show me; Show me the reference materials → Yes, show me | Both aids are discoverable. Each requires a confirmation; the generic hint wording also gates reference materials in reviewed source. |
| Attempts and feedback path | Select an answer; Submit answer; Next question; select/change an answer; Submit answer; open and copy Deep Dive; Back to the question | Two submissions and continued question navigation are recorded. Correctness, feedback quality, assisted-attempt classification and persistence are unknown. |
| Return | Student hub, with asserted navigation to Home; Explore units | The return link works at the recorded navigation level. This does not test stopping, reopening later, restoring unfinished input or resuming the exact lesson/phase. |

**Strengths:** the owner reaches the worked question, uses Deep Dive before and after practice, requests targeted aids, submits answers and returns to Home. The ingredients can support lesson learning, and targeted information attracts use in this trace.

**Interpretation:** the recorded path visits several options without a clearly stated learning purpose or bounded pause. The owner's clarification means example browsing, direct practice and copying notes can all be valid choices; sequence alone cannot classify them as detours. Guidance should help students act on their chosen goal. An owner navigating the product is not a representative first-time student, and the trace cannot establish confusion or timings.

## Findings and recommendations

### F1 — Setup is clearer than the teaching promise (high priority)

HomeWelcomeBanner: “Your [subject] access is ready. Pick a unit to start.”
HomeStageANew hero: “Tell us where your class is,” “Start here · 2 minutes.”
The rationale stresses that Cramapple has no work yet and cannot recommend honestly.

**Inference:** this explains a setup dependency and the absence of personalization, but gives little reason to invest the first minutes. “What happens next” describes graded-attempt thresholds, not the student's immediate learning experience.

**Proposed change:** lead with the test/exam purpose and an understandable choice: learn a lesson through a question, practice independently, use its Deep Dive as notes, or bring a homework question for help understanding it. Explain the example → own attempt route as a useful option. Keep personalization thresholds subordinate. “Lock in” is the product goal, not a mastery claim earned simply by finishing a route.

### F2 — A student must know the taxonomy before seeing value (high priority)

Stage A enables position saving only after selecting a unit; independent entry is shown after a saved unit exists. Topic is optional. No “not sure” recovery is rendered in this component. Unit-only positions resolve to the first topic of that unit.

**Inference:** “where your class is” is useful for students who know it, but unfamiliar syllabus terms or exam-review use can stall entry or send them to an unintended first topic.

**Proposed change:** retain class-position selection; add an honest alternate way to choose a recognizable lesson, including a supported example for students who are unsure. Do not silently guess that the first topic is what their teacher just covered.

### F3 — Continuation does not clearly distinguish learning from another example and testing yourself (highest priority)

OpenHandMcqScreen renders **“Next question”** with the primary variant and **“Try one on your own”** with the quiet variant.
LiveOpenHandTeaching binds Next to pickNextTeachingTopic, which advances through later topics and can cross units.

**Recorded evidence:** the trace uses Next question before Try one on your own. It corroborates the availability and use of this route, without proving the owner's motivation or that all students will choose it.

**Inference:** a student following the strongest button may move to a different lesson without realizing it. Browsing more examples is legitimate when chosen knowingly; “Next question” fails to say whether the next item is worked or independent, or whether its lesson changes.

**Proposed change:** after a worked question, offer a clear recommended continuation, “Try one yourself on this lesson,” alongside an explicit “Study another example.” State when the lesson changes. Keep practice optional and accessible directly from Home without viewing an example first. Explain the transition in a sentence tied to the tested reasoning move.

### F4 — Targeted practice is a preference, not a verified lesson-pairing contract (highest priority)

LiveOpenHandTeaching passes topic to /practice-mcq.
LivePracticeMcq fetches up to ten unit-gated MCQs from student-session-items, without sending the target topic in that request. biasItemsToTarget moves matching returned items first; it retains all nonmatching items.
No matching practice item is guaranteed by this client path, and same-topic matching alone does not establish that it checks the same reasoning move.

**Recorded discrepancy:** the Try one on your own navigation asserts `/practice-mcq?from=open-hand`, without a topic parameter. The reviewed teaching path supplies a topic when known. The captured path/build may differ, or topic context may be absent; the trace does not identify the cause. Reproduce this transition and inspect the served item before assigning a root cause.

**Risk:** the experience can imply transfer from the worked question while the next item checks something else.

**Proposed change:** validate availability of unseen practice for the lesson/reasoning move. Make a missing pair an explicit state with an honest alternative; do not quietly substitute unrelated practice. This is a content/serving contract question as well as UX copy.

### F5 — Face-up answers need an explicit learning task (medium/high priority)

Live teaching renders the correct option and all distractor rationales immediately. Its note explains that nothing is scored. Reference and Deep Dive are available.
The reviewed live teaching route does not use the separate WorkedExample component whose copy says “watch the move” and “Now you try.”

**Inference:** students can understand that the answer is visible while still not knowing how to study it. Clicking an already-marked correct choice need not require any reasoning.

**Proposed change:** one brief cue to direct attention: notice the reasoning that makes the correct answer work and why a tempting alternative fails. An optional self-explanation prompt can deepen engagement, but must not become another mandatory onboarding form. Clarify where Reference/Deep Dive help and when they are optional.

### F6 — “Not enough evidence” dominates early value language (medium priority)

Stage A includes an unfilled curriculum and personalization threshold copy. Stage B adds multiple evidence disclaimers, guided/independent placeholders and another threshold.
Honest limits are appropriate.

**Inference:** repeated emphasis on what the system cannot yet say can obscure what the student already gains from one well-chosen explanation and attempt.

**Proposed change:** show a factual immediate recap first: lesson visited, practice attempted, useful feedback or mistake to revisit. Keep exam-score prediction, mastery, performance trend and broad personalization separate and evidence-gated.

### F7 — The first learning cycle has no clear stopping point (high priority)

Reviewed MCQ feedback offers “Next question.” LivePracticeMcq finishes when its fetched batch is exhausted and offers Return Home or a worked example. It has no bounded first-use recap in this path.

**Inference:** a student leaving at minute seven may not know whether they accomplished anything or where to continue.

**Proposed change:** after a small justified set, summarize what happened and offer continue, another targeted attempt where useful, or stop with a concrete next step. Do not require completing all fetched items to reach a satisfying pause.

### F8 — Resume exists, but learning-phase continuity is incomplete (high priority)

Home Stage A/B show Resume when snapshot.liveSession exists. Practice resumes a stored learning session but initializes index to zero and refetches its queue. This does not prove that the exact next item is restored; backend behavior still needs checking.
The live teaching route has no learning session. Its Next traversal changes component state without persisting the traversed topic in the URL or a lesson-progress record. Returning Home therefore does not necessarily know whether the student studied the worked example and is ready to try the lesson independently.
Latest StudyNav adds hub/topic/subject exit controls, but the linked QA documents label its release verification incomplete. Archived-session reactivation remains a known separate gap.

**Proposed change:** resume a lesson and phase, not just a generic practice route. Explain what is saved, protect unfinished input, and distinguish same-device from cross-device continuity. Verify exact next-item behavior before promising it.

### F9 — Home presents a feature promise that is not fulfilled on click (high priority)

The trace includes a Homework helper click before the worked example. In reviewed TopicHome, the button intentionally looks available at rest; clicking reveals “coming soon” as a demand probe, with no helper feature behind that action. A separate ByoqHomeLink offers Bring your own question to /byoq.

**Inference:** a student seeking help with today's lesson can spend their first interaction on an unmet promise. The overlap with the available Bring your own question entry can also obscure which action helps now. The trace does not show the rendered coming-soon note, so that outcome is source evidence.

**Proposed change:** make availability clear before the click and clarify or consolidate the relationship with the actual question-help entry. Present “Help me understand my question” as a legitimate separate goal. Explain the boundary before upload: Cramapple helps the student reason through their own homework question without supplying its final answer. The reviewed link alone does not establish that this boundary is implemented.

### F10 — Assistance wording can discourage learning and mislabel reference use (medium priority)

The trace records two confirmation pairs: hint request and reference-material request. HintGate uses “Sure you need a hint?” for both, while ReferencePane uses this same gate for reference materials. Current assistance semantics distinguish coached attempts; assistance before submission is recorded, and post-answer Deep Dive is free.

**Inference:** generic, cautionary hint wording can make a learning aid feel like a penalty or treat reference use as an admission of failure. Two confirmation pairs add steps during the recorded attempt. The trace does not establish whether the owner objected.

**Proposed change:** use neutral, resource-specific wording and explain the consequence plainly, for example “Using this help marks this attempt as guided.” Preserve honest assistance recording and the student's explicit choice. Review repeated confirmations against that purpose; do not remove them without checking the intended assistance contract.

## Recommended first-use choices (proposal)

Explain the purpose before setup: **Prepare for tests and the AP exam, one lesson at a time.** Let students choose a recognizable lesson when needed; do not require class-position setup before every route.

| Student's goal | Proposed entry | What should happen | Useful pause/return state |
| --- | --- | --- | --- |
| Learn how this lesson appears in questions | **Learn from a question** | Show a worked question with reasoning, tested idea and tempting mistake; recommend an aligned own attempt when ready | Return to the example or choose an own attempt; neither is mandatory |
| Check what I can do | **Practice on my own** | Enter targeted independent practice immediately; offer explanations/help when needed | Restore the exact attempt/queue and unfinished input where supported |
| Supplement my class notes | **Read or export lesson notes** | Open the relevant Deep Dive and make export/copy availability clear, without requiring an attempt | Revisit the named Deep Dive; do not treat reading/export as demonstrated mastery |
| Understand my homework question | **Help me understand my question** | Accept an upload and guide the student's reasoning without providing the final answer | Restore the question and guidance context where supported; do not pretend it is an unanswered practice set |

For a student who chooses to learn from a question:
1. Identify the test/exam idea and reasoning move the question illustrates.
2. Explain why the correct response works and why a tempting alternative fails.
3. Offer an unseen aligned own attempt as the recommended next step, while keeping another example or notes available.
4. Give focused feedback if the student attempts practice.
5. Provide a factual recap and a concrete pause/continue choice.

Keep one dominant recommendation and compact, visible alternatives on the hub. These are different uses of the same lesson resources, not separate dashboard modes or a long onboarding tour.

### Student-facing vocabulary (proposal to validate)

Use **“Learn from a question”** as the action label, with **“See the reasoning behind a test-style question”** as its short explanation. “Worked example” can remain a descriptive term inside the screen where its meaning is apparent; “Open Hand” needs explanation if exposed to students. Validate these words with students rather than assuming familiarity with instructional terminology.

Suggested hero copy:

> Prepare for tests and the AP exam, one lesson at a time. Learn from a question with the reasoning explained, practice on your own, or use lesson notes alongside class.

Suggested homework-entry copy:

> Bring a question you're working on. We'll help you understand the ideas and work through your reasoning; you supply the answer.

Use “test-style” or equivalent exam-format claims only for content whose format and alignment support that promise. Avoid implying that an example is a predicted exam question.

## Alternate Student Hub design: assessment and revision brief

**Design reviewed:** [CramApple — Student Hub, Claude artifact](https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh), supplied by David as an unimplemented alternative.

**Evidence:** inspected the artifact's rendered canvas and accessibility content on 2026-10-07. Its one page contains four artboards: Desktop · Personalized, Mobile · Personalized, Frame A · New recognized student, and Frame B · Building evidence. The reviewed design shows hub layouts, not a complete worked-question, practice-feedback or session-end flow. Its links include mock fragment destinations; backend behavior, routing, saved state and recommendation quality were not validated. A design annotation says the mobile frame is an earlier version and has not been reworked.

### What this alternative resolves or improves

The alternate gives the recommended action a clear visual focal point, explains recommendation reasons, names specific lessons and separates curriculum position from demonstrated performance. Its personalized view surfaces an unfinished set (“Unit 4 MCQ · 6 of 10 done”), and the mobile view names that set in its Resume link. These are useful improvements in direction and return visibility. The illustrated design also omits the reviewed live hub's Points/Ask for help/Homework helper row. Its simpler hierarchy is useful, but removal of that row does not replace the need for understandable homework-help and notes entries.

It does **not** resolve the central first-use concern by itself. Frame A still leads with “Tell us where your class is,” “no work from you yet” and question thresholds. Later frames primarily offer Start practice for 15 or 20 minutes. None of the four frames clearly explains learning through test-style questions or distinguishes that route from direct practice, notes use and help with a student's own question. Resume visibility is improved, but exact lesson/phase restoration remains a behavior requirement.

| Concern from this assessment | Alternate design effect | Revision needed |
| --- | --- | --- |
| F1/F6: teaching promise and early value | Clear hierarchy; new view still foregrounds missing evidence | Explain the test/exam purpose and optional routes before emphasizing personalization thresholds |
| F2: choosing a lesson when unsure | Adds “Not sure?” and a six-question check | Offer recognizable lesson selection; do not imply six answers establish the teacher's current position |
| F3/F5: worked-question guidance and handoff | Not shown in these hub frames | Make learning from a question an explicit option; recommend an own attempt without making either a prerequisite |
| F4: practice alignment | Topic labels make the recommendation concrete | Validate an unseen aligned item before promising the cycle; UI labels alone do not establish alignment |
| F7: satisfying stop | 15/20-minute labels suggest a bounded activity | Define a short finish/recap and an honest duration expectation |
| F8: return continuity | Specific unfinished-set Resume is substantially clearer | Extend Resume to lesson and phase, including a completed worked example with practice still to do |
| F9/F10: competing promises and assistance | Cleaner hub choices; supportive “both fair calls” copy | Carry that tone into assistance gates and preserve truthful availability/status |

### Changes for a new student: Frame A

**1. Replace the setup-first hero with an outcome and a small learning path.**

Keep the strong hero treatment, but change its purpose. Suggested copy:

> Prepare for tests and the AP exam, one lesson at a time. Learn from a question with the reasoning explained, practice on your own, or use lesson notes alongside class.

Show the recommended route briefly: **Learn from a question → Try one yourself → Focused feedback**. Label it as a suggested path, not a required checklist. Use **Learn from a question** as the dominant first-use recommendation when appropriate, and put **Practice on my own** visibly beside it. Provide compact **Lesson notes** and **Bring my own question** entries without adding four large dashboard panels. Name the selected lesson in the entry. The time label can say **A short first session** until a five-to-seven-minute estimate has been validated. Do not imply a score or mastery outcome simply from finishing it.

**2. Keep topic selection, but make it a bridge to learning.**

Ask “What did you cover in class?” and show recognizable lesson names alongside official unit/topic labels. Allow the student to change the choice easily. Put the selector in or immediately beside the hero, so saving class position is not the perceived end of onboarding. A unit-only choice should lead to choosing a lesson, not silently selecting that unit's first topic.

For an unsure student, offer **Browse lessons** or a deliberately identified **Try a sample lesson**. A diagnostic can be secondary if implemented and justified. Rewrite the current “Answer 6 questions and we'll estimate it” claim: performance can inform a practice recommendation, but does not identify where the teacher is in the syllabus. Never convert that estimate into confirmed class position without the student's confirmation.

**3. Give early value more space than absent evidence.**

Reduce “can't estimate,” empty curriculum, threshold and “no work yet” messaging to one quiet explanation: **Recommendations become more personal as you practice.** Retain honest evidence limits where a performance claim would otherwise appear.

Move the full curriculum below the immediate actions. Provide selected-topic information beside the worked question, where it helps answer a concrete question, and also allow direct Deep Dive access for students seeking supplemental class notes. Label these as lesson-specific notes directed toward the tested ideas, rather than a general reference library. Notes users should not have to complete a worked question or graded attempt to read or export them.

**4. Design a finish worth reaching.**

At a useful pause in the chosen route, show a factual recap appropriate to what happened: an example viewed, notes copied/exported, a homework idea discussed, or practice attempted with feedback and assistance status. For the example-plus-practice route, identify the tested reasoning move and useful feedback. Offer a relevant continuation and **Pause for now**. A notes-only or example-only visit is a valid use; do not show an incomplete-practice warning merely because no attempt was submitted. A wrong practice answer should lead to a specific explanation or guided repair, with another aligned attempt available when justified.

This finish belongs to the lesson flow and must be designed alongside the hub; it is absent from the reviewed artifact.

### Changes for an early returning student: Frame B

**5. Replace the “building evidence” experience with a useful next lesson action.**

Keep its honest distinction between class position and performance. Replace the primary generic Start practice invitation with either:
- **Continue your lesson**, when there is unfinished lesson work; or
- **Work on Plasma membranes**, with visible choices to learn from a question, practice directly or open lesson notes when there is no unfinished work.

Explain why in one short sentence: **You selected Plasma membranes as today's lesson.** Avoid a large explanation of how little the system knows. The current repeated “not enough evidence” regions can be collapsed into a single restrained note; factual activity can still appear below.

A student should get useful test-directed learning or independent practice without first accumulating enough graded attempts for personalization. Do not require an example before practice.

**6. Turn recent work into an actionable memory cue.**

Show a small recent-lesson card with the lesson, last phase and next action. Examples are proposed states, not observed saved behavior:
- **Plasma membranes · Example viewed. Suggested next: try one yourself**, with return-to-example also available.
- **Membrane transport · Attempt submitted. Suggested next: revisit the explanation.**
- **Plasma membranes · Lesson notes last opened**, with direct reopen/export.
- **Your uploaded homework question · Guidance in progress**, with continue only if that context is actually saved.
- **Unit 4 practice · 6 of 10 completed. Next: question 7**, only if exact queue restoration is verified.

Do not infer understanding from viewing a worked question. If there is unfinished answer input, state that it is saved only when the product actually persists and restores it.

### Changes for an established returning student: personalized desktop and mobile

**7. Choose a single primary action using the student's unfinished work.**

The desktop hero currently contains both a new recommendation and an unfinished-set Resume link; the larger Start practice treatment can compete with returning to prior work. When meaningful unfinished work exists, make **Continue [lesson or question]** primary and name its next phase. After a completed activity, make a relevant new recommendation primary. For recent notes use, offer **Reopen [lesson] notes** rather than suggesting an abandoned attempt. Keep direct practice, learning from a question, notes and own-question help accessible. Allow an easy deliberate switch; do not force stale work or unfinished practice onto a student returning for notes.

Distinguish **Your class: Unit 5** from **Suggested review: Unit 4**. Name why the recommendation moves backward: **Your last attempts missed this reasoning step**, supported by actual evidence. This makes the backward curriculum arrow intelligible and helps the student judge relevance.

**8. Connect information, practice and motivation to the same lesson.**

Keep the bold typography, color and visible progress; they can give the hub energy. Make the hero show what the next activity will teach or check, rather than only recoverable points. Suggested direction:

> Feedback mechanisms  
> Learn how a test question distinguishes negative from positive feedback. See the reasoning, then try one yourself when you're ready.

Keep **Practice on my own** visible for a student who already understands the lesson.

Use truthful, task-specific encouragement after work: **You solved the next question without help** or **You corrected the same mistake on another question**, where recorded evidence supports it. Do not equate fewer hints with learning automatically. Preserve the supportive intent of “both fair calls” without attributing a student's motives.

Review “topics mastered,” “units complete,” “points waiting” and independence graphics against the actual evidence rules. Question counts alone do not establish mastery; “5 points waiting” should not sound like a guaranteed gain. Prefer observed results and clearly explained status, with stronger claims gated by the product's approved evidence contract.

**9. Make Deep Dives answer the current learning need.**

The alternate's short, named explainers are useful. Prioritize the one relevant to the active lesson or a recorded mistake and explain that relationship. Provide both in-question access and a direct **Lesson notes** route, with visible **Export notes** or **Copy notes** controls matching actual capability. Notes can supplement class independently of practice. Preserve topic, source/version context and useful structure in exported material; verify the export format and current implementation before promising it. The trace confirms Copy clicks, not a particular exported file format or successful copy result.

**10. Update mobile to the same action hierarchy.**

Do not ship the artifact's explicitly unreworked mobile frame as the final design. Above the fold, prioritize subject/lesson context, the primary start-or-continue card and its next phase. Countdown and broad curriculum can remain compact secondary context. Use the same specific resume wording as desktop; expand details on demand. Verify that the primary action and its purpose are visible at real device widths and text sizes, rather than relying on the canvas annotation about an 844px fold.

### Behavior required for these design promises

These are implementation requirements to scope separately, not changes authorized by this report:

- Persist the subject, lesson/topic, phase, current worked item, practice queue position and unfinished input as appropriate; define same-device and cross-device behavior.
- Serve an unseen practice item aligned with the lesson and intended reasoning move. Show an explicit alternative when that content is unavailable.
- Restore the actual next phase on return. A generic route or a restarted batch is insufficient for the proposed Continue copy.
- Preserve assistance classification, with neutral resource-specific explanation in the help gate.
- Produce a route-appropriate factual recap and useful next action without inventing mastery, a learning gain or a saved state. Reading/exporting notes is not practice evidence.
- Permit independent practice and direct notes use without an example-completion gate. Preserve easy switching between these routes.
- For uploaded homework, guide concepts and the student's reasoning without revealing its final answer, including through rationales, Deep Dives, downloads or generated solution steps. Verify this boundary in the implemented BYOQ flow; the existence of /byoq is not proof.
- Verify notes export/copy and own-question upload capabilities separately, and reflect actual availability in labels.
- Ensure every suggested entry is available; show disabled/unavailable content honestly.

### Priority and acceptance checks

**First:** revise Frame A's test/exam promise and optional route choices; specify the worked-question handoff and aligned attempt for students choosing that path, direct practice entry, route-appropriate recap and return behavior. Include clear notes export and own-question help boundaries. These directly address the product differentiation and the first seven minutes.

**Next:** apply the same primary-action rule to Frame B and personalized views, clarify recommendation reasons, reduce repeated evidence warnings, and bring mobile to parity. Preserve the visual character; an additional dashboard region is not required for each recommendation.

Validate with a first-time student and a returning student, without explaining the method beforehand:
1. Can they describe the test/exam purpose, choose a relevant lesson or upload their own question, and distinguish the available routes?
2. If choosing an example, do they notice the tested reasoning move and understand the optional own-attempt continuation? Can a practice-first student bypass the example?
3. Does that attempt check the intended lesson, including when aligned content is missing?
4. Can they stop after a useful small cycle and explain what happened?
5. On return, do they recognize their lesson and resume the correct phase, with input and queue state restored where promised?
6. Can a notes-first student find and export/copy the relevant Deep Dive without submitting an answer? Is its return state useful and free of misleading practice-completion prompts?
7. Does own-question help support the student's reasoning without supplying the homework answer, including indirect leakage through exported explanations?
8. Does mobile present the same clear choices and truthful state?

The alternate is a useful visual and recommendation framework. The proposed revision makes it communicate test-directed lesson learning while supporting a student's deliberate choice of examples, independent practice, supplemental notes or homework understanding.

## Remaining visual walkthrough and student validation

Use an existing controlled, entitled test student with no qualifying practice history; do not reset a real student. First verify the published build and record the evidence stage. Start after authentication, on Home.

Give a student one neutral task: “You just covered a lesson in class. Use Cramapple for a few minutes to prepare for being questioned on it, then stop when you would normally stop.” Avoid explaining the product method beforehand. Separately observe students who want immediate practice, supplemental notes and help understanding an uploaded homework question; do not require each to follow the example route.

Observe:
- time to identify a useful action for the student's stated goal, including a relevant example when chosen;
- hesitations and choices made without prompting;
- whether they can explain why the answer works, rather than merely identify it;
- whether they understand the independent-practice transition and know that examples are optional;
- whether the practice checks the intended lesson/reasoning;
- whether feedback changes their next action;
- where they decide to stop and what they believe was saved;
- returning in the same browser and, separately, another device.

At the end ask: “What is Cramapple helping you do?”, “What would you do next?”, and “How would you use this after your next class?” Ask after observing behavior; avoid leading questions such as “Was the worked example helpful?”

Repeat the principal path on mobile and test unsure-topic, no-worked-example, wrong-answer and interrupted-answer cases. A small number of sessions can identify friction; it does not establish statistical conversion or learning gains. This expert assessment cannot substitute for watching actual students.

## Next required action and approval state

**Next owner:** Codex for assessment synthesis; David for visual evidence and access to an appropriate controlled first-use account.
**Next action:** use the owner clarification and alternate-design revision brief to scope optional test-directed learning routes and return behavior; obtain screen/video evidence of implemented Home, worked question, practice feedback and return state; confirm the published build and account stage. Reproduce the topic-less practice handoff, inspect its served item, and test departure/re-entry. Follow with first-time student usability sessions. The action-trace findings above stand without another cloud-browser attempt; visual/layout and timing judgments remain pending.
**Approval:** read-only assessment and recommendation drafting are Lane 1. This report grants no implementation, production write, publication, migration, task closure or final QA approval. Proposed changes need a scoped task and the applicable gate.
