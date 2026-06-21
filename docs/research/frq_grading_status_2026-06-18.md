# FRQ Grading Approach: Status Summary

**Date:** 2026-06-18
**Owner:** Product Owner
**Scope:** AP Biology FRQ02 only (single question; 5 other summer-beta FRQs have no labeled corpus yet)
**Status:** Paused for independent code QA (Codex) before any further test run
**Detailed experimental record:** `docs/research/grader_speed_sp1_report.md` and `grader_speed_sp1_summary.json`
**Reporting discipline used throughout:** `docs/research/bio_reference_layer_reporting_standard.md`

This document is the consolidated, current-state summary of everything established today about FRQ grading speed, cost, and quality. It does not replace the detailed report — it's the thing to read first.

**Evidence tier legend** (per the discipline in `bio_reference_layer_reporting_standard.md`), tagged on every finding below:

- **[Decision-Grade]** — n≥30/arm or exhaustive (not sampled), can support a real promote/kill decision per protocol.
- **[Directional, n=40]** — real signal, not yet confirmed at larger scale; treat as a lead, not a conclusion.
- **[Qualitative]** — diagnosed by reading text/reviewer notes directly, not a statistical sample.
- **[Repeated across runs]** — not one sample size, but the same result recurring across many independent runs at different n.

Every finding in this document is **FRQ02-only** unless stated otherwise — none of it generalizes to the other 5 summer-beta FRQs yet, since none have a labeled corpus.

## Findings

### 1. Rubric precision beats architecture complexity `[Directional, n=40]`
The single biggest quality improvement of the entire session came from rewriting the `FRQ02-C2` boundary table, not from any model or routing change. Diagnosing the actual error pattern (a fix meant to stop over-credit had been applied too broadly, causing a *larger* under-credit problem) and rewriting the rubric contract cut `gpt-4o-mini`'s C2 error rate from 40% to 22.5% in one step — bigger than every escalation/routing experiment combined. `gpt-4o-mini` with the fixed boundary table beat `gpt-5.5` medium with no boundary table by 10 points on C2 alone. The lesson generalizes: before reaching for a bigger model, check whether the rubric contract itself is precise enough.

### 2. The misattribution pattern is real, diagnosable, and partially fixable two different ways `[Qualitative diagnosis; audit validated Decision-Grade at n=100 for C2Direct-Low, Directional n=40 for Gemini]`
The recurring C2 failure shape: models attach "random/by chance" to the wrong grammatical target — the resulting allele-frequency *outcome* instead of the construction destruction/survival *event* itself. This was fixed two ways: (a) sharpening the boundary table's language, and (b) building a deterministic dependency-parse checker (`scripts/misattribution-check/checker.py`) that catches it independently of any model, for free.

### 3. Some cases resist every configuration tested `[Repeated across runs — same case, many independent n=40/n=100 runs]`
`S020` has been graded wrong by *every single arm tested this session* — `BM-Control`, every `gpt-4o-mini` variant (both boundary table versions), `gpt-5.5` medium and low via direct routing, parse-first's hard path, `SP-FAST-Gemini`, and `gpt-5.5` medium escalation with no token constraint at all. No model, reasoning effort, or routing strategy has resolved it. Per the original SP-1 protocol's own kill-criteria logic, this points to boundary redesign or Learning Quality adjudication of the label itself — not another architecture experiment. `S028` and `S068` are nearly as stubborn (wrong in most configurations, occasionally fixed by escalation, non-deterministically).

### 4. Some "errors" are likely corpus label inconsistencies, not model failures `[Qualitative]`
`S014`, `S054`, `S058`, `S062`, `S070` use phrasing nearly identical to confirmed-`not_earned` responses, yet are labeled `earned` in `frq02_generated_answer_labels_codex_provisional.jsonl`. Loosening the boundary table to credit them would reopen the original over-credit hole (confirmed by testing). These need a Learning Quality pass on the corpus itself, not a prompt fix.

