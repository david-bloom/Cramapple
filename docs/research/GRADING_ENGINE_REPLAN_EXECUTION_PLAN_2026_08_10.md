# Grading-engine replan — executable plan

**Date:** 2026-08-10
**Status:** DRAFT — awaiting owner approval of the decision points marked `O#`.
**Origin:** second-opinion review of the exemplar pilot + gold-set project (see
`prompts/FABLE_EXEMPLAR_PILOT_AND_GOLD_SET_SECOND_OPINION_2026_08_10.md` and the
2026-08-10 review session). Sequencing rationale: free re-analysis first (it
defines the keys and fixes the measuring instrument), one deploy bundle carrying
fix + instrumentation second (telemetry accrues with time and the paid runs then
emit it for free), paid runs third against the fixed system, synthesis last.
**Priority frame:** Quality > Speed > Cost. Aspirational bar: 95% confidence,
<1 s, <$0.01. Grading is 100% automated — no human-in-the-loop paths anywhere
in this plan.
**Estimated total model spend:** ~$3–5. Everything else is engineering time.

---

## Step 1 — Free re-analysis + tooling fixes (no model spend; Production access read-only)

### 1.1 Deterministic-key invariant harness — *the fix is a failing test*

Build `scripts/grading-model-assessment/verify_deterministic_keys.ts` (Deno, no
network for the answer side):

- For every `STATISTICS_TARGETS` entry in
  `supabase/functions/_shared/statistics-verifier.ts`, run
  `checkStatisticsDeterministicEvidence` against:
  - the item's live `canonical_answer_1` (one read-only Production fetch,
    snapshot into a fixture with `content_hash`),
  - every repo gold-set answer for that item whose script marks the numeric
    element **present** (A1/A2 and applicable accepts from
    `scripts/content-seed/gold-set/*.jsonl`) → all must `pass`,
  - every gold answer whose script marks the numeric element **absent**
    (A3/A4/A8) → must `flag`.
- Report per-entry pass/fail + sensitivity/specificity. Expected first result:
  `APSTATS-SFRQ-008` fails (keyed `[1.8, 4.9]` vs true −1.40 / 4.48); the open
  question is the other 17 statistics entries and the other subjects' profiles.
- Derive corrected values for every failing entry **from the canonical answer,
  recomputed** (Phase B `validate_keys.py` pattern — derive, never transcribe),
  and record the source `content_hash` per entry.
- Wire into `deno test` so it runs with the existing 56-test suite forever.

**Deliverable:** audit table (entry → pass/fail → corrected value + provenance)
and the harness as a standing test. → **O1: owner approves the corrected key
set before anything deploys** (the original defect was unreviewed keys; do not
repeat it).

### 1.2 Assessment-harness repairs (the measuring instrument)

In `scripts/grading-model-assessment/` + pilot tooling, with unit tests using
`raw_calls.jsonl` records as fixtures:

- `to_result_cases.mjs`: parse the idempotency-replay shape
  (`result.criterion_results`); **fail loudly** on any unrecognized result
  shape instead of emitting empty criteria.
- Partial-credit-aware scoring policy (v2) in `harness.ts` alongside the binary
  v1 (gold 008a is 2 pt; the binary collapse can't evaluate the partial-credit
  behavior shipped 2026-07-29).
- Item-level cluster bootstrap: caller-side collapse of `item_correctness` keys
  to `content_key` in `main.ts`; report both response- and item-level CIs.
- Capture tooling: persist the rendered prompt (or its SHA-256) per call in
  future `raw_calls.jsonl` records.

### 1.3 Policy simulations from the existing capture (the free experiments)

Using `exemplar_grading_pilot_2026_08/raw_calls.jsonl` (5 trials/cell, gold
labels, both arms):

- **Retry-on-integrity-failure:** formalize the measured result (13.5% of
  LLM-path trials abstain on integrity checks; 8/10 affected cells stochastic →
  one retry recovers; 2/10 systematic → permanent-abstain residue). Output:
  expected abstention-conversion rate per retry.
