# Transcription-Fidelity Bake-Off — Live Run Report, 2026-07-09

**Status:** Executed (live vision models via Vercel AI Gateway). **Development
tier — optimistic upper bound** (synthetic machine-rendered images, NOT human
handwriting). The real-handwriting corpus is still required before this number
gates anything.
**Related:** `transcription_bakeoff_protocol.md` (preregistered),
`bakeoff_scorer.py` (scorer), `../math_formula_grading_experiment_2026_07_08/hand_drawn_formula_assessment.md`.

## What ran

| Field | Value |
| --- | --- |
| Corpus | 7 hand-authored formula items (9 lines), easy→hard: AP Stats SE/CI cascade, Physics C drag solution, Calc BC integration-by-parts, Calc AB chain rule, econ multiplier, Physics 1 kinematics |
| Images | **Synthetic** matplotlib-xkcd 2-D math renders (`generate_trace_images.py`), one PNG per item — machine-rendered, clean; NOT scanned handwriting |
| Arms | Vision transcription → deterministic equivalence scorer, via the gateway |
| Models | `openai/gpt-5.5`, `google/gemini-2.5-flash`, `anthropic/claude-haiku-4-5` |
| Scorer | `bakeoff_scorer.py` — algebraic equivalence vs the human reference; equivalent-but-different forms count as FAITHFUL |
| Cost | ~27 vision calls (small); BYOK via the gateway |

## Result

| Model | Faithful | Corrupted | Abstain | **Silent-corruption on correct work** |
| --- | ---: | ---: | ---: | ---: |
| openai/gpt-5.5 | 9/9 (100%) | 0 | 0 | **0.0** |
| google/gemini-2.5-flash | 9/9 (100%) | 0 | 0 | **0.0** |
| anthropic/claude-haiku-4-5 | 9/9 (100%) | 0 | 0 | **0.0** |

All three models transcribed every line faithfully, including the nested-fraction
CI expressions (`850 - 1.96*(120/sqrt(30))`), the drag ODE solution
(`(m*g/b)*(1 - e^(-b*t/m))`), and the integration-by-parts result
(`x*e^x - e^x + C`). The equivalence scorer correctly accepted cosmetic variants
(`e^(x)` vs `e^x`, spacing) as faithful, confirming it is not over-strict.

## What this establishes / does not

**Establishes (a necessary condition):** the full live pipeline works —
image → gateway vision model → per-line transcription → parse → algebraic-
equivalence scoring → fidelity metrics — and current frontier vision models can
read **clean 2-D math** (stacked fractions, radicals, exponents, multi-line
derivations) with zero corruption. Had they failed here, the transcription-then-
deterministic-checker approach would be dead. They did not, so the approach is
viable **in principle**.

**Does NOT establish:** real-handwriting fidelity, or the silent-corruption rate
on messy student input — which is the actual launch gate. These images are clean,
machine-rendered 2-D math (closer to typeset than to a hurried Blue-Book page),
so 100% here is the **optimistic ceiling**, not the operating number.

## Boundary / honesty notes

- Synthetic renders ≠ human handwriting. The hard cases in real capture (slanted
  writing, ambiguous `x` vs `×`, cramped fractions, cross-outs) are absent.
- Small corpus (9 lines). Enough to validate the pipeline and set a ceiling, not
  to estimate an operating error rate.
- No claim about the direct-to-expression arm vs transcription arm (only the
  transcription arm ran); no production or release claim (development tier).

## Next step (unchanged gate)

Run the same pipeline on **human-captured hand-drawn formula photos** (the
`capture_sheet.html` items, written by hand and photographed). The runner
(`../../scripts/vercel-gateway-check/transcription_bakeoff_live.mjs`) and scorer
are unchanged — only swap the images/manifest. That run produces the real
silent-corruption number that gates the hand-drawn Engine-3 path.
