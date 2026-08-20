# DECISION-0045 gold-verification pass — Engine 4 real-photo corpus — 2026-08-19

**Trigger:** `DECISION-0050` (2026-08-19) un-deferred `DECISION-0045`'s Set C for Engine 4 and
stated explicitly that "the existing 200-photo real-Biology corpus's single-pass-AI gold does not
automatically become certified gold... it still needs an actual DECISION-0045-protocol pass —
two independent non-OpenAI model families checking it." This directory is that pass, run against
`../gold/real_photo_gold_labels_2026_08_18.json` (200 photos, the gold written by Claude/Anthropic
in a single-pass, per `HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`).

**The existing gold file was NOT modified.** This directory only adds new files (this README, two
raw per-model output JSONL files, an analysis summary, and a flagged-discrepancy list).

## Independence constraint and model selection

Per `DECISION-0045`: the grader under test is OpenAI (`gpt-5.2`/`gpt-5.2-pro`, confirmed in
`ENGINE4_PRODUCTION_DESIGN_2026_08_18.md`). The existing gold's writer is Anthropic/Claude — the
writer family is "consumed" and cannot also verify. Two independent, non-OpenAI, non-Anthropic
model families were therefore required.

**Models tried, and what happened:**

| Model | Family | Vision-capable via gateway? | Structured-output reliable? | Used? |
|---|---|---|---|---|
| `google/gemini-2.5-flash` | Google | Yes | Yes, after raising `maxOutputTokens` (see below) | **Yes** |
| `moonshotai/kimi-k2` | Moonshot | **No** — 400 error on any image input (all 3 providers behind the gateway route: zai/deepinfra/novita reject or fail on image content) | N/A | No |
| `moonshotai/kimi-k2-thinking` | Moonshot | Yes for plain text (`streamText` returned correctly) | **No** — every attempt at the actual structured-output call (image + 6–9-criterion JSON schema) either failed to parse or did not return within 150s; two separate single-call probes were killed after hanging with zero output. Diagnosed as unreliable for this task's schema shape, not a fluke — dropped per the task's explicit instruction not to substitute a grader/writer-family model in its place. | **No** |
| `alibaba/qwen3-vl-235b-a22b-instruct` | Alibaba | Yes | Yes for most archetypes; **systematically returns an empty judgment for one archetype** (see Finding 1 below) | **Yes** (second verifier, in place of Kimi) |
| `zai/glm-4.6` | Zhipu | No — provider explicitly returns "does not accept image input" (deepinfra) / schema rejection (zai, novita) | N/A | No |
| `xai/grok-4`, `xai/grok-2-vision-1212`, `mistral/pixtral-large-latest`, `meta/llama-3.2-90b-vision-instruct`, `deepseek/deepseek-v3.2` | — | `grok-4`/`grok-2-vision`/`pixtral-large`/`llama-3.2-90b-vision` not found under those slugs on this gateway; `deepseek-v3.2` reachable but text-only tested, not pursued once Qwen validated cleanly | — | No |

**Final verifier pair: `google/gemini-2.5-flash` (Google) + `alibaba/qwen3-vl-235b-a22b-instruct`
(Alibaba)** — two model families, neither OpenAI (grader) nor Anthropic (gold writer), both
independently confirmed vision-capable and schema-reliable via a 2–4-photo validation probe before
the full run. `models.mjs`'s originally-suggested `moonshotai/kimi-k2`/`kimi-k2-thinking` pair was
**not** usable (see table) — this substitution (Alibaba/Qwen for Moonshot/Kimi) was made because
the task instructions explicitly named the Kimi models as "or" options subject to a reliability
check, not a hard requirement; Kimi failed that check outright (no vision) or was empirically
unreliable (thinking variant), so a third candidate was probed and validated the same way before
being used, rather than substituting a disallowed OpenAI/Anthropic model.

## Blind verification protocol

Verifiers were never shown: the existing gold's `criterion_statuses`, each other's output, or any
`gpt-5.2` grading output. Each call's prompt (`buildPrompt()` in
`scripts/vercel-gateway-check/decision_0045_verify_run.mjs`) contains only: `item_id`, `archetype`,
the item's `student_prompt`/`stem`, and the rubric's `criterion_id`/`met_rule` pairs — reading from
the same `hand_drawn_graph_corpus_2026_06_29/hand_drawn_graph_questions_2026_06_29.jsonl` source
the original gold-writing pass used. The output schema (`criterion_statuses[]` with
`earned`/`not_earned`/`unable_to_determine`, plus `confidence` and `rationale`) exactly matches
`hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs`'s grader schema, so results are directly
comparable across grader/gold/verifiers.

## Cost discipline and actual spend

Pre-run estimate (after the 2–3 photo validation probes measured ~$0.004–0.005/call for both
models): 200 photos × 2 models ≈ 400 calls × ~$0.005 ≈ **~$2 projected**, far under the $10
autonomous cap — proceeded to the full run without stopping.

**Actual spend** (sum of gateway-usage-derived `cost_usd` across all calls, tracked via
per-model pricing tables in the harness — see note on Qwen pricing below):

