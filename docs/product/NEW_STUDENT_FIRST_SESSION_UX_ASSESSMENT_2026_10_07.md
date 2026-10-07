# New Student First Session — UX Assessment

STATUS: CURRENT
DATE: 2026-10-07
OWNER: David Bloom (Product Owner)
AUTHOR: Claude (session `claude/ux-evaluation-session-flp1xj`)
TIER: Micro (read-only assessment; no code, schema, or Production change)
SCOPE: A student's first arrival at `app.cramapple.com/home` and the next 5–7 minutes, plus the
path back in on a later day.

## 0. Evidence labels used in this doc

| Label | Meaning |
| --- | --- |
| **[code]** | Read directly from the live Lovable source of the App project `56cae479` (HEAD `64352ecb`, 2026-10-07) or Marketing project `61dd6602`. Not rendered or clicked. |
| **[live]** | Observed in a browser on `cramapple.com` / `app.cramapple.com`, signed out. |
| **[data]** | Queried read-only from Supabase Production (`pcntajvbdfqhbeewmdry`) on 2026-10-07. |
| **[doc]** | Taken from a canonical repo doc (`ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`, `TASK-0048`, the 2026-10-04 checkout handoff). |
| **[recording]** | A Chrome DevTools Recorder export of the Product Owner's own signed-in walkthrough on 2026-10-07 (click path and selectors only; no timings, no screenshots). Account is at the `personalized` stage, active subject AP Chemistry. |
| **[unverified]** | Could not be checked this session; stated as a gap, not a finding. |

**What was not done:** a signed-in walkthrough of Production. Creating or signing into an account on
the live site is outside what an assistant may do autonomously, so every screen description below
is reconstructed from source. TASK-0048 itself records that Stage A/B have "never had signed-in
visual QA" **[doc]**. Section 8 says how to close that gap in ten minutes.

---

## 1. Verdict in four answers

David's four questions, answered first; the evidence follows.

| Question | Answer | Confidence |
| --- | --- | --- |
| **Is it obvious what to do next?** | **Partly, then no.** The first screen has exactly one job ("Tell us where your class is") and says so. After that the product stops narrating: the worked example does not say why the answer is showing or what comes after it, Practice does not say how many questions make a first session, and the session ends on a dead-end notice. | High **[code]** |
| **Can they see the value easily?** | **No, not inside 7 minutes.** The differentiator (see one worked, then earn points on your own, with criterion-level feedback and repair) is never *stated* anywhere in the app. It has to be inferred from a button label that changes depending on content availability. The marketing hero promises a rubric-graded FRQ; the first in-app step is an MCQ with every option pre-marked. | High **[code]** **[live]** |
| **Are we guiding them well?** | **The guidance is honest but passive.** Every screen explains what Cramapple *can't* say yet ("nothing to recommend honestly", "Until then it will say it doesn't know", "No trend yet") and almost nothing about what the student should *do* in the next five minutes. Three different home layouts appear in a student's first three visits. | High **[code]** |
| **Is it easy to get back in?** | **Mechanically yes, motivationally no.** Sign-in is a 6-digit emailed code with a one-per-minute limit; there is no next-day email, no "last time you…" recap (that field is hardcoded `null`), and the "Resume session" button is shown for every session because the practice screens never close one. | High **[code]** **[data]** |

