# ap_calculus_ab — Topic Labelling Run (TASK-0050 prerequisite)

**Run:** `topics-ap_calculus_ab-20260929100918` · **Started:** 2026-09-29T10:09:18.484Z
**Models:** proposers `openai/gpt-5.5`, `google/gemini-2.5-pro`; blind adjudicator `anthropic/claude-opus-5`, all three on every item.
**Nothing was applied.** The SQL file is written, never executed.

## Outcome

| | Items |
| --- | --- |
| Accepted (>= 2 of 3 agreed) | 119 |
| — unanimous 3/3 | 103 |
| — majority-earned 2/3 | 16 |
| Held (no majority) — NOT written | 3 |
| **Total** | **122** |

**Proposer agreement:** 105/122 = 86.1%.
Compare the skill pass on AP Statistics, which reached 85.6% choosing 1 of 2-6 inside a
fixed topic, and `TAXONOMY_LABELING_PLAN_V3`'s 44% at this ~81-way granularity.

## Resolution by strength of the unit prior

This is the number that says whether the pass is trustworthy where it has no help.

| Prior | Items | Accepted | Held |
| --- | --- | --- | --- |
| validated | 36 | 36 | 0 |
| provisional_model | 43 | 41 | 2 |
| held | 43 | 42 | 1 |

## Where the chosen topic contradicts the existing unit label

Recorded rather than absorbed: a disagreement with a **validated** unit is evidence
about that unit label, and should be looked at before either is trusted.

- Contradicts a **validated** unit: **0**
- Contradicts a provisional unit: 0

## Held items

| Item | Prior | Votes |
| --- | --- | --- |
| `apcalcab-frq-022` | provisional_model | gpt-5.5=8.7, gemini-2.5-pro=8.3, claude-opus-5=8.11 |
| `apcalcab-mcq-005` | provisional_model | gpt-5.5=2.8, gemini-2.5-pro=3.1, claude-opus-5=3.5 |
| `apcalcab-mcq-045` | held | gpt-5.5=7.4, gemini-2.5-pro=4.6, claude-opus-5=7.7 |

**Gateway spend:** $4.0259 across 366 calls.
---

## Content defect found by this run: three AB items test BC-only content

The pass surfaced something a prior audit explicitly concluded was not there. Three published
`apcalcab-*` items assess topics the CED marks **BC-only**, which is why no AB topic fits them:

| Item | Content | BC-only topic | Outcome |
| --- | --- | --- | --- |
| `apcalcab-mcq-045` | Euler's method | **7.5** | **Held** — no majority, because no AB topic exists |
| `apcalcab-mcq-046` | Logistic model `dP/dt=0.18P(1−P/900)` | **7.9** | Forced to 7.1, adjudicator confidence **0.40** |
| `apcalcab-mcq-050` | Arc length of `y=x²` | **8.13** | Forced to 8.3, adjudicator confidence **0.35** |

All three are `status='published'` on a published version.

**The models said so themselves, unprompted.** `claude-opus-5` on mcq-045: *"Euler's method (BC topic
7.5) is absent from the list"*; on mcq-050: *"Arc length isn't an AB topic"*. They were never told
which topics are BC-only — they inferred it from the AB topic list being complete and the item not
fitting it.

**Low confidence is a precise detector here.** Exactly two accepted items had any model at or below
0.40 confidence, and they are exactly the two BC-content items that were forced into a nearest fit.
No false positives.

**Two independent passes failed on the same three items.** All three also carry
`label_status='held'` from the earlier *unit* labelling pass. Two passes, different granularity,
same three items — because the items do not belong to this subject at all. The `held` bucket is
carrying real signal, not noise.

### This contradicts the fact pack's own record

`AP_CALCULUS_AB_BC_CED_FACT_PACK.md` states, in its Source control note and again at topic 8.13:

> checked the live Production corpus for any `apcalcab-*` item authored on arc length before fixing
> the claim — none found, no live defect from this specific error.

`apcalcab-mcq-050` is exactly such an item. The claim is false as of today — either the check missed
it or the item was authored afterwards.

### And the fact pack contradicts itself on Euler's method

- Line 137: *"Euler's method and logistic differential equations are shared AB/BC content."*
- Line 243: *"Two topics are BC-only, each tagged in three places: **7.5 Euler's Method** and
  **7.9 Logistic Models**."*

These cannot both be true. The taxonomy agrees with line 243 — `ap_calculus_ab` has topics
7.1, 7.2, 7.3, 7.4, 7.6, 7.7, 7.8 and **no 7.5 or 7.9**. Line 137 is wrong and should be corrected;
it is the kind of line that would license authoring exactly the three defective items above.

**Not fixed here.** Deciding what happens to three published items — retire, move to BC, or accept
as out-of-scope practice — is a content call for the Product Owner, and correcting the fact pack is
a separate change from this labelling run.
