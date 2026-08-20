# DECISION-0045 gold-verification pass — AP Statistics real-photo corpus — 2026-08-19

**Trigger:** same `DECISION-0050` un-deferral of `DECISION-0045` Set C that produced
`docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/`
for the Biology corpus. This directory is the equivalent pass for the AP Statistics real-photo
corpus, run against `../gold/apstats_smoke_gold_labels_2026_08_19.json` (28 photos — the "tier 2"
/ full real-photo corpus for this subject, confirmed by cross-checking the smoke-test README's
"Tier 2 (n=28, all real Stats photos)" section and counting the gold file: 28 records, all with a
`file_path` under `docs/hand drawn samples/Stats-HRD-2/`).

**The existing gold file was NOT modified.** This directory only adds new files (this README, two
raw per-model output JSONL files, an analysis summary, and a flagged-discrepancy list).

## Writer-independence check (done first, per the task's instruction not to assume from README prose alone)

Before picking verifiers, confirmed the Statistics gold's writer family the same way the task
asked — by checking the raw gold file and the grading-method doc, not just the smoke-test README's
summary line.

- The gold file itself (`apstats_smoke_gold_labels_2026_08_19.json`) carries no explicit
  `writer_model` field, so it can't be confirmed from the file alone.
- The smoke-test README states the gold was built "same method used for the Biology 200-photo
  gold," citing `docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`'s "Grade them
  yourself first" section.
- Read that section directly: it describes the Biology gold as built by "20 independent grading
  passes (one Agent-tool call per 10-photo batch) each visually inspected one photo at a time" —
  i.e. the acting Claude-Code (Anthropic) agent session visually inspecting each photo and writing
  labels directly, not a call to any OpenAI model. This is a **human-directed, Claude/Anthropic-
  executed** labeling process, structurally identical for both corpora.
- Nothing in the raw Statistics gold file or the smoke README contradicts this — every mention of
  `openai/gpt-5.2` and `anthropic/claude-sonnet-4.5` in that README is about *grader* runs being
  scored *against* the gold, never about how the gold itself was produced.

**Conclusion: the Statistics gold's writer family is Anthropic, same as Biology's.** The
independence constraint therefore resolves the same way: Anthropic is "consumed" as the writer and
cannot also verify; OpenAI (`gpt-5.2`) is the grader under test and is excluded too. This confirms
the task's default expectation — no need to stop and report a different-family writer.

## Independence constraint and model selection (reused, not re-derived)

Per `DECISION-0045` and the same reasoning already validated for Biology: two independent,
non-OpenAI, non-Anthropic model families are required. Reused the **already-validated verifier
pair** from the Biology pass without re-probing anything:

- `google/gemini-2.5-flash` (Google)
- `alibaba/qwen3-vl-235b-a22b-instruct` (Alibaba)

Per the task's explicit instruction, `moonshotai/kimi-k2`/`kimi-k2-thinking` were **not**
re-probed on this corpus — the Biology run already established both are unusable (no vision
support for the base model behind this gateway route; unreliable/hanging structured output for
the thinking variant), and that is a property of the models via this gateway, not of the Biology
photo set, so it generalizes to this corpus too.

## Blind verification protocol

Identical in shape to the Biology pass. Each verifier call's prompt (`buildPrompt()` in
`scripts/vercel-gateway-check/decision_0045_verify_run_apstats.mjs`, adapted from
`decision_0045_verify_run.mjs`) contains only: `item_id`, `archetype`, the item's `student_prompt`,
and the rubric's `criterion_id`/`met_rule` pairs, read from
`docs/research/apstats_hdg_graph_corpus_2026_08_18/apstats_hdg_graph_questions_2026_08_18.jsonl`
(confirmed present, 40 items, correct shape — `item_id`, `archetype`, `student_prompt`,
`criterion_definitions[]`, `display_table`, `expected_graph_spec`, matching what the script
expects). Verifiers were never shown: the existing gold's `criterion_statuses`, each other's
output, or any `gpt-5.2` grading output. The output schema
(`criterion_statuses[]` with `earned`/`not_earned`/`unable_to_determine`, plus `confidence` and
`rationale`) matches the Biology verify script's schema exactly, so results are directly
comparable in shape (not compared cross-corpus numerically here).

