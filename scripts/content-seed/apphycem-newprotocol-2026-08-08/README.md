# AP Physics C: E&M new-protocol batch — 2026-08-08

Owner-directed: update the E&M CED (first Physics subject to move off bare
tier — David supplied the full 189-page primary-source CED PDF for the first
time), then author 20 new-protocol items for Units 8/9/10 using the same
protocol as the Calc/Precalc batches (grounded authoring + full hand
verification before insertion), assigned to Muhammad Saood — the reviewer
who has personally handled nearly the entire E&M corpus to date (117 of 117
corpus-wide decisions) and whose edits-or-worse rate there (84.6%) is the
highest of any subject/reviewer pairing checked this session.

## CED update

`docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md` — new "Units 8-10 deep-tier
detail" section, grounded in the CED PDF (pages 21-58) plus the 2025 Scoring
Guidelines, Chief Reader Report, and Q1 Sample Student Responses booklet.
Headline finding: capacitance-with-dielectric for a non-parallel-plate
geometry is the single lowest-scoring, most explicitly documented failure
mode in the whole Units 8-10 exam content (mean scores 0.19-0.26/1) — a
"significant number" of real graded responses reached for the parallel-plate
formula `C=κε₀A/d` regardless of the actual (cylindrical/spherical) geometry.
Units 11-13 remain bare tier.

## Content batch

20 items, content-key scheme `apphycem-frq-np1-001..010` /
`apphycem-mcq-np1-001..010` (E&M's first new-protocol batch). Every FRQ
criterion and MCQ distractor traces to a specific documented misconception
or scoring-architecture rule from the research above:

- Gauss's-law Gaussian-surface-area and enclosed-charge errors (cylindrical
  vs. spherical confusion, using the Gaussian radius instead of the charge's
  actual radius) — items 1, 2, 6, 7, 10 (FRQ) and 1, 2, 6, 10 (MCQ).
- The calculus-based field/potential exclusion to five named geometries
  (ring on-axis used directly) — FRQ 3, 4.
- Vector (field) vs. scalar (potential) superposition contrast, including the
  real "field cancels at a ring's center but potential doesn't" distinction
  — FRQ 4, 9 and MCQ 4, 8.
- Conductor electrostatic-equilibrium qualitative content — FRQ 5, MCQ 9.
- The dielectric/non-parallel-plate capacitance trap (the headline finding
  above) — FRQ 9, 10 and MCQ 5.

All 20 inserted as `status='draft'`, structural gates clean (4-choice/1-key
MCQs, positive-point FRQ criteria), every criterion and answer key
independently hand-verified by direct computation before insertion. Assigned
to Muhammad Saood via `content_review_assignments`
(`review_stage='tutor_question'`, `assignment_purpose='subject_review'`).

SQL executed directly against Production via the Supabase MCP tool following
the same INSERT pattern used in the Calc AB and Precalculus replication
batches (`scripts/content-seed/replication-batch-2026-08-08/`); the exact
statements are recorded in the session transcript and in
`docs/activity_log/ACTIVITY_LOG.md`'s entry for this date.
