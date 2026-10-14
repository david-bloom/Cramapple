# TASK-0074 — Follow-up review of the Gateway QA results

**Date:** 2026-10-14. **Reviewer:** Claude. **Reviews:** `RESULTS_2026_10_14.md` at commit `c4f89731`, written by Codex.
**Scope:** read-only analysis of the existing ledger. No model call, rubric write, database write or deployment was made.
**Evidence preserved:** Codex's report and both ledgers are unchanged (`results-2026-10-14-attempt-2.jsonl`, SHA-256
`e009e20d94a3da6484846d828c3ff99a1b5f2a3c4b5d4302c30fe4c5a2236343` per that report; the direct-failure snapshot is kept
separately). The checks below are reproducible with `python3 followup_stats.py results-2026-10-14-attempt-2.jsonl`
and `node analyze.mjs results-2026-10-14-attempt-2.jsonl`.

## Outcome

**Keep the ten rubric rows in their current plain text (Option A, chosen by the Product Owner 2026-10-14).** The
pilot does not show that a LaTeX rubric is safe, and it does not show that it is unsafe. It shows one borderline cell
that behaved differently and one stray-markup string. No mitigation is built or deployed.

## 1. Independent verification of the counts

| Claim in the report | Reproduced? | Note |
|---|---|---|
| 54 ledger lines: 1 failed direct request + 53 valid Gateway grades | Yes | 54 lines, 53 with a parsed result |
| Within-form agreement 50/52 | Yes | `analyze.mjs` |
| Cross-form agreement 72/78 | Yes | `analyze.mjs` |
| Center of mass, vague: plain earned 3/3; LaTeX not_yet_earned, not_yet_earned, earned | Yes | the only cell with any variation |
| Exactly one backslash-markup field, in a LaTeX-form `minimum_fix` | Yes | 1 of 159 fields scanned (81 plain, 78 LaTeX) |
| Two U+007F characters around the expression in that string | Yes | see section 4 |
| 17 form cells have three repeats; `csc/vague/latex` has two | Yes | |

I did not re-check the 53 generation IDs, token usage or the helper's source comparison; those are taken from the
report.

## 2. Acceptance-rule interpretation

The README's "safe as is" rule has two conditions: cross-form agreement no worse than run-to-run agreement, and no
markup in persisted strings.

- **Condition 1 fails as written:** 72/78 (92.3%) cross-form against 50/52 (96.2%) within-form.
- **Condition 2 fails as written:** one string contains `\,` and `\mathrm{m/s^2}`.

Both literal failures stand. What the rule cannot do is separate a real effect from noise at this sample size.

## 3. Observed difference versus a causal claim about LaTeX

**What was observed:** in 8 of the 9 cells, plain and LaTeX rubrics gave the identical decision in all six repeats. The
whole cross-form gap comes from one cell, `com/vague`. All 6 disagreeing pairs and both within-form disagreements sit
in that cell, in the LaTeX arm.

**Why this is not yet a causal claim:**

1. **Noise is not excluded.** An exact permutation test (shuffle form labels within each cell; statistic = cross-form
   disagreeing pairs) gives **p = 0.40**; Fisher's exact test on `com/vague` earned-rate (plain 3/3 against LaTeX 1/3)
   also gives p = 0.40. With three repeats per arm the pilot could not have detected even a large effect.
2. **The LaTeX arm was itself unstable in that cell** (earned once, not-earned twice). A response the model grades
   inconsistently under one wording is a borderline response, whatever the form.
3. **The two rubric forms differ by more than LaTeX.** The LaTeX text adds a line break before the equation, swaps
   `×` for `\times`, wraps units in `\mathrm{}` with thin spaces, and rewrites `x_cm` as `x_{\mathrm{cm}}`. There is no
   control that keeps the new layout but drops the LaTeX commands, so a real difference could come from any of these.
4. **"Vague" is a fixture label, not a gold grade.** The response "Take the weighted average of the two positions"
   gives the method but not the computation. The LaTeX arm's more frequent "not yet earned" is arguably the more
   rubric-faithful grade, and the plain arm's 3/3 "earned" may be the lenient one. The direction of the difference is
   not evidence that LaTeX made grading worse.
