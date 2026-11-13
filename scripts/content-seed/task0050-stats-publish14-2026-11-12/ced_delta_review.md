# TASK-0050 manual CED delta review of the 12 revised successors

This read checks the *change from retired v1*, using `review14_draft_successors.json` and the sanctioned `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`. It does not replace the content protocol's two independent checker-family pass. Two older-family checks on each retired v1 found no scope issue on 13/14 targets; both flagged old MCQ-017's slope-inference content.

| Successor | Content delta | CED fact-pack scope |
| --- | --- | --- |
| GRAPH-021, GRAPH-022 | Unequal group totals make students compute conditional relative frequencies before drawing and comparing segmented bars. | §2.1–2.2 defines conditional relative frequency; the 2026-10-16 correction to §2.1 names segmented bar charts. |
| GRAPH-024, GRAPH-026 | Unequal group totals make mosaic width reasoning meaningful; a conditional-proportion comparison is now explicit and scored. | §2.1–2.2 covers two-way counts and conditional relative frequencies; the §2.1 correction names mosaic plots. |
| GRAPH-029 | A readable score list replaces a malformed table; the answer now treats 62 as a clear low outlier. | §1.5 names dotplots; §1.7–1.8 covers quartiles, IQR, and outliers. |
| GRAPH-032 | “Advertising spend” becomes “amount spent on advertising”; plotted pairs and association are unchanged. | §5.1 names scatterplots and direction, form, and strength of association. |
| GRAPH-036 | Corrected trend line and strength description for unchanged nine points; independently recomputed `r≈−0.765` and least-squares slope `−4.60`. | §5.1 supports scatterplots and association description; §5.5 describes least-squares line parameters as technology-calculated. The item asks students to sketch, not hand-derive coefficients. |
| MCQ-007 | The wheel now explicitly has ten equal sectors, three red; distractor D's five-spin probability uses the fifth power. | §2.5–2.7 covers independent events and the distinction between a single next event and a joint sequence. |
| MCQ-007-CAL | Corrects the same distractor exponent and updates legacy Unit 4 prompt metadata to current Unit 2. | §2.5–2.7 covers independent events; the new unit map places this in Topic 2.7. |
| MCQ-010 | Clarifies that sample size alone does not decide normality. | §3.2 explicitly requires both `np≥10` and `n(1−p)≥10`. With `n=40`, `p=.03`, `np=1.2` fails. |
| MCQ-012 | Changes the new-design completion count to 248, synchronizes the p-value to `≈.037`, and specifies the one-sided alternative. | §3.12–3.13 covers pooled two-proportion tests; §1.13 covers randomized experiments and causal inference. The independent one-sided calculation gives `p=0.036963`. |
| MCQ-017 | Replaces an old slope-standard-error/inference item with interpretation of a fitted slope of `−1.8`. | §5.5 explicitly requires contextual slope interpretation. §8 removes the old slope-inference topic, so the replacement resolves both earlier scope flags. |

No new concept in these deltas is outside the cited fact-pack topics. Fresh two-family scope checks remain the publication gate.
