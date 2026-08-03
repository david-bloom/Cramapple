# β2-A — Abstention & Escalation Avoidance: Results

**Date:** 2026-07-28
**Question:** Does strengthening rubric boundaries with an explicit `abstention_policy`
make the grader correctly abstain on genuinely undecidable responses — the
escalation-avoidance half of the owner's thesis, which β1 could not test?
**Verdict:** **GATE FAIL, and the failure is not the one we were testing for.**
The grader does not abstain **at all**, before or after. Boundary text is not the
binding constraint — abstention is effectively absent as a behaviour.
**Cost:** $1.3524 (1,512 calls, no budget stop). Cumulative Phase C spend: **$2.83**

---

## 1. Headline

| | `amb_pre` (original) | `amb_post` (revised + `abstention_policy`) |
|---|---:|---:|
| **Abstention recall** (gold ambiguous → abstained) | **2/56 = 3.6%** | **1/55 = 1.8%** |
| **Over-abstention** (gold decidable → abstained) | 0/692 = 0.0% | 0/692 = 0.0% |
| Accuracy on the decidable subset | 96.5% | 96.8% |
| p50 / p90 latency | 1,937 / 5,885 ms | 1,889 / 4,079 ms |

**Paired McNemar on the abstention decision (n = 740 paired):
1 fixed, 2 broken, p = 1.00.** On the 174 paired labels whose criterion actually received a
revised contract: 1 fixed, 1 broken, p = 1.00. **The `abstention_policy` field did nothing.**

## 2. What actually happened

Of **56 criterion labels that independent blind adjudicators judged genuinely undecidable**,
the grader returned a confident verdict on **54**:

| | earned | not_earned | unable_to_determine |
|---|---:|---:|---:|
| `amb_pre` | 24 | 30 | **2** |
| `amb_post` | 30 | 24 | **1** |

Note the near-mirror flip: 24/30 becomes 30/24. On input where no correct answer exists, the
verdict distribution is close to arbitrary. Directly measured: **pre and post agreed with each
other on only 41 of 55 ambiguous cases (75%)** — meaning roughly a quarter of genuinely
undecidable responses flip verdict on nothing but a change in boundary-text length. On
decidable input the same two conditions agree far more tightly.

**Every one of these verdicts was returned at `confidence: "high"`.**

## 3. The instruction was already there — this is not a missing-prompt bug

The frozen Arm A base prompt already says, explicitly:

> "Use status=unable_to_determine (not not_earned) when the response is genuinely ambiguous
> rather than clearly absent/wrong."

So the model was told, in both conditions, when to abstain, and the schema has always accepted
the value. Adding 30 hand-authored `abstention_policy` fields enumerating specific observable
conditions on top of that changed the behaviour by **one label out of 740**. The failure is not
that we forgot to ask. **The model will not abstain when asked in prompt text.**

## 4. Why this matters more than the accuracy result

β1 showed boundary strengthening buys real accuracy (+6.5 pp, p = 0.0004). That still stands.
But the operating model assumed a second mechanism: sharpened boundaries let the grader
recognise genuinely hard cases and route them to a human instead of guessing. **That mechanism
does not exist in the current system.**

The consequence is concrete: **there is presently no escalation path out of Engine 1.**

- 7.4% of this corpus was genuinely undecidable.
- 96% of that received a confident, high-confidence, essentially arbitrary grade.
- Nothing was flagged. Nothing routed to a tutor. A student on the wrong side of the coin flip
  receives a wrong grade with authoritative feedback and no signal that anyone should look.

This is the same failure shape as Engine 3's Bug 1 — silent, confident, and against the
student — but it is behavioural rather than a code defect, so no test suite would catch it.

The natural rate of genuine ambiguity in Engine 1's domain is ~0.7% (§B2 corpus note). At the
Aug-2026 beta scale (~2,500 AP Biology students) that is still a steady stream of ungradeable
responses being silently graded. Adjudication capacity was explicitly *not* considered a
bottleneck — tutors will be hired — so the cost of this gap is not capacity. It is that
**nothing ever reaches the tutors.**

## 5. Confidence is not merely uninformative — it is inversely useful

