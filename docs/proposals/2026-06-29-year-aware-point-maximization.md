# Year-Aware Point Maximization

**Status:** Reviewed by Codex — pending Product Owner + curricular decision
**Date:** 2026-06-29
**Author:** Strategy Advisor (with Product Owner)
**Product Owner:** David Bloom
**Curricular Owner:** Orly Bloom (pacing prior, decay cadence, retention)

## Problem

Cramapple maximizes AP points per hour invested. That objective has implicitly
been solved for one moment — exam season, with all units in play. Reality is
that a student who signs up in September has not been taught Unit 8 and gains
nothing from being guided toward it: cold attempts on unseen material are
demoralizing and produce junk diagnostic signal.

This is not a major overhaul. The objective does not change. We are making one
constraint that was always present — *what content is actually reachable for
this student right now* — explicit and time-aware.

## The model

### One new primitive: a readiness term

The recommendation engine weighs roughly `examWeight × improvability`. The whole
adaptation is a third, time-varying factor:

```
value(target, time) = examWeight × improvability × readiness(target, time)
```

`readiness` is ~0 for not-yet-taught content early in the year and rises as the
student's course covers it. The same `readiness` frontier scopes **two**
consumers — recommendations *and* diagnostics — so this stays one mechanism, not
two.

### Two axes, not one

Diagnosis measures two orthogonal things:

1. **Content mastery** — *what do you know?* Calendar-bound, grows with the
   course, scoped by the readiness frontier. Drives **what** to practice.
2. **Point-capture skill** — *can you convert what you know into every available
   point?* Answering the actual question asked, hitting rubric language, causal
   reasoning, not leaving points on the table. **Calendar-free, measurable from
   attempt #1**, on whatever single unit a September student has. Drives the
   **coaching** on every attempt.

Point-capture is the always-on job and the differentiator: it works in September
with one unit as well as in April with nine.

### One engine, with decaying mastery

The diagnostic's job shifts over the year — find unlearned gaps → catch decayed
retention → prioritize across everything — but these are **not** separate
programs. They are the same frontier-accumulating engine showing different
emphases as inputs change.

The only addition required is a **decay term on mastery**: **mastery freshness**
in a "locked" skill falls over time. Re-surfacing September's Unit 1 in January
then falls out of the same value function automatically (decayed freshness raises
improvability, which raises priority). No separate retention machine.

Note this is distinct from **position-estimate confidence** (below) — how sure we
are about *where the student's class is*. Mastery freshness is about a skill;
position-estimate confidence is about the pacing prior. They decay and update for
different reasons and should not be conflated when tuning.

### How the diagnostic behaves across the year (emergent, not designed)

| Window | Frontier | Diagnostic behavior |
| --- | --- | --- |
| Aug–Oct | ~0–2 units | No diagnostic ceremony. Diagnosis is a byproduct of practicing the current unit. First session is "start practicing," not "take a test." |
| Nov–Feb | accumulating | Light, rolling diagnostics scoped to covered units; decay term begins surfacing earlier units (retention). |
| Mar–May | all units taught | Full diagnostic earns its keep — real cross-unit prioritization plus integration and exam-execution weakness. |

## Locked decisions (Product Owner)

1. **Course position** = default pacing prior keyed to the official AP exam date,
   confirmed by the student (one tap, pre-filled — not an open question).
2. **Work-ahead is never gated.** A student may attempt anything. A *wrong*
   answer on ahead-of-class material triggers a soft redirect back to covered
   material. The wrong answer is the readiness signal; the redirect is the gate.
3. **Diagnostic scope = confirmed covered frontier.** No comprehensive
   diagnostic early in the year.
