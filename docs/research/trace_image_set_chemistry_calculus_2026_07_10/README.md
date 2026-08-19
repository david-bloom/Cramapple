# Trace Image Set — Chemistry and Calculus (2026-07-10)

**Status:** Internal specification work for a bake-off input set; not a gold
corpus, not a production artifact, not learner-facing.
**Purpose:** Supply the "hard case" (Calculus) and a new subject arm
(Chemistry) for the transcription-fidelity bake-off recommended in
`../math_formula_grading_experiment_2026_07_08/hand_drawn_formula_assessment.md`
("Recommended next step") — the single decisive experiment that gates whether
hand-drawn/photographed formula work can ever be graded automatically.
**Related:** `../math_formula_grading_experiment_2026_07_08/` (typed-formula
checker + `ecf_engine.py`, the judgment layer this bake-off's transcription
output would feed), `requirements.md` (per-subject formula-answer shapes),
`../../tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md` §5–6 (capture-quality
and labeling conventions this set borrows from, at reduced weight — this is a
16-item bake-off input, not a 300-response release corpus).

## What this measures

Per the assessment doc: **"how often does perception transcribe to a
parseable expression, and how often does it silently corrupt correct work?"**
This is a perception-only test. It does not test whether a student's math is
correct — every item's ground-truth expression is fixed in advance
(`items.json`) — it tests whether a vision model reading a photograph of
handwriting reproduces that expression faithfully, line by line.

This set does **not** decide grading accuracy, does **not** produce a gold
set, and does **not** authorize any learner-facing feature. It produces bake-
off *inputs*. The bake-off itself (arms, scoring, decision) is a separate,
later step per the assessment doc's "Recommended next step."

## Rights and originality

All 16 problems and their numeric values were authored fresh for this set.
None reproduce, paraphrase, or derive from College Board (or any other
copyrighted exam) content, per the standing no-CB-material rule applied
elsewhere in this repo (`DECISION-0031`, `CONTENT_GOVERNANCE_AND_VALIDATION.md`).
Safe to trace, photograph, and use as internal research input.

## Item set overview

16 items total: 8 Calculus (`CALC-E1..E3`, `CALC-H1..H5`), 8 Chemistry
(`CHEM-E1..E3`, `CHEM-H1..H5`). Full ground truth (problem statement, exact
canonical line-by-line solution, and the specific notation hazard each item is
designed to surface) is in `items.json`.

**Easy tier (3 per subject):** single-line formula setup or a one-step
result — the floor of the difficulty range, close to the typed-input case
already validated.

**Hard tier (5 per subject):** multi-line derivations (3–5 lines) chosen to
deliberately exercise the specific failure modes the typed-formula report
(`report.md`) already found or flagged as risk:

- **flat/stacked fractions** (the `3t^2/2t` hazard — the single biggest
  production risk found so far, because it silently parses to the wrong
  expression tree)
- **sign-sensitive exponents and subtraction of a negative** (Hess's law
  addition, Arrhenius `e^{-Ea/RT}`, related-rates negative rates)
- **fractions nested inside an exponent or a log argument** (Arrhenius,
  Henderson-Hasselbalch)
- **+C / missing-constant** (antiderivative)
- **multi-line dependency** (does line *n+1* correctly follow from line *n* —
  the method-credit case, not just the final answer)

Each item in `items.json` carries a `hazard_tags` field naming which of these
it targets, so a bake-off failure can be attributed to a specific cause rather
than scored as one undifferentiated miss.

## Tracing instructions (for whoever hand-writes these)

1. **One item per page.** Use ordinary blank, lined, or graph paper; pen or
   pencil, whatever a student would plausibly use.
2. **Copy the canonical solution lines exactly as given in `items.json`**
   (the `canonical_lines` field), in your own natural handwriting — do not
   re-derive or "improve" the math. The point of this set is a controlled,
   known ground truth; if you solve it independently instead of copying, we
   lose the fixed answer key the bake-off scores against.
3. **Write naturally, don't typeset.** Normal handwriting quirks (compressed
   fractions, cursive-ish exponents, uneven subscripts) are exactly the input
   the bake-off needs — don't write unusually neatly to make it "easy."
   Vary pen vs. pencil across items if convenient; that variation is useful
   signal, not noise to eliminate.
4. **Keep each line legible enough for a human to transcribe**, even if not
   for a model — this is a perception test, not a legibility-adversarial one.
   Illegible-on-purpose pages don't add information (see "Out of scope"
   below).
5. **Photograph like a student would**: phone camera, rear camera preferred,
   full page in frame, reasonably lit, minimal glare, roughly perpendicular
   to the page. One photo per item is enough for this bake-off (this is not
   the multi-capture-variant protocol TASK-0011 uses for a release corpus).
6. **Do not write your name or any identifying mark on the page.** Not
   because it's regulated PII here (the governing decision has already ruled
   handwriting itself is not PII), just to keep the images clean of anything
   irrelevant to the transcription question.
7. Send back the 16 photos with the `item_id` noted per photo (filename is
   fine: `CALC-H1.jpg`, `CHEM-E2.jpg`, etc.).

## Out of scope for this set

- Adversarially illegible or deliberately ambiguous handwriting — that's a
  different, later test (robustness/abstention calibration), not this one.