### 5. Gemini, not the `gpt-5.5`-routing family, is currently the strongest baseline `[Directional, n=40 — NOT yet validated at n=100, unlike C2Direct-Low]`
This was the most consequential thing Codex's independent review surfaced. `SP-FAST-Gemini` (no special C2 handling at all) beat every `gpt-5.5`-routing architecture built this session — `C2Direct`, `C2Direct-Low`, parse-first — on accuracy, cost, *and* speed simultaneously (n=40: 146/160 strict agreement, $0.00141/FRQ, 935ms p50). Most of this session's engineering effort went into optimizing the `gpt-4o-mini`+`gpt-5.5` routing family without first checking whether a different provider already beat the target. Worth remembering for future investigations: check the cheap, simple baseline across all available providers before optimizing one family's routing.

### 6. Parse-first routing works, but only once a real bug was found and fixed `[Directional, n=40]`
Running the misattribution parser *before* any model call to choose `gpt-4o-mini` vs `gpt-5.5` for C2 ties `C2Direct-Low` on speed and C2 accuracy while cutting cost 61% — but only after fixing a bug where the fast path kept an old confidence-based escalation threshold active, causing 68% of "fast" calls to redundantly re-escalate anyway. First attempt was *slower* than the baseline it was meant to improve on; the fix flipped that.

### 7. The misattribution audit is a validated, zero-marginal-cost safety net — with a real latency cost when it fires `[Directional, n=40 live run; Decision-Grade n=100 for the offline-join validation]`
Run live end-to-end for the first time today (previous validations were offline joins). Catches the over-credit error class that confidence-based escalation structurally cannot (a confidently-wrong model never self-flags). But the escalation step itself is not free: when it fires (~10% of C2 calls), it adds 8–11 seconds, and that's not a bug — it's the direct cost of giving `gpt-5.5` enough reasoning budget to actually finish (a separate bug found and fixed today: the escalation call was capped at 200 tokens; `S020` alone needs 493 reasoning tokens before it can emit any JSON).

### 8. The latency tail is structural and fully explained, not noise `[Directional, n=40 — but the within-run correlation (4/4) is exact, not a sampling claim]`
At n=40 with the audit live, p95 (8,142ms) is not an artifact — it's exactly the 4 audit-escalated responses, 100% correlation. Full percentile shape: p50=965ms, p60=1,108ms, p70=1,753ms, p80=2,173ms, p90=4,115ms, p95=8,142ms, p100=11,105ms. Practical read for UX: ~80% of students see ≤2.2s, ~10% see 4s+ (ordinary per-criterion escalation), and ~10% see 8–11s (audit escalation specifically). This needs an explicit product decision: is the rare 8–11s wait acceptable for the correctness it buys, or does the escalation call need its own latency mitigation?

### 9. Sentiment/hedge-detection investigation: negative finding, worth keeping so it isn't redone `[Decision-Grade — exhaustive scan of the full 100-response corpus, not sampled]`
Checked whether broadening hedge detection (beyond the narrow "not necessarily" pattern) would catch more ambiguity. It would not — 18 of 22 responses with a generic hedge word (`might`, `likely`, `probably`) are correctly `earned`; the hedge word modifies an unrelated claim elsewhere in the response. Broadening would create many false alarms for zero new catches. The narrow, already-built hedge list is correctly scoped; no further work needed here.

### 10. Full-scale (n=100) validation confirms the n=40 results aren't noise `[Decision-Grade, n=100 — the strongest evidence tier in this entire investigation]`
`C2Direct-Low` ties `BM-Control` exactly on accuracy (88.8% both) at the full available FRQ02 corpus, while running ~2.7x faster and ~2.5x cheaper. This is the strongest evidence in the investigation that the architecture changes are real, not small-sample artifacts.

