# TASK-0059 — Apply DECISION-0095 (CED vocabulary) as a Quality Check to the Published Banks of All Subjects

**Status:** Not Started. **Parked by the Product Owner on 2026-10-03** ("Just not dealing with it now"). Do not start until the Product Owner says so.
**Tier:** Standard (read-only scan); Hard-Gate for any Production retirement it recommends (each batch needs its own approval)
**Owner:** TBD
**Product Owner:** David Bloom
**Date opened:** 2026-10-03
**Area:** Content / QA / Scope
**Parent decision:** `DECISION-0095` (items stay within the subject's CED vocabulary; a mechanism supplied in the stem does not bring a term in scope; published items that break it are retired, not repaired)
**Related:** `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (section 10 and its pre-run checklist), `docs/handoffs/SEEDED_QUESTIONS_SESSION_RECORD_2026_10_01.md`, the per-subject `docs/product/AP_*_CED_FACT_PACK.md` files

## Why this exists

`DECISION-0095` was found and applied on AP Biology only: 7 variants (`APPROVAL-0091`) and 3 seeds (`APPROVAL-0092`) were retired because they used terms the CED never names. The decision states in its Consequences that the published banks of **Calc AB, Chemistry, Statistics, Physics and Precalculus have not been scanned** under this rule, and leaves open whether to scan them. The Product Owner has asked for it to be a standing quality check on every subject. This task records that so it is not lost.

The exposure is larger than when the decision was written. In the 2026-10-02/03 Units 1-3 run these were published (counts are items added, from the approvals log):

| Subject | Published in that run | Approval |
| --- | --- | --- |
| Chemistry | 72 variants | `APPROVAL-0075` |
| Statistics | 131 variants | `APPROVAL-0078` |
| Biology | 24 variants (7 since retired by `APPROVAL-0091`) | `APPROVAL-0080` |
| Calculus AB | 29 pilot variants + 109 new seeds and variants | `APPROVAL-0084`, `0085` |
| Calculus BC | 283 questions mirrored from AB | `APPROVAL-0090` |
| Physics 1 | 89 variants | `APPROVAL-0088` |
| Precalculus | seed repairs (`APPROVAL-0093`, `0094`); 147 variants authored, not yet loaded | |

Because Calculus BC was mirrored from AB, a break found in an AB item is also a break in its BC copy; both need retiring.

## What to do (when started)

1. **Per subject, make sure the fact pack records the CED terms known to be absent** (`DECISION-0095` point 4). Several packs already carry "authoring and review boundaries" or "not tested" lists (for example Physics 1: work is never presented as a dot product; Precalculus: the restriction to an initial value of 1 for inverse derivations). Turn each into an explicit term list, confirmed against the CED page, not the PDF text extract (it has spacing problems).
2. **Run the scan** exactly as `DECISION-0095` point 3 describes: a case-insensitive full-text match of stimulus, stem, every choice and every rationale against the confirmed-absent terms. A generic label built from a CED term is not a break. A model checker's scope flag is a candidate only and is adjudicated against the CED text, never by vote.
3. **Report per subject** the matched items with the matched term and the CED page that confirms its absence. Read-only; nothing is retired by the scan.
4. **Retire, do not repair or replace** each confirmed break (`DECISION-0095` point 2), one approval per subject batch, recorded in the approvals log. Retiring leaves labels in place and does not change label counts. Remember the Calc BC mirror when retiring AB items.
5. **Make it part of the pipeline.** Add the term scan to the pre-run checklist in the seeded generation protocol so new seeds and variants are screened before they are loaded, not after they are published.

## Open questions for the Product Owner (from `DECISION-0095`, still open)

- Does the rule apply to FRQ and hand-drawn items? They were not scanned in Biology.
- For subjects whose CED is tolerant of an explained mechanism in the stem (for example Statistics context sentences), is the same strict reading wanted?
- Should the scan also cover items published before the Units 1-3 run (the older banks), or only what this run added?

## Done when

Every subject's fact pack lists its confirmed-absent terms; every published MCQ in every subject has been scanned; each confirmed break has been retired under its own approval; and the term scan is a step in the seeded generation protocol's checklist.

## Not in scope

Rewriting or replacing retired items (the decision says retire); changing the decision itself.
