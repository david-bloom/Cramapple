# Course Mode — Student UX Integration Spec

STATUS: build-ready integration spec | DATE: 2026-08-25 | AUDIENCE: David → Claude Design (screens) → Lovable (build).

**What this supersedes.** The original mocks brief (`COURSE_MODE_STUDENT_UX_DEFINITION` + the
"four static HTML mocks" plan) framed Course Mode as **a panel above today's home** and four
**standalone** surfaces under `public/course-mode/`. On review of the live front-end
(`david-bloom/exam-buddy-wireframe`), that framing is wrong: those surfaces **already exist and
are backend-wired**, so standalone mocks would fork a working product — the CM-D02 "second
parallel product" anti-pattern. This spec replaces the panel/standalone framing with an
**integration** into the existing `/home`, `/session`, `/learn`, and `/progress` surfaces, and
records David's 2026-08-25 product direction: **lead with learning; let the student shift to
points when a quiz/test/exam is near.** It carries forward the fidelity findings from
`COURSE_MODE_STUDENT_MOCKS_REVIEW.md` (which correctly critiqued the mock content but endorsed
the now-overruled panel placement — treat this doc as the correction).

Governing model unchanged: `COURSE_MODE_LEARNING_MODEL.md` (CM-D##, INV-1..6),
`TEACHING_AND_PEDAGOGY_DESIGN.md`, the Unit-1 pilot plan. Pilot scope unchanged: AP Statistics
Unit 1, ~10 cells, MCQ + numeric-entry only.

---

## 1. The reframe: integrate, don't parallel

Course Mode is not a new destination. It is **the intelligence layer** — the due-queue, the
tier/decay learning state, the confidence-and-transfer loop — woven into the surfaces that
already exist:

| Course-Mode job | Lives in (existing surface) | Repo anchor |
|---|---|---|
| What should I do now? + my learning state | **`/home`** (`TopicHome` + `StudentHomeSnapshot`) | `components/home/TopicHome.tsx`, `lib/home-snapshot.ts` |
| The core loop (attempt → grade → prove it) | **`/session/mcq`** (and `/session/frq` later) | `routes/_ux.session.mcq.tsx`, `lib/use-grade-practice.ts`, `components/session/GradeResultView.tsx`, `components/ux/HelpPanel.tsx` |
| In-depth teaching + stuck escalation | **`/learn/$subjectKey/$unitNumber/$topicCode`** (already the "Learn more" route) | `TopicHome.tsx:559` |
| Deep mastery evidence | **`/progress`** ("See every point you've earned") | referenced from `TopicHome.tsx:344` |

Nothing needs a `--ca-*` HTML skin or a `public/course-mode/` tree. Every "mock" becomes a set
of **changes to real components**. The four original mocks map as: `home-panel` → `/home`
changes; `loop` → `/session/mcq` changes; `stuck` → `/learn/...`; `mastery` → `/progress`.

---

## 2. Two modes: Learn (default) and Points (on the student's shift)

David's direction, made concrete. This is CM-D02/D03's "one engine, two horizon settings" turned
into a control the student can actually use.

- **Learn mode — the default.** The whole year, the home leads with *what and how to learn,
  efficiently*: the learning-state of each skill, what's fading and cheap to save, and the
  single most efficient next move. The value shown is **learning locked in**, not a score.
- **Points mode — on the student's shift.** When a quiz, test, or the AP exam is near, the
  student flips to *turn this learning into points for the thing that's coming*: exam-shaped,
  point-capture-framed practice. This is the existing point-capture surface — but now it is a
  **mode you enter when timely**, not the default.

**Pilot mechanics (decided 2026-08-25 — framing flip + simple toggle now):**
- A persisted `mode: "learn" | "points"` preference, **defaulting to `learn`**, stored with the
  same pattern as the `home-v2` flag (`lib/feature-flags.ts`: localStorage + optional `?mode=`
  search override + env default). One visible toggle on `/home`.
- **Auto-nudge, never auto-switch:** when `subject.examState === "countdown"` and `daysToExam`
  is small (threshold TBD, e.g. ≤ 14), the home *suggests* Points mode ("Exam's close — want to
  switch to points prep?"); the student decides. The countdown signal already exists in the
  snapshot (`home-snapshot.ts:217`, `TopicHome.tsx:235`).
- **Deferred to Phase 2 (the fuller vision):** "tell us your next quiz/test" — a student-declared
  assessment with a **date and a scope** (which units/topics) that dates and scopes Points-mode
  prep. This needs new input + data + backend and is out of the Unit-1 pilot. The pilot's Points
  mode is subject/exam-wide, toggled, not per-declared-assessment.

**What the mode actually changes:** the *lead framing and ordering* of `/home` (§4.1) and the
*value language* of a graded result (§4.2). It does **not** fork the session mechanics — the same
cold-attempt loop runs in both modes; only what the surrounding surfaces emphasize changes.

---

## 3. Vocabulary: learning-native, no "fortress"

The metaphor is dropped. The replacement is anchored in the front-end's **own established voice**
— `_ux.home.tsx`'s `ReviewRhythm` already writes *"Time to see if these still hold"* and
*"Bring back [unit] — time to see if it still holds"* with a coded rule against
*"overdue, late, behind, or backlog language."* That is the register.

**State language** (student-facing; the internal tier→state mapping is unchanged, only the words):

| Internal (never shown) | Student-facing | Rule |
|---|---|---|
| `confirmed` | **"still holding" / "sticking"** | The only "solid" state. INV-5: a hinted (`supported`) win is never "sticking." |
| `fragile` (a prior success later failed) | **"worth another look"** | INV-6: reopened, not reset. |
| decay-due (staleness threshold crossed) | **"time to revisit"** | Family-A trigger (CM-D08). |
| `independent` / `supported` (not yet confirmed) | **"getting there" / "building"** | Provisional; never "sticking." |
| `exposed_unverified` | **"just started" / "new from class"** | New-exposure. |

**The four due-reasons** (Phase-1 triggers), in this voice:
- decay/maintenance → *"Time to see if this still holds"*
- provisional-success confirm → *"You needed a hint last time — let's see it stick without one"*
- reopened/direct miss → *"Missed this on Tuesday — worth another look"*
- new-exposure consolidation → *"Your class just covered this"*

**Value line (Learn mode):** *"Learn what matters, the efficient way — and turn it into points
when a test is coming."* (Approved direction 2026-08-25; final copy is Claude Design's.)

**Banned vocabulary anywhere in either mode:** *fortress, locked, slipping, defend, decay* (as a
noun to the student), *overdue, late, behind, backlog,* a *miss/failure counter,* *stuck* (about
the learner), *mastered* (after any hinted win), and any *projected score*.

---

## 4. Surface-by-surface integration

For each surface: **what's reused** (already there), **what changes**, **what's genuinely new**.

### 4.1 `/home` — `TopicHome` + the `StudentHomeSnapshot` contract

**Reused:** the whole page architecture — hero + "Next best action", evidence rail, unit/topic
selectors, `TopicBrief`, exam countdown, live-session resume, the honest empty-state discipline
(*"empty tracks rather than fake progress"*, `TopicHome.tsx:6`), and the snapshot's threshold
gates (`POINT_CAPTURE_MIN_ITEMS`, `canRecommend`, `canClaimTrend`, coached-never-counts).

**What changes — the framing flip:**
- In **Learn mode (default)**, the hero lede and the evidence rail lead with **learning state**,
  not points. The rail's primary read becomes the skill-grain learning summary ("3 sticking · 2
  worth another look · 4 time to revisit · rest building") — honest total, ≤ 3 actionable — in
  place of the points-earned/units-with-evidence bars as the *first* thing.
- In **Points mode**, the current point-capture rail (`selectedCapture`, units-with-evidence,
  `lastAttempt` points) leads exactly as it does today. This is a re-order + toggle, not a rewrite
  — the point-capture code stays and becomes the Points-mode view.
- The **"Next best action"** line and the `HomeTarget.provenance.reason` / "Why this?" affordance
  are reused verbatim; the four due-reasons (§3) become the reasons it can show. `pickRecommendation`
  (`_ux.home.tsx:364`) already speaks decay/return — extend its reason set to the four.

**Genuinely new — a learning-state layer on the snapshot.** `StudentHomeSnapshot` today has
**no** tier/decay field (`home-snapshot.ts:295`). Add a per-**skill-within-topic** learning-state
array (INV-1: plain-language skill names, never `4.B` codes; two skills in one topic must stay
distinct, never merged), each carrying: the internal tier, a freshness/decay signal, the
student-facing state word (§3), and the due-reason. It **must obey the same honest thresholds**
the point-capture layer already enforces (no state claimed below the evidence bar; estimates
qualified). This is a deterministic read of `student_cell_state` (the F2/F3 store) rolled up to
plain language — not a model inference (INV-4).

### 4.2 `/session/mcq` — the core loop

**Reused:** the entire loop is already here (`_ux.session.mcq.tsx`) — labeled **"Cold attempt"**,
MCQ radios, Submit → `useGradePractice` → `GradeResultView`, the `HelpPanel` least-revealing
ladder (small hint → break into parts → review concept), silent `attempt_condition` cold/coached
+ `help_level_used` tracking that already kills independent evidence when help is used, and
**"Move on and return later."** `assistanceState` is already passed to the grader — the exact
signal the cell-state hook consumes.

**Genuinely new (two beats):**
1. **Confidence bundled into submit.** Replace the plain "Submit answer" (`:221`) with the
   three-way **"Sure / Think so / Guessing"** control that *is* the submit action — captured
   before feedback, every attempt (§12.1 / CM-D07). Add the value to the `grader.submit(...)`
   input (alongside `assistanceState`). **"Guessing" must be a safe, non-stigmatized choice.**
   This is the one clearly-missing, high-value beat.
2. **Confirm-transfer — the "prove it" beat.** Today a graded-correct goes straight to
   "Continue to next question" (`:273`). Insert the **"Different question, same skill"** transfer
   item — a fresh, changed-surface item, no help — as the step that closes a cell as an
   independent success. This is the product's differentiator (§7) and currently absent from the
   flow. It also carries the confidence control (it's another cold attempt).

**What changes:**
- **MCQ is the first-class form** (it already is here); numeric-entry is a variant panel for the
  two computational cells (1.7×3.B, 1.9×3.B). The mock's numeric-only loop was backwards.
- **Three distinct outcomes** in `GradeResultView`: correct (offers Stretch), incorrect
  (neutral, smallest observable gap, tier shown "unchanged", no miss counter), content-uncertain
  (paper-grey, non-punitive, "doesn't count for or against you, sent for review"). This is a
  change to one component, not a new page.
- **HelpPanel → Tighten / Show.** The existing three help levels map to Tighten (nudge) and Show
  (worked example full → faded → parallel). **The worked example must be a *parallel* instance,
  never the item on screen** — for an MCQ a worked solution to the live item is an answer-key
  leak (a live security invariant; the `mcq_choices` leak was PR #106). Keep "no answer text."
- **Cold orient** shows stem + stimulus but must not pre-render the choices as part of orient.

### 4.3 `/learn/$subjectKey/$unitNumber/$topicCode` — the in-depth surface

This existing "Learn more" route is where **in-depth learning** lives — the surface the student
branches *into*, per David's direction, and returns from.

- **Teach ladder in full:** Tighten → Show (worked example full → faded → parallel), each ending
  in a fresh independent attempt. No answer text, no grading rationale.
- **Stuck escalation, trimmed to what Phase 1 can deliver:** lead with **Step Sideways** (another
  angle on the same skill) + **Move-on / Return-later** prominent after ~two unsuccessful
  escalations. **Step Apart** only where an authored decomposition exists. **Step Down (drop to a
  prerequisite) is cut** — the principle graph is Phase-2 deferred (CM-D12); the pilot cannot
  route to a prerequisite cell. Keep the vocabulary in the design system for later.
- **Never "stuck" about the learner** — the state belongs to the skill. No timer, no failure
  count. Overrides recorded as preference, never noncompliance.
- Entry point: a session miss that needs teaching offers "go deeper on this" → `/learn/...`;
  returning drops back into the session flow.

### 4.4 `/progress` — deep mastery evidence

Extends the existing progress surface, in Learn-mode framing.

- **Five evidence dimensions** in plain language, comparison period named: independence,
  retention, transfer, calibration, effort (drop bare accuracy, or keep it strictly subordinate
  and qualified — deliberate, per the review). Reuse the snapshot's trend gates
  (`TREND_MIN_ATTEMPTS`, `TREND_MIN_SESSIONS`) so no improvement is claimed without comparable
  evidence.
- **Calibration block** rewarding accurate calibration and help-seeking, not confidence alone
  (§12.2). This is where the confidence data from §4.2 pays off.
- **Every claim estimate-qualified. No projected score anywhere** (§8 guardrail).
- **Desirable-difficulty note** followed by the delayed evidence, not a request for faith
  (§4.3 / §11.3).

---

## 5. Fidelity fixes carried from the review (still binding)

1. **MCQ guess-floor / confidence-in-tier.** The engine promotes `unseen → independent` on one
   correct attempt, and `classifyWeight` (`cell-state.ts`) ignores confidence — so a "Guessing" +
   correct MCQ earns full independent evidence, overstating mastery. This is the load-bearing open
   decision (§9). Whatever is chosen, the confirm-transfer beat (§4.2) is the honest backstop.
2. **State word → tier mapping is honest:** "sticking" = `confirmed` only; a hinted win is never
   "sticking" (INV-5). Sample data must be consistent with the ~10-cell pilot, not a fictional
   larger scale.
3. **Stuck trimmed:** Step Down cut for the pilot (§4.3).

---

## 6. Data / contract implications

- **Snapshot learning-state layer** (§4.1): a new per-skill-within-topic array on
  `StudentHomeSnapshot`, deterministic roll-up of `student_cell_state`, plain-language, honest
  thresholds. Server-fn + tests, mirroring the existing point-capture computation.
- **Confidence capture** (§4.2): new field on the grade-submit input; stored on the attempt.
  **Open:** whether it deterministically discounts evidence weight (a CM-D07 change) — §9.
- **Mode state** (§2): a `learn | points` preference, `home-v2`-flag pattern; drives home
  ordering + result-value language only.
- **Deferred:** declared-assessment (date + scope) input and its scoped Points-mode.

---

## 7. Explicitly deferred to Phase 2 (do not build in the pilot)

- Student-declared quiz/test with date + scope; scoped Points-mode prep.
- Step Down (prerequisite routing) and any cross-cell / "related topic" resurfacing (needs the
  principle graph — CM-D12).
- Open free-response answering/grading (needs the R&D grader).
- Score prediction of any kind.

---

## 8. Hard-constraint checklist (both modes obey)

- [ ] No skill/letter codes, no cell grid — plain-language skill-within-topic (INV-1); two skills
      in one topic stay distinct.
- [ ] No miss/failure counter; "stuck" never labels the learner.
- [ ] "Sticking" (= `confirmed`) is the only "solid" state; never after a hinted win (INV-5).
- [ ] A miss shows tier "unchanged"; fragile/evidence change allowed, never framed as a reset
      (INV-6).
- [ ] No answer key / grading rationale reachable — live security invariant (redacted payloads;
      worked examples are parallel items only).
- [ ] No projected score in either mode (§8 guardrail).
- [ ] Every learning-state / improvement claim estimate-qualified, dimension + period named;
      honest thresholds reused, no claim under the evidence bar.
- [ ] Recommendation never disguised as a requirement; overrides recorded as preference.
- [ ] Only the four Phase-1 due-reasons; no "related topic" / "prerequisite you're missing."
- [ ] Content-uncertain reads non-punitive, changes no tier/evidence, routes to review.
- [ ] Banned vocabulary (§3) appears nowhere.

---

## 9. The one open decision David still owns

**Does a "Guessing" + correct MCQ earn full `independent` evidence?** Options, all deterministic
(INV-4-safe): (a) discount evidence weight when confidence = "Guessing" (a CM-D07 change, not
built); (b) require the confirm-transfer beat before `independent` for MCQ items even on a
first-try correct; (c) accept it and rely on the delayed `confirmed` gate. This decides whether
the confidence control is honest-about-tiering or admittedly calibration-only, and it is the
thing to settle before the session changes (§4.2) are built.

---

## 10. Handoff

This spec is the brief Claude Design builds screens against, and Lovable builds from. The four
original mocks are re-scoped as **component changes** to `TopicHome`, `/session/mcq`,
`GradeResultView`/`HelpPanel`, `/learn/...`, and `/progress` — not standalone pages. React
implementation remains a separate approval after the screens are reviewed.

---

## 11. Addendum — 2026-08-25 (Unit 1 Skills rail, learn-first entry, homework experiment)

Three directions from David, folded into the design (see the canvas artboards `SkillLink`,
`SkillEntry`, `Homework`).

### 11.1 "Unit 1 Skills" rail + skill ↔ topic linkage

- The `/home` learning-state rail (§4.1) is titled **"Unit 1 Skills"** (was "Where your learning
  stands"). Each row is a plain-language skill carrying its learning-state word.
- **Hover a skill →** (a) a short description of the skill; (b) the **topics it appears in light
  up** in the existing topic selector — topics stay on `/home`. A skill is the atom you learn;
  topics are where you meet it in class. This is INV-1 ("store fine, present coarse") made
  tangible, and the loss-aversion payoff is legible ("one skill, two topics — locking it in pays
  off twice").
- **Click a skill →** the learn-first session (11.2).
- Contract: needs the item→cell tags that already exist (`content_item_cells`) rolled up to a
  plain-language skill **plus** the set of topics each skill appears in (a skill→topics map).

### 11.2 Learn-first skill entry (explainer + "open hand")

Clicking a skill to **learn** it opens `/session` in a **teaching-first** entry:
1. a **skill explainer** — NEW authored content;
2. a first question played **"open hand"** — worked in full, we show how to solve it;
3. handoff to the student's **own cold attempt** ("now you try, no help").

**The honesty rule — entry context decides coldness:**
- **Learn-entry** (student clicks a skill to learn it; tiers `unseen`/`exposed_unverified`) →
  explainer + open-hand worked example → **COACHED, zero mastery evidence (INV-5)**. Only the
  cold attempt that follows counts.
- **Due-review / prove-it entry** (the skill surfaces from the queue) → **COLD**, exactly as the
  loop already does (§4.2).

This reuses existing machinery: `/session/mcq` already tracks `attempt_condition` cold|coached and
zeroes evidence when help is used — the explainer/worked example simply set `coached` for that
first item. **New content dependency:** a per-skill explainer + a worked first example, analogous
to the existing per-topic point briefs (`TopicBrief`) but at skill grain — authored/vetted (INV-3),
never model-generated on the fly.

### 11.3 Homework-image experiment — teach, don't solve

- **Intake:** the student photographs a homework page (extends the existing **`/bring-question`**
  flow with image intake).
- **Vision parse → classify** to subject → unit → topic → **skill (cell)**, reusing the
  taxonomy/cell registry (F1 `taxonomy_cells`). Honest confidence; **fail-closed when unsure**
  ("tell us if we read it wrong").
- **Output is NEVER the answer to their problem.** It routes into the learn-first entry (11.2) on
  a **parallel** problem, then prove-it on a fresh item — the student learns the skill and does
  their own homework. This is the "prove it transferred, don't just answer" differentiator (§7)
  applied to the student's real work.
- **Guardrails (non-negotiable):** never the answer to the student's item; practice only on
  **vetted, checkable** content (INV-3), never an LLM answer to their photo; the photo is used to
  read the problem then **discarded** (no retention); **name/PII sweep** per the user-provided-
  question rules (`TEACHING_AND_PEDAGOGY_DESIGN.md` §14.2); the academic-integrity stance is a
  **feature**, not a limitation.
- **Status: FILED FOR A LATER RELEASE (David, 2026-08-25).** A live feasibility test confirmed the
  vision-classification step works (correct subject/unit/topic/skill on an out-of-pilot proxy, with
  honest gaps flagged, teach-not-solve held) — but it is **not** built in the Unit-1 pilot. Full
  record + the two-gate finding (classification generalizes broadly; vetted-content coverage is the
  binding gate): `docs/research/HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md`.
- **Open question:** granularity when a homework problem spans multiple cells or a cell outside
  the pilot scope → honest "we can help with the part that's in range," never a fabricated stretch.

### 11.4 Learn-home layout refinements (2026-08-25)

Density and clarity pass on the Learn-mode `/home` (canvas `Main`):

- **Unit toggle.** The skills list carries a **unit stepper** (‹ Unit 1 ›) so the student can move
  through units — reusing the unit selection `TopicHome` already has (`selectUnit` / `coursePosition`).
- **Simplified skill state.** The per-skill state collapses to **a coloured dot + three labels —
  new (pink) / building (blue) / strong (green)** — with a **legend** so it is *never colour
  alone* (accessibility; also expose the label on hover/`aria`). Honesty preserved: **strong =
  `confirmed` only** (never a hinted win). Tier mapping: new = `unseen`/`exposed_unverified`,
  building = `supported`/`independent`, strong = `confirmed`. **Decay / "due" is no longer a dot** —
  it surfaces in the Start queue as an *action*, which is where "practice this now" belongs.
- **Obvious entry points.** The page resolves to **two clear doors**: one prominent **"Start"**
  card (the assembled session — the main entry, with the three queued items previewed and each
  individually startable) and the **skills list** (tap a skill → learn it, §11.2). Ambient copy
  and the multi-section stack were cut to let those two read at a glance.
- **Madlib course-position confirm replaces the personalized message.** Instead of a
  "Welcome back, <name>" lede (hollow for a new student), the top of `/home` asks *"Your class is
  on **Unit __ · Topic __** — right?"* pre-filled with our **best guess** and editable inline, with
  a graceful fallback when we have no guess (`coursePosition.source = unknown` → "Where's your class
  right now?"). This **sets the default learning experience** and is grounded in the existing
  `coursePosition` / `setCoursePosition` machinery (the v1 home's ReconfirmCard, evolved). It is
  recommendation-with-override: the guess is never a lock. **No confirm buttons** — editing a chip
  *is* the correction; leaving it alone accepts the guess. The **"Welcome, <name>"** greeting stays.
- **Subject toggle (upper-right).** For students with more than one subject, a subject switcher sits
  in the top bar (reusing `useActiveSubject` / `setActive`); the whole home re-scopes to the chosen
  subject.
- **Topic point brief stays.** Below the Unit Topics strip, the selected topic's point brief
  (`what it is / why it matters / how points are earned / answer move / common point loss`) renders
  as it does in `TopicHome` — cut in the density pass, restored here.
- **"Homework helper" stub (demand probe).** The deferred homework-image feature (§11.3) surfaces
  now as a camera affordance that **looks like a live feature — no "coming soon" badge at rest.**
  Only **on click** does it record the click (an interest signal) and reveal "coming soon." A badge
  up front would prime curiosity and pollute the signal; the goal is to measure *genuine pull*
  before building the real intake. Trivially wireable now as a single analytics event (the app
  already uses PostHog) — no new backend.
- **Mode consistency.** The subject toggle and the simplified new/building/strong dots (with the
  unit stepper) are carried into the **Points-mode** home too, so the two modes share one chrome.
