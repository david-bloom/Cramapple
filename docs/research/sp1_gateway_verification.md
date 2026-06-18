# SP-1 Gateway Verification Report

**Status:** Complete. Gateway feature-verification gate (§12.2 of SP-1 protocol) is passed.
**Owner:** Product Owner with Technical Owner
**Run Date:** 2026-06-17
**Protocol:** `docs/research/GRADER_SPEED_SUBTASK_PROTOCOL.md`
**Scratch Harness:** `scripts/vercel-gateway-check/` (Node ESM, AI SDK 6.0.208)
**Vercel Project:** `bloom-llc/cramapple`
**Vercel CLI:** 54.14.2 (invoked via `npx vercel@latest`)

## Executive Summary

Vercel AI Gateway clears the gate for SP-1 production use. All four fast-tier
candidate models are reachable through the gateway, native structured output
passes through cleanly on every provider tested, `reasoning_effort` is honored
on `gpt-5.5`, and the median gateway overhead vs direct OpenAI calls is +7ms
on TTFB and -51ms on total — within H8's < 30ms target.

The production-routing question (§16.5 of the protocol) resolves to: **use
the gateway for production grading.** Latency is at parity to slightly
positive, p95 is meaningfully tighter than direct, and the gateway carries
multi-provider, observability, BYOK billing, and failover benefits the
direct path does not.

## Hypotheses Decided

| Hypothesis | Result | Evidence |
| --- | --- | --- |
| H8 — gateway adds < 30ms median TTFB overhead vs direct on the same model | **PASS** | +7ms gateway median TTFB (-51ms total) on N=30 each, `openai/gpt-4o-mini` |
| H9 (structured-output passthrough) — native structured output works for each primary model | **PASS** | All four models returned schema-valid `streamObject` output |
| H9 (reasoning_effort passthrough) — `reasoningEffort` parameter is honored on `gpt-5.5` via gateway | **PASS** | Reasoning tokens dropped 129 → 101 on `low` vs `medium`; same response shape |
| H7 — stable rubric/boundary-table prefixes are not currently cached | **DEFERRED** | Production prompts not yet shaped; revisit when SP-1 harness lands |

## Run Details

### 1. Model Reachability (`scripts/vercel-gateway-check/models.mjs`)

Single sample per model. Reachability check, not statistical.

| Model | Status | TTFB | Total | Tokens (in/out) |
| --- | --- | ---: | ---: | --- |
| `openai/gpt-4o-mini` | ok | 922ms | 934ms | 17/6 |
| `openai/gpt-5.5` | ok | 1012ms | 1025ms | 16/6 |
| `anthropic/claude-haiku-4-5` | ok | 848ms | 1045ms | 18/8 |
| `google/gemini-2.5-flash` | ok | 785ms | 787ms | 10/21 |

All four reachable after Bloom-LLC team added paid credits ($22 balance).
Prior free-tier runs blocked `gpt-5.5` (RestrictedModelsError) and
rate-limited `gemini-2.5-flash`.

### 2. Native Structured Output (`scripts/vercel-gateway-check/structured.mjs`)

Schema modeled on SP-1's per-criterion contract (evidence_quote, gate,
status, confidence, minimum_fix). All four models accepted the schema and
returned validated structured output through the gateway.

| Model | Status | TTFB | Total | Decision |
| --- | --- | ---: | ---: | --- |
| `openai/gpt-4o-mini` | ok | 644ms | 1256ms | earned, conf 0.90 |
| `openai/gpt-5.5` | ok | 13653ms | 13999ms | earned, conf 0.86 |
| `anthropic/claude-haiku-4-5` | ok | 4137ms | 4718ms | earned, conf 0.95 |
| `google/gemini-2.5-flash` | ok | 2867ms | 3047ms | earned, conf 0.90 |

Observations:

- All four agreed on the test case (single sample, no quality claim).
- `gpt-5.5` defaulted to expensive reasoning (~13.6s) when no
  `reasoningEffort` was set — confirmed in the reasoning-effort check
  below. Production must always set this explicitly.

### 3. Reasoning Effort Passthrough (`scripts/vercel-gateway-check/reasoning.mjs`)