**The one-line diagnosis.** The product is built around a loop (set position → see it worked → do one
for points → get told what's next), but the loop exists only in the code's routing table. No screen
tells the student the loop exists, where they are in it, or when a step is done.

---

## 2. What real pilot students did **[data]**

Six accounts were created in Production in the last 21 days (five between 2026-10-04 and 10-06,
one on 09-23 that is almost certainly an internal account with all ten subjects). Only account
prefixes are listed; no emails were read.

| Account | Set position? | First session | What happened | Came back? |
| --- | --- | --- | --- | --- |
| `439d88e5` (10-06) | Unit 1 · 1.1 | MCQ practice | Two MCQs, **both wrong (0/1, 0/1)**, 5 min apart, then left. Session never closed. | No |
| `f6216fbc` (10-05) | Unit 1 · 1.1 | FRQ practice | Opened an FRQ screen, a draft attempt was auto-created, **never submitted**. Did the exact same thing again on 10-06. Two open sessions. | Once, same outcome |
| `7e1cdcfc` (10-05) | Unit 1 · 1.1 | FRQ practice | Opened an FRQ screen, draft auto-created, **never submitted**, left. | No |
| `86685859` (10-04) | No | None | Has an entitlement, never set a position, never started anything. | No |
| `0025c0c0` (10-05) | No | None | No entitlement row, no activity. (Possibly an abandoned checkout.) | No |

Four things this small sample already says loudly:

1. **Every student who set a position chose Unit 1, Topic 1.1** — the first option in both
   dropdowns. In October a real AP class is in Unit 2–4. Either they picked the first thing to get
   past the form, or they interpreted "where your class is" as "where the course starts". Either
   way the one piece of data the hub asks for is wrong for all three, and it drives *everything*
   downstream (which worked example, which practice items, which explainers).
2. **Three of four active students ended up on an FRQ screen and never submitted.** Home's "Start
   practice" routes to the MCQ worked example, so how they reached FRQ practice is not visible
   (the app records no navigation events, see §6). An unsubmitted draft after one or two seconds
   is a student who looked at a full free-response prompt as their first task and closed the tab.
3. **The one student who did MCQs got two wrong and quit.** Nothing in the flow says "two in,
   one more and we can tell you something". The first practice experience was two red verdicts.
4. **Nobody reached the "personalized" home** (it needs 3 graded attempts across 2 items). So the
   student hub that most of the design work targets has never been seen by a real student.

**Caveat:** n=5, friends-and-family pilot, $1 promo. It is directional, not statistical. But it
matches David's observation ("students seem to struggle to know what to do next") exactly.

## 2b. The Product Owner's own walkthrough **[recording]**

David recorded a signed-in session with Chrome's Recorder (desktop, 1210×1279). The export has no
timestamps or screenshots, but the click path is unambiguous. His account is `personalized`, so he saw
the legacy `TopicHome`, not Stage A. The path, with what it shows:

| Step | What the recording shows | What it tells us |
| --- | --- | --- |
| Sign in with emailed code → `/home` | Lands on `TopicHome` (mode bar **Learn · Points · Ask for help · Homework helper**). | A student with 3+ attempts gets the legacy hub (A6). |
| Picks Unit 1 in the madlib select | First option again. | Even the owner reaches for Unit 1 when the picker has no calendar hint (A2). |
| Clicks **Points**, then **Ask for help** | `/ask` is the AP Statistics Unit 1 homework flow; for a Chemistry student every pasted question ends in "We can't help with this yet". He left by typing `/home` into the address bar rather than the page's own "← Back to home". | "Ask for help" is offered on every subject's hub but only works for one unit of one subject (new finding **C7**). |
| Clicks **Homework helper** | The "coming soon" demand probe. | Two adjacent buttons that both lead nowhere useful. |
| **Bounced to `cramapple.com/login?redirect=/home`** mid-session, then back on `/home` with no code entered | A visible round-trip through the login page while already signed in. | Cross-subdomain auth flash (one-pager **O2**). Cause not determined here; it is the kind of thing that makes a 15-year-old assume they were logged out (new finding **D6**). |
| **See a worked example →** (from the *Points* hero) | AP Chemistry Open Hand MCQ. Clicks a distractor (free exploration works), **Next question**, **Show me the deep dive**. | Primary action on Open Hand is "Next question" (A3). |
| Clicks **Copy deep dive** twice, then its icon | No "Copied" confirmation exists (`DeepDiveOverlay.jsx` fires `clipboard.writeText` silently). | New finding **C8**: a button with no feedback gets clicked three times. |
| **Try one on your own** → `/practice-mcq?from=open-hand` | | The intended step 3. Page title asserted as empty at navigation. |
| **Give me a hint** → "Sure you need a hint?" → **Yes, show me**; **Show me the reference materials** → "Sure you need a hint?" → **Yes, show me** | Two consecutive two-step confirmation gates before the first answer. Each gate's copy warns about a "cost" that is listed on feedback. | New finding **C9**: the gating is doing the opposite of what the first seven minutes need. A new student should be *encouraged* to read the reference and the hint on question one, and told it is free the first time. |
| Picks "1.00 mol", **Submit answer**, **Next question**; changes mind Neon → Magnesium, **Submit answer** | Two graded answers. | The loop works mechanically. |
| **Show me the deep dive**, **Copy deep dive**, **Back to the question**, **Student hub** | Returns to `TopicHome`. | |
| **Explore units** | Scrolls to the madlib picker. End of recording. | After two graded answers the hub still says "Nothing due right now. Pick a unit and topic above to build ahead." There is no "you just did 2 questions on 1.1" anywhere (D3). |

Three things the recording settles that the source read could only suggest: the Ask-for-help dead
end for non-Statistics subjects, the silent copy button, and the double hint-gate. One thing it
raises that nothing else did: the login-page flash mid-session.

---

---

## 3. The first seven minutes, as built **[code]**

Reconstructed from the live source. Times are estimates for a motivated student who reads.

### 0:00 — Arrival
Post-purchase page: "Welcome to Cramapple. Your access is unlocked. If you already have a 6-digit
code from Cramapple, enter it below." → code → `app.cramapple.com/home?subject=biology&welcome=1`.

### 0:20 — Home, Stage A (`HomeStageANew.tsx`)
- Dismissible banner: **"Welcome to Cramapple — Your AP Biology access is ready. Pick a unit to start."**
- Heading: **"Welcome, {firstName}"** — `firstName` falls back to the part of the email before `@`
  when the account has no name, so a code-sign-in student sees "Welcome, jsmith2008" (`home.functions.ts`).
- Orientation strip, three cells: subject + "1 subject · Your only subject so far"; **"Where your
  class is — Not set yet — Cramapple can't estimate this yet"**; an exam countdown with a decorative
  SVG arc that is not data-driven (TASK-0048 finding 1).
- Hero: eyebrow **"Start here · 2 minutes"**, **"Tell us where your class is"**, "Pick the unit and
  topic your teacher is on. Everything else follows from it." Then a **"Why this:"** box:
  *"Cramapple has no work from you yet, so there is nothing to recommend honestly. Setting your
  position is the one thing that makes the next recommendation real."* Two selects (Unit, Topic;
  options are `1.1 · Topic title`), one button **"Set my position →"**.
