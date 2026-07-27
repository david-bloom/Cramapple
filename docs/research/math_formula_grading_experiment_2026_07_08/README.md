# Math Formula Grading Experiment — 2026-07-08

Session focus: mathematical formula grading for the math-heavy subject family
— AP Calculus AB/BC, AP Precalculus, AP Physics 1/2, AP Physics C (Mechanics,
E&M), AP Macro/Microeconomics, AP Statistics.

Extends the deterministic-check layer (DECISION-0034, Takeaways Lesson 3) from
numeric-presence checking (`../deterministic_check_experiment_2026_07_08/`) to
**algebraic-equivalence** checking of formula answers.

## Contents

| File | What it is |
| --- | --- |
| `requirements.md` | Per-subject formula-grading requirements map; shared platform capabilities; notation-intake position (the product decision this raises) |
| `hand_drawn_formula_assessment.md` | Architecture assessment for grading **hand-drawn** (Blue Book photo) formula responses: why math is harder than a graph, the transcription-makes-judgment-deterministic move, point-maximizing feedback, the transcription-error risk, and the one cheap decisive next experiment |
| `formula_checker.py` | Deterministic symbolic checker: expression equivalence, antiderivative (+C), numeric; PASS/FLAG/ABSTAIN verdicts matching the numeric sibling |
| `cases.json` | Development-tier battery: 62 asserted cases across all 10 subjects/SKUs + 4 quarantined notation hazards |
| `summary.json` | Machine-readable run results |
| `report.md` | Interpreted results, hazard analysis, claims supported/not supported, follow-through |
| `ecf_engine.py` | **Error-Carried-Forward (consistency-point) state machine** on top of the checker — the reference implementation for Codex. Two-universe cascade; verdicts CORRECT / CORRECT_VIA_ECF / CONCEPTUAL_COLLAPSE / COINCIDENTAL / NAKED_ANSWER / INCORRECT; chain-of-custody logic (rounding-robust); point-maximizing per-part feedback. 6/6 development battery. Naked answer → "help" per owner decision 2026-07-08 |
| `ecf_summary.json` | Machine-readable ECF battery results |

## How to run

```
python3 formula_checker.py   # no network, no API keys; SymPy required (1.14 used)
```

Deterministic (seeded sampling); rewrites `summary.json` and prints the
per-case table.

## Headline result

62/62 assertions met — 100% specificity (32/32 correct/equivalent forms PASS),
100% detection (27/27 wrong formulas FLAG), 3/3 conceptual ABSTAIN — at $0.
One production risk identified and quarantined: typed flat fractions
(`3t^2/2t`) false-flag under standard parsing; mitigation options are in
`requirements.md`.

**Tier: development.** Hand-built battery for checker mechanics; supports no
production quality claim (Lesson 7 stands — the launch gate remains the
adjudicated Biology gold set).
