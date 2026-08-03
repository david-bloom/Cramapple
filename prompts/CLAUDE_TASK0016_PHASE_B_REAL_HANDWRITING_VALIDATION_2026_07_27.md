# Claude Execution Prompt — TASK-0016 Phase B Real-Handwriting Validation

Repo: `Cramapple`. Work on the current canonical grading branch. Preserve all
unrelated working-tree changes and stage only files created or intentionally
modified by this task.

## Objective

Run the already-built Phase B transcription-fidelity bake-off against **real
handwritten formula photographs**, then report whether photo-sourced
transcription is safe enough to feed Cramapple's deterministic symbolic/ECF
checker.

Phase B's architecture work is already complete. This run is a validation
follow-up, not permission to redesign the engine. The critical endpoint is
**silent corruption of correct work**: a parseable but incorrect transcription
that would make the deterministic checker falsely reject correct student work.

## Read first

Read these files completely before doing anything:

1. `docs/GRADING_PROGRAM.md`
2. `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md`
3. `docs/research/statistics_phase_b_2026_07_08/README.md`
4. `docs/research/statistics_phase_b_2026_07_08/transcription_bakeoff_protocol.md`
5. `docs/research/statistics_phase_b_2026_07_08/bakeoff_capture_corpus.jsonl`
6. `docs/research/statistics_phase_b_2026_07_08/bakeoff_scorer.py`
7. `docs/research/math_formula_grading_experiment_2026_07_08/hand_drawn_formula_assessment.md`

Do not rely on chat history for experimental facts.

## Existing work—reuse it

Do not recreate the synthetic experiment, corpus, scorer, or symbolic checker.
The synthetic-render run already produced 9/9 faithful lines and zero silent
corruption for three models. It is an optimistic pipeline validation, not real
handwriting evidence.

The live runner was previously committed at:

`scripts/vercel-gateway-check/transcription_bakeoff_live.mjs`

If it is absent from the checkout, recover that exact file from commit
`1a76a29`; do not rewrite it from memory. Verify its current compatibility
before making any narrowly necessary fix.

## Required human inputs

Look for a real-capture master manifest at:

`docs/research/statistics_phase_b_2026_07_08/real_handwriting_captures_manifest.json`

The master manifest may be an array or object, but it must identify each
individual capture and include:

- `item_key`;
- an absolute or manifest-relative image path;
- an anonymous writer ID;
- capture-condition metadata when known: device, lighting, pen/pencil;
- a human-confirmed reference transcription for every written line;
- `human_grades_correct`;
- a statement that the reference transcription was confirmed **before and
  blind to model output**.

Use rights-clean adult/internal handwriting where possible. Strip EXIF and
exclude names, email addresses, faces, school identifiers, or unrelated page
content. Do not commit raw images containing personal information.

At minimum, require one complete real handwritten packet covering all seven
existing capture items. Prefer every supplied packet and capture variant. Treat
multiple photos of the same written response as a grouped robustness variant,
not as independent student work.

The recovered runner accepts a simple `item_key → image_path` manifest. Derive
one runner-compatible manifest per complete writer/capture packet from the
frozen master manifest, run packets separately, and annotate/concatenate the
result records with `capture_id`, anonymous writer ID, and condition metadata.
Do not discard grouping information merely to satisfy the legacy runner.

### If the real captures are missing or incomplete

Do not substitute synthetic renders, generated handwriting, fonts, or image
filters. Do not fabricate a fidelity result.

Instead:

1. validate the capture sheet and expected filenames;
2. write
   `docs/research/statistics_phase_b_2026_07_08/REAL_HANDWRITING_CAPTURE_HANDOFF.md`
   listing the exact missing captures and manifest fields;
3. stop before any paid model call;
4. report the human-capture blocker clearly.

## Preflight and freeze

Before examining any model output:

1. Verify every image opens and every manifest entry resolves.
2. Verify the human reference line count matches
   `bakeoff_capture_corpus.jsonl`.
