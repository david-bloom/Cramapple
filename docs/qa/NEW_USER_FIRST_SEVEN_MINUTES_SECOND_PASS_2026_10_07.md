# Student Experience: Second Pass After the October 7 Changes

**Status:** Draft — independent source assessment complete; fresh-student, timed and mobile walkthrough pending
**Date:** 2026-10-07
**Owner:** Codex
**Product Owner:** David Bloom
**Tier:** Micro — read-only assessment and documentation under Lane 1
**Branch:** codex/new-user-experience-second-pass
**Governing recommendation:** [Student Hub Unified Recommendation](../product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md), DECISION-0100 and its amendment
**Earlier evidence:** [First pass](NEW_USER_FIRST_SEVEN_MINUTES_ASSESSMENT_2026_10_07.md), merged PR #365
**Related:** TASK-0048, TASK-0052

## Verdict on the original request

The changes improve navigation reliability and remove confusing legacy hub choices for returning students. They have not yet made the differentiated learning method obvious in the first minutes. The current hub still explains class-position setup and collecting evidence more clearly than learning a lesson through how it is questioned on tests and the AP exam.

The new-student Stage A component was not changed in the net diff reviewed. Most of the unified recommendation remains proposed rather than implemented. This is a scope/status observation, not a rejection of the revised plan.

| Owner's question | Second-pass verdict | Evidence and implication |
| --- | --- | --- |
| Is it obvious what they should do? | **Partly.** The immediate setup action is clear; choosing a useful learning route is not. | Stage A asks for unit/topic and saves position before offering an entry. It has no unsure-lesson fallback. Home offers a context-dependent example/practice button, not separate choices. |
| Can they see the value easily? | **Still weak.** | Neither stage states the test/exam lesson-learning promise or explains why studying an answered question is useful. A face-up answer is available, but its reading task remains implicit. |
| Are we guiding them well over 5–7 minutes? | **Entry mechanics are better; learning guidance remains incomplete.** | Topic handoff and already-answered-item filtering are fixed in source and reported live. Primary Next still browses worked examples; aligned practice is still a batch preference; the three-attempt pause is absent. |
| Is it easy to stop and return? | **Return navigation exists; meaningful continuation is incomplete.** | Home still shows generic Resume. Practice rebuilds a queue, while teaching has no saved lesson/phase. There is no route-appropriate return recap or notes shelf. |

A student may choose examples, independent practice, supplemental notes or help understanding their own question. Success is accomplishing that chosen goal, not completing every phase of an example-to-practice sequence.

## What was examined and what was not

- Read current canonical bootstrap, architecture/design entry point, index, standing approval lanes, workflow and branch rules.
- Read the unified recommendation on main, including the owner's naming, optionality, first-question-aid and three-attempt-pause decisions, and Claude/Fable's same-day published-build findings.
- Independently inspected app source at **04e35dbc7c50dfcb88a9fbedf387550c9623fcc0**, latest head both at the start and end of this pass. Reviewed the net diff from the first pass's **64352ecbf26da46b26a235d142fefddf1043d82f**.
- The unified record reports personalized → Stage B (`ed1b4715`) published and owner-confirmed at approximately 15:35 UTC, and handoff/answered-item fixes (`d7e1292f`) published and owner-confirmed at approximately 16:00 UTC. Those are **recorded owner/Claude observations**, not a new walkthrough by this assessor.
- The assistance-state and minutes fixes at `04e35dbc` are documented as **preview only / awaiting publish** in that record. Project-level `is_published: true` does not prove this exact head is published.
- This assessor's fresh navigation to `app.cramapple.com/home` reached `cramapple.com/login?redirect=%2Fhome`. No signed-in screen, fresh student, timed session, grading result, notes export, BYOQ interaction or departure/re-entry was directly observed in this pass.
- No accounts were created/reset; no application code, grading/history, production configuration or deployment was changed. No old Recorder credentials were used.
- The unified recommendation governs. This report is a new implementation checkpoint, not a replacement competing design brief.

## Improvements confirmed in the current source