- Multi-page or multi-attempt responses per item.
- Any second solver's independent attempt at the same problem — one traced
  copy per item is sufficient for a perception-only bake-off.
- Any learner data, any production storage, any provider selection.

## What happens with these photos

Per the assessment doc, the photos get run through at least two arms —
(a) multimodal model direct-to-expression, and (b) multimodal transcription →
the existing deterministic `formula_checker.py`/`ecf_engine.py` — and scored
per line against `items.json`'s `canonical_lines`. That comparison, not this
item set, is the actual go/no-go decision point for photographed formula
grading. This document and `items.json` are only the fixed, known-ground-truth
input the comparison needs.

## Captured traces — Calculus (2026-07-10)

`captured_traces/calculus/` holds the first batch of traced photos against
this packet, from `docs/hand drawn samples/Calc AB HDR/` (5 photos, resized to
max 1800px / JPEG q90, EXIF stripped). The tracer combined multiple items per
photo rather than one page per item, so filenames reflect what's actually on
each page rather than a strict 1:1 with `items.json`.

**Coverage: 8 of 8 Calculus items, verified against `canonical_lines`:**

| Item | Photo | Transcription fidelity |
| --- | --- | --- |
| CALC-E1, E2, E3 | `CALC-E1_E2_E3__IMG_7074.jpg` | Exact match, all three |
| CALC-H1 | `CALC-H1_H2partial__IMG_7075.jpg` | Exact match, all 3 lines |
| CALC-H2 | started on `IMG_7075`, completed on `CALC-H2__IMG_7077.jpg` | Exact match, all 3 lines |
| CALC-H3 | `CALC-H3__IMG_7078.jpg` | Exact match, all 3 lines |
| CALC-H4 | `CALC-H4__IMG_7084.jpg` (added 2026-07-10, after HEIC failed to load on first attempt) | Exact match, all 5 lines |
| CALC-H5 | `CALC-H5__IMG_7080.jpg` (labeled "CALC-5" on the page — the tracer dropped the "H") | Matches 4 of 5 lines; omits the final restated "interval of convergence: [-1, 5)" summary line |

Calculus arm is now fully traced.

## Captured traces — Chemistry (2026-07-10)

`captured_traces/chemistry/` holds 8 traced photos against this packet, from
`docs/hand drawn samples/Chem HDR/` (9 HEIC/JPEG photos captured, 1 excluded —
see below). Same treatment as Calculus: resized to max 1800px, JPEG q90, EXIF
stripped.

**Coverage: 8 of 8 Chemistry items, verified against `canonical_lines`:**

| Item | Photo | Transcription fidelity |
| --- | --- | --- |
| CHEM-E1 | `CHEM-E1__IMG_7081.jpg` | Exact match |
| CHEM-E2 | `CHEM-E2__IMG_7082.jpg` | Exact match |
| CHEM-E3 | `CHEM-E3__IMG_7083.jpg` | Exact match (first attempt crossed out on the page; final line matches canonical) |
| CHEM-H1 | `CHEM-H1__IMG_7085.jpg` | Exact match, all 5 lines |
| CHEM-H2 | `CHEM-H2_H3__IMG_7086.jpg` (top half of page) | Exact match, all 4 lines |
| CHEM-H3 | `CHEM-H2_H3__IMG_7086.jpg` (bottom half, same page) | Exact match, all 5 lines |
| CHEM-H4 | `CHEM-H4__IMG_7087.jpg` (kept) + `CHEM-H4_clean__IMG_7089.jpg` (added) | Exact match, all 5 lines — see hazard note below |
| CHEM-H5 | `CHEM-H5__IMG_7088.jpg` | Exact match, all 5 lines |

**Excluded:** `IMG_7084 2.HEIC` in the Chem HDR folder is a stray duplicate of
the Calculus CALC-H4 photo (`IMG_7084.HEIC`, already filed under
`captured_traces/calculus/`), not Chemistry content. Not copied here.

**Correction (2026-07-10) — CHEM-H4 hazard note:** an earlier pass of this
README claimed the tracer wrote `-2.363` instead of `-2.303` on line 3 of
`IMG_7087`. That was wrong — it was a misread on the identifying pass, not a
tracer error. The handwritten `0` in `-2.303` has a small ink nub off the top
of the closed loop that reads as a `6` at normal viewing size; at full
resolution, and compared directly against the clean second photo, the digit
is unambiguously a `0`. **`IMG_7087` is a faithful, exact-match trace of
CHEM-H4** and is being kept, specifically *because* it's a naturally-occurring
example of an ambiguous-digit-stroke hazard — a real instance of the kind of
transcription risk this whole packet exists to test (a single ink artifact
that could plausibly cause a vision model to misread `0` as `6`), which is
more valuable than a synthetic version of the same hazard. `IMG_7089` is an
unambiguous second trace of the same item, added as the clean baseline to
compare against.

Chemistry arm is now fully traced, no open defects. Both subjects — 16 of 16
items in `items.json` — now have at least one traced photo, and CHEM-H4
specifically has two (one clean, one with a real digit-ambiguity hazard).

No transcription-fidelity scoring against a vision model has been run yet —
this only confirms the ground truth photos exist and are legible/faithful to
`items.json`. The actual bake-off (model transcription vs. this ground truth)
is a separate, later step.
