# Grading Hand-Drawn Mathematical Formulas — Architecture Assessment

**Status:** Assessment for Product Owner; not implementation approval
**Owner:** Product Owner with Learning Quality Owner
**Created:** 2026-07-08
**Related:** `requirements.md` + `report.md` (this folder, the typed-formula
checker); `../DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`;
`../../tasks/TASK-0011-HANDWRITTEN-GRAPH-CAPTURE.md`;
`../ap_statistics_hdr_grading_experiment_2026_07_06/`;
`../grading_cross_subject_takeaways.md` (Lessons 2-4, 6-7)

## The gap

Blue Book exams are answered on **paper**, so in Cramapple these are hand-drawn
responses (phone photos). The entire existing drawn-response program is scoped
to **graphs** — the architecture review's capability table
(`DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md` §2) explicitly files *"Handwritten
equations and derivations"* as a **separate track that has never been started.**
Two things therefore do not connect today:

- The typed-formula equivalence checker built this session assumes clean,
  machine-readable input. It has no perception layer.
- The graph HDR work (capture flow, geometry/OCR observation, the AP Stats
  photo set) does **not** transfer: a graph is a geometry-extraction problem; a
  formula is a **symbol-sequence transcription** problem with different failure
  modes.

This document proposes how to close that gap under the already-approved
architecture rules, and — importantly — argues the hand-drawn *formula* case can
be made **cleaner** than the graph case, not messier, if we make one
architectural choice.

## Why hand-drawn math is harder than a stats graph (the precise version)

The intuition "formulas are more intricate than a graph" is correct, and it
decomposes into four concrete difficulties a graph does not have:

1. **2-D spatial syntax carries meaning.** Superscript vs baseline
   (`x2` vs `x²`), numerator/denominator stacking, subscripts (`v_0`), limits of
   integration above/below `∫`, matrix layout. Position *is* semantics — a graph
   is read as geometry; a formula must be read as a structured expression tree.
2. **Symbol ambiguity is worse than digit ambiguity.** `x` vs `×`, `1` vs `l`
   vs `|`, `2` vs `z`, a minus sign vs a fraction bar vs a subtraction, clustered
   `dx`. A single misread symbol changes the meaning of the whole expression.
3. **Multi-line derivations.** AP FRQs award **method/setup** points, not only
   the final answer. That means reading order across lines, cross-outs, arrows,
   and work in margins — none of which a single-graph capture has.
4. **Prior art says VLMs are materially weaker here.** The FERMAT
   handwritten-math benchmark (already cited in-repo,
   `DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md` §9) and the general
   perception-vs-judgment finding (§4.2) both argue against a single multimodal
   pass as the grader — the same conclusion the graph review already reached.

## The key move: transcription turns judgment deterministic

For graphs, the approved pipeline separates a *visual observation* layer from a
*criterion judgment* layer (§4.3). For formulas that separation is not only
possible, it is unusually clean:

> **Perception's job is to transcribe the handwriting into a machine-readable
> symbolic form (one expression per line of work). The deterministic
> equivalence checker built this session then becomes the judgment layer.**

Once a line is transcribed to a parseable expression, grading it is *already
solved* and deterministic:

- **Final-answer credit:** is the last line algebraically equivalent to the
  keyed canonical? (`report.md`: 100% specificity / 100% detection on the typed
  battery, $0.)
- **Method/step credit:** does line *n+1* follow algebraically from line *n*?
  SymPy can check step-to-step equivalence, so a class of derivation points
  (valid algebra, correct substitution) is **also** deterministic. Only "did the
  student invoke the right principle / justify correctly" stays with the LLM
  grader (Lesson 2 — single fast grader as default for genuine judgment).

This is why the formula case can be cleaner than the graph case: for graphs the
judgment layer is irreducibly perceptual (is that point *on* the line?), whereas
for formulas the judgment collapses to deterministic algebra **the moment
transcription succeeds.** The hard problem is pushed entirely into one place —
transcription — where it can be measured, gated, and made student-correctable.

## Point-maximizing feedback falls out of the same structure

Cramapple's promise is "the minimum fix for the next point" (Lesson 6). That
requires locating the **earliest** place a point was lost, which whole-answer
grading cannot do. The line-by-line transcription + step-validity check gives it
directly:

