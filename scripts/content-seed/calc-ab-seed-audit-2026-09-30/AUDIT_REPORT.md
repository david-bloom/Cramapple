# Published Calc AB MCQ rationale audit, early-unit sample (2026-09-30)

Same method as the pilot (blind solve + rationale audit, Gemini 3.8 Flash + DeepSeek V4 Pro). Items: 12 here + the 8 pilot seeds = 20 items.
Coverage: **Unit 3 is a census** (all 5 published MCQs), **Unit 2 is a near-census** (5 of the 6 labeled MCQs; `mcq-004` has no published version),
Unit 1 has 5 of about 10 pre-batch MCQs, Units 4-8 have 1 each (the pilot seeds only).
Cost of this run: $0.157 (12 items x 2 models x 2 passes). Raw: `out/results.jsonl`. Items exactly as stored: `items.json` (`build.py`).

| | Result |
|---|---|
| Blind solve vs stored key | 0 of 24 disagreed. All keys correct (except `mcq-037`, found earlier, whose stored letter disagrees with its flagged choice) |
| Items with a flagged rationale | 5 of 12 here; 10 of 20 with the pilot seeds (5 of 8) |
| Flagged by both models | 4 of 12 here (`005` by Gemini only); 8 of 20 combined |
| By unit | Unit 3: 4 of 5 (005, 007, 008, 030). Unit 2: 1 of 5 (026). Unit 1: 1 of 5 (080). Units 4-8: 4 of 5 seeds (031, 038, np2-006, 016; not 017) |

Findings in this batch are wording/derivation errors in distractor rationales, verified by hand:
`mcq-030` A and `mcq-008` A call a reciprocal (-4/3, -5/4) the "negative reciprocal" (the negative reciprocal of -3/4 is 4/3, of -4/5 is 5/4);
`mcq-007` B says the outer derivative is "inverted", which would give 6x^2 sqrt(1+x^3), not the shown 3x^2 sqrt(1+x^3);
`mcq-005` A says it "omits both product-rule terms" but 2e^(2x)cos x is the product of the two derivatives;
`mcq-080` D says "not a true division by zero" (it is 0/0; the limit exists because the zero cancels).

Sample size: an exact 95% Wilson interval for 10 of 20 is about 30% to 70% (22% to 61% for the both-models-agree count of 8). That rules out
"a few rogue items" in these units but does not pin the library-wide rate; the sample is not random and Units 4-8 are barely sampled.