| Change | What improves | Remaining boundary |
| --- | --- | --- |
| Personalized students use HomeStageBBuilding; TopicHome is unmounted | Removes remembered Points mode and the misleading Homework helper/Ask for help row from that path | New students still use HomeStageANew. All students have not been routed to Stage B; follow the actual HomeV2 branches. |
| Question links use JSON-safe topic parameters | Numeric-looking topic codes survive the router; the worked-question handoff can now carry the chosen lesson | Topic preservation alone does not guarantee an aligned served question |
| Practice filters this browser's practice attempts and the student's submitted/graded item IDs | Returning users need not start by paging through old graded answers when those reads succeed | Filtering is after a limited server fetch; read failure falls back to local-only history |
| Grading passes coached/independent state at attempt creation | New assisted answers can contribute truthful stored assistance status | Preview publication pending; earlier misclassified answers are unchanged; assistance-event recording is still a follow-up |
| Weekly minutes use session start → last graded attempt, with a cap | Removes the recorded overnight abandoned-session inflation from this calculation | Preview publication pending; this is an estimate, not measured active-study time |

These changes matter for trust and continuity. They do not themselves teach a first-time student how to use Cramapple.

## The first 5–7 minutes, reconsidered

Time bands are assessment windows, not measured durations.

### Landing and first action: the student still encounters setup before purpose

Stage A still says “Tell us where your class is,” “Start here · 2 minutes,” and “Cramapple has no work from you yet.” Its primary action is Set my position. There is no test/exam purpose sentence, four-door entry row, recognizable browse/sample alternative or explicit unit-only lesson-selection step. The welcome banner still says Pick a unit to start.

**Implication:** a student can complete a form while not understanding why this is more useful than a reference site or practice bank. Familiarity with official taxonomy remains an entry dependency.

**Next:** implement unified §3.1/3.2/3.7: purpose, recognizable lesson choice, unsure fallback, compact routes and reduced empty-evidence copy. A lesson title should orient the student before codes do.

### Choosing a route: the recommended example still occupies the only ordinary learning entry

Both Stage A and Stage B use `usePracticeEntry`. When teaching content exists, the button becomes “See a worked example” and opens Open Hand. Otherwise it becomes Start practice. The student cannot explicitly choose direct practice through a second hub door when an example exists.

Stage B's hero says “Your best N minutes” and “Practice where your class is right now,” even when its action opens an answered example.

**Implication:** practice is reachable after the example screen, but the hub does not honor the intended one-tap choice to skip that example. The hero's promise and destination also differ.

**Next:** distinct Learn from a question and Practice on my own actions, with notes and Bring a question visible compactly. Make the first action recommended and explain why; no sequence or completion gate.

### Studying the answered question: the content teaches, but the screen does not direct attention

OpenHandMcqScreen still explains “Nothing is scored here” and shows every answer/rationale. It does not implement the agreed cue to notice the tested reasoning and tempting mistake. “Open Hand” remains exposed as terminology. “Next question” is primary, while Try one on your own is quiet; Next can change topics/units without naming the transition.

**Implication:** seeing that an answer is available does not tell a student how to learn from it. More examples are a valid choice, but the change must be explicit.

**Next:** unified §3.3's reading cue; recommended own attempt, explicitly labelled Study another example and advance destination. Keep examples optional and test-format/scoring claims appropriate to the item type.

### Trying independently: two defects are repaired, but targeting and guidance are still incomplete

The topic parameter now survives the handoff and answered items are removed from the fetched list. However, the client still asks the server for ten unit-gated MCQs without a topic parameter. `biasItemsToTarget` then reorders remaining items; it does not discard nonmatches or establish matching reasoning.

There is still no question-1 ungated-aid treatment, first-wrong-answer orientation or optional worked-first link in the practice screen. HintGate still asks “Sure you need a hint?” for reference access as well as hints.

**Implication:** the route is more usable, but the student may still face an unaligned item, discouraging aid confirmation and an unexplained testing-first interaction.

**Next:** preserve the handoff fix, implement B2's content/serving contract, and deliver agreed §3.4 guidance. Until alignment holds, keep “Try one on your own” rather than promising a similar/on-this-lesson question.

### At minute five to seven: there is still no intentional pause

LivePracticeMcq advances Next question until the fetched queue is exhausted. There is no pause after three graded attempts and no short summary of the lesson, points, assistance and useful feedback.

**Implication:** leaving early can still feel like abandoning a batch rather than completing a useful activity. Viewing an example or copying notes also leaves no factual return recap.

**Next:** implement the approved three-attempt invitation to continue, and factual finishes for the other routes. Do not claim every extra answer improves recommendation quality unless the actual recommendation behavior supports that wording.

### Returning: the hub knows that a session exists, not what the student intended to continue

