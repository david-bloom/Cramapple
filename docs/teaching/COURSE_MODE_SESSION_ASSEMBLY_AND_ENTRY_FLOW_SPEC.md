# Course Mode — Session Assembly & Entry-Flow Spec

STATUS: build-ready design spec (requirements + flow, not visual design) | DATE: 2026-08-25 | AUDIENCE: David (decision-maker) → Claude Design (screens) → Lovable (build).

**What this fills.** Every prior Course Mode UX doc names one thing as unbuilt: **session
assembly** — *how "your 20 minutes" is presented and paced* (the "single biggest undesigned
job," `COURSE_MODE_STUDENT_UX_DEFINITION_2026_08_24.md` §12.1; also §3.1 "explicitly not yet
designed"). The `COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` specifies the *surfaces* (`/home`,
`/session/mcq`, `/learn`, `/progress`) and §11.4 names the two `/home` doors ("Start" card +
skills list) — but not **what happens after the student clicks a door.** This spec defines that:
the entry points, how the due-queue becomes an assembled session, how the session runs beat to
beat, and how it ends.

**What this does NOT do.** It is not visual design (no layout/pixels — that is Claude Design's
job, §11) and it does not re-derive the settled model. It executes nothing: no content, no
migration, no switch.

Governing docs (source of truth; not duplicated here):
- `COURSE_MODE_LEARNING_MODEL.md` — CM-D## decisions, INV-1..6 invariants, tier ladder, the
  due-queue (CM-D10/D11), the priority scalar (CM-D09).
- `COURSE_MODE_STUDENT_UX_DEFINITION_2026_08_24.md` — the jobs-to-be-done + hard constraints.
- `COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` — surface-by-surface integration (this spec is the
  session-flow layer that sits inside its §4.1/§4.2 surfaces and §11.4 doors).
- `COURSE_MODE_STUDENT_MOCKS_REVIEW.md` — the fidelity catches (items-vs-minutes, guess-floor,
  three outcomes, Step-Down cut) this spec applies.
- `COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` — the concrete 10-cell pilot set (§4) and the
  direct-RLS serving path (§6, RESOLVED).

---

## 0. Scope and the one-line job

**When a student opens `/home` and acts, give them a short, coherent, low-activation-energy run
of the right practice right now — assembled from their own due-queue, honest about why each item
is there, provable (not just shown), and always escapable — that ends by showing them what moved
and when it returns.**

Pilot scope (unchanged): AP Statistics Unit 1, the ~10 cells in PILOT_PLAN §4 (2 numeric-entry:
1.7×3.B, 1.9×3.B; 8 MCQ), MCQ + numeric-entry grading only, Learn mode as the shipped core
(Points mode is a thin fast-follow, INTEGRATION_SPEC §11.5).

---

## 1. The entry points on `/home` (what each door produces)

`/home` resolves to a small, fixed set of doors (INTEGRATION_SPEC §11.4). This spec defines the
**flow behind each**. All coldness rules follow the entry-context honesty rule (§6, from
INTEGRATION_SPEC §11.2): the *reason the student arrived* decides whether the first item counts.

