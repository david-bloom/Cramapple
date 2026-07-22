# Drawn-Response Item Draft Reviews

**Status:** Running log of second-reviewer checks on Gemini-drafted
`DRG-P1-*` item packages, per `TASK-0011_PHASE_1_EXECUTION_SPEC.md`
section 3.2 step 2 ("a second reviewer reproduces every displayed value
from the recorded source").
**Owner:** Product Owner with Learning Quality Owner
**Related:** `docs/research/TASK-0011_PHASE_1_EXECUTION_SPEC.md`,
`docs/research/DRAWN_RESPONSE_PILOT_V0_REVIEW.md` (prior review, same
discipline applied to the earlier 3-prompt pilot)

## How To Read This Log

Each entry checks what a second reviewer can check from the draft text
alone: data reproducibility, archetype-specific rules, criterion-taxonomy
correctness, and rights-language honesty. **No entry here constitutes
Learning Quality approval, source-isolation/similarity clearance, or
Product Owner participant-use approval** — those remain separate,
required steps per spec section 3.2 regardless of what this log says.

A draft can fail this check (reproducibility error, rights overstatement,
archetype-rule violation) or pass it with or without minor fixes noted.
Passing this check is necessary, not sufficient, for the item to proceed.

## Entries

### DRG-P1-05 (draft 1) — 2026-06-19

**Verdict:** Passes reproducibility and archetype-rule check, with one
quality flag and two minor fixes noted.

**Reproducibility:** Formula `ΔM = -35.0·C + 10.5` reproduces all five
display-table values exactly (C=0.0→10.5, 0.2→3.5, 0.4→-3.5, 0.6→-10.5,
0.8→-17.5). Stated synthetic replicates also average to the displayed
mean exactly in all five groups.

**Quality flag (not a reproducibility failure):** every replicate triple
sums to exactly 3× the formula value in all five groups, with zero
residual noise structure. This is internally consistent but does not
actually model experimental variation — it reads as numbers fitted to a
target mean after the fact rather than independently generated replicate
noise. Does not affect any criterion (05 has no `UNCERTAINTY_MARKS`
requirement). Open call: acceptable as-is, or request regenerated
replicates with genuine (still-reproducible) noise.

**Archetype rules (spec §3.1, DRG-P1-05), all satisfied:** y-axis
includes zero and both signs; single best-fit line required and
correctly distinguished from connect-the-dots in `contradictions`;
estimate visibly linked to the zero-crossing via
`ZERO_INTERCEPT_ANNOTATION`; annotation and reported estimate correctly
use the x-variable unit (M), not the y-variable unit (%).

**Estimate math:** solving `-35.0·C + 10.5 = 0` gives C = 0.3 exactly,
matching the stated estimate. Correct.

**Criterion taxonomy:** all eleven criteria use valid shared labels;
correctly excludes `CATEGORY_IDENTITY`, `UNCERTAINTY_MARKS`,
`POINT_CONNECTION`, and `PLATEAU_ANNOTATION`, none of which apply to this
archetype.

**Rights language:** correctly states novelty/similarity as
"unverified, pending qualified human source-isolation and similarity
review" — does not overstate or invent an approval, unlike the original
pilot's P0-3 finding.

**Minor fixes, not blocking:**
1. `accepted_variants` contains a contradiction-style statement ("Bar
   graphs... are not accepted") that belongs in `contradictions` instead.
2. `minimum_feedback` is templated/generic at this stage, which is
   expected for an item-package template with no response to cite yet.
   Flag for whoever builds the feedback-generation pipeline: this text
   needs an actual cited observation before deployment, or it fails DR-2
   Tier 1's grounding check as written.

**Still required before use:** Learning Quality approval of criteria,
qualified source-isolation/similarity review, Product Owner participant-
use approval (spec §3.2 steps 3, 4, 7).

## Batch 2 — 10-Draft Run — 2026-06-19

Ten drafts submitted in one document. Mapped to item_id by content
against the locked item table in `TASK-0011_PHASE_1_EXECUTION_SPEC.md`
section 3, since not every draft carried an explicit `item_id` header.
Coverage: all six items got at least one draft. DRG-P1-03 got three
submissions (one an exact duplicate of another). DRG-P1-01 and DRG-P1-06
got two independent candidates each. DRG-P1-02, 04, and 05 got one each.

All ten correctly used the honest rights/similarity template ("unverified,
pending qualified human source-isolation and similarity review") with no
overstated approvals — that constraint held across the full batch.

### DRG-P1-04 candidate — photosynthesis vs. light intensity

**Verdict:** Minor reproducibility fix needed; otherwise passes.

**Reproducibility:** Formula `P(I) = 40.0·I/(100+I)` reproduces 6 of 7
table values exactly. At I=500, the formula gives 33.3 (40·500/600 =
33.333...) but the table and the stated replicates (32.4, 34.6, 33.2 →
mean 33.4) both show 33.4. The replicate-derived value is internally
consistent with itself; it is the formula that doesn't match its own
table at this one point. Fix: adjust the formula or replace the I=500
replicate set so both methods agree, same remediation pattern as the
original pilot's P0-1/P0-2.

**Archetype rules (spec §3.1, DRG-P1-03/04):** x positions reflect actual
numeric intervals, not column spacing — satisfied. `POINT_CONNECTION`
correctly used instead of `BEST_FIT_RELATIONSHIP` (this is a measured
series, not a fitted relationship). SEM bars symmetric — satisfied.

**Criterion taxonomy:** correct set for this archetype (no
`CATEGORY_IDENTITY`, `BEST_FIT_RELATIONSHIP`, or annotation criteria).

### DRG-P1-03 candidate A — enzyme reaction rate vs. temperature (carbohydrate-digesting enzyme, peak 60°C)

**Verdict:** Passes on everything checkable.

**Reproducibility:** The stated generative formula did not survive
extraction legibly (LaTeX fractions were mangled into plain text) and
could not be independently verified. However, the data source also states
explicit synthetic replicates (Method b), and **all eight group means
recompute exactly** from those replicates (e.g. 10°C: (12.3+14.1+12.6)/3
= 13.0 ✓; 60°C: (52.7+55.4+53.9)/3 = 54.0 ✓, confirming the claimed
interior maximum at 60°C is real in the data, not just asserted). Spot-
checked SEM values also recompute correctly from the same replicates.
Since the displayed table is independently reproducible from the
replicates regardless of the formula's legibility, this passes — but ask
for the formula to be re-supplied in a form that survives copy/paste
(plain Python-style notation, not LaTeX) so it can be checked directly
next time.

**Archetype rules:** satisfied (non-monotonic series, `POINT_CONNECTION`
used correctly, SEM bars symmetric).

### DRG-P1-03 candidate B — MDH-V enzyme vs. temperature (peak 50°C)

**Verdict:** Passes on everything checkable. **Submitted twice, byte-for-
byte identical** — treat as one candidate, not two independent drafts.

**Reproducibility:** Same situation as candidate A — generative formula
illegible after extraction, but all eight replicate-derived means
recompute exactly (e.g. 50°C: (9.9+9.3+9.5+9.7)/4 = 9.6 ✓, confirming the
interior maximum at 50°C, higher than both 40°C=8.1 and 60°C=7.0). SEM
spot-checks (10°C: s=0.3162, SEM=s/√4=0.1581→0.2) recompute correctly.

**Archetype rules:** satisfied, same as candidate A.

**Decision needed:** DRG-P1-03 now has two independently valid biological
scenarios (generic thermophilic enzyme vs. MDH-V) for one locked item
slot. Pick one; the other is a reasonable banked alternative, not a
second phase-1 item (six items is the locked scope).

### DRG-P1-06 candidate A — *Micrococcus viridis* logistic growth

**Verdict:** Fails reproducibility. Do not advance without remediation.

**Reproducibility:** Formula `N(t) = K·N0·e^(rt) / (K + N0·(e^(rt)-1))`
with K=75.0, N0=2.5, r=0.35 does **not** reproduce its own table at 5 of
7 points:

| t (hr) | Formula gives | Table shows | Diff |
| --- | ---: | ---: | ---: |
| 4 | 9.2 | 9.4 | 0.2 |
| 8 | 27.1 | 28.2 | 1.1 |
| 12 | 52.3 | 54.3 | 2.0 |
| 16 | 67.7 | 68.7 | 1.0 |
| 20 | 73.1 | 73.3 | 0.2 |

This uses the "deterministic formula + rounding rule" method (Method a)
with **no replicate fallback** to verify against, unlike the 03
candidates above — so there is no independent confirmation the table is
right at all. This is the same severity as the original pilot's P0-1/P0-2
findings. Required remediation per that precedent: either correct the
parameters so the formula reproduces every value exactly, or switch to
explicit replicate observations (Method b) and show the arithmetic.

**Separate finding, also present in candidate B below:** the student-facing
prompt says *"determine the carrying capacity (plateau value)... Report
this estimated plateau value"* — using "carrying capacity" directly in
student-facing text. `DRAWN_RESPONSE_PILOT_V0_REVIEW.md` section 4.2
already required removing this exact term from a prior pilot prompt
specifically because it tests recall of a vocabulary word instead of
graph construction, and risks implying an immutable species constant.
Required student-facing wording per that prior correction: *"Estimate the
population density around which the culture levels off under these
conditions."* This recurring in two independent drafts means the item-
generation prompt should be updated to state this as a hard constraint,
not just rely on the model recalling the prior project lesson.

### DRG-P1-06 candidate B — marine microalgae logistic growth

**Verdict:** Passes reproducibility cleanly. Same wording issue as
candidate A.

**Reproducibility:** Formula `f(t) = L/(1+e^(-k(t-t0)))` with L=14.0,
k=0.18, t0=16.0 reproduces **all 7** table values exactly to one decimal
(t=0: 0.7441→0.7 ✓; t=48: 13.9560→14.0 ✓, etc.). This is the cleanest
formula-based draft in the batch — no discrepancy at any point.

**Archetype rules (spec §3.1, DRG-P1-06):** linear y-axis with rescaled
unit (×10⁵ cells/mL) — satisfied; smooth trend consistent with plotted
observations — satisfied; estimate visibly linked to the plateau region —
satisfied via `PLATEAU_ANNOTATION`.

**Wording issue (same as candidate A):** student prompt says *"use it to
estimate the carrying capacity (maximum population density)"* — same
required fix as above.

**Recommendation:** of the two DRG-P1-06 candidates, this one should be
the default pick — it has no reproducibility defect, candidate A does.
Both need the carrying-capacity wording fixed before either proceeds.

### DRG-P1-01 candidate A — stomatal density, *Asarum canadense*

**Verdict:** Passes cleanly.

**Reproducibility:** Method b, four replicates per of four treatments,
all four means and all four SEMs recompute exactly (e.g. Deep Shade:
(33+36+32+38+31)/5 = 34.0 ✓; SEM = 2.9155/√5 = 1.3038 → 1.3 ✓).

**Archetype rules (spec §3.1, DRG-P1-01/02):** category order preserved
unless reordering is recorded as an accepted variant (it is, correctly,
in `accepted_variants`); y-axis starts at exactly zero; SEM bars
symmetric; no separate legend required since categories are written on
the x-axis. All satisfied.

### DRG-P1-02 candidate — RBC membrane leakage across four solutions

**Verdict:** Passes cleanly.

**Reproducibility:** Method b, all four means and SEMs recompute exactly
(e.g. Solution A: (0.04+0.06+0.03+0.07)/4 = 0.05 ✓; SEM = 0.01826/2 =
0.00913 → 0.01 ✓).

**Content note (positive):** correctly implements the spec's stated
distinguishing feature for this item — "tests category identity and
close-valued groups" — Solutions A/B (0.05 vs 0.09) and C/D (0.78 vs
0.82) are each close-valued pairs, which is exactly the discrimination
test the locked item table calls for.

**Archetype rules:** all satisfied, same checklist as DRG-P1-01 above.

### DRG-P1-01 candidate B — stomatal density, canopy-shading shrub

**Verdict:** The underlying data is reproducible; the cited formula is
not. Fix before advancing.

**Reproducibility:** All four group means and SEMs recompute exactly from
the stated replicates (e.g. Full Shade: (44.1+46.8+43.5+45.9+44.7)/5 =
45.0 ✓). But the draft *also* asserts a "generative baseline" formula,
`D(L) = 12.0·ln(L+2) + 24.0`, which does **not** match the table at any
of the four points:

| Light % | Formula gives | Table shows | Diff |
| --- | ---: | ---: | ---: |
| 5 | 47.4 | 45.0 | 2.4 |
| 15 | 58.0 | 57.6 | 0.4 |
| 40 | 68.9 | 67.8 | 1.1 |
| 100 | 79.5 | 79.2 | 0.3 |

The replicates are real and internally verified, so the table itself is
trustworthy — but stating a generative model that contradicts the data it
supposedly generated is its own integrity problem, independent of whether
the final numbers happen to be usable. Fix: either correct the formula's
parameters so it actually reproduces the table, or drop the "generative
baseline" framing entirely and describe this item as built from explicit
replicates only (Method b), with no formula claim.

**Archetype rules:** otherwise satisfied (category order, zero-baseline
y-axis, symmetric SEM bars).

**Recommendation:** between the two DRG-P1-01 candidates, candidate A
(*Asarum canadense*) is ready as-is; candidate B needs the formula
contradiction resolved first.

## Batch 2 Summary And Recommended Picks

| Item | Candidates | Recommended pick | Status |
| --- | --- | --- | --- |
| DRG-P1-01 | A (*Asarum canadense*), B (shrub) | A | Ready (pending LQ/rights/PO steps) |
| DRG-P1-02 | 1 | — | Ready (pending LQ/rights/PO steps) |
| DRG-P1-03 | A (generic enzyme), B (MDH-V, submitted twice) | Either — both pass | Ready (pending LQ/rights/PO steps); formula text should be resupplied legibly |
| DRG-P1-04 | 1 | — | Needs the I=500 fix |
| DRG-P1-05 | 1 (Batch 1) | — | Ready (pending LQ/rights/PO steps); replicate-noise quality flag open |
| DRG-P1-06 | A (*Micrococcus*), B (microalgae) | B | A fails reproducibility outright; both need the carrying-capacity wording fix |

**Process note:** the item-generation prompt should be revised to add an
explicit hard constraint against using "carrying capacity" (or similarly
loaded vocabulary that implies a fixed species constant) in student-facing
text for any plateau-estimate item, since this recurred independently in
two separate drafts despite being a previously documented and corrected
finding in this same project.

## Batch 2 Resolution — 2026-06-19

All findings above were corrected directly in
`docs/research/DRAWN_RESPONSE_FRQs.rtfd`:

- DRG-P1-04: I=500 replicate set and table corrected to 33.3 (matching
  the formula); SEM recomputed to 0.7.
- DRG-P1-06 candidate A: full calculation table recomputed from the
  stated formula/parameters (K=75.0, N0=2.5, r=0.35); 5 of 7 points
  corrected (t=4,8,12,16,20).
- Both DRG-P1-06 candidates: student-facing prompt no longer uses
  "carrying capacity" — replaced with "the population density around
  which the culture levels off under these conditions," per the
  pre-existing `DRAWN_RESPONSE_PILOT_V0_REVIEW.md` §4.2 correction.
  Internal/reviewer-facing fields (`expected_graph_spec`,
  `contradictions`, `development_tolerances`) still use the term where
  appropriate, matching that same prior guidance.
- DRG-P1-03 candidate A: unverifiable generative-formula claim removed;
  now described as Method b (explicit replicates) only, which was always
  the actual verified source.
- DRG-P1-01 candidate B: same fix — false `D(L) = 12.0·ln(L+2) + 24.0`
  claim removed; described as Method b only.
- DRG-P1-03 candidate B: exact-duplicate submission removed; one copy
  retained.
- DRG-P1-05: bar-graph exclusion statement moved from `accepted_variants`
  to `contradictions`.
- All garbled SEM-formula notation (a copy-paste artifact from KaTeX
  square-root rendering, confirmed via the bundle's orphaned SVG
  attachments, which were square-root glyph paths with no other content
  and have been removed) was rewritten in plain, unambiguous notation
  across every affected entry.

Re-verified after editing: all formula-based entries now reproduce their
displayed tables exactly; entry count is 9 (duplicate removed); both
carrying-capacity instances in student-facing text are fixed; zero
remaining garbled symbols in the document.

**Not changed, still open:** DRG-P1-05's replicate-noise quality flag
(every triple sums to exactly 3x the formula value) remains a judgment
call, not corrected here, since it isn't a reproducibility defect.
DRG-P1-03's original formula text (both candidates) still cannot be
recovered from the corrupted source — the data is fully verified via the
replicate method regardless, but if the true generative formula matters
for future item variants, it should be re-supplied directly rather than
copy-pasted from a rendered math view.

## Batch 3 — 10-Draft Run (`DRAWN_RESPONSE_FRQs_v1.1.md`) — 2026-06-19

A second 10-draft batch, written directly in clean Markdown rather than
copy-pasted from a rendered-math source. Covers all six items: two
candidates each for DRG-P1-01, 03, 04, and 06; one candidate each for
DRG-P1-02 and DRG-P1-05. No literal duplicate submissions this time.

**Headline finding — systematic, batch-wide replicate-noise defect, more
severe than Batch 2's quality flag.** Every one of the 40 replicate
groups across all 10 drafts is a consecutive run of 5 integers (5
hundredths for the one absorbance-scale item), e.g. `32,33,34,35,36`
then `39,40,41,42,43`. This forces an identical standard deviation
(1.5811) and identical SEM (0.7, or 0.01 on the hundredths scale) in
*every single group in the entire document*, regardless of item,
archetype, or treatment — verified directly: `stdev([32,33,34,35,36])`
= `stdev([39,40,41,42,43])` = ... = 1.5811 in all cases checked. This is
visibly spottable by inspection (not just a statistical regularity an
analysis would catch) and means `UNCERTAINTY_MARKS` would never be
exercised against a realistic range of bar lengths anywhere in this
batch. Recommend regenerating all replicate sets with genuine (still
fully reproducible) variation before treating any of this batch as
usable.

**Reproducibility — clean.** All three Method-a (closed-form formula)
items reproduce their tables exactly with zero discrepancy:
- Draft 5 (DRG-P1-05): `y = 13.0 - 25.0x` reproduces all 6 points exactly
  (integers, no rounding even required).
- Draft 6 (DRG-P1-06): `N(t) = 12.0 - 11.0*e^(-0.18t)` reproduces all 8
  points exactly.
- Draft 10 (DRG-P1-06, second candidate): `N(t) = 18.0 - 16.5*e^(-0.11t)`
  reproduces all 8 points exactly.

This is a real improvement over Batch 2, where 2 of 4 formula-based
drafts failed reproducibility outright.

**Carrying-capacity wording fix held.** Both DRG-P1-06 candidates (drafts
6 and 10) correctly use "the population density around which the culture
levels off under these conditions" in student-facing text, and correctly
warn against treating the plateau as a fixed species constant in
`contradictions` — the Batch 2 process-note fix was applied successfully.

**Minor finding — draft 10's table doesn't fully visually converge.** True
asymptote is 18.0×10⁵ cells/mL; the table only reaches 17.2 by the last
time point (t=28), a 0.8 gap. A student reading the visible trend honestly
might estimate ~17.5, right at the edge of the stated ±0.5 tolerance.
Recommend one more time point (e.g. t=36) so the plateau is unambiguous,
the same fix Batch 2's marine-microalgae item already used (extended to
t=48 to fully flatten).

**Minor finding — `X_UNIT` misapplied to categorical items.** Drafts 1, 2,
and 7 (DRG-P1-01 candidates and DRG-P1-02) include an `X_UNIT` criterion
for a purely categorical x-axis ("uses category labels only, not a
numeric x unit"). Spec §4.2 scopes `X_UNIT` to "items with a unit-bearing
x variable," which these don't have — the criterion as written is
vacuous, automatically satisfied by definition. Batch 2's categorical
items correctly omitted `X_UNIT` entirely; this batch should match that.

**Archetype rules, criterion taxonomy (aside from the `X_UNIT` note), and
rights language:** all satisfied across all 10 drafts. Non-monotonic peak
shape correct for both DRG-P1-03 candidates (peaks at 50C and 55C
respectively); monotonic-then-plateau shape correct for both DRG-P1-04
candidates; DRG-P1-05's estimate correctly uses the x-variable unit (M).

## Batch 3 Summary And Recommended Picks

| Item | Candidates | Recommended pick | Status |
| --- | --- | --- | --- |
| DRG-P1-01 | Draft 1, Draft 7 | Either, content-wise | Blocked on batch-wide replicate-noise fix |
| DRG-P1-02 | Draft 2 | — | Blocked on batch-wide replicate-noise fix |
| DRG-P1-03 | Draft 3, Draft 8 | Either, content-wise | Blocked on batch-wide replicate-noise fix |
| DRG-P1-04 | Draft 4, Draft 9 | Either, content-wise | Blocked on batch-wide replicate-noise fix |
| DRG-P1-05 | Draft 5 | — | Reproducibility clean; ready pending LQ/rights/PO steps |
| DRG-P1-06 | Draft 6, Draft 10 | Draft 6 (fully converged plateau) | Reproducibility clean; Draft 10 needs one more time point |

**Process note:** the item-generation prompt should add an explicit
constraint against consecutive-integer (or otherwise arithmetically
regular) replicate sets — e.g. require that no two groups in the same
item produce the same standard deviation, and that replicate spacing not
follow a fixed step pattern.
