# Cramapple Use Modes — Strategic Reconciliation

STATUS: draft for Product Owner review | DATE: 2026-09-17 | AUDIENCE: David, LLM-first
entry point for any session working across modes.

## 0. Why this document exists

Cramapple now has three distinct use modes in the record, built at three different
times, with three different levels of maturity, and no single document that says
how they relate. Each mode's own docs are internally coherent; nothing steps back
and asks whether the modes still add up to one product. This document is that
step-back. It does not decide anything on its own — every open question in §4 is
David's call — but it puts the three modes side by side so a decision is possible
without re-reading the full corpus each time.

## 1. The three modes today

| | **Cram Mode** | **Course Mode** | **Homework Mode** |
| --- | --- | --- | --- |
| What it is | The original ~10-day, points-per-hour exam-prep loop | Year-long, cell-based (topic × skill) mastery tracking | Bring an outside question; Cramapple teaches the underlying skill, doesn't solve it |
| Canonical doc | `docs/product/CRAMAPPLE_VISION.md`, `docs/teaching/LEARNING_SYSTEM.md` | `docs/teaching/COURSE_MODE_LEARNING_MODEL.md` + `COURSE_MODE_STATUS_AND_HANDOFF.md` | `docs/teaching/HOMEWORK_MODE_DESIGN_2026_08_28.md` |
| Status | The MVP the vision doc (v0.3, June 2026) is written around | Backend loop proven live on Dev (real MCQ grades, promotes a mastery cell); Prod held for David; student-facing experience not yet built | Design discussion only — nothing built; explicitly scoped as reusing Course Mode's content/pedagogy, not a separate engine |
| Pilot subject | AP Biology | AP Statistics (pilot) | Not subject-scoped yet — depends on whichever exam pack has content coverage |
| Governing constraint | INV-3 / no unvetted generation; validated content only | Same INV-3, expressed as CM-D14/CM-D15/CM-D16 (template-level generation, D8 release bars) | Same INV-3, expressed as CM-D20 (2026-08-28): "may not freelance new pedagogy... at response time" |

## 2. The "one engine" thesis — where it already holds

Course Mode's own status doc already states the intended relationship, but it's
buried in a session-handoff file, not in a place anyone would think to look for
product strategy:

> Cramapple is shifting from a 10-day AP cram tool to a year-long "efficient
> learn" companion for time-scarce, points-driven students (one engine, cram =
> its compressed final phase).

Homework Mode's design doc independently arrives at the same framing (CM-D20):
it is "a sibling initiative to Course Mode that reuses its content system and
pedagogy engine, not a separate one."

So the *intent* on record is not three products — it's one engine with three
entry points / horizon settings:

- **Cram Mode** = the engine running with a short time horizon and an urgent
  framing (exam in ~10 days).
- **Course Mode** = the same engine running with a long time horizon (a full
  school year), tracking mastery at the cell level instead of session-by-session.
- **Homework Mode** = the same engine entered from an external artifact (a
  photographed or pasted question) instead of from guided roaming, routed into
  the same teach/practice/grade loop Course Mode already built (§11.2 of the
  Course Mode UX integration spec).

What's actually shared, per the build record: the taxonomy/cell registry, the
question/rubric package format, the deterministic + LLM-assisted grading
pipeline, the misconception/scenario catalogs, and (for Course Mode and
Homework Mode specifically) the `student_cell_state` mastery store and tier
ladder. Nothing in the built code forks per mode at the content or grading
layer — the fork, where it exists, is in session assembly and entry-point UX.

## 3. Where the modes are NOT reconciled

This is the gap this document exists to surface.

### 3.1 The vision doc hasn't caught up

`CRAMAPPLE_VISION.md` (v0.3, June 2026) — still the canonical, linked-from-`README.md`
business document — describes a single product: the 10-day cram tool. It states
"design center is a student with approximately ten days before the exam" and
frames year-round use as something to not let "dilute the cram-first
experience" (§3.1). That was written before Course Mode existed as a concept.
Course Mode's own docs now say the opposite: cram is a mode *of* the year-long
engine, not the primary framing the engine is built around. Nobody has gone
back and reconciled the vision doc with that shift. Right now the durable
source-of-truth business document and the most-invested-in engineering effort
describe two different products.

### 3.2 Positioning tension, not just a documentation gap

This isn't only about which doc is stale — the underlying product bet has
actually moved:

- The vision doc's market position (§11.1) is **score optimization**,
  explicitly narrower than tutoring, explicitly urgent.