- Below the fold: **"Curriculum — 8 units · 50 topics · no evidence yet"**, a grid of empty cells
  with the legend "Not yet reached — every topic starts here. Cells fill in as you answer questions.
  Nothing is scored until then." Then **"What happens next — After 3 graded attempts across 2
  questions, Cramapple can say something useful. Until then it will say it doesn't know."** Then a
  "Bring your own question" link and **Log out**.

What a student can and cannot learn from this screen: they can learn that Cramapple wants a unit.
They cannot learn what Cramapple *is for*, what a session looks like, how long one takes, or that
there is a two-step worked-then-practice method. The word "worked example" does not appear until
after they submit the form.

### 1:30 — Position set
The page re-renders in place. Button row becomes **"Set my position →"** (now quiet) plus
**"See a worked example →"** (primary) — or **"Start practice →"** if no teaching item exists for
that topic, in which case the student skips Open Hand entirely without knowing it existed. A new
section **"While you're here — General explainers from your current unit"** shows up to three
cards. **These cards are plain `<article>`s with no link** — there is nothing to click.

### 2:00 — Open Hand MCQ (`/open-hand-mcq`, `OpenHandMcqScreen.jsx`)
- Study nav: **Student hub · Change topic · Subject ▾**.
- Plate masthead: course name + **"OPEN HAND"**; breadcrumb: course › `1.1 · Topic`; status **"Worked example"**.
- Left pane, eyebrow **"Face-up"**, title **"Answer Key"**: *"Nothing is scored here. Every option
  is marked, with why it is right or wrong."* followed by each choice's rationale.
