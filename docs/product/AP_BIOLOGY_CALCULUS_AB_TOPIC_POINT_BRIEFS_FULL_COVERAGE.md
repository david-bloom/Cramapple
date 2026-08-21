# AP Biology, AP Calculus AB, AP Calculus BC, and AP Precalculus Topic Point Brief Coverage

Status: Database seed implemented for the new-user home experience.

Purpose: give first-visit students useful, subject-specific guidance before
they have taken a diagnostic. Topic point briefs should explain how course
content becomes AP points without replacing full course instruction.

Canonical database seeds:
`supabase/migrations/20260820230000_seed_remaining_biology_calculus_topic_point_briefs.sql`

`supabase/migrations/20260821001000_ap_precalculus_and_calculus_bc_unit1_topic_point_briefs.sql`

Related prior seed:
`supabase/migrations/20260820192400_student_readable_taxonomy_and_topic_guides.sql`

## Coverage

The topic point brief surface now has published briefs for:

- AP Calculus AB: 85 topics, Units 1-8.
- AP Calculus BC: 16 topics, Unit 1.
- AP Biology: 60 topics, Units 1-8.
- AP Precalculus: 14 topics, Unit 1.
- Total published point briefs across these subjects: 175.

Existing AP Calculus AB Unit 1 explainers remain the only topic explainer set in
this pass. The new migration adds point briefs only.

## Student Promise

Each brief should help the student answer:

- What is this topic?
- Why does it matter for class and the AP exam?
- How do points get earned on this topic?
- What answer move should I practice?
- What common mistake costs points?

This is intentionally not a list of generic tactics. The point move must be
specific to the topic, such as:

- Calculus AB 4.1: attach derivative meaning to quantities, input, and units.
- Calculus AB 6.2: use subinterval width and sample height in a Riemann sum.
- Biology 2.7: compare solute concentrations and move water toward higher
  solute concentration.
- Biology 7.5: identify p, q, p^2, 2pq, and q^2 before interpreting
  Hardy-Weinberg results.

## Frontend Contract

The frontend should read from Supabase through the authenticated public guide
surface:

- `public.topic_point_briefs`
- `public.get_topic_point_guides(subject_key, unit_number, topic_code)`

Expected key behavior:

- Use `subject_key` values `ap_calculus_ab` and `ap_biology`.
- Unit selector should group by `unit_number`.
- Topic ordering should use `topic_sort_major` and `topic_sort_minor`, not raw
  lexicographic `topic_id` order.
- `learn_more_path` is present for every brief, but only Calculus AB Unit 1 has
  full explainer content in this pass.
- `practice_params` is present for every brief and can route practice by
  subject, unit, and topic.

## Authenticated QA Expectations

The QA script at `scripts/qa/topic_guides_database_qa.sql` expects:

- 175 published/public topic point briefs.
- 16 published/public topic explainers.
- 85 AP Calculus AB public topic point briefs.
- 60 AP Biology public topic point briefs.
- 16 AP Calculus BC Unit 1 public topic point briefs.
- 14 AP Precalculus Unit 1 public topic point briefs.
- 16 AP Calculus AB Unit 1 topic explainers.
- 0 AP Biology topic explainers for now.
