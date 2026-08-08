# AP Physics 1 new-protocol batch — 2026-08-08

Owner-directed: update the Physics 1 CED (David supplied the full 220-page
primary-source CED PDF for the first time this session), then author 10 FRQs
+ 10 MCQs for Units 1-3 (Kinematics; Force and Translational Dynamics; Work,
Energy, and Power) using the same protocol as the Calc/Precalc/E&M batches
(grounded authoring + full hand verification before insertion), assigned to
Muhammad Saood.

**Blocked on execution.** The Supabase MCP connection lost authorization
partway through this session (a simple test query returned a permission
error). Nothing in this directory has been run against the database yet.
Before running, re-authorize the Supabase MCP connection, then complete the
three pre-run checks called out in each script's header:

1. Confirm the `app.exam_packs.exam_name` value actually used for Physics 1
   (scripts assume `'AP Physics 1'`, matching the other three Physics C
   scripts' naming convention, but this was not re-queried this session).
2. Confirm the live `content_key` prefix is `apphy1-` (recalled from earlier
   session context — `apphy1-frq-047`, `apphy1-frq-013` — but not re-verified
   this session).
3. Confirm Muhammad Saood is a qualified reviewer for AP Physics 1 in
   `app.validator_qualifications` before running the assignment script; if
   not, re-target the assignment to a qualified reviewer instead.

## CED update

`docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` — new "Units 1-3 deep-tier
detail" section (Physics 1's second Physics subject off bare tier, after
E&M), grounded in the CED PDF (pages 21-74, read via 3 parallel research
passes) plus the 2024 Scoring Guidelines, Chief Reader Report, and Q1/Q2
Sample Student Responses booklets. Headline finding: only about half of
students correctly identified the *downward* direction of the normal force
at the top of a vertical circular loop (2024 Chief Reader Report) — the
single strongest documented Unit 2 misconception, driven by over-applying
the flat-surface "normal force points up" habit to a curved track. Units 4-8
remain topic-map tier.

## Content batch

20 items, content-key scheme `apphy1-frq-np1-001..010` /
`apphy1-mcq-np1-001..010` (Physics 1's first new-protocol batch). Every FRQ
criterion and MCQ distractor traces to a specific documented misconception,
exclusion/boundary statement, or scoring convention from the research above:

- The vertical-loop normal-force-direction misconception (the headline
  finding above) — FRQ 6, MCQ 4.
- Static friction as an inequality (not always at its maximum value), versus
  kinetic friction as an equality — FRQ 4 (equality case), MCQ 5 (inequality
  case, crate below max static friction).
- The 1-D-only restriction on relative-velocity vector addition (CED 1.4) —
  MCQ 3.
- The gravity-only action-at-a-distance restriction (CED 2.3) — MCQ 6.
- The qualitative-only scope for nonuniform acceleration, and the g=10 vs.
  9.8/9.81 no-penalty policy (CED 1.3) — MCQ 1, MCQ 2.
- The constant-force-only cosine work formula (never a dot product) versus a
  sine-instead-of-cosine slip — FRQ 8, MCQ 7.
- Conservative/nonconservative path-(in)dependence (CED 3.2) — FRQ 9, MCQ 8.
- The documented delta-K = (1/2)m(delta v)^2 algebra error, versus the
  correct delta-K = (1/2)m*delta(v^2) (2024 CRR / Q1-Q2 sample responses) —
  MCQ 9.
- The frictionless-banked-curve scope (explicitly in-scope per the CED's
  boundary statement, unlike the friction-required case) — FRQ 7.

All 20 items are fully drafted and hand-verified by direct computation (see
each SQL file's header for the worked numbers), but **not yet inserted** —
see the blocked-on-execution note above. Once the Supabase MCP is
reauthorized and the three pre-run checks pass, run in order:

1. `20260808_apphy1_newprotocol_units1-3_frq_batch.sql`
2. `20260808_apphy1_newprotocol_units1-3_mcq_batch.sql`
3. `20260808_apphy1_newprotocol_assign_saood.sql`

All items insert as `status='draft'`, structural gates clean (4-choice/1-key
MCQs, positive-point FRQ criteria).