Home's Resume session is secondary and uses a format-only URL (`/practice-mcq` or `/practice-frq`), without the chosen topic. LivePracticeMcq refetches/rebuilds its queue and starts at index zero; answered-item filtering is helpful but is not exact phase/queue restoration. An unsubmitted pick is component state. Navigation guards protect against some accidental exits; they do not save it.

Teaching traversal still changes component state without a saved lesson/phase record. No recent-lesson memory card or route-specific return summary is present.

**Implication:** a student returning after an example, an unfinished answer or notes use is not reliably offered the precise next action. A generic resume can also lose the topic bias.

**Next:** B1/B3/B4 before promising exact Continue. In the interim use truthful “Last time” context and explicit route choices. Explain what is saved, including device limits.

## Two additional issues exposed by this pass

### S2-1 — All-answered copy overstates the scope of the check

The new `PRACTICE_ALL_ANSWERED` says “You've answered every practice question ready for this lesson.” That state is computed by filtering the currently fetched batch of up to ten items. It does not check the whole lesson bank or fetch a replacement batch.

**Risk:** if a fetched batch is already answered while other unseen content exists, the student can receive a misleading completion/dead-end message. This is a source-derived conditional risk, not a reproduced production occurrence.

**Next:** fetch further eligible unseen items, or scope the message to the returned set. Do not equate exhausting a batch with exhausting the lesson. This extends B2, not a new product feature.

### S2-2 — Notes content appears without a usable notes door

Stage A explainers and Stage B Deep dives render previews in noninteractive `article` elements. They provide no Open/Save/Export actions. Stage B calls the section Deep dives while its body is the first available brief/explainer field, not necessarily the full Deep Dive. The question overlay can copy full Deep Dive text, but the handler silently ignores clipboard failures and gives no success state.

**Risk:** a notes-first student can recognize relevant material without a clear way to open the full notes, save them or know whether copying succeeded. Opening an example just to reach the notes is unnecessary friction for this legitimate use.

**Next:** a direct lesson-notes route, full-content distinction, truthful copy/export confirmation, then a saved-notes shelf when its storage exists. Do not label clipboard copy as durable in-app saving.

Bring your own question remains a quiet footer link, with no no-answer boundary in the hub text. The implemented BYOQ flow and indirect answer leakage still require separate validation under B6; this pass does not certify them.

## Highest-impact next slice

Continue the already agreed unified recommendation; another full redesign is unnecessary for this checkpoint.

1. **Explain and offer:** purpose sentence, lesson-first chooser, four visible routes and an explicit unsure fallback.
2. **Teach and transfer:** reading cue, accurately labelled example continuation, direct practice and aligned unseen practice or an honest unavailable state.
3. **Make help and pause useful:** agreed first-question aid behavior, neutral later gates and three-attempt pause with route-appropriate recap.
4. **Make returning truthful:** recent lesson/route context now; exact phase/input/queue restoration before promising it.
5. **Complete notes access and confirm the BYOQ boundary.** Keep them accessible without example completion.

Acceptance requires a zero-attempt student's first-use path and a returning student, on desktop and mobile, across all four goals. Ask after observing: “What is Cramapple helping you do?”, “What would you do next?”, and “How would you use this after your next class?” Include interruption/reopen and no-aligned-content cases. Source review cannot establish comprehension, timings or learning gains.

## Source anchors

All app references below were read at `04e35dbc`:
- `src/components/home/HomeV2.tsx`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeWelcomeBanner.tsx`, `ByoqHomeLink.tsx`.
- `src/lib/practice-entry.ts`, `use-practice-entry.ts`, `home-snapshot.ts`.
- `src/screens/OpenHandMcqScreen.jsx`, `LiveOpenHandTeaching.jsx`, `PracticeMcqScreen.jsx`, `LivePracticeMcq.jsx`, `parts/QuestionPlate.jsx`.
- `src/lib/live-practice-mcq/session.ts`, `bias.ts`, `answered.ts`, `grade.ts`; `src/components/hint/HintGate.jsx`; `src/lib/study-nav/guard.ts`.
- Net Lovable diff `64352ecb → 04e35dbc`.
- Unified recommendation §§3–8, including owner-confirmed published fixes and preview-only status of the latest head.

**Next owner:** implementation conductor / Lovable for the approved unified UX slice; Codex for independent reassessment after implementation; David/student participants for observed first-use validation.
**Next required action:** implement or identify a newer checkpoint containing the unified §3 experience changes, then run the fresh-student and return checks. The independently reviewed head does not yet contain those changes.
**Approval state:** assessment/documentation only. No implementation, publication, production write, QA acceptance or task closure is granted by this report.
