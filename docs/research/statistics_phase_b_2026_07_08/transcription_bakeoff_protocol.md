# Transcription-Fidelity Bake-Off — Preregistered Protocol (TASK-0016 Phase B)

**Status:** Preregistered; **not yet executed** (the live arms need Vercel AI
Gateway credentials, absent this session). The scorer and self-test are built and
verified (`bakeoff_scorer.py`); this runs turnkey when creds land. Per the
canonical process and integrity rules, **no fidelity numbers are fabricated
here.**
**Related:** `../math_formula_grading_experiment_2026_07_08/hand_drawn_formula_assessment.md`
(why transcription is the dominant risk), `DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md`
§6 (observation-first bake-off pattern), TASK-0016 Phase B.

## Decision this run informs

Can perception transcribe hand-drawn / photographed math to a parseable symbolic
expression reliably enough that the deterministic Engine-3 checker can grade it —
**or** must the hand-drawn path default to ABSTAIN-to-human with structured typed
input as the durable fix? This is the gate on the Engine-3 photo path; the typed
path (Phase A) does not depend on it.

## The one metric that gates everything

**Silent corruption of correct work.** Perception fails safely when it abstains
(unparseable → route to human) and dangerously when it produces a *parseable but
wrong* transcription, because the deterministic checker will then confidently
grade correct student work as wrong. The primary endpoint is therefore:

> Among lines whose **human reference transcription grades CORRECT**, the
> fraction whose **model transcription grades NOT-correct** (silent-corruption
> rate). Target: as close to 0 as possible; this is the specificity the whole
> deterministic layer's value rests on.

Secondary endpoints: parse rate, faithful rate (model ≡ human by algebraic
equivalence, so a different-but-correct form is NOT counted as corruption),
abstain rate, and per-stage latency (capture+upload dominates the photo tail).

## Corpus (to capture — minor-image approval granted, `APPROVAL-0033`/prior)

- Rights-clean, hand-authored AP Statistics + math-family items spanning the
  difficulty range: **hard** = multi-line derivations with fractions/radicals/
  exponents (Physics C / Calc BC style, plus the AP Stats SE→CI→t cascade);
  **easy** = single-line formula setup (`s/sqrt(n)`, multiplier, elasticity).
- Each captured response gets a **human reference transcription** (ground truth),
  authored blind to any model output, one entry per line of work.
- Capture-condition variants retained (device, lighting, pen/pencil) for
  robustness, split by underlying response — not by photo variant.

## Arms (freeze the manifest before any scoring)

1. **Direct-to-expression:** vision model → symbolic expression per line.
2. **Transcription→checker:** vision model → transcription, then the existing
   deterministic checker/ECF grades it (the architecture we intend to ship).

Keep prompt, output schema, and line-segmentation identical across arms. Record
the model + manifest before examining any output (DECISION-0030 burn rule).

## Scoring (credential-free — `bakeoff_scorer.py`)

The scorer reads one JSON record per line (`{item_key, line_id,
human_transcription, model_transcription, human_grades_correct}`), and for each:
parses the model transcription (ABSTAIN on failure), compares to the human
reference by **algebraic equivalence** (so equivalent forms are FAITHFUL, not
CORRUPTED), and rolls up parse / faithful / corrupted / abstain rates plus the
gating silent-corruption rate on correct-work lines. It runs today against a
synthetic self-test fixture to prove the mechanics; it scores real model outputs
unchanged once the arms run.

## Pass / fail logic

- **Green (ship photo path with read-back):** silent-corruption rate ≈ 0 and
  parse+abstain covers the rest safely; residual routed to read-back
  confirmation.
- **Red (ABSTAIN-to-human V1 + structured typed input):** non-trivial
  silent-corruption rate that read-back cannot catch → do not let the
  deterministic checker grade photo-sourced formulas; escalate to human and make
  the structured equation editor the frontend ask.

## Explicitly not claimed until executed

Fidelity, latency, and the ship/no-ship call — none exist until the gateway run
happens. This document + the verified scorer are the turnkey scaffold only.