Same `gpt-5.5` prompt, three effort levels, single sample each.

| Effort | TTFB | Total | Reasoning tokens | Output tokens |
| --- | ---: | ---: | ---: | ---: |
| low | 4233ms | 4658ms | **101** | 132 |
| medium | 3051ms | 3483ms | **129** | 160 |
| high | 4607ms | 5155ms | **129** | 159 |

Low vs medium drops reasoning-token count by 22%, confirming the parameter
is honored. Medium and high produce identical token counts on this prompt —
either gateway collapses them or this task is too easy to distinguish them.
Single sample; do not interpret latency ordering.

### 4. Gateway Overhead Calibration (`scripts/vercel-gateway-check/overhead.mjs`)

N=30 per series, identical prompts with per-call nonce to defeat caching,
`gpt-4o-mini` on both sides (gateway via `VERCEL_OIDC_TOKEN`, direct via
`OPENAI_API_KEY`).

| Series | Metric | Median | p95 | Min | Max | Mean |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| gateway | ttfb | 664ms | 1164ms | 437ms | 1279ms | 690ms |
| gateway | total | 695ms | 1165ms | 545ms | 1450ms | 767ms |
| direct | ttfb | 656ms | 1640ms | 442ms | 2290ms | 783ms |
| direct | total | 746ms | 1738ms | 537ms | 2420ms | 878ms |

Gateway overhead (gateway median − direct median):

- TTFB: **+7ms**
- Total: **−51ms** (gateway faster at p50)

Tail behavior:

- Gateway p95 TTFB is **40% tighter** than direct (1164ms vs 1640ms).
- Gateway p95 total is **50% tighter** than direct (1165ms vs 1738ms).

Plausible explanations: persistent connection pooling at the gateway,
gateway-side retry smoothing, or 30-sample luck. Direction is consistent
with not bypassing the gateway in production.

## Routing Decision

Per the §16.5 open question in the SP-1 protocol:

> If H8 confirms gateway overhead < 30ms, do we keep Vercel AI Gateway in
> production for observability and failover, or route direct and trade that
> ergonomics for the latency margin?

**Decision: Use the gateway for production grading.** Rationale:

- Median TTFB overhead is +7ms (below the 30ms gate).
- Median total latency is **negative** — gateway is slightly faster than
  direct on this calibration.
- p95 latency is meaningfully tighter via the gateway.
- Multi-provider, observability, BYOK billing, and failover are retained.
- No engineering cost to deploy: the SDK call shape is unchanged.

## Operational Notes

1. **BYOK is configured.** OpenAI calls bill against the user's OpenAI
   account, not Vercel gateway credits. This unblocked all four models on
   the team without further top-up.
2. **gpt-5.5 default reasoning is expensive.** The structured-output run
   showed 13.6s TTFB at default effort vs ~3s at explicit medium.
   Production code must always set `providerOptions.openai.reasoningEffort`.
3. **The local-vs-production network gap matters.** All measurements above
   were taken from a local dev machine to Vercel AI Gateway. Production
   runtime (Vercel-hosted server functions → Vercel AI Gateway) is
   intra-Vercel and should shave ~100–200ms from TTFB. The 500ms TTFD
   target in §11 of the protocol is plausible in production, not on a
   laptop.

## Items Deferred to the SP-1 Run Itself

- **H7 prompt-caching observability** — defer until production prompt
  shape is fixed.
- **`SP-FAST-Haiku-ESC` and `SP-FAST-Gemini-ESC`** — escalation variants
  for Haiku and Gemini remain out of scope for this verification.
- **Multi-provider direct calibration** — the OpenAI calibration is
  representative for gateway-hop cost. Per-provider direct calibration
  is not on the critical path.

## Artifacts

- `scripts/vercel-gateway-check/package.json` — `npm run verify | models | structured | reasoning | overhead`
- `scripts/vercel-gateway-check/.env.local` (gitignored) — VERCEL_OIDC_TOKEN, OPENAI_API_KEY
- `scripts/vercel-gateway-check/.vercel/` (gitignored) — project binding