5. **Transport and coverage.** The calls went through the AI Gateway to the same model, not the direct provider path
   production uses. Three synthetic items, display `\[...\]` only, inline `\(...\)` untested, one cell one repeat short.

**Why the rows still stay plain.** The product requirement is narrower than "LaTeX is harmful": editing a rubric line
that the grader reads must not change grading, and a presentation-only edit has no reason to take that risk. This
pilot cannot show invariance, and one cell moved. That is sufficient to hold the edits without claiming causation.

## 4. The control characters are not a LaTeX signature

Scanning every model-written string for control characters (C0 except tab and newline, and DEL) found five fields in
four calls:

| Form | Call | Field | Characters |
|---|---|---|---|
| plain | mech / vague / rep 1 | decision_explanation | U+001A twice, around the quoted equation |
| LaTeX | mech / vague / rep 1 | decision_explanation | U+007F twice, around the quoted expression |
| LaTeX | mech / vague / rep 1 | minimum_fix | U+007F twice, around the expression (the field with `\,\mathrm{...}`) |
| LaTeX | csc / correct / rep 1 | decision_explanation | U+001B ANSI escape sequence (`ESC[1m ESC[0m ESC[0m`) |
| LaTeX | mech / vague / rep 3 | decision_explanation | U+0012 and U+0013 around a quoted span |

- The pattern is **not specific to LaTeX**: a plain-rubric run shows it too, and in every case the characters surround
  a quoted equation or span. The report's description ("markup plus U+007F characters") is accurate for the one string
  but could be read as a LaTeX effect; the data do not support that reading.
- The cause is unknown. It could be a tokenizer or structured-output artifact, or something in the Gateway path. It was
  only observed through the Gateway.
- Of the five fields, only the `minimum_fix` string also contains a backslash command; no other flagged field does.
  That string, with delimiters absent, would show on screen as raw backslashes, since the prose renderer only typesets
  delimited spans.

These strings are model-written text that can reach students (`decision_explanation`, `minimum_fix`). That is an
output-hygiene question independent of the LaTeX decision.

## 5. Smallest mitigation and its verification plan

**Not needed under Option A.** If typeset rubric lines are wanted later, the options in order of preference are below.
None is built here, and none should be built or deployed without its own authorization.

**M1 — keep the grader's text byte-for-byte and store the typeset form separately (recommended).** The rubric's
grader-facing text stays exactly as it is today. The typeset version is added as display-only data that the question
page reads and the grader never queries.
- *Verification:* (a) an offline test that assembles the grading prompt for each of the ten criteria before and after
  and asserts byte equality; (b) a static check that the grader's criterion query does not select the display field;
  (c) if (a) and (b) hold, the model request is identical, so decision invariance follows by construction, apart from
  the model's own sampling variance. No model calls are needed.
- *Cost:* a schema or content-pack change, an app change and a deployment, each its own hard-gated step.
- The row text itself contains published exam text, so tests that use it must run in the private repository.

**M2 — a per-row lookup at prompt-build time.** Same effect as M1, with an explicit stored original per criterion
that the prompt builder uses. Same verification. This is a lookup, not a converter.

**M3 — a generic prompt-build conversion (flatten the LaTeX before the model sees it): not recommended and not
certified.** This review does **not** claim that a generic LaTeX stripper preserves grading semantics. A converter
that rewrites `\frac{a}{b}` as `a/b` can change precedence, grouping and units, and this pilot says nothing about
whether the resulting text grades the same. It would need per-row semantic equality checks against the original text
and a bounded, separately approved model verification before any use.

**Output hygiene (a separate, small item).** Stripping control characters (C0 except tab and newline, and DEL) from
model-written strings before they are stored is semantics-neutral, because those characters do not print. It would
not address a backslash-command leak, and it would need to be shown on real model output. Only M1/M2 removes the
LaTeX-in-prompt cause of that leak, since plain-form prompts produced no backslash leak in 81 scanned fields.

## 6. Limits of this review

- The ledger is small and synthetic; nothing here is a population-level estimate or a grading certificate.
- The missing observation (`csc/vague/latex` repeat 3) is not needed for any conclusion above and was not requested.
- Behavior on the direct provider path and with inline `\(...\)` delimiters is untested.
- No claim is made that LaTeX is harmless or harmful to grading, only that this evidence does not support editing
  grader-read text.
