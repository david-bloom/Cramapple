# TASK-0065 Units 1–3: outside-checker results (2026-10-06)

**Items:** 91 (`SCOPE_UNITS_1-3.json`). Biology 21, Statistics 29, Chemistry 21, Calc AB 20.
**Checkers (DECISION-0093, APPROVAL-0123):** `google/gemini-3.8-flash` and `deepseek/deepseek-v4-pro` through the
Vercel AI Gateway. Both are outside the Anthropic author family. DeepSeek V4 Pro replaced "DeepSeek 5", which is
not on the gateway; David chose it.
**Script:** `scripts/vercel-gateway-check/open_hand_teaching_check.mjs`. Each item gets a blind solve (stem and
choices only) and an audit against the subject's CED fact pack, temperature 0.
**Cost:** not metered per call; well under $1 at list prices.

## Smoke test (AQP §3.2 rule 4)
- Four items, one per subject: all clean on both models (`smoke_run/`).
- Canary: the same four items with a deliberately wrong key. Both models flagged all four:
  blind solve vs key, plus key_disputed (`smoke_canary_run/`).

## Full run (`check_run_1/`)
- 182/182 calls completed, with 0 call failures.
- **Every blind solve matched the key on both models, and neither model disputed any key.**
- 13 items raised at least one flag (union of both models). Each was verified by hand or by recomputing it in
  Python:

| Item | Flag | Verdict | Action |
|---|---|---|---|
| Calc AB 1.5 | rationale B (DeepSeek) | **Real.** 11/3 comes from reading (-2)^2 as -(2^2), not from "dropping the sign". | Reworded |
| Stats 1.5 | rationale A (DeepSeek) | **Real.** "The bin can hold 11 different scores" confuses the count with the possible values. | Reworded |
| Stats 3.14 | rationale A (DeepSeek) | **Real, minor.** Homogeneity also covers randomly assigned treatment groups. | Reworded |
| Stats 3.15 | rationale D (DeepSeek) | **Real.** 1.67 is Σ\|O−E\|/E. Σ(O−E)/E = 0. | Reworded |
| Stats 1.12 | off_topic (DeepSeek) | Not a defect. The published 1.12 brief and explainer cover exactly this (range, repeats, mapping). | None |
| Bio 2.10 | scope (DeepSeek) | Not a defect. The published 2.10 brief cites circular DNA, ribosomes and binary fission as the evidence. | None |
| Bio 3.3 | scope (DeepSeek) | Not a defect. The published 3.3 brief is about ATP hydrolysis and energy coupling. | None |
| Chem 3.8 | figure/calculator (DeepSeek) | Not a defect. The diagrams are described fully in words, and 8/100 = 16/200 needs no calculator. | None |
| Stats 3.3, 3.7, 3.9, 3.10, 3.13 | figure/calculator | Not a defect. AP Statistics allows a calculator on the whole exam, and Open Hand shows the worked answer. Keys recomputed: 1068 (n ≥ 1067.1, round up), z = 2.67, SD = 0.0638, CI (0.174, 0.426), z = 3.28. | None |

## Patch and re-check
The 4 rewordings were applied on top of PR #348, which rewrote the fix lines as actions. They went into
`SCOPE_UNITS_1-3.json` and into the subject copies (`ap-calculus-ab_u1-4.json`, `ap-statistics.json`), and every
fix line stays an action.
- `open_hand_teaching_check.mjs` on both models (`recheck_run_1/`): **4 of 4 clean**.
- `lint.py`: **4 of 4 pass**.
- `teaching_item_check.mjs` C3 trap audit (`recheck_run_1_c3/`): Calc AB 1.5, Stats 1.5 and Stats 3.15 pass on
  both models. **Stats 3.14 fails on both, because of choice D** (unnamed temptation; the fix states a fact). That
  is not one of my edits. Stats 3.14 is presumably among the 13 temptation-blocked items PR #345/#348 left open.

**Status:** 76 of the 91 items clear every stage. Still open from PR #345/#348: the 13 C3-blocked items (unnamed
temptation) and the 2 lint failures (Calc AB 1.11 and 1.13 use `!=`). Nothing has been loaded.
