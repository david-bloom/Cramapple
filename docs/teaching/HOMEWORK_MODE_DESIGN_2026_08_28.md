# Homework Mode — Design Discussion Record

STATUS: design discussion, nothing built | DATE: 2026-08-28 | AUDIENCE: LLM-first, David.

This records a planning conversation (David + this session) on a new capability:
**Homework Mode** — a student brings an outside question (free text, a photographed
question, or an uploaded worksheet) and asks Cramapple for help, and Cramapple
teaches the underlying skill without doing the problem for them. Nothing in this
document has been built. Where a point was explicitly settled by David it is
tagged DECIDED; where it is this session's recommendation awaiting sign-off it is
PROPOSED; unresolved product calls are OPEN. This mirrors the status vocabulary of
`COURSE_MODE_LEARNING_MODEL.md` deliberately — Homework Mode is a sibling
initiative to Course Mode that reuses its content system and pedagogy engine, not
a separate one.

## 0. Companion docs (read in this order)

1. `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004) — the original
   "Bring a Question" intake spec: capture, confirm-match, four help modes (Teach
   Me / Hint / Check My Work / Walk Through). Approved for design in 2026-06,
   never implemented. Homework Mode supersedes its sequencing and hardens its
   guardrails; it does not relitigate the parts reused as-is (see §2).
2. `docs/teaching/COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` §11.2–§11.3 — the
   learn-first skill entry (explainer → open-hand worked example → cold prove-it)
   that Homework Mode routes into, and the homework-image experiment design.
3. `docs/research/HOMEWORK_IMAGE_CLASSIFICATION_EXPERIMENT_2026_08_25.md` — the
   feasibility test proving vision classification generalizes broadly, and the
   finding that shapes this whole design: **classification is not the binding
   constraint, vetted-content coverage is.**
4. `docs/teaching/LEARNING_SYSTEM_STUCK.md` — the escalation/evidence model
   (assessable skill target, Sideways/Apart/Down, the confirmation ladder:
   supported → independent → confirmed) that Homework Mode's "prove it
   transferred" step is built on, not a new mechanism.
5. `docs/teaching/COURSE_MODE_LEARNING_MODEL.md` — INV-3 and CM-D14 ("no general
   LLM item generation; content generalizes only as far as correctness is
   independently checkable"), which §1 below extends explicitly to Homework Mode
   as CM-D20.

## 1. The governing principle (CM-D20)

**STATUS: DECIDED (David, 2026-08-28).** Recorded formally as CM-D20 in
`COURSE_MODE_LEARNING_MODEL.md` §12; restated here in full because it is the
load-bearing rule for every other decision in this document:

> Homework Mode must remain true to Cramapple's mission — helping students earn
> the most points from the time they have. What Cramapple teaches, and how it
> responds, must rely on principles already codified and content already
> created, or a version of that content parametrized to the specifics of the
> student's session. It may not freelance new pedagogy, explanations, or worked
> reasoning at response time.

This is INV-3 / CM-D14 ("no general LLM generation; content generalizes only as
far as correctness is independently checkable") applied to a live conversational
surface, not just to authored item banks. The model's live-generated role in
Homework Mode is limited to **routing, classifying, and confirming** — never
authoring pedagogy. Concretely:

- A "version of [content] based on the specifics of the student session" means a
  **new parametrized instance of an existing, validated template** — exactly what
  the Track A/Track B generator already does for Course Mode (CM-D15/CM-D16):
  same skill, same misconception catalog, different numbers/context,
  independently checkable. It does not mean an LLM composing a new explanation
  in the moment.
- Skill explainers shown to a student must be the existing authored
  explainer/topic-brief content, verbatim. "Personalizing to the session" means
  *selecting* which already-authored facet applies (which contrast case, which
  common-point-loss note), never rewriting or paraphrasing live.
- Any feedback on a student's own work must trace to a codified source (a
  deterministic recompute, or a named entry in the misconception catalog) — see
  §5 for how this constrains Check My Work specifically.
- Interview/confirmation language itself should be template-filled from stored
  taxonomy fields ("Are you talking about `{skill_name}` from `{topic_code}`?"),
  not composed fresh each time, so there is no surface where the model drafts
  original instructional language.

## 2. Three intake modes; sequencing

**STATUS: DECIDED (David).** Three entry points, launched in this order rather
than together:

1. **Free-text ask + bounded interview** — first. No vision/OCR dependency;
   fastest path to a working, guardrailed teach-on-parallel-item loop.
2. **Photo of a specific question** — second. Most already de-risked: the
   classification feasibility test (companion doc §0.3) already proved this
   works; §11.3's design is largely ready to build once (1) is proven live.
3. **Upload a worksheet (multi-question document)** — third. Needs new scope
   beyond UX-004's single-question assumption: decomposing a multi-question
   document into separately classified, separately coverage-gated items, with
   the student choosing which to work on. Not designed in detail yet — DEFERRED
   until (1) and (2) are live.

All three converge on the same backend pipeline (§3) — the point of sequencing is
to prove the guardrail loop once, cheaply, before adding intake surfaces onto it.

**Scope-narrowing decision (David):** photo capture is deferred; text intake
requires the student to **copy/paste the actual question**, not describe or
paraphrase it. See §4 for why this is also an anti-gaming measure, not just a
scope cut.

## 3. The unified pipeline

```
paste question → classify (Gate 1) → coverage check (Gate 2) → teach on a
parallel vetted item (explainer + open-hand worked example) → cold prove-it on a
fresh item → [optional, gated] Check My Work on the student's own question
```

**Gate 1 — Classify.** Subject → unit → topic → skill/cell, reusing the taxonomy
/ cell registry (F1 `taxonomy_cells`). Confirmed via a **closed-form** question,
not open dialogue (§4). Fail-closed when uncertain ("tell us if we read this
wrong") — matches UX-004 §6.3 and the image-classification experiment's own
finding that this step generalizes broadly and safely.

**Gate 2 — Coverage.** Do we have vetted, checkable practice for the classified
skill? **STATUS: DECIDED (David) — "name it, defer it."** If not: name the skill,
say practice for it is coming, and stop there. Never generate a live substitute
item. This is CM-D20 in miniature: recognition is cheap and broad; coverage is
the real, narrow, honest constraint (today: AP Statistics Unit 1).

*Open refinement, not yet decided* — **STATUS: OPEN.** AP Stats Unit 1 is the
only topic with servable interactive practice, but authored topic-level
explainers ("what it is / why it matters / answer move / common point loss")
already exist broadly across multiple subjects. A two-tier degrade (show the
real vetted explainer when one exists even without a practice cell; defer only
the hands-on practice) would give meaningfully more day-one value using content
that is already vetted — but this widens what a student sees outside the pilot,
so it needs an explicit decision rather than defaulting to it. Until decided,
implement the strict binary form (full loop where covered, name-and-defer
everywhere else).

**Teach on a parallel item.** Reuses the existing learn-first entry (§11.2 of the
UX integration spec) unmodified: explainer → worked example on a
**different-numbers, same-skill** item, played open-hand → handoff to the
student's own cold attempt. `attempt_condition=coached` for the worked step,
exactly as Course Mode already tracks it. **STATUS: DECIDED (David) —** the
open-hand parallel example is non-negotiable; it is the one point in the loop
where the student sees a worked solution, and it is never the solution to their
own item.

**Cold prove-it.** A fresh, independently generated instance of the same
template/cell, no answer-bearing help. This is the actual gate the student must
clear — see §5 for why "attempted" is not enough.

## 4. The interview and paste-first intake (anti-gaming, layer 1)

**STATUS: DECIDED (David).** Two changes narrow the intake surface specifically
to make it hard to game, not just simpler to build:

- **Verbatim paste, not description.** A pasted real question is *checkable in
  shape* — plausible stem, often numbers/choices/notation, plausible length. A
  garbage input ("asdf", "just give me the answer") fails that shape check
  before it ever reaches classification. An open free-text description can't be
  screened this way, because vagueness is also the normal honest case.
- **Closed-form confirmation, not open dialogue.** E.g. *"Are you talking about
  telling variable types apart, from Unit 1.9?"* — Yes / No, something else /
  Add more. This is UX-004 §6.2's existing "Moderate Confidence" pattern
  re-derived, not a new invention. It matters for anti-gaming specifically
  because a closed-form yes/no is a far smaller attack surface than a free-text
  box — there is no room for a student to argue, rephrase, or socially engineer
  the interviewer into engaging with their problem's content. The "interview"
  should compress to: paste → classify → one closed-form confirm → (only if
  still ambiguous) one more closed-form disambiguator. Not a real conversation.

**Consequence for the guardrail, not a reason to avoid this:** once the system
holds the *verbatim* text of the student's real problem (not a vague paraphrase),
the "never touch its specific numbers/steps" rule has to hold under more
pressure than before — the model has the literal content sitting in front of it.
This raises the bar for the adversarial red-team pass (§6); it does not change
the rule itself.

Academic-integrity carry-forward from UX-004 §8 (not redesigned this session,
just inherited): ask where the question is from (homework/practice vs. an active
quiz or test vs. unsure); for an active assessment, keep Teach Me available but
disable Check My Work / solution-adjacent modes. **STATUS: OPEN** — exact
mechanism for a conversational (vs. UX-004's original multiple-choice) intake is
undecided.

## 5. Closing the loop: Check My Work, tightened (anti-gaming, layer 2)

The open question David raised: after teaching (explainer + open-hand parallel
example + cold prove-it), a student may go solve their *actual* homework problem
correctly on their own. Silence forever feels wrong — but re-engaging with their
specific problem can't reopen the door INV-3/CM-D20 just closed.

**Resolution — sequencing, not silence (STATUS: DECIDED, David confirmed the
shape; exact thresholds below are OPEN/PROPOSED):**

1. **Before the cold prove-it attempt is complete:** zero engagement with the
   content of the student's stated problem. No confirming, no "getting warmer."
   This is the part the field-experiment evidence (§7) validates hardest.
2. **After a genuinely independent, correct attempt on a fresh, different item:**
   the objection is gone — the student has already proven the skill without help.
   At that point, **Check My Work on their own original problem is UX-004 §7.3's
   already-designed mode**, not a new one: student supplies their own
   answer/work; Cramapple evaluates only what it can independently support.
3. **Under CM-D20, "evaluate only what it can support" is narrower than UX-004's
   original "formative reasoning feedback" language** — that phrasing risked
   freeform LLM commentary on an unvetted problem, which is exactly what CM-D20
   forbids. The compliant version:
   - If the item is a form Cramapple can **independently, deterministically
     recompute** (reusing the same checkable-computation machinery the generator
     already uses), confirm correct/incorrect on the final answer. If incorrect,
     only say something if the error **matches a named entry in the existing
     misconception catalog** — name that misconception; do not generate a novel
     explanation of the mistake.
   - If the item **cannot** be independently verified this way (most real
     homework — open conceptual/free-response, no deterministic check): do not
     grade or comment on the student's specific reasoning at all. Decline
     gracefully and point back to the codified topic brief's answer-move /
     common-point-loss language — the same already-authored fields, not
     model-improvised commentary.

**The unresolved gaming risk this doesn't yet close — STATUS: OPEN, needs a
decision:** gating Check My Work behind "completed the cold prove-it" is only as
strong as what counts as "completed." Concretely:

- **"Attempted" must mean "correct," not "submitted."** Needs to be explicit in
  the eventual spec.
- **A single correct MCQ guess has a 25% blind-guess floor.** The codebase
  already has the right concept for this — `LEARNING_SYSTEM_STUCK.md`'s
  Confirmation Ladder treats one correct fresh attempt as only **provisional**
  independent transfer, never confirmed. PROPOSAL: make the *provisional →
  confirmed* threshold (not just "provisional") the literal unlock bar for Check
  My Work — e.g. two correct independent items, or one correct plus a required
  self-explanation ("why is that right?"). Self-explanation is independently
  supported in the learning-science literature (§7) as both a genuine learning
  aid and a much harder thing to fake than a lucky guess.
  **Exact threshold: OPEN — not yet decided.**
- **A miss should not allow free retries on the same item.** Should route into
  the existing escalation machinery (a genuinely different parallel item) rather
  than "try again until correct." **STATUS: OPEN.**
- **If a student tries to skip straight to Check My Work without doing the
  parallel practice:** PROPOSAL — default to routing them through Teach Me first
  (a recommendation, not a hard block, consistent with
  `LEARNING_SYSTEM_STUCK.md` §6.1's recommendation-with-override principle), so
  Check My Work can't become a bypass around the whole guardrail. **STATUS:
  OPEN.**

## 6. Guardrail hardening as a hard gate, not a nice-to-have

**STATUS: PROPOSED, not yet scheduled.** The "never solve any part of the
student's stated problem" rule is a prompted behavior until proven otherwise.
This codebase already runs adversarial QA on every risk-bearing feature (Fable
QA rounds on the grading hook; independent Gate-2 re-derivation on generated
content). Homework Mode's interview/teaching surface needs the same treatment
before any real student sees it: a red-team pass specifically trying rephrasing
tricks, "just check my logic" framing, escalating pressure, and pasting the
literal problem mid-conversation. This should be treated as a launch gate
analogous to D8/CM-D19 for content, not an optional QA nice-to-have.

## 7. Evidence base (why this design, not just caution)

A 2024–25 field experiment in Turkish high schools (Bastani, Bastani, Sungu, Ge,
Kabakcı, Mariman; published PNAS 2025) is close to a direct test of this design.
~1,000 students got GPT-4 access during math practice under three conditions: no
AI, unrestricted ("GPT Base," would solve on request), and a hint-only "GPT
Tutor." Both AI conditions boosted practice-session scores hugely (+48% / +127%).
When AI access was removed for a real exam: **the unrestricted-AI group scored
17% *worse* than students who never had AI at all** — they had substituted the
AI's reasoning for their own. **The hint-only tutor group showed none of that
harm** — exam performance matched the no-AI control despite the same practice
boost. This is close to a controlled validation of "never solve the student's
stated problem, only teach on a parallel item."

Supporting threads: worked examples reduce cognitive load for genuinely novel
material but should fade once a schema exists (motivates open-hand-then-cold,
not open-hand-forever); the testing/retrieval-practice effect (producing an
answer from memory builds more durable learning than being shown one, motivating
the mandatory cold prove-it); a recent RCT found direct-answer AI responses
nearly doubled the rate of students left stuck in high-confusion moments versus
an incremental-hint tutor; Khan Academy's Khanmigo publicly states the same
design principle (prompt engagement, never hand over the answer) at production
scale; the self-explanation effect supports requiring "why is that right?" as
both a learning booster and a harder-to-fake authenticity signal (§5).

Full citations were surfaced in-conversation (2026-08-28); not yet copied into a
references section here.

## 8. What is explicitly deferred (not silently dropped)

- Photo-of-a-question intake (§2, item 2) — design exists (§11.3, the feasibility
  experiment), not scheduled to build until text-interview is live.
- Worksheet/multi-question document upload (§2, item 3) — needs new
  decomposition design beyond UX-004's single-question assumption. Not designed.
- Exact Check My Work unlock thresholds (§5) — OPEN.
- Two-tier coverage degrade using existing topic explainers (§3) — OPEN.
- Conversational academic-integrity handling (§4) — OPEN.
- The adversarial red-team guardrail pass (§6) — PROPOSED, not scheduled.
- Backend contract (new edge function(s) for interview turns + classification +
  coverage lookup + a new `entry_path` value) and the front-end conversation UI
  (`exam-buddy-wireframe`, outside this repo's session scope) — not yet
  specified in implementation detail.

## 9. Next steps

1. Decide the OPEN items in §3–§5 (two-tier coverage degrade; Check My Work
   unlock thresholds; academic-integrity mechanism for text mode).
2. Write the backend contract (interview-turn function, classification call,
   coverage lookup, `entry_path` addition) at the same level of detail as
   `COURSE_MODE_SESSION_ASSEMBLY_AND_ENTRY_FLOW_SPEC.md`.
3. Schedule the adversarial red-team pass as a named gate before any build is
   considered launchable (§6).
4. Once (1)-(3) are settled, open a TASK file's Acceptance Criteria against a
   real build plan (see `TASK-0037`, filed alongside this document as the
   tracking record for the initiative).