### 11. Strategic direction (not yet built): MCQ and multi-subject grading need different verification approaches `[Qualitative / strategic — not empirical]`
Captured as forward-looking project memory, not yet actioned: MCQ grading should be a free local lookup table (no model, no rubric-boundary problem at all) — none of this session's machinery applies. Multi-subject expansion should differentiate verification technique by subject (e.g., symbolic math for Calculus, a misattribution-style structural check for History causation claims), with the AI Gateway as the infrastructure that makes per-subject/content-type routing cheap rather than a maintenance burden. This is consistent with, not separate from, what's already specified in `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7–9.

## No Production Candidate Yet — Two Different Things Not to Conflate

Raised directly by Codex's review of this document: it's easy to read "ties baseline at 2.7x faster, 2.5x cheaper" next to "Gemini is the strongest baseline" and assume one of them is *the* recommendation. Neither is. Nothing in this investigation has cleared SP-1's own §14 production-promotion gates (single FRQ, proxy ambiguity tagging, no real grading-service instrumentation — see Open Items). These are two different claims, deliberately not merged:

- **Most-validated architecture: `SP-FAST-ESC-C2Direct-Low`.** `[Decision-Grade, n=100]` Ties `BM-Control` exactly on accuracy while running ~2.7x faster and ~2.5x cheaper. This is the only architecture in this entire investigation tested at full scale.
- **Strongest single number found: `SP-FAST-Gemini`.** `[Directional, n=40 only]` Beats `C2Direct-Low` on accuracy, cost, and speed simultaneously — but has never been run at n=100, and the misattribution audit has only been tested against it once, live, at n=40.

If a production decision were needed today, `C2Direct-Low` is the only candidate with decision-grade evidence behind it. Gemini is the more promising lead but is one rigor tier behind — the next experiment this investigation should run, not a result to act on yet.

## Technical Updates

**New code, built this session:**
- `scripts/vercel-gateway-check/sp1_pilot.mjs` — the grading harness. Started from a constrained pilot script and grew to 10+ arms: `BM-Control`, `SP-1` family, `SP-FAST` family, `SP-FAST-ESC-C2Direct`, `-C2Direct-Low`, `-C2ParseFirst`, `SP-FAST-Haiku`, `SP-FAST-Gemini`.
- `scripts/misattribution-check/checker.py` — deterministic spaCy dependency-parse audit for the C2 misattribution pattern. Runs in a dedicated Python 3.12 venv (system Python was too old for current spaCy).
- `scripts/vercel-gateway-check/misattribution_bridge.mjs` — persistent Node↔Python worker bridge (spaCy model loads once, not per-check), FIFO request/response matching verified under concurrency.
- `docs/research/bio_reference_layer_reporting_standard.md` — the run-metadata/integrity-gate/read-tier discipline used for every report this session.

**Bugs found and fixed (all found via live testing, not code review — this is the direct motivation for the current QA pause):**
1. Prefilter used per-criterion keyword lists as an off-topic check, which acted as an insufficient-wording filter the protocol explicitly prohibits — fixed with a single broad FRQ-level vocabulary check.
2. Escalation trigger used a flat `confidence < 0.7` threshold that almost never fired (`gpt-4o-mini`'s confidence never dropped below 0.8 on this corpus) — replaced with per-criterion thresholds.
3. Gemini 2.5 Flash defaults to hidden "thinking" tokens, breaking structured output at any reasonable token cap — fixed via `thinkingConfig.thinkingBudget: 0`.
4. T6 latency instrumentation double-counted call time due to a misplaced timer — fixed.
5. Boundary table v1's over-credit fix was applied too broadly, causing systematic under-credit — rewritten (v2).
6. Within v2, `"selection"` matched negated "natural selection," and `"event"` caused cross-sentence false positives in the misattribution checker — both found and fixed via corpus testing.
7. Parse-first's fast path kept the old high-risk confidence escalation threshold active, causing most "fast" calls to redundantly re-escalate — fixed by disabling escalation on that path entirely.
8. Misattribution audit's escalation call was capped at 200 tokens (inherited from routine routing config) — far too tight for the hardest cases, which need up to ~500+ reasoning tokens. Raised to 1,000.
9. Audit's escalation call had no bounded retry, unlike the primary path — added.
10. Schema-consistency drift: a new output field (`audit_escalation_retried`) was missing its default value on the prefilter early-return code path.
11. **Found via Codex QA, not live testing:** `withTimeout` was called on an already-`await`-ed result, not the live call promise — `Promise.resolve(x)` always resolves before any positive-duration timeout, so the race could never actually time out. Every arm sets `criterionTimeoutMs`, meaning no timeout had fired in any run this entire session. Fixed by racing the call's own promise before awaiting it.

**Infrastructure:**
- Found and flagged a live OpenAI API key stored in plaintext in `~/.zshrc` — rotation requested, `.env`/`.vercel`/`.venv` added to `.gitignore`.
- Vercel AI Gateway access via `vercel link` + `vercel env pull`, using OIDC auth (`VERCEL_OIDC_TOKEN`), not a static API key.

## Open Items

**Immediate:**
- **Codex QA pass complete (2026-06-18), findings addressed:**
  - **Fixed:** `withTimeout` was racing an already-resolved value, not the live call — `criterionTimeoutMs`/`escalationTimeoutMs` had never actually bounded a call in any run this session (every arm sets one). Now races the real in-flight promise.
  - **Fixed:** `.gitignore`'s `.env.*`/`.env*` rules would have also hidden committed template files like `.env.example` — narrowed to `.env.local`/`.env.*.local`.
  - **Clarified, not a bug:** the "arm config fields never defined" finding was reviewing `next_protocol.mjs` (Codex's own earlier, simpler script from before this investigation), not `sp1_pilot.mjs` (where `escalates`/`criterionOverrides`/`parseFirstRouting`/`misattributionAudit` are actually implemented and configured per-arm).
  - **Still open, real policy question, not yet decided:** `checker.py`'s `any_qualifying` is true if *any* sentence in a response qualifies, with no check for a contradicting sentence elsewhere in the same response. One concrete instance of this exact failure mode was found and fixed (the `"event"` lemma bug), but the underlying policy — "any qualifying sentence anywhere earns" — hasn't been stress-tested against genuinely mixed/contradictory responses, only against the one case that surfaced it. Needs an explicit decision before being treated as settled.
  - Re-flagged for a fresh look, not yet re-reviewed: `applyMisattributionAudit`'s retry/cost-summing logic, and the unverified three-way interaction between `criterionOverrides`/`parseFirstRouting`/`misattributionAudit` (no arm currently combines all three).

**Not yet built or tested:**
- A combined design: parse-first routing *and* a post-hoc audit that checks both paths' outputs (not just fast-path `earned` verdicts) — motivated by the finding that parse-first's hard path is only 50% accurate on its own.
- The same error-vs-reviewer-note diagnostic that found C2's boundary-table bug, applied to `FRQ02-C1`, `C3`, `C4` — not yet investigated at all.
- `SP-FAST-Gemini` validated at n=100 — only validated at n=40 so far, unlike `C2Direct-Low`.
- The misattribution audit tested against `C2Direct`/`C2Direct-Low`'s `gpt-5.5`-routed verdicts using the corrected 1,000-token escalation budget — the original full-scale audit validation (catching `S020`/`S028` "100%") predates this fix and should be re-confirmed.

**Needs people, not more engineering:**
- `S020` (and to a lesser extent `S028`, `S068`) need Learning Quality adjudication — no tested model/architecture combination has resolved them.
- The suspected corpus label inconsistencies (`S014`, `S054`, `S058`, `S062`, `S070`) need a Learning Quality review pass on the labels themselves.
- An explicit product decision on the audit's latency tradeoff: is an 8–11s wait on ~10% of responses acceptable for the correctness it buys?

**Structural gaps that remain regardless of further experimentation:**
- Still single-FRQ (FRQ02 only) — the other 5 summer-beta FRQs have no labeled corpus, so no cross-FRQ generalization claim is possible yet.
- No real grading-service T1–T6 instrumentation — every latency number this session comes from a script-level harness, not the production path.
- TTFD (time-to-first-decision-token) was never separately instrumented from general TTFB.
- Ambiguity tagging remains a 5-response proxy, not frozen Learning Quality review at the criterion level.
- None of this satisfies SP-1's own §14 production-promotion gates yet — that was true at the start of the session and remains true now; what's changed is how much closer and better-understood the gap is.