4. **Two diagnostic axes:** content mastery (calendar-bound) and point-capture
   skill (always on from attempt #1).
5. **Mastery decays** rather than being permanent; retention re-surfacing is
   emergent from the one engine.

## Onboarding efficiency

Current first-session flow is an interstitial + five screens. The decisions above
make most of it redundant. Target: **five screens → one.**

| Current step | Verdict | Rationale |
| --- | --- | --- |
| Interstitial "setup takes a minute" | Cut | Speed bump, captures nothing. Fold the one-line value statement into the first real screen. |
| Confirm subject = AP Bio | Cut | Single-subject beta; implied. |
| Exam date display | Keep as display | Show on plan/home, not its own screen. |
| Registration status | Defer to account settings | Affects nothing in the learning loop; do not gate the first attempt on an admin field. |
| Broad starting point (open question) | Replace with one-tap confirm | Pacing prior pre-fills it: "Your class is probably around Unit 3 — right?" |
| Immediate goal (4-way fork) | Cut as a screen | A first-timer cannot meaningfully choose; default to "tell me what to work on," surface the rest as in-product actions. |
| Available time | Keep — the one real question | Genuinely shapes the session; may default to a 15-min quick win and stay adjustable. |
| Calibration vs. direct fork | Cut | The first practice item *is* the calibration now (continuous assessment + point-capture from attempt #1). |

**Resulting first session:** one screen — *"Here's a ~15-minute session on [current
unit]. Start, or adjust"* — with course-position confirm and time as inline taps.

Here "one screen" means a single composed setup surface with recoverable
sub-decisions, not one untracked call to action. The surface may persist
course-position confirmation, time selection, plan generation, and any
interruption state separately while presenting them as one coherent start.

Guardrails:

- Legally-required notices (age-gating/consent) are a separate legal gate and are
  **not** in scope to cut here; they may force a screen regardless.
- The collapsed flow should be an explicit **A/B test** with learners (minimal vs.
  fuller), not shipped unvalidated.

Implementation decisions from Codex review:

- Do not convert one answer into mastery, readiness, or an AP score. A poor
  answer on ahead-of-class material is a large routing signal because it means
  something different from a poor answer on already-covered material, but it is
  not standalone negative mastery evidence.
- Work-ahead remains learner-available. A wrong work-ahead answer may lower
  **position-estimate confidence** in the current course-position estimate and
  trigger a soft redirect to covered material. It does not lower mastery freshness.
- Registration status does not affect the learning loop and should not gate the
  first attempt. If Cramapple reminds students about AP registration, that
  belongs in Account or lightweight plan/home copy rather than onboarding.
- Decay does not replace Lock or due review. Decay lowers **mastery freshness**
  over time and influences ranking; Lock remains the mechanism for delayed
  retrieval evidence. (Their coordination is still open — see Questions for Codex.)

## What this needs from Orly (curricular, gating)

- A credible default AP Biology scope & sequence for the pacing prior, and an
  honest read on how much real classrooms diverge from it.
- The mastery **decay cadence** — how fast mastery freshness in a locked unit
  should fall, and how aggressively to re-surface it. This is the genuinely new
  behavior and the easiest to over- or under-tune.

## Questions for Codex

### Resolved in this revision

- **Retention vs. Lock.** Retention is modeled as decay on mastery freshness, not
  a separate scheduler. Decay influences ranking; Lock remains the mechanism for
  delayed retrieval evidence. (Coordination between the two is still open — see
  below.)
- **Single-answer semantics.** One answer is a routing signal, never standalone
  negative mastery evidence; it is not converted into mastery, readiness, or an
  AP score.
- **Work-ahead.** Stays learner-available; a wrong work-ahead answer lowers
  position-estimate confidence and soft-redirects, without lowering mastery
  freshness.
- **"One screen."** Means one composed, recoverable setup surface, not one
  untracked call to action.

### Still open

1. **Decay/Lock coordination.** Decay-driven re-surfacing and a Lock due-review
   can target the same item (e.g., September's Unit 1 in January). What rule keeps
   them from double-surfacing or contending for the same slot?
2. Is `readiness` best expressed as a multiplicative gate, a soft prior, or a
   hard scope on candidate selection — given the no-gate work-ahead decision?
3. Does scoping diagnostics to the covered frontier conflict with any current
   assumption in UX-001 / UX-006 / UX-007 or the recommendation logic?
4. What is the smallest implementation footprint to reach the one-screen
   onboarding without breaking the recoverable-setup and accessibility guarantees
   already specified?
5. Where should point-capture skill live as a first-class, cross-unit signal
   distinct from content mastery?

## Scope guardrails

- This is additive, not a rebuild: one `readiness` term, one decay term, a second
  (point-capture) signal axis, and onboarding subtraction.
- Do not introduce capacity/infra machinery — out of scope at beta scale.
- Every change traces back to points-per-hour for the student.
- Nothing here is approved. This is a proposal for Codex review and then Product
  Owner + curricular decision.
