# Codex G3V — AP Statistics 2026-27 Vertical-Slice Independent QA

**Status:** Proposed QA finding — remediation required before bulk generation
**Date:** 2026-07-13
**Source reviewed:** `docs/research/ap_statistics_2027_vertical_slice_2026_07_13.md`
**Reviewer:** Fresh independent Codex QA context; not the authoring cascade
**Environment impact:** None; document review only

## Proposed verdict

**FAIL — targeted remediation and G3V re-review required.** Result: **7 PASS / 3 FAIL across 10 logical review units**.

The source summary says “9 items,” but its declared inventory is one linked three-question set + five standalone MCQs + four FRQs. That is **10 logical review units** or **12 atomic questions**. The count must be corrected before deterministic pipeline counts become authoritative.

All numeric claims recomputed correctly. None of the five removed topics is tested: departures from linearity, combining random variables, geometric distribution, chi-square goodness-of-fit, or inference for slopes. The Unit 5 item uses only a supplied regression line and descriptive residual.

## Per-item results

| Review unit | Result | Independent verification |
|---|---|---|
| Linked MCQ Set 1 (1.1–1.3) | PASS | Side-by-side boxplots correctly compare quantitative distributions across categories. IQR = `12−5=7`; upper fence = `12+1.5(7)=22.5`; 25 is flagged. A convenience class is nonrandom and cannot support school-wide generalization. |
| Standalone MCQ U1 | PASS | Adding 5 changes the mean by +5 and leaves SD unchanged. |
| Standalone MCQ U2 | PASS | Binomial mean `np=20(.3)=6`; variance `20(.3)(.7)=4.2`; SD `√4.2=2.04939≈2.05`. This is retained binomial content, not geometric or combining random variables. |
| Standalone MCQ U3 | PASS | `SE=√(.30·.70/200)=√.00105=.0324037≈.032`. |
| Standalone MCQ U4 | PASS | `SE=10/√25=2`; `df=25−1=24`; t procedure is correct because only sample SD is supplied. |
| Standalone MCQ U5 | PASS | `ŷ=3+2(5)=13`; residual `15−13=2`. Descriptive regression only. |
| FRQ Q1 | **FAIL** | Numeric shape checks are correct: Zone 1 outer spreads `40−18=22` vs `10−4=6`; Zone 2 `16−2=14` vs `30−25=5`. Points 2–10 are otherwise separable. Point 1/model answer incorrectly calls Branch P a census while the stated study population is library members and only members visiting during one chosen week are reached. That is a time-location/convenience frame with undercoverage unless the target population is explicitly redefined as that week’s visitors. |
| FRQ Q2 | PASS | Brand A sum `805`, mean `115`, median `95`; `Q1=85`, `Q3=105`, `IQR=20`, upper fence `135`. Brand B sum `868`, mean/median `124`, `Q1=120`, `Q3=128`, `IQR=8`; symmetric. Add explicit consequential-error/ECF language for dependent Points 5–7, but this is non-blocking for content correctness. |
| FRQ Q3 | **FAIL** | `SE=9/√36=1.5`; `t=(496.5−500)/1.5=−2.3333`; `df=35`; two-sided `p≈.0255`; reject at `.05`; Type I statement is correct. However B(ii) asks the learner to **verify** independence and requires `n≤10%`, while the stimulus gives no production/population count. “Presumably” is not verification. |
| FRQ Q4 | **FAIL** | Distribution sums to 1; `P(X≥3)=.50`; `E(X)=2.60`; model `p0=P(X≥4)=.25`; `p̂=68/250=.272`; `SE=√(.25·.75/250)=.0273861`; `z=.803326`; two-sided `p≈.4218`; expected counts 62.5 and 187.5. Part D demands an inferential decision but supplies neither alpha nor an explicit two-standard-error rule. The model silently introduces “well under ~2.” |

## Required remediation

1. **Q1:** either key Branch P as a convenience/time-location sample and explain undercoverage, or explicitly redefine the target population before asking so every member of that population is reached. Preserve “apparent/likely” when inferring shape from five-number summaries.
2. **Q3:** state that the company produced/has at least 360 relevant bottles, explicitly state independent sampling, or change the verb from “verify” to a justified condition statement that matches supplied evidence.
3. **Q4:** add `α=0.05` and use the p-value decision, or explicitly ask whether the sample result is within two standard errors of the model. If independence is to be verified, also supply at least 2,500 relevant orders.
4. Add explicit consequential-error/ECF rules for downstream criteria in Q2 and the calculation/decision chains in Q3/Q4 so “independently earnable” is operational rather than aspirational.
5. Correct the inventory count to 10 logical units / 12 atomic questions and make the deterministic counter state which convention it uses.

## Gate disposition

G3V does not clear. The three failed FRQs require targeted author revision followed by fresh independent re-review. The seven passing units need no correctness rewrite, subject to the still-pending fact-pack/domain review described by the source artifact. Nothing was staged or published.
