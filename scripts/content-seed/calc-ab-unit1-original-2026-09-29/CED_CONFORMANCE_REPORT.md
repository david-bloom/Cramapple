# Phase 4: two-family CED-conformance report (34 original items)

**Batch:** `calc-ab-unit1-original-2026-09-29` · **Run:** 2026-09-29 · **Protocol:** `CONTENT_AUTHORING_AND_QA_PROTOCOL.md` section 4 and 5.3
**Raw results:** `ced_conformance_results.jsonl` (68 rows, all `ok`). **Script:** `scripts/vercel-gateway-check/apcalcab_unit1_ced_conformance.mjs`
**Authority:** the fact pack `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`, with disputed points settled against `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`.

## Checkers and why

| Model | Family | Role |
|---|---|---|
| `deepseek/deepseek-v3.2` | DeepSeek | checker |
| `google/gemini-2.5-flash` | Google | checker (the protocol's candidate third family) |
| `anthropic/claude-haiku-4-5` | Anthropic | **excluded**: the author of these items is Claude, so a same-family checker breaks writer-independence (section 3.2) |

The prompt is the section 4 prompt with the load-bearing "do not flag a specific value or example merely because it is not verbatim" rule unchanged.
The author is recorded only in this folder's README (protocol gap P0-A).

## Result

| | Count |
|---|---:|
| Items checked | 34 (29 MCQ, 5 FRQ) |
| Both families `fully_in_scope` | 33 |
| Both families `contains_out_of_scope_content` | 1 (FRQ 003) |
| Disagreements between families | 0 |
| Internal-consistency issues that are real defects | 0 |

Reliability note: Gemini's structured-output mode failed on 11 items across up to 6 attempts each (4 never recovered). Those 4 (MCQ 005, 006, 007, 013)
were re-run with the same prompt asking for plain JSON, validated against the same schema, and are marked `mode: text_json` in the results. The
script now does this fallback itself. DeepSeek never needed a retry.

## Adjudication (section 5.3: settle by source, not by vote)

**FRQ 003, part (c): flagged by both families. FALSE POSITIVE, resolved against the CED.**
Both models flagged "justify using the relative growth rates of the functions" as not being a named justification method in the fact pack. A grep confirms
the fact pack has no text on growth rates (it lists topic 1.15 only by title plus one misconception note). The actual CED, however, lists
**LIM-2.D.5 under topic 1.15: "Relative magnitudes of functions and their rates of change can be compared using limits."** The concept is in scope.
Both models were right about what the pack says and wrong about the course. The same models cleared MCQ 029, which tests the same concept, so the flag was also inconsistent.
**Action for the pack (a documentation gap, not an item defect):** add LIM-2.D.3, D.4 and D.5 to the topic 1.15 entry so the next check has something to grep.

**Consistency notes (DeepSeek on MCQ 003, 009, 022 and FRQ 005): not defects.** Each note restates that a distractor is intentionally wrong, or that a value
(such as h(5) = 0.2) was chosen on purpose. MCQ 022's list of "out-of-scope concepts" names epsilon-delta and exotic DNE cases that the item does not use; its verdict was `fully_in_scope`.

## What this does and does not establish

- It establishes that two families outside the author's read every item against the scope source and found no scope violation. Both-clear is provisional
  per section 5.3: it is unverified by a third path. Checkers can also share a blind spot, and Haiku's documented failure mode (rationalizing past an exclusion) is exactly why
  a single family is not used.
- It does **not** check mathematical correctness. That is the section 9 independent re-derivation, which is still open (the author's own sympy check in `verify_and_build.py` is not independent).
- It does not check reading level, difficulty, or whether distractors are good. That is human review (phase 3).

## Remaining gates before publish

1. Phase 3 human review (needs the drafts in the database and reviewer assignment: requires approval).
2. Section 9 independent re-derivation by a fresh context, not the author.
3. Terminal-approved `review_status`, then the publish gate.

## Addendum: re-run on a newer Gemini (same day)

The first run used `google/gemini-2.5-flash` because the protocol named it as the candidate third family; nobody had checked the gateway for
newer models. The gateway lists `google/gemini-3.5-flash` (and 3.6, 3.7, 3.8 Flash), so the whole batch was re-run on 3.5 Flash
(`ced_conformance_results_gemini35.jsonl`).

| | gemini-2.5-flash | gemini-3.5-flash |
|---|---:|---:|
| Valid structured results, first attempt | 7 items failed all 6 attempts; 27 needed retries | **34 of 34, 0 retries** |
| `fully_in_scope` | 33 | 33 |
| Flagged | FRQ 003 | FRQ 003 (same reason: "relative growth rates", CED LIM-2.D.5) |

Both Gemini generations reach the same verdicts on all 34 items, so the batch's conclusions do not depend on which one is used. 3.5 Flash is the
better checker on reliability alone. The protocol was changed the same day (v0.5) so checker models are picked from a suggested menu instead of a fixed roster.

## Addendum 2: the 102 variants (2026-09-30)

**Checkers (Product Owner accepted the recommendation):** `google/gemini-3.5-flash` and `deepseek/deepseek-v4-pro`. Neither shares a family with the author (Claude).
**Results:** `ced_conformance_results_variants.jsonl` (204 calls, all valid, 1 retry) and `ced_conformance_results_variants_round2.jsonl` (re-check of four changed items).
DeepSeek V4 Pro had passed the structured-output smoke test (3 items, including a table FRQ) but **not** the protocol's known-defect calibration, so its recall is unproven; it is recorded here as smoke-tested only.

| | DeepSeek V4 Pro | Gemini 3.5 Flash |
|---|---:|---:|
| `fully_in_scope` | 101 of 102 | 100 of 102 |
| Flagged | 1 (MCQ 028-v3) | 2 (FRQ 003-v1, MCQ 029-v1) |
| Flags shared by both | 0 | 0 |

**Adjudication (grep against the fact pack and CED):**
- **FRQ 003-v1 (Gemini only): false positive.** "Relative growth rates" is CED LIM-2.D.5, in scope (same as the originals' FRQ 003).
- **MCQ 028-v3 (DeepSeek only): real.** The fact pack says not to author or approve an `apcalcab-*` item on logistic models (7.9 is BC-only). The item's `900/(1 + 8e^(-t/3))` colony model is a logistic function. Replaced with a non-logistic radical model (probe speed, `30t/sqrt(t^2 + 9)`); re-checked clean by both families and by the math check.
- **MCQ 029-v1 (Gemini only): real, fixed.** The stem posed a discrete "steps on input of size n" and then asked to "write n as x", which invites a sequence-limit reading (BC Unit 10). Restated with a continuous variable from the start. Re-checked clean.
- **Consistency notes (Gemini, 7 items):** one real wording fix (017-v1 said "unbroken" where AP language is "continuous"; fixed). The rest are realism nitpicks (a pressure setting of -3, a cost function that goes negative for years 2 to 9, a density that goes negative in a distractor) and one rubric-strictness remark (FRQ 002 variants: whether "zero denominator and nonzero numerator" is an acceptable asymptote justification versus a limit statement). Left as is except 029-v3, whose denominator was changed to `5(2^x) - x^3`, which stays positive for all x >= 0.
  **Reviewer note:** the AP-strictness remark on FRQ 002 (and its variants) is defensible; parts (b) and (c) already require limit statements with signs, so part (a) is only identification. A human reviewer may want part (a) to require a limit statement too.

## Addendum 3: the 34 originals on the same pair as the variants (2026-09-30)

Re-ran the originals with `deepseek/deepseek-v4-pro` and `google/gemini-3.5-flash` so every one of the 136 items has been checked by the same two families
(results: `ced_conformance_results_originals_round3.jsonl`). **34 of 34 `fully_in_scope` from both models; 68 valid calls, 0 retries.**
FRQ 003, flagged in the first two rounds because the fact pack omits LIM-2.D.5, was cleared by both.

**CED coverage across the batch, final:** originals 34/34 clear (2 checkers); variants 102 checked, 3 flags raised and all resolved (1 dismissed as a fact-pack gap, 2 real and fixed and re-checked clean). The four variants changed after their first check (017-v1, 028-v3, 029-v1, 029-v3) were re-checked and clear.
Unproven: DeepSeek V4 Pro's recall (no known-defect calibration run), and the CED check reads scope only, not correctness or quality.
