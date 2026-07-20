# AP Biology Gold-Set Candidate — 2026-07-08

**Corpus tier:** `calibration` (silver) — NOT governance `adjudicated_gold`
**Status:** Adjudication-ready package with AI provisional labels
**Related:** DECISION-0034 (Option B — AI provisional labels approved as
calibration evidence); `../grading_cross_subject_takeaways.md`;
`../../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12

## What this is / is not

- **Is:** a locked, composition-controlled candidate response set with a
  criterion-level provisional-label pass and a blind dual-scoring harness ready
  for two qualified human Grading Validators.
- **Is not:** `adjudicated_gold`. The labels here are AI provisional judgments
  (Claude Fable) against each item's rubric `evidence_requirements` and
  `accepted_variants`. They become gold only after two human validators score
  blind and a Lead adjudicates disagreements (§12.1). Do not cite this set for a
  release-threshold quality claim until that happens.

## Run metadata

| Field | Value |
| --- | --- |
| Source corpus | `../ap_biology_frq_bootstrap_corpus_2026_07_07.json` |
| Selection | deterministic spread across items carrying ≥3 distinct response types |
| Items / responses / criterion judgments | 5 / 20 / 88 |
| Read tier | Directional (20 responses) — supports "worth adjudicating," not a release decision |
| Label authority | AI provisional vs rubric; human adjudication pending |

## Composition

20 responses = 5 `fully_correct`, 5 `partially_correct`, 5 `borderline`,
5 `subtly_wrong`, spanning photosynthesis, ecology/energy flow, cell signaling,
phylogenetics, and cellular respiration.

Meets §12.2 minimums for partial (25%), ambiguous/boundary (25%), and
contradictory/subtly-wrong (25%). **Gaps** (must be filled before this is a real
archetype gold set): no equivalent-language variants, no explicit
abstention/unreadable cases, no HDR/image responses in this slice.

## Provisional label distribution

| Label | Count |
| --- | ---: |
| earned | 47 |
| partially_earned | 13 |
| not_earned | 28 |
| unable_to_determine | 0 |

The `subtly_wrong` responses are the strongest part of this set: several are
**confidently-wrong-but-complete** (e.g., insulin-receptor item — every part
asserted with fluent but incorrect mechanism), which is exactly the failure mode
the deterministic layer and boundary contracts exist to catch and which a
model's self-reported confidence cannot.

## Adjudication queue (9 items)

Nine criterion judgments are flagged for human focus because they sit on a
genuine boundary. Highest-value:

- **APBIO-FRQ-L-001 / partially_correct / a_i** — value correct but explanation
  restates "net O₂ = 0" without stating photosynthesis rate = respiration rate;
  does that half earn?
- **APBIO-FRQ-L-001 / subtly_wrong / b** — proton-pumping direction reversed;
  does a reversed mechanism void the criterion or earn partial?
- **APBIO-FRQ-L-009 / borderline / b** — nitrogen pathway correct but omits
  organism names (Rhizobium/Nitrosomonas) and nitrate reduction; how strict on
  named organisms?
- **APBIO-FRQ-L-033 / borderline / b,c** — alcoholic fermentation implied but
  pyruvate decarboxylation not named; aerobic shift stated without 6-vs-2 CO₂ or
  NADH-shuttle depth.

These flags are the criterion-boundary-contract sharpening targets — resolve
them with Learning Quality, then encode the decision into the boundary contract.

## Deterministic-check note

No deterministic-check targets in the Biology slice (its criteria are
judgment-heavy prose). Contradiction/misattribution checks from
`../AP_BIOLOGY_VERIFICATION_PROFILE.json` still apply at runtime; the
`APBIO-FRQ-L-033 / subtly_wrong` response contains an internal contradiction
(lactic-acid premise propagated into part d) that the contradiction check should
catch.

## How to upgrade to `adjudicated_gold`

1. Assign `blind_scoring_template.csv` to two qualified Grading Validators; they
   fill `validator_A/B_label` + evidence quotes blind to the AI labels and each
   other.
2. Lead adjudicates every disagreement; record in `final_gold_label`.
3. Where adjudication reveals rubric ambiguity, revise the criterion-boundary
   contract (a C2 change), not the label.
4. Re-tier the package `adjudicated_gold` and record the promotion decision.

## Files

- `manifest.json` — package metadata, composition, distribution
- `provisional_labels.json` — criterion-level AI labels with evidence, confidence, adjudication flags
- `blind_scoring_template.csv` — empty dual-scoring sheet for human validators
