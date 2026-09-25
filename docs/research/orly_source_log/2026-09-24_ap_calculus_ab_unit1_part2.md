# Insight note: AP Calculus AB Unit 1 Part II materials (Solebury, Gavin)

Sources (all Solebury School, same class as the 2026-08-24 batch, teacher
presumed Michelle Gavin — not re-confirmed on these specific documents):

- `Unit 1 Part II Notes Packet.pdf` — 14-page LT-structured notes/practice
  packet, LT1.9 through LT1.15 (school's own numbering — see correction
  below), format matches the "Flipped Math"-style warm-up / notes / practice
  / closing-problem daily structure seen in the 2026-08-24 batch.
- `calc_1.10_packet.pdf` — a standalone practice/test-prep packet for the
  school's "1.10" (discontinuity types), same content family as the notes
  packet's LT1.9 section, with additional graph-based multiple-choice
  test-prep items.
- `calc_mid-unit_1_review.pdf` — "Mid-Unit 1 Review — Limits, Lessons 1.1
  through 1.9," algebraic limit-evaluation and multiple-representations
  review.
- One photographed page (via chat, not a separate PDF file) showing a related
  discontinuity/continuity worksheet with what appears to be **Orly's own
  handwritten work on it**. Per protocol §7, grading or evaluating Orly's own
  submitted work is explicitly out of scope — this image was used only to
  confirm it's the same topic family as the other three documents, not
  reviewed as her work product.

Logged in `SOURCE_LOG.md`.

## Correction to the source's own numbering (protocol §6 step 1 in action)

The school's "LT" labels do **not** match the College Board's own topic codes
starting at LT1.9, unlike the 2026-08-24 batch where they matched exactly
(1.1-1.8). Verified against `app.taxonomy_topics` before authoring anything:

| School's "LT" label | What it actually covers | Real CED topic code |
| --- | --- | --- |
| LT1.9 | Discontinuity type identification | **1.10** Exploring Types of Discontinuities |
| LT1.10 | Continuity definition; piecewise "find k" for continuity | **1.11** Defining Continuity at a Point |
| LT1.11 | Domain of functions, incl. transformations of parent functions | Prerequisite/algebra-review skill — not its own CED topic (see Category note) |
| LT1.12 | Find the value that removes a discontinuity / makes a point continuous | **1.13** Removing Discontinuities |
| LT1.13 | Infinite limits / vertical asymptotes | **1.14** Connecting Infinite Limits and Vertical Asymptotes |
| LT1.14 | Horizontal asymptotes / limits at infinity | **1.15** Connecting Limits at Infinity and Horizontal Asymptotes |
| LT1.15 | Intermediate Value Theorem | **1.16** Working with the Intermediate Value Theorem (not 1.15) |

This is exactly the failure mode the protocol's step 1 warns about — the
2026-08-24 batch happened to match and this one doesn't. Worth re-verifying
every time, not assuming from one good match.

The mid-unit review's own label ("Lessons 1.1 through 1.9") is closer to
correct — its content (algebraic limit evaluation, one/two-sided limits,
squeeze-theorem-shaped trig limits, table/graph limit estimation, difference
quotient interpreted as average rate of change in a modeling context) maps
reasonably to real topics 1.1-1.9, though "1.9 Connecting Multiple
Representations of Limits" is the loosest fit — the review's mixed
table/graph/algebraic items support that read.

## Pacing and sequencing

This batch picks up right where the 2026-08-24 summer-assignment batch left
off content-wise (that one was 1.1-1.8, school-numbered) and works through
essentially the rest of Unit 1's *limits and continuity* content (real
1.10-1.16) before Unit 1 presumably moves into derivatives-adjacent material.
A mid-unit review sits at the 1.1-1.9 boundary — a real checkpoint pattern:
this teacher reviews roughly the first half of a unit's content once, mid-way
through, rather than only at the unit's end. Worth considering for Cramapple's
own unit-pacing if a "mid-unit checkpoint" UX pattern is ever built.

## Structural devices worth noting (not content)

- **"Spot the Error" problem type**: a worked solution with deliberately
  planted mistakes (3, in the notes packet's LT1.9/1.10 closing problem) that
  the student must find and correct, explicitly required to use target
  vocabulary ("limit", "f(c)") in the explanation. A genuinely different
  practice-item shape from anything Cramapple currently serves — closer to
  our own error-analysis/misconception framing than a standard MCQ/FRQ, worth
  a product conversation if error-analysis items are ever considered as a
  distinct practice format.
- **"Fix it" prompts**: after showing a broken example, asking "what single
  change would remove the break" — a minimal-edit framing that could inform
  hint design (asking a student for the smallest fix rather than a full
  re-derivation).
- **One-sentence-takeaway / fill-in-the-blank summary prompts** at the end of
  a topic ("A discontinuity is *removable* when ..., and I can remove it by
  ...") — a lightweight self-explanation checkpoint, distinct from the 0-4
  rubric scale seen in the summer-assignment batch.
- Calculator-allowed vs. no-calculator sections are explicitly marked within
  a single worksheet (the mid-unit review), not just at the assessment level
  — a finer-grained calculator-mode signal than Cramapple currently captures
  per-item pacing-wise, though `calculator_mode` already exists per item.

## Category note

CED-aligned unit content overall (§4), with one embedded prerequisite-style
skill: LT1.11's "domain of functions, including transformations of parent
functions" is general algebra/precalculus review folded into the Calc AB
sequence rather than a distinct AP Calculus CED topic — same
prerequisite/readiness pattern the AP Chemistry summer assignment surfaced in
the 2026-08-24 batch, just embedded mid-unit here rather than as its own
document. Not shoehorned into a CED topic code for authoring purposes (see
work order).
