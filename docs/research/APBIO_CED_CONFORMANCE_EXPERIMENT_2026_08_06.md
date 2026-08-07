# Blind CED-conformance experiment — AP Biology, 2026-08-06

**Status:** Prototype experiment, read-only. No content items or reviewer records
were modified. No launch or production-adoption decision implied.

## What this tests

`docs/research/GOLD_SET_GENERATION_PROTOCOL.md` (2026-08-03) replaced all-human
gold-set answer authoring with AI generation plus independent multi-model
verification. This experiment prototypes the analogous check for original
*question* authoring: an automated, blind pass that checks whether a question's
cited facts are covered by the verified `AP_BIOLOGY_CED_FACT_PACK.md`, run
before a human tutor ever sees the item — the missing layer identified when
comparing Adil Abbasi's four AP Biology findings against the fact pack
(see the 2026-08-06 chat session; no standalone doc was written for that
comparison).

## Method

- **Test set (4):** `APBIO-FRQ-L-016`, `-026`, `-030`, `-036` — the four items
  Adil disapproved/edited citing off-CED content or internal contradictions.
- **Control set (4):** `APBIO-FRQ-S-009`, `-061`, `-089`, `APBIO-MCQ-001` — AP
  Biology items with `approve` from at least two distinct reviewers and no
  disagreeing decision. Only 3 FRQs met that bar cleanly in Production; one
  MCQ fills the 4th slot.
- **Blinding:** the model-facing prompt carries the item's stem, stimulus, and
  rubric criteria, and the full CED fact pack text — nothing else. No group
  label, reviewer name, or decision is included or implied.
- **Independence:** none of these items has recorded generation provenance,
  but this codebase's reviewer-facing grader is OpenAI, so the check
  deliberately used non-OpenAI model families, mirroring
  `GOLD_SET_GENERATION_PROTOCOL.md` R1/R5. `anthropic/claude-haiku-4-5` and
  `google/gemini-2.5-flash` both completed the run. `moonshotai/kimi-k2` was
  dropped after 8/8 calls failed with a structured-output "Bad Request" via
  this gateway path — the same class of incompatibility the protocol's own
  Kimi note flags ("pre-registered and never run"). Only 2 of the protocol's
  target 3 non-OpenAI families were usable; logged as a limitation, not
  silently worked around.
- **Schema note:** the first run capped `out_of_scope_concepts` at 10 items.
  `APBIO-FRQ-L-030` (which cites ~11 distinct off-CED terms) and several other
  cells failed schema validation and were silently dropped as errors —
  a false negative caused by the check's own design, not by the model.
  Raising the cap to 20 fixed it. Worth remembering for any real
  implementation: an under-sized array bound on a genuinely bad item makes it
  *look* like a tooling failure instead of a finding.
- Script: `scripts/vercel-gateway-check/apbio_ced_conformance_experiment.mjs`.
  Raw output: `/private/tmp/cramapple-ced-conformance-experiment/`.

## Result

| Item | Group | Majority verdict | Model agreement |
|---|---|---|---|
| `APBIO-FRQ-L-016` | flagged | **contains_out_of_scope_content** | 2/2 |
| `APBIO-FRQ-L-026` | flagged | **contains_out_of_scope_content** | 1/1 (1 schema error) |
| `APBIO-FRQ-L-030` | flagged | **contains_out_of_scope_content** | 2/2 |
| `APBIO-FRQ-L-036` | flagged | **contains_out_of_scope_content** | 1/1 (1 schema error) |
| `APBIO-FRQ-S-009` | control | **fully_in_scope** | 2/2 |
| `APBIO-FRQ-S-061` | control | **fully_in_scope** | 2/2 |
| `APBIO-FRQ-S-089` | control | **fully_in_scope** | 1/1 (1 schema error) |
| `APBIO-MCQ-001` | control | **fully_in_scope** | 2/2 |

**8/8 items classified correctly against the human review outcome, with zero
disagreement among the model calls that returned a valid result.** All four
flagged items were caught; all four multiply-approved items passed clean.

## What the models found beyond what Adil flagged

- **`L-016`**: both models independently identified the exact defect Adil
  named — stem (homeostasis/feedback/hypothalamus/pH) has no relationship to
  stimulus/rubric (yeast fermentation) — described as "two entirely different
  questions" stitched together, without being told that was the concern.
- **`L-026`**: both models named the same off-CED cluster Adil flagged (Ne,
  MVP, purging hypothesis, MHC/skin-graft immunology), plus flagged that
  "genetic rescue" as a named conservation strategy and "allelic richness" as
  a metric are also absent from the CED — detail beyond Adil's note.
- **`L-030`**: both models named the same cluster (MacArthur-Wilson, SLOSS,
  rescue effect, minimum viable area, corridors, metapopulation) and
  additionally flagged that the species-area formula `S=cA^z`, needed for
  Part A's calculation, is never supplied and isn't in the CED's required
  math skills — a distinct, checkable defect Adil's note didn't call out.
- **`L-036`**: both models caught the inducer/repressor direction error Adil
  found, and Claude additionally caught that Part A asks students to predict
  "Strain 3" behavior when the stimulus table only provides wild-type and
  Strain 2 data — Strain 3 doesn't exist in the given data at all. This is a
  genuinely new finding, not present in Adil's original notes.

## Reading this result

This is a single 8-item run, not a certification — it does not by itself meet
the gold-set protocol's Phase 0/certification bar (§5), which requires ~100
independently-verified calls per set before an automated path is trusted at
production scale. What it does establish: the mechanism recommended after
comparing the fact pack to Adil's findings — a blind, CED-grounded, non-writer-
family model pass before tutor assignment — separates this known-bad/known-
good pair cleanly, at the cost of a few API calls instead of a full tutor
review cycle, and surfaced at least two defects (`L-030`'s missing formula,
`L-036`'s missing Strain 3 data) that the original human review pass didn't
name.

## Before this goes further

1. Re-run at the ~100-call scale the protocol's own certification gate (§5)
   requires before trusting an automated accept/reject path, not just a
   discard-and-flag-for-human path.
2. Resolve the Kimi gateway incompatibility or substitute a third confirmed
   family — two families is workable for a prototype, not for the R5 bar.
3. Decide the routing rule before wiring this into authoring: given this
   result, "flag for human review" is clearly justified; "auto-discard" is a
   separate, higher-stakes decision this 8-item run cannot support.
