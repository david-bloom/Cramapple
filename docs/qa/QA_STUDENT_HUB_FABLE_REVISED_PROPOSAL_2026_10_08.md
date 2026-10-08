# Student Hub — Fable's Independent Assessment and Revised Proposal

STATUS: EVIDENCE RECORD — findings N1–N8 and §5b–§5d stand; the proposal sections are consolidated with Sol's challenge QA in `QA_STUDENT_HUB_CONSOLIDATED_PLAN_2026_10_08.md`, which governs where the two differ. Originally PR #382, folded into PR #381 at Sol's request.
DATE: 2026-10-08
AUTHOR: Claude (Fable), session `claude/studenthub-qa-optimization-v8j16i`
OWNER: David Bloom
COMPANION: Sol's `QA_STUDENT_HUB_CHALLENGE_2026_10_08.md` (PR #381, findings H1–H15). This document answers the same brief independently, compares the two, and proposes a revised plan. Where the two agree, Sol's finding id is reused.
SCOPE: `/home` for a new student, then the returning student. Planning only. No app, schema, data or deployment change.
NEXT OWNER: Sol (review and merge into one plan), then the implementation conductor for scoped slices.

## 1. Verdict against the brief

David asked whether a new student understands what to do and how Cramapple will help, whether the paths are obvious and clearly different, whether the page renders and loads as designed, and whether there are defects.

| Question | Verdict | Why |
| --- | --- | --- |
| Does a new student understand what to do? | **Partly.** The form is unmistakable; the study choice is not. | Stage A's only headline is "Tell us where your class is". The four doors sit under the form's button, inside the form's box, after the sentence "Cramapple has no work from you yet, so there is nothing to recommend honestly." |
| Do they understand how Cramapple will help? | **No.** | The purpose sentence exists ("Prepare for tests and the AP exam, one lesson at a time") but is the smallest text on the page and is placed under the form. The first screen contains nine statements of what Cramapple cannot do yet (§3) and none of what the student will do in the next ten minutes. |
| Are the paths obvious and clearly different? | **The four doors are the right model; their behaviour is not yet trustworthy.** | The door marked Recommended opens a "coming soon" plate for most lessons outside Units 1–3 of four subjects (N1). A unit-only position is handled three different ways by the three content doors (N2). |
| Does it render and load as designed? | **Unverified.** | Neither Sol nor I had a signed-in session. Responsive CSS exists for 900px and 560px; no screenshot exists. Section 8 lists the ten-minute check David can run. |
| Are there defects? | **Yes: four P1, eight P2.** | §4 and §5. The P1s are data scoping, the unsaved-selection split, the stale-topic save, and the recommended door's dead end. |

The structural choice is sound and should not be reopened: four equal doors, learning from a question recommended but never required, lesson before evidence. What remains is making the doors truthful, putting the explanation where a 16-year-old will read it, and removing the copy that talks about evidence instead of learning.

## 2. Checkpoint, method, limits

