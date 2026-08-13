# Policy simulations from the exemplar-pilot capture — 2026-08-11

**Task:** replan item 1.3 (`../GRADING_ENGINE_REPLAN_EXECUTION_PLAN_2026_08_10.md`)
**Data:** `raw_calls.jsonl` (330 records; 300 with HTTP 2xx: 130
deterministic-gate short-circuits, 170 LLM-path trials over 34 (case × arm)
cells × 5 trials), scored against `gold_cases.json` (30 responses, 84
gold-determinable criteria per arm). No new model calls — every number below
is recomputed from the existing capture.

**Small-n caveat, stated up front:** 4 held-out items, one subject
(AP Statistics), 30 responses, and a capture in which one item's
deterministic gate was firing on a *defective* key (SFRQ-008, see
`../DETERMINISTIC_KEY_AUDIT_2026_08_11.md`). Every figure here is
directional input for Step 4 sizing, not a certified rate. Where the
SFRQ-008 defect changes a conclusion, both with- and without- numbers are
given.

---

## (a) Retry-on-integrity-failure

**Measured base rates.** Of the 170 LLM-path trials, 24 returned
`status: "uncertain"`; 23 (13.5%) are integrity-check abstentions
(`uncertainty_reason` = "Grading output failed N integrity check(s)…") and 1
is a provider timeout ("Signal timed out.", SFRQ-005#1 arm=off trial 2 —
transport, not integrity; excluded below). The 23 failures fall in 10 of the
34 cells:

| Cell | integrity-abstain trials / 5 |
| --- | --- |
| SFRQ-001#1 off | **5/5 (systematic)** |
| SFRQ-001#1 with_exemplar | **5/5 (systematic)** |
| SFRQ-001#0 with_exemplar | 3/5 |
| SFRQ-005#2 off | 3/5 |
| SFRQ-009#7 with_exemplar | 2/5 |
| SFRQ-005#1/#2/#3/#4 with_exemplar | 1/5 each |
| SFRQ-009#6 with_exemplar | 1/5 |

**Method.** Model each cell's per-trial abstention probability as its
empirical fraction p̂ (trials are same-prompt repeats, so this is the
maximum-likelihood per-call rate for that response). A retry-on-abstain
policy converts an abstention with probability 1 − p̂; k retries leave
abstention probability p̂^(k+1).

**Results.**

- Expected conversion of abstention events on **one retry: 7.6 of 23 = 33%**
  (weighted by each event's own cell p̂ — the failures concentrate in
  high-p̂ cells, which is why this is below the naive 8-of-10-cells
  intuition).
- Expected per-call abstention rate: single call **13.5%** → retry-once
  **9.1%** (Σp̂²/34) → retry-twice **7.5%**.
- **Systematic floor: 5.9%** (10 of 170 trials; the two SFRQ-001#1 cells at
  5/5 in *both arms* — same response, arm-invariant, so this is a
  response-content problem, not sampling noise; retries never help).
  Stochastic residue after one retry ≈ 3.2%, after two ≈ 1.6%.

**Reading:** one retry buys back about a third of abstentions for 1.135×
mean cost on the LLM path (retry fires on 13.5% of calls); nearly everything
recoverable is recovered by the second retry. The 5.9% systematic residue is
the permanent-abstain-with-scaffold slice the escalation ladder's terminal
rung must own — consistent with the ledger's β2-B finding that the remaining
undecidable mass is not reachable by re-asking.

---

## (b) Single-call vs modal-of-3 vs modal-of-5

**Method.** For each (case × arm) cell, subsample k of its 5 trials
uniformly without replacement (500 seeded draws for k=1 and k=3; k=5 is the
committed full aggregation), aggregate with `to_result_cases.mjs`'s exact
rules (modal status per criterion, first-seen tie-break, median points
clamped), score with `harness.ts` `scoreRun` (binary v1 policy, matching the
committed report), and average over draws. Deterministic-gate cells (13
cases, arm-invariant) are included and are k-invariant, which damps the
whole curve. Simulation script: run from
`scratchpad/modal_sim.ts` (session scratch; method fully described here and
reproducible from the committed files).