| # | Door on `/home` | Produces | First-item condition | Detail |
|---|---|---|---|---|
| E1 | **"Start"** (primary card — the assembled session) | An **assembled multi-item session** built from the due-queue | **COLD** (due-review) | §2 assembly, §3 run |
| E2 | **A single previewed queued item** (each of the ~3 preview rows on the Start card is individually startable) | A **one-item session** on that cell | **COLD** (due-review) | §3 run, single item |
| E3 | **Click a skill** in the "Unit 1 Skills" rail (to *learn* it) | A **learn-first entry**: skill orientation (what it's about / the skill you need / the move that earns the points) → open-hand worked example → the student's own cold attempt | **COACHED** first item, zero evidence (INV-5); only the cold attempt that follows counts | §5 |
| E4 | **Resume** a live/interrupted session | Re-enters the in-progress session at the next unfinished beat | unchanged from when paused | §3.5 |
| E5 | **"Homework helper"** camera stub (demand probe) | Records an interest click, reveals "coming soon" | n/a | Deferred (INTEGRATION_SPEC §11.3/§11.4); no session |

Points-mode variant: the **same doors and the same session mechanics** run; only the lead framing
and result value-language change (INTEGRATION_SPEC §2, §4.2). Points-mode assembly ranks by
"highest-value on this unit," never a "+N pts" projection (§8 no-projected-score).

**Agency rule (all doors).** A recommendation is never disguised as a requirement. E1 is
*suggested*, not forced; E2/E3 are always available alternatives; "Pick something else" carries
equal visual weight to "Start" (UX_DEFINITION §6; MOCKS_REVIEW §1). Overrides are recorded as
preference, never as noncompliance or negative evidence.

---

## 2. Session assembly — how the due-queue becomes "your N questions"

This is the core gap. Assembly is a **deterministic read** of the per-cell due-queue (CM-D11:
one row per cell = `next_due_at` + `reason`), ranked by the priority scalar (CM-D09), rolled up
to plain language (INV-1). It is not a model inference (INV-4).

### 2.1 Session size — items-primary, time-secondary

**DECISION (PROPOSED — David sign-off): a session is a small fixed count of items, displayed
items-first with a soft time estimate.** Default **N = 3 items**, shown as **"3 questions
(~7 min)"**.

Rationale (MOCKS_REVIEW §6, the "20 minutes vs 3 questions" catch):
- Honest-uncertainty ethos: a time cap is a guess; a student who runs over feels the product
  broke a promise. A **count** is a promise the product can keep. Time is an *estimate*, qualified.
- The time-scarce persona (Micah/Orly, CM-D01) responds to low, concrete activation energy —
  "3 questions" reads as finishable.
- The engine already ranks by priority ÷ **time cost** (CM-D09), so a time estimate is available
  as the secondary number without leading with it.

The **N items are the counted spine** (§2.4). Sub-beats within an item — teach, and the
confirm-transfer "prove it" attempt — are **not** counted against N (they are part of proving the
one skill), so the progress meter never inflates or surprises the student.

Edge cases:
- **Fewer than N cells due** → assemble a shorter honest session ("2 questions today — you're
  caught up"); never pad with not-yet-due cells to hit N (that would manufacture work and dilute
  the "why this?" honesty). New-exposure consolidation cells (E-below) may top up.
- **Zero cells due** → no empty session. `/home` shows the honest caught-up state ("Nothing's due
  right now — everything's holding") and offers E3 (learn a new skill) as the forward move, not a
  fabricated queue. This reuses the front-end's existing "empty tracks rather than fake progress"
  discipline (INTEGRATION_SPEC §4.1).
- **"Keep going"** — after finishing N, offer an optional "one more?" that pulls the next queue
  item; never auto-extend, never a hard stop. (Open item §7.4.)

### 2.2 Selection — top-N from the due-queue by priority

Take the N highest-priority **due** cells (CM-D09 scalar ≈ exam-value × deficit × improvability ×
staleness ÷ time-cost). Constraints:
- **Honest thresholds gate inclusion** — a cell below the evidence bar is not claimed as a
  known state; it still may be *served* for practice, but its `/home` reason is stated honestly
  (INTEGRATION_SPEC §4.1 "no state claimed below the evidence bar").
- **Only the four Phase-1 due-reasons** may appear (§2.3). No cell enters the session under a
  deferred graph reason ("a related weak topic," "a prerequisite you're missing") — those don't
  exist for the pilot (CM-D12; MOCKS_REVIEW §6).
- **One cell → at most one counted item per session.** A cell's confirm-transfer beat is a
  *second attempt on the same cell within its item*, not a second session slot (§3.3).

### 2.3 Each item carries its plain-language "why" (the four reasons)

Every assembled item shows *why it is queued*, in the front-end's established voice
(INTEGRATION_SPEC §3), locked to the four Phase-1 triggers (CM-D10/D12) — no fifth:

| Due-reason (internal trigger) | Student-facing line (voice per §3) |
|---|---|
| decay / maintenance (Family A, CM-D08) | *"Time to see if this still holds"* |
| provisional-success confirm (a `supported` win) | *"You needed a hint last time — let's see it stick without one"* |
| reopened / direct miss (Family B) | *"Missed this on Tuesday — worth another look"* |
| new-exposure consolidation (class advanced) | *"Your class just covered this"* |

The Start card previews the N items with these reasons and each item's plain-language skill name
(never a `4.B` code, INV-1). Two skills in one topic (e.g. 1.9 hosts calculate *and* justify)
stay **distinct** rows, never merged (MOCKS_REVIEW §6).

### 2.4 Ordering / interleaving

**DECISION (PROPOSED): interleave skills across the session; do not block by topic.** Serve the N
items as N *different* cells where inventory allows, in priority order but not two consecutive
items on the same skill.

Rationale: interleaved/mixed practice is a desirable difficulty (UX_DEFINITION §7 / §11.3) — it
*feels* harder and produces more mistakes while improving retention. The product's honesty move is
to **name that** ("mixing skills feels harder — that's the point") and later **show the delayed
evidence**, not ask for faith. Ordering caveat: lead with an item the student can get traction on
where possible (avoid opening on the single hardest cell), so the session doesn't start in a hole.

---

## 3. The session run — beat by beat from Start to finish

A session is a **container** that runs the per-item core loop (INTEGRATION_SPEC §4.2 / UX_DEFINITION
§4) N times, with session-grain chrome around it. The container lives at `/session` (the existing
route family; MCQ items render the `/session/mcq` loop, numeric-entry items a variant panel).

### 3.1 Session container chrome (session grain)

- **Progress:** "Question 2 of 3" (items-primary, §2.1). The meter counts only the N spine items;
  teach and confirm-transfer sub-beats do not advance it.
- **Escape hatch, always present:** "Move on / Return later" at item grain, and "End session" at
  session grain — both non-punitive, no timer, no failure count (UX_DEFINITION §6). Ending early
  is a clean, honest exit, not an abandonment.
- **No forced completion, no time cap, no countdown clock** on the session (a soft "~7 min"
  estimate is fine; a ticking timer is banned — it manufactures the pressure the product is
  fighting).
- **No pre-session setup page (DECISION, David 2026-08-25).** There is **no `/session/setup`**
  step. Session size, unit/topic scope, and Learn/Points mode are chosen on `/home` (the doors +
  selectors already there); their **changeable defaults are surfaced inline on `/session`** — an
  unobtrusive, adjustable line (e.g. "3 questions · Unit 1") the student can tweak in-flow — not on
  a separate config screen. A `/home` door opens straight into the running session.

### 3.2 The per-item loop (rendered inside the container)

Each item runs the settled 8-beat loop (UX_DEFINITION §4), unchanged; this spec only situates it
inside the session:

**Orient (cold) → Cold attempt + confidence → Evaluate → [Diagnose → Teach → Independent retry, if
missed] → Confirm transfer → Schedule next review → advance to next item.**

- **Orient stays cold** and, for MCQ, **must not pre-render the choices** (the misconception-encoded
  distractors appear at the attempt beat, not orient) — the one UI-enforceable part of coldness
  (MOCKS_REVIEW §6). During a cold attempt the skill rail (§3.6) shows **only** the topic +
  plain-language skill name and *what this is about* — never the point-earning move or the
  point-loss (those are repair-only, §3.4 / §3.6).
- **Confidence is bundled into submit** ("Sure / Think so / Guessing" *is* the submit control),
  captured before feedback, on **every** cold attempt — the initial one **and** the confirm-transfer
  one (MOCKS_REVIEW §6). "Guessing" is a safe, non-stigmatized choice.
- **Three graded outcomes render distinctly** (UX_DEFINITION §4; INTEGRATION_SPEC §4.2):
  - **Correct** → advance/maintain; a *clean* win offers **Stretch** (a slightly harder surface)
    then flows to confirm-transfer.
  - **Incorrect (direct miss)** → enter Diagnose→Teach→Retry (§3.4); mark the cell `fragile`;
    show tier **"unchanged"** (true — a miss never resets the tier, INV-6) but do **not** imply
    "nothing changed" (a later "worth another look" traces back to this miss, MOCKS_REVIEW §6);
    never a miss counter, never shame.
  - **Content-uncertain** → a distinct, non-punitive "we're not sure about this one" state
    (paper-grey); changes **no tier and no evidence**, routes to review; must not read as wrong
    (fail-closed). Rare in an MCQ pilot but real (MOCKS_REVIEW §6).

### 3.3 The confirm-transfer beat inside the session

"Prove it on a second question" is the product's structural differentiator vs. a chatbot
(UX_DEFINITION §7). Its placement in the session:

- On a graded-correct cold attempt, insert a **"Different question, same skill"** item — a fresh,
  **changed-surface**, no-help attempt — as the beat that closes the cell as an *independent*
  success. It carries the same bundled confidence control (it is another cold attempt).
- It is a **sub-beat of the same counted item**, not a new slot: the progress meter stays on
  "Question k of N" through both attempts. This is why one cell → one counted item (§2.2).
- **Honest grain of the claim:** an MCQ transfer is *recognition* transfer; the two numeric-entry
  cells (1.7×3.B, 1.9×3.B) are where *production* transfer lives — make those the visible showcase
  of "prove it," and don't let an MCQ recognition read as the same strength of proof
  (MOCKS_REVIEW §3). Whether an MCQ single-hop to `independent` is even allowed is the open
  guess-floor decision (§7.1) — if David gates MCQ `independent` behind confirm-transfer, this beat
  becomes *mandatory* for MCQ, not optional.

### 3.4 When an item is missed — folding teach back into the session

A miss must not eject the student from the session or dead-end them:

- **The point-earning move + "where students lose it" surface HERE, in repair — not before the cold
  attempt (DECISION, David 2026-08-25).** The two "money" lines of the skill orientation (§5) are
  held back from the cold attempt and delivered as Teach content when the student misses (or
  deliberately pulls help): **Tighten** delivers the *where-students-lose-it* nudge aimed at the
  exact gap (e.g. *"Two descriptions side by side isn't a comparison yet — say which is higher"*),
  and the *move that earns the points* frames the **Show** worked example. This keeps the cold
  attempt honest — the move is answer-shaped help, so surfacing it flips the attempt to assisted and
  drops its evidence weight (INV-5) — while putting the highest-value coaching exactly where it
  lands. One authored source (the per-skill orientation record, §5) feeds both the learn-first
  opener and this repair content.
- **Default: inline least-revealing teach**, in-session. The `HelpPanel` ladder — **Tighten**
  (targeted nudge at the exact gap) → **Show** (a worked example: full → faded → **parallel**) —
  runs inside the item, always ending in a fresh independent retry (UX_DEFINITION §4;
  INTEGRATION_SPEC §4.2). **The worked example is a *parallel* instance, never the item on
  screen** — for an MCQ a worked solution to the live item is an answer-key leak (a live security
  invariant; the `mcq_choices` leak, PR #106). No answer text, no grading rationale ever reachable.
- **"Go deeper" branch (optional):** a miss that needs more than an inline nudge offers "go deeper
  on this" → the in-depth `/learn/$subject/$unit/$topic` surface (INTEGRATION_SPEC §4.3);
  **returning drops back into the session at the same item.** The session is paused, not lost.
- **Stuck escalation, pilot-trimmed** (MOCKS_REVIEW §5; INTEGRATION_SPEC §4.3): lead with **Step
  Sideways** (another item on the same skill — always available, INV-2-safe); **Step Apart** only
  where an authored decomposition exists; **Step Down is cut** for the pilot (no prerequisite
  routing — the principle graph is Phase-2, CM-D12). After ~two unsuccessful escalations, **"Move
  on / Return later" becomes the prominent suggestion** — never a hard stop, never a timer, never a
  failure count. "Stuck" is a state of the skill, **never a label on the learner**.

### 3.5 Pause / interrupt / resume (E4)

- A session can be left at any beat (Move on, End session, or simply leaving). State persists so
  `/home` can offer **Resume** (E4) back to the next unfinished beat.
- **At-most-once evidence integrity:** a re-entered or re-graded attempt must not double-count
  evidence — the engine already enforces this (`last_attempt_id`, first terminal grade wins;
  STATUS_AND_HANDOFF §2 Fable F2). The UI must not present a resumed item as a fresh cold attempt
  if it was already graded.

### 3.6 Session layout & the skill rail

The `/session` screen is a **two-column shell** (DECISION direction, David 2026-08-25; the visual
design is Claude Design's to render). It replaces the current single-column "YOUR TASK / Answer"
screen.

- **Header — name the skill, not "Your Task."** Replace the generic *"Your Task"* label with the
  **topic + plain-language skill name** (e.g. *"Comparing distributions · Compare two groups from a
  graph or summary"*, INV-1 — never a `4.B` code). Honest to show on any attempt; the skill *name*
  leaks nothing.
- **Left rail — the "skill card," gated by beat / entry:**
  - **Cold attempt** (due-review E1/E2, and learn-first's "now you try" beat): rail shows **only**
    the skill name + *what this is about*. The **move that earns the points** and **where students
    lose it** are **absent** — repair-only (§3.4).
  - **Learn-first coached beats** (E3 opener): rail shows the **full** points-led orientation (all
    four beats, §5), pinned as reference while the student works the coached example — teaching-first
    door, coached, zero evidence.
  - **Repair** (after a miss / on help): the move + point-loss enter as Teach content (§3.4); the
    rail may expand to keep them visible through the retry.
- **Right column — the attempt:** stem + stimulus, then the answer control. **MCQ is first-class**
  (choice buttons); the two computational cells (1.7×3.B, 1.9×3.B) use a **numeric-entry** field.
  **Open free-text is out of pilot scope** (open-FRQ grading needs the unbuilt R&D grader) — the
  live FRQ screen's free-text box + "~30 min remaining" timer are **not** the Course-Mode pilot
  loop.
- **No session countdown timer** (§3.1) — replace "~N min remaining" with the items-primary
  progress ("Question k of N").
- **Mobile reflow:** the two columns stack; the skill rail collapses to a top accordion so it can
  never push the answer control off-screen (accessibility: keyboard/focus order, `aria` labels).

---

## 4. Session completion — the wrap-up

The end of a session is where the product **shows the student its own evidence** rather than
asking for faith (UX_DEFINITION §2). It is a distinct beat, not a silent return to `/home`.

The wrap-up must be able to show, honestly:
- **What moved** — per skill, in plain language and estimate-qualified: what advanced, what was
  confirmed, what reopened ("worth another look"). Name the dimension; never a bare "great job."
- **What's scheduled to return, and when** — the loss-aversion payoff and the recurring reason to
  come back: "we'll bring [skill] back on <date> to see if it still holds." This makes the
  fortress-vs-decay frame legible without the banned "fortress/locked/slipping" vocabulary
  (INTEGRATION_SPEC §3).
- **A calibration nudge where the data supports it** — reward accurate calibration and help-seeking,
  not confidence alone (UX_DEFINITION §7): e.g. overconfident (wrong + "Sure") → gently contrast
  the misconception; underconfident (independently right + "Guessing") → show the evidence to
  stabilize confidence. This is where the per-attempt confidence data (§3.2) pays off.
- **The forward move** — re-assemble the next session from the *updated* queue (the just-answered
  cells are now scheduled out; new ones may have surfaced). "Start" on the next `/home` reflects
  the new state.

**Never at completion:** a projected score of any kind (§8); a "mastered" claim after any hinted
win (INV-5); an answer key or full rationale; a miss/failure counter; a streak mechanic beyond the
honest fortress-vs-decay frame (UX_DEFINITION §11).

---

## 5. Learn-first entry flow (E3) in detail

Clicking a skill in the "Unit 1 Skills" rail to **learn** it (INTEGRATION_SPEC §11.2) opens a
teaching-first entry — a distinct assembly from the due-review session:

1. **Skill orientation — the "what this is and how it scores" header (leads the session).** Before
   any worked example, the learn-first entry opens with a short, plain-language orientation to the
   skill, in three beats — the skill-grain, **points-led** sibling of the existing per-topic
   `TopicBrief` point brief (which already carries *what it is / why it matters / how points are
   earned / answer move / common point loss*, INTEGRATION_SPEC §11.4). The register is David's
   framing:
   - **What this is about** — the concept in plain language. *"This is about comparing two
     distributions…"*
   - **The skill you need** — name the move the skill requires (plain language, never a `4.B` code,
     INV-1). *"You need to read center, spread, and shape for each group and line them up…"*
   - **The move that earns the points** — the concrete, point-earning action the AP exam rewards.
     *"You earn points when you use this skill by making an explicit comparison in context —
     'Group A's median is higher than Group B's' — not by describing each group on its own."*
     (Optionally: the common point-loss to avoid, mirroring the point brief's last field.)
   This is **NEW authored content at skill grain** (authored/vetted, INV-3, never model-generated on
   the fly). **Honesty guardrail:** "the move that earns the points" describes the *general* skill
   move only — it must never reveal the answer to the open-hand example or to any served item (the
   live no-answer-key security invariant, §8).
2. **A first question played "open hand"** — worked in full; we show how to solve it, demonstrating
   the point-earning move from beat 1 on a concrete instance. **COACHED → zero mastery evidence
   (INV-5).**
3. **Handoff to the student's own cold attempt** ("now you try, no help") — this is the first beat
   that *counts*, and it runs the normal per-item loop (§3.2) including confirm-transfer.

This reuses existing machinery: `/session/mcq` already tracks `attempt_condition` cold|coached and
zeroes evidence when help is used — the orientation + open-hand example simply set `coached` for
that first item (INTEGRATION_SPEC §11.2).

**Two homes for the same content, gated by coldness (DECISION, David 2026-08-25).** *What this is
about* / *the skill you need* are safe to show ambiently. The **move that earns the points** and
**where students lose it** appear up front **only here, in the learn-first opener** (teaching-first,
coached). On a **cold / due-review attempt they are held back and surface only in repair** (§3.4) —
the same authored per-skill record, two placements decided by whether the attempt counts.

**New content dependency (flag for David):** the per-skill orientation (the three-beat header above)
+ the open-hand worked example do not exist yet; they are authored content on the critical path for
E3 (not for E1/E2, which serve existing published items). The orientation is authored once per
pilot skill, analogous to how `TopicBrief` point briefs are authored per topic.

---

## 6. Entry-context coldness matrix (the honesty rule made concrete)

| Entry | First item condition | Counts toward mastery? | Why |
|---|---|---|---|
| E1 Start (assembled due-review) | **COLD** | Yes (per weight) | The queue surfaced it; cold retrieval is the test |
| E2 Single queued item | **COLD** | Yes (per weight) | Same as E1, one item |
| E3 Learn-a-skill | **COACHED** (explainer + open-hand) | **No** on the taught item; the following cold attempt counts | INV-5: a taught win is not mastery |
| E4 Resume | as-paused | as-originally | No re-count (§3.5) |

`classifyWeight` (`cell-state.ts`) is the deterministic authority (INV-4): independent + changed-
surface + after-delay = full; same-session = 0.65; near-identical repeat = 0.35; assisted/coached
= 0; uncertain = 0. The UI's only job is to feed a **truthful** cold/coached + help-used +
changed-surface signal from each attempt (INTEGRATION_SPEC §4.2 — `assistanceState`,
`attempt_condition`, `help_level_used` already flow to the grader).

---

## 7. Open decisions for David (these change the flow, not just pixels)

1. **MCQ guess-floor / confidence-in-tier** *(the load-bearing one, carried from
   INTEGRATION_SPEC §9 / MOCKS_REVIEW §3, §7-1).* A "Guessing" + correct MCQ currently earns full
   `independent` evidence (`classifyWeight` ignores confidence; the engine promotes
   `unseen→independent` on one correct attempt). Options, all deterministic/INV-4-safe: (a) discount
   evidence weight when confidence = "Guessing" (a CM-D07 change, not built); (b) **require the
   confirm-transfer beat before `independent` for MCQ items** even on a first-try correct
   (recommended default here — makes §3.3 mandatory for MCQ and keeps the "prove it" claim honest);
   (c) accept it and rely on the delayed `confirmed` gate. **This decides whether confirm-transfer
   is mandatory (b) or optional (a/c) in the flow.**
2. **Session size N.** Default 3 (§2.1). Confirm, or set per-mode (e.g. Learn 3, Points 5).
3. **"Keep going" after N** (§2.1) — offer an optional one-more pull, or end cleanly at N.
4. **Interleave vs. block** (§2.4) — recommended interleave; confirm.
5. **Learn-first content dependency** (§5) — approve authoring per-skill explainers + open-hand
   examples as pilot-critical content, or defer E3 to a fast-follow and ship E1/E2 first.

---

## 8. Hard-constraint checklist (session flow must obey — consolidated)

Mapped to source; every screen in the flow passes all of these (superset of
INTEGRATION_SPEC §8 / MOCKS_REVIEW §8, session-specific):

- [ ] No time cap, no countdown clock, no forced completion; escape hatch present at item + session
      grain (UX_DEFINITION §6).
- [ ] Items-primary progress ("k of N"); teach + confirm-transfer sub-beats do not advance the
      meter (§2.1/§3.3).
- [ ] Confidence captured before feedback on **every** cold attempt, incl. confirm-transfer
      (MOCKS_REVIEW §6). "Guessing" non-stigmatized.
- [ ] Orient cold; MCQ choices not pre-rendered in orient (MOCKS_REVIEW §6).
- [ ] Three outcomes render distinctly; content-uncertain non-punitive, changes no tier/evidence
      (UX_DEFINITION §4).
- [ ] Miss → tier "unchanged" (not "nothing changed"); `fragile`/evidence change allowed, never a
      reset or punishment; no miss counter (INV-6).
- [ ] Worked examples are **parallel** items only; no answer key / grading rationale ever reachable
      — live security invariant (PR #106).
- [ ] Only the four Phase-1 due-reasons in assembly; no "related topic" / "prerequisite" reason
      (CM-D10/D12).
- [ ] Step Down not wired in the pilot; "stuck" never labels the learner (MOCKS_REVIEW §5).
- [ ] No skill/letter codes, no cell grid; plain-language skill within topic; two skills in one
      topic stay distinct (INV-1).
- [ ] "Sticking"/"strong" = `confirmed` only; never after a hinted win (INV-5).
- [ ] No projected score anywhere, incl. the wrap-up (§8 guardrail; Points mode ranks by value,
      not "+N pts").
- [ ] Recommendation never disguised as a requirement; overrides recorded as preference.
- [ ] Estimate-qualified claims; improvement claims name dimension + comparison period; honest
      thresholds reused, no claim under the evidence bar.

---

## 9. Data / contract implications (for the build handoff)

These are the deltas the flow needs on top of what already exists (INTEGRATION_SPEC §6). No DDL
here — logical contract only; verify field/route names against the live front-end
(`david-bloom/exam-buddy-wireframe` / the current Lovable project) at build time, same anti-drift
discipline as MOCKS_REVIEW §2.

- **Session-assembly read** — a deterministic top-N pull from the per-cell due-queue (rolled up
  from `student_cell_state`, the F2/F3 store), returning per item: cell → plain-language skill name,
  due-reason (one of four), priority rank, serving item ref, and time-cost estimate. Server-fn +
  tests, mirroring the existing point-capture computation. Reuses the direct-RLS serving path
  (`usePublishedMcqs`-style) — cell-tagged, published, `rubric_type='mcq'` items — per PILOT_PLAN §6
  (RESOLVED); no `validated` serving label needed.
- **Session state** — persisted enough to drive progress ("k of N"), Resume (E4), and at-most-once
  integrity (§3.5). The item loop already routes through `useGradePractice` → `evaluate-attempt` →
  `persistCellState`; the session layer wraps, it does not replace, that.
- **Confidence field** — bundled into the grade-submit input on every cold attempt (already
  identified, INTEGRATION_SPEC §6); its evidence-weight effect depends on §7.1.
- **Per-skill orientation + open-hand example content** — the E3 dependency (§5): a skill-grain,
  points-led orientation (what it's about / the skill you need / the move that earns the points),
  the skill-grain sibling of the per-topic `TopicBrief` point brief, plus an open-hand worked
  example. Authored, vetted (INV-3).
- **Mode** — `learn | points` preference already specified (INTEGRATION_SPEC §2/§6); drives
  assembly ranking language + wrap-up value language only, not the mechanics.

---

## 10. Explicitly deferred (do not build in the pilot)

- Student-declared quiz/test (date + scope) and the scoped Points-mode session it would date/scope
  (INTEGRATION_SPEC §7/§11.5 — the full Points value prop).
- Step Down / prerequisite routing and any cross-cell "related topic" resurfacing (needs the
  principle graph, CM-D12).
- Open free-response answering/grading in the session (needs the R&D grader; skill-4 ideas serve as
  MCQ interpret-and-pick).
- Homework-image intake as a live session entry (E5 stays a demand-probe stub;
  research record: `docs/research/HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md`).
- Score prediction of any kind.

---

## 11. Handoff

This spec is the session-flow brief Claude Design turns into screens (the assembled-session run,
the wrap-up, the learn-first entry, the miss→teach fold-in) and Lovable builds as **changes to the
existing `/home` doors and the `/session` container** — not a new destination (CM-D02 anti-fork).
It composes with INTEGRATION_SPEC §4 (the surfaces) and depends on David resolving §7 (especially
§7.1, the guess-floor decision) before the confirm-transfer placement (§3.3) is finalized.
