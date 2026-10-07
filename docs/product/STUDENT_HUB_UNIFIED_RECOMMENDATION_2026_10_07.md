# Student Hub and First Session — Unified Recommendation

STATUS: CURRENT
DATE: 2026-10-07
OWNER: David Bloom (Product Owner)
PREPARED BY: Claude, reconciling two parallel assessments
GOVERNING DECISION: `DECISION-0100` (worked example is recommended, never required; four equal entry points)
TIER: Micro (recommendation only; no code, schema, publication or Production change)

**Inputs reconciled**

| Assessment | Where | Distinctive evidence |
| --- | --- | --- |
| Claude, `claude/ux-evaluation-session-flp1xj` | `docs/product/NEW_STUDENT_FIRST_SESSION_UX_ASSESSMENT_2026_10_07.md` (findings A1–A6, B1–B5, C1–C9, D1–D6; recommendations R1–R15; canvas changes K1–K24) | Production rows for the five Oct 4–6 pilot accounts; PostHog taxonomy (no app events); plate-loop on/off history; three-hubs structure; vocabulary inventory |
| Sol (Codex), `codex/new-user-experience-assessment`, PR #365 | `docs/qa/NEW_USER_FIRST_SEVEN_MINUTES_ASSESSMENT_2026_10_07.md` (findings F1–F10; "recommended first-use choices"; canvas revision brief 1–10; behavior-required list; student validation protocol) | Practice-alignment contract (F4); teaching traversal not persisted (F8); route-appropriate recap; neutral assistance wording; a usability protocol |

Both were made the same morning from the same source head (`64352ecb`), the same Recorder trace,
and the same four artboards. Both received the owner clarification now recorded as `DECISION-0100`.
Neither had a signed-in walkthrough. **Primary concern: the new student. Secondary: the returning
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
| **The door's name** | "Scored example" / "See one scored" — leads with scoring, the differentiator. | "Learn from a question", explained as "See the reasoning behind a test-style question". | **Sol's label, Claude's sub-line.** "Learn from a question" says what the student does; the sub-line says why it is different: *"See how a test-style question is asked and scored."* "Test-style" only where content alignment supports it (Sol §vocabulary). Final word is David's (§6). |
| **First-session length** | Three graded questions, then a stopping-point card (matches `RECOMMEND_MIN_ATTEMPTS`). | "A short first session"; a recap at a small justified set; example-only and notes-only visits are complete visits. | **Both.** Practice route: a pause card after the third graded attempt, because that is the real threshold and the student should be told so. Every other route gets its own factual recap (§3.5). Time label: "a short first session" until measured. |
| **Hints on the first question** | Free and ungated on question 1 (R9a). | Neutral, resource-specific wording; do not remove confirmations without checking the assistance contract. | **Sol now; Claude's as a Product Owner decision.** Ungated hints interact with `DECISION-0074` (no hint before submission for mastery). Reword and merge the two gates immediately (§3.4); whether question 1's aids are free is question 6.2. |
| **"Not sure where my class is"** | Calendar badge ("most classes are in Unit 2–3 in October") and an explicit "start me at the beginning". | Recognisable lesson names, "Browse lessons" / "Try a sample lesson"; the 6-question check must not claim to find the teacher's position. | **All of it except the 6-question check**, which stays cut. |
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
  in grey), a quiet calendar hint ("most classes are around Unit 2–3 in early October"), and two
  explicit alternatives: **Browse lessons** and **Not sure, start me at the beginning**.
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
- **After the third graded attempt, a pause card:** points, the lesson, one sentence of what the
  feedback said, and *"That's enough for Cramapple to start recommending. Back to your hub →"* with
  **Keep going** quiet. Never require the batch to finish. (Claude R4; Sol F7.)
- **First wrong answer:** *"Normal for a first look. The explanation for the one you picked is on the
  left."* (Claude R5; Sol F7.)