- Centre pane: the question, chip **"Not scored"**, every option already tagged Correct / Distractor.
- Buttons: **"Next question"** (primary), **"Try one on your own"**, **"Upload your own question"**.
- Right pane: Reference (topic notes), **"Show me the deep dive"**.

Four names for one idea on one screen (Open Hand, Worked example, Face-up, Not scored), and the
primary button keeps the student *in* worked examples rather than moving them to the step that
earns points. Nothing says "this is step 2 of 3" or "read this, then try one".

### 3:30 — Practice MCQ (`/practice-mcq`, `PracticeMcqScreen.jsx`)
- "Loading practice questions — One moment — we're setting up your session."
- Left pane **"Practice · Hints"**: *"One point. One submission. The key stays closed until you
  commit."* then hint gates, each with a "cost" sentence ("This shows the answer move for this topic
  before you commit, and is listed on your feedback.").
- Centre: question, "Pick one answer" → **Submit answer** → Feedback card (verdict chip, score chip,
  coaching line) + the left pane flips to the Answer Key with every rationale. Primary becomes
  **"Next question"**. Secondary before submit: "Skip for now".
- Right pane: Reference is *gated* until submission; deep dive behind a hint gate.

This is the best screen in the flow: the feedback is real, specific, and immediate. But it gives
no sense of progress toward anything. The study nav shows "Questions seen: N · this device", which
is a browser-local counter, not progress.

### 5:00–7:00 — Keep going, then a dead end
Up to 10 items are served. After the last: **"You've finished the questions ready for this unit."**
with **Return Home** / **See a worked example**. The learning session is never ended (`ended_at`
stays null) **[data]**, so the hub will show a "Resume session" button indefinitely, and "Resume"
just starts a fresh item list.

### Back on Home — a different page
- After 1–2 graded attempts: **Stage B** ("Welcome back, … We're still building a reliable picture
  from your work." / "Your best 10 minutes — Practice where your class is right now. Based on
  position, not yet on performance." / Pulse / "Guided → independent: Ask again once you've
  completed at least 3 graded attempts" / "Worth revisiting: Nothing due right now" / Curriculum
  "Provisional" / Deep dives).
- After 3 graded attempts across 2 items: the **legacy `TopicHome`** — a mode bar (**Learn · Points ·
  Ask for help · Homework helper**), "Next best action — Nothing due right now. Pick a unit and
  topic above to build ahead.", a madlib "Your class is on [Unit ▾] [Topic ▾]" captioned *"Our best
  guess from your class calendar"* (there is no class calendar), a topic point brief with
  **"Learn more"** / **"Get started →"**, and Log out.

Three structurally different homes in three visits, with different vocabularies and different
primary actions. TASK-0048 flagged this as "finding 2 — product call" and it is still open **[doc]**.

---

## 4. Findings, by David's four questions

### 4.1 "Is it obvious what they should do?"

| # | Finding | Evidence |
| --- | --- | --- |
| A1 | The only clearly-stated action is the position form. After it, the primary button's *label* is the sole guidance, and that label is content-dependent ("See a worked example" vs "Start practice"). | [code] `practice-entry.ts`, `HomeStageANew.tsx` |
| A2 | The position form has no default and no hint about the calendar. All three real students picked the first option. | [data] [code] |
| A3 | Open Hand's primary button is "Next question", which loops worked examples. The step that earns points is a quiet secondary button. | [code] `OpenHandMcqScreen.jsx` |
| A4 | Practice has no session length, no progress indicator, and no stopping point. It serves 10 and ends with "You've finished the questions ready for this unit", which reads as "the product is out of content". | [code] `LivePracticeMcq.jsx` |
| A5 | The "While you're here" explainer cards on Stage A are not links. | [code] `HomeStageANew.tsx` |
| A6 | Three hubs (Stage A, Stage B, TopicHome) with three primary-action vocabularies: "Set my position / See a worked example", "Confirm / Start practice", "Start practicing / Get started / Learn more / Pick something else / Explore units". | [code] |

