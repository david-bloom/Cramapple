# Engine 3 — Production Harness Test: Scope

**Date:** 2026-07-28
**Purpose:** First execution of the Production Engine 3 path (routing → profile →
symbolic/ECF verification → output) using **synthesized structured responses**,
without building a typed-input editor.
**Status:** Scoped, not started. Three owner decisions required (§9).
**Model cost:** ~$0 by construction — the deterministic path makes no model call.

---

## 1. Objective

Prove or disprove, on real Production infrastructure and real content versions,
that the Engine 3 chain executes correctly:

1. an item routes to `symbolic_ecf`;
2. the profile for that item is found and loaded;
3. `coerceEcfQuestion` accepts a structured response;
4. the symbolic/ECF checker returns correct per-part verdicts;
5. ECF chaining, guardrails, and abstention behave as specified;
6. the orchestration handles **mixed** items (some criteria deterministic, some
   conceptual) without contaminating either side.

### Explicit non-objectives

This test **cannot and will not** establish:

- that real students can produce structured math input (no editor exists; the
  transcription bake-off used synthetic renders and real handwriting is still
  unvalidated);
- that Engine 3 can issue an **authoritative grade** — the path hard-codes
  `finalStatus = "uncertain"` (`evaluate-attempt/index.ts:~1121`), so
  authoritative output is unbuilt, not merely ungated;
- any launch-readiness or accuracy claim against the ≥95% bar.

It is an **integration proof**, not a calibration run.

## 2. Preconditions — what must change before it can run at all

| # | Precondition | Type | Note |
|---|---|---|---|
| P1 | ≥1 item has `evaluator_strategy = 'symbolic_ecf'` | **data write** | Currently **0 of 1,316**. Unavoidable: a routing path cannot be tested without routing something to it. |
| P2 | Profile reachable for that item | **code or data** | Either extend the hardcoded map, or (preferred) wire the loader to read `prompt_json.verification_profile`, which the router already reads for routing metadata |
| P3 | A caller can POST structured `response_parts` | **already satisfied** | `attempt-response/index.ts:361` accepts and persists arbitrary `response_parts` jsonb — no client work needed |

P3 being already satisfied is what makes this test cheap and available now.

## 3. Feasibility check — completed, and better than expected

Codex flagged the risk that profile criterion keys would not match Production
`frq_criteria`. **Checked against Production: they match.**

| content_key | profile criteria | Production `frq_criteria` keys | match |
|---|---|---|---|
| `APSTAT-MOD3-E004` | range_calculation | range_calculation | ✓ |
| `APSTAT-MOD6-M001` | sampling_design, margin_of_error | margin_of_error, sampling_design | ✓ |
| `STATS-MOD1-E004` | mean_calculation | mean_calculation | ✓ |
| `STATS-MOD1-M004` | frequency_table | frequency_table | ✓ |
| `STATS-MOD3-M006` | percentile_zscore | percentile_zscore | ✓ |
| `APSTAT-MOD8-M004` | slope_interpretation | slope_interpretation | ✓ |
| `APSTAT-MOD3-H001-INV` | 5 keys | same 5 keys | ✓ |
| `APSTAT-MOD6-H001` | 3 keys | same 3 keys | ✓ |
| `APSTAT-MOD7-H001` | 2 keys | same 2 keys | ✓ |

**But content status is the real constraint.** Of the 28 firing-capable profiles
(2 of 30 have empty `ecf_parts` and can never fire):

- **6 map to a `published` + tutor-approved item** — all single-criterion or
  simple, weak ECF coverage;
- **~19 map to `draft` items** — including *every* rich multi-part ECF chain;
- 1 `reviewed_disapproved`, 1 `assigned`, 1 `retired` (superseded by a published v2).

**The scientifically interesting ECF cases are all on draft content.** That is the
central scoping tension.

## 4. Item selection

### Tier A — published, approved, no content-state risk (4 items)

| item | criteria | ecf_parts | what it tests |
|---|---|---|---|
| `STATS-MOD1-E004` | 1 | 1 | simplest possible numeric verdict — smoke test |
| `STATS-MOD1-M004` | 1 | **6** | multi-part under a *single* criterion; part-to-criterion aggregation |
| `STATS-MOD3-M006` | 1 | 1 | constant-answer key (accepts approximate z=1) |
| **`APSTAT-MOD6-M001`** | **2** | 1 | **mixed item**: `margin_of_error` numeric + `sampling_design` conceptual-ABSTAIN. The orchestration test, and it is published. |

`APSTAT-MOD6-M001` is the single most valuable Tier A case — it is the only
published item that exercises deterministic/model co-existence on one item.

### Tier B — draft, but the only real ECF chains (3 items)

| item | ecf chain | what it tests |
|---|---|---|
| `APSTAT-MOD3-H001-INV` | `SE` → {`CI_low`, `CI_high`, `t_stat`} | **branching** ECF: one upstream error propagating to three downstream parts |
| `APSTAT-MOD6-H001` | `SE_diff` → `t_stat` | linear ECF + **`sign_sensitive`** handling |
| `APSTAT-MOD7-H001` | `P_D` → `P_BgivenD` | linear ECF on probabilities |

Without Tier B the test cannot exercise ECF at all — which is the distinctive
capability of Engine 3. Recommend including Tier B, on Dev (§7).

## 5. Test matrix — synthesized structured responses

Per item, POST `response_parts` in the shape `coerceEcfQuestion` requires
(`student_answer`, `shown_subs`, `stated_formula` per part). Cases:

| # | Case | Expected behaviour |
|---|---|---|
| 1 | All parts correct | all parts PASS |
| 2 | **ECF**: wrong upstream, downstream correct *on the student's own value* | upstream FLAG, downstream PASS with ECF credit |
| 3 | Wrong upstream **and** wrong downstream | both FLAG, no spurious ECF credit |
| 4 | **Coincidental canonical**: right answer, wrong formula | FLAG (guardrail: must not pass on the number alone) |
| 5 | **Naked answer**: `student_answer` only, no `stated_formula`/`shown_subs` | no ECF applied; per DECISION, triggers help/scaffolding rather than silent 0 |
| 6 | Equivalent-but-non-canonical algebraic form | PASS (equivalence, not string match) |
| 7 | Ambiguous notation (e.g. flat fraction) | **ABSTAIN, not FLAG** — known notation hazard |
| 8 | Missing a required part entirely | `coerceEcfQuestion` returns `null` → clean fallthrough, no crash |
| 9 | Mixed item (`APSTAT-MOD6-M001`) | numeric criterion deterministic; conceptual criterion untouched/ABSTAIN |
| 10 | `sign_sensitive` part with reversed sign (`APSTAT-MOD6-H001`) | per profile: magnitude graded, sign not |

≈10 cases × 7 items, minus non-applicable combinations ≈ **45–55 requests**.

## 6. Measurements

- **Routing reachability:** did the `symbolic_ecf` branch execute? (binary, and
  currently the single most important output)
- **Profile resolution:** found / not found per item
- **Per-part verdict correctness** vs the expected column in §5
- **ECF chain correctness** — downstream credit granted on the student's own value
- **Guardrails:** coincidental-canonical rejected; naked answer not ECF'd;
  ambiguous notation ABSTAINs rather than false-flags
- **Latency:** wall-clock for the deterministic path. Expect **single-digit to
  low-tens of ms**. This is the latency business case — if it is not ~0, the
  premise that deterministic coverage fixes the 1,000 ms bar is wrong.
- **Cost:** expect exactly **$0** (no model call)
- **Deterministic ownership, both denominators:** criteria owned, **and items
  fully owned** — the latter governs the latency case, since a mixed item still
  pays full model latency
- **Final status emitted:** expect `uncertain` — documenting link 4 as unbuilt

## 7. Environment — recommend Dev, with a Production smoke subset

| | Production `pcntajvbdfqhbeewmdry` | Dev `wmgjsdkphcyhngaffbqf` |
|---|---|---|
| Tests the deployed system | ✓ | ✗ (divergence risk; reconciled 2026-07-15) |
| Requires content writes (P1 routing) | ✗ risk — mutates live content rows | ✓ safe |
| Requires attempt/response/grade writes | ✗ — Phase C was read-only by rule | ✓ safe |
| Can use draft Tier B items | uncertain (RLS / function guards) | ✓ |

**Recommendation:** run the **full matrix on Dev** (Tiers A+B, all 10 cases),
then a **minimal Production smoke test** on Tier A only — ideally the single
mixed item `APSTAT-MOD6-M001` — to confirm the deployed function behaves
identically. The Production portion needs explicit approval for its write
footprint and a verified cleanup, exactly as the 2026-07-27 repair pilot did.

## 8. Effort and cost

| Item | Estimate |
|---|---|
| Model/API cost | **~$0** (deterministic path makes no model call) |
| P1 routing writes | 4–7 rows (`evaluator_strategy` update) |
| P2 loader wiring | small code change if reading from `prompt_json`; zero if extending the hardcoded map for the test |
| Harness build | synthesize `response_parts` fixtures + POST driver + expectation table |
| Test writes | ~50 attempt/response/grading rows on Dev; ~10 on Production if approved |
| Wall clock | short — the bottleneck is fixture authoring, not runtime |

## 9. Decisions required before starting

1. **Environment:** Dev-only, or Dev + a Production smoke subset? (Production
   requires approval for content mutation + test-row writes + cleanup.)
2. **Tier B (draft items):** include them? Without Tier B the test cannot
   exercise ECF chaining at all — the distinctive Engine 3 capability. Including
   them means testing against unpublished content, which is fine for an
   engineering proof but must not be reported as launch progress.
3. **P2 approach:** wire the loader to `prompt_json.verification_profile` now
   (the durable fix, and it makes profiles governed content), or temporarily
   extend the hardcoded map to unblock the test faster and defer the loader?
   Recommend wiring the loader — the hardcoded map is the defect under
   investigation, and testing through it would validate the wrong path.

## 9b. Deferred harness gap — carry into the integration test

The checker-level harness (run 2026-07-28) covers `coerceEcfQuestion` and
`buildEcfResult`. The production `symbolic_ecf` path calls a third function the
harness does **not** exercise:

- **`detectAmbiguousTypedFormulaText`** (`_shared/formula-notation.ts`, called at
  `evaluate-attempt/index.ts:1039`) — the ABSTAIN-on-ambiguous-notation
  guardrail. This is a named failure case in the rollout plan ("typed-notation
  ambiguity: ABSTAIN, not false-flag") and covers the known flat-fraction
  hazard. **Add fixtures for it as part of the integration test.**

Also noted: `checkFormulaCase` — the exported entry point behind the "62/62"
symbolic-checker validation — is **not called by `evaluate-attempt`** at all.
The underlying symbolic comparison is still exercised internally by
`buildEcfResult` via `compareExpressions`, so the capability is covered, but the
validated entry point is not on the production grading path.

## 10. What a pass would and would not license

**A pass licenses:** proceeding to Codex's step 7 — migrate the remaining
validated Statistics profiles — and step 8, a Calculus/Precalculus packet to
test the Engine 3 ceiling.

**A pass does not license:** any learner-facing Engine 3 output. Link 4
(authoritative grade) is unbuilt and link 2 (real structured input from
students) is unsolved. Everything stays shadow-only until held-out accuracy,
abstention safety, and authoritative-grade behaviour are separately built and
approved.
