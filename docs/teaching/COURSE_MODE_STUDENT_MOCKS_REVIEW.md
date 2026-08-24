# Course Mode — Student-Mocks Plan Review (Lovable static-HTML step)

STATUS: design review (assess / challenge, not execute) | DATE: 2026-08-24 | AUDIENCE: David, then Claude Design + Lovable.

**What this is.** A fidelity review of Lovable's plan for the four static-HTML Course Mode
mocks (`home-panel.html`, `loop.html`, `mastery.html`, `stuck.html`), measured against the
settled model: `COURSE_MODE_STUDENT_UX_DEFINITION_2026_08_24.md` (the requirements),
`COURSE_MODE_LEARNING_MODEL.md` (CM-D##, INV-1..6), `TEACHING_AND_PEDAGOGY_DESIGN.md`
(progress display, calibration, escalation), and the live backend state in
`COURSE_MODE_STATUS_AND_HANDOFF.md`, `COURSE_MODE_NEXT_SESSION_PROMPT.md`, and the
`..._PILOT_PLAN_...` / `..._RELEASE_PATH_DECISION_BRIEF...` docs.

The plan is **substantially loyal** to the intent. The design instincts — panel-above-home,
confidence-bundled-into-submit, honest-total/calm-framing, three visually-distinct outcomes,
recommendation-with-override, no answer key — are all correct and hard-won. This review is
not a rewrite; it is a list of the places the mock would **quietly promise something the
pilot engine cannot yet deliver**, or **overstate mastery in a way the invariants forbid**.
Those are the two failure modes that matter, because both erode the exact trust the product
is selling.

---

## 0. Verdict in one line

Ship the mocks — but fix three things before Lovable builds them: (1) the core-loop cold
attempt is drawn as **numeric entry**, when the pilot's proven, dominant modality is **MCQ**;
(2) the **fortress words need an explicit, honest tier mapping** or "locked" will end up
claiming mastery the invariants prohibit; (3) the stuck-state offers **Step Down (drop to a
prerequisite)**, a routing move the Phase-1 engine cannot make (the principle graph is
deferred). Details below, each with the doc that governs it and a concrete change.

---

## 1. What the plan gets right (keep exactly as-is)

Called out so these don't get lost in the edits:

- **Panel above home, not a replacement** — correct. Matches the "one engine, two horizon
  settings" framing (CM-D02); Course Mode is additive, the existing surface stays.
- **Confidence bundled into the submit control** ("Sure / Think so / Guessing" *is* the
  submit) — elegant, and it honors "capture confidence *before* feedback, every relevant
  item, on a small consistent scale" (§12.1 / CM-D07) with zero extra beat. Keep it.
- **Honest total, calm framing** ("6 need a refresh," top 3 actionable) — this is the
  honest-uncertainty invariant made visible (INV-6, §8 "honest uncertainty in all
  displays"). Keep the honest total; keep the ≤3 actionable.
- **Three graded outcomes visually distinct, content-uncertain as paper-grey non-failure** —
  exactly CM-D07 / the §4 three-outcome table / fail-closed. Keep.
- **Tier "unchanged" on a miss, no miss counter, no shame** — INV-6. Keep (one precision
  note in §6).
- **No skill codes, no cell grid, plain-language skills** — INV-1. Keep.
- **Recommendation-with-override, equal-weight "Pick something else," overrides as
  preference** — §6, §10.3.1. Keep. This is a genuine differentiator; don't let it soften.
- **"Prove it on a second question" given the strongest visual treatment** — correct
  instinct; §7 names this the product's structural argument vs. a chatbot. (The caveat in §3
  is about *modality*, not about de-emphasizing it — if anything, lean in harder.)

---

## 2. Location correction (not a design issue, but reviewers should know)

The plan says the mocks live in `public/course-mode/` and copy tokens "verbatim from
`src/styles.css`." **Neither path exists in this repo** (`david-bloom/cramapple`) — there is
no `src/`, no `styles.css`, no `TopicHome.tsx`, no `public/`, and no `--ca-*` tokens here.
This repo is the pedagogy/content/supply brain-trust. The **front-end lives in the separate
Lovable repo `david-bloom/exam-buddy-wireframe`** (STATUS_AND_HANDOFF §3, §7). So:

- The mocks and the `--ca-*` Newsprint tokens the plan cites both belong to
  `exam-buddy-wireframe`, and that is where `TopicHome.tsx` will be touched later. The plan's
  file paths are correct *for that repo*, not for the one this review sits in.
- Practical ask: whoever runs Lovable should confirm the token values against
  `exam-buddy-wireframe/src/styles.css` at build time, since we can't verify them from here.
  The plan's "redeclare the tokens verbatim in an inline `<style>`" discipline is right —
  it's the anti-drift move — it just needs the real source file in front of it.

---

## 3. Tension #1 (the big one): the loop is drawn as numeric-entry; the pilot is MCQ-first

**What the plan shows.** `loop.html` renders the cold attempt as **numeric entry**, with the
three-way submit beside it.

**What the pilot actually serves.** Of the ~10 proposed pilot cells (PILOT_PLAN §4), **8 are
MCQ and 2 are numeric-entry** (only the two computational cells 1.7×3.B and 1.9×3.B). More
decisively: the loop was **proven live on Dev as MCQ** — the generator's "Fix 1" now stamps
**every** generated item `rubric_type='mcq'` so it grades on choice-match, and the numeric
`content_item_checks` sit **unused** (NEXT_SESSION_PROMPT §0/§6, action log 2026-08-24). The
one earlier "serving form = numeric-entry" decision (RELEASE_PATH_BRIEF banner, 2026-08-23)
was **superseded the next day** by the MCQ path that actually ran. So the mock depicts the
*minority, currently-dormant* modality as the whole loop.

**Why it matters (two reasons, one cosmetic, one about the mission):**

1. **Cosmetic/build:** the attempt widget is different (choice buttons vs. a numeric field),
   the "Orient must stay cold" rule plays out differently (an MCQ's distractors are
   misconception-encoded and appear *at attempt time*, not in orient), and a reviewer stepping
   through a numeric-only loop will design the wrong primary control. Draw **MCQ as the
   first-class loop**, with numeric-entry shown as a labeled variant for the two computational
   cells.

2. **Mission-level (the one to actually think about):** §7 makes "prove it transferred on a
   fresh question" *the* structural argument vs. a generic chatbot. Recognition among four
   options is a **weaker** transfer claim than production — and the current deterministic
   engine promotes `unseen → independent` on **one** correct independent attempt
   (NEXT_SESSION_PROMPT §0), with **no confidence adjustment** in `classifyWeight`
   (`cell-state.ts`: weight is independent/same-session/assisted/uncertain only — confidence
   is *not* an input). Put those together and a **1-in-4 lucky guess, marked "Guessing,"
   still lands full independent evidence.** The mock's confidence control is, for tiering
   purposes, currently **cosmetic** — it feeds the calibration display, not the tier.

   That is the single biggest fidelity risk in the whole set: the product promises "we prove
   the skill transferred, we don't just show you an answer," and the MCQ-only path with a
   guess-floor and confidence-blind weighting can **overstate mastery** (bumping against
   §8's "never materially overstate mastery" and INV-5's spirit).

**Recommendations (design + one engine question for David):**

- **Loop mock:** make **MCQ the primary** cold-attempt UI; show numeric-entry as a variant
  panel for computational cells. Keep the three-way submit on both.
- **Confirm-transfer for MCQ:** keep it central, but be **honest about the grain of the
  claim.** An MCQ transfer is *recognition* transfer; the two numeric-entry computational
  cells are where *production* transfer lives — make those two the visible showcase of "prove
  it," and don't let an MCQ recognition read as the same strength of proof.
- **Engine question (David's call, changes the mock's honesty, not just its pixels):** should
  a **"Guessing" + correct MCQ** earn full independent evidence? Options, all deterministic
  (INV-4-safe): (a) discount evidence weight when confidence = "Guessing" (a CM-D07 change —
  not built); (b) require the **confirm-transfer** beat before `independent` for MCQ items
  even on a first-try correct (so recognition never single-hops to independent); (c) accept it
  and rely on the delayed `confirmed` gate to catch guesses. This is *not* a mock-only
  decision — but the mock should reflect whichever way it goes, so flag it now rather than
  ship a control that implies it changes your tier when it doesn't.

---

## 4. Tension #2: the fortress words need an explicit, honest tier mapping

The header line — "9 skills locked · 3 slipping · 6 need a refresh" — is the emotional core
(loss-aversion fortress, CM-D04). But "locked / slipping / needs a refresh" are **three
words** and the model has **five tiers plus a fragile flag** (CM-D06). Without a pinned
mapping, Lovable will guess, and the most likely guess (locked = "doing well" = independent
*or* confirmed, maybe even a hinted `supported`) **violates INV-5** ("never render 'mastered'
after a help-assisted win") and the hard-constraint list's "no 'mastered' after a hinted win."

**Proposed mapping (make this explicit in the mock margin so it can't drift):**

| Fortress word | Maps to | Why |
|---|---|---|
| **Locked** | `confirmed` **only** (independent success again after a delay) | This is the only tier that is honestly "held against decay." INV-5: a `supported` (hinted) win is never locked; a bare `independent` (no delay yet) is *provisional* (CM-D06) — "almost," not locked. |
| **Slipping** | `fragile` flag (a prior success that later failed) | INV-6: the estimate reopened without erasing history. This is precisely "a lock that slipped" — the recurring reason to return (CM-D04). |
| **Needs a refresh** | decay-due (staleness crossed threshold; CM-D08 Family-A trigger) | Freshness decayed, not yet failed. Honest "come check this before it slips." |

**The gap this exposes:** where do `exposed_unverified`, `supported`, and
`independent-not-yet-confirmed` live? They are **not** locked, slipping, or needing a
refresh — they are **in progress**. The plan handles them correctly but *only in the queue*
(the four "Your 20 minutes" reasons map cleanly to the four Phase-1 triggers — see §6). So
the fortress strip is a **status summary of settled cells**, and the in-progress cells surface
as *actions*, not as a count. That's a defensible design — but the mock should **say** it,
or a student with 10 cells all mid-ladder will see "0 locked · 0 slipping · 0 need a refresh"
and think the product is empty. Consider a fourth, neutral "in progress / building" state in
the strip (no color of success), so a new unit doesn't read as a void.

**Sample-data consistency (small but do it):** "9 locked · 3 slipping · 6 need a refresh" =
18 cell-states, but the pilot is **~10 cells** (PILOT_PLAN §4). Fake numbers that exceed the
pilot's own scope will mis-calibrate every reviewer. Either make the sample internally
consistent with ~10 cells (e.g. "3 locked · 2 slipping · 4 refresh, 1 building") **or** label
the mock explicitly as "a mature unit, later in the year." Same discipline for `mastery.html`:
use the **actual pilot skill names** (PILOT_PLAN §3–4) — "Summary statistics for one
quantitative variable," "Comparing two distributions," "Describe a distribution (shape,
center, spread, outliers)," "Types of random sampling," "Bias in sampling," "Experimental
design" — so the plain-language layer is reviewed against real content, not placeholders.

---

## 5. Tension #3: the stuck-state offers a move the Phase-1 engine can't make

`stuck.html` offers three escalations: **Step Sideways** (different angle), **Step Apart**
(break into parts), **Step Down** (prerequisite, then return). Against the engine:

- **Step Down is Phase-2, deferred.** Dropping to a prerequisite and returning requires the
  **vertical edges of the principle graph**, which **do not exist in the data** and are
  explicitly deferred (CM-D12; MODEL §10 DEFERRED; PILOT_PLAN "cross-cell/prerequisite
  resurfacing is deferred"). The pilot **cannot route to a prerequisite cell.** A mock that
  offers "Step Down" promises routing the backend won't do for the pilot.
- **Step Apart is conditional.** "Break into parts and rebuild" needs an authored
  decomposition. For an MCQ interpret-and-pick item there often isn't one; it works only where
  a slot-frame or authored sub-structure exists. Available *sometimes*, not generally.
- **Step Sideways is the clean one.** "Another angle on the same skill" = serve a different
  item on the same cell. This the pilot can always do (subject to item inventory) and it
  never crosses a cell boundary (INV-2-safe).

**Recommendation:** for the **pilot** stuck experience, lead with **Step Sideways +
Move-on/Park**, show **Step Apart only where an authored decomposition exists**, and **cut
Step Down** (or clearly mark it "Phase 2 — not in the pilot" so nobody builds routing behind
it). The escalation *vocabulary* (Sideways / Apart / Down) is good and worth keeping in the
design system for later; just don't wire a pilot button to the one capability that isn't
there.

**Two more stuck-state notes:**

- **Frequency reality:** genuine escalation entry is evidence-gated (LEARNING_SYSTEM_STUCK:
  ~1.65 cumulative failure weight, ≥2 independent attempts, ≥2 distinct surfaces, a failed
  ordinary repair — §8.5). In a ~10-cell MCQ pilot with limited per-cell inventory, a student
  may **rarely reach true "stuck."** Design `stuck.html`, but treat it as **lower build
  priority** than the other three; it's the least-exercised surface in the pilot.
- **The "never 'stuck' about the learner" rule is correctly held** — keep it; the state
  belongs to the skill (§6). And "after ~two unsuccessful escalations, Move-on/Return becomes
  prominent, never a hard stop, no timer, no failure count" is exactly §6 / §10.3.2. Keep.

---

## 6. Smaller but real catches

- **Confidence belongs on the transfer attempt too, not just the first.** §12.1 says capture
  confidence before feedback on **every relevant** attempt. The confirm-transfer beat is
  another cold, independent attempt — it should carry the **same bundled three-way submit.**
  The plan only shows it on the initial cold attempt. Add it to Confirm-transfer. (This also
  strengthens the calibration data the whole `mastery.html` calibration block depends on.)
- **The four home-panel reasons are exactly right — lock them to the four Phase-1 triggers.**
  "Hasn't been checked in 11 days" = decay (Family A); "You got this with a hint last time —
  let's confirm it" = provisional-success confirm; "Missed this on Tuesday" = reopened/direct
  miss; "Your class just covered this" = new-exposure consolidation. These are the **only**
  four Phase-1 reasons (CM-D10/CM-D12). The plan says "these four and nothing else" — correct;
  make sure no fifth ("a related weak topic," "a prerequisite you're missing") sneaks in, since
  those are the deferred graph triggers and would be a promise the engine can't keep.
- **"Tier unchanged" on a miss is right, but not "nothing changed."** A miss **does** set the
  `fragile` flag and decrement weighted evidence (with a floor at 0; `cell-state.ts`, INV-6).
  So the honest phrasing is "**tier unchanged**" (true) — avoid implying the attempt left *no*
  trace, because a later "slipping" state will trace back to exactly this miss. Small wording
  precision; keeps the mastery surface consistent with the loop.
- **Evidence dimensions: the mock lists five; the source lists six.** §12.3 / §3.3 name
  effort, **accuracy/performance**, independence, retention, transfer, calibration. The mock
  drops accuracy. That's arguably a **good** deliberate choice — a bare "accuracy %" feeds the
  fluency illusion the product is fighting (CM-D03) — but make it a *decision, not an
  omission*: if accuracy appears at all, it must be qualified and clearly subordinate to
  independence (a hinted-correct is not mastery). Flag it so David signs off on dropping it.
- **Roll-up grain: plain-language *skill*, not just *topic*.** INV-1 says present coarse, but a
  single topic hosts multiple skills (e.g. topic 1.9 "Comparing distributions" = **3.B
  calculate** *and* **4.B justify**). Rolling all the way up to the topic would **merge** a
  cell you're independent on with one you're slipping on. The mock's example names ("Read a
  distribution's shape," "Compare two groups from summaries") are already at plain-language
  *skill* grain — good — so state the grain explicitly as "plain-language skill within topic,"
  and ensure two skills in one topic get **distinct** names, never collapsed into one bar.
- **Content-uncertain is correctly designed but will be rare in an MCQ pilot.** The abstain →
  `content_uncertain` path mostly fires on unparseable numeric entry / grading ambiguity; a
  well-formed MCQ choice-match rarely abstains. Design the paper-grey card (it's a real state,
  and honest), just know it's an edge state in this pilot, not a common beat.
- **"20 minutes" vs "3 questions" (the plan's own open item).** Recommend **items-primary,
  time-secondary**: "3 questions (~7 min)." Reasons: (a) the honest-uncertainty ethos —
  a time estimate is a guess and a student who runs over feels the product broke a promise,
  whereas "3 questions" is a count you can keep; (b) the time-scarce persona (Micah/Orly,
  CM-D01) responds to low, concrete activation energy; (c) internally the engine already ranks
  by priority ÷ **time cost** (CM-D09), so time is available as the *secondary* estimate
  without leading with it.
- **Cold orient must not pre-show the MCQ options.** "Coldness is a content guarantee, not
  UI-enforceable" is the right note — but the one thing the UI *can* enforce is not rendering
  the four (misconception-encoded) choices during Orient. Keep options in the attempt beat, not
  the orient beat.

---

## 7. Open questions for David (these change what the mock should show)

1. **MCQ guess-floor / confidence-in-tier (from §3).** Do we discount a "Guessing" + correct
   MCQ, gate MCQ `independent` behind confirm-transfer, or accept it and lean on the delayed
   `confirmed` gate? This decides whether the confidence control is honest-about-tiering or
   admittedly-calibration-only.
2. **Fortress "in progress" state (from §4).** Add a neutral fourth state to the strip so a
   new unit of mid-ladder cells doesn't read as an empty fortress — or keep the strip to
   settled cells only and rely on the queue? (I lean: add the neutral state.)
3. **Step Down in the pilot (from §5).** Cut it, or keep it visible as a labeled Phase-2
   placeholder? (I lean: cut from the pilot loop, keep the vocabulary in the design system.)
4. **Drop raw accuracy from `mastery.html` (from §6)?** Deliberate subordination to
   independence, or keep a qualified accuracy line?
5. **Session unit: items or minutes (from §6)?** (I lean: items-primary.)

---

## 8. Hard-constraint checklist Lovable must obey (consolidated, mapped to source)

Every mock must pass all of these. This is the plan's "never rendered" list, reconciled with
the invariants and de-duplicated:

- [ ] No skill/letter codes, no cell grid — plain-language skill within topic (INV-1).
- [ ] No miss/failure counter anywhere (§6, hard constraints).
- [ ] "Stuck" is never a label on the learner — only on a skill (§6).
- [ ] No "mastered"/"locked" after a hinted win — **locked = `confirmed` only** (INV-5, §4).
- [ ] A miss never resets a tier — tier shown "unchanged"; fragile/evidence change is allowed
      but not framed as a reset or a punishment (INV-6).
- [ ] No answer key and no full grading rationale reachable — this is a **live security
      invariant**, not just tone: grader "reasons" embed the answer and are redacted from
      student payloads (§6; and the `shadow_result` exposure the release brief §8 tracks).
- [ ] No score prediction anywhere (§9, §11 "not designed yet").
- [ ] No claim about *why* the student failed beyond the smallest observable gap (§4 Evaluate:
      observation separated from interpretation).
- [ ] Every mastery/estimate claim carries an "estimate" qualifier; improvement claims name the
      dimension **and** comparison period (§3.3, §12.3).
- [ ] Recommendation never disguised as a requirement; overrides recorded as preference, never
      noncompliance/negative evidence (§6, §10.3.1).
- [ ] Only the four Phase-1 due-reasons appear; no "related topic" / "prerequisite you're
      missing" (CM-D10/CM-D12).
- [ ] Content-uncertain reads as non-punitive, changes no tier/evidence, routes to review —
      never as a wrong answer (§4, fail-closed).

---

## 9. Per-mock punch list (what to change before build)

**`home-panel.html`**
- Keep the panel-above-home structure, the four reasons, equal-weight "Pick something else,"
  the "Coming back on" parked-skills line.
- Add the fortress→tier mapping in the margin (§4). Add a neutral "in progress/building"
  state or note why the strip only counts settled cells.
- Make the sample counts consistent with ~10 pilot cells (or label as a mature unit).
- Decide items-vs-minutes (§6/§7-5).

**`loop.html`**
- **Redraw the cold attempt as MCQ-primary**, numeric-entry as a labeled variant (§3).
- Put the bundled three-way submit on **both** the cold attempt **and** the confirm-transfer
  attempt (§6).
- Keep three distinct outcomes; on Incorrect, say "tier unchanged" (not "nothing changed").
- Keep Orient thin and free of the MCQ options.
- Keep the teach ladder (Tighten → Show full/faded/parallel) ending in a fresh independent
  attempt, no answer text — good as specified.

**`mastery.html`**
- Roll up to plain-language **skill-within-topic**, with distinct names for two skills in one
  topic (§6). Use real pilot skill names (§4).
- Confirm the five vs six evidence dimensions decision (drop-accuracy) with David (§6/§7-4).
- Keep the fortress-vs-decay strip honest-total/top-3; keep the calibration block rewarding
  accurate calibration and help-seeking, not confidence alone (§7 model).
- Keep the desirable-difficulty note **followed by delayed evidence**, not a request for faith
  (§7, §11.3) — the plan has this right.

**`stuck.html`**
- Lead with **Step Sideways + Move-on/Park**; **cut Step Down** (or mark Phase-2); Step Apart
  only where an authored decomposition exists (§5).
- Keep "stuck belongs to the skill," no timer, no failure count, Move-on always present.
- Treat as lower build priority — least-exercised surface in this pilot.

---

## 10. Bottom line on mission loyalty

The plan is loyal to the mission's *emotional* frame — fortress, loss-aversion, evidence over
faith, agency, honest uncertainty. The risk is not in the framing; it's that **MCQ pragmatism
can quietly hollow out the one claim the mission rests on** — "we prove the skill transferred,
we don't just show you an answer" (§7). Recognition-among-four, promoted to `independent` on a
single confidence-blind attempt, is not yet that proof. The fix is not to abandon MCQ (it's
the reliable pilot grader); it's to (a) be **honest about the grain** of an MCQ transfer
claim, (b) make the **two numeric-entry cells the visible showcase** of production transfer,
and (c) settle the **guess-floor/confidence-in-tier** question so the confidence control earns
its place in the loop. Do that, and the mocks will be loyal not just to the plan, but to why
Course Mode exists.