### 4.2 "Can they see the value easily?"

| # | Finding | Evidence |
| --- | --- | --- |
| B1 | No screen states the method. The closest is the Stage A "Why this" box, which explains an *absence* ("nothing to recommend honestly"). | [code] |
| B2 | Marketing hero (live): a rubric-scored FRQ with "Describe the association +2 / Interpret the slope +1" and "Try one on your own →". First in-app step: an MCQ with pre-marked options. The thing the student was sold is two screens and one subject-capability check away. | [live] [code] |
| B3 | The first practice feedback is the first moment of value, and for the one student who got there it was two "Incorrect" verdicts with no framing ("that's normal, one more and we can say something"). | [data] [code] |
| B4 | Criterion-level FRQ feedback — the vision doc's stated core value (§2.3) — is not reachable from Home's primary path at all; Home only routes to the MCQ worked example. | [code] `practice-entry.ts` [doc] `CRAMAPPLE_VISION.md` |
| B5 | Everything with evidence on the hub is below the recommendation threshold for a new student, so the hub is a page of honest empty states: "no evidence yet", "Nothing due right now", "No trend yet", "Ask again once you've completed…". Honest is right; *only* honest is demoralising. | [code] |

### 4.3 "Are we guiding them well?"

| # | Finding | Evidence |
| --- | --- | --- |
| C1 | Vocabulary inventory a new student meets in 7 minutes (student-facing strings): Student hub · Home · Study home · Set my position · Where your class is · Worked example · Open Hand · Face-up · Answer Key · Not scored · Practice · Scoring · Hints · cost · Reference · Deep dive · Topic notes · Point brief · Explainer · Learn more · Next best action · Pulse · Guided → independent · Worth revisiting · Provisional · Curriculum · Session · Resume session · Change topic · Bring a question · Bring your own question · Upload your own question · Homework helper · Ask for help · Learn / Points. That is ~35 terms for a 4-step loop. | [code] |
| C2 | Three different names for bringing in an outside question (Bring a question, Upload your own question, Homework helper "coming soon"), two of which sit next to each other on the same screens. | [code] |
| C3 | "Welcome, {email-prefix}" for name-less accounts. | [code] `home.functions.ts` |
| C4 | TopicHome caption claims "Our best guess from your class calendar"; no calendar exists. | [code] `TopicHome.tsx` |
| C5 | Decorative exam gauge arc looks like progress but is static. | [code] [doc] TASK-0048 f.1 |
| C7 | "Ask for help" is on every subject's hub mode bar but `/ask` serves AP Statistics Unit 1 only; every other subject's question is declined after the student has pasted it and answered "Where's this from?". | [code] `ask.tsx` [recording] |
| C8 | "Copy deep dive" gives no confirmation; the owner clicked it three times. | [code] `DeepDiveOverlay.jsx` [recording] |
| C9 | Hint and Reference each sit behind a two-step "Sure you need a hint?" gate with "cost" copy. On question one of a first session this is friction against the very thing we want them to read. | [code] `HintGate.jsx`, `PracticeMcqScreen.jsx` [recording] |
| C6 | No instrumentation: PostHog receives **zero events from the app** in the last 30 days (only checkout events from marketing; no `$pageview`). We cannot see where students stall, which is why §2 had to be reconstructed from database rows. | [data] PostHog `read-data-schema` |

### 4.4 "When they leave, is it easy to get back in?"

