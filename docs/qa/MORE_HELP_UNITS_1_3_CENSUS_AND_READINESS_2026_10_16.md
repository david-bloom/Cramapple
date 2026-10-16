# More help — units 1–3 census and readiness audit (2026-10-16)

STATUS: CURRENT (a snapshot; rerun the SQL in `scripts/more-help-readiness/` for fresh numbers)

Read-only against Production. Content counts, not learner counts, and not proof of serving eligibility. Nothing was enabled. "First three units" = the three lowest unit numbers in each subject's taxonomy, so Physics 2 resolves to units 9–11 and Physics C E&M to 8–10; those two are **counted for information only, no work is planned or done on them** (owner direction 2026-10-15). Latest published version per content item; unit from the question RPC's active-cell rule. "Usable" = published, topic-tagged, with published reference grounding.

## Census (owner request: flag any subject/unit with fewer than 3 MCQs or fewer than 1 FRQ)

**Result: no subject/unit is short.** Every one of the 30 cells has at least 13 usable MCQs and at least 6 usable FRQs. Zero questions in these cells lack reference grounding.

| Subject | Unit | MCQ | FRQ | Image-bearing |
| --- | --- | --- | --- | --- |
| AP Calculus AB | 1 / 2 / 3 | 136 / 96 / 76 | 39 / 11 / 9 | 4 / 0 / 0 |
| AP Calculus BC | 1 / 2 / 3 | 127 / 94 / 81 | 21 / 11 / 9 | 0 / 0 / 0 |
| AP Chemistry | 1 / 2 / 3 | 51 / 44 / 71 | 8 / 7 / 16 | 0 / 0 / 2 |
| AP Physics 1 | 1 / 2 / 3 | 16 / 48 / 55 | 14 / 18 / 14 | 0 / 0 / 0 |
| AP Physics 2 (info only) | 9 / 10 / 11 | 24 / 22 / 26 | 10 / 7 / 11 | 0 / 0 / 0 |
| AP Physics C: E&M (info only) | 8 / 9 / 10 | 38 / 25 / 24 | 19 / 8 / 6 | 0 / 0 / 0 |
| AP Physics C: Mechanics | 1 / 2 / 3 | 15 / 13 / 37 | 7 / 14 / 7 | 0 / 0 / 0 |
| AP Precalculus | 1 / 2 / 3 | 83 / 70 / 71 | 25 / 27 / 27 | 0 / 0 / 0 |
| AP Statistics | 1 / 2 / 3 | 298 / 54 / 60 | 32 / 24 / 16 | 0 / 0 / 0 |
| AP Biology | 1 / 2 / 3 | 96 / 33 / 26 | 8 / 15 / 11 | 0 / 0 / 1 |

Thinnest cells (not shortfalls, but where a small output run or later tagging gaps would bite first): MCQ — Physics C Mechanics U2 (13), U1 (15), Physics 1 U1 (16); FRQ — Physics C E&M U10 (6), Chemistry U2 (7), Physics 2 U10 (7), Physics C Mechanics U1/U3 (7).

**Not in the census (no resolvable unit, so not assignable to units 1–3):** AB 1, BC 64, Chemistry 37, Physics 1 45, Physics 2 35, Physics C E&M 42, Physics C Mechanics 41, Precalculus 9; Statistics and Biology 0. These may include units-1–3 questions awaiting topic tags; BC (64) and the Physics courses are the large ones. (Different definition from Codex's earlier "161"; do not reconcile the two without re-deriving.)

## Readiness findings

- **Reference grounding:** complete for every subject's first three units. **Pitfall that cost an audit run:** reference/taxonomy keys differ from registry keys — Biology is `ap_biology`, not `biology`. A join on `replace(subject_key,'-','_')` wrongly reports Biology as 100% ungrounded.
- **Images:** 7 image-bearing questions in scope: Calculus AB U1 (4), Chemistry U3 (2), Biology U3 (1). The AB/Chemistry six are the known image-support blockers; the Biology one still needs a grounding ruling. Statistics, Precalculus and all Physics have none, which makes them cleaner next candidates.
- **Authored parts:** 0 questions with incomplete or malformed parts in any subject (so none would hit `question_parts_unavailable`). Many FRQs carry their parts inside the stem text rather than a parts array (Physics 1 37 of 46, E&M 28 of 33): normal, as Statistics round 1 showed.
- **Topic gaps:** the four known unmapped items (Physics 1 `apphy1-frq-np1-004`, Physics C Mechanics `apphycm-frq-044`, Precalculus `apprecalc-frq-016` and `apprecalc-mcq-sv-037-v3`) still need their six-vote topic probe (model calls, not run).

## Does the identify/define rule transfer to other subjects?

The trap (nouns: procedure, test, interval, parameter, hypotheses, variable, population, sample) matches few FRQs: Statistics 12 of 72, Precalculus 3/79, Physics 1 5/46, Physics C Mechanics 2/28, and 0–1 elsewhere. The "identify/name/state/define" parts in other subjects are phrased differently, so the rule would rarely fire there. Most common objects (data-derived, units 1–3 FRQs):

| Subject | Frequent "identify/state/name/define …" objects |
| --- | --- |
| All | "state whether …" (BC 9, Precalc 15, Physics 2 11, AB 6, Statistics 6) — asks for a verdict |
| Statistics | identify which (10), identify appropriate (8), state null (6) |
| Physics 1 / C Mech | identify independent (variable), name object, identify actual/every … |
| Physics 2 / C E&M | state direction (8), state/identify governing (law), state sign |
| Precalculus | state midline (7), state period (4), state domain (3) |
| Chemistry | identify which/type/element, state electron (…) |
| Biology | identify which/fatty (acid)/type/step, name chemical (…) |

**Recommendation (not implemented, to be judged after the live Statistics rerun):** if the prompt boundary works, widen its trigger to any FRQ part that asks to identify/name/state/define/decide, keeping the deterministic procedure-name validator Statistics-specific; per-subject validators (e.g. governing law names for Physics, "midline/period" values for Precalculus) need an owner ruling on what counts as disclosure before being written. Do not add them speculatively.

## Reproduce
`scripts/more-help-readiness/census_units_1_3.sql`, `readiness_parts_shape_units_1_3.sql` (run on Production via a read-only connection).
