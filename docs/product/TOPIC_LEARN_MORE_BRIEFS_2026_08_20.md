# Topic Learn More Briefs

STATUS: HISTORICAL PRODUCTION BASELINE

DATE: 2026-08-20

Status: production seed and migration baseline. The rows described here remain
the record of the August 20 release, but new and rewritten content is governed
by `TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md`, including its structured
v2 content-block contract and rewrite requirements.

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

This derivation method was sufficient for the initial coverage pass, but it does
not by itself satisfy the structured v2 standard. In particular, subject-aware
wrappers are not equivalent to reviewed reasoning steps, misconception
corrections, exam connections, or worked-example explanations.

## Migration To Structured Content Blocks

The August 20 explainers are v1 source material. They must be sectioned and
rewritten before being labeled `content_version = 2`.

For each row:

- rewrite `what_students_need_to_understand` as a specific
  `learning_objective`;
- retain or rewrite `core_idea` so it adds instruction beyond the topic card;
- split and rewrite `how_this_becomes_points` and `answer_move` into ordered
  `reasoning_steps` plus a distinct `exam_connection`;
- combine `common_point_loss` and relevant `weak_answer` material into one or
  more `common_mistakes`, each with a correction and improved answer move;
- review `mini_example_question`, `weak_answer`, and
  `point_attaining_answer` as one `worked_example`, adding an explicit
  `why_it_earns_points` explanation from approved source grounding;
- write concise `key_takeaways` only after the other blocks are reviewed;
- rewrite `practice_bridge` as a specific next action for the same topic;
- preserve `source_note` and add precise `source_references` where available.

This is an editorial migration, not a field-renaming exercise. Generic wrappers,
sentence-boundary splitting, and unsupported generated filler are not allowed.
When a source row lacks enough material for a required block, mark the block
missing and route it to authoring and Learning Quality review.

Use a representative MCQ/FRQ topic set as the pilot before converting the full
August 20 catalog. The pilot must produce complete, partial, missing, rewritten,
reviewed, and approved counts and must preserve an exact before-state for every
converted row.

## Immediate Presentation Use

Before the v2 migration is complete, the frontend may improve the responsive
Learn More / Deep Dive presentation, use honest fallbacks, and offer a
browser-local topic- or question-scoped scratchpad. It must not present a
one-line or wrapper-derived explanation as a complete Deep Dive, synthesize
missing content in the adapter, or imply that local notes sync across devices.

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

The current RPC is the v1 runtime contract. Supporting structured v2 content
requires a versioned database/RPC change, compatibility behavior for unmigrated
rows, and frontend rendering for both shapes during the migration window.
