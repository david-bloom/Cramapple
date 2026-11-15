# Engine-core-to-coaching test — 2026-11-15

**Status:** Completed exploratory offline test. No Production records written; not a release gate.

## Correction to the earlier experiment

The two earlier ten-case coaching runs fed AI-provisional rubric labels directly to a coaching model. They did not use a grader. This run grades ten of those answers first and gives the resulting criterion-level grade, evidence and fixes to the coaching model. The ten are the second run's five Biology and five Statistics answers, one answer per item family.

## Method

- Grade each answer with `gpt-5.4-mini` using the **same shared prompt builder, structured request schema, and sanitizer** imported by `supabase/functions/evaluate-attempt/index.ts` from `_shared/grading-contract.ts`. The runner used the whole-item analytic-text Arm B contract. It did not invoke the deployed edge function, its routing/deterministic layers, or its database-dependent side effects; therefore it is an offline test of the grading core, not an end-to-end Production engine test.
- Give each sanitized grade, rubric, question and synthetic answer to `gpt-5.4-mini` using the earlier coaching prompt with an added instruction to preserve uncertain outcomes. The prompt did not receive the provisional labels or student history.
- Inspect each coach output against the actual answer and grader result. The source corpus labels are AI provisional and cannot adjudicate grader accuracy. No independent model-judge or qualified subject review was run.
- The first grading attempt for Biology L-009 returned `incomplete` at an 8,000-output-token cap. The runner was raised to 16,000 and resumed from the saved first result. The failure is recorded in `failures.jsonl`; ten grades were eventually completed.

## Run facts

| Stage | Completed | Input tokens | Output tokens | Mean API latency |
| --- | ---: | ---: | ---: | ---: |
| Grading core | 10/10, plus one incomplete first attempt | 18,735 | 57,389 | 23.5 s |
| Coaching | 10/10 | 24,116 | 1,217 | 1.39 s |

Using the official `gpt-5.4-mini` list rates of $0.75 per million input and $4.50 per million output tokens, the ten completed grades and coaching calls total about **$0.296**. The incomplete attempt's exact usage was not retained, so this is a lower bound; its 8,000-output-token cap and similar input size put the overall run well below the prototype's $3 per-run guard. This is an estimate from reported tokens, not a billing receipt. [Model pricing](https://developers.openai.com/api/docs/models/gpt-5.4-mini).

Grader outcomes differed materially from the provisional labels. Examples: Biology L-017 graded 7/8 rather than full credit; Statistics MOD4 graded 0/4 rather than multiple earned/partial labels. Two Biology grades were `uncertain` (L-009 and L-025). Full criterion results and usage are in `grades.json`; the subsequent coaching is in `results.json`.

## Coaching read

| Case | Grader result | Coaching finding |
| --- | --- | --- |
| Biology L-001 | 6/10 graded | Correctly names earned and partial parts, reverses the wrong CO₂ prediction, and fixes proton movement and RuBP. Faithful to the grader in this case. |
| Biology L-009 | 1/8 **uncertain** | Names a correct calculation and useful missing work, but presents the undecided part (a) as a lost requirement without saying its grade is uncertain. |
| Biology L-017 | 7/8 graded | Correctly identifies the absent third consequence rather than crediting one the student never wrote. Clear improvement over label-fed coaching. |
| Biology L-025 | 2/8 **uncertain** | States “you earned 2 points” but describes undecided part (b) as “missing” and omits the pending review of (b) and (d). Uncertainty is lost at the handoff. |
| Biology L-033 | 4/10 graded | Correctly replaces lactic-acid fermentation with alcoholic fermentation. It avoids the previous run's false statement that pyruvate decarboxylation itself regenerates NAD⁺. |
| Statistics MOD3 | 1/5 graded | Correctly catches that high-traffic Friday/Saturday sampling would **overestimate**, not underestimate, average daily sales. Also fixes the standard-error denominator. |
| Statistics MOD4 | 0/4 graded | **Contradiction:** begins “You earn credit for” treatment/control groups and random assignment even though the grader awarded zero points. It appears to mean conceptual progress, but a student could read it as awarded credit. It also says `p = 0.02` “shows a real difference in sample data,” an imprecise explanation of statistical significance. |
| Statistics MOD5 | 2/4 graded | Aligns with earned causation and experimental-design criteria; gives specific missing confounder explanations and an additional assumption. |
| Statistics MOD6 | 2/3 graded | Correctly targets the unearned calculation criterion, though it mainly repeats the grader's request for degrees of freedom. |
| Statistics MOD7 | 0/2 graded | Correctly distinguishes the requested conditional probability from the student's joint-probability calculation and gives the missing denominator. |

## Conclusion

The shared analytic-text grading core gives coaching substantially better inputs than the provisional-label shortcut. It corrected several misleading coaching claims. **The handoff still fails when the grader is uncertain or awards zero despite some correct fragments.** Coaching needs an explicit rule that `unable_to_determine` is pending review, not a lost point, and that descriptive encouragement cannot imply earned points absent from `points_awarded`.

This run does not test the full deployed `evaluate-attempt` path, the symbolic or spatial graders, student history, the proposed coaching library, or learning after feedback. The tested answers are typed FRQs routed to analytic-text grading; the other grader types are not applicable to these fixtures.
