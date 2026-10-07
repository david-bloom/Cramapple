# New-User Experience: First 5–7 Minutes

**Status:** Draft — source assessment complete; signed-in observation pending
**Date:** 2026-10-07
**Owner:** Codex / Main Conductor
**Product Owner:** David Bloom
**Tier:** Standard assessment under Lane 1 standing approval
**Branch:** codex/new-user-experience-assessment
**Related:** TASK-0048, TASK-0052, TASK-0060; DECISION-0087, DECISION-0097

## Purpose and owner framing

David's assessment brief: Cramapple helps students lock in each lesson through targeted information and targeted practice. The Open Hand / worked question is central. Assess from first landing on Student Home through the next 5–7 minutes, including stopping and returning.

This records the owner's brief and proposed assessment criteria. It does not amend the product vision or assert that every competitor fits a reference/test dichotomy. No competitive research was performed.

## Preliminary finding

The reviewed implementation contains the right ingredients, but does not consistently guide a student through one small learning cycle. Home leads with class-position setup and collecting evidence; the worked-question screen's primary CTA advances to another worked example, while independent practice is secondary. The student must infer both the method and when to move from reading to doing.

This is an expert source-review finding, not observed student behavior or a usability-test verdict.

## Evidence boundaries

- Canonical bootstrap, workflow, standing approval lanes, architecture/design entry point and index were read from GitHub in this session.
- TASK-0048 records Stage A/B as published on 2026-10-05; signed-in visual QA remains owed.
- Lovable project 56cae479-f7c9-4988-b536-56538c38ee4e was read at exact source commit **64352ecbf26da46b26a235d142fefddf1043d82f**, the latest head returned 2026-10-07. Some changes at this head are documented as preview-only. Publication of this exact head was not verified.
- Direct browser navigation to app.cramapple.com/home redirected to cramapple.com/login?redirect=%2Fhome. Sign-in offers Google or an emailed sign-in code. No signed-in hub or question was observed.
- No timed student session, grading, lesson completion, departure/re-entry, mobile screen inspection, or learning-outcome test was performed.
- No student account was created or reset. No grading/history/course-position write, production configuration, publication, or migration occurred.
- Existing QA reports are historical evidence with their stated limitations; they are not new tests in this session.

## The journey to assess

The time bands below are proposed observation windows, not measured timings or a promise that every lesson fits seven minutes.

| Window | Student's question | Success criterion | Source assessment |
| --- | --- | --- | --- |
| First 30 seconds | What is this for, and where do I start? | Student can explain the worked-question → own attempt method and identify one primary action | Partial: class-position action is explicit; differentiated method is not explained in the reviewed welcome or Stage A hero |
| 30–90 seconds | Which lesson should I work on? | Choose a relevant topic; recover if they do not know their official unit/topic | Partial: taxonomy selects exist, but no visible “not sure” path in Stage A |
| 1–3 minutes | What should I notice in this worked question? | Identify the key reasoning move and a likely mistake without guessing which pane to read | Partial: correct answer/rationales and reference are present; no explicit reading sequence or student task in this live teaching path |
| 3–5 minutes | Can I now do this myself? | Clear primary CTA to an unseen question requiring the same lesson/reasoning | Weak: independent practice is secondary; topic is passed, but the practice client only reorders a server-selected batch |
| 5–7 minutes | What did I learn and what next? | Feedback names the useful lesson; clear continue/repair/stop choice with an honest small-session recap | Partial: scored feedback exists; reviewed MCQ path advances with “Next question” and finishes on batch exhaustion rather than a defined small learning cycle |
| Stop and return | Where was I and how do I continue? | Resume the exact lesson and phase with expectations about saved work | Unverified/partial: practice session IDs and Home Resume exist; live teaching traversal has no learning session and stores its current topic in component state |

## Source findings and recommendations

### F1 — Setup is clearer than the teaching promise (high priority)

HomeWelcomeBanner: “Your [subject] access is ready. Pick a unit to start.”
HomeStageANew hero: “Tell us where your class is,” “Start here · 2 minutes.”
The rationale stresses that Cramapple has no work yet and cannot recommend honestly.

