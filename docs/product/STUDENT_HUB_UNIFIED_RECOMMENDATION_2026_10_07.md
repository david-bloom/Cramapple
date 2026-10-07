# Student Hub and First Session — Unified Recommendation

STATUS: CURRENT
DATE: 2026-10-07
OWNER: David Bloom (Product Owner)
PREPARED BY: Claude, reconciling two parallel assessments
GOVERNING DECISION: `DECISION-0100` (worked example is recommended, never required; four equal entry points) and its 2026-10-07 amendment (§6 answers)
TIER: Micro (recommendation only; no code, schema, publication or Production change)

**Inputs reconciled**

| Assessment | Where | Distinctive evidence |
| --- | --- | --- |
| Claude, `claude/ux-evaluation-session-flp1xj` | `docs/product/NEW_STUDENT_FIRST_SESSION_UX_ASSESSMENT_2026_10_07.md` (findings A1–A6, B1–B5, C1–C9, D1–D6; recommendations R1–R15; canvas changes K1–K24) | Production rows for the five Oct 4–6 pilot accounts; PostHog taxonomy (no app events); plate-loop on/off history; three-hubs structure; vocabulary inventory |
| Sol (Codex), `codex/new-user-experience-assessment`, PR #365 | `docs/qa/NEW_USER_FIRST_SEVEN_MINUTES_ASSESSMENT_2026_10_07.md` (findings F1–F10; "recommended first-use choices"; canvas revision brief 1–10; behavior-required list; student validation protocol) | Practice-alignment contract (F4); teaching traversal not persisted (F8); route-appropriate recap; neutral assistance wording; a usability protocol |

Both were made the same morning from the same source head (`64352ecb`), the same Recorder trace,
and the same four artboards. Both received the owner clarification now recorded as `DECISION-0100`.
Neither had a signed-in walkthrough at the time; §8 adds one (desktop, returning-student account). **Primary concern: the new student. Secondary: the returning
student.** This document supersedes the *recommendation* sections of both; their findings stand as
the evidence record and are cited by id below.

---

## 1. Where the two assessments agree

Every substantive finding appears in both. The ids differ; the content does not.

