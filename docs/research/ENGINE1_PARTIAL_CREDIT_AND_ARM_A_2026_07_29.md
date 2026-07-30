# Engine 1 — partial credit, uncertainty wording, and Arm A

**Date:** 2026-07-29
**Scope:** the four Engine 1 items in `GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` §2.
**Status:** built, tested, live-verified against the production model. **Not deployed.**
**Model used for all measurements:** `gpt-4.1-mini` — the model Production actually runs, not
the `google/gemini-2.5-flash` every Phase C number was measured on (handoff trap 1).

---

## 1. Owner decisions taken this session

| Question | Decision |
|---|---|
| Are multi-point criteria partial-credit or all-or-nothing? | **Partial credit is intended**, including error carry forward — correct method on a value carried forward from an earlier wrong step keeps its credit. |
| Session scope | Finish Engine 1: speed (Arm A) + correctness (partial credit, `uncertainty_reason`). |

---

## 2. Repo HEAD was behind Production

`grading-contract.ts`, `grading-feedback.ts`, `evaluate-attempt/index.ts`, `math-verifier.ts` and
`review-queue/index.ts` held the fixes deployed as v26/v25 on 2026-07-28 but had **never been
committed**. "Diff the repo against the deployed version" — the check whose absence caused the
25-minute outage that same day — had no valid reference point.

Committed verbatim as `26859a8` before any new work landed on top.

---

## 3. Partial credit

### The defect

`sanitizeModelResult` converted any `earned` criterion whose award was not exactly
`points_possible` into `unable_to_determine` with **zero** points, and the resulting integrity
issue marked the **entire grading** `uncertain`. A student earning 2 of 3 points received 0 points
and an unreliable-result verdict.

