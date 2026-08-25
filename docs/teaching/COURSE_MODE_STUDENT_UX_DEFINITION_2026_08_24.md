# Course Mode — Student Experience: What the UX Must Accomplish

STATUS: UX definition (requirements, not visual design) | DATE: 2026-08-24 | AUDIENCE: David, then Claude Design (design), then Lovable (build).

**How to use this doc.** This is the articulation of *what the Course Mode student experience
must accomplish and the rules it must obey* — the "jobs to be done," the model it must render,
and the hard constraints. It is **not** a visual design and does not prescribe layout. Hand this
to Claude Design to produce screens/flows; then hand the design to Lovable to build. §12 lists the
questions that are genuinely the designer's to answer.

The pedagogy and mastery model below are **settled** (governed by
`COURSE_MODE_LEARNING_MODEL.md` and the learning-system docs). What is open — and undesigned
today — is how they are *rendered* to a student. That gap is what this fills.

Companion docs: `COURSE_MODE_LEARNING_MODEL.md` (CM-D## decisions, INV-1..6 invariants),
`LEARNING_SYSTEM.md` / `LEARNING_SYSTEM_STUCK.md` (the loop + escalation),
`TEACHING_AND_PEDAGOGY_DESIGN.md` (progress display, confidence/calibration),
`COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md` (pilot scope).

---

## 1. The one-sentence job

**Give a student a short, guided session that serves the right practice right now, proves a skill
actually transferred (not just that an answer was shown), and shows the student their own evidence
that learning is being locked in against forgetting — so that opening the app again next week feels
worth it.**

## 2. The promise the experience sells (the emotional frame, CM-D04)

- The product promise is **"lock in *learning*"** — the controllable part of the grade — not a
  grade or a score prediction.
- Mastery is a **fortress the student defends against decay**, not a one-time badge. The recurring
  reason to return is that **locks slip** over time. Frame with loss-aversion ("don't leak a point
  you already earned"), not accumulation.
- The behavioral enemy is the **fluency illusion** (cramming/ re-reading *feels* effective) plus
  future-discounting. The UX's job is to make the long-horizon, harder-feeling path feel rewarding
  *now*, and to **show the student their own evidence** rather than ask for faith.

Every screen should be answerable against: *does this help a student lock in learning and see that
it's happening?*

## 3. Primary surfaces and the job each must accomplish

Four surfaces. Design may combine or sequence them, but each job must be met.

### 3.1 "Your session" / home — *what should I do right now?*
- Presents a short, assembled session (think "your 20 minutes"), not an open catalog.
- Draws from a single per-cell **due-queue** (one row per cell: what's due, why, when) ranked by a
  next-best-action score ≈ (exam value × deficit × improvability × staleness) ÷ time cost.
- Tells the student *why* this is queued in plain language (see the due-reasons in §5) and roughly
  how long it will take.
- Must offer agency: start the suggested session, or choose otherwise. A recommendation must never
  be disguised as a requirement.
- **Note:** session assembly UX is named as required but was explicitly *not yet designed* — the
  single biggest open design job (§12). Now specified in
  `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` (2026-08-25).

### 3.2 The practice surface — *the core loop* (§4)
Where an item is served, attempted cold, evaluated, taught if needed, and re-proven. This is the
heart of the experience and must render the 8-beat loop and the three graded outcomes distinctly.

### 3.3 The mastery / progress surface — *am I actually getting this, and is it sticking?*
- Renders the student's own **evidence**, at the **topic/practice roll-up grain — never the
  internal cell grid, and never letter/skill codes** (INV-1).
- Must be able to show, in plain language: effort done, accuracy, **independence** (wins without
  help), **retention** (wins after a delay), **transfer** (wins on a changed surface), and
  **calibration** (confidence vs. performance).
- Must render the **fortress-vs-decay** state: what's locked, what's slipping, what's newly at risk
  — this is what makes returning feel necessary.
- Improvement claims must name the dimension and comparison period ("more independent this week than
  last"), never a vague "you're doing better."

### 3.4 The struggle experience — *I'm stuck, now what?* (§6)
Not a separate screen necessarily, but a distinct mode inside the loop with its own rules (§6),
including a prominent, non-penalizing way out (Move On / Return later).

## 4. The core loop (render this, beat by beat)

The student should recognize this structure within ~two sessions — the structure is itself a
transferable study skill. Beats:

**Orient → Cold attempt (+ confidence) → Evaluate → Diagnose → Teach (least-revealing) → Independent retry → Confirm transfer → Schedule next review.**

- **Orient** without leaking the answer. The default is a **cold** orientation: it must **not** name
  the tested concept, reveal a distractor's misconception, name the required formula, enumerate
  hidden criteria, or summarize the data trend. (Coached and Exam orientation modes exist but Cold
  is the pilot default.)
- **Cold attempt** — the student does the work *before* any teaching. **Capture confidence before
  showing feedback**, every relevant item, on a small consistent scale. Confidence is evidence, not
  decoration.
- **Evaluate** — show the smallest observable gap; separate the observed result from its
  interpretation.
- **Teach — least-revealing intervention.** Repair with the smallest help that works, always ending
  in a fresh independent attempt. Repair modes the UX must support: **Tighten** (a targeted nudge at
  the exact gap — e.g. an inline bracket marker with a Socratic prompt), **Show** (a faded worked
  example: full → faded → parallel), **Stretch** (after a clean win, confirm on a slightly harder
  surface). *Reading an explanation is never accepted as learning.*
- **Confirm transfer** — the "prove it" moment: a fresh, structurally-related item with a **changed
  surface** and no answer-bearing help. Only an independent transfer can close an interaction as a
  provisional success.
- **Schedule / Move on** — write the next review; "Move on and return later" is always available and
  never penalized.

**The three graded outcomes must look and feel different:**
| Outcome | What it means | What the UX does |
|---|---|---|
| **Correct** | Right answer; evidence weighted by independence/surface/delay | Advance or maintain; a *clean* win offers **Stretch** (transfer) |
| **Incorrect (direct miss)** | Wrong answer | Enter Diagnose→Teach→Retry; mark the cell **fragile**; **never reset the tier to zero**; never shame |
| **Content-uncertain** | Grader abstains / source or rubric ambiguity | A distinct, **non-punitive "we're not sure about this one"** state — changes **no tier and no evidence**, routes to review. Must not read as a wrong answer. |

## 5. The mastery model the UX renders

- **Cell = topic × skill** is the internal atom, but **stored fine, presented coarse** (INV-1):
  students see topics/units and plain-language skills, never `4.B`-style codes or the raw cell grid.
- **Tier ladder (discrete, ordered — not a percentage):** `unseen` → `exposed_unverified` (class
  taught it, we haven't verified) → `supported` (correct only *with* help; provisional) →
  `independent` (correct on a fresh changed-surface item, no help) → `confirmed` (independent again
  *after a delay*). A **`fragile`** flag marks a skill that later slipped. **A miss never resets a
  tier** — honesty over punishment.
- **What advances a tier is deterministic** (never model judgment): weighted evidence from attempt
  history — independent + changed-surface + after-a-delay counts most; a near-identical repeat
  counts little; help-assisted or uncertain counts zero.
- **Decay & due:** each cell's freshness decays at a tier-dependent rate (supported fast,
  independent medium, confirmed slow) and intervals **compress as the exam nears**. Everything
  reduces to a due-queue with a **reason** the UX should express in plain language. Phase-1 reasons:
  *maintenance/decay*, *new-exposure consolidation*, *reopened miss*, *confirm a provisional success*.
- **What a student must be able to see about their mastery:** independence, retention, transfer,
  calibration, effort — as evidence, honestly qualified as estimates.

## 6. Stuck-state, agency, and the hard "must not show" list

- **"Stuck" is a state of one skill, never a label on the student.** Never show the word "stuck"
  about the learner, and never show a failure counter.
- Entry to escalation is evidence-weighted (multiple distinct items/surfaces + a failed ordinary
  repair), not a raw miss count — but that's engine logic; the UX job is to *offer the right next
  move and always an escape hatch*.
- **Escalation moves the UX must support:** a different angle on the same skill (Step Sideways),
  breaking a skill into parts and rebuilding (Step Apart), dropping to a prerequisite then returning
  (Step Down). Also: fade-support-then-cold-retry, and `content_uncertain` routing.
- **Move On / Park:** after ~two unsuccessful escalation attempts, make "Move on / Return later" the
  *prominent* suggestion — but never a hard stop, never a time cap. Offer clear choices (try another
  approach / move on and return later / move on for now / end session).
- **Recommendation-with-override everywhere:** the interface must not disguise a recommendation as a
  requirement; overrides are recorded as preference, never as noncompliance or negative evidence.

**Hard UI constraints (treat as non-negotiable):**
- **MUST NOT show:** the word "stuck" as a learner label; a failure/miss counter; unsupported claims
  about *why* the student failed; a "mastered" claim after a help-assisted win; **any answer key or
  full grading rationale** the student could read (this is a live *security* invariant, not just
  pedagogy — grader "reasons" that embed the answer are redacted from student payloads).
- **MUST show:** why the next action is suggested (plain language); the alternatives available; when
  a deferred skill will come back; evidence of later improvement when the data supports it.

## 7. Self-assessment & the "prove it on a second question" surface

- **Confidence captured before feedback**, every relevant attempt, on a small consistent scale.
- **Calibration states** worth surfacing: calibrated-strong, calibrated-uncertain, **overconfident**
  (wrong + high confidence → contrast the misconception), **underconfident** (independently right +
  low confidence → show the evidence to stabilize confidence), unstable. Reward accurate calibration
  and help-seeking — **not confidence alone**.
- **Desirable-difficulty framing:** tell students mixed/interleaved practice *feels* harder and
  produces more mistakes even while improving retention — then **show the delayed evidence** rather
  than asking for faith.
- **"Prove it on a second question"** is Cramapple's structural argument versus generic AI: a
  chatbot gives the answer; Cramapple gives the skill and **proves it transferred on a fresh
  question.** Make this moment legible and central — it is the product's differentiator.

## 8. Invariants that constrain the design (INV-1..6, + fail-closed)

- **INV-1 Store fine, present coarse** — never show skill codes / the cell grid; roll up to
  topic/practice.
- **INV-2 Threading never pools evidence** — never render one topic's win as credit toward another.
- **INV-3 Correctness is independently checkable** — only reviewed, verifier-backed content backs a
  mastery claim (no LLM-generated "question + claimed answer").
- **INV-4 Determinism over judgment** — tiers, due-times, weights are deterministic rules.
- **INV-5 Supported success is provisional** — never render "mastered" after a hinted win.
- **INV-6 Honest uncertainty** — a later failure marks `fragile` without erasing history; no reset
  to zero on one miss.
- **Fail-closed:** any grading/content uncertainty counts as zero evidence and never counts against
  the student.
- **Honest uncertainty in all displays** — mastery and any projected outcome are estimates, always
  qualified; never materially overstate mastery or a projected score.

## 9. First-pilot scope (build only this)

- **Subject: AP Statistics only. Unit: Unit 1 only. ~8–12 cells** (the pilot set in
  `COURSE_MODE_STATS_UNIT1_PILOT_PLAN_2026_08_24.md`).
- **Grading paths in the loop: numeric-entry (deterministic) and MCQ (choice-match) ONLY.** No open
  free-response grading in the student loop yet (that needs the unbuilt R&D grader). Skill-4
  "interpret/justify" ideas are served as **MCQ interpret-and-pick**, not open FRQ.
- **Due-reasons are Phase-1 only:** decay, direct miss, provisional-success confirm, new-exposure
  consolidation. **Do not** promise "we'll resurface a *related* weak topic" — cross-cell/prerequisite
  resurfacing (the principle graph) is deferred.
- Not in the pilot: score prediction as a promise, parent controls, cross-subject, long-term course
  replacement.

## 10. Success criteria for the pilot experience

A student can: open the app and be told what to practice and why; do a cold attempt and rate
confidence; get graded with the three outcomes rendered distinctly; be taught with least-revealing
help and re-proven on a changed surface; see their own mastery move at the topic level with honest
qualifiers; and leave (Move On/Park) without penalty and know when the skill returns. And: no answer
key or full rationale is ever reachable by the student.

## 11. What NOT to design yet
- Open free-response answering/grading UI. Cross-cell "related topic" resurfacing. Score-prediction
  dashboards. Multi-subject navigation. Parent/teacher surfaces. Social/streak mechanics beyond the
  fortress-vs-decay frame (validate the honest version first).

## 12. Open questions for Claude Design (where the latitude is)
1. **Session assembly** — how "your 20 minutes" is presented and paced (the biggest undesigned job).
   → now specified in `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md` (2026-08-25): the
   entry points, top-N assembly from the due-queue, the beat-by-beat run, and the wrap-up.
2. **The fortress-vs-decay visualization** — how "locked / slipping / at risk" reads at a glance at
   the topic grain without a cell grid or codes, and without implying false precision.
3. **The confidence-capture UI** — the small consistent scale, fast enough to not tax the cold
   attempt, before every feedback.
4. **Rendering the three graded outcomes** — especially a `content_uncertain` state that feels
   non-punitive and distinct from "wrong."
5. **The least-revealing help ladder** — how Tighten/Show/Stretch surface progressively without
   leaking the answer, and how the "prove it on a second question" beat is staged.
6. **The Move On / Park / return affordances** — prominent-but-not-forced, with a legible "returns
   on <date>".
7. **Plain-language translation of skills** — how internal `topic×skill` cells become student-facing
   topic/skill names.
