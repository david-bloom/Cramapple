# AP Biology Kimi Grading Experiment — Pre-Registration and Run Plan

**Status:** Pre-registered; NOT YET RUN. This document is written before the
paid run so results cannot be cherry-picked after the fact. It is a run plan
and hypothesis registration, not a results report or a grading-quality claim.
**Owner:** Main Conductor (Claude) with Product Owner
**Product Owner:** David Bloom
**Prepared:** 2026-07-17
**Protocol inherited:** `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md` (SP-1)
**Reporting standard:** `docs/research/bio_reference_layer_reporting_standard.md`
**Wiring commit:** see branch `claude/cramapple-grading-experiments-9lkjqc`

## 1. Question

Does **Kimi** (Moonshot's `kimi-k2-thinking` reasoning model) grade AP Biology
FRQ criteria well enough to help students — and if so, at what **speed** and
**cost**? The hypothesis under test is that native complex reasoning improves
criterion agreement on exactly the hard, boundary-sensitive cases where the
current fast graders fail (the FRQ02-C2 randomness/attribution cluster,
`S020` / `S028` / `S068`), and the open question is whether it does so without
violating the binding priority order below.

## 2. Priority Order (Binding, inherited from SP-1 §2)

Per the project-wide `[[feedback_grader_priority]]`: **Speed > Quality > Cost**,
up to ~$0.03/FRQ — never trade speed for cost. A Kimi arm that is more accurate
but materially slower than the current best single-FRQ path does **not** win on
quality alone; the speed regression is judged first. Cost is the tiebreaker,
not a gate, below the ~$0.03/FRQ ceiling.

## 3. Arms

Wired into `scripts/vercel-gateway-check/sp1_pilot.mjs`. Both Kimi arms grade
with the model alone — no gpt-5.5 escalation, no misattribution audit — so the
numbers are a clean read on Kimi's own grading, paired against the existing
control and best-provider arms on the identical FRQ02 corpus.

| Arm | Model | Thinking | maxOutputTokens | criterionTimeout | Role |
| --- | --- | --- | --- | --- | --- |
| `SP-Kimi-Thinking` | `moonshotai/kimi-k2-thinking` | native | 2000 | 45000 ms | Headline: does reasoning help? |
| `SP-FAST-Kimi` | `moonshotai/kimi-k2` | none | 200 | 8000 ms | Baseline: what does the reasoning buy vs. same-family instruct? |
| `BM-Control` | `openai/gpt-5.5` (medium) | reasoning | 200 | — | Existing control |
| `SP-FAST-Gemini` | `google/gemini-2.5-flash` | off | 150 | 4000 ms | Prior best speed+quality+cost single number |

**Why the two Kimi-thinking settings differ from every fast arm** (both are
required for the arm to measure something real rather than time out into
garbage):
- `maxOutputTokens: 2000` — a thinking model bills and counts its reasoning as
  output tokens; a 150-token cap truncates it mid-reasoning before it emits the
  JSON verdict.
- `criterionTimeoutMs: 45000` — a thinking pass can take tens of seconds; the
  4–8 s caps tuned for fast models would time out every call and teach us
  nothing about true latency. This bound still catches a genuine hang without
  pre-judging the speed result.

Kimi reasons **natively**, not through the OpenAI `reasoningEffort` knob, so
`reasoningEffort` is intentionally unset on both arms (the harness then attaches
no `openai` provider options).

## 4. Corpus and Pairing

- Corpus: `docs/research/frq02_generated_answer_labels_codex_provisional.jsonl`
  — 100 rows, all `learning_quality_approved` / `use_as_ground_truth: true`.
  This is FRQ02 (AP Biology, single question) only. Everything below is
  therefore single-question evidence — an input to `TASK-0010`, never a
  release claim.
- Selection: `selectCorpus` (deterministic — all 5 ambiguous-cluster IDs
  `S010/S020/S028/S066/S068` plus a strided fill). NOT `random`; the two are
  not comparable distributions and must not be mixed (reporting standard §3).
- Pairing: run all compared arms over the **same** response-ID set. Use
  `--limit 40` for a Directional read or `--limit 100` for Decision-Grade
  (reporting standard §3 read tiers).

## 5. How to Run (needs the gateway key — not present in the web session)

The paid run requires `AI_GATEWAY_API_KEY` (or `VERCEL_OIDC_TOKEN`) in
`scripts/vercel-gateway-check/.env.local`. Kimi has **no** direct-provider
fallback in the harness (only `openai/*` does), so the gateway is mandatory
for these arms.

```bash
cd scripts/vercel-gateway-check
npm install

# 0. Confirm the Kimi gateway slugs are reachable BEFORE spending on the pilot.
#    If either Kimi row errors "unknown model", fix the slug in models.mjs AND
#    in sp1_pilot.mjs (Arms + PRICING), then re-probe.
npm run models

# 1. Directional run (n=40), Kimi arms + the two comparison anchors, same IDs.
node --env-file=.env.local sp1_pilot.mjs \
  --arms SP-Kimi-Thinking,SP-FAST-Kimi,BM-Control,SP-FAST-Gemini \
  --limit 40 \
  --output /tmp/cramapple-grader-kimi/kimi_pilot_2026-07-17.jsonl

# 2. If Directional is encouraging, scale to Decision-Grade (n=100) unchanged.
```

The run is resumable: re-invoking with the same `--output` skips
already-completed `arm:response_id` units.

## 6. Integrity Gate (fill in at run time — reporting standard §4)

Do not trust any metric until every box is checked or listed under Known Issues:

- [ ] Token usage nonzero for ≥1 successful billed row.
- [ ] Cost > $0 for ≥1 successful row.
- [ ] **Kimi pricing reconciled against the actual Vercel AI Gateway Moonshot
      line items.** The `PRICING` entries for `moonshotai/kimi-k2-thinking` and
      `moonshotai/kimi-k2` are **PROVISIONAL** (Moonshot list prices at wiring
      time; the gateway may mark them up). No Kimi cost number may be cited
      until this is done.
- [ ] Timeout rate reported per arm. If `SP-Kimi-Thinking` times out on a
      meaningful fraction even at 45 s, its latency/quality numbers are
      truncated and must be labeled so — a thinking arm that mostly times out
      has *failed the speed gate*, it has not "graded accurately."
- [ ] Same response-ID set across all compared arms (true pairing).
- [ ] p95 computed on ≥20 samples or labeled "single-point".
- [ ] Schema-invalid rows listed by response ID with raw error. Watch this for
      `SP-Kimi-Thinking` specifically: structured `streamObject` output from a
      reasoning model is the most likely failure mode.

## 7. Reporting

On completion, produce `docs/research/apbio_kimi_grading_<date>_report.md`
plus a sibling `summary.json`, using the reporting standard's required tables
(§5.1 per-arm metrics, §5.2 paired changes vs. control, §5.3 claims
supported / not supported). Read tier is set by n-per-arm **before** drafting
the executive summary.

## 8. Pre-registered Success / Kill (directional, to be confirmed at n≥30)

- **Encouraging:** `SP-Kimi-Thinking` fixes ≥2 of the C2 hard-cluster errors
  (`S020/S028/S068`) that `BM-Control` and `SP-FAST-Gemini` get wrong, with
  no new errors in the frozen boundary cluster, at p50 latency within the
  single-FRQ budget.
- **Kill for the fast path:** if `SP-Kimi-Thinking` p50 latency is materially
  worse than the current best single-FRQ path, it is out as a primary grader
  under the Speed-first priority regardless of accuracy — at most a candidate
  for a selective escalation route (the role gpt-5.5 plays today), to be
  registered as a separate follow-up arm, not concluded from this run.
- `SP-FAST-Kimi` is evaluated as an ordinary SP-FAST-* provider arm; its only
  special job here is to isolate what the thinking actually buys.

## 9. Scope and Non-Claims

- This is FRQ02-only, single-question. It cannot satisfy any `TASK-0010`
  acceptance criterion; it is input to that task's design.
- It does not open automated FRQ scores to students. `NOW-013` / `TASK-0010`'s
  learner-facing gate is unchanged.
- Until the run is executed with the gateway key and the integrity gate passes,
  this document supports **no** speed, quality, or cost claim about Kimi.