**Inference:** this explains a setup dependency and the absence of personalization, but gives little reason to invest the first minutes. “What happens next” describes graded-attempt thresholds, not the student's immediate learning experience.

**Proposed change:** lead with the small outcome and method: choose today's lesson, examine a worked question, try a related question, get focused feedback. Keep personalization thresholds subordinate. “Lock in” is the product goal, not a mastery claim earned simply by completing the first cycle.

### F2 — A student must know the taxonomy before seeing value (high priority)

Stage A enables position saving only after selecting a unit; independent entry is shown after a saved unit exists. Topic is optional. No “not sure” recovery is rendered in this component. Unit-only positions resolve to the first topic of that unit.

**Inference:** “where your class is” is useful for students who know it, but unfamiliar syllabus terms or exam-review use can stall entry or send them to an unintended first topic.

**Proposed change:** retain class-position selection; add an honest alternate way to choose a recognizable lesson, including a supported example for students who are unsure. Do not silently guess that the first topic is what their teacher just covered.

### F3 — Primary continuation moves away from locking in this lesson (highest priority)

OpenHandMcqScreen renders **“Next question”** with the primary variant and **“Try one on your own”** with the quiet variant.
LiveOpenHandTeaching binds Next to pickNextTeachingTopic, which advances through later topics and can cross units.

**Inference:** a student following the strongest button may browse several lessons without trying the one just explained. “Next question” also fails to say whether the next item is worked or independent.

**Proposed change:** make independent practice for this lesson primary. Label browsing another worked example explicitly and keep it available as a deliberate secondary choice. Explain the transition in one sentence tied to the learning move.

### F4 — Targeted practice is a preference, not a verified lesson-pairing contract (highest priority)

LiveOpenHandTeaching passes topic to /practice-mcq.
LivePracticeMcq fetches up to ten unit-gated MCQs from student-session-items, without sending the target topic in that request. biasItemsToTarget moves matching returned items first; it retains all nonmatching items.
No matching practice item is guaranteed by this client path, and same-topic matching alone does not establish that it checks the same reasoning move.

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

## Recommended first-use sequence (proposal)

1. Pick a familiar lesson, with help if unsure.
2. Show the outcome and brief path: worked question → own attempt → focused feedback.
3. Direct attention to one useful reasoning move in the worked question.
4. Make “Try this yourself” the primary continuation, with an unseen aligned item.
5. Give specific feedback; offer another targeted attempt when needed.
6. Provide a factual mini recap and a clear pause/continue choice.
7. Returning Home shows the lesson and the appropriate next phase.

Keep the worked question central. A long feature tour, extra dashboard regions, or multiple introductory modes would add choices before the student experiences this method.

## Observed walkthrough and validation plan

Use an existing controlled, entitled test student with no qualifying practice history; do not reset a real student. First verify the published build and record the evidence stage. Start after authentication, on Home.

Give a student one neutral task: “You just covered a lesson in class. Use Cramapple for a few minutes to help it stick, then stop when you would normally stop.” Avoid explaining the product method beforehand.

Observe:
- time to identify a useful first action and time to a relevant worked example;
- hesitations and choices made without prompting;
- whether they can explain why the answer works, rather than merely identify it;
- whether they notice and choose the independent-practice transition;
- whether the practice checks the intended lesson/reasoning;
- whether feedback changes their next action;
- where they decide to stop and what they believe was saved;
- returning in the same browser and, separately, another device.

At the end ask: “What is Cramapple helping you do?”, “What would you do next?”, and “How would you use this after your next class?” Ask after observing behavior; avoid leading questions such as “Was the worked example helpful?”

Repeat the principal path on mobile and test unsure-topic, no-worked-example, wrong-answer and interrupted-answer cases. A small number of sessions can identify friction; it does not establish statistical conversion or learning gains. This expert assessment cannot substitute for watching actual students.

## Next required action and approval state

**Next owner:** Codex for assessment; David for providing secure sign-in to an appropriate existing controlled test student.
**Next action:** complete the signed-in published-build walkthrough, then reconcile observed findings with this source assessment. Follow with student usability sessions.
**Approval:** read-only assessment and recommendation drafting are Lane 1. This report grants no implementation, production write, publication, migration, task closure or final QA approval. Proposed changes need a scoped task and the applicable gate.