- Course Mode's framing is closer to a **year-long learning companion** —
  broader, less urgent, a different sales motion (school-year subscription
  behavior vs. one-time pre-exam purchase) and a different pricing shape (the
  vision doc's one-time-purchase pricing hypothesis, §12.1, was built for the
  cram case).
- Homework Mode is closer still to a third position — **on-demand help**,
  triggered by school assignments rather than exam prep at all.

These aren't incompatible, but they're not the same 30-second pitch either. A
single landing page, a single onboarding flow, and a single pricing page can't
lead with all three without picking an order.

### 3.3 No sequencing decision on record

Given one engine and three entry points, the real question is not "which mode
do we build" (Course Mode is already furthest along technically) but **which
mode ships to a real student first, and what does that imply about the other
two.** Candidates, as the record actually stands:

- **Cram Mode / AP Biology** is what the approved MVP scope (`CRAMAPPLE_VISION.md`
  §9) and the August 2026 beta launch sequence (§12.2) describe, but per
  `MASTER_TODO.md` it's gated on several still-open P0/P1 items (content
  governance, grader calibration, TASK-0004 tutor review) that predate Course
  Mode's build activity.
- **Course Mode / AP Statistics** has the most recent, most concentrated
  engineering investment and a proven Dev-live loop, but has zero
  student-facing UX built and Prod is explicitly held for David.
- **Homework Mode** is the least built (design-only) but may be the cheapest
  path to a first real usage signal, since CM-D20 means it inherits Course
  Mode's grading/content substrate rather than needing its own — *if* enough
  vetted content exists to answer real homework questions, which per the
  Homework Mode doc's own feasibility finding is the actual constraint, not
  classification.

No document says which of these is the near-term priority, or whether they're
meant to ship together, sequentially, or as parallel bets that will later
consolidate. `MASTER_TODO.md`'s Active Task Register still centers on the
original Biology gates (TASK-0004 through TASK-0010) and doesn't mention
Course Mode or Homework Mode as tracked items at all — the entire Course Mode
build (10+ PRs, a proven Dev pipeline) and the Homework Mode design session
exist outside the backlog's formal tracking.

### 3.4 Subject fragmentation

Cram Mode targets AP Biology. Course Mode's pilot is AP Statistics. That's a
second, separate fragmentation from the mode question: even if the mode
strategy were resolved today, the two most-built modes are validated against
different subjects, so "ship Course Mode" and "ship the Biology MVP" are not
the same milestone converging on the same launch.

## 4. Open decisions (David's call)

1. **Positioning**: is Cramapple, going forward, primarily a year-long
   learning companion that compresses into a cram mode near the exam (Course
   Mode's framing), or primarily a cram tool that happens to support
   early-year use (the current vision doc's framing)? This changes the vision
   doc, the pricing model, and the marketing sequence — it's not a documentation
   nit.
2. **Sequencing**: which mode reaches a real student first? Does that
   determine which subject (Biology vs. Statistics) is the actual launch
   subject, overriding the vision doc's Biology-first sequence?
3. **Backlog integration**: should Course Mode and Homework Mode be brought
   into `MASTER_TODO.md`'s Active Task Register with real Task IDs and status,
   so they're visible in the same place as the Biology gates instead of living
   only in `docs/teaching/COURSE_MODE_*` handoff files?
4. **Homework Mode's content dependency**: given CM-D20 ties Homework Mode's
   usefulness directly to vetted content coverage, should its build be
   explicitly sequenced *after* a coverage milestone in whichever subject it
   targets, rather than developed in parallel on the assumption coverage will
   catch up?
5. **Vision doc refresh**: does `CRAMAPPLE_VISION.md` get revised now to
   describe the three-mode, one-engine architecture, or does that wait until
   the sequencing decision (item 2) is made, so it's written once against a
   settled answer instead of twice?

## 5. Recommendation

Resolve item 2 (sequencing) first — it's the one every other open item depends
on. Once a first-ship mode/subject is chosen, items 1 and 5 (positioning and
the vision-doc refresh) become a single writing pass instead of a live debate,
and item 3 (backlog integration) becomes mechanical: promote the chosen mode's
work into `MASTER_TODO.md` with real Task IDs, leave the others as tracked but
lower-priority. Item 4 (Homework Mode's content gate) is a sequencing
consequence, not an independent decision, once item 2 is settled — it should
inherit whatever coverage state the chosen first-ship subject reaches.

## 6. Suggested next step

A short decision session with David on §4 items 1–2 only, working from this
document instead of the underlying `COURSE_MODE_*` and `HOMEWORK_MODE_*`
corpus. Once those two are settled, the Main Conductor updates
`MASTER_TODO.md` and opens the vision-doc revision as its own tracked task.