3. Run the credential-free scorer self-test.
4. Run `validate_keys.py` and record the result.
5. Freeze a dated run manifest containing:
   - image hashes;
   - anonymous writer/capture grouping;
   - included item keys and line counts;
   - model IDs;
   - prompt hash;
   - runner/scorer commit hashes;
   - planned cost ceiling;
   - exclusions and reasons.
6. Store the frozen manifest under:
   `docs/research/statistics_phase_b_2026_07_08/real_handwriting_run_2026_07_27/`.

Do not change references, prompts, line segmentation, or exclusions after
viewing outputs. Any correction requires a new versioned manifest and a clear
burned-run record.

## Paid arms

Use the Vercel AI Gateway/OIDC configuration already established in
`scripts/vercel-gateway-check/.env.local`. Never copy credentials into an
artifact.

Run the same three model families used in the synthetic baseline when they are
available:

- `google/gemini-2.5-flash`
- `anthropic/claude-haiku-4-5`
- `openai/gpt-5.5`

Run both frozen observation prompts:

1. direct exact transcription;
2. transcription intended for deterministic checking.

If the recovered live runner exposes only one prompt, preserve its original arm
as the primary comparison and add the second arm only through a small,
reviewable configuration—not a duplicated runner.

Use all frozen captures. Process capture variants without pooling them as
independent writers. Set a hard total spend ceiling of **$5.00**. Stop launching
calls before the next call could exceed the ceiling. Record failed calls and
known incurred cost.

## Scoring

Use `bakeoff_scorer.py`; do not score by eyeballing model output.

For each model, arm, writer, capture condition, and difficulty slice, report:

- total lines;
- parse rate;
- algebraically faithful rate;
- safe abstain rate;
- silent-corruption count and rate on human-correct lines;
- exact binomial confidence interval for the silent-corruption rate;
- schema/line-count failures;
- end-to-end p50, p90, p95, and max latency;
- estimated cost per image and per line.

Equivalent algebraic forms are faithful. Unparseable or empty output is a safe
ABSTAIN, not silent corruption. A parseable but non-equivalent transcription of
human-correct work is silent corruption.

Also perform a blinded qualitative audit of every silent-corruption case:

- identify the visual ambiguity;
- determine whether a read-back UI would expose it;
- classify it as segmentation, symbol identity, superscript/subscript,
  fraction grouping, radical extent, sign, or other;
- propose the smallest safe mitigation.

## Decision language

Do not call a small real-handwriting packet production validation.

Use these conclusions:

- **Promising:** zero observed silent corruption, with confidence interval and
  sample-size limitation stated.
- **Unsafe for automatic checking:** any recurring or material silent
  corruption not reliably exposed by read-back.
- **Inconclusive:** insufficient captures, excessive safe abstention, or
  operational/schema failure.

Typed formulas remain unaffected. If the photo path is unsafe or inconclusive,
recommend ABSTAIN-to-human plus typed/structured input; do not weaken the
deterministic checker to accommodate bad transcription.

## Required outputs

Create:

- `real_handwriting_run_2026_07_27/FROZEN_MANIFEST.json`
- `real_handwriting_run_2026_07_27/records_<model>_<arm>.jsonl`
- `real_handwriting_run_2026_07_27/summary.json`
- `real_handwriting_run_2026_07_27/RESULTS.md`
- `real_handwriting_run_2026_07_27/EXECUTION_LOG.md`

The report must compare real handwriting with the prior synthetic result without
pooling them, state the evidence tier, and recommend ship-with-read-back,
ABSTAIN-to-human, or more capture.

Update `docs/research/GRADING_PROGRAM_LEDGER_2026_07_27.md` only with the final
measured result and next action. Do not rewrite historical reports.

## Completion checklist

- Real, human-confirmed captures used; no synthetic substitution.
- Inputs and prompt frozen before outputs.
- Credential-free validators pass.
- Paid spend stayed within the cap.
- Raw records and scorer outputs retained.
- Silent-corruption cases individually audited.
- No credentials or personal data committed.
- Ledger updated with evidence tier and decision.
- Only task-scoped files staged/committed.