One structural simplification versus the Biology script: the Statistics gold file already carries
one record per photo with an explicit absolute `file_path` (no filename-pattern photo discovery
needed, since there's no multi-packet/multi-response-per-item structure here) — the adapted script
iterates the gold file directly and joins to the corpus JSONL by `item_id` for prompt/rubric
content.

## Cost discipline and actual spend

Ran one validation call per model first (`--limit 2`), as required, before scaling to the full
corpus:

| Item | Calls | Cost |
|---|---|---|
| Validation probes (2 photos × 2 models) | 4 | $0.0152 |
| `google/gemini-2.5-flash` full run (28 photos, 0 errors) | 28 | $0.1497 |
| `alibaba/qwen3-vl-235b-a22b-instruct` full run (28 photos, 0 errors) | 28 | $0.0997 |
| **Total** | **60** | **~$0.2646** |

Well under the $3 autonomous cap for this task (and under the $0.30–0.50 pre-run projection). No
approval checkpoint was needed. Qwen's per-call cost uses the same deliberately conservative
placeholder pricing table carried over from the Biology script (no gateway-reported cost field for
this model), so actual Qwen billing is likely somewhat lower than shown.

**No reliability issue this time**: unlike the Biology run, where Qwen returned empty judgments for
33.5% of photos (concentrated in two archetypes), **both verifiers returned a complete,
schema-valid judgment for all 28/28 photos** on this corpus. Usable analysis set: 28/28 photos, no
exclusions.

## Raw outputs (append-only)

- `runs/verifier_gemini25flash_results.jsonl` — 28 lines, 0 errors, 28/28 schema-valid.
- `runs/verifier_qwen3vl_results.jsonl` — 28 lines, 0 errors, 28/28 schema-valid.

Both written by `scripts/vercel-gateway-check/decision_0045_verify_run_apstats.mjs` in bounded
synchronous chunks (no background/async polling used for the run itself — each full-corpus run was
launched as a single blocking call and waited out with a synchronous polling loop on the output
file's line count, never the Monitor tool, per the task's explicit process instruction).

## Result 1 — Per-criterion and overall agreement, each verifier vs. the existing (Claude-written) gold

(n = 28 usable photos, 112 total criterion judgments — 4 criteria/photo average across archetypes)

| Verifier | Overall per-criterion agreement | Exact-match (all criteria correct) photo rate |
|---|---|---|
| `google/gemini-2.5-flash` | **87.5%** (98/112) | 60.7% (17/28) |
| `alibaba/qwen3-vl-235b-a22b-instruct` | **72.3%** (81/112) | 28.6% (8/28) |

Gemini agrees with gold noticeably more than Qwen does on this corpus — a wider gap than Biology's
(91.5% vs 89.7%). Full per-criterion breakdown is in `analysis_summary.json` →
`verifier_vs_gold.<model>.perCriterion`. Weakest criteria: `POINTS_PLOTTED` (Gemini 40%, Qwen 0%),
`ASSOCIATION_DESCRIPTION` (Gemini 40%, Qwen 100% — a large split, see below),
`HEIGHTS_BY_CONDITIONAL_PROPORTION` (Qwen 0%, Gemini 80%), `RELATIVE_FREQUENCIES` (Qwen 40%, Gemini
60%), `WIDTHS_BY_TOTAL` (Qwen 20%, Gemini 100% — Qwen specifically struggles with the mosaic-plot
proportional-width judgment that this program's own gpt-5.2 investigation already found hard).
Strongest for both: `AXIS_LABELS`, `AXIS_SCALE`, `AXIS_SCALE_LABELS`, `X_LOCATION`,
`CATEGORY_LABELS`, `BOXPLOT_SCALE`, `CENTER_COMPARISON`, `SEGMENT_LABELS` (100% both).

## Result 2 — Unanimity rate between the two verifiers (independent of gold)

(n = 28 usable photos, 112 total criterion judgments)

**Overall unanimity: 71.4% (80/112).** Exact-match (all criteria, both verifiers agree) photo
rate: 32.1% (9/28) — noticeably lower than Biology's 88.5%/47.4%. The gap is concentrated in a
handful of criteria where the two verifiers diverge sharply from each other, not just from gold:
`WIDTHS_BY_TOTAL` (20%), `RELATIVE_FREQUENCIES` (20%), `HEIGHTS_BY_CONDITIONAL_PROPORTION` (20%),
`ASSOCIATION_DESCRIPTION` (40%), `SEGMENTED_BARS` (40%), `TREND_LINE` (60%), `POINTS_PLOTTED`
(60%). These cluster heavily in the mosaic-plot (`WIDTHS_BY_TOTAL`, `HEIGHTS_BY_CONDITIONAL_
PROPORTION`, `RELATIVE_FREQUENCIES`, `SEGMENTED_BARS`, `AREA_OR_COUNT_REASONING`) and
scatterplot/dotplot (`POINTS_PLOTTED`, `TREND_LINE`, `ASSOCIATION_DESCRIPTION`, `DOT_COUNTS`)
archetypes — the same two archetype families this program's earlier gpt-5.2 smoke-test work
already flagged as its hardest (mosaic self-contradiction defect, scatterplot idealized-line
pattern). Full per-criterion breakdown in `analysis_summary.json` →
`verifier_vs_verifier_unanimity.perCriterion`.

## Result 3 — Flagged candidate corrections (both verifiers unanimously disagree with gold)

**6 criterion-level flags**, across 6 distinct photos, in `flagged_discrepancies.json`. Per
`DECISION-0045`, these are candidates for human review before any correction is applied — **the
existing gold file was not edited.** Two patterns, both already anticipated by this program's own
prior single-model (gpt-5.2) work on this same corpus:

- **3 of 6** are `POINTS_PLOTTED` cases on the scatterplot archetype (`GRAPH-032`, `GRAPH-035`,
  `GRAPH-036`) where gold says `not_earned` (because the drawn points form a smooth idealized
  monotonic line rather than reproducing the supplied table's genuine non-monotonic bump/dip) and
  **both independent verifiers say `earned`** — this is exactly the "scatterplot point-idealization"
  pattern the smoke-test README already documented as a real, consistent authoring pattern across
  this archetype's photos, where the smoke test's own `gpt-5.2` runs sided with gold's strict
  reading every time. Here, two independent non-OpenAI/non-Anthropic verifiers side with the
  *lenient* reading instead — a genuine three-way split (gold + gpt-5.2 strict; Gemini + Qwen
  lenient) worth a human governance call on whether "recoverable locations" should tolerate a
  idealized/smoothed line when it's still monotonic in the right direction, rather than requiring
  the specific non-monotonic wiggle to be reproduced.
- **2 of 6** touch the mosaic-plot / boxplot archetypes in the *opposite* direction — gold `earned`,
  both verifiers `not_earned`: `GRAPH-023 HEIGHTS_BY_CONDITIONAL_PROPORTION` (the same photo whose
  `WIDTHS_BY_TOTAL` was already flagged in the smoke-test README as the one genuinely-harder,
  noisy case — Bike's totals sum to 80 not 100, a real subtler visual call) and `GRAPH-013
  FIVE_NUMBER_VALUES` (both verifiers claim the drawn boxplot positions don't match the five-number
  summary; gold's rationale says they "plausibly match" — a spatial-tolerance judgment call, not a
  clear-cut error either direction).
- **1 of 6** is `GRAPH-014 VARIABILITY_COMPARISON`, gold `not_earned` → both verifiers `earned` —
  this is the same item the smoke-test README already flagged as a "legitimate grading-strictness
  dispute, not a clear defect" (garbled-but-directionally-correct numbers) when comparing
  `gpt-5.2` grader runs; two independent verifiers now also lean lenient on it, adding weight to
  the "dispute, not defect" read from that earlier finding.

Full list with each flagged item's `gold_rationale`, both verifiers' `rationale`, and file path is
in `flagged_discrepancies.json`. None of these have been applied to the gold file — that requires
a human decision per item, consistent with how the Biology verification pass and this program's
own prior Statistics tolerance-clause experiments both treated flagged disagreements.

## What is still outstanding: reader-certification (same caveat as Biology, not addressed here)

As with the Biology pass, `DECISION-0045` part 1's reader-certified false-accept-rate audit
(cold visual-inspection by a qualified human, ≤5% upper-95%-bound FAR to certify) is out of scope
for this AI-agent session and was not attempted. This pass only covers the multi-model-verification
step. Given the Statistics corpus is small (28 photos total), a reader audit here would likely need
to cover most or all of the corpus rather than a stratified sample, unlike Biology's 200-photo
corpus where a ~100-photo stratified sample was proposed.

## Files in this directory

- `README.md` — this file.
- `runs/verifier_gemini25flash_results.jsonl` — raw Gemini output, 28 lines.
- `runs/verifier_qwen3vl_results.jsonl` — raw Qwen output, 28 lines.
- `analysis_summary.json` — machine-readable version of Results 1–2 plus the corpus/gap counts.
- `flagged_discrepancies.json` — machine-readable version of Result 3 (6 flags).

## Scripts (in `scripts/vercel-gateway-check/`)

- `decision_0045_verify_run_apstats.mjs` — runs one verifier model over the 28-photo AP Statistics
  gold corpus (`--model`, `--out`, `--skip`, `--limit`); adapted from `decision_0045_verify_run.mjs`
  (the Biology version) — same prompt/schema shape, simplified photo discovery (reads directly from
  the gold file's `file_path` field instead of filename-pattern scanning, since this corpus has one
  photo per gold record already).
- `decision_0045_analyze_apstats.mjs` — computes Results 1–3 from the two raw JSONL files + the
  existing gold JSON; writes `analysis_summary.json` and `flagged_discrepancies.json`. Adapted from
  `decision_0045_analyze.mjs` with the same latest-record-wins/usable-photo logic (no retries were
  needed on this corpus — both models were 0-error, 28/28 schema-valid on the first pass).