| | `amb_pre` | `amb_post` |
|---|---|---|
| All labels | 748 high, 0 medium, 0 low | 746 high, 1 medium, 0 low |
| On gold-ambiguous input | **56 high** | 54 high, 1 medium |
| On the grader's own errors | **78 high** | 76 high |

β1 found confidence uninformative on ordinary input. β2 tested the case that could have
rescued it — input that is *objectively* undecidable — and it still reports `high` **100% of
the time**. A field that reads `high` on genuinely ungradeable content cannot be used for
triage, routing, or any confidence-gated release. It should be treated as a constant and
either removed or replaced.

## 6. What was NOT damaged

The revised contracts did not hurt anything:

- accuracy on the 692 decidable labels: 96.5% → 96.8%
- over-abstention stayed at exactly 0.0% in both conditions
- p90 latency actually improved (5,885 → 4,079 ms)

So this is a **null result on abstention, not a regression**. β1's recommendation to continue
boundary authoring for accuracy is unaffected. What fails is only the claim that the same
mechanism buys escalation.

Also worth noting: accuracy on the decidable subset (96.5%) sits **above the ≥95% bar**, unlike
Stage 6's 90.6%. That is not evidence the bar is cleared — this corpus is deliberately
unrepresentative (88% of non-target gold labels are `earned`, and the items are the 21 already
targeted by β1). It is not a launch-readiness number.

## 7. Honest accounting

- **17 of 1,512 calls (1.1%) returned unparseable output** ("No object generated"), split 8 pre
  / 9 post. They are excluded from all figures above. This is a real schema-adherence failure
  rate that should be tracked separately; at beta scale it is not negligible.
- **A partial paid run was burned.** The job was first launched in the foreground, hit a
  10-minute cap, and — because the script only wrote results at completion — produced no data
  for the money spent (est. $0.50–0.70, not precisely recoverable since nothing was written).
  The script now checkpoints every response-group to `raw/b2_ambiguity_cells.jsonl` and resumes
  from it. **Lesson: any paid run must write incrementally before it writes anything else.**
- Corpus construction, class-validity rates, and the blinding protocol are documented in
  `B2_AMBIGUITY_CORPUS_CONSTRUCTION.md`. Three of six seeded ambiguity classes failed to
  produce genuine ambiguity and were diagnosed rather than discarded silently.

## 8. Recommendation — stop trying to buy abstention with prompt text

The evidence says asking harder does not work: the instruction was present in both conditions,
30 targeted policies were added, and the effect was one label in 740. Three options remain, in
priority order:

1. **Detect ambiguity outside the grading call.** The three empirically-valid ambiguity classes
   are largely *structural* and cheap to detect deterministically or with a tiny dedicated
   check — competing incompatible assertions, truncation mid-assertion, and load-bearing
   references to absent artifacts. A6 in particular (reference to a sketch/table that is not
   present) is close to a regex. This does not depend on the grader's judgement at all, and it
   is the shape already used for `detectAmbiguousTypedFormulaText` in Engine 3.
2. **Make escalation a routing decision, not a model verdict.** Disagreement between two cheap
   independent grades is an observable proxy for undecidability — and we now have direct
   evidence it works: pre/post disagreed on 25% of ambiguous input versus far less on decidable
   input. β2-B (repeat runs) will quantify this properly, and it needs no new model capability.
3. **Audit the 30 `abstention_policy` fields against the corpus finding** that absent content is
   decidable. Any clause instructing abstention on *absence* manufactures escalations rather
   than preventing them. They are currently inert, so this is not urgent — but they must not be
   activated as written.

**Do not report escalation avoidance as a validated property of boundary strengthening.** It was
tested directly, at adequate power, and it did not occur.

## 9. Status of the owner's thesis, stated precisely

> "A body of grading actions allowed us to strengthen the rubric boundary and better handle edge
> cases, thus avoiding time-consuming escalations."

- **"Strengthen the rubric boundary"** — **validated** (β1: +6.5 pp on fresh answers, p = 0.0004,
  +28.2 pp on treated criteria, no collateral damage).
- **"Better handle edge cases"** — **validated for decidable edge cases** (under-credit fell 41%),
  **refuted for undecidable ones** (the grader does not recognise them).
- **"Avoiding time-consuming escalations"** — **not applicable as stated.** There are no
  escalations to avoid, because the system never escalates. The real gap is the opposite of the
  one assumed: not too many escalations, but none at all.