| Policy | Cost | `off` overall (sd) | `off` coverage | `with_exemplar` overall (sd) | `with_exemplar` coverage |
| --- | --- | --- | --- | --- | --- |
| single call (k=1) | 1× | 56.7% (1.6) | 60.6% | 56.6% (1.3) | 58.9% |
| modal-of-3 | 3× | 57.5% (0.5) | 61.1% | 58.0% (1.0) | 60.4% |
| modal-of-5 | 5× | 57.1% (—) | 60.7% | 58.3% (—) | 60.7% |

Selective accuracy is flat throughout (93.7–94.2% `off`, 96.0–96.1%
`with_exemplar`).

**Reading:** the accuracy curve is almost flat — modal-of-3 buys ≈ +0.8–1.4pp
over a single call, and modal-of-5 adds nothing outside noise, at 3×/5× cost
and 3×/5× latency exposure. This matches the run-to-run stability already on
record (97.2% mean modal agreement across trials; ledger's 99.4% on
decidable content): voting can only fix what varies. **Blanket modal-of-N is
not where this corpus's error mass lives** — the headroom is in the
deterministic-gate zeroings ((c) below) and the systematic-abstention slice
((a) above), neither of which N repeats touch. If escalation is built, this
supports the ledger's disagreement-routing shape (escalate only the unstable
slice) rather than always-on voting.

---

## (c) Blast-radius recovery bound (input to O2)

**What the gate does today:** a deterministic flag zeroes the ENTIRE item —
`buildStatisticsDeterministicFallback` marks every criterion
`unable_to_determine` with `points_earned: 0`, including criteria the keyed
values have nothing to do with.

**Measured blast radius in this capture.** 13 of 30 cases were gated (all 5
trials, both arms — arm-invariant): SFRQ-008 × 8 (defective key; every one
spurious), SFRQ-009 × 3 and SFRQ-001 × 2 (legitimate flags — the keyed
evidence genuinely was absent/wrong). Against gold
(`gold_cases.json`), the gate zeroed **31 gold-determinable criteria — 37%
of the run's entire 84-criterion denominator per arm**. Of those 31:

- **14** belong to the criterion the keyed values live in (SFRQ-001 a1/c1;
  SFRQ-008 criterion a; SFRQ-009 criterion a) — flag-scoping would keep
  zeroing these (correctly, once keys are right);
- **17** belong to unrelated criteria (SFRQ-001 b1/d1 ×2 = 4; SFRQ-008 b/c
  = 10; SFRQ-009 b = 3) — pure collateral.

**Bound.** Scoping flags per-criterion sends the 17 unrelated criteria to
the LLM grader, which decides at measured selective accuracy 94–96% on this
corpus:

- expected recovery = 17 × 0.94…0.96 = **16.0–16.3 criteria ≈ +19.0 to
  +19.4pp overall accuracy per arm** on this capture as it happened.

**Post-key-fix residual (the number O2 actually governs going forward):**
with SFRQ-008's key corrected (O1), its 8 spurious gatings disappear and
only the legitimate flags remain (SFRQ-001 ×2, SFRQ-009 ×3; 7 unrelated
determinable criteria): expected recovery = 7 × 0.94…0.96 = **6.6–6.7
criteria ≈ +7.8 to +8.0pp** on this corpus.

**Reading:** both numbers say the same thing — item-wide zeroing is the
single largest recoverable error mass in this capture, larger than anything
prompt- or voting-shaped. Recommend **yes** on O2 (matches the replan's
prior), with the caveat that 4 items / one subject means the +8pp residual
figure is an illustration of the mechanism's size, not a forecast. Note O2
is learner-visible (partial feedback instead of a whole-item hold) and
ships only with explicit approval.

---

## Cross-check totals

- 330 raw records = 300 × 2xx + 29 × 401 (session expiry, recovered by
  resume) + 1 × 409 (retired SFRQ-003, excluded item).
- 300 × 2xx = 130 deterministic-gate + 170 LLM-path; the 170 include the 5
  idempotency-replay records whose parsing defect is corrected in
  `to_result_cases.mjs` (see `REPORT.md` "Correction — 2026-08-11").
- Latency/cost context from the capture (for the escalation-ladder costing):
  deterministic-gate calls 691 ms p50 / 953 ms p95 wall; LLM-path 10.6 s
  p50 / 20.2 s p95; LLM cost ≈ $0.0067/response mean.
