# Label gap fill Units 1-5, round 2: CED-text rulings on the residue (2026-11-13)

Owner approved (chat, 2026-11-13): CED-text rulings by Claude for the no-majority items and the existing-cell conflicts, and release of the 10 held items held for "other". **Correction:** in my message I counted the no-clear-topic group as 68; it is **50** (32 no majority + 18 below 5 of 6). Reviewed: 83 items (50 + 23 non-validated cell conflicts + 10 "other" held). Ruled: **82**. Left unlabeled: **1** (`apprecalc-frq-np2-010`: three unrelated parts across Units 1 and 3, no single topic).
Rules: the existing validated cell is never changed (the topic equals it); a non-validated provisional/authored primary cell that disagrees is replaced by a new validated cell (the old one is kept, non-primary and `superseded_by` the new one); a variant follows its seed family; required units from the votes (units named by >= 4) unless noted. Sources: the item text, the part prompts, the per-topic text in `docs/product/*_CED_FACT_PACK.md`, the six-vote tallies.

**Voter blind spot found and checked:** 43 FRQs were voted from a stem that omitted the part prompts (stored in `prompt_json.parts`). All were re-voted with the parts included (measured $0.89, `stage3_rerun/`): **25 of the 27 already-published labels agree** (>= 4 of 6); **2 differ and are NOT changed** (validated labels are never changed without asking): `apcalcab-frq-u13-003` (published 2.3; parts-informed vote 2.1, 3 of 5, same unit) and `apcalcbc-frq-u13-015` (published 3.6; vote split 2.10/3.6). The parts-informed votes also informed the rulings on `apcalcab-frq-u13-002/-007/-012`, `apprecalc-frq-u12-002/-014/-016`.

