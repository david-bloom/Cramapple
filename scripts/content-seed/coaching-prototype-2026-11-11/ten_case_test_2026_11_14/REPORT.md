# Ten-case synthetic FRQ coaching test — 2026-11-14

**Status:** Exploratory result, not a coaching release gate or library ablation.

## Method

- Reused five AP Biology responses from the 2026-07-08 grading calibration candidate and five AP Statistics responses from the 2026-07-09 candidate. Both corpora explicitly mark their criterion labels **AI provisional, not human-adjudicated gold**.
- Selected five distinct item families per subject: two fully correct, four partially correct, two borderline, and two subtly wrong responses across the ten.
- Sent each synthetic response, item prompt and stimulus, rubric, and provisional criterion labels to the OpenAI API (`gpt-5.4-mini`) after the owner explicitly authorized that destination and payload. The request contained no real student data. The script capped execution at ten calls.
- The prompt asked for a concise coaching paragraph grounded in the response and supplied rubric outcomes, without invented student motives or point awards. It did **not** include a coaching library or student history. This tests a baseline coaching behavior, not the library's value or cross-session adaptation.
- The author reviewed the outputs against the supplied response and labels. No independent subject reviewer or two-judge coaching gate was run; this is not an `approved` coaching set.

## Run facts

All ten calls returned nonempty coaching. All ten outputs stayed within the 110-word limit. Mean output was 86 words; mean API latency was 1.86 seconds. Usage totaled 15,954 input and 1,301 output tokens. The provider response did not report dollar cost, so no dollar figure is asserted. Case inputs, provisional labels, model outputs, usage, and response IDs are in `results.json`; the fixed instruction prompt is in the test script.

## Case-level read

| Case | Observed coaching result |
| --- | --- |
| Biology L-001, partial | Correctly distinguishes identifying the compensation point from explaining equal photosynthesis and respiration rates. Addresses one more incorrect prediction, but omits the other three missed criteria. Useful prioritization; fails the parent voice rule if that rule requires every lost criterion in the paragraph. |
| Biology L-009, borderline | Identifies the missing nitrate-to-ammonium reduction and organism detail. Its `1 point` statement relies on a provisional partial-credit label and needs grading adjudication before student display. |
| Biology L-017, subtly wrong | Correctly rejects the response's cAMP account of insulin signaling and gives a concrete pathway correction. It addresses two of four zero-credit parts, so it is a targeted intervention rather than a complete score explanation. The source item and rubric need subject review before treating this as verified teaching. |
| Biology L-025, full | Names specific successful elements without inventing a defect. It is mainly a recap, which may be enough for a full-credit case. |
| Biology L-033, partial | Correctly names alcoholic fermentation and the decarboxylation step missing from the response; also points to the aerobic and experimental-design gaps. Strongest concise correction in this slice. |
| Statistics MOD3-H001-INV, partial | Distinguishes a computed interval from interpretation and asks for a more concrete sampling design. It repeats the response's `(807, 893)` interval; the provisional rubric calls approximately `(808, 892)` correct, so this numerical boundary should be adjudicated rather than assumed exact. |
| Statistics MOD4-H001-INV, borderline | **Over-credit risk:** says the response “correctly treat[s] measurement time as a blocking factor,” but the response proposes measuring everyone at the same time, which controls time rather than describing a blocked design. The provisional label marked the criterion earned; the coach amplified that label into a stronger description of the student's work. The suggested improvement for practical significance largely repeats what the student already said. |
| Statistics MOD5-H001-INV, subtly wrong | Correctly identifies the observational-causation error and the role of random assignment. “Your conclusion is not valid because...” is too categorical given the supplied p-value; missing assumptions and overclaiming should be separated. |
| Statistics MOD6-H001, full | Credit recap matches the labels. Its “next step” repeats the exact p-value comparison already present in the student's response, so it adds little teaching value. |
| Statistics MOD7-H001, partial | Correctly repairs the total-probability denominator and Bayes result (`0.025`, `0.60`). It does not explain why a correct formula setup received only partial credit; that partial label needs review. |

## What this establishes

The model can produce case-specific corrections from existing synthetic grading fixtures, and several outputs are useful. It also follows provisional labels into questionable credit claims, and full-credit advice can become redundant. The run does **not** establish individual adaptation: every case had one answer and no prior-student state. It does not measure the proposed library's incremental benefit, learning on a subsequent item, or a low factual-error rate.

Before expanding the coaching library, adjudicate the questionable grading cases, then rerun a paired baseline-versus-library test. For an adaptation check, keep an answer fixed and vary the synthetic history; require a different next teaching action only where that history supports it.