- **Single-call vs modal-of-3 vs modal-of-5:** simulate each policy against
  gold; produce the accuracy/coverage-vs-cost curve that sizes the escalation
  ladder before it is built.
- **Blast-radius recovery bound:** count gold-determinable criteria zeroed by
  deterministic flags aimed at unrelated criteria; multiply by measured
  selective accuracy (94–96%) → expected recovery from per-criterion flag
  scoping. Feeds O2.

**Deliverable:** one short report; its numbers are inputs to Step 4, and its
escalation curve decides whether any escalation-shaped paid run is needed at
all.

### 1.4 Correct the written record (governance)

Annotate — do not rewrite — `exemplar_grading_pilot_2026_08/REPORT.md`, the
ledger §A row, and the 2026-08-10 activity-log entry: the +4.7pp / [0, 12.2]
figures are corrupted by the replay-parsing defect (corrected: +1.4pp,
CI [−2.5, +6.7], secondary metrics equalize). Prevents the wrong numbers being
cited later; the ledger's own convention ("do not re-cite") requires the
correction to live where the numbers live.

### 1.5 Plan-doc update with already-decided items

Update `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` (or a dated successor
note it links) with what existing evidence already settles — no new data
needed:

- Prompt-content experiments (exemplar/few-shot) closed; remaining prompt work
  is `accepted_variants` only.
