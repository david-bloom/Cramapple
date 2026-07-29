# Engine 3 — What It Takes to Raise Verification-Profile Coverage

**Date:** 2026-07-28 (revised same day after Codex review)
**Question:** What is needed to increase verification-profile coverage so Engine 3
can be tested at scale?
**Answer, revised:** Coverage is **not the first binding constraint**. Engine 3 is
currently **unreachable in Production for every item in the bank**, for reasons
upstream of profiles. Raising coverage without fixing those first would change
nothing measurable.

> **This document supersedes the first version, which contained two errors
> identified by Codex review and a third found while verifying that review.
> Corrections are marked ✗→✓ in §0.**

---

## 0. Corrections to the first version

### ✗→✓ Error 1: "There is nowhere in the database to store a profile"

**Wrong.** `content_item_versions.prompt_json` is a version-bound `jsonb` column,
and `grading-router.ts:35` explicitly reads `record.verification_profile` from it
— with a dedicated unit test (`grading-router_test.ts:98`, *"reads rubric metadata
from prompt_json verification_profile"*). The architecture already anticipated a
nested profile.

**Cause of the error:** I queried `information_schema.columns` for column *names*
matching `%verification%`/`%profile%`. A key nested inside an existing `jsonb`
column cannot show up that way. I concluded "no home exists" from a search that
structurally could not have found it.

**The accurate finding:** there is no *dedicated, validated, governed* profile
storage contract. A storage location exists and is read; what is missing is a
schema contract, a validator, provenance, and lifecycle. Codex's framing is
correct and materially different from mine.

**However** — and this qualifies the correction — the router reads
`prompt_json.verification_profile` only for **routing metadata** (`rubric_type`,
`evaluator_strategy`). The actual checker keys are still fetched by
`findStatisticsItem(content_key)` from the hardcoded map in `math-verifier.ts`.
So the anticipated location is not yet wired to the checker, and:

**`prompt_json.verification_profile` is populated on 0 of 1,316
content_item_versions.** The mechanism is live in code and unused in data.

### ✗→✓ Error 2: "0.7% deterministic coverage" — and then "0.0%"

Both figures are wrong, and the second correction did not go far enough.
**I never measured Production Engine 3 at all.** The "deterministic check" in my
Stage 6 runner was a proxy I wrote myself: a substring match of a canonical
numeric answer against the response text. Production does something entirely
different — symbolic parsing plus a two-universe ECF state machine over
structured `response_parts`. The two share no code path and no semantics.

The honest statement: **Engine 3 has never been measured on this corpus in any
form that reflects production behaviour.**

### ✗→✓ Error 3 (mine, found while verifying Codex): the HDG-GRAPH artifact was self-inflicted

I reported that 5 `HDG-2026-GRAPH` items polluted the Engine 1 corpus and
attributed it to "the corpus was built without consulting the router." Verified:
**all 5 are correctly tagged `rubric_type='spatial'`, `evaluator_strategy='human_shadow'`
in Production.** The data was right. My Stage 1 eligibility SQL filtered on tutor
decision, status, review_status, and criteria presence — but **not** on
`evaluator_strategy`. The 24% error-mass artifact in Stage 6 was my
corpus-construction error, not a content defect. Cheap permanent fix: filter
Engine 1 corpora on `evaluator_strategy = 'llm_discrete_text'`.

## 1. The actual blocking chain — four independently fatal links

Engine 3 fails at the **first** link, so nothing downstream has ever executed.

| # | Link | Status | Evidence |
|---|---|---|---|
| **1** | **Item is routed to Engine 3** | **0 of 1,316 versions have `evaluator_strategy = 'symbolic_ecf'`** | routing distribution below |
| **2** | Structured response input exists | `coerceEcfQuestion` **returns `null`** unless every `ecf_part` is present in `response_parts` with `student_answer` / `shown_subs` / `stated_formula`. **No text parsing, no inference.** | `math-verifier.ts:819-855` |
| **3** | Profile keys are available | Hardcoded map, 5 entries, 2 structurally dead; `prompt_json.verification_profile` = 0/1,316 | `math-verifier.ts:873-951` |
| **4** | Output is authoritative | Path sets **`finalStatus = "uncertain"`**, `modelResponse = null`, zero cost — shadow review only | `evaluate-attempt/index.ts:~1121` |

Production routing distribution (all 1,316 versions):

| evaluator_strategy | rubric_type | versions |
|---|---|---:|
| `llm_discrete_text` | `discrete_text` | 561 |
| `rule_based_mcq` | `mcq` | 494 |
| *(null)* | *(null)* | 221 |
| `human_shadow` | `spatial` | 40 |
| **`symbolic_ecf`** | — | **0** |

And the two hardcoded profiles that are *capable* of firing
(`APSTAT-MOD3-H001-INV`, `APSTAT-MOD6-H001`) sit on items whose `rubric_type` and
`evaluator_strategy` are both **NULL** — so they fall through to the item-type
fallback and never reach the `symbolic_ecf` branch.

**Conclusion: "delivery, not authoring" was the wrong diagnosis.** Delivery is
link 3 of 4. Routing (link 1) and input representation (link 2) both bind
earlier, and authoritative-output calibration (link 4) binds after. Codex's
fuller diagnosis is correct: *Engine 3 has validated checker components but not a
production system.*

## 2. Where the Codex review is right, and accepted

- **25 authored profiles are migration *candidates*, not deployable.** Each needs
  its `content_key` re-resolved to the current immutable version, criteria keys
  matched to Production `frq_criteria`, formulas parsed by the **TypeScript**
  runtime (not the research Python), and ECF behaviour re-checked after the
  recent content repairs. My "3 items → ~28 immediately" was too optimistic.
- **`APSTAT-MOD8-H001` needs adjudication, not auto-rejection.** Its
  `corpus_defect` field says "NO DATASET", but the same file records the defect
  as *RESOLVED 2026-07-09 by Product Owner approval* (rubric rescoped to
  method-only). The lingering field is stale metadata; the item should be judged
  on the resolution, not the field.
- **A validator must precede any bulk migration**, enforcing: version linkage,
  criterion-to-profile coverage, formula/dependency validity, canonical-answer
  consistency, point totals, unresolved defects, and **routing reachability**
  (which, given §1, would currently reject all 30).
- **59% keyability is sizing, not coverage.** It overcounts criteria needing
  shown reasoning, method credit, domain restrictions, sig-figs, units, graphical
  evidence, or multiple independently-scored steps. It needs a human
  classification pass (deterministically owned / assisted / model owned /
  unsupported) before it forecasts anything.
- **Units belong after the foundational blockers**, not as blocker #4.
- **Do not abandon Statistics.** Codex's two-goal split is better than my
  recommendation and is adopted below.

## 3. Revised recommendation

Adopting Codex's gated sequence, with routing added as step 0 since §1 shows it
binds first:

0. **Fix routing reachability.** Decide which items are Engine 3 and set
   `evaluator_strategy = 'symbolic_ecf'`. Until ≥1 item routes there, no other
   Engine 3 work is observable.
1. **Define the versioned profile contract + validator** (including routing
   reachability as a validation rule).
2. **Decide storage:** nested in immutable `prompt_json.verification_profile`
   (already read by the router, already version-bound) vs a dedicated
   version-linked table (better provenance, querying, lifecycle). Recommend the
   dedicated table, with `prompt_json` retained for routing metadata.
3. **Confirm the response-input contract.** This is the largest genuinely
   unsolved problem: without a typed editor, parser, or validated handwriting
   transcription producing `student_answer` / `shown_subs` / `stated_formula`,
   profiles make items *theoretically* verifiable only. Note the prior
   transcription bake-off used **synthetic renders**; real-handwriting
   validation is still outstanding.
4. **Audit the 30 Statistics candidates** against current Production content →
   classify valid / stale / conceptual-only / defective / unsupported.
5. **Wire a 5–10 profile slice** through the real Production-compatible loader
   and exercise numeric, symbolic, ECF, abstention, and mixed-criterion cases.
6. **Measure both** deterministic *criterion* ownership and deterministic
   *item* ownership — the latter governs the latency business case, since a
   mixed item still pays full model latency.
7. Only then migrate the remaining validated Statistics profiles.
8. **In parallel:** a small Calculus/Precalculus packet to test the Engine 3
   *ceiling* (86–92% keyable), separately from the Statistics *launch* track.
9. **Keep everything shadow-only** until held-out accuracy, abstention safety,
   and authoritative-grade behaviour are explicitly approved — noting that
   link 4 currently hard-codes `uncertain`, so "authoritative" is itself
   unbuilt, not merely ungated.

## 4. Two goals, kept separate (per Codex)

| Goal | Vehicle | Why |
|---|---|---|
| **Validate the Engine 3 platform** | Small high-yield Calculus/Precalculus slice | Highest deterministic ceiling (86–92%), fastest signal on whether the engine works at all |
| **Advance the Statistics launch** | Migrate + validate usable Statistics profiles, measure real contribution | Statistics is the committed first launch subject; a 24% ceiling is still worth having, and abandoning it does not serve the launch |

These should not be traded against each other, and the Calculus work must not be
presented as launch progress.
