# QA Report — Work Order B (AP Statistics Canonical Answers)

**Disposition: the 46 canonical answers are ACCEPTED as content. Their `spans[]` segmentation is
REJECTED and must be re-cut before Open Hand ingests it.**

That split is deliberate. Every answer is statistically correct and well written; what fails is the
criterion-level strike mechanic the spans exist to provide. The text can proceed to Product Owner
ratification; the segmentation cannot ship as it stands.

This line is the DECISION-0055 independent cross-model QA gate for work order B. It ratifies nothing.

- **QA model:** Claude Opus 5 (non-OpenAI, independent of the Codex builder), 2026-09-23
- **Producer:** Codex, snapshot `2026-09-23T01:46:31Z`, run end `02:08:26Z`
- **Production:** `pcntajvbdfqhbeewmdry`, read-only throughout. No writes, no migrations. The 34
  out-of-scope items were not touched.

## Verification method

Every count was recomputed from Production or from the artifacts before `SUMMARY.md` was read.

1. **Packet re-derived against Production**, as nine independent field aggregates over all 80
   published AP Statistics FRQ — content keys, version ids, version numbers, md5 of both canonical
   fields, md5 of stem and stimulus, criterion counts and point sums. **All nine match.**
   *(A first comparison appeared to differ on eight of nine; that was my own error — Postgres's
   default collation orders `apstats-frq-*` before `APSTATS-HDG-*` while Python sorts by byte. Re-run
   with `COLLATE "C"` the aggregates agree exactly. The packet was never in question.)*
2. **Scope confirmed independently:** 80 published FRQ, **46** with both canonical fields blank, 34
   already answered. Matches the work order exactly, 0 drift.
3. **Mechanics:** concatenation, criterion coverage, invented criteria, removal-non-empty, and the
   prohibited second-person phrasing check.
4. **Numeric contract:** every numeric token in every answer checked against `derivations[]`, then
   all 55 distinct computed derivations re-derived independently.
5. **Authoring quality:** each authored span scored against its own `learner_facing_text`, using the
   check added to `scripts/qa/overnight_qa_harness.py` after work order A's QA.
6. **Strike behaviour:** for each of the 240 criteria, measured how much of the text struck by
   deselecting it is *exclusive* to that criterion.

## Independently confirmed

| Claim | Independent result | Verdict |
| --- | --- | --- |
| 80 published AP Statistics FRQ; 46 blank, 34 answered | 80 / 46 / 34 from Production | Confirmed |
| Packet matches Production | 9 of 9 field aggregates identical across all 80 items | Confirmed |
| Spans concatenate exactly to `full_text` | 46/46 | Confirmed |
| Every stored criterion covered | 46/46, 0 uncovered | Confirmed |
| No invented criteria | 0 violations | Confirmed |
| Every number in the answer appears in `derivations[]` | 0 orphans among **618** numeric tokens | Confirmed |
| No second-person rubric phrasing | 0 occurrences | Confirmed |
| The 34 out-of-scope items untouched | 0 proposal rows for them | Confirmed |
| 240 criterion rows, 246 stored points | 240 / 246 (the extra 6 are `apstats-frq-u12-005`) | Confirmed |
| `criterion_ledger.csv` agrees with the proposal | 240 rows, 0 disagreements | Confirmed |

## Statistical correctness: all 55 computed derivations are right

This is the part of B that mattered most, and it is excellent. I re-derived every distinct computed
expression. A representative set:

- **Chi-square independence test** (`APSTAT-MOD7-H002-INV`): expected counts from margins
  (200,200,100)×(310,190)/500 give (124, 76, 124, 76, 62, 38); Σ(O−E)²/E recomputes to **52.207**
  against the stated 52.21, df = 2, p < 0.0001. The two-way table's own margins reconcile.
- **Welch t-tests**: (68−72)/√(6²/25+5²/25) = **−2.561** with Satterthwaite df **46.5** (stated
  −2.56, "about 47"); (76−72)/√(7²/30+8²/30) = **2.061** with df **57.0** (stated 2.06, 57).
- **One-sample t interval**: t*(29) = 2.045, 120/√30 = 21.909, margin **44.80**, interval
  (805.2, 894.8) — all correct, and the follow-on test t = 50/21.909 = **2.282**, p ≈ 0.015.