- **Answer wrong but method sound** → "your setup on line 2 is correct; the
  arithmetic slip is between lines 3 and 4" (a full-method, minor-error profile —
  the point-maximizing feedback students most need).
- **Wrong principle** → routed to the LLM grader, which explains the conceptual
  fix.
- **Equivalent-but-unsimplified** → full credit, no false "simplify further"
  nag (AP accepts unsimplified answers; the checker already honors this).

The feedback layer reasons over the agreed symbolic transcription, not the raw
pixels — which is both more accurate and auditable (every criterion cites the
transcribed line, per §4.3's observation-ID requirement).

## The dominant new risk: transcription error

A misread symbol makes the deterministic checker **confidently flag correct work
as wrong** (or pass wrong work). This is the same failure class as this
session's flat-fraction hazard (`report.md`), but worse, because it is
introduced silently by perception rather than by the student's own typing. It is
the single thing that gates the whole approach. Two mitigations, both already
sanctioned by existing principles:

1. **ABSTAIN on low transcription confidence** — never convert an ambiguous
   perception into a confident flag; route to LLM grader or human instead. This
   is the identical rule adopted this morning for typed notation intake, and it
   preserves the checker's 100%-specificity property by construction. Confidence
   must be calibrated against adjudicated transcription error, **not** the
   model's self-report (§4.4, Lesson 4).
2. **Transcription transparency / read-back confirmation** — show the student
   what was read ("here is your work as we parsed it") and let them correct it.
   This is the highest-leverage single move: it converts perception errors into
   student-correctable events (removing the worst failure mode), is
   exam-authentic-adjacent without building a drawing tool, and hands the
   feedback layer a clean, agreed artifact. It is the formula analog of the graph
   retake loop.

## Born-digital vs paper-photo: offer both, reserve the photo path

Two input modes with very different risk:

- **Born-digital typed / equation-editor practice** (primary device): feeds the
  deterministic checker directly, **zero perception risk** — this is essentially
  already built (this session). Best default for everyday practice.
- **Paper-photo practice** (exam simulation): requires the transcription layer
  and its risk controls above. Reserve it for exam-simulation mode where paper
  authenticity is the point, and always run it through read-back confirmation.

This lets Cramapple deliver formula grading *now* for typed practice while the
harder photo path is validated, rather than blocking all math grading on
handwriting recognition.

## What stays governed and unchanged

Everything the graph review already established applies unchanged: separate
perception from judgment (§4.3); **no single-pass learner-facing score** (§4.5);
calibrate abstention from observed error, not self-report (§4.4); original,
rights-clean questions only — no official CB items as inputs/exemplars/eval
(§4.1); **no vendor selection before a held-out bake-off** (§4.2); preserve the
immutable original image (§3.3); and this track needs its **own adjudicated gold
set** — the graph gold set does not transfer, and depth-over-breadth still holds
(Lesson 7). The external-provider data-transfer approval for minors' images is
still an open gate (blocked the model arm in
`../hand_drawn_sample_grading_experiment_2026-06-29.md`).

## Recommended next step (one cheap, decisive experiment)

Do **not** fork a large new program. The one measurement that gates everything
is transcription fidelity, so run a small bake-off on a hand-authored,
rights-clean set that spans the difficulty range:

- **Hard case:** AP Physics C and Calculus BC multi-line derivations
  (fractions, exponents, integrals, sign-sensitive exponents).
- **Easy case:** econ/stats formula *setup* (single-line `s/√n`, multiplier
  formulas).

Measure the only thing that matters first: **how often does perception transcribe
to a parseable expression, and how often does it silently corrupt correct work?**
Score transcription against a human transcription, per line. Arms should include
at least (a) multimodal-model direct-to-expression, and (b) multimodal
transcription → deterministic checker, mirroring the graph bake-off's
observation-first arm (§6 Priority 3).

- If transcription is reliable enough → the checker + feedback layer are largely
  already built (this session), and read-back confirmation covers the residual.
- If not → **ABSTAIN-to-human is the honest V1**, and structured equation input
  becomes the durable frontend ask (the Lovable dependency this raises).

This keeps the effort proportionate, produces decision-grade evidence on the
single crux, and reuses this session's deterministic layer as-is.