| # | Finding | Evidence |
| --- | --- | --- |
| D1 | No re-engagement email of any kind. TASK-0026's Loops lifecycle program was never started. | [doc] |
| D2 | Sign-in is email + 6-digit code, with Supabase's one-email-per-minute cap. Fine for a returning student who remembers to come back; it is the whole reason nobody comes back by accident. | [doc] 2026-10-04 handoff |
| D3 | The hub cannot say "last time you…": `lastAttempt` is hardcoded `null`, `stats` is `[]`. Stage B's Pulse ("3 questions · 12 minutes this week") is the only memory the product shows. | [code] `home.functions.ts` |
| D4 | "Resume session" appears for every student who has ever practised, because `/practice-mcq` and `/practice-frq` never call `session_end`; resume starts a new list anyway. | [code] [data] (all 7 recent sessions `ended_at = null`) |
| D6 | A signed-in student can be bounced through `cramapple.com/login?redirect=/home` mid-session and land back on `/home` without entering a code. Cause unverified; relates to the open cross-subdomain cookie question (one-pager O2). | [recording] |
| D5 | The one student who returned (`f6216fbc`) did the identical thing both days: opened an FRQ screen, never submitted. Nothing changed on the second visit to help them. | [data] |

---

## 5. Recommendations

Ordered by (impact on the first 7 minutes) ÷ (effort). "Lovable" = frontend prompt to `56cae479`,
no backend. Everything in P0 is copy and structure on screens that already exist.

### P0 — this week, Lovable only