- The deterministic text-gate is a live, decision-making layer inside Engine 1
  and is brought under Engine 3-grade governance (1.1's invariant).
- Engine 3 owner-decision #3 resolved toward wiring the profile loader
  (the hardcoded-map pattern is the class that just failed in production).
- Stale claims corrected: "deterministic layer effectively absent (0.7%)",
  "Engine 1 never abstains" (system-level abstention is now common), §11's
  unmeasured non-model latency (measured: ~691 ms p50 e2e).

### 1.6 Stage-1 gold-set false-accept computation (read-only, free)

Both readers' marks on the 40-answer Statistics Set B corpus exist and are
unused. Compute the reader-consensus false-accept count on provisional accepts
+ the reader-vs-reader disagreement rate (protocol §5 definitions; exclude or
footnote Jill's 6 owner-returned re-marks). Not certifiable at n=40 — but it is
the program's first machine-vs-human number and a Step 4 input.

**Gate 1:** all new tests green; O1 signed; 1.3 report written.

---

## Step 2 — One deploy bundle: key fix + instrumentation

Single `evaluate-attempt` deploy (plus one migration), so telemetry starts
accruing before and during the paid runs.

### 2.1 The fix

- Corrected `STATISTICS_TARGETS` values per 1.1, each entry annotated with
  source `content_hash` + derivation.
- Bump the deterministic verifier version string (the
  `deterministic_verifier_version` convention, e.g.
  `stats-verifier-ts-2026-08-11`).
- **O2 (owner):** per-criterion flag scoping — deterministic flags stop zeroing
  criteria the keyed values don't belong to. Learner-visible behavior change;
  recommend **yes** on the 1.3 recovery bound, but it ships only with explicit
  approval, and may ship as a separate follow-up deploy if O2 needs more time.

### 2.2 The instrumentation (all passive, no behavior change)

- `grading_results`: normalized-response-text hash column (replay hit-rate
  telemetry — decision threshold pre-registered: build cross-attempt replay if
  per-item duplicate rate > ~10% once real traffic exists).
- Log provider `cached_tokens` (+ any provider timing fields) per call.
- In-function stage timings: auth / DB / deterministic check / model call /
  sanitize — attacks the ~691 ms non-model floor with data.
- No prompt changes in this bundle → no `EVALUATE_ATTEMPT_PROMPT_VERSION` bump.

### 2.3 Deploy discipline (handoff §6/§7)

- Diff repo HEAD against the deployed function version first (trap 2).
- Migration via the scratch-workdir procedure (the CLI is linked to Dev and
  `~/supabase` is a stale Prod-linked checkout — 2026-08-03 hazard note).
- `supabase functions deploy evaluate-attempt --project-ref pcntajvbdfqhbeewmdry --use-api --workdir <repo>`.

### 2.4 Post-deploy verification

- Replay a known-correct SFRQ-008 answer → deterministic check `pass`, graded
  route reached.
- Canary one response per remaining keyed item → no new false flags.
- Confirm instrumentation rows land (timings, cached_tokens, response hash).

**Gate 2:** smoke green; telemetry visible; activity-log entry written.

---

## Step 3 — Paid runs (≈$3–4 total) + exemplar-pilot Production cleanup

### 3.0 FIRST: execute the outstanding exemplar-pilot cleanup (blocking)

Per `docs/research/exemplar_grading_pilot_2026_08/README.md` §5 — required
before the pilot is closed, and done **before** new runs so the new synthetic
footprint is the only one:

- Delete all rows tied to the synthetic pilot student: `app.grading_results`,
  `app.response_versions`, `app.attempts`, any `app.student_memory`, its
  `app.profiles` row, and the Supabase Auth user.
- Record what was deleted in
  `exemplar_grading_pilot_2026_08/EXECUTION_LOG.md`; final query confirming
  zero `app.*` rows reference the pilot user id.
- **O3 (owner):** approve the deletion (destructive, Production).
- **Adopt the same create→run→cleanup protocol for every run below** — each run
  ends with its own cleanup + logged confirmation, so this debt never
  accumulates again. (The 2026-07-28 test-data footprint in handoff §8,
  owner-held "keep for now", is a separate decision — flag, don't touch.)

### 3.1 Run A — recovered accuracy after the key fix (~$0.50–1)

The gated calls never reached the model, so this is genuinely new data, not a
re-score. ~14 previously-gated responses (SFRQ-008 ×8, 009 ×3, 001 ×2–3) ×
5 trials × 1 arm (production prompt, `exemplar_mode: off`) against the fixed
keys (and scoped flags if O2 shipped). Score with the v2 harness.
**Pre-registered expectation:** overall accuracy on these items converges
toward the 1.3 recovery bound; SFRQ-008 moves off 0%. Checkpoint-and-resume
capture (trap 4), prompts captured (1.2).

### 3.2 Run B — prompt-caching A/B (~$1, offline via research gateway first)

Restructure for a byte-stable ≥1024-token prefix (unit test asserting prefix
stability across responses of the same item); ~50 calls over same-item response
sets; read `cached_tokens` + TTFB deltas. Baseline on record is zero cached
tokens. **Decision rule:** nonzero cache hits and a measured TTFB/cost delta →
productionize behind `EVALUATE_ATTEMPT_PROMPT_VERSION` bump as its own change
(**O4**); otherwise close the direction with the measurement recorded.

### 3.3 Run C — Arm A latency on the production model (~$1–2)

Phase C validated Arm A on `gemini-2.5-flash` (trap 1 — wrong model). Re-run
the narrow-pilot harness on `gpt-4.1-mini`: confirm flat-in-criterion-count
latency and the ~16 s → ~4 s expectation on 4-criterion items, plus quality
parity per the 2026-07-29 Arm A quality caveat (0/6 finding) — quality-first
means Run C is a *quality* gate for Arm A as much as a speed measurement.

**Gate 3:** all runs scored with the v2 harness; per-run cleanup executed and
logged; results + raw captures committed; activity-log entries written.

---

## Step 4 — Handoff redesign + rebuild register

**Deliverable:** a dated successor revision of
`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` (successor section or linked
successor doc, per the v1.0→v2.0 convention — the 2026-07-28 snapshot stays
intact as the comparison baseline). Inputs: Step 1 reports + Step 3
measurements + the already-known facts. The revision covers:

1. **Quality:** abstention-conversion escalation architecture (retry →
   modal-of-N on the unstable slice → permanent-abstain-with-scaffold residue),
   sized from the 1.3 curve and Run A — machine-only throughout. Deterministic
   expansion roadmap gated on the 1.1 invariant. `accepted_variants` work
   scheduled per the ledger.
2. **Speed:** Arm A go/no-go from Run C; non-model-overhead workstream from the
   2.2 timing telemetry (~691 ms floor vs the 1 s bar); caching decision from
   Run B; replay decision deferred to the pre-registered traffic threshold.
3. **Standing measurement:** each engine gets a frozen gold-set regression gate
   (protocol Phase 5) as a rollout precondition; Stage-1 false-accept number
   (1.6) recorded as the first machine-vs-human baseline; every future fix
   ships with its own standing test or logged metric.

### Rebuild register — completed work re-decided on evidence, not presumption

Each entry names its trigger; nothing is rebuilt (or preserved) on sunk-cost
grounds in either direction.

| Completed work | Trigger evidence | Decision space |
|---|---|---|
| Arm A conversion (built, default-off, 0/6 quality finding) | **DECIDED 2026-08-13, Run C** (`exemplar_grading_pilot_2026_08/EXECUTION_LOG.md`): 24 real calls on `gpt-4.1-mini`, 22–31s across all criterion counts (not flat, not the ~4s pre-registered expectation, mostly slower than Arm B). Quality not clearly bad this round (82.6%/95% selective). | **Keep default-off, do not ship on this evidence.** Not a full discard — sample (n=6–12/bucket) is too small to rule out "genuinely faster, just noisy here." Re-open only with a substantially larger sample; do not re-run at this size. |
| `STATISTICS_TARGETS` as bare constants | **DONE 2026-08-13.** 1.1's audit found one failure (`APSTATS-SFRQ-008`, retired-canonical values); fixed as a value-only correction with per-entry provenance comments, not rebuilt to derived formula+givens keys. | Closed as value-fix-only; revisit the Phase B derived-key shape only if a second key defect is found. |
| Engine 3 hardcoded profile map | already settled (008 incident class) | schedule the governed-loader build — **still not scheduled as of 2026-08-13** |
| Deterministic-flag blast radius (sanitizer path) | **DONE 2026-08-13 ("O2").** Scoped per-criterion for the 8 items with a known criterion mapping (real `app.frq_criteria.criterion_key`, not the gold-fixture ids `NUMERIC_ELEMENT_CRITERIA` uses for audit — conflating the two was a same-session bug, caught before it reached real traffic). Unmapped items keep item-wide. | Closed as shipped. Extending to a new item requires verifying its criterion-key mapping against a live query first — see the ledger's "Engineering pitfall" row. |
| Assessment harness, replay parsing, partial credit, clustering | already rebuilt in Step 1 | record only |
| Gold-set corpora with the A3/A6 same-element collision (Stats/Calc/Precalc) | gold-set program's own call | **out of scope here** — cross-reference only; owned by the gold-set certification track |

**New row, 2026-08-13:** evidence-grounding false-alarm rate
(`grading-feedback.ts`'s sanitizer, `evidence_not_found`) | Run A + the O2
smoke test both found selective accuracy ≈100% with the entire accuracy
gap sitting in abstention from this mechanism — not scoped by this plan,
found as a byproduct of verifying it. | **Not decided — this plan didn't
scope it. Recommended as the next investigation** (ledger §5, new top
priority); ranked above further deterministic-key coverage, gold-set
volume, or another model/arm evaluation, since none of those move a
number whose gap is abstention.

Handoff sections that survive unchanged are listed explicitly in the revision
(verified-facts table, §6 traps, §7 runbook, Engine 3 shadow ceiling, Engine 4
scope-first, §8 footprint note) so the diff is auditable.

---

## Owner decision points (summary)

| # | Decision | Blocks |
|---|---|---|
| O1 | Approve corrected deterministic key set (1.1) | Step 2 |
| O2 | Per-criterion flag scoping (learner-visible) | 2.1 (can trail as follow-up) |
| O3 | Exemplar-pilot cleanup deletion | 3.0, hence all paid runs |
| O4 | Productionize prompt restructure if Run B pays | post-3.2 |
| O5 | Sign off plan-doc updates (1.5) and final synthesis (Step 4) | Step 4 close |
