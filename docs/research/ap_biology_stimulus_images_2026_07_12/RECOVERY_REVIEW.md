# Recovered AP Biology Stimulus Images — Visual Preflight

**Status:** Draft
**Review date:** 2026-08-03
**Scope:** Visual-layout preflight only. This is not Learning Quality,
accessibility, grading, rights, or release approval.

The package was recovered from `archive/pr43-stimulus-images-20260721`. The
archived README described it as complete and uploaded to Production, but the
assets and deterministic source were absent from `main`. All ten PNGs open and
their dimensions and checksums match `manifest.json`.

## Production state verified 2026-08-03

Read-only queries against Supabase project `pcntajvbdfqhbeewmdry` bound every
asset to its exact current compatibility-view version:

| Content key | Version ID | Version state | Recovery preflight |
| --- | --- | --- | --- |
| `APBIO-FRQ-S-002` | `a236fbd8-86f8-4903-95ad-573b70e9aa0d` | retired | pending |
| `APBIO-FRQ-S-003` | `c4da3229-8d7a-4cf9-8738-68b62af20372` | retired | layout rejected |
| `APBIO-FRQ-S-005` | `8abb500d-b447-4bd9-8721-7aaea3d3e118` | retired | pending |
| `APBIO-FRQ-S-008` | `a56f23da-cef3-4e50-a948-0dafc5d646c0` | retired | layout rejected |
| `APBIO-FRQ-S-009` | `de59d53c-1f80-4b1a-9694-10d9e50dcad0` | **published** | **layout rejected** |
| `APBIO-FRQ-S-012` | `016a377a-f8ae-4d8d-93bd-1f8876bf5e8c` | retired | pending |
| `APBIO-FRQ-S-014` | `1dae7790-b798-4aaa-aa29-5ca755c66719` | retired | pending |
| `APBIO-FRQ-S-015` | `ee8b585c-8d40-4ca0-9302-de533c286ff8` | retired | layout rejected |
| `APBIO-FRQ-S-018` | `4fd9f55d-75d7-415b-a306-f18c4f27ca5c` | reviewed-disapproved | layout rejected |
| `APBIO-FRQ-S-020` | `7732c678-b454-45d3-8b9d-a882ce6ef6a0` | retired | pending |

Only `APBIO-FRQ-S-009` is currently published. Its four recorded question
decisions are approvals, but none records image-specific or accessibility
review; one contains a rubric-gap concern. Its `content-assets` object is 48,400
bytes, matching the recovered PNG's size, but the available Storage metadata
does not prove byte identity. The published item therefore needs focused live
verification and a corrected, newly versioned diagram. The other nine are
historical evidence and should not consume re-authoring effort unless their
items are separately proposed for republication.

### S009 replacement candidate

`candidates/APBIO-FRQ-S-009-v2-candidate.png` fixes the branching defect: two
separate arrows run from the same pre-mRNA row to two mature products, and no
arrow runs between products. The deterministic source is
`generate_s009_replacement.py`. Its complete Python 3.12 dependency set is
pinned in `requirements-lock.txt`; two independent renders were byte-identical
at SHA-256 `d32435dc2eb8415dfe4c837df1952ef5d57e289310a43e8820ee2a51e4af4020`.

This proves deterministic build repeatability only. Scientific, grading,
accessibility, answer-leakage, rights, responsive-layout, and live-delivery
approval remain pending, and no Production object or row was changed.

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
- The exact compatibility-view item versions are now recorded in the manifest,
  but their relationship to newer artifact-model records still needs checking
  before any replacement action.

## Required next pass

1. Re-author `APBIO-FRQ-S-009` against its published version, with two arrows
   branching independently from the pre-mRNA to the two products.
2. Treat the other nine assets as historical; re-author only if their items are
   separately proposed for republication.
3. Run scientific and grading review in exact item context.
4. Run accessibility review, including short alternative, long description or
   alternate item, answer-leakage assessment, 200% zoom, narrow viewport, and
   contrast.
5. Regenerate the manifest checksums and dimensions.
6. Reproduce the recorded bytes under the pinned generator environment, or
   intentionally version new outputs and review them as new assets.
7. Only set `release_eligible: true` after every required review field is
   `approved` or explicitly `not_applicable`.
