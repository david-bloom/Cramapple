# QA Report — Work Order G, subject 1 of 8: AP Physics 1 (including the G.1 repair)

**Disposition: ACCEPTED.** The physics is correct, the G.1 span repair did what it claimed, and every
segmentation invariant passes. **G may proceed to subject 2 (`ap-physics-c-em`).**

Three findings are recorded. One is a content-free process gap that **must be fixed before the next
seven subjects**, because it multiplies by 182 FRQ if it is not.

This line is the DECISION-0055 independent cross-model QA gate for G's first subject and satisfies
G's STOP-for-QA-between-subjects rule.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-24
- **Producer:** Codex — original batch 2026-09-23, G.1 repair 2026-09-23
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout.

## Verified

| Check | Result |
| --- | --- |
| Packet vs Production | **identical on 5 of 5 field aggregates** across all 54 published Physics 1 FRQ |
| Scope | 39 items, exactly the 39 with a blank `canonical_answer_1` |
| Exact concatenation | 39 / 39 |
| Full criterion coverage | 39 / 39 |
| Invented criteria | 0 |
| **Span exclusivity (the G.1 repair)** | **0 of 176** criteria without an exclusive span; mean over-strike **0.00** |
| Physics re-derived by hand | **10 of 10 items correct** |
| Numeric tokens covered by `derivations[]` | 240 of 241 |

**The G.1 repair is real, not asserted.** Measured before and after:

| | Before | After |
| --- | ---: | ---: |
| Spans | 88 | **237** |
| Criteria with no exclusive span | 176 / 176 | **0 / 176** |
| Mean over-strike | 1.00 | **0.00** |
| Multi-criterion spans | 39 | **0** |

`G1_CHANGES.md` reports 16 items whose `full_text` changed and 23 byte-identical; concatenation and
coverage still hold on all 39. That matches what I measured.

## The physics

I re-derived ten items by hand, weighted toward the sixteen G.1 re-authored. All correct, including
the non-trivial ones:

- `apphy1-frq-035` — spring/friction/ramp: `h = kx²/(2mg) − μL`, and for double compression
  `h(2x) − h(x) = 3kx²/(2mg)`. Correct, and the answer explains *why* it is not a doubling (spring
  energy scales as x² while the friction loss is unchanged).
- `apphy1-frq-055` — conical pendulum: `r = 1.20 sin25° = 0.507 m`, `T = 0.500(9.80)/cos25° = 5.41 N`,
  `v = √(rg tanθ) = 1.52 m/s`, `T_p = 2πr/v = 2.09 s`. All four recompute.
- `apphy1-frq-038` — SHM energy: at `x = A/2`, `U = E/4` so `K = 3E/4`; `v₁ = (A/2)√(3k/m)`;
  for amplitude `2A` at `x = A`, `v₂ = A√(3k/m) = 2v₁`; period independent of amplitude. Correct.
- `apphy1-frq-np2-007` — `T = 2π√(0.50/200) = 0.314 s`, `f = 3.18 Hz`, `E = 1.00 J`,
  `v_max = 2.00 m/s`; the 0.157 s half-cycle reasoning is right, and the doubling case (T unchanged,
  E ×4, v_max ×2) is right.
- `apphy1-frq-047`, `-np1-008`, `-np1-009`, `-001`, `-012`, `-018` all recompute.

Rubric-restatement similarity averages **0.347**, which is comfortably in answer territory rather
than rubric echo.

## Finding 1 — the tightened `derivations[]` schema did not land, and `G1_CHANGES.md` says it did

This is the finding that matters, because G has **182 more FRQ across seven subjects** and
`derivations[]` is the field that lets QA re-derive instead of trust.

`G1_CHANGES.md` states: *"Derivations were regenerated under the tightened schema: each numeric
occurrence has a value-specific expression and label/value inputs."* Measured across all 442
derivations:

- **87% of `expression` values contain more than one distinct number**, so they are prose sentences
  carrying several values, not a formula for the one value. Example: value `6.00` with expression
  `"v=6.00 m/s and Δx=12.0 m from constant-acceleration relations."`