| Item | Subject | Topic | Cell | Serving label | Reason |
|---|---|---|---|---|---|
| APSTATS-MCQ-097 | statistics | 1.13 | validated cell kept | new label, units 1,4 | validated cell 1.13 stays; the item also needs the Unit 4 difference-of-means inference |
| apcalcab-frq-023 | calculus_ab | 5.5 | existing promote_in_place | new label, units 2,3,5,6,8 | Candidates Test for absolute extrema is the central ask; matches 4 of 6 votes and the existing cell |
| apcalcab-frq-024 | calculus_ab | 1.13 | existing promote_in_place | new label, units 1,2 | finding k that makes f continuous is removing a discontinuity; existing cell, 2 of 4 votes |
| apcalcab-frq-030 | calculus_ab | 5.9 | existing promote_in_place | new label, units 5 | multi-part sign-chart analysis of f, f' and f'' reasoning is 5.9; 4 of 6 votes and cell |
| apcalcab-frq-u13-002 | calculus_ab | 1.10 | existing promote_in_place | label already served | parts read one-sided limits and classify the discontinuity; 4 of 6 votes and cell (voters did not see the parts) |
| apcalcab-frq-u13-007 | calculus_ab | 2.6 | existing promote_in_place | label already served | parts ask sum/difference/constant-multiple rules with the power rule; plurality and cell (voters did not see the parts) |
| apcalcab-frq-u13-012 | calculus_ab | 1.13 | existing promote_in_place | label already served | parts end in redefining the function to remove the discontinuity after classifying it; existing cell (voters did not see the parts) |
| apcalcab-frq-u1n-005 | calculus_ab | 1.9 | 1.13 x None [provisional_model] | label already served | table estimate + algebraic evaluation + continuity of the extension is connecting representations of limits |
| apcalcab-frq-u1v-001-v1 | calculus_ab | 1.13 | existing promote_in_place | label already served | removable discontinuity and the value that removes it; plurality 3 of 5 and cell |
| apcalcab-frq-u1v-005-v1 | calculus_ab | 1.9 | 1.13 x None [provisional_model] | label already served | variant stays in its seed family |
| apcalcab-frq-u1v-005-v2 | calculus_ab | 1.9 | 1.13 x None [provisional_model] | label already served | variant stays in its seed family (5 of 6 votes said 1.6, algebra only; seed structure is 1.9) |
| apcalcab-frq-u1v-005-v3 | calculus_ab | 1.9 | 1.13 x None [provisional_model] | label already served | variant stays in its seed family |
| apcalcab-mcq-027 | calculus_ab | 2.10 | 2.8 x None [provisional_model] | label already served | tests the derivatives of sec and tan (3 of 5 votes); product rule is incidental; same unit as the cell 2.8 |
| apcalcab-mcq-060 | calculus_ab | 1.3 | existing promote_in_place | label already served | limit read from a described graph; cell; votes four-way split |
| apcalcab-mcq-u1n-002 | calculus_ab | 2.1 | existing promote_in_place | label already served | average rates tending to the instantaneous rate; 4 of 6 and cell |
| apcalcab-mcq-u1n-004 | calculus_ab | 1.5 | 1.2 x None [provisional_model] | label already served | evaluating each one-sided limit by substituting into the formula is applying limit properties; 5 of 6 votes override the provisional cell 1.2 (same un |
| apcalcab-mcq-u1n-012 | calculus_ab | 1.7 | existing promote_in_place | label already served | choose rewriting as a piecewise and use one-sided limits for |x-3|/(x-3): selecting a procedure; existing cell (same unit as the 1.6 plurality) |
| apcalcab-mcq-u1n-018 | calculus_ab | 1.13 | existing promote_in_place | label already served | value of k that makes g continuous is removing a discontinuity |
| apcalcab-mcq-u1n-020 | calculus_ab | 1.13 | existing promote_in_place | label already served | parameter that makes f continuous is removing a discontinuity |
| apcalcab-mcq-u1n-029 | calculus_ab | 1.15 | existing promote_in_place | label already served | limit at infinity comparing growth rates; 4 of 6 and cell (L Hospital 4.7 is not needed) |
| apcalcab-mcq-u1v-002-v1 | calculus_ab | 2.1 | existing promote_in_place | label already served | variant of 2.1 seed; 3 of 5 and cell |
| apcalcab-mcq-u1v-002-v2 | calculus_ab | 2.1 | existing promote_in_place | label already served | variant of 2.1 seed; 4 of 6 and cell |
| apcalcab-mcq-u1v-004-v1 | calculus_ab | 1.5 | 1.2 x None [provisional_model] | label already served | variant of the same family; 5 of 5 votes; replaces provisional cell 1.2 (same unit) |
| apcalcab-mcq-u1v-007-v2 | calculus_ab | 1.5 | existing promote_in_place | label already served | quotient limit property when both limits are 0; cell |
| apcalcab-mcq-u1v-009-v1 | calculus_ab | 1.6 | existing promote_in_place | label already served | sin(kx)/(mx) limit by manipulation; plurality and cell |
| apcalcab-mcq-u1v-009-v2 | calculus_ab | 1.6 | existing promote_in_place | label already served | same family; plurality and cell |
| apcalcab-mcq-u1v-014-v1 | calculus_ab | 1.10 | existing promote_in_place | label already served | identify which model has an infinite discontinuity: types of discontinuities; cell |
| apcalcab-mcq-u1v-014-v3 | calculus_ab | 1.10 | existing promote_in_place | label already served | same family; 4 of 6 and cell |
| apcalcab-mcq-u1v-019-v2 | calculus_ab | 1.13 | existing promote_in_place | label already served | same family |
| apcalcab-mcq-u1v-020-v1 | calculus_ab | 1.13 | existing promote_in_place | label already served | same family |
| apcalcab-mcq-u1v-020-v2 | calculus_ab | 1.13 | existing promote_in_place | label already served | same family |
| apcalcab-mcq-u1v-020-v3 | calculus_ab | 1.13 | existing promote_in_place | label already served | same family |
| apcalcbc-frq-017 | calculus_bc | 1.13 | existing insert | new label, units 1,2 | find k so f is continuous (removing the discontinuity) is the lead ask; parts also use the derivative definition (Unit 2) and IVT |
| apchem-mcq-042 | chemistry | 4.9 | existing insert | new label, units 4 | oxidizing agent and oxidation-state change in a redox reaction; 5 of 5 votes (owner approved release of the hold) |
| apchem-sfrq-023 | chemistry | 4.9 | existing insert | new label, units 4 | redox half-reactions and oxidizing agent; 5 of 5 votes (owner approved release of the hold) |
| apphy1-frq-012 | physics_1 | 4.4 | existing insert | label already served | perfectly inelastic collision and why kinetic energy is not conserved; 4 of 6 votes |
| apphy1-frq-019 | physics_1 | 1.4 | validated cell kept | new label, units 1 | validated cell; 5 of 5 votes (hold released) |
| apphy1-frq-026 | physics_1 | 3.4 | validated cell kept | new label, units 1,3 | validated cell; 5 of 5 votes (hold released) |
| apphy1-frq-np1-010 | physics_1 | 3.5 | validated cell kept | new label, units 2,3 | validated cell; 5 of 5 votes (hold released) |
| apphy1-mcq-045 | physics_1 | 5.6 | existing insert | new label, units 5 | rotational form of Newton second law; 5 of 5 votes (hold released) |
| apphy2-frq-003 | physics_2 | 11.8 | validated cell kept | new label, units 10,11 | validated cell; 6 of 6 votes (hold released) |
| apphy2-frq-008 | physics_2 | 9.4 | validated cell kept | new label, units 9 | validated cell; 5 of 5 votes (hold released) |
| apphy2-frq-035 | physics_2 | 11.8 | validated cell kept | new label, units 10,11 | validated cell; 5 of 5 votes, also parts-included revote (hold released) |
| apphycem-frq-021 | physics_c_em | 9.2 | validated cell kept | new label, units 8,9 | validated cell; 5 of 5 votes (hold released) |
| apphycem-mcq-037 | physics_c_em | 12.1 | existing insert | label already served | CED fact pack: topic 12.1 includes the closed-loop Gauss law for magnetism integral |
| apphycm-frq-044 | physics_c_mechanics | 3.4 | existing insert | label already served | energy conservation for a spring-mass maximum speed needs Unit 3 only; keeps the recorded unit (7.4 would move it to Unit 7) |
| apprecalc-frq-002 | precalculus | 2.10 | validated cell kept | new label, units 2 | validated cell 2.10 stays; serving label only |
| apprecalc-frq-020 | precalculus | 2.6 | existing insert | new label, units 2 | fitting a two-term exponential model and comparing its prediction with the pattern is competing-model validation |
| apprecalc-frq-np2-007 | precalculus | 2.13 | existing insert | new label, units 2,3 | two of three parts are logarithm/exponential equation work (2.12 rewrite, 2.13 solve); part (c) trig equation adds Unit 3 |
| apprecalc-frq-u12-002 | precalculus | 2.12 | validated cell kept | new label, units 2 | validated cell 2.12 stays; serving label only |
| apprecalc-frq-u12-014 | precalculus | 2.12 | validated cell kept | new label, units 2 | validated cell 2.12 stays; parts-included revote 5 of 6 on 2.12 |
| apprecalc-frq-u12-016 | precalculus | 2.2 | validated cell kept | new label, units 2 | validated cell 2.2 stays; parts-included revote 4 of 6 |
| apstat-compare_stats-090000 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090001 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090002 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090003 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090004 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090005 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090006 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090007 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090008 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090009 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090010 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090011 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090012 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090013 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090014 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090015 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090016 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090017 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090018 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-compare_stats-090019 | statistics | 1.7 | 1.9 x 3.B [authored] | new label, units 1 | asks for a difference of two computed summary statistics (mean/median/IQR); CED 1.7; replaces the authored 1.9 tag (same unit) |
| apstat-u1-11-2a-sampling-101002 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101004 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101006 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101012 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101016 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101018 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-11-2a-sampling-101019 | statistics | 1.12 | 1.11 x 2.A [authored] | new label, units 1 | stem describes a voluntary-response or convenience plan: bias in sampling is 1.12; replaces the authored 1.11 tag (same unit) |
| apstat-u1-6-4a-distribution-106005 | statistics | 1.6 | existing keep_authored | new label, units 1 | describing a distribution from a five-number summary (shape, center, spread, outliers) is 1.6; matches the authored cell |
| apstat-u1-6-4a-distribution-106007 | statistics | 1.6 | existing keep_authored | new label, units 1 | describing a distribution from a five-number summary (shape, center, spread, outliers) is 1.6; matches the authored cell |
| apstat-u1-6-4a-distribution-106018 | statistics | 1.6 | existing keep_authored | new label, units 1 | describing a distribution from a five-number summary (shape, center, spread, outliers) is 1.6; matches the authored cell |
