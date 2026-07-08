# Grading Label Adjudication Queue — 2026-07-08

**Status:** Consolidated, adjudication-ready queue for the human Grading Validators
**Sources:** two independent label reviews of the three silver gold-set candidates —
(1) the Claude label-robustness cross-check + judgment-layer blind re-grade
(`label_robustness_crosscheck_2026_07_08/`), and (2) Codex's third-opinion review
(`THIRD_OPINION_GRADING_ISSUES_2026_07_08.md`).
**Tier:** calibration (silver). None of this clears the §12 release gate; it is
pre-triage for human dual-blind adjudication.

## Headline

The two independent reviews **converge**. Every item either both reviews flagged,
or one flagged and the other's evidence is consistent. No contradictions between
the two passes. That convergence is itself the most reassuring signal: the silver
labels are sound except at a small, agreed set of genuine boundaries plus one
corpus defect.

## Consolidated queue (ranked)

| # | Pri | Subject | Item / criterion | Current label | Claude re-grade | Codex third opinion | Recommended disposition |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | High | Biology | `APBIO-FRQ-L-001` / `b` | `not_earned` | Lean `partially_earned` (correct electron-flow = 1 of 2 required elements; proton direction reversed) | Boundary: does one correct element earn partial? | **Human decides up-or-hold.** Strongest move-candidate. Encode the outcome into the b criterion-boundary contract (does a correct sub-element earn on a 2-point criterion with a reversed coupled mechanism?). |
| 2 | High | Statistics | `APSTAT-MOD8-H001` (item) | n/a | Corpus defect: no dataset → values unverifiable | Corpus defect: exclude or rewrite with data | **Exclude from gold-set decisions** until a real dataset is attached or the rubric is scoped to method-only. Do not pool into any agreement claim. |
| 3 | High | Biology | `APBIO-FRQ-L-001` / `a_i` | `partially_earned` | Uphold partial (value right; explanation restates "net O₂=0", omits photosynthesis = respiration) | Boundary: does the partial explanation still earn? | **Human sets the boundary:** does stating the value + "net O₂=0" earn the explanation half? Encode into the a_i boundary contract. |
| 4 | High | Biology | `APBIO-FRQ-L-009` / `b` | `partially_earned` (type: borderline) | Uphold partial; adjudicate organism-name strictness | Boundary: how much named detail (Rhizobium/Nitrosomonas, nitrate reduction) does the rubric require? | **Human sets the named-detail requirement** in the b boundary contract. |
| 5 | High | Statistics | `APSTAT-MOD5-H001-INV` / `experimental_conclusion` | `partially_earned` (type: borderline) | Uphold partial (conclusion in context + 1 assumption; rubric wants ≥2) | Boundary: strictness on assumption count | **Human sets the assumption-count rule** (is 1 of ≥2 partial or not_earned?). |
| 6 | Med | Biology | `APBIO-FRQ-L-033` / `b`, `c` | `partially_earned` (type: borderline) | Uphold partial; adjudicate depth (names alcoholic fermentation/aerobic shift but not pyruvate decarboxylation or 6-vs-2 CO₂/NADH) | Boundary: depth threshold | **Human sets the depth threshold** for b and c. |
| 7 | Med | Chemistry | `APCHEM-FRQ-L-041` / `verification` | `partially_earned` (type: borderline) | Uphold partial (comparison stated; magnitudes not fully spelled out) | Boundary: is the stated comparison enough? | **Human decides** whether spelling out magnitudes is required for the verification criterion. |
| 8 | Med | Statistics | `APSTAT-MOD6-H001` / `conclusion`; `APSTAT-MOD7-H001` / `calculation` | criterion = `earned` (response *type tag* = `partially_correct`) | Criterion labels are `earned` and correct; the source **type tag** overstates wrongness | Reads like full credit — under-credit? | **No criterion-label change.** Flag the AP Statistics bootstrap corpus: some `partially_correct` synthetic responses are effectively full-credit; fix the source **type tags** (Learning Quality corpus note), not the grades. |

## Resolved / not re-litigated

- `APBIO-FRQ-L-009` / `subtly_wrong` / `a`: was `not_earned`, corrected to
  `partially_earned` during the Claude re-grade (the rubric awards 1 pt for the
  correct efficiency calculations, which the response has). **Codex independently
  confirms this is resolved and not a live discrepancy.** Two independent passes
  agreeing on the same correction is strong evidence it was right.
- The large majority of high-confidence labels sampled by both reviews were
  consistent with the rubric.

## What the human pass should produce

For each open item (1–8), decide "uphold / move up / move down" against the
rubric language, and — critically — **write the decision into the relevant
criterion-boundary contract** (per DECISION-0034 §9.1) so the boundary is fixed
once, not re-litigated. Item 2 (MOD8) and item 8 (Stats type tags) are corpus
fixes, not grade decisions.
