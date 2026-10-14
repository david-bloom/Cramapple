# Grader LaTeX test (TASK-0074)

Tests whether the FRQ grader's decisions and explanations change when a rubric line is written with LaTeX
(`\[...\]`) instead of plain text. Synthetic fixtures only; no database, no Production data.

**Approved budget: 54 real model calls** (3 items x 3 responses x 2 rubric forms x 3 repeats), Product Owner,
2026-10-14. The runner enforces the cap by counting lines in the results file, counts failed calls, and stops at the
first failure.

## Run (anyone with an OpenAI key)

    cd scripts/grader_latex_test
    OPENAI_API_KEY=... OPENAI_MODEL=gpt-5.4-mini node run_direct.mjs results.jsonl
    node analyze.mjs results.jsonl

Use the same model the Development grader uses (`gpt-5.4-mini`, high reasoning effort, 3000 max output tokens).
Do not delete `results.jsonl` between runs: it is the call counter. A restart resumes where it stopped.

`run.mjs` is the variant that goes through a temporary Development edge function and needs no local key.

## What the analysis reports

- decision (status/points) per cell for each form, run-to-run agreement within each form, and agreement across forms;
- every model-written field (`evidence_quote`, `decision_explanation`, `minimum_fix`) containing `\(`, `\[`, `\frac`,
  `\mathrm`, `\,` or `$`.

"Safe as is" needs cross-form agreement no worse than run-to-run agreement and zero markup in persisted strings.

## Latest execution — 2026-10-14

[Attempt 2 report](RESULTS_2026_10_14.md): the Product Owner renewed up to 54 calls before execution. The standalone runner stopped on its first HTTP 429 credit refusal, so the fresh counter `results-2026-10-14-attempt-2.jsonl` has **1 attempt, 0 grades, 53 remaining calls**. Preserve both attempts; do not erase the counter or treat analysis `0/0` and zero fields as a successful safety result. A full 54-success matrix needs 54 successful calls in addition to the already-spent failed attempt, requiring separate authorization for any increase beyond the renewed cap. No automatic retry or credit purchase.

## Gateway continuation (preferred with the existing Development key)

The same `openai/gpt-5.4-mini` model is available through Gateway Responses. The temporary Development `tmp-latex-grader-test` harness reads its existing `AI_GATEWAY_API_KEY`; the local driver authenticates only as the established QA account, so the Gateway secret never leaves Development. Keep the production grader unchanged. The harness accepts only indices in the immutable synthetic fixture plan and limits providers to OpenAI, with no model fallback.

    cd scripts/grader_latex_test
    node run_gateway.mjs results-2026-10-14-attempt-2.jsonl 1
    node run_gateway.mjs results-2026-10-14-attempt-2.jsonl 52
    node analyze.mjs results-2026-10-14-attempt-2.jsonl

The first command is part of the matrix, not an additional smoke call. The ledger retains the failed direct request, so the original renewed cap is 54 total attempts and only 53 Gateway successes fit. No implicit reset or extra allowance. `results-2026-10-14-attempt-2-direct-failure.jsonl` preserves the original failure bytes. The driver reserves before sending, refuses an unresolved outcome, selects missing valid observations and stops on failure. `node run_gateway_test.mjs` checks those controls with every fetch mocked (zero provider calls).