| # | Change | Where | Why |
| --- | --- | --- | --- |
| R1 | **Put the loop on the page.** One strip, top of every hub stage and carried into the plate chrome: **1 Where is your class · 2 See one worked · 3 Try one for points · 4 We tell you what's next.** Highlight the current step. | Stage A/B hero, `QuestionPlate` breadcrumb right-slot (replace "Worked example"/"Practice" status with "Step 2 of 4 · Worked example") | Fixes A1, A3, B1 in one move; gives every other screen a frame to refer to. |
| R2 | **Make the position form answerable.** Replace "Tell us where your class is" with "What did your teacher cover most recently?"; show topic *titles* (not `1.1 ·` codes) and group by unit; preselect or badge the calendar-typical unit ("Most classes are in Unit 2–3 in early October"); keep "Not sure — start from the beginning" as an explicit choice so Unit 1 is a decision, not a default. | `HomeStageANew.tsx` | A2: 3/3 real students chose 1.1. |
| R3 | **Open Hand: say why, then push forward.** Add a one-liner above the key: *"This one's answered for you. Read how each point is earned, then try one like it for real."* Make **"Try one on your own →"** the primary button; demote "Next question" to "Show me another worked one". Keep "Upload your own question" off this screen (it is on the hub). | `OpenHandMcqScreen.jsx` | A3, C2. |
| R4 | **Practice: give the first session a shape.** Say "Your first session: 3 questions" on entry, show "Question 2 of 3" in the plate, and after the third graded answer show a **stopping-point card**: points so far, the topic, and *"That's enough for Cramapple to start recommending. Back to your hub →"* with "Keep going" as secondary. The Stage A copy already promises exactly this threshold (3 attempts across 2 items). | `LivePracticeMcq.jsx`, `PracticeMcqScreen.jsx` | A4, B3, B5. Replaces the "You've finished the questions ready for this unit" dead end. |
| R5 | **Frame the first wrong answer.** On the first incorrect verdict of a session add one line to the feedback card: *"Normal for a first look at a topic. The explanations on the left are the point — read the one you picked."* | `FeedbackCard` caller in `PracticeMcqScreen.jsx` | B3: the one MCQ student quit after two reds. |
| R6 | Link the "While you're here" explainer cards to `/learn/…`, and move them *below* the primary action so they do not compete with it. | `HomeStageANew.tsx` | A5. |
| R7 | **One vocabulary.** Student-facing: **Worked example** (step 2) and **Practice** (step 3). Keep "Open Hand" only as the masthead brand word if at all; drop "Face-up" and the standalone "Not scored" chip (fold into R3's one-liner). One name for outside questions: **Bring a question** everywhere; remove "Upload your own question" and the "Homework helper" probe from the mode bar. | `OpenHandMcqScreen.jsx`, `TopicHome.tsx`, `ByoqHomeLink.tsx` | C1, C2. |
| R9a | **First-question hints are free.** On the first practice item of a session, open the Reference pane and the topic hint without a gate and say so ("Free on your first question. From the next one, hints are listed on your feedback."). Keep the gate from question two. | `PracticeMcqScreen.jsx`, `ReferencePane` | C9. |
| R9b | **Hide "Ask for help" and "Homework helper" for every subject except AP Statistics**, and add a "Copied" state to the deep-dive button. | `TopicHome.tsx`, `DeepDiveOverlay.jsx` | C7, C8. |
| R8 | Small honesty fixes: "Welcome" (no name) instead of "Welcome, jsmith2008"; remove the static gauge arc (plain "34 days to the exam"); delete "from your class calendar". | `home.functions.ts` (frontend server fn), `HomeStageANew.tsx`, `TopicHome.tsx` | C3, C4, C5. |

### P1 — next, needs a decision or small backend work

| # | Change | Needs | Why |
| --- | --- | --- | --- |
| R9 | **Close the session and remember it.** Call `session_end` when the student leaves via the stopping-point card or "Return Home"; populate `lastAttempt` / a "Last time" line on the hub ("Yesterday: 3 questions on 1.1, 2 points. Next: …"). | Backend: small change in `home.functions.ts` plus the practice screens' exit path | D3, D4. Makes the return visit feel continuous. |
| R10 | **One hub, not three.** Decide TASK-0048 finding 2: either extend Stage B's structure through the personalized state (recommended — it already has the orientation strip, hero, pulse, curriculum, deep dives) or build the Main artboard. Retire the Learn/Points mode bar and the TopicHome madlib either way. | David's call; then Lovable | A6. |
| R11 | **Instrument the loop.** Six events from the app: `hub_viewed{stage}`, `position_set{unit,topic,was_default}`, `worked_example_viewed`, `practice_started{entry}`, `answer_submitted{correct,hints}`, `session_ended{questions,points}`. Turn on `$pageview` on `app.cramapple.com`. Until then every assessment like this one is archaeology. | Lovable (posthog.ts already exists) | C6. |
| R12 | **Investigate the FRQ drafts.** Find how three students reached `/practice-frq` (there is no link from Home's primary path), and why the first thing they saw was a full FRQ. If it is the Open Hand FRQ screen (`LiveOpenHand.jsx` opens a practice session to fetch its list), the draft is an artefact and the student saw a worked FRQ and left — which still means the worked FRQ did not pull them into practice. Ask the three students; there are no session replays. | 30 min code trace + three messages | §2 item 2, D5. |
| R13 | **Match the promise.** For AP Biology and AP Statistics (the two subjects cleared for the criterion-level starter, `CRITERION_STARTER_SUBJECTS`), make the first worked example an **FRQ with its rubric** — the thing the marketing hero shows — and the first practice a short-text FRQ. MCQ first for the other eight. | Product call; `practice-entry.ts` routes by subject | B2, B4. |
| R15 | **Trace the mid-session login flash** (D6): reproduce with the Recorder export, check whether the app-side session is being re-validated against `cramapple.com`, and fix under O2. | eng | A student who sees a login page thinks they were logged out. |
| R14 | **One next-day email.** "You left off at 1.1 Topic title with 2 questions done. One more and Cramapple can tell you what's next." Link to `/home?subject=…`. Loops is connected; TASK-0026 scoped it. | Backend + Loops | D1. |

### Not recommended right now
- Rebuilding the hub visually before R1–R4 land. The 2026-09-27 canvas design is sound; the problem
  is narration and sequencing, not layout.
- Adding a 6-question diagnostic (TASK-0048 cut it; this assessment agrees — it is a third thing
  to explain before any value is shown).

---

## 6. What I could not verify and how to close it

| Gap | How to close | Time |
| --- | --- | --- |
| Rendered Stage A / Open Hand / Practice at desktop and 390px, signed in. | David signs in on the Lovable Dev preview or Production in the Claude browser pane (sign-in is his action; the walkthrough and screenshots can then be mine). | 10 min |
| Why 3/4 students landed in FRQ practice. | R12. | 30 min |
| Whether Stage A's dropdown shows codes or titles on a phone. | Same walkthrough. | — |
| Whether the welcome banner actually renders (publish of commit `7193c3b2` was unconfirmed on 2026-10-04). | Same walkthrough, with `?welcome=1`. | — |

---

## 7. Open questions for the Product Owner

1. **Is the worked example mandatory or optional?** Today it is neither: it is the primary path when
   content exists and silently absent when it doesn't. R1 assumes "mandatory, named step 2".
2. **How long is a first session?** Stage A says 3 attempts across 2 items; Practice serves 10.
   R4 assumes 3.
3. **Which word?** "Worked example" (what the button says) or "Open Hand" (what the masthead says).
   R7 assumes "Worked example" for students, "Open Hand" stays internal.
4. **FRQ-first for Bio/Stats (R13)?** It is the promise on the homepage; it is also the screen three
   students bounced off. The answer may be "worked FRQ first, short-text FRQ practice", not "no FRQ".
5. **Can we talk to the five pilot accounts?** Three questions each would be worth more than this
   whole document.

---

## 8. Sources read this session

- App `56cae479` (Lovable, HEAD `64352ecb`): `HomeV2.tsx`, `HomeStageANew.tsx`, `HomeStageBBuilding.tsx`,
  `TopicHome.tsx`, `HomeWelcomeBanner.tsx`, `_ux.home.tsx`, `_ux.tsx`, `Pieces.tsx`, `SubjectSwitcher.tsx`,
  `home-snapshot.ts`, `home.functions.ts`, `feature-flags.ts`, `practice-entry.ts`, `use-practice-entry.ts`,
  `retired-routes.ts`, `RetiredRouteGate.tsx`, `open-hand-mcq.tsx`, `practice-mcq.tsx`, `LiveOpenHandTeaching.jsx`,
  `OpenHandMcqScreen.jsx`, `LivePracticeMcq.jsx`, `LivePracticeFrq.jsx`, `PracticeMcqScreen.jsx`,
  `FeedbackCard.jsx`, `QuestionPlate.jsx`, `StudyNav.jsx`, `open-hand/teaching.ts`, `open-hand/loop.ts`,
  `open-hand/presentation.ts`, `live-practice-mcq/feedback.ts`, `live-practice-frq/session.ts`,
  `returning-context.ts`, `parked-sessions.ts`, `change-topic-anchor.ts`, `onboard.tsx`, `SessionFrame.tsx`,
  `.lovable/plan/one-time-welcome-banner-on-the-student-hub-2026-10-04.md`,
  `.lovable/plan/fix-open-hand-pre-reveal-and-subject-topic-scope-2026-10-06.md`.
- Marketing `61dd6602`: `checkout.success.tsx`, `PaymentResult.tsx`; live pages `/`, `/checkout`, `/login`.
- Repo: `CRAMAPPLE_SESSION_START.md`, `docs/INDEX.md`, `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`,
  `CRAMAPPLE_VISION.md`, `TASK-0048`, `TASK-0026`, `SESSION_CLOSE_2026_10_04_CHECKOUT_USER_TESTING.md`.
- Production DB: `auth.users`, `app.subject_entitlements`, `app.student_course_positions`,
  `app.learning_sessions`, `app.attempts` (read-only, last 21 days).
- PostHog: event taxonomy (last 30 days).
- Product Owner's Chrome Recorder export, 2026-10-07 10:10 (click path only; the file also contains the owner's email and a spent one-time code and should not be committed).