| Item | Calls | Cost |
|---|---|---|
| Validation probes (both models, several rounds while diagnosing token-budget truncation) | ~20 | ~$0.10 |
| `google/gemini-2.5-flash` full run (200 photos + 3 retries for calls that still failed to parse at 8000 tokens) | 203 | $1.32 |
| `alibaba/qwen3-vl-235b-a22b-instruct` full run (200 photos, 0 errors) | 200 | $0.73 |
| **Total** | **~423** | **~$2.15** |

Well under the $10 autonomous cap; no approval checkpoint was needed.

**Note on Qwen pricing:** the gateway did not return a per-call cost/billing field for this model
(unlike some others whose `raw` usage included an `estimated_cost`), so `cost_usd` for Qwen calls
uses a deliberately conservative (likely-too-high) placeholder rate in
`decision_0045_verify_run.mjs`'s `PRICING` table ($1.00/$3.00 per 1M input/output tokens). Actual
Qwen billing is very likely lower than the $0.73 shown above, not higher — this does not change the
total-spend-vs-cap conclusion.

**A model-behavior finding that affected token budgeting:** `google/gemini-2.5-flash` spends a
large, *unpredictable* fraction of its output-token budget on internal "thinking" tokens before
emitting the JSON object — observed range ~1,050 to ~4,316 thinking tokens for different photos of
the same 9-criterion item. The harness's `MAX_OUTPUT_TOKENS` was raised from an initial 600 (the
gpt-5.2 script's original value) through 1200 → 2500 → 4500, still truncating some calls, before
settling on 8000, which cleared every case observed except 3 (retried individually at 16000 and
all 3 succeeded).

## Raw outputs (append-only)

- `runs/verifier_gemini25flash_results.jsonl` — 203 lines (200 photos; 3 initial failures at
  8000 tokens, each retried once at 16000 and appended as separate `retry:true` records — the
  analysis below uses the retry record for those 3 photos, not the original failure).
- `runs/verifier_qwen3vl_results.jsonl` — 200 lines, 0 API/parse errors.

Both files were written by `scripts/vercel-gateway-check/decision_0045_verify_run.mjs` (append-only
by construction — refuses to overwrite an existing output path) in bounded synchronous chunks (no
background/async polling used for the run itself), plus `scripts/vercel-gateway-check/retry_failed.mjs`
for the 3 gemini retries.

## Finding 1 — Qwen3-VL systematically fails one archetype (reliability finding, not a content disagreement)

`alibaba/qwen3-vl-235b-a22b-instruct` returned `ok:true` (the API call succeeded, and an empty
array is valid against the loose zod schema) but an **empty or partial `criterion_statuses`**
for **67 of 200 photos (33.5%)** — concentrated entirely in two archetypes:

| Archetype | Empty-response count |
|---|---|
| `continuous_relationship_graph_derived_estimate` (EST) | 53 |
| `continuous_measured_series_supplied_uncertainty` (SER, partial) | 14 |

These calls returned as few as 23 output tokens total, with `rationale: ""` and no criterion
judgments — not a disagreement about what's in the photo, but Qwen declining/failing to produce
any judgment at all for those items (both archetypes carry more criteria — 9 and up to 13 — than
the CAT archetype's 6, and both involve a plotted relationship/derived-estimate task rather than a
simple category comparison; likely related, not confirmed).

**Handling:** these 67 photos are excluded from the agreement/unanimity/discrepancy analysis below
(counting an empty response as "Qwen disagrees with the photo's content" would be misleading — it
never rendered an opinion). This is reported here as a standalone reliability finding about Qwen3-VL
specifically, separate from the content-agreement numbers. Gemini had zero empty/partial responses
across all 200 photos.

**Usable analysis set: 133 / 200 photos** (both verifiers returned a complete, schema-valid
judgment). Full per-model gap detail is in `analysis_summary.json`'s `corpus` block.

## Result 1 — Per-criterion and overall agreement, each verifier vs. the existing (Claude-written) gold

(n = 133 usable photos, 950 total criterion judgments)

| Verifier | Overall per-criterion agreement | Exact-match (all criteria correct) photo rate |
|---|---|---|
| `google/gemini-2.5-flash` | **91.5%** (869/950) | 56.4% (75/133) |
| `alibaba/qwen3-vl-235b-a22b-instruct` | **89.7%** (852/950) | 52.6% (70/133) |

Per-criterion breakdown (both verifiers) is in `analysis_summary.json` →
`verifier_vs_gold.<model>.perCriterion`. Weakest criteria for both verifiers: `UNCERTAINTY_MARKS`
(67–80%), `ZERO_INTERCEPT_ANNOTATION` (33–67%, small n=6), `X_SCALE` (80–90%). Strongest: exact
category/representation-type criteria (95–100%).

## Result 2 — Unanimity rate between the two verifiers (independent of gold)

(n = 133 usable photos, 950 total criterion judgments)

**Overall unanimity: 88.5% (841/950).** Exact-match (all criteria, both verifiers agree)
photo rate: 47.4% (63/133). Per-criterion breakdown in `analysis_summary.json` →
`verifier_vs_verifier_unanimity.perCriterion`.

