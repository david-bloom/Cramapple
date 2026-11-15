# Second ten-case synthetic FRQ coaching test — 2026-11-14

**Status:** Exploratory read, not a release gate or library ablation.

## Method and run

This reused the five Biology and five Statistics item families from the first ten-case run but chose a different synthetic answer for each item. The source corpora and criterion labels are the same **AI-provisional, non-adjudicated** grading candidates. The user had authorized sending synthetic cases and rubrics to the OpenAI API; `gpt-5.4-mini` received ten new answers under the script's ten-call cap. No real student data, student history, coaching-library context, or Production writes were involved.

All ten calls returned nonempty coaching within the 110-word limit. Mean output was 85.5 words and mean API latency 1.82 seconds. Usage was 15,415 input and 1,289 output tokens. The provider did not return a dollar cost. The complete case inputs, labels, outputs and usage are in `results.json`; the fixed instruction prompt and reproducible selection are in the test script (`--round=2`).

## Case-level findings

| Case | Review finding |
| --- | --- |
| Biology L-001, subtly wrong | Recognizes that the student now earned the compensation-point criterion, unlike the first answer, and repairs the opposite CO₂ prediction. It leaves the incorrect proton-gradient direction and RuBP prediction unaddressed. |
| Biology L-009, partial | Corrects the 5,000 kg trophic-chain error to 50,000 kg and credits the NPP values. “Part of a point” is too vague for a provisional two-point criterion; the omitted parts (c)(ii) and (d) are not discussed. |
| Biology L-017, borderline | **Unsupported claim about the answer:** the coach says the student gave three consequences, including altered gene expression. The answer names increased glucose uptake/low blood sugar and growth/division, but does not state a gene-expression consequence. The provisional label marked the criterion earned; the coach expanded that into an invented description of the student's work. |
| Biology L-025, partial | Correctly switches from the first run's full-credit recap to the missing synapomorphy and molecular-clock work. Focuses on the most actionable parts. |
| Biology L-033, subtly wrong | **Factual teaching error:** it says the pyruvate-to-acetaldehyde decarboxylation “also regenerates NAD+.” The supplied rubric separates those steps: decarboxylation releases CO₂; subsequent reduction of acetaldehyde to ethanol oxidizes NADH and regenerates NAD+. This output must not be shown to a student. |
| Statistics MOD3-H001-INV, subtly wrong | **Missed central error:** the answer says Friday/Saturday sampling *underestimates* mean daily sales because weekends have *lower* traffic, contradicting the question's highest-traffic premise. The coach does not identify that reversal, despite a no-credit bias label, and starts by praising the sampling plan. It does correctly flag the wrong standard-error denominator. |
| Statistics MOD4-H001-INV, partial | Identifies missing confounder and practical-significance detail. It calls the test incomplete but does not explicitly correct the student's approximate `t ≈ 2.0`; the supplied group summaries give `t ≈ 2.56`. |
| Statistics MOD5-H001-INV, borderline | Appropriately warns that a p-value alone does not establish the direction “restriction reduces anxiety,” and asks for another assumption. Stronger than the first run's critique of this item. |
| Statistics MOD6-H001, borderline | Follows the provisional label in awarding the calculation point despite the answer's shorthand “sqrt(sum of variances)” instead of an actual computation. Its recommendation to make the α-based decision explicit is useful, but the earned label needs adjudication. |
| Statistics MOD7-H001, subtly wrong | Correctly distinguishes `P(B and D)=0.015` from the requested `P(B|D)` and supplies the missing denominator. Clear and useful. |

## Paired interpretation

The ten outputs changed when the answer changed: for example, Biology L-017 moved from zero-credit correction to full-credit recap, and Statistics MOD7 moved from repairing an incorrect denominator to explaining why a joint probability is not a conditional probability. This is evidence of **response sensitivity**, not evidence of adaptation to an individual student's history or prior help. Several responses still followed provisional labels too literally or overlooked what the answer actually said.

Across the two runs, twenty outputs from ten item families exposed at least one clear factual coaching error and multiple faithfulness/credit risks. No defensible defect-rate estimate follows from this selected, small, non-adjudicated sample. The next gate should require human adjudication of the fixture labels and a response-faithfulness check that can reject claims such as the Biology L-017 invented third consequence. A separate paired history test is needed to assess individualized teaching choices.
