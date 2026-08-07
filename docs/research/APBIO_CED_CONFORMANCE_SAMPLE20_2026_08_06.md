# AP Biology CED-conformance — random 20-item sample, Haiku only, 2026-08-06

**Status:** Prototype experiment, read-only. No content records modified.

## Method

- 20 items via `order by random() limit 20` over published AP Biology
  `content_items` (mix of MCQ, long/short FRQ, and hand-drawn-graph FRQ items;
  no filtering by prior review outcome).
- Same blind protocol as the earlier 8-item run: model sees only stem,
  stimulus, and rubric criteria/choices plus the full CED fact pack — no
  group label, no reviewer decision, no indication of prior review status.
- **Haiku only** per owner instruction, single pass (no second-model
  corroboration this run).
- Script: `scripts/vercel-gateway-check/apbio_ced_conformance_sample20.mjs`.
  Raw output: `/private/tmp/cramapple-ced-conformance-sample20/`.

## Result

**14 `fully_in_scope`, 6 `contains_out_of_scope_content`, 0 errors** (20/20 calls succeeded).

| Verdict | Items |
|---|---|
| contains_out_of_scope_content | `APBIO-MCQ-099`, `APBIO-FRQ-L-029`, `APBIO-FRQ-L-015`, `APBIO-FRQ-L-014`, `APBIO-FRQ-L-001`, `APBIO-FRQ-L-009` |
| fully_in_scope | remaining 14, including `APBIO-FRQ-L-026` |

## Two things worth flagging honestly, both checked against the fact pack directly

**1. A known-bad item flipped to a clean pass — a real single-pass reliability failure.**
`APBIO-FRQ-L-026` was one of the four items Adil originally flagged, and both
models caught it independently in the first 8-item run (Ne, MVP, purging
hypothesis, MHC/skin-graft immunology all correctly identified as absent from
the CED). In this run, the same model (Haiku) called it `fully_in_scope`,
confidence 0.95 — and its own reasoning cites specific EK codes (`7.4.A.1`,
`7.4.B.1`) as covering effective population size and minimum viable
population. Checked directly against the fact pack: those EKs cover mutation,
drift, bottleneck effect, founder effect, and gene flow — **Ne, MVP, and the
purging hypothesis appear nowhere in them.** This is a hallucinated citation
producing a false negative on an item already confirmed bad. It's exactly the
failure mode the gold-set protocol's certification gate (§5) exists to catch
— a single pass is not trustworthy for auto-accept, which is why that
protocol requires ~100 independently-verified calls before trusting an
automated path, not one.

**2. Even within a correctly-flagged item, one sub-claim was factually wrong.**
`APBIO-MCQ-099` was flagged `contains_out_of_scope_content` and listed
"biomagnification" and "eutrophication" among the out-of-scope concepts.
Checked directly: both terms are explicitly named in the fact pack, verbatim,
at EK 8.7.C.1 ("Human impact accelerates extinctions, incl. biomagnification
and eutrophication"). That specific claim is simply wrong — a fabricated gap
inside an otherwise-plausible flag (the item's actual defect is more likely
the "niche complementarity" / canopy-layer mechanism detail, which is a fair
catch: the CED names "niche partitioning" at 8.5.B.3 but nothing about
vertical canopy layers, rooting depths, or phenology).

## What checked out clean against verified exclusion text

Grepped the fact pack directly for the specific terms each flagged item cited
as out-of-scope:

- `APBIO-FRQ-L-001` and `APBIO-FRQ-L-015` both cite the fact pack's own
  exclusion statements almost verbatim: "3.4 Photosynthesis *(Exclusion:
  Calvin-cycle steps, molecule structures, ...)*" and "*(Exclusion:
  memorization of glycolysis/Krebs steps, structures, enzyme ... )*" are real
  lines in `AP_BIOLOGY_CED_FACT_PACK.md`. Both FRQs ask students to name
  specific Calvin-cycle/glycolysis/Krebs intermediates (3-PG, RuBP fate,
  named carbon-tracking steps) — content the fact pack explicitly excludes.
  Neither of these was part of Adil's original four findings — this is new.
- `APBIO-FRQ-L-014` (rotenone, oligomycin, DNP, mitochondrial fission) and
  `APBIO-FRQ-L-009` ("Pasteur effect") cite terms that return **zero matches**
  anywhere in the fact pack — consistent with genuine, previously-uncaught
  gaps.

## Reading this result

Net: in one unverified pass, the check surfaced at least two plausible new
defect classes (named Calvin-cycle/glycolysis intermediates; named drugs and
cell-biology terms with zero CED grounding) that no human review had flagged
yet — and simultaneously missed a defect it had caught cleanly one run
earlier, while also asserting one flatly false claim inside a correct-verdict
item. That combination — real signal, real noise, in the same 20-item batch
— is the argument for the protocol's own design: single-pass automated
verdicts are useful as a "look here" filter, not as an auto-accept or
auto-discard oracle. Nothing here should move any item's review status
without a second, independent look — model or human.