- **Binomial / normal approximation**: σ = √(200·0.06·0.94) = **3.3586**; continuity-corrected
  z = 6.5/3.3586 = **1.935**, p ≈ 0.0265.
- **Expected value and variance**: E(Y²) − [E(Y)]² = 8,000,000 − 160,000 = **7,840,000**, SD **2,800**.
- Every conditional and marginal proportion in the two-way-table items reconciles to its margins.

The only imprecision I found anywhere is `apstats-frq-u12-011(c)`, which states z = 1.333 and then
reports 0.0918 — the table value for z = 1.33 (the exact value gives 0.0912). That is standard AP
table practice and is not an error.

**B also avoids the failure work order A fell into.** Scored against their own criterion text, B's
authored spans have a mean word-level similarity of **0.167 with zero at or above 0.70**, versus A's
**0.582 with 15 at or above 0.85**. B wrote answers; A largely echoed the rubric.

## The rejection: 81% of criteria cannot be struck independently

The work order states the purpose plainly: *"Spans exist so that deselecting a rubric point can
strike exactly the text that earns it."*

- **195 of 240 criteria (81%) have no span of their own.**
- Mean over-strike — text removed that is *not* exclusive to the criterion — is **0.82**. For those
  195 it is **1.00**: every character struck is shared with another criterion.
- The 20 `apstats-frq-u12-*` items are the worst case: **10 criteria across 6–8 spans**, segmented by
  response part rather than by criterion.

Concretely, `apstats-frq-u12-001` has 10 criteria and 4 content spans, one per part. Striking
`part-d-criterion-03` ("Explains why a histogram would be inappropriate") strikes the entire (d)
paragraph, taking `part-d-criterion-01` and `-02` with it.

**The builder disclosed this** as open question B-005 and, to its credit, wrote in `SUMMARY.md` that
the "removing any one criterion never empties the answer" invariant is satisfied only by the
uncredited `Response:` span and "does **not** imply criterion-level fine-grained strike behavior."
It asked QA to assess whether finer segmentation is required. **It is** — this report is that answer,
with the measurement attached.

**The fix is mechanical, not a re-authoring.** The shared spans are multi-sentence, and their
sentences already map one-to-one onto the criteria they serve. Splitting at sentence boundaries
closes the finding with `full_text` unchanged and every other invariant preserved.

**One spec lesson worth carrying forward:** the work order's invariant table has no "each criterion
has text exclusive to it" row, which is why a run that satisfies every stated invariant still fails
its stated purpose. Work order G authors 221 FRQ on the same pattern. Add the row before G runs.

## Recorded, not blocking

- **B-QA-002** — `derivations[]` is complete but not mechanically re-derivable: `inputs` carries a
  boilerplate source quote rather than operands, and `expression` repeats the whole answer sentence
  for each value in it. Looked-up critical values (`2.045`, `1.2816`) are tagged `computed`. I could
  verify everything by reading, but a second model should not have to parse arithmetic out of prose.
  Worth tightening for G.
- **B-QA-003** — the builder self-declares (B-004) that the protocol prefers a non-OpenAI author
  where an OpenAI model grades later, and that the sanctioned external route was unavailable. The
  work order did assign Codex the authorship and DECISION-0052 names it as drafter, so this is not a
  breach — but it is a Product Owner confirmation, and these answers must not be used as gold-set
  evidence under DECISION-0045.
- **`APSTAT-MOD4-H001-INV`** — the builder flagged that the prompt cites p ≈ 0.014 while the
  directional alternative gives ≈ 0.007. Its handling is correct: it used the one-sided value
  consistent with the stated alternative and flagged the discrepancy rather than silently picking
  one. The stored item is what should be confirmed here, not the answer.
- **`apstats-frq-u12-005`** — the 4-criteria/10-point rubric anomaly was recorded as instructed and
  authored against as stored. Independently confirmed against Production.

## What this disposition does and does not authorise

**Does:** satisfies DECISION-0055's independent cross-model QA gate for work order B. The 46 answers
may go to the Product Owner for ratification as text.

**Does not:** authorise any write to Production, and does not clear the segmentation for Open Hand.
Until the spans are re-cut, striking a rubric point will remove text earning other points.