- **Every one of the 1,242 input labels is a generic placeholder** — `numeric operand 1` through
  `numeric operand 6`. B-QA-002 asked for the operands *named*; `{"label": "numeric operand 1",
  "value": "12.0"}` names nothing, so `6.00` still cannot be re-derived from its own derivation row.
- `kind: "looked_up"` is used **0 times**. Codex's defence — *"this Physics 1 batch contains no
  statistical table lookup"* — is a fair reading of my wording, which gave only statistical examples
  (`t*`, `z`, `χ²`). But `9.80` appears 22 times as a physical constant and is the Physics analogue.
  **That ambiguity is the work order's fault, not Codex's**, and is corrected below.
- 11 derivations (2%) carry empty `criterion_keys`.

**B-QA-002 is therefore not closed.** I could verify the physics only by re-deriving it myself from
the stem, which is exactly what the field exists to avoid.

## Finding 2 — `similarity_report.csv` missing; four spans over the hard threshold, unflagged

Work order F requirement 1a, which G inherits, requires a `similarity_report.csv` and says spans at
or above 0.85 similarity to their own criterion must not be emitted, with 0.70–0.85 emitted only
under a `restatement_justified` flag. G emitted **no `similarity_report.csv`** (F did), and four
span-criterion pairs sit at or above 0.85 with no flag:

| Item | Criterion | Similarity |
| --- | --- | ---: |
| `apphy1-frq-041` | `a-independent` | 0.89 |
| `apphy1-frq-038` | `part-a-criterion-03` | 0.89 |
| `apphy1-frq-049` | `a-independent` | 0.86 |
| `apphy1-frq-035` | `part-b-criterion-02` | 0.86 |

**All four are legitimate.** They are one-fact criteria where the criterion states the whole answer —
`"Concludes K=E-U=3E/4, so K>U"` against `"Consequently K=E-U=3E/4, so K>U."` There is no better way
to write that, and padding it would game the metric. The charter anticipates exactly this case and
says to flag it and leave the sentence alone. **The content is right; the flag and the report are
missing**, so a reader cannot distinguish "legitimately short" from "rubric echo" without redoing
the measurement. G's `flags[]` are also plain strings rather than typed objects, so no
`restatement_justified` type is expressible in the current shape.

## Finding 3 — the DECISION-0052 grader gate cannot be run on Physics at all

I attempted the 100% grader gate on this batch. It is unreachable:

```
qa_grade_frq: evaluate-attempt returned HTTP 409: {"error":"qa_path_ap_biology_only"}
```

The deployed handler contains `if (examPack.exam_code !== "ap_biology") return 409`. Combined with
the `canonical_answer_already_present` guard found during F's QA, the gate's true reach across the
whole published library is:

| | Count |
| --- | ---: |
| Published items | 1,346 |
| Published FRQ | 563 |
| AP Biology FRQ | 75 |
| — with a blank canonical (gate-reachable) | 7 |
| — of those, text-gradeable (not hand-drawn) | **3** |

**DECISION-0052's rule that "the production grader awards it 100% against its own rubric" can be
exercised on 3 of 563 published FRQ.** All 39 Physics 1 items have blank canonicals and would
otherwise qualify; they are refused on subject alone. This is not a G defect — it upgrades QA finding
F-QA-002 from "reaches 4% of Biology" to "reaches 0.5% of the FRQ library", and it means G's 221 FRQ
will complete with that gate never having been applied to any of them.

## What Codex flagged itself, and was right to

`open_questions.csv` raises that several stored Physics rubrics call for a **graph or diagram** while
the proposal supplies a precise textual description, because the artifact format carries text
(`apphy1-frq-033`, `-049`, `-052` among them). That is honest and it is the same structural question
as the hand-drawn items: a criterion about a drawn artifact cannot be earned by prose. Those items
should be checked against the Engine 4 spatial path rather than accepted as text.

Confidence is honestly spread — 34 `high`, 5 `medium` — with 60 flags across 39 items.

## What this disposition does and does not authorise

**Does:** satisfies the STOP-for-QA gate; **G may begin subject 2**.

**Does not:** ratify any answer, authorise a write to Production, or certify these answers under
DECISION-0052's 100% rule — that gate cannot be run on this subject. **Findings 1 and 2 should be
fixed before subject 2 rather than after subject 8**, since both are cheap now and multiply by 182
FRQ if deferred.
