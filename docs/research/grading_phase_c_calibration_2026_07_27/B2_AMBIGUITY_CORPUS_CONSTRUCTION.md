# β2-A — Constructing an Ambiguity Corpus: what "undecidable" actually turned out to mean

**Date:** 2026-07-28
**Purpose:** β1 validated that boundary strengthening improves accuracy but could **not**
test the owner's escalation-avoidance claim, because the corpus contained no ambiguous
cases for `abstention_policy` to act on. This note records how the ambiguity corpus was
built, and a substantive finding that emerged from building it.
**Cost:** $0 — corpus generation and adjudication are unpaid agent work.

---

## 1. Why ambiguity has to be seeded rather than observed

| source | ambiguous labels |
|---|---|
| β1 fresh gold (252 labels) | **0** |
| Stage 3 gold, as previously reported | 14/434 = 3.2% |
| Stage 3 gold, HDG-GRAPH items removed | **3/409 = 0.73%** |

The 3.2% figure was inflated: 11 of the 14 sit on `HDG-2026-GRAPH` items, which are Engine 4
spatial content being scored as text. **Genuine Engine 1 ambiguity is ~0.7%.** At that rate a
naturally-sampled corpus would need thousands of labels to yield enough ambiguous cases to
measure anything. Seeding is not a shortcut here; it is the only feasible design.

## 2. Design

- **21 items** — the β1 targets, whose revised contracts carry substantive `abstention_policy` text.
- **126 responses**, each seeded on exactly one criterion, the rest written as ordinary decidable work.
- **Generation was blind to the revised contracts.** The writer saw the criterion construct and
  an abstract ambiguity class, never the `abstention_policy` text it is meant to trigger.
  Showing it the policy would let the post cell win by construction.
- **Gold adjudication was blind** to seed labels, seed classes, and the revisions, in shuffled order,
  against the **original** rubric — so the measurement asks "is the grader *correct*", not
  "does the grader obey the revision".
- **42 of the responses are decisive controls**, carrying surface features that mimic ambiguity.
  Without them a grader that abstained on everything would post perfect abstention recall.

## 3. The finding: absent content is decidable; only present content can be ambiguous

Six ambiguity classes were tried. Three work and three do not, and the split is not random.

| class | idea | gold-ambiguous | verdict |
|---|---|---:|---|
| A6 offloaded to absent artifact | load-bearing content in a "see my sketch" that isn't there | 17/18 = **94%** | **works** |
| A3 truncated mid-assertion | proposition cut off, plausible either way | 14/17 = **82%** | **works** |
| A1 competing unresolved claims | two incompatible assertions, nothing marks which is final | 22/27 = **82%** | **works** |
| A4 ambiguous notation | expression readable two non-equivalent ways | 1/7 = 14% | fails |
| A2 unresolvable referent | claim whose target can't be pinned down | 1/8 = 12% | fails |
| **A5 assertion absent** | describes the procedure, never asserts the conclusion | **0/7 = 0%** | **fails completely** |

**A5 failing at exactly zero is the informative result, and it was a design error of mine, not
an adjudication error.** A response that describes what one would do without ever asserting the
conclusion is not undecidable — a careful reader decides `not_earned`, correctly, every time.
Most of A2 and A4 failed the same way: adjudicators resolved the referent or the notation from
surrounding context instead of guessing.

The rule this yields:

> **Ambiguity arises from content that is present-but-competing or present-but-unreadable.
> It never arises from content that is missing. Missing content is decidable.**

This has direct consequences beyond this experiment:

1. **`abstention_policy` fields should be audited against it.** Any policy clause instructing
   abstention on *absence* is wrong and will manufacture escalations — the grader should return
   `not_earned`, not route to a human. Several β1 policies enumerate illegible/image conditions,
   which are genuine (unreadable), but "no statement defining it" style clauses need review.
2. **It bounds the escalation ceiling.** If only competing/unreadable content is legitimately
   ambiguous, the population needing human adjudication is small and structural — consistent
   with the measured ~0.7% natural rate.
3. **It explains why A6 scores highest.** An absent artifact is not missing content; it is
   *present but unreadable* content — the student asserted something and the assertion cannot
   be read. That is the purest ambiguity shape available in a text corpus.

## 4. Final corpus

| | |
|---|---:|
| Responses | 126 |
| Gold labels | 756 |
| **Gold-ambiguous** | **56 (7.4%)** |
| Gold-decidable | 700 |
| Ambiguity confined to the targeted criterion | 55/56 |
| Control responses whose gold was ambiguous | **0/42** |

Two properties make the corpus trustworthy:

- **Controls held perfectly.** All 42 came back decidable — hedged-but-assertive → earned,
  self-corrected → earned on the final version, verbose-but-decisive → earned, confidently
  wrong → not_earned. Nothing about surface confusion drove adjudicators to abstain.
- **Seeding was surgical.** Of 630 non-target criterion labels, exactly **1** came back
  ambiguous. The ambiguity landed where it was aimed and nowhere else, so the non-target
  labels form a large clean control surface.

The top-up round (42 additional responses, A1/A3/A6 only, with an explicit instruction to
state the case for both verdicts before writing) also *raised* hit rates — A1 75%→82%,
A3 71%→82% — confirming the classes were sound and the first round's prompt was the weak link.

## 5. What this does not yet establish

This note covers corpus construction only. Whether the revised `abstention_policy` fields
actually improve abstention calibration — in either direction — is the paid pre/post
comparison, reported separately in `B2_ABSTENTION_RESULTS.md`.
