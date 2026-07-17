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
| `SP-Kimi-Thinking` | `moonshotai/kimi-k2-thinking` | native | 2000 | 45000 ms | Headline: does reasoning help as a primary grader? |
| `SP-FAST-Kimi` | `moonshotai/kimi-k2` | none | 200 | 8000 ms | Baseline: what does the reasoning buy vs. same-family instruct? |
| `SP-FAST-ESC-Kimi` | `openai/gpt-4o-mini` → `moonshotai/kimi-k2-thinking` | native (escalation only) | 150 / esc 2000 | 4000 ms / esc 45000 ms | Kimi as the selective escalation target (the role gpt-5.5 plays today) |
| `BM-Control` | `openai/gpt-5.5` (medium) | reasoning | 200 | — | Existing control |
| `SP-FAST-Gemini` | `google/gemini-2.5-flash` | off | 150 | 4000 ms | Prior best speed+quality+cost single number |

**`SP-FAST-ESC-Kimi`** is the answer to "what if the reasoning is accurate but
too slow to be speed-first." Fast `gpt-4o-mini` grades every criterion; only
low-confidence / invariant-violating verdicts escalate to `kimi-k2-thinking`,
so the thinking latency and cost are paid on the ~10–20% of criteria that
actually need it while the p50 stays on the fast path. It is identical to the
existing `SP-FAST-ESC` arm except the escalation model is Kimi instead of
gpt-5.5, which required making the escalation `maxOutputTokens` configurable
(new `escalationMaxOutputTokens: 2000` — default stays 200 for every existing
arm) and widening `escalationTimeoutMs` to 45 s so a thinking escalation isn't
silently timed out back to the fast verdict.

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

# 1. Directional run (n=40): all three Kimi arms + the two comparison anchors,
#    same response-ID set. --max-cost-usd caps spend at $10 (the default; shown
#    explicitly here). The estimated cost of this run is ~$1.50, so the cap is a
#    guardrail against a pricing surprise, not an expected stopping point.
node --env-file=.env.local sp1_pilot.mjs \
  --arms SP-Kimi-Thinking,SP-FAST-Kimi,SP-FAST-ESC-Kimi,BM-Control,SP-FAST-Gemini \
  --limit 40 \
  --max-cost-usd 10 \
  --output /tmp/cramapple-grader-kimi/kimi_pilot_2026-07-17.jsonl

# 2. If Directional is encouraging, scale to Decision-Grade (n=100) unchanged.
```

The run is resumable: re-invoking with the same `--output` skips
already-completed `arm:response_id` units.

**Cost cap.** `--max-cost-usd` (default **$10**) is a hard spend ceiling: the
run stops launching new response×arm units once cumulative **estimated** cost
crosses it. Notes:
- Cost is estimated from the harness `PRICING` table. For Kimi that pricing is
  provisional, so the cap is a guardrail against a pricing surprise, not an
  exact billing limit — reconcile against the real gateway invoice.
- It is a *soft* cap: with up to `SP1_CONCURRENCY` (default 10) units in flight,
  a few already-started units finish after the cap trips. Overshoot is bounded
  by that many units — single-digit dollars at these per-FRQ costs.
- Cost already banked in a resumed `--output` file counts against the cap, so a
  restart can't spend the full ceiling again. If a run stops early on the cap,
  re-run the same command with a higher `--max-cost-usd` to finish.
- Set `--max-cost-usd 0` to disable the cap.

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
  worse than the current best single-FRQ path, it is out as a *primary* grader
  under the Speed-first priority regardless of accuracy. That does not kill Kimi
  outright — `SP-FAST-ESC-Kimi` is in this same run precisely to test the
  selective-escalation role, where the thinking cost/latency is paid only on the
  minority of criteria that escalate. Judge that arm on: (a) does escalating to
  Kimi fix the C2 hard-cluster errors the fast-only path misses, and (b) does it
  keep p50 on the fast path (escalation rate near SP-1 §11's expected 10–20%,
  not the 72.5% C2 rate a prior gpt-5.5 escalation arm hit).
- `SP-FAST-Kimi` is evaluated as an ordinary SP-FAST-* provider arm; its only
  special job here is to isolate what the thinking actually buys.

## 9. Scope and Non-Claims

- This is FRQ02-only, single-question. It cannot satisfy any `TASK-0010`
  acceptance criterion; it is input to that task's design.
- It does not open automated FRQ scores to students. `NOW-013` / `TASK-0010`'s
  learner-facing gate is unchanged.
- Until the run is executed with the gateway key and the integrity gate passes,
  this document supports **no** speed, quality, or cost claim about Kimi.