- **App head inspected: Lovable `8a97bdca8638951af6bf14a335e4472f6979b086`** (two connector commits after Sol's `d5adcbc6`: PR #380 packages 1 and 2). I diffed `d5adcbc6 → 8a97bdca`: the hub components (`HomeV2.tsx`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeStudyActions.tsx`, `HomeWelcomeBanner.tsx`, `home.functions.ts`, `home-snapshot.ts`, `DeepDiveOverlay.jsx`, `styles.css`) are byte-identical; only `use-published-frq.ts` changed (FRQ readiness now comes from `count_practice_frqs_available`). **Every hub finding in Sol's report therefore still holds at the current head**, with the FRQ half of H8 already addressed.
- Read: `HomeV2`, both stages, `HomeStudyActions`, welcome banner, `home.functions`, `home-snapshot`, `practice-entry`, `use-practice-entry`, `open-hand/teaching`, `open-hand/presentation`, `topic-content`, `taxonomy/adapter` + `remote`, `active-subject`, `SubjectSwitcher`, `_ux.home.tsx`, `_ux.tsx`, `LiveOpenHandTeaching`, `DeepDiveOverlay`, `useEscapeToClose`, `stats-unit1-skills`, hub CSS, the Stage A/B helper tests.
- **Production, read-only (`pcntajvbdfqhbeewmdry`, 2026-10-08):** attempts and positions per student and per pack, entitlements, `student_cell_state`, teaching-item coverage per subject and unit, notes coverage per topic, and the definitions of `get_home_start_queue` and `get_open_hand_teaching_topics`. No writes, no impersonation, no account prefixes beyond those already in the 10-07 assessment.
- Canonical docs: `DECISION-0100` and amendment, the unified recommendation, the minimal clarity plan and its execution record, Sol's second pass, Sol's challenge report (PR #381), PR #380's three reports.
- **Not done:** any signed-in render. `/home` redirects to the marketing login when signed out and the Lovable preview requires a Lovable login. No usability session. Comprehension findings are expert judgment with copy quoted from source.

## 3. What a new student reads today (Stage A, as built)

In page order, with the doors' actual position. Quoted strings are verbatim from `HomeStageANew.tsx` and `HomeStudyActions.tsx`.

1. Optional banner: "Welcome to Cramapple. Your AP Chemistry access is ready. Pick a unit to start."
2. Orientation strip: "Welcome, {first name}" · subject · "N subjects available." · **Where your class is: Not set yet · Cramapple can't estimate this yet · Tell us your unit and topic and the whole page starts working.** · exam countdown with a decorative arc.
3. Orange box, eyebrow **"Start here · 2 minutes"**, headline **"Tell us where your class is"**, "Pick the unit and topic your teacher is on. Everything else follows from it." Then **"Why this: Cramapple has no work from you yet, so there is nothing to recommend honestly. Setting your position is the one thing that makes the next recommendation real."** Two selects: "Choose a unit…" / "Pick a unit first".
4. Right column of the same box: **Set my position →**, then the purpose line "Prepare for tests and the AP exam, one lesson at a time." in note-sized text, then four outline buttons (Learn from a question, Practice on my own, Read lesson notes, Bring a question) with "Set your position first" under them, all disabled except Bring a question.
5. "While you're here · General explainers from your current unit" (only after a position is saved): three static cards, not clickable.
6. "Curriculum · 9 units · 91 topics · **no evidence yet**" with a legend "**Not yet reached** — every topic starts here. Cells fill in as you answer questions. **Nothing is scored until then.**" and a grid of empty squares that never fill on this stage.
7. "What happens next: After 3 graded attempts across 2 questions, Cramapple can say something useful. **Until then it will say it doesn't know.**" · "N subjects · **no work yet**".

That is nine negations before the student has done anything, and the one sentence that says what Cramapple is for is in 14px grey under a button. The doors are inside the form, so the eye reads them as part of filling in the form. A student who does not know their unit number has nowhere to go except the form.

## 4. Findings Sol did not make, or made without the evidence that sets their priority

Priorities: P1 = fix before the new-student experience is accepted; P2 = material improvement.

### N1 — The Recommended door opens a "coming soon" plate for most lessons outside Units 1–3 (P1, source-confirmed, Production-quantified)

`HomeStudyActions.learn()` resolves the destination through `entry.resolve()`; when the lesson has no teaching item the resolver answers `kind: "practice"`, and the hub **ignores that and navigates to `/open-hand-mcq` anyway** (`else void navigate({ to: "/open-hand-mcq" … })`). `LiveOpenHandTeaching` then renders a plate whose Answer Key pane and Question pane both read "A worked example for this topic is coming soon." Sol's H8 names the branch; this is how often it fires.

Production teaching-item coverage (released, published; topic codes matched to the verified taxonomy):

| Subject | Units 1–3 topics with an example | Unit 4 | Notes |
| --- | --- | --- | --- |
| AP Statistics | 40 of 40 | 2 of 10 | |
| AP Chemistry | 28 of 28 | 0 of 9 | |
| AP Biology | 22 of 22 | 1 of 6 | |
| AP Calculus AB | 32 of 32 | 0 of 7 | |
| AP Calculus BC | 24 of 32 | 0 of 7 | Unit 1 first topic has none |
| AP Precalculus | 14 of 44 | 0 of 14 | |
| AP Physics 1 | 10 of 19 | 0 of 4 | Unit 1: 1 of 5 |
| AP Physics C: Mechanics | 4 of 20 | 0 of 4 | Unit 2: 0 of 10 |
| AP Physics 2 (Units 9–11) | 4 of 21 | 0 of 4 | |
| AP Physics C: E&M (Units 8–10) | 4 of 13 | 0 of 8 | |

In October a real AP class is in Unit 2–4. For six of ten subjects the door marked Recommended will, more often than not, open a page that says the recommended thing does not exist. The hub already holds the cached teaching-topics list (`usePracticeEntry` fetches it with `staleTime: Infinity` to compute a label the hub never displays), so availability can be decided before the click at no extra request.

**Fix (Lovable, small):** decide availability on the hub. When the lesson has a teaching item, the door reads *Learn from a question · Recommended*. When it does not, the door reads *Learn from a question · No worked example for this lesson yet* and is disabled, and **Practice on my own** carries the Recommended mark with the line *"Answer questions on this lesson and read the explanation after each one."* Honour the resolver's `practice` answer in the click handler. Never open the "coming soon" plate from the hub.

### N2 — A unit-only position is handled three different ways by the three content doors (P1, source-confirmed, Production-quantified)

Five of the ten saved positions in Production are unit-only (`topic_code` null). For such a student today:

- **Learn from a question** silently resolves to the unit's first topic (`decidePracticeEntry` → `resolveStartTopic`) and opens it under a hub heading that showed only "Unit 2". The unified recommendation §3.2 says a unit-only answer "never silently resolves to the unit's first topic".
- **Practice on my own** sends no topic, so the queue is unit-wide with no bias.
- **Read lesson notes** becomes "Pick a topic to read its notes" and focuses the topic select.

Three doors, three definitions of "this lesson". **Fix:** one rule, stated once above the doors. Recommended: a unit-only position is a valid starting point; the hub shows *"Studying: Unit 2 · pick a topic to narrow it"*; Learn and Practice open unit-wide and say so on the plate ("Unit 2 · first available example"); Notes offers the unit's topics as a short list instead of a disabled button. Whichever rule is chosen, all three doors must follow it.

### N3 — "Worth revisiting" can only ever render AP Statistics Unit 1 (P2, source-confirmed, Production-quantified)

`loadStartQueue` drops any queue row whose `(topicCode, skillCode)` is not in `findPilotSkillByCell`, which is the ten-cell AP Statistics Unit 1 pilot map. For nine subjects, and for Statistics beyond Unit 1, the section is permanently "Nothing due right now" under a second **"Next best action"** eyebrow. Production has 8 `student_cell_state` rows for 2 users in total. Sol's H10 asks for better empty/error states; I would not build them. **Fix:** remove the section from Stage B until a real revisit list exists (a trivial one is "lessons you answered in the last 7 days", from the attempts already loaded). That also resolves H9's duplicate heading.

### N4 — Unit evidence labels can never fill (P2, confirms H7 with the mechanism)

`home.functions.ts` maps every attempt with `unitId: null`; `computeUnitPointCapture` filters on `a.unitId === unitId`, so every Stage B unit card says "Not enough evidence yet" however much the student has done, and the legend's "Evidence label shown when supported" is never true. This cannot be fixed in the client: the attempt row carries `content_item_version_id`, and the unit lives in `app.content_taxonomy_labels`. Until the server joins it, show the unit grid without evidence labels and without the three-state legend.

### N5 — Cross-subject evidence is a real condition, not a hypothetical (confirms H1, Production)

Three of the six students with attempts hold attempts in more than one exam pack. On the owner's account the user-wide qualifying count is 7 while the active pack holds 5, so Stage B's "Based on your 7 graded attempts" is wrong today. Zero attempts have a null pack id, so the "null means in-scope" rule in `scopeToExamPackVersion` protects nothing. **Fix:** `.eq("exam_pack_version_id", versionId)` on the attempts and sessions reads, before the limits. One line each.

### N6 — The stale-topic save is one missing `null` (confirms H3, part two)

`stageAPositionPayload(2, null)` sends `topicCode: undefined`; the server deliberately preserves the stored topic when the key is absent (comment in `setCoursePosition`). Changing Unit 1 · 1.1 to Unit 2 without choosing a topic leaves `topic_code = "1.1"` under `unit_id = 2`. The orientation strip hides it (the lookup finds no 1.1 in Unit 2 and prints the unit title), but all three doors use the snapshot's `topicCode` and open 1.1 content under a Unit 2 heading. Stage B already sends `topicCode: null`; Stage A should do the same. The existing test asserts the wrong behaviour ("without clearing one for unit-only saves") and must change with it.

### N7 — Notes are the most complete content and the least prominent door (P2, Production)

Published notes (brief or explainer) exist for every topic in nine subjects and for 17 of 31 in Physics C: E&M, so "No notes for this topic yet" is rare. Worked examples are sparse (N1). The notes door is the one door that works for every lesson a student can pick, and today it is third, often disabled by the unit-only rule, and its preview cards are not clickable (Sol H9). When no example exists for a lesson, the hub should say so and point at notes and practice.

### N8 — Almost every student sees the subject picker, and it has no saving state (confirms H13, Production)

22 of 25 entitled accounts hold more than one subject, so "Which subject first?" is the first screen for nearly everyone, not an edge case. Its options are `role="radio"` with `aria-checked={false}` permanently, and a click gives no feedback until the hub reloads. Small, but it is the first click.

## 5. Disposition of Sol's H1–H15

| Sol | My reading | Priority I propose | What changes |
| --- | --- | --- | --- |
| H1 cross-subject evidence | **Agree, with data** (N5). | P1 | Scope both reads by pack. Drop the null-pack exception. |
| H2 saved selection clears during taxonomy load | **Agree on the defect, lower the priority.** The summary strip still shows the saved position and the doors still work from the snapshot; the selects are blank and the Set button is disabled until the student re-picks. | P2 | Guard `units.length === 0` as Stage B does. |
| H3 draft vs saved lesson | **Agree.** Prefer the simpler of Sol's two options and go further: **save on change.** Picking a unit or topic persists it at once with an inline "Saved" state; no Confirm button; the doors always read the saved lesson. Plus N6. | P1 | Removes the split rather than labelling it. |
| H4 "Not sure" has no start | **Agree, narrow the fix.** Do not build "Browse lessons" or "Try a starting lesson" in this slice. Ship the already-decided line, **"Not sure? Start me at the beginning"**, which saves the first topic of the first unit with `source: "estimated"` so the strip reads *"Starting point · Change"* rather than "Confirmed by you". Titles before codes in both selects. | P1 | Uses a field that already exists; no new concept. |
| H5 page explains uncertainty more than learning | **Agree, raise to P1.** This is the heart of David's brief. | P1 | §6 layout and copy. |
| H6 thresholds promise capability not delivered | **Agree.** | P1 | Delete the threshold line and the "What happens next" section; hero basis becomes "Based on the lesson you chose". |
| H7 evidence mapping cannot support its labels | **Agree, with mechanism** (N4). | P2 | Hide unit evidence labels and legend until the server joins taxonomy. |
| H8 route availability is not readiness | **Agree.** FRQ half is done at `8a97bdca`; the Learn half is N1. | P1 | N1. |
| H9 shelves have no next step | **Agree, simplify.** | P2 | Explainer and deep-dive cards open the existing notes overlay for that topic. Drop "Worth revisiting" (N3). One "Suggested next" heading. |
| H10 queue failure shown as "Nothing due" | **Agree in principle; moot once N3 removes the section.** | — | — |
| H11 notes overlay accessibility | **Agree.** The project already ships a Radix `dialog.tsx`; use it (focus trap, `aria-modal`, Escape, focus restore come free). Rename "Copy deep dive" to "Copy notes". | P1 (accessibility) | — |
| H12 loading/error recovery | **Agree.** | P2 | Retry on the two subsection errors; a visible message on a failed Learn resolution. |
| H13 subject setup and welcome confusion | **Agree, with data** (N8). | P2 | `aria-checked` on the chosen option, "Saving…" state, retry after a failed auto-select, welcome copy derived from the current step. |
| H14 activity wording | **Agree, low.** | P2 | "minutes (estimated)". |
| H15 rendering readiness | **Agree. Neither of us has seen a signed-in pixel.** | Acceptance blocker | §8. |

**Where I differ from Sol's proposed experience.** (1) The first-use panel should not be dismissible or reopenable; that is state and a control for a sentence. Show the explanation on Stage A for everyone and drop it on Stage B. (2) Keep the decided wording and spelling: "Not sure? Start me at the beginning", US spelling ("practice", not "practise"), and "Free-response questions (FRQs)", which is the AP term students already know, rather than "Written-response". (3) "Studying: [lesson] · Change" is right; I would make it the heading of the doors section, not a line above them. (4) Do not add a dismiss, a "How Cramapple works" link, error states for the queue, or a lesson browser in this round. Every one of those is reasonable; none is needed to make the first visit clear, and David's standing preference is solid and simple.

## 5b. Where Sol's reasoning does not hold, and what is not feasible as written

These are the places where I think the challenge report's logic or its proposed fix fails, as distinct from the priority calls in §5.

| Sol | The problem | What to do instead |
| --- | --- | --- |
| H4 and the proposed experience: "Choose only an available lesson and distinguish that study choice from confirming the teacher's position"; "an optional study choice must not silently overwrite the student's confirmed class position." | This needs two positions per student, a class position and a study choice. `student_course_positions` holds one row per user and pack, and every door reads that one row. The distinction has no storage, so a "Try a starting lesson" that does not overwrite the position cannot be built without a schema change, which Sol's own scope line rules out. | Use the row's existing `source` column: a "start me at the beginning" choice saves `source: "estimated"` and the strip says "Starting point · Change" instead of "Confirmed by you". One row, one lesson, honest label. |
| Proposed experience: a first-use panel "dismissible after use and reopenable from 'How Cramapple works'", while "this need not become a persistent tutorial across sessions." | If the dismissal is not persisted, the panel returns on every load and the dismiss control does nothing useful. If it is persisted, it is the cross-session state David said he does not need. The two sentences cannot both hold. | No dismiss. Show the explanation on Stage A, where every student has zero evidence, and drop it on Stage B. |
| H8: "eligibility must mean renderable, answerable content for this subject/lesson/format"; door table: Practice must offer "renderable selected-lesson content or explicit chosen alternative". | The hub has no per-lesson practice availability to read. `count_practice_frqs_available` is per pack; the MCQ selector is service-role only and runs inside the edge function on entry. Deciding Practice eligibility per lesson on the hub needs a new RPC. | Decide Learn availability on the hub (the teaching-topics list is already cached, N1). Leave Practice always enabled once a lesson is saved and let the practice screen state the scope it served. Add a per-topic count RPC later if the data shows empty practice queues. |
| H8 (second half): "Topic bias does not guarantee an aligned item after the server cap." | True at `d5adcbc6`, stale at `8a97bdca`: `select_student_practice_items` puts the requested topic first server-side and pages by offset (PR #380 package 1). | Drop from the hub plan; it is PR #380's acceptance row. |
| H3 fix: "validate unit-topic membership server-side". | `loadStudentHome` builds `snapshot.units` from the static `@/data/taxonomy`, which Stage B's own comment says "had no AP Chemistry units at all". A server-side membership check against that source would reject valid Chemistry topics. Validation would have to read `taxonomy_topics` for the pack's verified source version, which is new server code for a bug that one `null` fixes (N6). | Send `topicCode: null` on unit-only saves. Validate server-side only when the server function moves to the live taxonomy. |
| H7 placed in the first "reliability" slice with H1–H3 and H8. | H7 is backend only: the unit for an attempt lives in `content_taxonomy_labels`, not on the attempt row, and the frontend cannot derive it. Putting it in the first Lovable slice blocks the slice. | Frontend slice: hide the unit evidence labels and legend. Backend task: join the unit server-side. |
| H10: build "Review suggestions couldn't load" with Retry for the revisit queue. | The section cannot show anything for nine subjects regardless of load success (N3). Error states for a dead section are code without a user. | Remove the section. |
| H2 as P1. | Nothing a student can do is blocked: the strip shows the saved lesson and every door reads the snapshot. The defect is two blank selects and a disabled button. | P2, two-line guard. |

## 5c. Edge cases and implementation risks neither report had

| Risk | Where | Why it matters |
| --- | --- | --- |
| **The subject switcher floats above the notes overlay.** `DeepDiveOverlay` standalone uses `zIndex: 30`; the `_ux` layout's `SubjectSwitcher` is fixed at `zIndex: 40`. A student can open notes and switch subjects without closing them; the overlay then shows the previous subject's notes over the new hub. | `DeepDiveOverlay.jsx`, `_ux.tsx` | Fixed for free by moving notes to the Radix dialog (H11), which renders in a portal above the layout. Add to H11's acceptance. |
| **Save-on-change creates more unit-only positions, not fewer.** My H3 proposal saves the unit the moment it is picked, before a topic exists. Every student who pauses between the two selects writes a unit-only row. | §6.1 step 3 | N2's one rule for unit-only positions stops being a nice-to-have and becomes a precondition of save-on-change. Also debounce or key the mutation to the latest selection so an out-of-order response cannot save an older pick. |
| **"Start me at the beginning" is not Unit 1 for every subject.** AP Physics 2 starts at registry Unit 9 and Physics C: E&M at Unit 8. | H4 fix | Use the first unit the taxonomy returns, never the literal 1. |
| **Availability lookup failure must not read as "unavailable".** If the teaching-topics read errors or returns `entitlement_required`, the hub must not label the Learn door "No worked example for this lesson yet". | N1 fix | Three states: available, unavailable, unknown. Unknown keeps the door enabled and lets the plate explain. Sol's F3 in PR #380 makes the same point for the plate. |
| **Lessons with neither an example nor notes.** Physics C: E&M has 14 topics with no notes and most without an example. | N1, N7 | The doors box must still offer one working door (Practice) and say so; test E&M Unit 11 explicitly. |
| **On a phone the doors are below the form.** `.home-stage-a-start` stacks at ≤900px, so the four doors render after both selects and the Set button, likely below the fold on 390px. | `styles.css` | §6.1 moves the doors into their own box; on mobile the purpose line and the doors must precede the form's selects, or the first screen is still a form. Add a 390px row to H15: doors visible without scrolling past the form. |
| **"Welcome, jsmith2008".** `firstNameFrom` falls back to the email local part; the unified recommendation §3.7 asked for plain "Welcome". Still open. | `home.functions.ts` | One line. |
| **The Recommended line is not announced with its door.** "Recommended: see how…" is a sibling `<p>`, not linked to the button. | `HomeStudyActions.tsx` | `aria-describedby` from each door to its line. |
| **Welcome dismissal is per browser, not per student.** `cramapple.home.welcome.dismissed.v1` has no user scope; PR #380's F8 fixed the same class of bug for attempts. | `home-welcome.ts` | Low; note for the storage-user sweep. |
| **The Radix dialog animates by default.** Shadcn's `dialog.tsx` carries `animate-in` classes; the design system is zero-motion. | H11 | The global `--motion-duration` override already neutralises it; confirm on the screenshot rather than assume. |

## 5d. Consistency with the product vision and standing decisions

| Decision or rule | This proposal | Sol's proposal |
| --- | --- | --- |
| `DECISION-0100`: four equal doors, worked example recommended never required, lesson before evidence. | Kept. The Recommended mark moves to Practice only when no example exists, which is availability, not a gate. | Kept. |
| `DECISION-0100` §4 and the minimal plan: saved-notes store and export are explicitly deferred; copy is partial delivery. | Kept: "Copy them to keep", no "Save as notes", no shelf. | Kept ("durable saved-notes work is optional and separate"). |
| Minimal plan §A: "Open Hand" stays in the plate masthead; the door is "Learn from a question". PR #380: student-facing name is "Worked example". | Kept: door copy says "worked example" and "test question"; the plate is untouched. | Kept. |
| Minimal plan §A: for MCQs explain answer and rationale, do not imply a rubric. | The door line is "See a real test question answered, and why the right answer works", not "asked and scored", because the teaching pool is 186 MCQs and zero FRQs (PR #380 challenge §4). This is a deliberate departure from the unified §3.1 sub-line and needs David's nod. | Keeps "how questions work"; also avoids "scored". |
| `DECISION-0074` mastery rule and the Independence bar. | Untouched; Independence stays at three or more attempts. | Untouched. |
| Design system (`new_design/`): orange/light/Bungee, square, zero motion, responsive. | No new motion, no new palette; the Radix dialog's animation is neutralised by the global rule (§5c). The exam arc is removed, which the unified §3.7 already asked for. | Same. |
| Marketing promise ("Practice the way the test is given", rubric-graded FRQ hero). | The hub makes no FRQ-teaching promise; the FRQ door is practice only and appears only when the count RPC says it will render. The gap between the marketing hero and the MCQ teaching pool is PR #380 §4's open product decision, not the hub's. | Same. |
| David's standing preference: solid and simple. | Removes a button (Confirm), a section (Worth revisiting), a grid, a legend, an arc and sixteen lines of copy; adds one link and one computed label. | Adds a dismissible panel with a reopen link, a lesson browser, queue error states, and a second position concept. |

## 6. Revised proposal: the hub a new student should meet

Stage A, top to bottom. Everything here is existing content and existing routes; Lovable-only; no new backend except where marked.

### 6.1 Layout

1. **Orientation strip** (keep): "Welcome, Ava" · AP Chemistry · exam countdown as one plain line ("34 days to the exam · Mon 4 May"), no arc.
2. **Purpose, in the headline position:** *"Prepare for tests and the AP exam, one lesson at a time."* One supporting sentence: *"Pick the lesson your class is on. Then learn from a worked question, practice on your own, read the notes, or bring your own question."*
3. **Lesson picker (the form, shortened):** heading *"What did your class cover most recently?"* Unit select (titles, "Unit 2 · Compound Structure"), topic select (titles first, codes in grey). **Save on change**, inline *"Saved"*. Under it: *"Not sure? Start me at the beginning"*. No "Start here · 2 minutes", no "Why this", no "Set my position" button.
4. **Doors section**, its own box, heading **"Studying: 2.3 · Intramolecular Force and Potential Energy · Change"** (or *"Studying: Unit 2 · pick a topic to narrow it"*). Four doors, one line each, from the table below. Recommended mark computed from availability (N1).
5. **Notes preview:** three cards from the saved unit, each opening the notes overlay for its topic (H9). Heading *"From Unit 2"*.
6. **Curriculum:** one line, *"9 units · 91 topics"*, no grid, no legend, no "no evidence yet".
7. Nothing else. No "What happens next". No "no work yet".

Stage B keeps its orientation strip and gets the same doors box in place of the hero. "Why this" becomes *"Based on the lesson you chose."* The threshold line goes. Your week stays (questions · minutes, estimated). Independence stays, shown only at three or more attempts. "Worth revisiting" goes (N3). Unit cards lose the evidence label and legend (N4). Deep-dive cards open notes (H9).

### 6.2 Door copy and required behaviour

| Door | Line under the door | Available when | Opens |
| --- | --- | --- | --- |
| **Learn from a question** · Recommended when available | *See a real test question answered, and why the right answer works.* | A teaching item exists for the lesson (N1) | `/open-hand-mcq?topic=` with the saved topic. Never the "coming soon" plate. |
| **Practice on my own** · Recommended when no example exists | *Answer questions on this lesson. Every answer comes with an explanation.* | Always, once a lesson is saved | `/practice-mcq?topic=`. Quiet link beneath: *Free-response questions (FRQs)* when `count_practice_frqs_available` > 0. |
| **Read lesson notes** | *The key ideas for this lesson. Copy them to keep.* | Notes exist for the saved topic (nearly always, N7) | Existing overlay through the Radix dialog (H11); button reads "Copy notes"; "Copied" / "Couldn't copy" inline. |
| **Bring a question** | *Stuck on homework? We'll help you understand it. We won't answer it for you.* | Always | `/byoq`. |

Disabled door text is specific: *"No worked example for this lesson yet"*, *"No notes for this lesson yet"*, *"Pick a lesson first"*. Never "Set your position first".

### 6.3 Copy to delete

"Start here · 2 minutes" · "Tell us where your class is" · "Cramapple can't estimate this yet" · "the whole page starts working" · "Cramapple has no work from you yet, so there is nothing to recommend honestly" · "no evidence yet" · "Not yet reached" · "Cells fill in as you answer questions. Nothing is scored until then." · "Until then it will say it doesn't know." · "no work yet" · "Cramapple gets more specific after 3 graded attempts" · "Based on position, not yet on performance" · "A signal is taking shape" · "Ask again once you've completed at least 3 graded attempts" · "still gathering evidence" · "Provisional" · the second "Next best action".

## 7. Implementation order

Four slices, each reviewable alone. Nothing here authorises implementation; sizes are to help Sol and David weigh them.

| Slice | Content | Findings | Size |
| --- | --- | --- | --- |
| 1. Data and selection correctness | Scope attempts and sessions by pack (N5/H1). Save on change, send `topicCode: null` on unit-only, fix the Stage A test (H3/N6). Guard the empty-taxonomy effect (H2). Decide Learn availability on the hub and honour the resolver (N1/H8). One rule for unit-only positions across the doors (N2), which save-on-change makes a precondition (§5c). | H1 H2 H3 H8 N1 N2 N6 | Small: `home.functions.ts`, `HomeStageANew.tsx`, `HomeStudyActions.tsx`, one test. |
| 2. First-use clarity | §6.1 layout and §6.2 copy on Stage A; doors box shared with Stage B; "Not sure? Start me at the beginning" with `source: "estimated"` (H4); delete §6.3 copy (H5 H6). | H4 H5 H6 | Medium: two stage components, `HomeStudyActions.tsx`, CSS. |
| 3. Shelves and access | Remove "Worth revisiting" (N3/H10). Hide unit evidence labels (N4/H7). Cards open notes (H9). Radix dialog for notes, "Copy notes" (H11). Subsection retries and a visible Learn failure (H12). Subject picker states (H13/N8). "minutes (estimated)" (H14). | H7 H9–H14 N3 N4 N8 | Small to medium. |
| 4. Acceptance | §8 on a named Preview commit, signed in, desktop and 390/320px, then the student protocol already in the unified recommendation §5. | H15 | David's ten minutes plus Sol's independent rerun. |

Backend, later, outside these slices: a server-side unit for each attempt (N4), the B1–B9 requirements already in the unified recommendation, and a real revisit queue.

## 8. Acceptance checks

Sol's matrix stands; these rows are added or sharpened.

| Scenario | Expected |
| --- | --- |
| Lesson with no teaching item (Physics C Mechanics 2.1; Chemistry 4.1) | Learn door disabled with "No worked example for this lesson yet"; Practice carries Recommended; the "coming soon" plate is unreachable from the hub. |
| Unit-only position (Unit 2, no topic) | All three content doors describe the same scope; nothing silently opens topic 2.1 under a "Unit 2" heading. |
| Change Unit 1 · 1.1 to Unit 2 with no topic | Stored `topic_code` is null; no door opens 1.1. |
| Student with attempts in two subjects | Stage, counts and "Based on your N graded attempts" use the active subject only; switching to an untouched subject shows Stage A. |
| Returning Stage A student, cold load | Selects show the saved lesson while the taxonomy loads; nothing clears. |
| Any subject other than AP Statistics on Stage B | No "Worth revisiting" section; no second "Next best action". |
| Notes overlay by keyboard | Focus moves into the dialog, Tab stays inside, Escape and "Return to student hub" restore focus to the door; "Copied" is announced. |
| Signed-in screenshots: desktop, 390px, 320px, Stage A with and without a saved lesson, Stage B | No horizontal scroll, no clipped door, doors box above the fold on desktop, no console errors or failed required requests. |
| Read-through by a student who does not know the term "unit" | Finds a way to start without the form (Not sure link) and can say what the four doors do. |

## 9. What I could not verify and how to close it

| Gap | Close it by |
| --- | --- |
| Rendering at any width | David signs in to the Preview at a named commit and takes five screenshots (the §8 row); or a controlled test account with no attempts. |
| Whether the "coming soon" plate is what a student actually sees from the hub | Click Learn from a question on a Chemistry Unit 4 lesson on the published build. |
| Student comprehension | The unified recommendation §5 protocol, unchanged. |
| Assistance attribution on the Independence bar | PR #380's package 2 validation, not this document. |

## 10. Source map

Lovable `56cae479`, head `8a97bdca`: `src/components/home/HomeV2.tsx`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`, `HomeStudyActions.tsx`, `HomeWelcomeBanner.tsx`; `src/lib/home.functions.ts`, `home-snapshot.ts`, `practice-entry.ts`, `use-practice-entry.ts`, `use-published-frq.ts`, `topic-content.ts`, `open-hand/teaching.ts`, `open-hand/presentation.ts`, `course-mode/stats-unit1-skills.ts`, `taxonomy/adapter.ts`, `taxonomy/remote.ts`, `active-subject.ts`; `src/screens/LiveOpenHandTeaching.jsx`; `src/components/overlay/DeepDiveOverlay.jsx`; `src/components/ui/dialog.tsx` (unused by the hub); `src/routes/_ux.home.tsx`, `_ux.tsx`; `src/styles.css` (`.home-stage-a*`, `.home-stage-b*`, `.home-study-actions`); `src/lib/__tests__/home-stage-a.test.ts`, `home-stage-b.test.ts`.

Production reads (read-only, 2026-10-08): `app.attempts`, `app.student_course_positions`, `app.subject_entitlements`, `app.student_cell_state`, `app.open_hand_teaching_items` joined to `content_items`, `exam_pack_versions`, `exam_packs`, `subjects`; `app.taxonomy_topics` through the verified `taxonomy_source_versions`; `app.topic_point_briefs`, `app.topic_explainers`; function definitions of `public.get_home_start_queue` and `public.get_open_hand_teaching_topics`.

Canonical comparisons: [Sol's challenge QA](QA_STUDENT_HUB_CHALLENGE_2026_10_08.md) · [Unified recommendation](../product/STUDENT_HUB_UNIFIED_RECOMMENDATION_2026_10_07.md) · [Minimal clarity plan](../product/STUDENT_SESSION_CLARITY_MINIMAL_PLAN_2026_10_07.md) · [Execution record](../handoffs/STUDENT_SESSION_CLARITY_EXECUTION_2026_10_07.md) · [Sol's second pass](NEW_USER_FIRST_SEVEN_MINUTES_SECOND_PASS_2026_10_07.md) · `DECISION-0100`.

**Approval state:** Lane 1 documentation proposal only. **Unresolved:** signed-in rendering, comprehension, every item in §9. **Next owner/action:** Sol reviews this against H1–H15 and folds the two into one plan on PR #381; David decides the §5 priority calls and the §6.1 layout; the implementation conductor scopes slices 1–3.
