# Triage of the 76 unlabeled published items with no identifiable unit (2026-11-14)

Read-only. Nothing was written to Production. Source: a fresh Production export of all ten subjects (published, non-teaching items whose latest version is published). Machine-readable list: `LABEL_UNITLESS_76_TRIAGE_2026_11_14_ITEMS.json`. Evidence: `scripts/content-seed/label-gap-audit-u6plus-2026-11-13/stage7/` (rubric check). Owner request: "Triage the 76".

## What the 76 are
Published items with no validated topic cell and no valid serving label, and no way to tell their unit. 74 carry a held serving label, 1 has only a provisional one (`apprecalc-frq-np2-010`) and 1 has only legacy prompt data (`apchem-sfrq-003`). All are seeds. The held reasons: 50 model unit disagreement, 12 rubric preflight failure, 7 other, 4 empty required units, 1 model call failure. By subject: Calculus BC 38, Physics 1 7, Physics C: Mechanics 7, Chemistry 8, Physics 2 6, Physics C: E&M 5, Precalculus 4, Biology 1.

## Buckets
| Bucket | Items | What it needs |
|---|---|---|
| **A. Vote, then label** | 64 | The six-vote topic probe, then labels, the same way as the last rounds. 6 are `other`-held with an uninformative reason, so they also get a CED-text screen. |
| **B. Repair the rubric, then label** | 11 | A rubric (or prompt) repair as in APPROVAL-0277/0282, a three-model recheck, then the probe. |
| **C. Out of the course description** | 1 | Not labelable. `apcalcbc-mcq-007` (Newton's method): the CED PDF text has zero occurrences of "Newton" (the same extraction finds "Euler" 5 times). Owner call: retire it, or leave it unserved. |

### B. Rubric repairs (current rubrics, three-model check, measured $0.41)
All 11 fail with the same flags from at least two of three models. Pattern: the rubric scores something the prompt does not ask, or leaves an asked operation unscored.
- `apcalcbc-frq-016`: criterion part-a-criterion-1 scores a derivation (term-by-term integration) that part (a) does not ask for.
- `apcalcbc-frq-022`: part-d-criterion-2 scores the x-values of the extrema; (d) asks for the extreme values only.
- `apcalcbc-frq-030`: evaluations of v and a at t=π/4 (asked in (a), (b)) are unscored.
- `apcalcbc-frq-031`: the interpretation in (d) is unscored.
- `apcalcbc-frq-033`: part-c-criterion-2 and -3 score conditional versus absolute convergence, which (c) does not ask.
- `apchem-frq-l-005`: part (c) trial design and part (d) comparison are unscored, d2 scores an unasked equilibrium explanation; the rubric also totals 8 points against a prompt total of 10, which is a separate defect.
- `apchem-sfrq-005`: the endpoint-equals-equivalence-point assumption in (b) is unscored.
- `apchem-sfrq-007`: the crossover-temperature calculation in (a) is unscored (2 of 3 models fail it).
- `apphy2-frq-002`: part (a) scores only qualitative cancellation, not the derivation and numerical value (V about 1.80 x 10^5 V, E = 0) the prompt asks for.
- `apphy2-frq-011`: part-a and part-b criteria add requirements the prompt does not ask.
- `apprecalc-frq-np2-008`: part-c-criterion-01 scores the x-coordinate; (c) asks for the y-coordinate only.

`apcalcbc-frq-002` was also rubric-held but now passes 3 of 3, so the hold is stale and it moves to bucket A.

## Things to watch in bucket A
- **BC-only topics are fine in BC.** `apcalcbc-mcq-038` and `apcalcbc-frq-027` are Euler's-method items; Euler (7.5) is BC-only and these are BC items.
- **Stub stems.** `apcalcbc-frq-u13-014` and `APBIO-HDG-2026-GRAPH-008` have placeholder stems; the probe will read the full prompt parts, and I'd check the result by hand.
- **No stored model outputs** for `apchem-mcq-012` and `apchem-sfrq-010`.
- **CED exclusions are not yet screened** for the 64. Two of the last six items turned out to contain excluded content (Euler in an AB item, buffer pH-change computation), so the vote stage must include that screen; expect a few more defects.
- **Units 1-5 and 6+ both appear.** Many are Unit 1-5 items that the earlier audits skipped because they had no unit. The probe sets the unit.

## Estimate (not spent)
Votes on 64 seeds plus about 11 repaired: roughly $1.0 to $1.3 at the measured rate of about $0.014 per seed. Rubric rechecks about $0.15. Total about $1.5, under a $3 cap. Repairs of 11 items are my authoring time, not gateway cost.

## Not verified
The bucket A items have not been read for content defects, and the bucket B flags come from three models (consistent, but not read by a subject specialist).
