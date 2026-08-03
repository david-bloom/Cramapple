# β2-B — Verdict Stability, and Whether Disagreement Can Serve as the Escalation Signal

**Date:** 2026-07-28
**Question:** β2-A showed Engine 1 never abstains, so escalation cannot come from the model's
own introspection. Can it come from **disagreement between runs** instead — and is that
disagreement available for free at temperature 0, or must it be induced?
**Verdict:** **Disagreement is free and highly specific, but far too insensitive to be the
escalation mechanism on its own.** Precision 62.5% against a 7.4% base rate; recall 18.5%.
**Cost:** $1.2766 (1,512 calls). Cumulative Phase C spend: **$4.11**

---

## 1. Verdict stability under identical inputs — the reliability number the program was missing

Three replicates of the identical prompt, identical model, temperature 0, thinking disabled.
728 criterion labels with all three replicates and a gold label.

| pair | overall agreement | on decidable input | on ambiguous input |
|---|---:|---:|---:|
| r1–r2 | 98.4% | 99.3% | 87.0% |
| r1–r3 | 98.9% | 99.6% | 90.7% |
| r2–r3 | 98.4% | 99.4% | 85.2% |

**Overall instability: 2.2%** (16 of 728 labels where the three replicates did not all agree).

This is the first direct measurement of Engine 1 run-to-run reliability, and it is **good on
ordinary content — 99.4% self-consistent on decidable input.** Temperature 0 is doing its job.
A reliability claim for the grader can now cite a number instead of an assumption.

## 2. The instability is almost entirely concentrated on genuinely undecidable content

| | unstable | n | rate |
|---|---:|---:|---:|
| gold **ambiguous** | 10 | 54 | **18.5%** |
| gold **decidable** | 6 | 674 | **0.9%** |

**A 20.8× enrichment.** The grader is not randomly flaky. It is stable exactly where a stable
answer exists, and unstable exactly where no correct answer exists. That is the behaviour you
would want from a well-calibrated system that simply lacks a way to say so.

This also answers the open question from β2-A: identical prompts at temperature 0 **do**
disagree on hard input. The signal does not have to be manufactured.

## 3. As an escalation trigger — high precision, unusable recall

Trigger = "the three replicates did not all agree."

| | 3× identical replicates | induced diversity (original vs revised prompt) |
|---|---:|---:|
| **Recall** (undecidable labels caught) | **18.5%** | 24.5% |
| **Precision** | **62.5%** | 54.2% |
| Volume escalated | 2.2% of all labels | 3.3% |
| Base rate for comparison | 7.4% | 7.4% |

Both variants are **8× better than chance at precision** — when they fire, they are usually
right, and the escalation volume is small enough that tutor capacity is a non-issue.

**But recall is the whole problem.** Catching 18.5% of undecidable work means **81.5% of it
still receives a silent, confident, arbitrary grade.** As a safety mechanism that is not
adequate, and it should not be described as solving the escalation gap.

Inducing diversity with a different prompt buys a little recall (18.5% → 24.5%) at the cost of
precision (62.5% → 54.2%) and volume. Neither is close to sufficient. **Sampling more is not
the answer** — the failure is not noise, it is that the model confidently commits to one side
of a genuine ambiguity and does so *reproducibly*.

## 4. Combining with structural detection — better, still not enough

Disagreement catches the shapes unevenly:

| ambiguity shape | caught by disagreement |
|---|---:|
| A6 reference to an absent artifact | 6/16 = 38% |
| A1 competing unresolved claims | 3/23 = 13% |
| A3 truncation mid-assertion | 1/13 = 8% |

A6 is the shape most amenable to **deterministic** detection — a load-bearing reference to a
sketch, table, or diagram that is not present is close to a regex, costs ~0 ms, and needs no
model call. Assuming a structural detector catches A6 perfectly and disagreement handles the
remainder:

| | recall |
|---|---:|
| disagreement alone | 18.5% |
| structural A6 alone | 30% |
| **union** | **37%** (20/54) |

Still missing **34 of 54** — predominantly A1 (20) and A3 (12): competing unresolved claims and
truncation mid-assertion. Both are structural in principle (two incompatible assertions about
one quantity; a proposition that terminates before completing) but neither is a regex. They are
the next detection problem, and they are where the remaining recall lives.

## 5. Honest read

**What is now established:**
- Engine 1 run-to-run reliability is **97.8% overall, 99.4% on decidable content**. Real number, first time measured.
- Instability is **20.8× enriched** on undecidable content — a genuine, free, high-precision signal.
- A disagreement-triggered escalation would fire on ~2% of labels at ~62% precision.

**What is not:**
- Disagreement **does not close the escalation gap.** 81.5% of undecidable work still passes silently.
- Union with the one easy structural detector reaches ~37% recall. Better, not sufficient.
- Nothing here has been tested outside the 21 β1 items, which are the known-hard subset.
- The corpus is seeded, so these rates describe behaviour *on ambiguous content*, not the
  end-to-end rate a student would experience.

## 6. Recommendation

1. **Ship disagreement-triggered escalation anyway.** 62% precision at 2% volume is cheap, is
   free of wall-clock cost if the replicate runs in parallel, and converts ~1 in 5 silent wrong
   grades into a human review. Partial mitigation beats none. Cost is 2–3× tokens on a
   $0.0039/FRQ base — about $0.0117/FRQ, still well inside the $0.03 ceiling, and Speed > Cost
   in the stated priority order.
2. **Build the A6 structural detector.** Near-regex, ~0 ms, ~30% recall on its own. Highest
   return per unit of effort in this whole result.
3. **Treat A1 and A3 detection as the open research problem.** They hold the remaining ~63% of
   recall and neither prompt-based abstention nor replicate sampling touches them.
4. **Do not claim the escalation gap is closed.** State the recall number whenever the
   mechanism is described. A safety feature that catches under 40% of the cases it exists for
   must be reported with that figure attached.
5. **Report grader reliability as 99.4% on decidable content** — this is a legitimately good
   result and should be used where a reliability claim is needed, with the ambiguous-content
   caveat stated alongside it.