## Result 3 — Flagged candidate corrections (both verifiers unanimously disagree with gold)

**31 criterion-level flags**, across 26 distinct photos, in `flagged_discrepancies.json`. Per
`DECISION-0045`, these are candidates for human review before any correction is applied — **the
existing gold file was not edited.** Two clear patterns dominate:

- **17 of 31** are `PLOT_VALUES`/`X_SCALE` cases where gold says `not_earned` and both verifiers
  independently say `earned` (e.g. `HDG-2026-P1-SER-012/013/015/016/017/037/042/045/049`,
  `HDG-2026-P1-CAT-004/009/016/017`) — a recoverable-plot-position judgment call where the
  original single-pass gold may have applied a stricter tolerance than two independent models
  converge on.
- **7 of 31** are `UNCERTAINTY_MARKS` cases, split both directions (some gold `earned`→verifiers
  `not_earned`, some gold `unable_to_determine`→verifiers resolving to a definite status) —
  consistent with `UNCERTAINTY_MARKS` also being the weakest-agreeing criterion against gold in
  Result 1, suggesting this criterion's rubric wording or the photos' whisker-mark legibility is
  genuinely borderline rather than a one-sided gold error.

Full list with each flagged item's `gold_rationale`, both verifiers' `rationale`, and file path is
in `flagged_discrepancies.json`. None of these have been applied to the gold file — that requires
a human decision per item (or per pattern, for the `PLOT_VALUES` tolerance cluster), consistent
with `docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/` prior sessions' own
tolerance-clause findings (see `DECISIONS_AND_BLOCKERS.md`).

## What is still outstanding: reader-certification (NOT done here, cannot be done by an AI agent)

`DECISION-0045` part 1 requires a **reader-certified false-accept-rate audit** on top of the
multi-model-verification step this document covers — cold verification of rubric-element presence
by an actual qualified human reader, gated at ≤5% upper-95%-bound FAR to certify. This was
explicitly out of scope for this session (no AI agent can stand in for a qualified human reader).

**Proposed audit-sample package, ready to hand to a reader:**

- **Sample size:** ~100 photos (per `DECISION-0045`'s "~100 answers per set" sizing note),
  stratified across the 4 corpus archetypes (`categorical_comparison_supplied_uncertainty`,
  `continuous_measured_series_supplied_uncertainty`, `continuous_relationship_graph_derived_estimate`,
  and any others present) roughly proportional to their share of the 200-photo corpus, with
  deliberate over-sampling of the weakest-agreement criteria found above (`UNCERTAINTY_MARKS`,
  `X_SCALE`, `ZERO_INTERCEPT_ANNOTATION`) so the audit has power where the automated path is least
  reliable — not just a uniform random draw.
- **Cold format (per `DECISION-0045`):** reader sees the photo + the item's rubric
  (`criterion_id`/`met_rule` only) and marks each criterion element present/absent — **no script
  output, no verifier output, no grader output, no gold label, no route indication.** Never asks
  for a point total or score, only element presence/absence, matching what this pass and the
  original gold pass both did.
- **Scoring:** compare reader labels against the currently-recorded gold label (or, on the 26
  flagged photos above, against whichever of gold/verifier-consensus the human reviewer accepts as
  correct first) to compute a false-accept rate (gold/consensus says `not_earned`, reader says
  `earned`, or vice versa depending on which direction is being certified) with a 95% upper
  confidence bound, gated ≤5% certifies / 5–15% diagnose-and-repilot / >15% rejects per
  `DECISION-0045`.
- **What's missing to run it:** a qualified reader's time (the actual blocking resource per
  `DECISION-0050`'s own rationale for retiring the dual-human-adjudication requirement), and a
  decision on whether the 26 flagged photos above get resolved by the same reader pass or a
  separate, earlier adjudication step before they're folded into the audit sample.

## Files in this directory

- `README.md` — this file.
- `runs/verifier_gemini25flash_results.jsonl` — raw Gemini output, append-only.
- `runs/verifier_qwen3vl_results.jsonl` — raw Qwen output, append-only.
- `analysis_summary.json` — machine-readable version of Results 1–2 plus the corpus/gap counts.
- `flagged_discrepancies.json` — machine-readable version of Result 3 (31 flags).

## Scripts (in `scripts/vercel-gateway-check/`)

- `decision_0045_verify_run.mjs` — runs one verifier model over the corpus (`--model`, `--out`,
  `--skip`, `--limit`); append-only, refuses to overwrite an existing `--out` file at `--skip 0`.
- `retry_failed.mjs` — standalone retry helper for individual failed calls (used for gemini's 3
  parse failures, at a higher token budget).
- `decision_0045_analyze.mjs` — computes Results 1–3 from the two raw JSONL files + the existing
  gold JSON; writes `analysis_summary.json` and `flagged_discrepancies.json`. Re-run any time after
  editing the raw files (it always takes the last record per photo, so retries appended later
  correctly supersede earlier failures).
