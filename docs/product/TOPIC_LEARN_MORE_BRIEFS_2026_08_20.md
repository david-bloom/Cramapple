# Topic Learn More Briefs

Status: production seed, August 20, 2026.

Purpose: make the `Learn more` action on a topic point card useful on first
visit. A topic point brief is the compact home-card version. A topic explainer is
the richer Learn More page payload.

## Coverage In This Pass

- AP Biology: all 60 published topic point briefs now have Learn More explainers.
- AP Calculus AB: all 85 published topic point briefs now have Learn More
  explainers. The hand-authored Unit 1 explainer set remains unchanged.
- AP Chemistry: Unit 1's 8 published topic point briefs now have Learn More
  explainers.
- AP Statistics: Unit 1's 13 published topic point briefs now have Learn More
  explainers.

AP Statistics is included once; the duplicate mention in the request is treated
as emphasis rather than a second distinct subject.

## Authoring Approach

The Learn More explainers are derived from the already-reviewed topic point brief
fields:

- `core_idea` uses the topic's `what_it_is`.
- `what_students_need_to_understand` uses `why_it_matters`.
- `how_this_becomes_points` uses `how_points_are_earned`.
- `answer_move` uses the topic-specific answer move from the point brief.
- `common_point_loss` carries through the topic-specific point-loss warning.
- `mini_example_question`, `weak_answer`, `point_attaining_answer`, and
  `practice_bridge` are subject-aware wrappers that ask the student to connect
  the topic content to a scoring move.

This keeps the pages subject-specific and point-focused without copying external
content or introducing a separate source of truth.

## Database Source Of Truth

Runtime source of truth is Supabase:

- `app.topic_point_briefs`
- `app.topic_explainers`
- `public.topic_point_briefs`
- `public.topic_explainers`
- `public.get_topic_point_guides(subject_key, unit_number, topic_code)`

Frontend should keep using the RPC where possible because it normalizes subject
keys such as `ap-statistics` to `ap_statistics` and returns briefs and explainers
together.
