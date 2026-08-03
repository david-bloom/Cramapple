# Recovered AP Biology Stimulus Images — Visual Preflight

**Status:** Draft
**Review date:** 2026-08-03
**Scope:** Visual-layout preflight only. This is not Learning Quality,
accessibility, grading, rights, or release approval.

The package was recovered from `archive/pr43-stimulus-images-20260721`. The
archived README described it as complete and uploaded to Production, but the
assets and deterministic source were absent from `main`. All ten PNGs open and
their dimensions and checksums match `manifest.json`.

## Blocking visual findings

- `APBIO-FRQ-S-003`: electron labels overlap boxes and arrows; the NADPH arrow
  begins ambiguously at the edge of PSI; the membrane/lumen/stroma geometry is
  difficult to parse at smaller widths.
- `APBIO-FRQ-S-008`: parental strands stop before the helicase and do not
  visibly connect to either daughter-strand branch. The geometry therefore does
  not communicate one continuous replication fork.
- `APBIO-FRQ-S-009`: the second product arrow visually originates from product
  1, implying a product-to-product transformation instead of two alternative
  outcomes from the same pre-mRNA.
- `APBIO-FRQ-S-015`: the bound-repressor label, induction text, and connecting
  line collide. The allolactose-to-repressor relationship is not visually
  explicit.
- `APBIO-FRQ-S-018`: the animal-cell ellipses overlap, placing the gap-junction
  channels inside an overlap rather than between two clearly adjacent plasma
  membranes; the plant panel indicates a wall crossing but does not draw a
  distinct channel.

These assets are marked `visual_layout: rejected` in the manifest. The other
five remain `pending`, not approved; they still require item-context,
scientific, grading, accessibility, and responsive-render review.

## Package-level gaps

- No immutable manifest or checksums existed before this recovery.
- No machine-readable approval state existed per asset.
- The generator wrote to an expired agent-specific `/tmp` path; it is now
  portable and defaults to this package directory.
- Regeneration under the locally available Matplotlib 3.9.4 changed pixels and
  bounding-box dimensions for all ten assets. The recovered PNG metadata names
  Matplotlib 3.11.1, now pinned in `requirements.txt` and enforced by the
  generator. Exact-environment reproduction remains unverified.
- Draft short alternatives now exist, but construct equivalence and answer
  leakage have not been reviewed.
- The recovered package does not contain the exact item versions/stems against
  which each image was supposedly approved, so version-specific fidelity is
  unproven.

## Required next pass

1. Export the exact current item versions for the ten content keys.
2. Re-author the five visually rejected diagrams against those versions.
3. Run scientific and grading review in item context.
4. Run accessibility review, including short alternative, long description or
   alternate item, answer-leakage assessment, 200% zoom, narrow viewport, and
   contrast.
5. Regenerate the manifest checksums and dimensions.
6. Reproduce the recorded bytes under the pinned generator environment, or
   intentionally version new outputs and review them as new assets.
7. Only set `release_eligible: true` after every required review field is
   `approved` or explicitly `not_applicable`.