- **Assistance wording, now:** rename the gates to the resource ("Show the hint", "Open the lesson
  notes"), one gate not two, consequence stated plainly: *"Using this marks the attempt as guided."*
  (Sol F10; Claude C9.) Whether question 1's aids are free is §6.2.
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
| B3 | Close learning sessions on exit; record `lastAttempt`; stop showing "Resume" for every session ever opened. | Claude D4, R9 | 3.5, 3b.1 |
| B4 | Route-appropriate recap data: example viewed, notes saved, practice summary. | Sol brief 4; Claude R9 | 3.5 |
| B5 | Saved-notes store and export format. | Claude K23; Sol brief 9 | 3.6 |
| B6 | BYOQ answer-boundary verification, including leakage through explanations and exports. | Sol F9 | 3.6 |
| B7 | Assistance classification preserved under the reworded gate; decision on question-1 aids vs `DECISION-0074`. | Sol F10; Claude R9a | 3.4 |
| B8 | Six app events in PostHog: `hub_viewed{stage}`, `door_chosen{door}`, `position_set{unit,topic,was_default}`, `example_viewed`, `answer_submitted{correct,assisted}`, `session_paused{questions,points}`; `$pageview` on. | Claude R11 | every later assessment |
| B9 | Trace the mid-session login-page flash (`DECISION-0097` era build, cross-subdomain cookie, one-pager O2). | Claude D6 | trust on return |

---

## 5. Validation, in order

1. **Signed-in walkthrough on the published build** (David signs in; Claude drives the Recorder path
   and screenshots Stage A, the worked example, practice and the hub at desktop and 390px). Confirms
   what is actually published versus preview-only at `64352ecb`, and the account stage. Neither
   assessment had this.
2. **Sol's student protocol**, adopted as written: a controlled entitled test account with no
   qualifying history; one neutral task ("you just covered a lesson in class, use Cramapple for a few
   minutes to prepare for being questioned on it, then stop when you normally would"); separate
   observations for practice-first, notes-first and own-question students; same-browser and
   other-device return; the three closing questions asked *after* observing. Its eight acceptance
   checks are the exit criteria for §3.
3. **Three questions to the five pilot accounts**, if David is willing: what did you expect to happen
   after choosing your unit; why did you stop; what would bring you back.

---

## 6. Decisions still needed from the Product Owner

1. **The door's name.** "Learn from a question" (recommended here) vs "Scored example / See one
   scored" vs keep "Worked example". The sub-line "See how a test-style question is asked and scored"
   works under any of them.
2. **Question-1 aids.** Free and ungated on the first practice question (Claude R9a), or reworded but
   still gated (Sol F10)? This touches `DECISION-0074`'s "no hint before submission" mastery rule.
3. **First-session pause at three graded attempts** (the real threshold) — confirm, or name a number.
4. **Calendar hint** on the lesson question — keep, or drop as presumptuous.
5. **Who reconciles PR #365 and this branch.** Recommendation: merge both assessments as evidence
   records with a STATUS line pointing here, and treat this document as the single recommendation.

---

## 7. Sequencing and owners

| Order | Work | Owner | Needs |
| --- | --- | --- | --- |
| 1 | §3.1, 3.2, 3.7 on the hub; §3.3 lead line and buttons; §3.4 gate wording and pause card; §3.5 recap for the practice route | Lovable `56cae479` | nothing backend; B3 for the recap's numbers |
| 2 | Canvas updated to match: Stage A + new Stage-A2-Ready; two plate boards (learn-from-a-question, first practice question); Stage B memory card; Main/Mobile primary-action rule | Design canvas `HoaRcFFv8GoiV9VeyDcgYh` | §6.1 |
| 3 | B3, B8 (session close, last attempt, events) | Claude, backend + Lovable | — |
| 4 | B2 (aligned practice contract), B1 (phase persistence), B5 (notes store), B6 (BYOQ boundary) | scoped tasks under `TASK-0048` / `TASK-0052` successors | David's gate |
| 5 | §5 validation | David + Claude, then students | published build |

**Not recommended:** a visual rebuild of the hub ahead of step 1; the 6-question diagnostic; any
"Continue" or "Resume" copy that promises restoration the backend does not yet do.
