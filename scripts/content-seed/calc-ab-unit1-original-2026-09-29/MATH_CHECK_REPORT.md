# Independent math check: 136 items, two model families (2026-09-29/30)

**Items:** 34 originals + 102 variants = 136 (116 MCQ, 20 FRQ). **Checkers:** `alibaba/qwen3.8-max` and `deepseek/deepseek-v4-pro` (chosen by the Product Owner; neither is from the author's family).
**Script:** `scripts/vercel-gateway-check/apcalcab_unit1_math_check.mjs` · **Analysis:** `analyze_math_check.py` · **Raw results:** `math_check_results_round1.jsonl`, `math_check_results_round2_patched.jsonl`

## Method (protocol section 9, done by other families)

Two passes per item per model, 4 calls per item:
1. **Blind solve.** The model sees the question and choices (shuffled to fresh letters, so no build order leaks) or the FRQ parts. No key, no rationales. MCQ answers are compared to the key.
2. **Rationale audit.** The model sees the key and every choice's rationale (or every rubric criterion), solves the item itself first, then judges whether the keyed choice is right and whether each rationale is factually accurate and correctly explains the error. This targets the text students will read as feedback (TASK-0053).

Every flag was adjudicated by the orchestrator against direct computation. A flag is not a finding until it is checked.

## Round 1 (all 136 items)

| | Qwen 3.8 Max | DeepSeek V4 Pro |
|---|---:|---:|
| MCQ blind solve agreed with my key | 108 of 116 | **116 of 116** |
| MCQ solve "disagreements" | 8 (all Qwen errors: 7 contradicted its own working, 1 arithmetic slip -24/6 = -12) | 0 |
| Rationale flags | 44 | 10 |
| Criterion flags (FRQ) | 6 | 1 |
| Errors / retries | 0 | 0 |
| Median call time | 24 s | 12 s |

**Keys: no key was wrong.** **Rationales and rubric text: about 20 items had real defects** (adjudicated from roughly 60 raw flags; the rest were wording nitpicks, misread shuffled letters, Qwen's own arithmetic slips, or a hallucinated "part (e)").
Real defects: two false numbers in rationales (016-v3 f(1) = -1/3 not -1/2; 021-v2 limit -2 not -1); five distractor rationales that did not explain the error that yields the choice (009-v1, 010-v3, 028-v2, 029-v3, and the "3" distractor); FRQ 005-v1 called x a "common factor"; overstated wording ("must be rationalized", "the quotient rule" for limits, a denominator approaching 0 "makes the quotient large" without the nonzero-numerator condition); imprecise lists (tangent undefined "at x = 6 and -6"); one ambiguous choice (003-v3); FRQ 001 variants wrote "the numerator is 2" where it only approaches 2.
Fixed items are listed in `patched_keys.txt` (29) plus the round-2 fixes below.

## Round 2 (29 patched items, both models, both passes)

Answer keys again held on every MCQ. New problems found and fixed:
- **003-v3:** my instructed rewording made choice B vacuously true (the stem says C(3) is undefined), giving two defensible choices. Reworded to "Any value later assigned to C(3) must be 12." Rechecked: clean.
- **010-v3:** the rewritten rationale claimed the product is "not bounded above by 1", false near 0. Reworded. Rechecked: clean.
- **007-v1:** "gives an unbounded result only if the numerator does not shrink too" was inaccurate. Reworded. Rechecked: clean.
- **029-v3:** the distractor "3" did not follow from the described error (3/(-1) = -3). Replaced with "-3" and its rationale. DeepSeek solve agreed and its audit raised nothing; Qwen chose "infinity" on the solve pass, which is wrong (2^x outgrows x^8; sympy and DeepSeek agree the limit is 0), and its audit call timed out.

## How the two checkers compare

- **Solve:** DeepSeek 116/116; Qwen 108/116 at first and wrong on 029-v3 again on the re-run. Every Qwen miss was visible in its own reasoning, so it is unstable at committing to a final answer, not unable to do the math.
- **Audit:** DeepSeek's flags were almost always real (roughly 8 of 10 in round 1). Qwen produced about 4 times as many flags, most of them noise, and its audit calls were slow (some over 3 minutes).
- **Recommendation:** use DeepSeek as the primary auditor; keep Qwen as an independent second solver, and adjudicate any Qwen-only flag before acting.

## Not changed on purpose

About 40 Qwen-only remarks were left alone: wording that is accurate but could be tighter, "could also mention" suggestions, remarks about choices it had mislabelled after the letters were shuffled, and rationales it later withdrew in its own output. The original FRQ 001 evidence line ("cancels x - 3") lacks the "for x not equal to 3" qualifier that its variants now have; that is a small consistency gap, not an error.

## What this establishes and does not

Established: the answer keys and rubric claims of all 136 items were independently re-derived by two families other than the author, and the student-facing rationale text was audited and corrected.
Not established: CED scope for the 102 variants (phase 4 not yet run on them), item quality or difficulty calibration, and anything a human reviewer would catch about wording or fairness. Nothing is in a database.