Re-counted against Production (the handoff's figures have moved with new content):

| points_possible | criteria | on published items | routed to Engine 1 |
|---:|---:|---:|---:|
| 1 | 2,368 | 486 | 2,072 |
| **2** | **382** | **47** | **361** |
| **3** | **219** | **77** | **197** |

**601 of 2,969 criteria (20%) are multi-point; 124 of those are already published.**

### Three changes, all required

Any one alone does nothing:

1. **Schema.** The status enum could not express partial credit, so the model could only signal it
   through `points_awarded` — which the sanitizer then read as a contradiction. Added
   `partially_earned`.
2. **Prompt.** Nothing told the grader it could award fewer points than `points_possible`, so it
   had no reason to ever return 1 or 2 on a 3-point criterion. **Removing the zeroing lets a
   partial award survive; it does not cause one.** The award range is also stated per-criterion,
   since multi-point criteria are the minority and a global instruction is easy to overlook.
3. **Sanitizer.** Status is now reconciled against `points_awarded` rather than zeroed on mismatch.
   `points_awarded` is already clamped to `[0, points_possible]` and is the more specific claim, so
   deriving status from it can never award more than the status alone would have.

### Guards deliberately kept

- A credit status paired with a **zero** award is still a hard integrity failure — no internally
  consistent reading of it exists. This is the residue of the old blanket check.
- The must-be-evidenced rule now covers `partially_earned`. It keyed off `earned` alone, which
  would have left an unevidenced-credit hole straight through the grounding check.
- Soft reconciliations go to a new `normalizations` list, **not** `integrity_issues`, so routine
  partial credit does not mark every multi-point grading unreliable.

### Verified live

Replaying the unmodified production request body against `gpt-4.1-mini` on a purpose-built
4-criterion, 7-point item whose correct award is 4/7:

```
model:      C1 partially_earned 2/3   C2 earned 1/1   C3 partially_earned 1/2   C4 not_yet_earned 0/1
sanitized:  identical
result:     4/7, status = graded
```

Correct, and stable across 3 of 3 trials. **Under the previous code the same response would have
scored 1/7 and been marked `uncertain`.**

### Also changed

- **Repair targeting** now ranks by points *remaining* rather than a criterion's face value, so a
  3-point criterion already worth 2 does not outrank an untouched 2-point one. Identical to
  previous behaviour for any criterion awarded zero, which is every gap under all-or-nothing
  scoring — single-point items are unaffected.
- **Migration** `20260729010000` widens the `attempt_criterion_results` status CHECK. **Not
  urgent:** that table has no writer — results persist as jsonb in
  `grading_results.criterion_results` — so the constraint is not on the live path. It would have
  become a landmine the first time the table was wired up.
- `scripts/grading-model-assessment/harness.ts` had to learn the status too. Its fallback is
  `unable_to_determine`, so omitting it would have silently reclassified every partial award as an
  abstention, moving those cases out of the accuracy denominator entirely.

---

## 4. The uncertainty message

A grading goes `uncertain` for two unrelated reasons — integrity failure, or the grader abstaining
— but every uncertain result was worded as an integrity failure. One caused purely by abstention
emitted the literal string **"Grading output failed 0 integrity check(s)"**. That reads to a tutor
as a broken grader rather than as the grader correctly declining to guess.

Each cause is now worded for what it is, and both are reported when both are present. A regression
test asserts the zero-count string can no longer be produced.

---

## 5. Arm A — the speed fix

### Result

4-criterion, 7-point item, `gpt-4.1-mini`, 3 trials:

| | Arm B (deployed) | Arm A (new) | |
|---|---:|---:|---|
| wall clock, median | 7,541 ms | **2,255 ms** | **3.34× faster** |
| per-call latency | — | 1,443 / 2,099 / 2,507 ms (min/med/max) | flat, tight tail |
| cost per item | $0.00140 | $0.00183 | 1.31× |
| award (correct = 4/7) | **4/7 — correct, 3/3** | 5/7 — **wrong, 3/3** | |

### The quality regression is real and reproducible

Arm A over-credits the 2-point `C3_graph` criterion 2/2 where 1/2 is correct, in **3 of 3** trials.
Arm B is correct in 3 of 3.

The mechanism is visible. `C3_graph` awards one point for describing an initially steep rise and
one for describing the curve flattening. The response says only *"On a graph it ends up flat at the
top"*. Seeing **only that criterion**, "flat at the top" reads as a complete description of the
curve. Seeing **all four criteria**, the grader has the response's full treatment of the graph in
context and notices the steep-rise element is absent.

This is precisely the mechanism Phase C hypothesised when it measured Arm B **+2.8 pp** on
criterion agreement (93.4% vs 90.6% pooled) — an effect it could not call significant and
explicitly recorded as "the hypothesis to test if a future run needs a quality lever". It now has a
reproducible instance.

**One item is not a corpus.** This does not establish an effect size. It does establish that the
effect is not hypothetical.

### A caution on the latency number

The **first** replay run measured Arm B at 18.0 s and Arm A at 13.2 s — a 1.4× win, not 3.3×, with
one criterion call alone taking 13.2 s. The three subsequent trials were tight (7.3–7.9 s and
2.2–2.5 s). The first run was almost certainly cold-start. **Both are reported because the tail
matters**: exam-week tail latency is brand-critical, and a single 13 s draw inside a max-of-N
fan-out sets the item's latency.

### Design decisions worth knowing

- **Ships default off** (`GRADING_ARM=b`). Arm A changes the request shape, the output schema, and
  the student-facing summary at once, on a grader that had never completed a Production grading
  until 2026-07-28.
- `GRADING_ARM` has a safe default, so **no Production secret is needed to deploy it** — unlike the
  entitlement gate, whose migration was absent.
- Each fan-out call gets **its own idempotency key**. Reusing the item's key would let the provider
  serve one criterion's cached response for every criterion on the item.
- Latency aggregates as **max**, tokens and cost as **sum**.
- **One criterion failing no longer loses the item** — its slot becomes `unable_to_determine` and
  the grading goes uncertain. Under Arm B a single failed call lost every criterion. This is a
  robustness gain independent of speed.
- `student_facing_summary` is **composed from the sanitized verdicts**, since no single Arm A call
  sees the whole item. Plainer than model prose, but it cannot contradict the awarded points.
  **This is a product-visible change.**
- `predicted_improvement` is recorded as **null**, not derived. That column is scored to measure
  how well the *model* forecasts; a computed value dressed as a prediction would corrupt the
  measurement.

---

## 5b. Priority order corrected, and the Arm A fix that failed

**Owner, 2026-07-29: Quality > Speed > Cost** — not Speed > Quality > Cost as previously recorded.
*"The cost is immaterial. We are still at one fifth of a cent."* The docs were already
inconsistent on this (`ARM_B_ROOT_CAUSE_ANALYSIS.md` §4 flagged that the Stage 6 prompt ordered
Quality first while the grader-priority memo said the reverse). **Quality first is the standing
order; treat any doc asserting Speed first as stale.**

Cost was the *only* thing Arm A bought by sending each call only its target criterion. Removing
that constraint, each call now gets the full rubric marked as do-not-grade context — targeting the
exact mechanism Phase C proposed.

**It did not work.** Three more trials, same item, correct award 4/7:

| | trial 1 | trial 2 | trial 3 |
|---|---|---|---|
| Arm B | 5/7 | 4/7 | 4/7 |
| Arm A, full rubric | 5/7 | 6/7 | 5/7 |

Pooled across both batches: **Arm B 5 of 6 correct; Arm A 0 of 6**, across both variants. Arm A
still never scores `C3_graph` correctly, and the full-rubric variant produced a 6/7 — its worst
result. Verified the sibling criteria really do reach the prompt, so this is a genuine null rather
than a plumbing bug.

**Two corrections to §5 above.** Arm B is 5 of 6, not 3 of 3 — it is less stable than first
reported. And criterion-blind Arm A was not uniquely bad; both variants fail the same way.

Context starvation was a plausible mechanism and is now the wrong explanation. Grading a criterion
in isolation makes the grader more generous for a reason that supplying the other criteria does
not fix.

### Methodological limit — important under a quality-first order

Ground truth in these runs is **my own reading of a rubric I wrote, on one synthetic item.** That
is not an adjudicated gold set. It is adequate to show a reproducible *difference between arms*;
it is **not** adequate to certify either arm's quality. Governance requires 300+ dual-blind
adjudicated held-out responses and none exists for any production question.

### The larger lever this exposes

Under Quality > Speed > Cost with cost immaterial, **the model is a bigger lever than the request
architecture.** `gpt-4.1-mini` takes ~2 s for a single 1-point criterion where Phase C measured
`gemini-2.5-flash` at 1.4 s p50 per call, and it is `gpt-4.1-mini` that is making these
over-crediting errors. Testing a stronger model is cheap, is now unconstrained by cost, and could
improve quality *and* speed at once — which no arm choice can do. **This should probably outrank
the Arm A question.**

---

## 5c. SUPERSEDED: the synthetic-rubric findings

**2026-07-30.** The C3_graph over-crediting used throughout §5 and §5b came from a rubric I wrote
myself, and that rubric is **not representative of the real bank**. See
`RUBRIC_DECOMPOSITION_AND_PARTIAL_CREDIT_2026_07_30.md`:

- The overlapping-element defect that made C3 ambiguous is structurally impossible in real
  Cramapple content, where criteria are partitioned one per question part.
- On real criteria the grader leans **under**-credit (full marks on only 7 of 10 complete
  answers), the opposite of the over-crediting seen on the synthetic item.

**Consequence for Arm A:** the quality evidence in §5 is from the discredited instrument. Arm A
should stay default-off — nothing here argues for shipping it — but the "0 of 6 vs 5 of 6" result
must be **re-measured on real criteria** before the arm decision is treated as settled.

## 6. What is NOT done

- **Nothing is deployed.** Repo HEAD is now ahead of Production by this session's three commits.
- **The Arm A A/B has not been run on a real corpus.** The 3.34× speed win and the C3 regression
  are both n=1 item. The narrow pilot re-run should score both arms on multi-point content.
- **`EVALUATE_ATTEMPT_PROMPT_VERSION` has not been bumped.** The grading prompt changed materially
  (partial credit + ECF instructions), so results before and after are not comparable. It is a
  Supabase secret, not code — it must be bumped in the same change that deploys this.
- **Engine 1 still never abstains and has no escalation path.** Untouched this session.
- **The four unmeasured feedback-quality dimensions remain unmeasured.**

---

## 7. Recommended next steps

Reordered for **Quality > Speed > Cost**.

1. **Bump `EVALUATE_ATTEMPT_PROMPT_VERSION` and deploy with `GRADING_ARM` unset (Arm B).** This
   ships partial credit and the uncertainty fix — both pure quality wins — with zero architecture
   change and no quality risk. Nothing below blocks it.
2. **Test a stronger model.** Cost is immaterial and quality is first, which makes this the
   highest-value experiment available: it is the one lever that can improve quality *and* speed
   together, where no arm choice can. `gpt-4.1-mini` is both the slow component and the thing
   making the over-crediting errors.
3. **Build a multi-point pilot corpus with real labels.** The narrow pilot's 6 items are all
   single-point and cannot test partial credit at all. Under a quality-first order, arm and model
   decisions cannot rest on self-authored ground truth.
4. **Only then decide Arm A**, on that corpus. As it stands Arm A is 2.5–3.3× faster and 0 of 6
   correct where Arm B is 5 of 6. Under Quality > Speed that is a reject, and the obvious fix has
   already been tried and failed.
