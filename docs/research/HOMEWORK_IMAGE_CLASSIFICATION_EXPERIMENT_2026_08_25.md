# Homework-Image Classification — Feasibility Experiment

STATUS: experiment note (filed for a later release) | DATE: 2026-08-25 | AUDIENCE: David + future Course Mode sessions.

**Decision (David, 2026-08-25):** the homework-photo → learn (not solve) capability is a **good
proxy result — filed away for a later release**, not built in the Unit-1 pilot. This note records
what was tested and the one finding that should shape the eventual build. Design context:
`docs/teaching/COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md` §11.3 (and the `Homework` canvas
artboard).

## What was tested

A single live test of the **hard step only** — can a vision model read a photo of a homework page
and classify it to subject → unit → topic → skill? Input: a phone photo (rotated ~90°, page 1/8)
of a **trigonometry worksheet** — used deliberately as an *out-of-pilot proxy* because no AP
Statistics homework was on hand. No intake or serving plumbing was built; this was Claude's image
analysis run directly.

Visible content: a "Use quotient and reciprocal identities" worksheet.
- #1 — `tan β = √15/10`, find `cot β`.
- #2 — cut off by the rotation (flagged, not guessed).
- #3 — `cot x = −1/2`, `sin x = 2√5/5`, find `cos x`.

## Result

Classification was accurate and appropriately hedged:

| Item | Subject | Topic | Skill | Confidence |
|---|---|---|---|---|
| #1 | Trig / Precalculus | Trig identities | Reciprocal identity (cot = 1/tan) | High |
| #3 | Trig / Precalculus | Trig identities | Quotient identity (cot = cos/sin) + sign/quadrant reasoning | High |

- Read the legible problems correctly, pinned the exact skills, and **flagged what it could not
  read** (#2, the full directions) rather than inventing them — the honest-uncertainty posture the
  model requires.
- **Teach-not-solve held:** the two skills were taught on *parallel* problems (different numbers,
  worked open-hand), and the student's actual #1 and #3 were handed back unsolved.

## The finding that should shape the build

**Classification and content-coverage are two separate gates, and coverage is the binding one.**

- The model classified a trig problem confidently even though trig is **outside** the built pilot
  (AP Statistics Unit 1). So "what skill is this?" generalizes broadly.
- But "teach on a *vetted, checkable* parallel problem" (INV-3) needs authored content for the
  classified skill — which may not exist. Confident recognition ≠ confident coverage.
- **Implied product behavior:** `/bring-question` image intake should run **two** checks:
  1. *Classify* the skill (works broadly).
  2. *Do we have vetted practice for it?* (pilot-limited today).
  When (2) fails, degrade honestly to *name-the-skill + "practice for this is coming"* — **never a
  fabricated item.** An LLM free-teaching a skill with no vetted item behind it is exactly the
  INV-3 drift the learning model prohibits. The safe version pairs classification with the authored
  explainer + worked example (the `SkillEntry` learn-first flow, spec §11.2) — so this feature and
  that content dependency are the same bet.

## Guardrails validated in the test (carry into the build)

- Never output the answer to the student's own item; practice on a parallel problem only.
- The photo is read, then discarded — not retained.
- Name/PII sweep before any use (the test page's name field was blank).
- Academic-integrity stance ("we won't do your homework, we'll get you able to") is a feature.

## Not built (later release)

Image intake on `/bring-question`, the vision-classification service, the coverage gate, and the
route into a vetted parallel-practice session. Feasibility of the classification step is proven;
the rest is deferred.