| Concern | Claude | Sol | Agreed statement |
| --- | --- | --- | --- |
| The purpose is never stated; setup is clearer than the promise | B1, B5 | F1, F6 | The first screen explains a dependency ("tell us your unit") and an absence ("nothing to recommend honestly"), never why a student would spend five minutes here. |
| The position question stalls or misleads | A2 | F2 | Four of four real users chose the first option; a unit-only choice silently resolves to the unit's first topic. |
| The worked-example screen pushes to *another* example, not to the student's own attempt | A3 | F3 | "Next question" is primary; "Try one on your own" is quiet; a Next can cross into a different unit without saying so. |
| Face-up answers come with no reading task | — | F5 | Everything is shown; nothing says what to notice. (Claude's R3 lead line covers this; Sol names it as a finding.) |
| No stopping point; the batch runs out | A4 | F7 | Practice ends on "You've finished the questions ready for this unit" after ten items. |
| Return is mechanical, not continuous | D3–D5 | F8 | Resume restarts a batch; the worked-example traversal is never persisted; no "last time" memory. |
| Two homework-help promises, one of them fake | C2, C7 | F9 | "Homework helper" is a demand probe; "Ask for help" serves one unit of one subject; "Bring a question" is the real door. |
| Assistance gates discourage the first read | C9 | F10 | Two "Sure you need a hint?" confirmations before the first answer; the reference pane uses the hint gate. |
| Honesty copy crowds out value | B5 | F6 | "Not enough evidence", "no trend yet", "ask again at 25" are each honest and together demoralising. |
| The canvas is a hub design, not a loop design | §8 intro | brief intro | None of the four artboards shows the worked example, the practice feedback, or the finish. |

## 2. Where they differed, and the resolution

| Topic | Claude | Sol | Resolution |
| --- | --- | --- | --- |
| **Shape of the first-session guidance** | A numbered 1-2-3-4 strip (withdrawn by `DECISION-0100`). | A suggested route plus four equal goals. | **Sol's model.** One sentence of purpose; four doors; the example route *recommended* with its reason, never numbered or gated (§3.1). |
| **The door's name** | "Scored example" / "See one scored" — leads with scoring, the differentiator. | "Learn from a question", explained as "See the reasoning behind a test-style question". | **Decided 2026-10-07: "Learn from a question"** (David, §6.1), with the sub-line *"See how a test-style question is asked and scored."* "Test-style" only where content alignment supports it (Sol §vocabulary). "Worked example" may stay as a descriptive word inside the screen. |
| **First-session length** | Three graded questions, then a stopping-point card (matches `RECOMMEND_MIN_ATTEMPTS`). | "A short first session"; a recap at a small justified set; example-only and notes-only visits are complete visits. | **Both.** Practice route: a pause card after the third graded attempt, because that is the real threshold and the student should be told so. Every other route gets its own factual recap (§3.5). Time label: "a short first session" until measured. |
| **Hints on the first question** | Free and ungated on question 1 (R9a). | Neutral, resource-specific wording; do not remove confirmations without checking the assistance contract. | **Decided 2026-10-07: free and ungated on the first practice question** (David, §6.2). Reword and merge the gates everywhere (§3.4). The attempt is still *recorded* as guided when an aid was opened, so `DECISION-0074`'s mastery rule is untouched; what changes is the gate and the tone, not the data. |
| **"Not sure where my class is"** | Calendar badge ("most classes are in Unit 2–3 in October") and an explicit "start me at the beginning". | Recognisable lesson names, "Browse lessons" / "Try a sample lesson"; the 6-question check must not claim to find the teacher's position. | **Lesson titles, "Browse lessons", "Not sure, start me at the beginning"; the calendar hint is dropped** (David, §6.4: visual clutter, not helpful); the 6-question check stays cut. |
| **Practice alignment** | Not examined. | F4: the client only *reorders* a server batch toward the topic; no aligned item is guaranteed; the recorded URL had no topic parameter. | **Adopt F4 as a behavior requirement** (§4). Until it holds, the handoff copy must not promise "one like it". |
| **Instrumentation** | R11: six events; app sends none today. | Not raised. | **Keep R11.** Both assessments had to reconstruct behaviour from database rows and a click trace. |
| **Pilot-account data** | Five accounts; FRQ drafts; 0/1 ×2. | Not available. | **Keep, with the caveat** that the plate loop was off on Oct 5–6 (`DECISION-0097` amendment), so those sessions likely ran the legacy path. |
| **Validation** | Owner signs in; Claude screenshots the path. | A neutral-task usability protocol with first-time and returning students. | **Both, in that order** (§5). |

---

## 3. Unified recommendation — primary: the new student

Ordered as a student meets them. "Lovable" = frontend change in `56cae479`, no backend.

### 3.1 The hub says what this is for, then offers four doors (Stage A, and every stage)

- **One sentence under the greeting:** *"Prepare for tests and the AP exam, one lesson at a time."*
  (Sol's line; it names the purpose and the unit of work.)
- **A "ways in" row for the current lesson**, four doors, each one tap:
  1. **Learn from a question** · *Recommended* · "See how a test-style question is asked and scored."
  2. **Practice on my own** · "Unseen questions, scored."
  3. **Lesson notes** · "Read or save the deep dive for this lesson."
  4. **Bring a question** · "We'll help you understand your own homework question. We won't answer it for you."
- The recommended door is first and visually dominant; the other three are compact and always
  present. Nothing is numbered, locked or sequenced. (`DECISION-0100`; Claude K1 revised; Sol F1, F3.)
- Each door shows the student's own state for this lesson where it exists ("1 example seen",
  "2 of 3 answered", "notes saved"), never a fabricated one.
- Remove "Ask for help" and "Homework helper" everywhere; "Bring a question" is the one name.
  (Claude R7, R9b; Sol F9.)

### 3.2 The lesson question comes before the position form, and the form cannot mislead

- Ask **"What did you cover in class most recently?"** with lesson *titles* grouped by unit (codes
  in grey) and two explicit alternatives: **Browse lessons** and **Not sure, start me at the
  beginning**. No calendar hint (§6.4).
- A unit-only answer leads to choosing a lesson; it never silently resolves to the unit's first
  topic (`resolveStartTopic` today). (Claude K6; Sol F2, brief 2.)
- The 6-question check stays cut. A diagnostic can inform a *practice* recommendation; it cannot
  find the teacher's position, and must never be shown as if it does. (Sol brief 2.)
- Position copy: "Confirmed by you · Change". No "Estimated by Cramapple" until an estimator exists.
  (Claude K13.)

### 3.3 Learn-from-a-question screen: a reading task and a recommended next door

- **Lead line above the key:** *"This one's answered for you. Notice the reasoning that makes the
  correct answer work, and why the tempting one fails. This is how the exam asks and scores it."*
  (Sol F5; Claude R3.)
- **Buttons:** **Try one yourself on this lesson →** (recommended, primary) · **Study another example**
  (quiet; says when the lesson changes: "Next example is 2.5 · Membrane transport") · **Save as
  notes** (on the deep dive, with confirmation) · **Back to hub**. (Sol F3; Claude R3, K23.)
- No "Upload your own question" on the plate; the hub's door covers it.
- "Try one yourself on this lesson" may only say *on this lesson* once §4's alignment requirement
  holds. Until then: **"Try one on your own →"**.

### 3.4 Practice: a first session with a shape, aids that don't scold

- Breadcrumb right slot: **"Question 1 of 3 · a short first session"**.
- **After the third graded attempt, a pause card** (§6.3, decided): points, the lesson, one sentence
  of what the feedback said, then **"Want to keep going?"** with **Keep going →** primary and **Back to
  your hub** beside it. Framing line: *"That's enough for Cramapple to start recommending. Every
  question after this makes the recommendation sharper."* The student is invited onward, not sent
  away; three is the floor, not the session. Never require the batch to finish. (David 2026-10-07;
  Claude R4; Sol F7.)
- **First wrong answer:** *"Normal for a first look. The explanation for the one you picked is on the
  left."* (Claude R5; Sol F7.)
- **First question: aids are free and ungated** (§6.2). The hint and the lesson notes are open on
  question 1 with the line *"Free on your first question. From the next one, opening help is noted
  on your feedback."* The attempt is still recorded as guided if an aid was opened (B7).
- **From question 2: one gate, not two,** named by the resource ("Show the hint", "Open the lesson
  notes"), consequence stated plainly: *"Using this marks the attempt as guided."* No "Sure you need a
  hint?". (Sol F10; Claude C9.)
- A quiet **"See one worked first"** link on the first practice question for students who came
  straight to practice. (Claude K8.)

### 3.5 A finish for every route, not just practice

A factual recap on return to the hub, matched to what happened (Sol brief 4; Claude R9):
- Example viewed → "Plasma membranes · example seen. Suggested next: try one yourself." Viewing is
  never counted as understanding.
- Practice attempted → questions, points, assistance status, one line of feedback.
- Notes saved/exported → "Lesson notes saved" with reopen/export.
- Own question brought → "Guidance in progress" only if that context is actually saved.
No route shows an incomplete-practice warning because no answer was submitted.

### 3.6 Notes and bring-a-question are real doors

- **Lesson notes:** "Copy deep dive" becomes **Save as notes** with a visible confirmation and an
  **export** (copy or download); a **Your notes** shelf on the hub lists saved ones by lesson. Notes
  never count as evidence. (Claude K23; Sol brief 9.) *Needs:* a small saved-notes store, or local
  storage for v1.
- **Bring a question:** the boundary is stated in the door and verified in the implemented BYOQ
  flow, including indirect leakage through rationales, deep dives and exports. The existence of
  `/byoq` is not proof. (Sol F9, behavior list; Claude K24.)

### 3.7 Housekeeping that is cheap and visible

"Welcome" without the email prefix; no decorative exam arc; delete "from your class calendar";
"Copied"/"Saved" confirmations; curriculum grid collapsed to one line on a first visit; explainer
cards are links and sit below the primary action; no upsell or notice above the first action.
(Claude R6, R8, K4, K5, K10, K11.)

---

## 3b. Unified recommendation — secondary: the returning student

### 3b.1 One primary action, chosen from the student's unfinished work

- When meaningful unfinished work exists, **Continue [lesson] · [next phase]** is primary and names
  the phase ("Example seen · next: try one yourself", "Question 7 of 10"). After a completed activity,
  a new recommendation is primary. For a notes-first student, **Reopen [lesson] notes**. The four
  doors stay visible beneath. (Sol brief 5–7; Claude K18.)
- "Continue" may only promise what is actually restored. Today practice restarts the batch at index
  0 and the worked-example traversal lives in component state (Sol F8), so until §4 lands the
  card says **"Last time: …"** and offers the doors, not "Resume".

### 3b.0 Interim, decided 2026-10-07: personalized accounts route to Stage B

David, on seeing the legacy TopicHome (Points mode, Learn/Points/Ask for help/Homework helper bar) on
his own `personalized` account during the §8 walkthrough: **"route personalized accounts to Stage B
for now."** `HomeV2.tsx` renders `HomeStageBBuilding` for all three stages until the personalized
board is built; three Stage B copy lines become conditional on `canRecommend` ("Here's where you
are", a why-this that cites the attempt count, no threshold line); `TopicHome.tsx` stays in the
codebase unmounted. Built in Lovable `56cae479` the same day as commit `ed1b4715` (3 files: `HomeV2.tsx`,
`HomeStageBBuilding.tsx` with an exported `stageBCopy` helper, `home-stage-selection.test.ts`; full suite
676 tests, typecheck and build clean; diff reviewed by Claude). **Preview only; David publishes.** This closes A6 / F9 / C7 on the student path at once and makes §3.1's four-door hub a
single-structure change.

### 3b.2 A memory card instead of evidence disclaimers (Stage B)

Replace the Pulse + Independence pair, which both say "not enough evidence" by construction below
the threshold, with one **recent-lesson card** (lesson, last phase, suggested next) and a single
restrained note: *"Recommendations get more personal as you practice. You're at 2 of 3."*
(Claude K14, K15; Sol F6, brief 5–6.)

### 3b.3 Established student (Main, Mobile)

- Distinguish **Your class: Unit 5** from **Suggested review: Unit 4**, and say why the arrow points
  back, from evidence ("your last attempts missed this reasoning step"). (Sol brief 7.)
- The hero says what the next activity teaches or checks, not only recoverable points. (Sol brief 8.)
- "So far" tiles degrade individually at zero; streaks and "points waiting" wait for their backend;
  "Share these" is cut for launch. (Claude K19.)
- For AP Biology and AP Statistics, the FRQ recommendation routes through a worked FRQ first, as the
  recommended door, never as a gate. (Claude K20, R13.)
- Mobile gets the same hierarchy: lesson context, the primary start-or-continue card and its phase
  above the fold; countdown and curriculum compact; the canvas's unreworked mobile frame is not
  shipped as final. (Sol brief 10; Claude K12, K22.)

---

## 4. Behavior the design promises require (merged, to scope as tasks)

| # | Requirement | Source | Blocks |
| --- | --- | --- | --- |
| B1 | Persist lesson, phase, current worked item, practice queue position and unfinished input; define same-device vs cross-device. | Sol F8, list 1 | 3b.1 "Continue" |
| B2 | Serve an *unseen, lesson-aligned* practice item after a worked example, or show an explicit "no practice for this lesson yet" state. The client's reorder-a-batch is not a contract. Reproduce the topic-less `/practice-mcq?from=open-hand` handoff first. | Sol F4 | 3.3 "on this lesson" |
| B2a | **Fix the dropped topic on the Open Hand → Practice handoff** (§8 W4): route through the router's `search` object, not `URLSearchParams`; test with a numeric-looking topic code. Frontend only. | §8 W4 | 3.3 |
| B2b | **Practice never opens on an already-submitted item** (§8 W5): skip or exclude items with a stored attempt for this student; show how many unseen remain. Frontend first; server selector follow-up. | §8 W5 | 3.3, 3.4 |
| B3 | Close learning sessions on exit; record `lastAttempt`; stop showing "Resume" for every session ever opened. | Claude D4, R9 | 3.5, 3b.1 |
| B4 | Route-appropriate recap data: example viewed, notes saved, practice summary. | Sol brief 4; Claude R9 | 3.5 |
| B5 | Saved-notes store and export format. | Claude K23; Sol brief 9 | 3.6 |
| B6 | BYOQ answer-boundary verification, including leakage through explanations and exports. | Sol F9 | 3.6 |
| B7 | Assistance classification preserved: a question-1 attempt with an opened aid is recorded as guided even though no gate was shown, so `DECISION-0074` is unaffected. | Sol F10; Claude R9a; §6.2 | 3.4 |
| B8 | Six app events in PostHog: `hub_viewed{stage}`, `door_chosen{door}`, `position_set{unit,topic,was_default}`, `example_viewed`, `answer_submitted{correct,assisted}`, `session_paused{questions,points}`; `$pageview` on. | Claude R11 | every later assessment |
| B9 | Trace the mid-session login-page flash (`DECISION-0097` era build, cross-subdomain cookie, one-pager O2). | Claude D6 | trust on return |

---

## 5. Validation, in order

1. **Signed-in walkthrough on the published build.** Done at desktop on 2026-10-07 for the
   returning-student path (§8): found two P0 bugs (W4, W5). Still owed: phone width, and Stage A on an
   account with zero attempts (a controlled test account, not a reset of a real student).
2. **Sol's student protocol**, adopted as written: a controlled entitled test account with no
   qualifying history; one neutral task ("you just covered a lesson in class, use Cramapple for a few
   minutes to prepare for being questioned on it, then stop when you normally would"); separate
   observations for practice-first, notes-first and own-question students; same-browser and
   other-device return; the three closing questions asked *after* observing. Its eight acceptance
   checks are the exit criteria for §3.
3. **Three questions to the five pilot accounts**, if David is willing: what did you expect to happen
   after choosing your unit; why did you stop; what would bring you back.

---

## 6. Product Owner decisions (answered 2026-10-07; recorded as the amendment to `DECISION-0100`)

1. **The door's name: "Learn from a question."** Decided.
2. **Question-1 aids: free and ungated on the first practice question.** Decided. Still recorded as
   guided (B7).
3. **First-session pause.** *Clarification of what was asked:* the pause card (§3.4) appears after a
   fixed number of graded attempts in a practice session. The proposal is **three**, because three
   graded attempts across two questions is the real threshold at which the hub can start
   recommending (`RECOMMEND_MIN_ATTEMPTS`), so the card can truthfully say "that's enough for
   Cramapple to start recommending". "Confirm, or name a number" meant: accept three, or choose
   another count (five, say) and the card's sentence changes to match. **Decided: three.** David's
   framing: Cramapple has what it needs after three, but gets more from every further answer and the
   student may well want to continue, so the card asks **"Want to keep going?"** with continuing as
   the primary and the hub as the alternative.
4. **Calendar hint: dropped.** Decided.
5. **Landing the two assessments:** both merge as evidence records with a STATUS line pointing to
   this document, which is the single recommendation. Decided.

---

## 7. Sequencing and owners

| Order | Work | Owner | Needs |
| --- | --- | --- | --- |
| 1 | §3.1, 3.2, 3.7 on the hub; §3.3 lead line and buttons; §3.4 gate wording and pause card; §3.5 recap for the practice route | Lovable `56cae479` | nothing backend; B3 for the recap's numbers |
| 2 | Canvas updated to match: Stage A + new Stage-A2-Ready; two plate boards (learn-from-a-question, first practice question); Stage B memory card; Main/Mobile primary-action rule | Design canvas `HoaRcFFv8GoiV9VeyDcgYh` | §6.1 |
| 3 | B3, B8 (session close, last attempt, events) | Claude, backend + Lovable | — |
| 4 | B2 (aligned practice contract), B1 (phase persistence), B5 (notes store), B6 (BYOQ boundary) | scoped tasks under `TASK-0048` / `TASK-0052` successors | David's gate |
| 5 | §5 validation | David + Claude, then students | published build |

---

## 8. Published-build walkthrough, 2026-10-07 **[live]**

Done signed in as the Product Owner through his own Chrome (Claude in Chrome extension), on
`app.cramapple.com`, 15:05–15:10 UTC, desktop width. The account is at the `personalized` stage with
AP Chemistry active, so this is the returning-student path; Stage A was not reachable on this account.
Screenshots in `docs/product/assets/first-session-walkthrough-2026-10-07/`.

| # | What the live build showed | Confirms / adds |
| --- | --- | --- |
| W1 | `/home` opened in **Points** mode because the mode is remembered in local storage from the last visit: "Your points so far", "No graded evidence in this unit yet", "0 of 9 units with evidence", with the **Learn · Points · Ask for help · Homework helper** bar above it. (`01`) | A6, C7, F9 live. A returning student can land on the less useful mode without choosing it. |
| W2 | In Learn mode the hero reads **"Nothing due right now — Pick a unit and topic above to build ahead"** above **See a worked example →**, **Resume session**, **Pick something else**. Below: "Your class is on Unit 1 · 1.1" captioned *"Our best guess from your class calendar"*. (`02`) | C4 live (no calendar exists); D4 live (Resume shown). |
| W3 | **Open Hand renders correctly** on the published build: subject label, "1.1 · Moles and Molar Mass", face-up key with four rationales, reference pane from the topic guide, deep dive. Primary **Next question**, quiet **Try one on your own**, **Upload your own question**. (`03`) | A3 live. The 2026-10-06 fixes under `TASK-0052` are published. |
| **W4** | **The Open Hand → Practice handoff drops the topic.** The hub sends `?topic=%221.1%22` (the router JSON-encodes the string) and Open Hand loads 1.1. "Try one on your own" lands on `/practice-mcq?from=open-hand` with **no topic**. Cause: the Open Hand screen builds the URL with `URLSearchParams` (`topic=1.1`, unquoted); the practice route's validator is `z.string().optional().catch(undefined)`; the router parses `1.1` as a number, the string check fails, and `.catch` discards it silently. Confirmed independently: typing `/open-hand-mcq?topic=1.1` by hand was rewritten to `?from=home`. **Every topic code shaped `N.N` is affected, which is all of them.** The practice bias toward the lesson never applies from this handoff. | Root-causes Sol F4's "topic-less handoff". New P0 bug. Fix: navigate through the router's `search` object (or JSON-encode in the URL) in `LiveOpenHandTeaching.startPractice` and `goWorkedExample`; add a test with a numeric-looking code. |
| **W5** | **Practice served two already-answered questions in a row, pre-graded.** The first item was this morning's glucose question with the old verdict already shown ("Your answer 1.00 mol · 0/1 · Hints used: Topic hint, Reference materials"); **Next question** gave this morning's photoelectron question, also pre-graded (1/1). The queue repeats the same server batch across sessions and the client replays stored attempts. A returning student who clicks "Try one on your own" must page past old graded questions to reach anything new, with no sign of how many are left. (`04`, `05`) | Confirms Sol F4/F8 and requirement B2: "unseen" is not guaranteed. New P0: the practice list must exclude items this student has already submitted, or start at the first unanswered one. |
| W6 | "Questions seen: 3 · this device" counter in the study nav; **Student hub** and **Change topic** links work. | The 2026-10-07 02:00 preview-only work is in fact published. |
| W7 | **Phone width not captured.** Resizing the window to 390×844 through the extension did not change what the screenshot tool returned (still 1131 px wide). Mobile stays unverified. | Validation step 1 is half done: desktop yes, phone no. |

**What this changes in the plan above.** Two P0 bugs sit underneath the copy and structure work in §3
and must land first or alongside it, because they break the recommended door even when the words
are right: W4 (the topic is lost between the worked example and practice) and W5 (practice shows
already-graded questions first). Both are frontend-only in `56cae479`; W5 may also want the server
selector to skip submitted items. They are added to §4 as B2a and B2b.

**Not recommended:** a visual rebuild of the hub ahead of step 1; the 6-question diagnostic; any
"Continue" or "Resume" copy that promises restoration the backend does not yet do.
