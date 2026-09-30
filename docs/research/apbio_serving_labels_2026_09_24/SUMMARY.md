# AP Biology Serving Labels — Work Orders N + N.1

**Status:** BLOCKED BEFORE MODEL CALLS  
**Branch:** `codex/work-order-n-biology-serving-labels`  
**Production writes:** 0

## Preflight completed

- Production scope re-verified against `Cramapple - Production` (`pcntajvbdfqhbeewmdry`).
- Work Order N scope is exactly **43** published AP Biology short FRQs with no current serving label.
- Work Order N.1 scope is exactly **5** named MCQs.
- `packet.jsonl` contains exactly **48 unique current Production item/version packets**.
- No content field was changed.
- No QA-owned file was created or edited.
- No Production write was attempted.

## N.1 Unit-3 audit

The widened audit inspected **15** current, unsuperseded AP Biology serving labels whose `required_units` contains Unit 3.

Known N.1 Unit-3/Unit-4 confusions:
- `APBIO-MCQ-030`
- `APBIO-MCQ-033`
- `APBIO-MCQ-046`

Additional suspected Unit-3/Unit-4 confusions found outside the five-item N.1 proposal scope:
- `APBIO-MCQ-031` — RTK dimerization / downstream signalling.
- `APBIO-MCQ-035` — somatostatin / Gi / cAMP / KATP signalling.

These two are recorded in `u3_audit.csv` only. They were **not** silently added to the N.1 proposal scope.

## Required model run not executed

The governing work order requires the exact independent pair:

- `openai/gpt-5.5`
- `google/gemini-2.5-flash`

through the **Vercel AI Gateway**.

This ChatGPT session does not currently have an installed/connected Vercel integration or an accessible `AI_GATEWAY_API_KEY`/`VERCEL_OIDC_TOKEN`. The Vercel connector has been surfaced for connection. I did **not** substitute another model pair because that would invalidate the measured lane and violate the work order.

Therefore `serving_label_proposal.jsonl` has not been created yet. N and N.1 are **not complete** until the mandated two-model run and aggregation/assertions are finished.

## Next required action

Connect Vercel for this ChatGPT session (or resume this branch in a Codex environment that already has the Vercel AI Gateway credential), then run the 48 packets through the mandated pair. After that:

1. emit `serving_label_proposal.jsonl`;
2. assert N=43, N.1=5, and 48 unique content keys/version IDs;
3. verify every successful FRQ criterion appears exactly once in both model outputs;
4. require exact unit-set **and criterion-map** agreement for FRQs;
5. route disagreements/preflight failures to empty final units + human review;
6. flag every exact-agreement final set containing Unit 3;
7. require MCQ `criterion_units=null` and retain keyed-answer/distractor evidence;
8. confirm packet/proposal version IDs match;
9. confirm Production writes remain 0;
10. update this summary and `run_metadata.json` to COMPLETE.

No PR should be opened and nothing should be merged to `main` under this work order.
