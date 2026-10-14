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
